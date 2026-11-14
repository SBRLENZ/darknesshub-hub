local repo = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"
local cacheBypass = "?t=" .. tostring(os.time())

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

-- Deteksi paksa berdasarkan PlaceId atau nama game/workspace khusus Animal Hospital
local placeId = game.PlaceId
local ok, info = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(placeId).Name
end)
local gName = ok and info:lower() or ""

-- Debug print ke console F9
print("DARKNES HUB DETECTED GAME:", gName, "PLACEID:", placeId)

if gName:find("rumah opa") or gName:find("opah") then
    boot("darknesopah.lua")
elseif gName:find("evade") or gName:find("menghindar") or workspace:FindFirstChild("Nextbots") then
    boot("darknesevade.lua")
elseif gName:find("animal") or gName:find("hospital") or workspace:FindFirstChild("Patient") or workspace:FindFirstChild("Patients") or workspace:FindFirstChild("PatientSpawn") then
    boot("darknesanimalhospital.lua")
elseif gName:find("brookhaven") or gName:find("brook") then
    boot("darknesbrookhaven.lua")
else
    -- Fallback default jika tidak terdeteksi
    boot("darknesanimalhospital.lua")
end
