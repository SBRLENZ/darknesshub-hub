--[[ DARKNES HUB - MAIN LOADER ]]
local baseUrl = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"
local bypass = "?t=" .. os.time() -- Bypass cache

local success, gameName = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

if not success or not gameName then gameName = "Unknown" end
local lowerName = gameName:lower()

local function loadScript(file)
    pcall(function()
        loadstring(game:HttpGet(baseUrl .. file .. bypass))()
    end)
end

-- ==========================================
-- DETEKSI OTOMATIS BERDASARKAN NAMA GAME
-- ==========================================

-- 1. Malam Bersama Opah
if lowerName:find("opah") or lowerName:find("malam") then
    loadScript("darknesopah.lua")

-- 2. Brookhaven RP
elseif lowerName:find("brookhaven") or lowerName:find("brook") then
    loadScript("darknesbrookhaven.lua")

-- 3. Murder Mystery 2 (MM2)
elseif lowerName:find("murder") or lowerName:find("mm2") then
    loadScript("darknesmm2.lua")

-- 4. Evade (Lari dari Nextbot)
elseif lowerName:find("evade") then
    loadScript("darknesevade.lua")

-- 5. Climb and Jump (Menara Dubai)
elseif lowerName:find("climb") or lowerName:find("jump") or lowerName:find("dubai") then
    loadScript("darknesclimbjump.lua")

-- JIKA GAME TIDAK ADA DI LIST
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DARKNES HUB",
        Text = "Game belum didukung: " .. gameName,
        Duration = 3
    })
end
