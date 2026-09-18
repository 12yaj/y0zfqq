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
    local url = RAW_BASE .. fileName
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

local libSrc, libErr = fetchScript("Libary.lua")
if not libSrc then
    libSrc, libErr = fetchScript("Library.lua")
end
if not libSrc then
    bootErr(
        "Libary.lua indirilemedi.\n"
        .. tostring(libErr)
        .. "\n\nRepo public mi? Yol dogru mu?\nOrnek:\n"
        .. RAW_BASE .. "Libary.lua"
    )
    return
end

local hubSrc, hubErr = fetchScript("aa.lua")
if not hubSrc then
    bootErr("aa.lua indirilemedi.\n" .. tostring(hubErr))
    return
end

g.OxideForcePC = (g.OxideForcePC ~= false)
g.OxideUsePlayerGui = true
g.OxideKickSafe = (g.OxideKickSafe ~= false)
g.OxidePhoneParity = (g.OxidePhoneParity ~= false)
g.OxideSkipACNeutralizer = (g.OxideSkipACNeutralizer ~= false)
g.OxideDisableTags = (g.OxideDisableTags ~= false)
g.OxideDefaultStealMethod = g.OxideDefaultStealMethod or "Tween Glide"
g.OxideCreateWindowOpts = g.OxideCreateWindowOpts or {
    Mobile = false,
    Parent = pg,
    LoadingAnimation = true,
    LoadingDuration = 0.9,
    DisplayOrder = 100,
    SkipTagSystem = true,
}
g.OxideCreateWindowOpts.Parent = g.OxideCreateWindowOpts.Parent or pg
g.OxideCreateWindowOpts.SkipTagSystem = true

local runLib, compileLib = loadstring(libSrc, "Libary.lua@HTTP")
if not runLib then bootErr("Libary derleme: " .. tostring(compileLib)); return end
local okL, lib = pcall(runLib)
if not okL or type(lib) ~= "table" or type(lib.CreateWindow) ~= "function" then
    bootErr("Libary calismadi: " .. tostring(lib)); return
end
_G.OxideLib = lib
_G.y0zfqqLib = lib

local hubCode = "local Library = _G.OxideLib\n" .. hubSrc
local runHub, compileHub = loadstring(hubCode, "aa.lua@HTTP")
if not runHub then bootErr("aa derleme: " .. tostring(compileHub)); return end
local okH, runErr = pcall(runHub)
if not okH then bootErr("aa calismadi:\n" .. tostring(runErr)); return end

print("[y0zfqq HTTP] Yuklendi. Menu: Sag Ctrl / PlayerGui")
