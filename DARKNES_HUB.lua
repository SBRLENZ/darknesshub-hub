--[[ DARKNES HUB - MAIN LOADER (Fixed Priority) ]]
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

-- PRIORITAS 1: MAP OPAH (Karena biasanya ada kata "Malam" atau "Opah")
if lowerName:find("opah") or lowerName:find("malam") then
    loadScript("darknesopah.lua")

-- PRIORITAS 2: MAP GRANNY (Baru cek "nenek" atau "granny" kalau bukan Opah)
elseif lowerName:find("granny") or lowerName:find("nenek") or lowerName:find("rumah") then
    loadScript("darknesgrannymp.lua")

-- PRIORITAS 3: MAP EVADE
elseif lowerName:find("evade") then
    loadScript("darknesevade.lua")

-- JIKA TIDAK ADA YANG COCOK
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DARKNES HUB",
        Text = "Map tidak didukung: " .. gameName,
        Duration = 3
    })
end
