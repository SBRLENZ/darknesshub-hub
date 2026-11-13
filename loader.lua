local baseUrl = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"

-- Deteksi nama game
local success, gameName = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

if not success or not gameName then
    gameName = "Unknown"
end

local function loadScript(file)
    pcall(function()
        loadstring(game:HttpGet(baseUrl .. file))()
    end)
end

-- Pencocokan nama map
if gameName:lower():find("granny") or gameName:lower():find("nenek") then
    loadScript("darknesgrannymp.lua")
elseif gameName:lower():find("opah") then
    loadScript("darknesopah.lua")
else
    -- Fallback jika map tidak dikenali, buka opah by default
    loadScript("darknesopah.lua")
end
