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
-- TAB 1: VISUAL & ESP ANOMALI
-- ==========================================
local t1 = Win:CreateTab("Visual ESP", 4483362458)
local espAnomaly, espPet, espItem, espPlr, fbOn = false, false, false, false

t1:CreateToggle({ Name = "ESP Anomali / Glitch / Rare Patient", CurrentValue = false, Callback = function(v)
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

t1:CreateToggle({ Name = "ESP Animals / Pets (Blue)", CurrentValue = false, Callback = function(v)
    espPet = v
    task.spawn(function()
        while espPet do
            for _, o in ipairs(WS:GetDescendants()) do
                if o:IsA("Model") and (o:FindFirstChildOfClass("Humanoid") or o.Name:lower():find("pet") or o.Name:lower():find("animal")) and not Plrs:GetPlayerFromCharacter(o) then
                    if not o:FindFirstChild("_petHL") then
                        local h = Instance.new("Highlight", o)
                        h.Name = "_petHL"
                        h.FillColor = Color3.fromRGB(0, 150, 255)
                    end
                end
            end
            task.wait(1.5)
        end
    end)
end })

t1:CreateToggle({ Name = "ESP Players (Green)", CurrentValue = false, Callback = function(v)
    espPlr = v
    task.spawn(function()
        while espPlr do
            for _, p in ipairs(Plrs:GetPlayers()) do
                if p ~= LP and p.Character and not p.Character:FindFirstChild("_plrHL") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "_plrHL"
                    h.FillColor = Color3.fromRGB(0, 255, 0)
                end
            end
            task.wait(1.5)
        end
    end)
end })

t1:CreateToggle({ Name = "Fullbright Lighting", CurrentValue = false, Callback = function(v)
    fbOn = v
    Lgt.Brightness = v and 3 or 1
    Lgt.GlobalShadows = not v
end })

t1:CreateParagraph({ Title = "Doctor Timer Status", Content = "Checking doctor arrival time automatically..." })
task.spawn(function()
    while true do
        for _, obj in ipairs(WS:GetDescendants()) do
            if obj.Name:lower():find("timer") or obj.Name:lower():find("doctor") then
                break
            end
        end
        task.wait(3)
    end
end)

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

-- ==========================================
-- TAB 3: EXCLUSIVE (SAFE NOCLIP & COFFEE)
-- ==========================================
local t3 = Win:CreateTab("Exclusive", 4483362458)
local safeNoclip, autoCoffee = false, false

t3:CreateToggle({ Name = "Safe Noclip (Walls Only / No Floor Fall)", CurrentValue = false, Callback = function(v)
    safeNoclip = v
end })

RS.Stepped:Connect(function()
    if safeNoclip and LP.Character then
        local r = root()
        for _, p in ipairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") then
                -- Biarkan bagian kaki bawah tetap Colide agar tidak tembus lantai jatuh ke void
                if p.Name ~= "HumanoidRootPart" and p.Name ~= "LeftFoot" and p.Name ~= "RightFoot" and p.Name ~= "LowerTorso" then
                    p.CanCollide = false
                end
            end
        end
    end
end)

t3:CreateToggle({ Name = "Auto Ambil Kopi (Teleport when ready)", CurrentValue = false, Callback = function(v)
    autoCoffee = v
    task.spawn(function()
        while autoCoffee do
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj.Name:lower():find("coffee") or obj.Name:lower():find("kopi") then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                    local r = root()
                    if handle and r then
                        r.CFrame = handle.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.3)
                        for _, p in ipairs(obj:GetDescendants()) do
                            if p:IsA("ProximityPrompt") then fireproximityprompt(p) end
                        end
                    end
                end
            end
            task.wait(3)
        end
    end)
end })

t3:CreateButton({ Name = "Instant Skip Doctor Dialogue", Callback = function()
    for _, gui in ipairs(LP.PlayerGui:GetDescendants()) do
        if gui:IsA("TextButton") and (gui.Text:lower():find("skip") or gui.Text:lower():find("next")) then
            for _, conn in ipairs(getconnections(gui.MouseButton1Click)) do
                conn:Fire()
            end
        end
    end
end })

-- ==========================================
-- TAB 4: TELEPORT & UTILITY
-- ==========================================
local t4 = Win:CreateTab("Utility", 4483362458)
local sid, svol, snd = "6023426915", 1, nil

t4:CreateInput({ Name = "Roblox Audio ID", PlaceholderText = "Sound ID", Callback = function(t) sid = t end })
t4:CreateSlider({ Name = "Volume", Range = {0.1, 5}, Increment = 0.1, CurrentValue = 1, Callback = function(v) svol = v if snd then snd.Volume = v end end })
t4:CreateToggle({ Name = "Play Sound", CurrentValue = false, Callback = function(s)
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

t4:CreateButton({ Name = "Chat Owner via Telegram (Copy Link)", Callback = function()
    if setclipboard then
        setclipboard("https://t.me/ManzXDzx")
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "DARKNES HUB", Text = "Telegram link copied to clipboard!", Duration = 5 })
    end
end })

t4:CreateButton({ Name = "Activate Anti-AFK Protector", Callback = function()
    LP.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), WS.CurrentCamera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), WS.CurrentCamera.CFrame)
    end)
end })

t4:CreateButton({ Name = "Unload UI Hub", Callback = function() Lib:Destroy() end })
