--[[ DARKNES HUB - Malam Bersama Opah ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local CFG = { walkSpeed = 16, noclip = false, flyEnabled = false, flySpeed = 60, autoFarmFlip = false, autoFarmKunci = false, unlimitedStamina = false }

local function char() local c = LocalPlayer.Character return c, c and c:FindFirstChildOfClass("Humanoid") end
local function findByName(keyword) local list = {} for _, obj in ipairs(Workspace:GetDescendants()) do if obj:IsA("BasePart") and obj.Name:lower():find(keyword:lower()) then table.insert(list, obj) end end return list end
local function tpTo(cf, offsetY) local c = LocalPlayer.Character if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame = cf + Vector3.new(0, offsetY or 3, 0) end end

local Window = Rayfield:CreateWindow({ Name = "☠ DARKNES HUB - OPAH ☠", LoadingTitle = "Memuat Opah...", ConfigurationSaving = {Enabled = false}, KeySystem = false })

local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateParagraph({Title = "Halo @" .. LocalPlayer.Name, Content = "Map: Malam Bersama Opah"})

local TpTab = Window:CreateTab("Teleport", 4483362458)
TpTab:CreateButton({Name = "TP ke Nenek", Callback = function() local n = findByName("nenek") if n[1] then tpTo(n[1].CFrame) end end})
TpTab:CreateButton({Name = "TP ke Dapur (Fixed)", Callback = function() local d = findByName("kitchen") if d[1] then tpTo(d[1].CFrame, -3) end end})
TpTab:CreateButton({Name = "TP ke Safe Zone", Callback = function() local s = findByName("safe") if s[1] then tpTo(s[1].CFrame) end end})

local VisTab = Window:CreateTab("Visual", 4483362458)
VisTab:CreateToggle({Name = "ESP Nenek", CurrentValue = false, Callback = function(s) 
    if s then for _, n in ipairs(findByName("nenek")) do local box = Instance.new("BoxHandleAdornment", n) box.Size = n.Size box.Adornee = n box.Color3 = Color3.new(1,0,0) end end 
end})

local FarmTab = Window:CreateTab("Farm", 4483362458)
FarmTab:CreateToggle({Name = "Auto Collect Flip Flop", CurrentValue = false, Callback = function(s)
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
end})

FarmTab:CreateToggle({Name = "Auto Farm Kunci", CurrentValue = false, Callback = function(s)
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
end})

local SetTab = Window:CreateTab("Setting", 4483362458)
SetTab:CreateSlider({Name = "WalkSpeed", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) CFG.walkSpeed = v end})
RunService.Stepped:Connect(function() local c, hum = char() if hum and math.abs(hum.WalkSpeed - CFG.walkSpeed) > 0.1 then hum.WalkSpeed = CFG.walkSpeed end end)

local LainTab = Window:CreateTab("Lainnya", 4483362458)
LainTab:CreateToggle({Name = "Unlimited Stamina", CurrentValue = false, Callback = function(s) CFG.unlimitedStamina = s
    if s then task.spawn(function() while CFG.unlimitedStamina do local c = char() if c then for _, v in ipairs(c:GetDescendants()) do if v:IsA("ValueBase") and v.Name:lower():find("stamina") then v.Value = 9999 end end end task.wait(0.1) end end) end
end})
