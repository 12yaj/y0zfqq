--[[
    y0zfqq — PC + telefon birleşik loader
    ========================================
    PC executor workspace ornegi:
        selams/b.lua
        selams/Libary.lua
        selams/aa.lua

    Calistir (klasor adin selams ise):
        loadstring(readfile("selams/b.lua"))()

    Dosyalar workspace kokundeyse:
        loadstring(readfile("b.lua"))()

    YAPMA: readfile("selams") — bu KLASOR, "Expected File But Got Directory" verir.

    GUI gelmiyorsa: F9 konsolda [y0zfqq] hata satırına bak.
    Alternatif hub: opensource_egg.txt (BobloUI — PlayerGui)
]]

if typeof(getgenv) ~= "function" then
    getgenv = function() return _G end
end

local g = getgenv()
local Players = game:GetService("Players")

local function showBootstrapError(msg)
    warn("[y0zfqq] " .. tostring(msg))
    pcall(function()
        local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
        local pg = lp:WaitForChild("PlayerGui", 15)
        local old = pg:FindFirstChild("y0zfqqBootstrapError")
        if old then old:Destroy() end
        local sg = Instance.new("ScreenGui")
        sg.Name = "y0zfqqBootstrapError"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 100000
        sg.Parent = pg
        local f = Instance.new("TextLabel")
        f.Size = UDim2.new(0.85, 0, 0, 120)
        f.Position = UDim2.new(0.075, 0, 0, 40)
        f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        f.TextColor3 = Color3.fromRGB(255, 120, 120)
        f.TextWrapped = true
        f.TextSize = 16
        f.Font = Enum.Font.GothamBold
        f.Text = "[y0zfqq]\n" .. tostring(msg)
        f.Parent = sg
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    end)
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = lp:WaitForChild("PlayerGui", 20)
if not playerGui then
    showBootstrapError("PlayerGui yok — oyuna tam giris yap.")
    return
end

pcall(function()
    local prev = _G.y0zfqqStealAnEgg or _G.OxideStealAnEgg
    if prev and type(prev.Unload) == "function" then
        prev.Unload()
    end
end)

local FILE_CANDIDATES = {
    lib = {
        "Libary.lua", "Library.lua",
        "selams/Libary.lua", "selams/Library.lua",
        "./Libary.lua", "./selams/Libary.lua",
    },
    hub = {
        "aa.lua", "selams/aa.lua",
        "./aa.lua", "./selams/aa.lua",
    },
}

local function pathIsFolder(path)
    if typeof(isfolder) == "function" then
        local ok, yes = pcall(isfolder, path)
        if ok and yes then return true end
    end
    return false
end

local function pathIsFile(path)
    if typeof(isfile) == "function" then
        local ok, yes = pcall(isfile, path)
        if ok then return yes end
    end
    return true
end

local function readOneFile(path)
    if pathIsFolder(path) then
        return nil, ("'%s' klasor — dosya degil.\nOrnek: selams/b.lua veya selams/Libary.lua"):format(path)
    end
    if not pathIsFile(path) then
        return nil, nil
    end
    local ok, src = pcall(readfile, path)
    if not ok then
        local err = tostring(src)
        if err:lower():find("directory") then
            return nil, ("readfile('%s'): klasor secildi. Tam dosya yolu yaz."):format(path)
        end
        return nil, err
    end
    if type(src) == "string" and #src > 100 then
        return src, path
    end
    return nil, nil
end

local function readScript(candidates)
    if not readfile then
        return nil, "readfile yok — executor workspace + selams/b.lua kullan."
    end
    local lastErr
    for _, path in ipairs(candidates) do
        local src, err = readOneFile(path)
        if src then return src, path end
        if err then lastErr = err end
    end
    if lastErr then
        return nil, lastErr
    end
    return nil, "Hicbir dosya okunamadi. Workspace'e selams/ klasoru koy:\n"
        .. table.concat(candidates, "\n")
end

local function loadChunk(src, label)
    local fn, err = loadstring(src, label)
    if not fn then
        return nil, "Derleme: " .. tostring(err)
    end
    return fn
