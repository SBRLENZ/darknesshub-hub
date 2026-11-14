--[[ DARKNES HUB - MAIN LOADER ]]
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

-- Deteksi game secara fleksibel
local success, gameName = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

local lowerName = success and gameName:lower() or ""

-- ROUTER MODUL GAME
if lowerName:find("rumah opa") or lowerName:find("opah") then
    loadScript("darknesopah.lua")
elseif lowerName:find("evade") or lowerName:find("menghindar") or lowerName:find("hlwn") or workspace:FindFirstChild("Nextbots") then
    loadScript("darknesevade.lua")
elseif lowerName:find("brookhaven") or lowerName:find("brook") then
    loadScript("darknesbrookhaven.lua")
else
    -- Fallback aman jika judul game tidak terbaca sempurna
    loadScript("darknesbrookhaven.lua")
end
