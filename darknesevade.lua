--[[ DARKNES HUB - Evade (Rayfield) ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInput = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local CFG = { 
    walkSpeed = 16, jumpPower = 50, flyEnabled = false, flySpeed = 60, 
    noclip = false, autoCoin = false, avoidNextbot = false 
}

local function char() 
    local c = LocalPlayer.Character
    return c, c and c:FindFirstChildOfClass("Humanoid") 
end

local function findByName(keyword, class) 
    local list = {} 
    for _, obj in ipairs(Workspace:GetDescendants()) do 
        if obj:IsA(class or "BasePart") and obj.Name:lower():find(keyword:lower()) then 
            table.insert(list, obj) 
        end 
    end 
    return list 
end

local Window = Rayfield:CreateWindow({ 
    Name = "☠ DARKNES HUB - EVADE ☠", 
    LoadingTitle = "Memuat Evade...", 
    ConfigurationSaving = {Enabled = false}, 
    KeySystem = false 
})

-- ===== TAB MAIN =====
local MainTab = Window:CreateTab("Main / Player", 4483362458)
MainTab:CreateSlider({Name = "WalkSpeed", Range = {16, 250}, Increment = 1, Suffix = "Speed", CurrentValue = 16, Callback = function(v) CFG.walkSpeed = v end})
MainTab:CreateSlider({Name = "JumpPower", Range = {50, 300}, Increment = 1, Suffix = "JP", CurrentValue = 50, Callback = function(v) CFG.jumpPower = v end})
MainTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(s) CFG.noclip = s end})

MainTab:CreateToggle({
    Name = "Fly (WASD + Space)", 
    CurrentValue = false, 
    Callback = function(state)
        CFG.flyEnabled = state
        local c = char() 
        if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart") 
        if not root then return end
        
        if state then
            local bv = Instance.new("BodyVelocity", root) 
            bv.Name = "FlyBody" 
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5) 
            bv.Velocity = Vector3.zero
            local bg = Instance.new("BodyGyro", root) 
            bg.Name = "FlyGyro" 
            bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5) 
            bg.P = 1000 bg.D = 50
            task.spawn(function()
                while CFG.flyEnabled and root.Parent do
                    local cam = Workspace.CurrentCamera 
                    local dir = Vector3.zero
                    if UserInput:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                    if UserInput:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                    if UserInput:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                    if UserInput:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                    if UserInput:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
                    if UserInput:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
                    bv.Velocity = dir * CFG.flySpeed
                    bg.CFrame = cam.CFrame
                    task.wait()
                end
                if root:FindFirstChild("FlyBody") then root.FlyBody:Destroy() end
                if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
            end)
        else
            local b = root:FindFirstChild("FlyBody") if b then b:Destroy() end
            local g = root:FindFirstChild("FlyGyro") if g then g:Destroy() end
        end
    end,
})

RunService.Stepped:Connect(function() 
    local c, hum = char() 
    if hum then 
        if math.abs(hum.WalkSpeed - CFG.walkSpeed) > 0.1 then hum.WalkSpeed = CFG.walkSpeed end 
        if math.abs(hum.JumpPower - CFG.jumpPower) > 0.1 then hum.JumpPower = CFG.jumpPower end
    end 
    if CFG.noclip and c then 
        for _, v in ipairs(c:GetDescendants()) do 
            if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end 
        end 
    end 
end)

-- ===== TAB AUTO FARM =====
local FarmTab = Window:CreateTab("Auto Features", 4483362458)
FarmTab:CreateToggle({
    Name = "Auto Collect Coins", 
    CurrentValue = false, 
    Callback = function(s)
        CFG.autoCoin = s
        task.spawn(function()
            while CFG.autoCoin do
                local c = char()
                if c and c:FindFirstChild("HumanoidRootPart") then
                    local coins = findByName("coin") 
                    if #coins == 0 then coins = findByName("cash") end
                    for _, coin in ipairs(coins) do 
                        if not CFG.autoCoin then break end 
                        c.HumanoidRootPart.CFrame = coin.CFrame 
                        task.wait(0.05) 
                    end
                end
                task.wait(0.5)
            end
        end)
    end
})

FarmTab:CreateToggle({
    Name = "Avoid Nextbot (Teleport ke Langit)", 
    CurrentValue = false, 
    Callback = function(s)
        CFG.avoidNextbot = s
        if s then
            task.spawn(function()
                while CFG.avoidNextbot do
                    local c = char()
                    if c and c:FindFirstChild("HumanoidRootPart") then
                        local myPos = c.HumanoidRootPart.Position
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                                local hrp = obj:FindFirstChild("HumanoidRootPart")
                                if hrp and (hrp.Position - myPos).Magnitude < 25 then 
                                    c.HumanoidRootPart.CFrame = CFrame.new(0, 500, 0) 
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

FarmTab:CreateButton({
    Name = "Auto Revive",
    Callback = function()
        local c = char()
        if c and c:FindFirstChildOfClass("Humanoid") and c.Humanoid.Health <= 0 then
            game:GetService("TeleportService"):Teleport(game.PlaceId)
        else
            Rayfield:Notify({Title = "Info", Content = "Kamu belum mati bro.", Duration = 2})
        end
    end
})

-- ===== TAB VISUAL =====
local VisTab = Window:CreateTab("Visual (ESP)", 4483362458)
VisTab:CreateToggle({
    Name = "ESP Nextbot (Bahaya)", 
    CurrentValue = false, 
    Callback = function(s)
        if s then
            task.spawn(function()
                while task.wait(2) do
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                            if obj.PrimaryPart and not obj.PrimaryPart:FindFirstChild("DarknesESP") then 
                                local b = Instance.new("BoxHandleAdornment", obj.PrimaryPart) 
                                b.Name = "DarknesESP"
                                b.Size = obj:GetExtentsSize() 
                                b.Color3 = Color3.new(1,0,0) 
                                b.AlwaysOnTop = true 
                            end
                        end
                    end
                end
            end)
        end
    end
})
