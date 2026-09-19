--[[
  y0zfqq — GitHub Raw (HTTP) loader — SON SECENEK
  ================================================

  1) Libary.lua + aa.lua dosyalarini GitHub repo'na yukle (ornek: selams/ klasoru)
  2) Asagidaki USER, REPO, BRANCH degerlerini duzenle VEYA getgenv ile ver:

     getgenv().OxideGitHubRaw = "https://raw.githubusercontent.com/KULLANICI/REPO/main/selams/"

  3) Executor'da SADECE su satiri calistir (tek dosya yeter):

     loadstring(game:HttpGet("https://raw.githubusercontent.com/KULLANICI/REPO/main/selams/github_loader.lua"))()

  Ya da github_loader.lua'nin TAMAMINI yapistir — HttpGet ile kendini cekmesine gerek yok.

  NOT: Private repo raw linkleri token ister; public repo kullan.
]]

if typeof(getgenv) ~= "function" then getgenv = function() return _G end end
local g = getgenv()
local Players = game:GetService("Players")

-- Repo: https://github.com/12yaj/y0zfqq  (dosyalar repo KOKUNDE olmali)
local GITHUB_USER   = g.OxideGitHubUser   or "12yaj"
local GITHUB_REPO   = g.OxideGitHubRepo   or "y0zfqq"
local GITHUB_BRANCH = g.OxideGitHubBranch or "main"
local GITHUB_FOLDER = g.OxideGitHubFolder or "" -- "" = kok; veya "selams"

local function buildRawBase()
    if type(g.OxideGitHubRaw) == "string" and #g.OxideGitHubRaw > 10 then
        local base = g.OxideGitHubRaw
        if not base:match("/$") then base = base .. "/" end
        return base
    end
    local base = ("https://raw.githubusercontent.com/%s/%s/%s/"):format(
        GITHUB_USER, GITHUB_REPO, GITHUB_BRANCH
    )
    if type(GITHUB_FOLDER) == "string" and GITHUB_FOLDER ~= "" then
        base = base .. GITHUB_FOLDER:gsub("^/", ""):gsub("/$", "") .. "/"
    end
    return base
end

local RAW_BASE = buildRawBase()

local function bootErr(msg)
    warn("[y0zfqq HTTP] " .. tostring(msg))
    pcall(function()
        local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
        local pg = lp:WaitForChild("PlayerGui", 12)
        local sg = Instance.new("ScreenGui")
        sg.Name = "y0zfqqBootstrapError"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 100000
        sg.Parent = pg
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(0.88, 0, 0, 160)
        t.Position = UDim2.new(0.06, 0, 0, 28)
        t.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        t.TextColor3 = Color3.fromRGB(255, 110, 110)
        t.TextWrapped = true
        t.TextSize = 14
        t.Font = Enum.Font.GothamBold
        t.Text = "[y0zfqq HTTP]\n" .. tostring(msg)
        t.Parent = sg
        Instance.new("UICorner", t).CornerRadius = UDim.new(0, 8)
    end)
end

local function httpGet(url)
    local fn = syn and syn.request or http and http.request or request
    if fn then
        local res = fn({ Url = url, Method = "GET" })
        local body = res and (res.Body or res.body)
        if type(body) == "string" and #body > 50 then return body end
        error("HTTP bos veya hata: " .. tostring(res and res.StatusCode or res and res.status))
    end
    if game.HttpGet then
        return game:HttpGet(url, true)
    end
    error("HttpGet / request yok — executor ag desteklemiyor")
end

local function fetchScript(fileName)
    local url = RAW_BASE .. fileName .. "?v=17&t=" .. tostring(os.time())
    local ok, body = pcall(httpGet, url)
    if not ok then
        return nil, ("Indirilemedi: %s\n%s"):format(url, tostring(body))
    end
    if type(body) ~= "string" or #body < 200 then
        return nil, ("Cok kisa / 404 olabilir: %s"):format(url)
    end
    if body:sub(1, 1) == "<" or body:lower():find("<!doctype", 1, true) then
        return nil, ("HTML dondu (yanlis URL?): %s"):format(url)
    end
    return body, url
