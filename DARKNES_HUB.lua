--[[ DARKNES HUB - MAIN LOADER (ID & WORKSPACE CHECK) ]]
local baseUrl = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"
local bypass = "?t=" .. os.time()

local function loadScript(file)
    local s, err = pcall(function()
        loadstring(game:HttpGet(baseUrl .. file .. bypass))()
    end)
    if not s then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DARKNES HUB ERROR",
            Text = "Failed to load " .. file .. ": " .. tostring(err),
            Duration = 5
        })
    end
end

-- Deteksi game berdasarkan PlaceId atau Workspace
local placeId = game.PlaceId
local isEvade = false
local isOpah = false

-- Cek apakah ada objek khas Evade atau Rumah Opa di Workspace / PlaceId
if workspace:FindFirstChild("Nextbots") or workspace:FindFirstChild("Map") or placeId == 9872472334 -- contoh/masukin ID Evade kalau tau, atau biarkan deteksi nama fleksibel
then
    isEvade = true
end

-- Cek nama game via Marketplace dengan fallback aman
local success, gameName = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(placeId).Name
end)

local lowerName = success and gameName:lower() or ""

if lowerName:find("rumah opa") or lowerName:find("opah") then
    loadScript("darknesopah.lua")
elseif lowerName:find("evade") or lowerName:find("menghindar") or lowerName:find("hlwn") or workspace:FindFirstChild("Nextbots") then
    loadScript("darknesevade.lua")
else
    -- Paksa masuk Evade kalau lu lagi main mode Menghindar/Evade tapi namanya nggak kebaca
    loadScript("darknesevade.lua")
end
