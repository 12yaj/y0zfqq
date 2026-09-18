--[[ y0zfqq idle inject — Libary + aa.lua yuklenmez; BAC idle kick (4512) azaltir ]]
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()

local IDLE_BUILD = 13

local function env()
    if typeof(getgenv) == "function" then return getgenv() end
    return _G
end

local HUB = { conns = {}, dead = false, build = IDLE_BUILD, idle = true }
local function track(c)
    table.insert(HUB.conns, c)
    return c
end

do
    local g = env()
    if g.y0zfqqHideGlobals ~= false and g.OxideHideGlobals ~= false then
        g.__y0zfqqHub = HUB
    else
        _G.y0zfqqStealAnEgg = HUB
        _G.OxideStealAnEgg = HUB
    end
end

HUB.Unload = function()
    HUB.dead = true
    for _, c in ipairs(HUB.conns) do
        pcall(function() c:Disconnect() end)
    end
    HUB.conns = {}
    local g = env()
    if g.__y0zfqqHub == HUB then g.__y0zfqqHub = nil end
end

local function httpGet(url)
    local fn = syn and syn.request or http and http.request or request
    if fn then
        local res = fn({ Url = url, Method = "GET" })
        local body = res and (res.Body or res.body)
        if type(body) == "string" and #body > 50 then return body end
        error("HTTP: " .. tostring(res and res.StatusCode or res and res.status))
    end
    if game.HttpGet then
        return game:HttpGet(url, true)
    end
    error("HttpGet yok")
end

local function rawBase()
    local g = env()
    local base = g.y0zfqqRawBase or g.OxideGitHubRaw
    if type(base) ~= "string" or #base < 10 then
        base = "https://raw.githubusercontent.com/12yaj/y0zfqq/main/"
    end
    if not base:match("/$") then base = base .. "/" end
    return base
end

local loading = false
local booted = false

local function readLocal(paths)
    if typeof(readfile) ~= "function" then return nil end
    for _, path in ipairs(paths) do
        local ok, src = pcall(readfile, path)
        if ok and type(src) == "string" and #src > 200 then
            return src
        end
    end
    return nil
end

local function bootFullHub()
    if booted or loading or HUB.dead then return end
    loading = true
    local gPre = env()
    local preGrace = tonumber(gPre.y0zfqqHubLoadGraceSec) or 12
    preGrace = math.clamp(preGrace, 0, 60)
    if preGrace > 0 then
        print("[y0zfqq] Sag Ctrl: ", preGrace, "sn bekle, sonra Libary+aa (BAC-5516)")
        task.wait(preGrace)
    end
    if HUB.dead then loading = false return end

    local base = rawBase()
    local t = tostring(os.time())

    local libSrc = readLocal({ "Libary.lua", "Library.lua", "selams/Libary.lua", "selams/Library.lua" })
    if not libSrc then
        local okLib
        okLib, libSrc = pcall(httpGet, base .. "Libary.lua?v=" .. IDLE_BUILD .. "&t=" .. t)
        if not okLib or type(libSrc) ~= "string" or #libSrc < 200 then
            okLib, libSrc = pcall(httpGet, base .. "Library.lua?v=" .. IDLE_BUILD .. "&t=" .. t)
        end
    end
    if type(libSrc) ~= "string" or #libSrc < 200 then
        warn("[y0zfqq] Libary indirilemedi")
        loading = false
        return
    end

    local hubSrc = readLocal({ "aa.lua", "selams/aa.lua" })
    if not hubSrc then
        local okHub
        okHub, hubSrc = pcall(httpGet, base .. "aa.lua?v=" .. IDLE_BUILD .. "&t=" .. t)
        if not okHub or type(hubSrc) ~= "string" or #hubSrc < 500 then
            warn("[y0zfqq] aa.lua indirilemedi")
            loading = false
            return
        end
    end

    local hubBuild = tonumber(hubSrc:match("build%s*=%s*(%d+)"))
    if not hubBuild or hubBuild < 13 then
        warn("[y0zfqq] GitHub aa.lua eski (build " .. tostring(hubBuild) .. "). 13+ yukle.")
        loading = false
        return
    end

    booted = true
    HUB.Unload()

    local runLib, errL = loadstring(libSrc, "Libary.lua@idle")
    if not runLib then
        warn("[y0zfqq] Libary derleme: " .. tostring(errL))
        loading = false
        return
    end
    local okL, lib = pcall(runLib)
    if not okL or type(lib) ~= "table" or type(lib.CreateWindow) ~= "function" then
        warn("[y0zfqq] Libary calismadi: " .. tostring(lib))
        loading = false
        return
    end
    _G.y0zfqqLib = lib
    _G.OxideLib = lib

    local hubCode = "local Library = _G.y0zfqqLib or _G.OxideLib\n" .. hubSrc
    local runHub, errH = loadstring(hubCode, "aa.lua@idle")
    if not runHub then
        warn("[y0zfqq] aa derleme: " .. tostring(errH))
        loading = false
        return
    end

    local g = env()
    g.y0zfqqAllowClientEggApi = false
    g.y0zfqqRemoteOnly = (g.y0zfqqRemoteOnly ~= false)
    g.y0zfqqDisableEvidenceScrub = (g.y0zfqqDisableEvidenceScrub ~= false)
    g.y0zfqqOpenMenuNow = false
    g.y0zfqqOpenMenuAfterLoad = true
    g.y0zfqqMenuGraceAfterLoad = tonumber(g.y0zfqqMenuGraceAfterLoad) or 18

    local okH, runErr = pcall(runHub)
    loading = false
    if not okH then
        warn("[y0zfqq] aa calismadi: " .. tostring(runErr))
        booted = false
    end
end

print("[y0zfqq] idle build", IDLE_BUILD, "— inject hafif. GUI yok; 30sn bekle, Sag Ctrl")

do
    local g = env()
    if g.y0zfqqOpenMenuNow == true then
        bootFullHub()
    else
        track(UserInputService.InputBegan:Connect(function(input, gp)
            if HUB.dead or booted then return end
            if gp then return end
            if input.KeyCode == Enum.KeyCode.RightControl then
                bootFullHub()
            end
        end))
        print("[y0zfqq] kick yoksa Sag Ctrl ile menu (Libary+aa o zaman yuklenir)")
    end
end
