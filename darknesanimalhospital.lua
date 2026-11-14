local Lib = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Plrs = game:GetService("Players")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local Lgt = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local LP = Plrs.LocalPlayer

local Win = Lib:CreateWindow({
   Name = "DARKNES HUB | Animal Hospital OP",
   LoadingTitle = "DARKNES HUB ULTIMATE",
   LoadingSubtitle = "SBRLENZ",
   ConfigurationSaving = { Enabled = true, FolderName = "DarknesCfg", FileName = "AnimalHospitalOP" },
   KeySystem = false
})

local function root() return LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") end
local function hum() return LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") end
local function go(cf)
    local r = root()
    if r and cf then r.CFrame = typeof(cf) == "CFrame" and cf + Vector3.new(0, 3, 0) or CFrame.new(cf + Vector3.new(0, 3, 0)) end
end

-- ==========================================
-- TAB 1: MAIN & HUB
-- ==========================================
local t1 = Win:CreateTab("Main", 4483362458)
t1:CreateParagraph({ Title = "Operator: " .. LP.Name, Content = "Status: OP Features Active\nDiscord: https://discord.gg/jzDxbbJhy" })
t1:CreateButton({ Name = "Copy Discord Link", Callback = function() if setclipboard then setclipboard("https://discord.gg/jzDxbbJhy") end end })
t1:CreateButton({ Name = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end })
t1:CreateButton({ Name = "Server Hop Hub", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end })
t1:CreateButton({ Name = "Unlock Max Camera Zoom", Callback = function() LP.CameraMaxZoomDistance = 999999 end })
t1:CreateButton({ Name = "Reset Camera FOV", Callback = function() WS.CurrentCamera.FieldOfView = 70 end })
t1:CreateButton({ Name = "Hide Hub UI Menu", Callback = function() Lib:Hide() end })

-- ==========================================
-- TAB 2: OP AUTO-FARM & HOSPITAL HACKS
-- ==========================================
local t2 = Win:CreateTab("OP Auto-Farm", 4483362458)
local autoReg, autoCheck, autoHealLoop, autoTpDirect = false, false, false, false

t2:CreateToggle({ Name = "Auto Daftarin Pasien (Queue)", CurrentValue = false, Callback = function(v)
    autoReg = v
    task.spawn(function()
        while autoReg do
            for _, o in ipairs(WS:GetDescendants()) do
                if o:IsA("ProximityPrompt") and (o.ActionText:lower():find("register") or o.ActionText:lower():find("daftar") or o.ObjectText:lower():find("reception")) then
                    fireproximityprompt(o)
                end
            end
            task.wait(1)
        end
    end)
end })

t2:CreateToggle({ Name = "Auto Periksa & Beri Obat (System Pick)", CurrentValue = false, Callback = function(v)
    autoCheck = v
    task.spawn(function()
        while autoCheck do
            for _, o in ipairs(WS:GetDescendants()) do
                if o:IsA("ProximityPrompt") and (o.ActionText:lower():find("treat") or o.ActionText:lower():find("cure") or o.ActionText:lower():find("examine") or o.ActionText:lower():find("medicine")) then
                    fireproximityprompt(o)
                end
            end
            task.wait(0.5)
        end
    end)
end })

t2:CreateToggle({ Name = "Auto Heal (TP to Patient & Return)", CurrentValue = false, Callback = function(v)
    autoHealLoop = v
    task.spawn(function()
        while autoHealLoop do
            local r = root()
            if r then
                local savedPos = r.CFrame
                for _, obj in ipairs(WS:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name:lower():find("patient") or obj.Name:lower():find("animal") or obj:FindFirstChildOfClass("Humanoid")) then
                        local targetPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                        if targetPart and not Plrs:GetPlayerFromCharacter(obj) then
                            r.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.2)
                            for _, p in ipairs(obj:GetDescendants()) do
                                if p:IsA("ProximityPrompt") then fireproximityprompt(p) end
                            end
                            task.wait(0.3)
                            r.CFrame = savedPos
                            break
                        end
                    end
                end
            end
            task.wait(1.5)
        end
    end)
end })

