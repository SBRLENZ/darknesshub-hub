--[[ DARKNES HUB - MAIN LOADER ]]
local baseUrl = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"
local bypass = "?t=" .. os.time()

local success, gameName = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

if not success or not gameName then gameName = "Unknown" end
local lowerName = gameName:lower()

local function loadScript(file)
    local s, err = pcall(function()
        loadstring(game:HttpGet(baseUrl .. file .. bypass))()
    end)
    if not s then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DARKNES HUB ERROR",
            Text = "Failed to load " .. file .. ": " .. tostring(err),
            Duration = 5
        })
    end
end

-- DETEKSI MAP LEBIH FLEKSIBEL (TERMASUK EDISI HALLOWEEN / MENGHINDAR)
if lowerName:find("rumah opa") or lowerName:find("opah") then
    loadScript("darknesopah.lua")
elseif lowerName:find("evade") or lowerName:find("menghindar") or lowerName:find("hlwn") then
    loadScript("darknesevade.lua")
elseif lowerName:find("brookhaven") or lowerName:find("brook") then
    loadScript("darknesbrookhaven.lua")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DARKNES HUB",
        Text = "Game not supported: " .. gameName,
        Duration = 4
    })
end
