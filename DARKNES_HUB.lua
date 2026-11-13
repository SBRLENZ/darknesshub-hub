local req = (syn and syn.request) or (http and http.request) or http_request or request
local url = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"
local bypass = "?update=" .. tostring(tick())

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

if PlaceId == 750114916 or GameName:find("opah") or GameName:find("malam") then
    Load("darknesopah.lua")
elseif GameName:find("brookhaven") then
    Load("darknesbrookhaven.lua")
elseif GameName:find("evade") then
    Load("darknesevade.lua")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DARKNES", Text = "Unsupported Game.", Duration = 3
    })
end
