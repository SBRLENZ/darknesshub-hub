--[[ DARKNES HUB - MAIN LOADER ]]
local url = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"
local bypass = "?v=" .. tostring(tick())

local function getGame()
    local s, n = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
    return s and n or "Unknown"
end

local GameName = string.lower(getGame())
local PlaceId = game.PlaceId

local function Load(scr)
    pcall(function()
        loadstring(game:HttpGet(url .. scr .. bypass))()
    end)
end

-- DETEKSI MAP
if PlaceId == 750114916 or GameName:find("opah") or GameName:find("malam") then
    Load("darknesopah.lua")
elseif GameName:find("brookhaven") then
    Load("colihub.lua")
elseif GameName:find("evade") then
    Load("darknesevade.lua")
elseif GameName:find("math") or GameName:find("matematika") or GameName:find("balapan") then
    Load("darknesmath.lua") -- Loader untuk game matematika
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DARKNES HUB", 
        Text = "Game belum didukung: " .. GameName, 
        Duration = 3
    })
end
