--[[
  y0zfqq — GitHub Raw loader (build 19+)
  Tek hub loadstring: aa.lua (minimal UI). aa_idle + Libary HTTP yolu KAPALI (BAC-1518).

  getgenv().y0zfqqUseIdleLoader = true  → eski idle + Libary yolu (riskli)
  getgenv().y0zfqqMinimalUi = false     → tam Libary (readfile b.lua kullan)
]]

if typeof(getgenv) ~= "function" then getgenv = function() return _G end end
local g = getgenv()
local Players = game:GetService("Players")

local GITHUB_USER   = g.OxideGitHubUser   or "12yaj"
local GITHUB_REPO   = g.OxideGitHubRepo   or "y0zfqq"
local GITHUB_BRANCH = g.OxideGitHubBranch or "main"
local GITHUB_FOLDER = g.OxideGitHubFolder or ""

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
    warn("[y0zfqq] " .. tostring(msg))
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
        t.Text = "[y0zfqq]\n" .. tostring(msg)
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
        error("HTTP bos: " .. tostring(res and res.StatusCode or res and res.status))
    end
    if game.HttpGet then
        return game:HttpGet(url, true)
    end
    error("HttpGet yok")
end

local function fetchScript(fileName)
    local url = RAW_BASE .. fileName .. "?v=21&t=" .. tostring(os.time())
    local ok, body = pcall(httpGet, url)
    if not ok then
        return nil, ("Indirilemedi: %s\n%s"):format(url, tostring(body))
    end
    if type(body) ~= "string" or #body < 200 then
        return nil, ("Cok kisa / 404: %s"):format(url)
    end
    if body:sub(1, 1) == "<" or body:lower():find("<!doctype", 1, true) then
        return nil, ("HTML (yanlis URL?): %s"):format(url)
    end
    return body, url
end

local HTTP_LITE_STUB = [[
-- HTTP: AC/hook kodu bytecode'dan cikarildi (BAC-105110)
local function oxideEnv()
    if typeof(getgenv) == "function" then return getgenv() end
    return _G
end
local function shouldSkipHeavyAC() return true end
local function shouldUseBacSpoof() return false end
local function allowClientEggCalls()
    local g = oxideEnv()
    return g.y0zfqqAllowClientEggApi == true or g.OxideAllowClientEggApi == true
end
local function useRemoteOnlyEggPipeline()
    local g = oxideEnv()
    if g.y0zfqqRemoteOnly == false or g.OxideRemoteOnly == false then return false end
    return true
end
local function shouldRequireGameDataModules()
    if useRemoteOnlyEggPipeline() and not allowClientEggCalls() then return false end
    local g = oxideEnv()
    if g.y0zfqqRequireGameData == true or g.OxideRequireGameData == true then return true end
    return allowClientEggCalls()
end
local function shouldRunEvidenceScrub() return false end
local function shouldStartHubRuntimeLayers() return false end
local function startHubRuntimeLayers() end
local bacHookInstalled = false
local HookFn = nil
]]

local function cutBetweenMarkers(src, startNeedle, endNeedle, insert)
    local a = src:find(startNeedle, 1, true)
    local b = src:find(endNeedle, 1, true)
    if not a or not b or b <= a then return src, false end
    local pre = src:sub(1, a - 1)
    local sep = pre:find("\n%-%- =+=%-%-\n", 1, true)
    if sep then a = sep + 1 end
    local sep2 = src:sub(1, b - 1):find("\n%-%- =+=%-%-\n", 1, true)
    if sep2 and sep2 < b then b = sep2 + 1 end
    return src:sub(1, a - 1) .. (insert or "") .. src:sub(b), true
end

local function stripHttpHubSource(src)
    local out = src
    local ok1
    out, ok1 = cutBetweenMarkers(
        out,
        "CLIENT AC NEUTRALIZER & UGI",
        "CHARACTER & MOVEMENT HELPERS",
        HTTP_LITE_STUB .. "\n\n-- ==============================================================================\n-- CHARACTER & MOVEMENT HELPERS\n-- ==============================================================================\n"
    )
    local ok2
    out, ok2 = cutBetweenMarkers(
        out,
        "BAC TELEMETRY PACKET SPOOFER",
        "GAME NETWORKING & MODULE INTEGRATION",
        "\n-- ==============================================================================\n-- GAME NETWORKING & MODULE INTEGRATION\n-- ==============================================================================\n"
    )
    if g.y0zfqqQuiet ~= true and (ok1 or ok2) then
        print("[y0zfqq] HTTP lite strip OK (hook/GC imzasi yok)")
    end
    return out
end

