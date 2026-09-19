--[[ y0zfqq idle inject — ikinci loadstring sadece menu tusunda (BAC-3511: Sag Ctrl risk) ]]
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()

local IDLE_BUILD = 18

local function env()
    if typeof(getgenv) == "function" then return getgenv() end
    return _G
end

local function resolveMenuKey()
    local g = env()
    local k = g.y0zfqqMenuKey or g.OxideMenuKey
    if typeof(k) == "EnumItem" and k.EnumType == Enum.KeyCode then
        return k
    end
    return Enum.KeyCode.Insert
end

local function menuKeyLabel()
    local k = resolveMenuKey()
    if k == Enum.KeyCode.Insert then return "Insert" end
    if k == Enum.KeyCode.Home then return "Home" end
    if k == Enum.KeyCode.F8 then return "F8" end
    return tostring(k.Name or k)
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

local function stashLibrary(lib)
    local g = env()
    g.__y0zfqqLib = lib
    if g.y0zfqqHideGlobals == false or g.OxideHideGlobals == false then
        _G.y0zfqqLib = lib
        _G.OxideLib = lib
    else
        pcall(function()
            if _G.OxideLib then _G.OxideLib = nil end
            if _G.y0zfqqLib then _G.y0zfqqLib = nil end
        end)
    end
end

local function bootFullHub()
    if booted or loading or HUB.dead then return end
    loading = true

    local gPre = env()
    local direct = gPre.y0zfqqDirectMenu ~= false and gPre.OxideDirectMenu ~= false
    local preGrace = tonumber(gPre.y0zfqqHubLoadGraceSec)
    if preGrace == nil then preGrace = direct and 0 or 20 end
    preGrace = math.clamp(preGrace, 0, 90)
    if preGrace > 0 then
        print("[y0zfqq]", preGrace, "sn sonra Libary yukleniyor...")
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

    booted = true
    HUB.Unload()

    local runLib, errL = loadstring(libSrc, "Libary.lua@idle")
    if not runLib then
        warn("[y0zfqq] Libary derleme: " .. tostring(errL))
        loading = false
        booted = false
        return
    end
    local okL, lib = pcall(runLib)
    if not okL or type(lib) ~= "table" or type(lib.CreateWindow) ~= "function" then
        warn("[y0zfqq] Libary calismadi: " .. tostring(lib))
        loading = false
        booted = false
        return
    end
    stashLibrary(lib)

    local between = tonumber(gPre.y0zfqqHubSplitGraceSec)
    if between == nil then between = direct and 0 or 15 end
    between = math.clamp(between, 0, 60)
    if between > 0 then
        print("[y0zfqq] Libary OK —", between, "sn sonra aa.lua")
        task.wait(between)
    end

    local hubSrc = readLocal({ "aa.lua", "selams/aa.lua" })
    if not hubSrc then
        local okHub
        okHub, hubSrc = pcall(httpGet, base .. "aa.lua?v=" .. IDLE_BUILD .. "&t=" .. t)
        if not okHub or type(hubSrc) ~= "string" or #hubSrc < 500 then
            warn("[y0zfqq] aa.lua indirilemedi")
            loading = false
            booted = false
            return
        end
    end

    local hubBuild = tonumber(hubSrc:match("build%s*=%s*(%d+)"))
    if not hubBuild or hubBuild < 18 then
        warn("[y0zfqq] GitHub aa.lua eski (build " .. tostring(hubBuild) .. "). 18+ yukle.")
        loading = false
        booted = false
        return
    end

    local g = env()
    g.y0zfqqAllowClientEggApi = false
    g.y0zfqqRemoteOnly = true
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
    g.y0zfqqOpenMenuNow = false
    g.y0zfqqOpenMenuAfterLoad = true
    local menuGrace = tonumber(g.y0zfqqMenuGraceAfterLoad)
    if menuGrace == nil then menuGrace = direct and 12 or 20 end
    g.y0zfqqMenuGraceAfterLoad = menuGrace

    local hubCode = "local Library = (getgenv and getgenv().__y0zfqqLib) or _G.y0zfqqLib or _G.OxideLib\n" .. hubSrc
    local runHub, errH = loadstring(hubCode, "aa.lua@idle")
    if not runHub then
        warn("[y0zfqq] aa derleme: " .. tostring(errH))
        loading = false
        booted = false
        return
    end

    local okH, runErr = pcall(runHub)
    loading = false
    if not okH then
        warn("[y0zfqq] aa calismadi: " .. tostring(runErr))
        booted = false
    end
end

local keyName = menuKeyLabel()
print("[y0zfqq] loader build", IDLE_BUILD)

local function bindMenuTriggers()
    local menuKey = resolveMenuKey()
    track(UserInputService.InputBegan:Connect(function(input, gp)
        if HUB.dead or booted or loading then return end
        if gp then return end
        if input.KeyCode == menuKey then
            task.spawn(bootFullHub)
        end
    end))

    track(LP.Chatted:Connect(function(msg)
        if HUB.dead or booted or loading then return end
        local m = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
        if m == ".y0z" or m == ".y0zfqq" or m == "/y0z" then
            task.spawn(bootFullHub)
        end
    end))
end

local function startDirectMenuLoad()
    local g = env()
    local delay = tonumber(g.y0zfqqDirectMenuDelaySec) or 4
    delay = math.clamp(delay, 0, 45)
    print("[y0zfqq] menu otomatik yukleniyor (Jane modu) — lib+hub indiriliyor...")
    task.spawn(function()
        if delay > 0 then task.wait(delay) end
        if not HUB.dead and not booted and not loading then
            bootFullHub()
        end
    end)
end

do
    local g = env()
    local direct = g.y0zfqqDirectMenu ~= false and g.OxideDirectMenu ~= false
    if g.y0zfqqOpenMenuNow == true then
        bootFullHub()
    elseif direct then
        startDirectMenuLoad()
        bindMenuTriggers()
    else
        bindMenuTriggers()
        print("[y0zfqq] Insert / chat .y0z ile menu (Sag Ctrl kullanma). Tus:", keyName)
    end
end
