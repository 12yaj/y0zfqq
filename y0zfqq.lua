--[[
  y0zfqq giris — build 25
  loadstring(game:HttpGet("https://raw.githubusercontent.com/12yaj/y0zfqq/main/y0zfqq.lua?" .. os.time()))()
]]

if typeof(getgenv) ~= "function" then getgenv = function() return _G end end
local g = getgenv()
local Players = game:GetService("Players")

local GITHUB_USER   = g.OxideGitHubUser   or "12yaj"
local GITHUB_REPO   = g.OxideGitHubRepo   or "y0zfqq"
local GITHUB_BRANCH = g.OxideGitHubBranch or "main"
local GITHUB_FOLDER = g.OxideGitHubFolder or ""
local CACHE_VER     = "25"

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

local function log(...)
    if g.y0zfqqQuiet == true then return end
    print(...)
end

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
    local tried = {}
    local function tryBody(body)
        if type(body) == "string" and #body > 50 then return body end
        return nil
    end
    if game.HttpGet then
        local ok, body = pcall(function() return game:HttpGet(url, true) end)
        if ok then
            local got = tryBody(body)
            if got then return got end
        end
        table.insert(tried, "HttpGet")
    end
    local req = (http_request or request or (http and http.request) or (syn and syn.request))
    if req then
        local ok, res = pcall(req, { Url = url, Method = "GET" })
        if ok and type(res) == "table" then
            local got = tryBody(res.Body or res.body)
            if got then return got end
        end
        table.insert(tried, "request")
    end
    error("HTTP basarisiz (" .. table.concat(tried, ",") .. ")")
end

local function fetchScript(fileName)
    local url = RAW_BASE .. fileName .. "?v=" .. CACHE_VER .. "&t=" .. tostring(os.time())
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

local function applyFlags(playerGui)
    g.y0zfqqRawBase = RAW_BASE
    g.y0zfqqHttpBoot = true
    g.y0zfqqMinimalUi = false
    g.OxideMinimalUi = false
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
    g.y0zfqqOpenMenuNow = false
    g.y0zfqqMenuGraceAfterLoad = tonumber(g.y0zfqqMenuGraceAfterLoad) or 0
    g.OxideForcePC = (g.OxideForcePC ~= false)
    g.OxideUsePlayerGui = true
    g.OxideKickSafe = (g.OxideKickSafe ~= false)
    g.OxidePhoneParity = (g.OxidePhoneParity ~= false)
    g.OxideDisableTags = true
    g.y0zfqqStealthGui = (g.y0zfqqStealthGui == true)
    g.OxideDefaultStealMethod = g.OxideDefaultStealMethod or "Tween Glide"
    g.OxideAutoLoadConfig = false
    g.y0zfqqAutoLoadConfig = false
    g.OxideCreateWindowOpts = {
        Mobile = false,
        Parent = playerGui,
        LoadingAnimation = true,
        LoadingDuration = 1.15,
        DisplayOrder = 100,
        SkipTagSystem = true,
        AutoLoad = false,
        ConfigName = "y0zfqq_steal",
        GuiName = "SettingsUI",
        Name = "y0zfqq | Steal an Egg",
    }
end

if not game:IsLoaded() then game.Loaded:Wait() end
local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
local pg = lp:WaitForChild("PlayerGui", 20)
if not pg then bootErr("PlayerGui yok."); return end
if not lp.Character then lp.CharacterAdded:Wait() end

pcall(function()
    local prev = _G.y0zfqqStealAnEgg or _G.OxideStealAnEgg
    if typeof(getgenv) == "function" then
        prev = prev or getgenv().__y0zfqqHub
    end
    if prev and type(prev.Unload) == "function" then prev.Unload() end
end)

applyFlags(pg)

log("[y0zfqq] HTTP boot 25 — F9'da hub25 gormelisin (hub22 = eski GitHub)")

local libSrc, libErr = fetchScript("Libary.lua")
if not libSrc then
    libSrc, libErr = fetchScript("Library.lua")
end
if not libSrc then
    bootErr("Libary.lua: " .. tostring(libErr))
    return
end

local hubSrc, hubErr = fetchScript("aa.lua")
if not hubSrc then
    bootErr("aa.lua: " .. tostring(hubErr))
    return
end

local hubBuild = tonumber(hubSrc:match("build%s*=%s*(%d+)"))
log("[y0zfqq] aa build", tostring(hubBuild), "| Libary", #libSrc, "byte")
if not hubBuild or hubBuild < 25 then
    bootErr(
        "GitHub aa.lua eski (build " .. tostring(hubBuild) .. "). Beklenen 25+.\n"
        .. "Desktop/selams icindeki aa.lua + y0zfqq.lua + github_loader.lua GitHub'a REPLACE et."
    )
    return
end
if not hubSrc:find("local function findHRP", 1, true) then
    bootErr("aa.lua bozuk/eski: findHRP yok. GitHub REPLACE et (build 25).")
    return
end

local combined = table.concat({
    "local Library = (function()\n",
    libSrc,
    "\nend)()\n",
    "if type(Library) ~= \"table\" or type(Library.CreateWindow) ~= \"function\" then\n",
    "  error(\"[y0zfqq] Library donmedi\")\n",
    "end\n",
    hubSrc,
})

local runHub, errH = loadstring(combined, "y0zfqq@hub25")
if not runHub then
    bootErr("hub derleme: " .. tostring(errH))
    return
end

local okH, runErr = pcall(runHub)
if not okH then
    bootErr("hub calismadi:\n" .. tostring(runErr))
    return
end
