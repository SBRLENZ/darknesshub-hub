--[[ DARKNES HUB - MAIN LOADER ]]
local baseUrl = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"
local bypass = "?t=" + os.time()

local success, gameName = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

if not success or not gameName then gameName = "Unknown" end
local lowerName = gameName:lower()
local placeId = game.PlaceId

local function loadScript(file)
    local s, err = pcall(function()
        loadstring(game:HttpGet(baseUrl .. file .. "?t=" .. os.time()))()
    end)
    if not s then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DARKNES HUB",
            Text = "Gagal memuat " .. file .. ": " .. tostring(err),
            Duration = 5
        })
    end
end

-- DETEKSI MAP
if placeId == 750114916 or lowerName:find("opah") or lowerName:find("malam") or lowerName:find("rumah") then
    loadScript("darknesopah.lua")
elseif lowerName:find("brookhaven") or lowerName:find("brook") then
    loadScript("darknesbrookhaven.lua")
elseif lowerName:find("evade") then
    loadScript("darknesevade.lua")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DARKNES HUB",
        Text = "Game belum didukung: " .. gameName,
        Duration = 3
    })
end
