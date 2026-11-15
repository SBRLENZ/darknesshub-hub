--[[ DARKNES HUB - MAIN LOADER FIXED ]]
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local url = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"
local bypass = "?v=" .. tostring(tick())

local function getGame()
    local s, n = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)
    return s and n or "Unknown"
end

local GameName = string.lower(getGame())
local PlaceId = game.PlaceId

local function LoadScript(filename)
    local fullUrl = url .. filename .. bypass
    print("[DARKNES HUB] Memuat: " .. fullUrl)
    
    local success, result = pcall(function()
        return game:HttpGet(fullUrl)
    end)
    
    if success and result then
        local fn, err = loadstring(result)
        if fn then
            local runSuccess, runErr = pcall(fn)
            if not runSuccess then
                warn("[DARKNES HUB] Error eksekusi " .. filename .. ": " .. tostring(runErr))
            end
        else
            warn("[DARKNES HUB] Error loadstring " .. filename .. ": " .. tostring(err))
        end
    else
        warn("[DARKNES HUB] Gagal HttpGet file: " .. filename)
    end
end

-- Deteksi Game
if GameName:find("animal") or GameName:find("hospital") then
    LoadScript("darknesanimalhospital.lua")
elseif PlaceId == 750114916 or GameName:find("opah") or GameName:find("malam") or GameName:find("rumah") then
    LoadScript("Darknesrumahopah.lua")
elseif GameName:find("brookhaven") or GameName:find("brook") then
    LoadScript("colihub.lua")
elseif GameName:find("evade") then
    LoadScript("DarknesEvade.lua")
else
    -- Fallback paksa load Rumah Opah jika test di game tersebut
    LoadScript("Darknesrumahopah.lua")
end