end

local bootApplied = false
local bootSrc, _ = readScript({ "y0zfqq_bootstrap.lua", "selams/y0zfqq_bootstrap.lua" })
if bootSrc then
    local bootFn = loadChunk(bootSrc, "y0zfqq_bootstrap.lua")
    if bootFn then
        local okB, applyEnv = pcall(bootFn)
        if okB and type(applyEnv) == "function" then
            applyEnv(g, playerGui)
            bootApplied = true
        end
    end
end
if not bootApplied then
    g.OxideForcePC = (g.OxideForcePC ~= false)
    g.OxideUsePlayerGui = true
    g.OxidePhoneParity = (g.OxidePhoneParity ~= false)
    g.OxideSkipACNeutralizer = (g.OxideSkipACNeutralizer ~= false)
    g.OxideEnableBacSpoof = (g.OxideEnableBacSpoof == true)
    g.y0zfqqEnableBacSpoof = (g.y0zfqqEnableBacSpoof == true)
    g.OxideDisableTags = (g.OxideDisableTags ~= false)
    g.OxideDefaultStealMethod = g.OxideDefaultStealMethod or "Tween Glide"
    g.OxideKickSafe = (g.OxideKickSafe ~= false)
    g.OxideCreateWindowOpts = {
        Mobile = false, Parent = playerGui, LoadingAnimation = true,
        LoadingDuration = 0.9, DisplayOrder = 100, SkipTagSystem = true,
    }
end

local useLazyIdle = (g.y0zfqqLazyInject ~= false and g.OxideLazyInject ~= false)
if useLazyIdle then
    local idleSrc, idlePath = readScript({ "aa_idle.lua", "selams/aa_idle.lua" })
    if idleSrc then
        g.y0zfqqRawBase = g.y0zfqqRawBase or g.OxideGitHubRaw
        local runIdle, idleErr = loadChunk(idleSrc, idlePath or "aa_idle.lua")
        if not runIdle then
            showBootstrapError(idleErr)
            return
        end
        local okI, runErr = pcall(runIdle)
        if not okI then
            showBootstrapError("aa_idle: " .. tostring(runErr))
            return
        end
        print("[y0zfqq] OK — idle inject. Sag Ctrl ile tam hub.")
        return
    end
end

local libSrc, libPath = readScript(FILE_CANDIDATES.lib)
if not libSrc then
    showBootstrapError(libPath)
    return
end

local runLib, libCompileErr = loadChunk(libSrc, libPath)
if not runLib then
    showBootstrapError(libCompileErr)
    return
end

local libOk, lib = pcall(runLib)
if not libOk or type(lib) ~= "table" or type(lib.CreateWindow) ~= "function" then
    showBootstrapError("Libary.lua gecersiz: " .. tostring(lib))
    return
end
_G.OxideLib = lib
_G.y0zfqqLib = lib

local hubSrc, hubPath = readScript(FILE_CANDIDATES.hub)
if not hubSrc then
    showBootstrapError(hubPath)
    return
end

if not hubSrc:find("OxideStealAnEgg", 1, true) then
    warn("[y0zfqq] aa.lua hub imzasi bulunamadi — yine de deneniyor.")
end

hubSrc = "local Library = _G.y0zfqqLib or _G.OxideLib\n" .. hubSrc
local runHub, hubCompileErr = loadChunk(hubSrc, hubPath or "aa.lua")
if not runHub then
    showBootstrapError(hubCompileErr)
    return
end

local hubOk, hubErr = pcall(runHub)
if not hubOk then
    showBootstrapError("aa.lua calismadi:\n" .. tostring(hubErr))
    return
end

if g.OxideLoadSimpleFarm == true then
    local farmSrc, farmPath = readScript({ "a.lua", "selams/a.lua" })
    if farmSrc then
        local runFarm = loadChunk(farmSrc, farmPath or "a.lua")
        if runFarm then pcall(runFarm) end
    end
end

print("[y0zfqq] OK — GUI PlayerGui'de. Sag Ctrl ile ac/kapa.")
