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

-- ==========================================
-- DETEKSI MAP (Prioritas PlaceId / Nama)
-- ==========================================

-- 1. Animal Hospital
if GameName:find("animal") or GameName:find("hospital") then
    Load("darknesanimalhospital.lua")

-- 2. Malam Bersama Opah / Rumah Opah
elseif PlaceId == 750114916 or GameName:find("opah") or GameName:find("malam") or GameName:find("rumah") then
    Load("darknesopah.lua")

-- 3. Brookhaven RP
elseif GameName:find("brookhaven") or GameName:find("brook") then
    Load("colihub.lua")

-- 4. Evade
elseif GameName:find("evade") then
    Load("darknesevade.lua")

-- 5. Fallback (Map tidak dikenal)
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DARKNES HUB", 
        Text = "Game belum didukung: " .. GameName, 
        Duration = 3
    })
end
