--[[ DARKNES HUB - Brookhaven RP (Troll Edition) ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInput = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local CFG = { walkSpeed = 16, jumpPower = 50, flyEnabled = false, noclip = false, autoFling = false }

local function char() local c = LocalPlayer.Character return c, c and c:FindFirstChildOfClass("Humanoid") end
local function findByName(keyword, class) local list = {} for _, obj in ipairs(Workspace:GetDescendants()) do if obj:IsA(class or "BasePart") and obj.Name:lower():find(keyword:lower()) then table.insert(list, obj) end end return list end

local Window = Rayfield:CreateWindow({ Name = "☠ DARKNES HUB - BROOKHAVEN TROLL ☠", LoadingTitle = "Memuat Troll...", ConfigurationSaving = {Enabled = false}, KeySystem = false })

-- ===== TAB MAIN =====
local MainTab = Window:CreateTab("Player", 4483362458)
MainTab:CreateSlider({Name = "WalkSpeed", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) CFG.walkSpeed = v end})
MainTab:CreateSlider({Name = "JumpPower", Range = {50, 300}, Increment = 1, CurrentValue = 50, Callback = function(v) CFG.jumpPower = v end})
MainTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(s) CFG.noclip = s end})

MainTab:CreateToggle({
    Name = "Fly", CurrentValue = false, Callback = function(state)
        CFG.flyEnabled = state
        local c = char() if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart") if not root then return end
        if state then
            local bv = Instance.new("BodyVelocity", root) bv.Name = "FlyBody" bv.MaxForce = Vector3.new(1e5, 1e5, 1e5) bv.Velocity = Vector3.zero
            local bg = Instance.new("BodyGyro", root) bg.Name = "FlyGyro" bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5) bg.P = 1000 bg.D = 50
            task.spawn(function()
                while CFG.flyEnabled and root.Parent do
                    local cam = Workspace.CurrentCamera local dir = Vector3.zero
                    if UserInput:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                    if UserInput:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                    if UserInput:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                    if UserInput:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                    if UserInput:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
                    if UserInput:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
                    bv.Velocity = dir * 60 bg.CFrame = cam.CFrame task.wait()
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
    if CFG.noclip and c then for _, v in ipairs(c:GetDescendants()) do if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end end end
end)

-- ===== TAB VISUAL =====
local VisTab = Window:CreateTab("Visual", 4483362458)
VisTab:CreateToggle({Name = "Fullbright", CurrentValue = false, Callback = function(s)
    local L = game:GetService("Lighting")
    if s then L.Brightness = 3 L.ClockTime = 12 for _, v in pairs(L:GetChildren()) do if v:IsA("PostEffect") then v.Enabled = false end end
    else L.Brightness = 1 L.ClockTime = 0 end
end})
VisTab:CreateToggle({Name = "No Fog", CurrentValue = false, Callback = function(s) game:GetService("Lighting").FogEnd = s and 999999 or 100 end})

local function addESP(obj, color, name)
    if not obj or obj:FindFirstChild("DarknesESP") then return end
    local box = Instance.new("BoxHandleAdornment") box.Name = "DarknesESP" box.Adornee = obj box.Size = obj.Size box.AlwaysOnTop = true box.Transparency = 0.4 box.Color3 = color box.Parent = obj
    local bill = Instance.new("BillboardGui") bill.Name = "DarknesLabel" bill.Size = UDim2.new(0, 100, 0, 25) bill.StudsOffset = Vector3.new(0, obj.Size.Y/2 + 1, 0) bill.AlwaysOnTop = true bill.Adornee = obj bill.Parent = obj
    local lbl = Instance.new("TextLabel", bill) lbl.Size = UDim2.new(1, 0, 1, 0) lbl.BackgroundTransparency = 1 lbl.Text = name or obj.Name lbl.TextColor3 = color lbl.TextStrokeTransparency = 0 lbl.Font = Enum.Font.GothamBold lbl.TextSize = 12
end

VisTab:CreateToggle({Name = "ESP Player", CurrentValue = false, Callback = function(s)
    if s then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then addESP(p.Character.HumanoidRootPart, Color3.fromRGB(0, 255, 0), p.Name) end
        end
    end
end})

-- ===== TAB TROLL (26+ FITUR) =====
local TrollTab = Window:CreateTab("Troll 😈", 4483362458)
TrollTab:CreateSection("Aksi Massal")

TrollTab:CreateButton({Name = "Fling All Players", Callback = function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local bv = Instance.new("BodyAngularVelocity", p.Character.HumanoidRootPart)
            bv.AngularVelocity = Vector3.new(9999, 9999, 9999) bv.MaxTorque = Vector3.new(9999, 9999, 9999)
            game:GetService("Debris"):AddItem(bv, 1)
        end
    end
end})

TrollTab:CreateButton({Name = "Kill All Players", Callback = function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then p.Character.Humanoid.Health = 0 end
    end
end})

TrollTab:CreateButton({Name = "Bring All Players", Callback = function()
    local c = char() if not c then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame + Vector3.new(math.random(-5,5), 3, math.random(-5,5))
        end
    end
end})

TrollTab:CreateButton({Name = "Ban All Players (Kick)", Callback = function()
    -- Fitur ini mencoba menendang semua pemain (bisa gagal tergantung executor)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            pcall(function() p:Kick("DARKNES HUB Troll") end)
        end
    end
end})

TrollTab:CreateSection("Aksi Target Tertentu")

local targetName = nil
local plrList = {}
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(plrList, p.Name) end end
TrollTab:CreateDropdown({Name = "Pilih Target", Options = plrList, CurrentOption = {"Pilih"}, Callback = function(opt) targetName = opt[1] end})

TrollTab:CreateButton({Name = "Fling Target", Callback = function()
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local bv = Instance.new("BodyAngularVelocity", target.Character.HumanoidRootPart)
        bv.AngularVelocity = Vector3.new(9999, 9999, 9999) bv.MaxTorque = Vector3.new(9999, 9999, 9999)
        game:GetService("Debris"):AddItem(bv, 1)
    end
end})

TrollTab:CreateButton({Name = "Fling Target pakai Bus 🚌", Callback = function()
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    if not target or not target.Character then return end
    local bus = Workspace:FindFirstChild("Bus") or Workspace:FindFirstChild("bus")
    if bus and bus:IsA("Model") and bus.PrimaryPart then
        bus:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0))
        task.wait(0.1)
        local bv = Instance.new("BodyVelocity", bus.PrimaryPart)
        bv.Velocity = Vector3.new(math.random(-1000,1000), 1000, math.random(-1000,1000)) bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        game:GetService("Debris"):AddItem(bv, 2)
        Rayfield:Notify({Title="Troll", Content="Fling pakai Bus ke "..targetName, Duration=3})
    else
        Rayfield:Notify({Title="Error", Content="Bus tidak ditemukan di map", Duration=3})
    end
end})

