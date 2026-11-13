--[[ DARKNES HUB - MAIN LOADER ]]
local baseUrl = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"

local success, gameName = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

if not success or not gameName then gameName = "Unknown" end
local lowerName = gameName:lower()

local function loadScript(file)
    pcall(function()
        loadstring(game:HttpGet(baseUrl .. file))()
    end)
end

if lowerName:find("granny") or lowerName:find("nenek") or lowerName:find("rumah") then
    loadScript("darknesgrannymp.lua")
elseif lowerName:find("opah") or lowerName:find("malam") then
    loadScript("darknesopah.lua")
elseif lowerName:find("evade") then
    loadScript("darknesevade.lua")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DARKNES HUB",
        Text = "Map tidak didukung: " .. gameName,
        Duration = 3
    })
end
