--[[
    DARKNES HUB - MAIN LOADER (Smart Detection)
]]

local baseUrl = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"

-- Ambil nama game
local success, gameName = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

if not success or not gameName then 
    gameName = "Unknown" 
end

local lowerName = gameName:lower()
local placeId = game.PlaceId

local function loadScript(file)
    pcall(function()
        loadstring(game:HttpGet(baseUrl .. file))()
    end)
end

-- 1. Deteksi Granny / Nenek / Rumah Opah
if lowerName:find("granny") or lowerName:find("nenek") or lowerName:find("opah") or lowerName:find("rumah") then
    loadScript("darknesgrannymp.lua")
    
-- 2. Deteksi Malam Bersama Opah (Berdasarkan nama atau Place ID)
-- Kamu bisa tambahkan PlaceID dari game Malam Bersama Opah di sini (contoh: 123456789)
elseif lowerName:find("malam") or placeId == 123456789 then
    loadScript("darknesopah.lua")

-- 3. Deteksi Penjara
elseif lowerName:find("penjara") or lowerName:find("prison") then
    loadScript("darknesprison.lua")

-- 4. Jika tidak ada yang cocok, tetap buka menu default (Opah) atau beri notif
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DARKNES HUB",
        Text = "Game tidak dikenali: " .. gameName,
        Duration = 3
    })
    -- Fallback: Buka map Opah jika tidak terdeteksi (opsional)
    -- loadScript("darknesopah.lua") 
end