TrollTab:CreateButton({Name = "Sky Drop Target", Callback = function()
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 500, 0)
    end
end})

TrollTab:CreateButton({Name = "Void Drop Target", Callback = function()
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0)
    end
end})

TrollTab:CreateButton({Name = "Freeze Target", Callback = function()
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local bp = Instance.new("BodyPosition", target.Character.HumanoidRootPart)
        bp.Position = target.Character.HumanoidRootPart.Position bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        game:GetService("Debris"):AddItem(bp, 5)
    end
end})

TrollTab:CreateButton({Name = "Kill Target", Callback = function()
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then target.Character.Humanoid.Health = 0 end
end})

TrollTab:CreateButton({Name = "Bring Target ke Saya", Callback = function()
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    local c = char()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and c then
        target.Character.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame
    end
end})

TrollTab:CreateButton({Name = "Spectate Target", Callback = function()
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        Workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
    end
end})

TrollTab:CreateButton({Name = "Orbit Target", Callback = function()
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    local c = char()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and c then
        task.spawn(function()
            for i = 1, 100 do
                c.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(i * 10), 0) * CFrame.new(0, 5, 10)
                task.wait(0.05)
            end
        end)
    end
end})

TrollTab:CreateButton({Name = "Headsit Target", Callback = function()
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    local c = char()
    if target and target.Character and target.Character:FindFirstChild("Head") and c then
        c.HumanoidRootPart.CFrame = target.Character.Head.CFrame + Vector3.new(0, 2, 0)
    end
end})

TrollTab:CreateButton({Name = "Glue ke Target (Anti Lepas)", Callback = function()
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    local c = char()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and c then
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = c.HumanoidRootPart weld.Part1 = target.Character.HumanoidRootPart weld.Parent = c.HumanoidRootPart
        game:GetService("Debris"):AddItem(weld, 10)
    end
end})