local function applySecureHubFlags()
    g.y0zfqqAllowClientEggApi = false
    g.OxideAllowClientEggApi = false
    g.y0zfqqRemoteOnly = true
    g.OxideRemoteOnly = true
    g.y0zfqqDisableEvidenceScrub = true
    g.OxideDisableEvidenceScrub = true
    g.OxideSkipACNeutralizer = true
    g.y0zfqqDisableBacSpoof = true
    g.OxideDisableBacSpoof = true
    g.y0zfqqEnableBacSpoof = false
    g.OxideEnableBacSpoof = false
    g.y0zfqqEnableHubLayers = false
    g.OxideEnableHubLayers = false
    g.y0zfqqAllowEggRemotes = false
    g.y0zfqqOpenMenuAfterLoad = true
    g.y0zfqqMenuGraceAfterLoad = tonumber(g.y0zfqqMenuGraceAfterLoad) or 0
end

local function runHubAa(hubSrc)
    applySecureHubFlags()
    if g.y0zfqqMinimalUi ~= false then
        hubSrc = stripHttpHubSource(hubSrc)
    end
    local prefix = "-- y0zfqq HTTP minimal\n"
    local runHub, errH = loadstring(prefix .. hubSrc, "aa.lua@HTTP")
    if not runHub then
        bootErr("aa derleme: " .. tostring(errH))
        return false
    end
    local okH, runErr = pcall(runHub)
    if not okH then
        bootErr("aa calismadi:\n" .. tostring(runErr))
        return false
    end
    return true
end

local function bootMinimalHttp(hubSrc)
    g.y0zfqqRawBase = RAW_BASE

    local dwell = tonumber(g.y0zfqqJoinDwellSec)
    if dwell == nil then dwell = 22 end
    dwell = math.clamp(dwell, 0, 120)
    if dwell > 0 then
        if g.y0zfqqQuiet ~= true then
            print("[y0zfqq] sunucu nefesi", dwell, "sn (coklu loadstring onleme)...")
        end
        local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
        if not lp.Character then lp.CharacterAdded:Wait() end
        task.wait(dwell)
    end

    return runHubAa(hubSrc)
end

local function bootIdleLegacy(hubSrc)
    local idleSrc, idleErr = fetchScript("aa_idle.lua")
    if not idleSrc then
        bootErr("aa_idle: " .. tostring(idleErr))
        return false
    end
    local runIdle, compileIdle = loadstring(idleSrc, "aa_idle.lua@HTTP")
    if not runIdle then
        bootErr("aa_idle derleme: " .. tostring(compileIdle))
        return false
    end
    local okI, runErr = pcall(runIdle)
    if not okI then
        bootErr("aa_idle: " .. tostring(runErr))
        return false
    end
    return true
end

if not game:IsLoaded() then game.Loaded:Wait() end
local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
local pg = lp:WaitForChild("PlayerGui", 20)
if not pg then bootErr("PlayerGui yok."); return end

pcall(function()
    local p = _G.y0zfqqStealAnEgg or _G.OxideStealAnEgg
    if p and type(p.Unload) == "function" then p.Unload() end
end)

g.y0zfqqRawBase = RAW_BASE

local hubSrc, hubErr = fetchScript("aa.lua")
if not hubSrc then
    bootErr("aa.lua: " .. tostring(hubErr))
    return
end
local hubBuild = tonumber(hubSrc:match("build%s*=%s*(%d+)"))
if g.y0zfqqQuiet ~= true then
    print("[y0zfqq] aa build", tostring(hubBuild), "| minimal HTTP yolu")
end
if not hubBuild or hubBuild < 21 then
    bootErr(
        "GitHub aa.lua eski (build " .. tostring(hubBuild) .. "). Beklenen 21+.\n"
        .. "aa.lua, github_loader.lua, y0zfqq_bootstrap.lua, y0zfqq.lua REPLACE."
    )
    return
end

if g.y0zfqqUseIdleLoader ~= true then
    g.y0zfqqHttpBoot = true
    g.y0zfqqMinimalUi = (g.y0zfqqMinimalUi ~= false)
end

local bootSrc = fetchScript("y0zfqq_bootstrap.lua")
local bootFn = bootSrc and loadstring(bootSrc, "y0zfqq_bootstrap.lua")
if bootFn then
    local okBoot, applyEnv = pcall(bootFn)
    if okBoot and type(applyEnv) == "function" then
        applyEnv(g, pg)
    end
end
if not g.OxideCreateWindowOpts then
    g.OxideCreateWindowOpts = {
        Mobile = false, Parent = pg, DisplayOrder = 100,
        SkipTagSystem = true, AutoLoad = false, ConfigName = "y0zfqq_steal",
    }
end

if g.y0zfqqUseIdleLoader == true then
    g.y0zfqqMinimalUi = false
    if g.y0zfqqQuiet ~= true then
        warn("[y0zfqq] ESKI idle+Libary yolu — BAC-1518 riski")
    end
    bootIdleLegacy(hubSrc)
else
    bootMinimalHttp(hubSrc)
end
