local url = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"
local bypass = "?v=" .. tostring(tick())

local GameName = string.lower(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
local PlaceId = game.PlaceId

local function Load(scr)
    -- Sengaja tanpa pcall biar error-nya kelihatan di Console (F9)
    loadstring(game:HttpGet(url .. scr .. bypass))()
end

if PlaceId == 750114916 or GameName:find("opah") or GameName:find("malam") or GameName:find("nenek") or GameName:find("rumah") then
    Load("darknesopah.lua")
elseif GameName:find("brookhaven") then
    Load("darknesbrookhaven.lua")
elseif GameName:find("evade") then
    Load("darknesevade.lua")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DARKNES HUB", 
        Text = "Game tidak dikenali (" .. GameName .. "). Memaksa load Opah...", 
        Duration = 5
    })
    Load("darknesopah.lua")
end
