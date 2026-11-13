--[[ DARKNES HUB - MAIN LOADER (Opah Focus) ]]
local baseUrl = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"
local bypass = "?t=" .. os.time() -- Bypass cache

local success, gameName = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

if not success or not gameName then gameName = "Unknown" end
local lowerName = gameName:lower()
local placeId = game.PlaceId

local function loadScript(file)
    pcall(function()
        loadstring(game:HttpGet(baseUrl .. file .. bypass))()
    end)
end

-- ==========================================
-- DETEKSI MAP
-- ==========================================

-- 1. FOKUS UTAMA: MALAM BERSAMA OPAH / RUMAH OPAH
if placeId == 750114916 or lowerName:find("opah") or lowerName:find("malam") or lowerName:find("rumah") then
    loadScript("darknesopah.lua")

-- 2. BROOKHAVEN RP
elseif lowerName:find("brookhaven") or lowerName:find("brook") then
    loadScript("darknesbrookhaven.lua")

-- 3. MURDER MYSTERY 2 (MM2)
elseif lowerName:find("murder") or lowerName:find("mm2") then
    loadScript("darknesmm2.lua")

-- 4. EVADE
elseif lowerName:find("evade") then
    loadScript("darknesevade.lua")

-- 5. CLIMB AND JUMP
elseif lowerName:find("climb") or lowerName:find("jump") or lowerName:find("dubai") then
    loadScript("darknesclimbjump.lua")

-- JIKA TIDAK ADA YANG COCOK
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DARKNES HUB",
        Text = "Game belum didukung: " .. gameName,
        Duration = 3
    })
end
