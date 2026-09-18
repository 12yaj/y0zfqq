--[[
  â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  y0zfqq â€” BU DOSYANIN TAMAMINI EXECUTOR'A YAPIÅTIR (Execute)
  Komut satÄ±rÄ±na readfile("selams") YAZMA â€” klasÃ¶r hatasÄ± verir.
  â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
]]

if typeof(getgenv) ~= "function" then getgenv = function() return _G end end
local g = getgenv()
local Players = game:GetService("Players")

local function bootErr(msg)
    warn("[y0zfqq] " .. msg)
    pcall(function()
        local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
        local pg = lp:WaitForChild("PlayerGui", 12)
        local sg = Instance.new("ScreenGui")
        sg.Name = "y0zfqqBootstrapError"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 100000
        sg.Parent = pg
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(0.9, 0, 0, 140)
        t.Position = UDim2.new(0.05, 0, 0, 30)
        t.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        t.TextColor3 = Color3.fromRGB(255, 100, 100)
        t.TextWrapped = true
        t.TextSize = 15
        t.Font = Enum.Font.GothamBold
        t.Text = "[y0zfqq]\n" .. msg
        t.Parent = sg
        Instance.new("UICorner", t).CornerRadius = UDim.new(0, 8)
    end)
end

if not readfile then
    bootErr("Executor'da readfile yok.\nDosyalari workspace'e ekle veya baska executor dene.")
    return
end

local function isDir(path)
    if typeof(isfolder) ~= "function" then return false end
    local ok, yes = pcall(isfolder, path)
    return ok and yes == true
end

local function isFile(path)
    if typeof(isfile) ~= "function" then return not isDir(path) end
    local ok, yes = pcall(isfile, path)
    return ok and yes == true
end

local function tryRead(path)
    if not path or path == "" then return nil end
    if isDir(path) then
        return nil, "KLASOR: " .. path .. "  â†’  ornek: " .. path .. "/b.lua"
    end
    if not isFile(path) then return nil end
    local ok, body = pcall(readfile, path)
    if not ok then
        local e = tostring(body)
        if e:lower():find("directory") then
            return nil, "readfile klasor okudu: " .. path
        end
        return nil, e
    end
    if type(body) == "string" and #body > 200 then
        return body, path
    end
    return nil
end

local function listDirHint(dir)
    if typeof(listfiles) ~= "function" then return "" end
    local ok, files = pcall(listfiles, dir)
    if not ok or type(files) ~= "table" or #files == 0 then return "" end
    local lines = {}
    for i = 1, math.min(#files, 12) do
        lines[#lines + 1] = "  â€¢ " .. tostring(files[i])
    end
    return "\nlistfiles('" .. dir .. "'):\n" .. table.concat(lines, "\n")
end

local LIB_NAMES = { "Libary.lua", "Library.lua" }
local HUB_NAMES = { "aa.lua" }

local ROOTS = { "", "selams", "selams/", "./selams", "scripts", "autoexec" }

local function discover(nameList)
    local tried, lastDirErr = {}, nil
    for _, root in ipairs(ROOTS) do
        local prefix = root
        if prefix ~= "" and not prefix:match("/$") then prefix = prefix .. "/" end
        for _, fname in ipairs(nameList) do
            local path = prefix .. fname
            tried[#tried + 1] = path
            local body, err = tryRead(path)
            if body then return body, path, nil, tried end
            if err and err:find("KLASOR") then lastDirErr = err end
        end
    end
    if typeof(listfiles) == "function" then
        for _, root in ipairs(ROOTS) do
            local ok, files = pcall(listfiles, root)
            if ok and type(files) == "table" then
                for _, full in ipairs(files) do
                    local low = string.lower(tostring(full))
                    for _, fname in ipairs(nameList) do
                        local escaped = fname:gsub("(%W)", "%%%1")
                        if low:match(escaped:lower() .. "$") then
                            tried[#tried + 1] = tostring(full)
                            local body, err = tryRead(full)
                            if body then return body, full, nil, tried end
                            if err and err:find("KLASOR") then lastDirErr = err end
                        end
                    end
                end
            end
        end
    end
    return nil, nil, lastDirErr or "Dosya bulunamadi", tried
end

if not game:IsLoaded() then game.Loaded:Wait() end
local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
local pg = lp:WaitForChild("PlayerGui", 20)
if not pg then bootErr("Oyuna gir â€” PlayerGui yok."); return end

pcall(function()
    local p = _G.y0zfqqStealAnEgg or _G.OxideStealAnEgg
    if p and type(p.Unload) == "function" then p.Unload() end
end)

local libSrc, libPath, libErr, libTried = discover(LIB_NAMES)
if not libSrc then
    bootErr(
        "Libary.lua bulunamadi.\n"
        .. (libErr or "")
        .. "\n\nWorkspace'e selams klasoru ac, icine Libary.lua + aa.lua koy."
        .. listDirHint("")
        .. listDirHint("selams")
        .. "\n\nDenenen yollar:\n  " .. table.concat(libTried or {}, "\n  ")
    )
    return
end

local hubSrc, hubPath, hubErr, hubTried = discover(HUB_NAMES)
if not hubSrc then
    bootErr(
        "aa.lua bulunamadi.\n"
        .. (hubErr or "")
        .. listDirHint("selams")
        .. "\n\nDenenen:\n  " .. table.concat(hubTried or {}, "\n  ")
    )
    return
end

g.OxideForcePC = true
g.OxideUsePlayerGui = true
g.OxidePhoneParity = (g.OxidePhoneParity ~= false)
g.OxideSkipACNeutralizer = (g.OxideSkipACNeutralizer ~= false)
g.OxideEnableBacSpoof = (g.OxideEnableBacSpoof == true)
g.y0zfqqEnableBacSpoof = (g.y0zfqqEnableBacSpoof == true)
g.OxideDisableTags = (g.OxideDisableTags ~= false)
g.OxideKickSafe = (g.OxideKickSafe ~= false)
g.OxideDefaultStealMethod = g.OxideDefaultStealMethod or "Tween Glide"
g.OxideCreateWindowOpts = {
    Mobile = false,
    Parent = pg,
    LoadingAnimation = true,
    LoadingDuration = 0.9,
    DisplayOrder = 100,
    SkipTagSystem = true,
}

local runLib, errLib = loadstring(libSrc, libPath)
if not runLib then bootErr("Libary derleme: " .. tostring(errLib)); return end
local okL, lib = pcall(runLib)
if not okL or type(lib) ~= "table" or type(lib.CreateWindow) ~= "function" then
    bootErr("Libary calismadi: " .. tostring(lib))
    return
end
_G.OxideLib = lib
_G.y0zfqqLib = lib

local hubCode = "local Library = _G.y0zfqqLib or _G.OxideLib\n" .. hubSrc
local runHub, errHub = loadstring(hubCode, hubPath)
if not runHub then bootErr("aa derleme: " .. tostring(errHub)); return end
local okH, errRun = pcall(runHub)
if not okH then bootErr("aa calismadi:\n" .. tostring(errRun)); return end

print("[y0zfqq] Yuklendi â€” " .. libPath .. " + " .. hubPath)
print("[y0zfqq] Menu: Sag Ctrl")

