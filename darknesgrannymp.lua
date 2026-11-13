--[[ DARKNES HUB - Granny Multiplayer ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local CFG = { walkSpeed = 16, autoFarmItems = false, freezeGranny = false }

local function char() local c = LocalPlayer.Character return c, c and c:FindFirstChildOfClass("Humanoid") end
local function findObjs(class, kw) local list = {} for _, obj in ipairs(Workspace:GetDescendants()) do if obj:IsA(class) and (not kw or obj.Name:lower():find(kw:lower())) then table.insert(list, obj) end end return list end
local function tpTo(cf, offsetY) local c = LocalPlayer.Character if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame = cf + Vector3.new(0, offsetY or 3, 0) end end

local Window = Rayfield:CreateWindow({ Name = "☠ DARKNES HUB - GRANNY ☠", LoadingTitle = "Memuat Granny...", ConfigurationSaving = {Enabled = false}, KeySystem = false })

local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateParagraph({Title = "Halo @" .. LocalPlayer.Name, Content = "Map: Granny / Nenek Multiplayer"})

-- TAB GRANNY 1, 2, 3
local function createGrannyTab(name)
    local T = Window:CreateTab(name, 4483362458)
    T:CreateButton({Name = "TP ke Main Door", Callback = function() local d = findObjs("BasePart", "door") if d[1] then tpTo(d[1].CFrame) end end})
    T:CreateButton({Name = "TP ke Basement", Callback = function() local b = findObjs("BasePart", "basement") if b[1] then tpTo(b[1].CFrame) end end})
end
createGrannyTab("Granny 1")
createGrannyTab("Granny 2")
createGrannyTab("Granny 3")

local VisTab = Window:CreateTab("Visual", 4483362458)
VisTab:CreateToggle({Name = "ESP Granny (Nenek)", CurrentValue = false, Callback = function(s)
    if s then
        local g = findObjs("Model", "granny") local n = findObjs("Model", "nenek")
        for _, v in ipairs(g) do if v.PrimaryPart then local box = Instance.new("BoxHandleAdornment", v.PrimaryPart) box.Size = v:GetExtentsSize() box.Color3 = Color3.new(1,0,0) box.AlwaysOnTop = true end end
        for _, v in ipairs(n) do if v.PrimaryPart then local box = Instance.new("BoxHandleAdornment", v.PrimaryPart) box.Size = v:GetExtentsSize() box.Color3 = Color3.new(1,0,0) box.AlwaysOnTop = true end end
    end
end})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
FarmTab:CreateToggle({Name = "Auto Ambil Semua Item (Fast)", CurrentValue = false, Callback = function(s)
    CFG.autoFarmItems = s
    task.spawn(function()
        while CFG.autoFarmItems do
            local c = char()
            if c then
                local tools = findObjs("Tool")
                for _, t in ipairs(tools) do
                    if t:FindFirstChild("Handle") then
                        c.HumanoidRootPart.CFrame = t.Handle.CFrame
                        task.wait(0.05)
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end})

local LainTab = Window:CreateTab("Lainnya", 4483362458)
LainTab:CreateToggle({Name = "Freeze Granny", CurrentValue = false, Callback = function(s)
    local g = findObjs("Model", "granny") local n = findObjs("Model", "nenek")
    for _, v in ipairs(g) do local h = v:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = s and 0 or 16 end end
    for _, v in ipairs(n) do local h = v:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = s and 0 or 16 end end
end})

local SetTab = Window:CreateTab("Setting", 4483362458)
SetTab:CreateSlider({Name = "WalkSpeed", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) CFG.walkSpeed = v end})
RunService.Stepped:Connect(function() local c, hum = char() if hum and math.abs(hum.WalkSpeed - CFG.walkSpeed) > 0.1 then hum.WalkSpeed = CFG.walkSpeed end end)
