--[[ DARKNES HUB - Malam Bersama Opah (Custom UI) ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Load Custom UI
local DARKNES_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/DARKNES_UI.lua"))()
-- GANTI ANGKA 0 DENGAN ASSET ID GAMBAR LU YANG SUDAH DIUPLOAD KE ROBLOX
local UI = DARKNES_UI.new("DARKNES HUB", "rbxassetid://0") 

local CFG = { walkSpeed = 16, autoFarmFlip = false, autoFarmKunci = false, unlimitedStamina = false }

local function char() local c = LocalPlayer.Character return c, c and c:FindFirstChildOfClass("Humanoid") end
local function findByName(keyword) local list = {} for _, obj in ipairs(Workspace:GetDescendants()) do if obj:IsA("BasePart") and obj.Name:lower():find(keyword:lower()) then table.insert(list, obj) end end return list end

-- TAB FARM
local FarmTab = UI:AddTab("Farm")
FarmTab:AddSection("Auto Collect")
FarmTab:AddToggle("Auto Collect Flip Flop", false, function(s)
    CFG.autoFarmFlip = s
    task.spawn(function()
        while CFG.autoFarmFlip do
            local c = char()
            if c then
                local startCF = c.HumanoidRootPart.CFrame
                local flips = findByName("flip") if #flips == 0 then flips = findByName("sendal") end
                for _, f in ipairs(flips) do c.HumanoidRootPart.CFrame = f.CFrame task.wait(0.05) end
                c.HumanoidRootPart.CFrame = startCF
            end
            task.wait(1)
        end
    end)
end)

FarmTab:AddToggle("Auto Farm Kunci", false, function(s)
    CFG.autoFarmKunci = s
    task.spawn(function()
        while CFG.autoFarmKunci do
            local c = char()
            if c then
                local keys = findByName("key") if #keys == 0 then keys = findByName("kunci") end
                for _, k in ipairs(keys) do c.HumanoidRootPart.CFrame = k.CFrame task.wait(0.15) end
                local locks = findByName("gembok") if #locks == 0 then locks = findByName("lock") end
                for _, l in ipairs(locks) do 
                    c.HumanoidRootPart.CFrame = l.CFrame task.wait(0.1)
                    l:FireTouchInterest(c.HumanoidRootPart, l, 0) task.wait(0.05) l:FireTouchInterest(c.HumanoidRootPart, l, 1)
                end
            end
            task.wait(0.5)
        end
    end)
end)

-- TAB SETTINGS
local SetTab = UI:AddTab("Settings")
SetTab:AddSection("Player Mods")
SetTab:AddSlider("WalkSpeed", 16, 300, 16, function(v) CFG.walkSpeed = v end)
RunService.Stepped:Connect(function()
    local c, hum = char()
    if hum and math.abs(hum.WalkSpeed - CFG.walkSpeed) > 0.1 then hum.WalkSpeed = CFG.walkSpeed end
end)

-- TAB LAINNYA
local LainTab = UI:AddTab("Lainnya")
LainTab:AddSection("Ekstra Fitur")
LainTab:AddToggle("Unlimited Stamina", false, function(s)
    CFG.unlimitedStamina = s
    if s then
        task.spawn(function()
            while CFG.unlimitedStamina do
                local c = char()
                if c then for _, v in ipairs(c:GetDescendants()) do if v:IsA("ValueBase") and v.Name:lower():find("stamina") then v.Value = 9999 end end end
                task.wait(0.1)
            end
        end)
    end
end)