end

if not game:IsLoaded() then game.Loaded:Wait() end
local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
local pg = lp:WaitForChild("PlayerGui", 20)
if not pg then bootErr("Oyuna gir — PlayerGui yok."); return end

pcall(function()
    local p = _G.y0zfqqStealAnEgg or _G.OxideStealAnEgg
    if p and type(p.Unload) == "function" then p.Unload() end
end)

print("[y0zfqq HTTP] Raw base: " .. RAW_BASE)

g.y0zfqqRawBase = RAW_BASE

local hubSrc, hubErr = fetchScript("aa.lua")
if not hubSrc then
    bootErr("aa.lua indirilemedi.\n" .. tostring(hubErr))
    return
end
local hubBuild = tonumber(hubSrc:match("build%s*=%s*(%d+)"))
print("[y0zfqq HTTP] aa.lua GitHub build:", tostring(hubBuild))
if not hubBuild or hubBuild < 17 then
    bootErr(
        "GitHub'daki aa.lua ESKI (build " .. tostring(hubBuild) .. ").\n"
        .. "Beklenen: build 17+\n\n"
        .. "https://github.com/12yaj/y0zfqq  uzerinden aa_idle.lua, aa.lua, Libary.lua, github_loader.lua, y0zfqq.lua, y0zfqq_bootstrap.lua REPLACE et.\n"
        .. "Sonra cache kirarak tekrar dene:\n"
        .. "loadstring(game:HttpGet('https://raw.githubusercontent.com/12yaj/y0zfqq/main/y0zfqq.lua?'..os.time()))()"
    )
    return
end

local idleSrc, idleErr = fetchScript("aa_idle.lua")
if not idleSrc then
    bootErr("aa_idle.lua indirilemedi.\n" .. tostring(idleErr))
    return
end

local bootSrc = fetchScript("y0zfqq_bootstrap.lua")
local bootFn = bootSrc and loadstring(bootSrc, "y0zfqq_bootstrap.lua")
if bootFn then
    local okBoot, applyEnv = pcall(bootFn)
    if okBoot and type(applyEnv) == "function" then
        applyEnv(g, pg)
    end
else
    g.OxideForcePC = (g.OxideForcePC ~= false)
    g.y0zfqqDeferLoad = (g.y0zfqqDeferLoad ~= false)
    g.y0zfqqJoinGraceSec = g.y0zfqqJoinGraceSec or 15
    g.OxideUsePlayerGui = true
    g.OxideKickSafe = (g.OxideKickSafe ~= false)
    g.OxidePhoneParity = (g.OxidePhoneParity ~= false)
    g.OxideSkipACNeutralizer = (g.OxideSkipACNeutralizer ~= false)
    g.OxideEnableBacSpoof = (g.OxideEnableBacSpoof == true)
    g.y0zfqqEnableBacSpoof = (g.y0zfqqEnableBacSpoof == true)
    g.OxideDisableTags = (g.OxideDisableTags ~= false)
    g.OxideDefaultStealMethod = g.OxideDefaultStealMethod or "Tween Glide"
    g.OxideCreateWindowOpts = {
        Mobile = false, Parent = pg, LoadingAnimation = true,
        LoadingDuration = 0.9, DisplayOrder = 100, SkipTagSystem = true,
    }
end
if not g.OxideCreateWindowOpts then
    g.OxideCreateWindowOpts = {
        Mobile = false, Parent = pg, LoadingAnimation = true,
        LoadingDuration = 0.9, DisplayOrder = 100, SkipTagSystem = true,
    }
end

local runIdle, compileIdle = loadstring(idleSrc, "aa_idle.lua@HTTP")
if not runIdle then bootErr("aa_idle derleme: " .. tostring(compileIdle)); return end
local okI, runErr = pcall(runIdle)
if not okI then bootErr("aa_idle calismadi:\n" .. tostring(runErr)); return end

print("[y0zfqq HTTP] OK — menu otomatik yuklenecek (Jane modu). F9: lib+hub indirme loglari")
