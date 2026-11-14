local repo = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"
local cacheBypass = "?t=" .. tostring(tick())

local function boot(scriptName)
    local status, res = pcall(function()
        loadstring(game:HttpGet(repo .. scriptName .. cacheBypass))()
    end)
    if not status then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DARKNES HUB ERROR",
            Text = "Failed to compile module: " .. tostring(res),
            Duration = 6
        })
    end
end

local ok, info = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)
local gName = ok and info:lower() or ""

-- Deteksi router utama dengan dukungan nama map Indo & Inggris
if gName:find("rumah opa") or gName:find("opah") then
    boot("darknesopah.lua")
elseif gName:find("evade") or gName:find("menghindar") or workspace:FindFirstChild("Nextbots") then
    boot("darknesevade.lua")
elseif gName:find("animal") or gName:find("hospital") or gName:find("hewan") or gName:find("rumah sakit") or workspace:FindFirstChild("Pasien") or workspace:FindFirstChild("Patient") or workspace:FindFirstChild("Patients") then
    boot("darknesanimalhospital.lua")
elseif gName:find("brookhaven") or gName:find("brook") then
    boot("darknesbrookhaven.lua")
else
    boot("darknesanimalhospital.lua")
end