t2:CreateToggle({ Name = "Auto Direct Give Item / Medicine", CurrentValue = false, Callback = function(v)
    autoTpDirect = v
    task.spawn(function()
        while autoTpDirect do
            local r = root()
            if r then
                for _, tool in ipairs(WS:GetDescendants()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                        tool.Handle.CFrame = r.CFrame
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end })

t2:CreateButton({ Name = "Instant Interact All Prompts", Callback = function()
    for _, p in ipairs(WS:GetDescendants()) do if p:IsA("ProximityPrompt") then p.HoldDuration = 0 end end
end })

t2:CreateButton({ Name = "Fire All Proximity Prompts", Callback = function()
    if fireproximityprompt then
        for _, p in ipairs(WS:GetDescendants()) do if p:IsA("ProximityPrompt") then fireproximityprompt(p) end end
    end
end })

-- ==========================================
-- TAB 3: VISUAL & ESP ANOMALI
-- ==========================================
local t3 = Win:CreateTab("Visual ESP", 4483362458)
local espAnomaly, espPet, espItem, espPlr = false, false, false, false

t3:CreateToggle({ Name = "ESP Anomali / Glitch / Rare Patient", CurrentValue = false, Callback = function(v)
    espAnomaly = v
    task.spawn(function()
        while espAnomaly do
            for _, o in ipairs(WS:GetDescendants()) do
                if o:IsA("Model") and not Plrs:GetPlayerFromCharacter(o) then
                    local nameL = o.Name:lower()
                    if nameL:find("anomaly") or nameL:find("glitch") or nameL:find("rare") or nameL:find("boss") or nameL:find("special") then
                        if not o:FindFirstChild("_anomalyHL") then
                            local h = Instance.new("Highlight", o)
                            h.Name = "_anomalyHL"
                            h.FillColor = Color3.fromRGB(255, 0, 255)
                            h.OutlineColor = Color3.fromRGB(255, 255, 255)
                        end
                    end
                end
            end
            task.wait(1.5)
        end
    end)
end })

t3:CreateToggle({ Name = "ESP Animals / Pets", CurrentValue = false, Callback = function(v)
    espPet = v
    task.spawn(function()
        while espPet do
            for _, o in ipairs(WS:GetDescendants()) do
                if o:IsA("Model") and (o:FindFirstChildOfClass("Humanoid") or o.Name:lower():find("pet") or o.Name:lower():find("animal")) and not Plrs:GetPlayerFromCharacter(o) then
                    if not o:FindFirstChild("_petHL") then
                        local h = Instance.new("Highlight", o)
                        h.Name = "_petHL"
                        h.FillColor = Color3.fromRGB(255, 100, 200)
                    end
                end
            end
            task.wait(1.5)
        end
    end)
end })

t3:CreateToggle({ Name = "ESP Medical Tools & Food", CurrentValue = false, Callback = function(v)
    espItem = v
    task.spawn(function()
        while espItem do
            for _, o in ipairs(WS:GetDescendants()) do
                if o:IsA("Tool") or (o:IsA("BasePart") and (o.Name:lower():find("med") or o.Name:lower():find("food") or o.Name:lower():find("cure"))) then
                    if not o:FindFirstChild("_itemHL") then
                        local h = Instance.new("Highlight", o)
                        h.Name = "_itemHL"
                        h.FillColor = Color3.fromRGB(0, 255, 200)
                    end
                end
            end
            task.wait(1.5)
        end
    end)
end })

t3:CreateToggle({ Name = "Fullbright Lighting", CurrentValue = false, Callback = function(v) Lgt.Brightness = v and 3 or 1 Lgt.GlobalShadows = not v end })
t3:CreateToggle({ Name = "Wide FOV 120", CurrentValue = false, Callback = function(v) WS.CurrentCamera.FieldOfView = v and 120 or 70 end })
t3:CreateButton({ Name = "Remove Atmosphere Fog", Callback = function() for _, o in ipairs(Lgt:GetDescendants()) do if o:IsA("Atmosphere") then o.Density = 0 end end end })

-- ==========================================
-- TAB 4: PLAYER & MOVEMENT
-- ==========================================
local t4 = Win:CreateTab("Player", 4483362458)
local ws, jp, nc, ij = 16, 50, false, false

t4:CreateSlider({ Name = "Custom WalkSpeed", Range = {16, 160}, Increment = 1, CurrentValue = 16, Callback = function(v) ws = v end })
t4:CreateSlider({ Name = "Custom JumpPower", Range = {50, 220}, Increment = 5, CurrentValue = 50, Callback = function(v) jp = v end })
t4:CreateToggle({ Name = "Noclip Walk Through Walls", CurrentValue = false, Callback = function(v) nc = v end })
t4:CreateToggle({ Name = "Infinite Jump Hack", CurrentValue = false, Callback = function(v) ij = v end })

RS.Heartbeat:Connect(function()
    local h = hum()
    if h then
        if ws > 16 then h.WalkSpeed = ws end
        if jp > 50 then h.JumpPower = jp end
    end
end)

RS.Stepped:Connect(function()
    if nc and LP.Character then
        for _, p in ipairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
end)

UIS.JumpRequest:Connect(function()
    if ij then local h = hum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
end)

t4:CreateButton({ Name = "Reset Character Health", Callback = function() local h = hum() if h then h.Health = 0 end end })
t4:CreateButton({ Name = "Toggle Zero Gravity", Callback = function() WS.Gravity = WS.Gravity == 0 and 196.2 or 0 end })

-- ==========================================
-- TAB 5: TELEPORT
-- ==========================================
local t5 = Win:CreateTab("Teleport", 4483362458)
local savedCF = nil
t5:CreateButton({ Name = "TP to Spawn Location", Callback = function() local s = WS:FindFirstChildWhichIsA("SpawnLocation", true) if s then go(s.CFrame) end end })
t5:CreateButton({ Name = "TP High Into Sky", Callback = function() local r = root() if r then r.CFrame = r.CFrame + Vector3.new(0, 200, 0) end end })
t5:CreateButton({ Name = "TP Underground Safe", Callback = function() local r = root() if r then r.CFrame = r.CFrame - Vector3.new(0, 20, 0) end end })
t5:CreateButton({ Name = "Save Current Position", Callback = function() savedCF = root() and root().CFrame end })
t5:CreateButton({ Name = "Load Saved Position", Callback = function() if savedCF then go(savedCF) end end })

-- ==========================================
-- TAB 6: UTILITY & AUDIO
-- ==========================================
local t6 = Win:CreateTab("Utility", 4483362458)
local sid, svol, snd = "6023426915", 1, nil

t6:CreateInput({ Name = "Roblox Audio ID Input", PlaceholderText = "Sound ID", Callback = function(t) sid = t end })
t6:CreateSlider({ Name = "Audio Volume Control", Range = {0.1, 5}, Increment = 0.1, CurrentValue = 1, Callback = function(v) svol = v if snd then snd.Volume = v end end })
t6:CreateToggle({ Name = "Play Sound (On/Off)", CurrentValue = false, Callback = function(s)
    if s then
        if snd then snd:Destroy() end
        local r = root()
        if r then
            snd = Instance.new("Sound", r)
            snd.SoundId = "rbxassetid://" .. tostring(sid)
            snd.Volume = svol
            snd.Looped = true
            snd:Play()
        end
    else
        if snd then snd:Stop() snd:Destroy() snd = nil end
    end
end })

t6:CreateButton({ Name = "Activate Anti-AFK Protector", Callback = function()
    LP.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), WS.CurrentCamera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), WS.CurrentCamera.CFrame)
    end)
end })
t6:CreateButton({ Name = "FPS Boost (Smooth Plastic)", Callback = function() for _, p in ipairs(WS:GetDescendants()) do if p:IsA("BasePart") then p.Material = Enum.Material.SmoothPlastic p.Reflectance = 0 end end end })
t6:CreateButton({ Name = "Unload Hub UI Menu", Callback = function() Lib:Destroy() end })
