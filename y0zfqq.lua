--[[
  y0zfqq — GitHub Raw tek giris
  loadstring(game:HttpGet("https://raw.githubusercontent.com/12yaj/y0zfqq/main/y0zfqq.lua"))()

  Not: y0zfqq.lua ile github_loader.lua ayni mantik; repo'da ikisi de olmali.
  y0zfqq.lua sadece github_loader'i cagirir (guncelleme tek yerden).
]]
if typeof(getgenv) ~= "function" then getgenv = function() return _G end end
local url = (getgenv().y0zfqqRawLoader or getgenv().OxideGitHubRaw or "https://raw.githubusercontent.com/12yaj/y0zfqq/main/")
if not url:match("/$") then url = url .. "/" end
url = url .. "github_loader.lua?v=14&t=" .. tostring(os.time())
print("[y0zfqq] loader", url)
local ok, err = pcall(function()
    loadstring(game:HttpGet(url, true))()
end)
if not ok then
    warn("[y0zfqq] Loader indirilemedi: " .. tostring(err) .. "\nURL: " .. url)
end