TrollTab:CreateButton({Name = "Fling Ball ke Target", Callback = function()
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    if not target or not target.Character then return end
    local ball = Instance.new("Part") ball.Shape = Enum.PartType.Ball ball.Size = Vector3.new(5,5,5) ball.Color = Color3.new(1,0,0) ball.Position = target.Character.HumanoidRootPart.Position + Vector3.new(0,10,0) ball.Parent = Workspace
    local bv = Instance.new("BodyVelocity", ball) bv.Velocity = Vector3.new(0, -500, 0) bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    game:GetService("Debris"):AddItem(ball, 3)
end})

TrollTab:CreateButton({Name = "Child Troll (Pocong)", Callback = function()
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    if not target or not target.Character then return end
    local child = Instance.new("Part") child.Size = Vector3.new(1,2,1) child.Color = Color3.new(0,0,0) child.Material = Enum.Material.Neon child.Parent = Workspace
    local bill = Instance.new("BillboardGui", child) bill.Size = UDim2.new(0,100,0,50) bill.StudsOffset = Vector3.new(0,2,0)
    local txt = Instance.new("TextLabel", bill) txt.Size = UDim2.new(1,0,1,0) txt.BackgroundTransparency = 1 txt.Text = "👻" txt.TextScaled = true
    task.spawn(function()
        for i = 1, 200 do
            if not child or not child.Parent then break end
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                child.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-5,5), 3, math.random(-5,5))
            end
            task.wait(0.1)
        end
        if child then child:Destroy() end
    end)
end})

TrollTab:CreateButton({Name = "Pirate Tornado", Callback = function()
    local c = char() if not c then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local bav = Instance.new("BodyAngularVelocity", p.Character.HumanoidRootPart)
            bav.AngularVelocity = Vector3.new(0, 50, 0) bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            game:GetService("Debris"):AddItem(bav, 5)
        end
    end
end})

TrollTab:CreateButton({Name = "Spam Chat (Pesan Troll)", Callback = function()
    task.spawn(function()
        for i = 1, 20 do
            game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer("DARKNES HUB TROLL 😈", "All")
            task.wait(0.5)
        end
    end)
end})

TrollTab:CreateButton({Name = "Spam Request (Carry/Piggyback)", Callback = function()
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    if target then
        task.spawn(function()
            for i = 1, 10 do
                game:GetService("ReplicatedStorage"):FindFirstChild("Request"):FireServer(target)
                task.wait(0.3)
            end
        end)
    end
end})

TrollTab:CreateButton({Name = "Delete Target's House", Callback = function()
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    if target then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name:lower():find(targetName:lower()) then obj:Destroy() end
        end
    end
end})

TrollTab:CreateButton({Name = "Bring All Cars", Callback = function()
    local c = char() if not c then return end
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") and v.Parent then
            v.Parent:SetPrimaryPartCFrame(c.HumanoidRootPart.CFrame + Vector3.new(math.random(-10,10), 3, math.random(-10,10)))
        end
    end
end})

TrollTab:CreateButton({Name = "Remove All Vehicles", Callback = function()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") and v.Parent then v.Parent:Destroy() end
    end
end})

TrollTab:CreateButton({Name = "Server Shutdown (Crash)", Callback = function()
    -- Fitur ekstrem, gunakan dengan risiko sendiri
    for i = 1, 50 do
        game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(string.rep("A", 500), "All")
        task.wait(0.1)
    end
end})

TrollTab:CreateButton({Name = "Invisible (Local)", Callback = function()
    local c = char() if not c then return end
    for _, v in ipairs(c:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = 1 v.CanCollide = false
        elseif v:IsA("Decal") then v.Transparency = 1 end
    end
end})

TrollTab:CreateButton({Name = "Un-Invisible (Local)", Callback = function()
    local c = char() if not c then return end
    for _, v in ipairs(c:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = 0 v.CanCollide = true
        elseif v:IsA("Decal") then v.Transparency = 0 end
    end
end})

TrollTab:CreateButton({Name = "RGB Name & Bio", Callback = function()
    task.spawn(function()
        while true do
            local hue = tick() % 1
            local color = Color3.fromHSV(hue, 1, 1)
            game:GetService("Players").LocalPlayer:SetAttribute("RGBColor", color)
            task.wait(0.1)
        end
    end)
end})
