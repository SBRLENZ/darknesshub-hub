--[[
    DARKNES HUB - MAIN LOADER
]]

local baseUrl = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"

local success, gameName = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

if not success or not gameName then gameName = "Unknown" end

local function loadScript(file)
    pcall(function()
        loadstring(game:HttpGet(baseUrl .. file))()
    end)
end

local lowerName = gameName:lower()

if lowerName:find("granny") or lowerName:find("nenek") then
    loadScript("darknesgrannymp.lua")
elseif lowerName:find("opah") then
    loadScript("darknesopah.lua")
elseif lowerName:find("penjara") or lowerName:find("prison") then
    loadScript("darknesprison.lua")
else
    -- Fallback
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DARKNES HUB",
        Text = "Map tidak dikenali: " .. gameName,
        Duration = 3
    })
end
