--[[ DARKNES HUB - Opah Universe (Malam Bersama Opah & Rumah Opah) ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInput = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local CFG = { 
    walkSpeed = 16, jumpPower = 50, flyEnabled = false, flySpeed = 60, 
    noclip = false, autoFarmFlip = false, autoFarmKunci = false, 
    unlimitedStamina = false, flingPlayer = false, autoRun = false, 
    noHide = false, freezeOpah = false, warningSign = false 
}

local function char() 
    local c = LocalPlayer.Character
    return c, c and c:FindFirstChildOfClass("Humanoid") 
end

-- Fungsi pencarian multi-keyword (Support Rumah Opah & Malam Bersama Opah)
local function findByName(keywords, class) 
    local list = {} 
    local keywordTable = type(keywords) == "table" and keywords or {keywords}
    for _, obj in ipairs(Workspace:GetDescendants()) do 
        local isValidClass = (class and obj:IsA(class)) or (not class and (obj:IsA("BasePart") or obj:IsA("Model")))
        if isValidClass then
            local objName = obj.Name:lower()
            for _, kw in ipairs(keywordTable) do
                if objName:find(kw:lower()) then 
                    table.insert(list, obj) 
                    break 
                end
            end
        end
    end 
    return list 
end

-- Fungsi cari Nenek / Opah
local function getNenek()
    local n = findByName({"nenek", "opah", "grandma"}, "Model") 
    if #n == 0 then n = findByName({"nenek", "opah"}, nil) end
    return n[1]
end

local function tpTo(cf, offsetY) 
    local c = LocalPlayer.Character
    if c and c:FindFirstChild("HumanoidRootPart") then
        c.HumanoidRootPart.CFrame = cf + Vector3.new(0, offsetY or 3, 0) 
    end 
end

local Window = Rayfield:CreateWindow({ 
    Name = "☠ DARKNES HUB - OPAH ☠", 
    LoadingTitle = "Memuat Opah Universe...", 
    ConfigurationSaving = {Enabled = false}, 
    KeySystem = false 
})

-- ===== TAB PLAYER =====
local MainTab = Window:CreateTab("Player", 4483362458)
MainTab:CreateSlider({Name = "WalkSpeed (Bypass)", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) CFG.walkSpeed = v end})
MainTab:CreateSlider({Name = "JumpPower", Range = {50, 300}, Increment = 1, CurrentValue = 50, Callback = function(v) CFG.jumpPower = v end})
MainTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(s) CFG.noclip = s end})

MainTab:CreateToggle({
    Name = "Fly (WASD + Space)", CurrentValue = false, 
    Callback = function(state)
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
                    bv.Velocity = dir * CFG.flySpeed bg.CFrame = cam.CFrame task.wait()
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

-- ===== TAB TELEPORT =====
local TpTab = Window:CreateTab("Teleport", 4483362458)
TpTab:CreateSection("Lokasi Penting")
TpTab:CreateButton({Name = "TP ke Nenek / Opah", Callback = function() local n = getNenek() if n and n:FindFirstChild("HumanoidRootPart") then tpTo(n.HumanoidRootPart.CFrame) end end})
TpTab:CreateButton({Name = "TP ke Dapur (Fixed)", Callback = function() local d = findByName({"kitchen", "dapur"}) if d[1] then tpTo(d[1].CFrame, -3) end end})
TpTab:CreateButton({Name = "TP ke Safe Zone / Spawn", Callback = function() local s = findByName({"safe", "spawn"}) if s[1] then tpTo(s[1].CFrame) end end})
TpTab:CreateButton({Name = "TP ke Pintu Keluar", Callback = function() local e = findByName({"exit", "door", "pintu"}) if e[1] then tpTo(e[1].CFrame) end end})

-- ===== TAB VISUAL =====
local VisTab = Window:CreateTab("Visual (ESP)", 4483362458)
VisTab:CreateSection("Tampilan & Cahaya")

VisTab:CreateToggle({Name = "Fullbright", CurrentValue = false, Callback = function(s)
    local L = game:GetService("Lighting")
    if s then L.Brightness = 3 L.ClockTime = 12 for _, v in pairs(L:GetChildren()) do if v:IsA("PostEffect") then v.Enabled = false end end
    else L.Brightness = 1 L.ClockTime = 0 end
end})
VisTab:CreateToggle({Name = "No Fog (Hilangkan Kabut)", CurrentValue = false, Callback = function(s)
    game:GetService("Lighting").FogEnd = s and 999999 or 100
end})

VisTab:CreateSection("ESP Settings")
local function addESP(obj, color, name)
    if not obj or obj:FindFirstChild("DarknesESP") then return end
    local box = Instance.new("BoxHandleAdornment") box.Name = "DarknesESP" box.Adornee = obj box.Size = obj.Size box.AlwaysOnTop = true box.ZIndex = 5 box.Transparency = 0.4 box.Color3 = color box.Parent = obj
    local bill = Instance.new("BillboardGui") bill.Name = "DarknesLabel" bill.Size = UDim2.new(0, 100, 0, 25) bill.StudsOffset = Vector3.new(0, obj.Size.Y/2 + 1, 0) bill.AlwaysOnTop = true bill.Adornee = obj bill.Parent = obj
    local lbl = Instance.new("TextLabel", bill) lbl.Size = UDim2.new(1, 0, 1, 0) lbl.BackgroundTransparency = 1 lbl.Text = name or obj.Name lbl.TextColor3 = color lbl.TextStrokeTransparency = 0 lbl.Font = Enum.Font.GothamBold lbl.TextSize = 12
end

VisTab:CreateToggle({Name = "ESP Kunci", CurrentValue = false, Callback = function(s)
    if s then local list = findByName({"key", "kunci"}) for _, k in ipairs(list) do addESP(k, Color3.fromRGB(255, 215, 0), "Kunci") end end
end})
VisTab:CreateToggle({Name = "ESP Code", CurrentValue = false, Callback = function(s)
    if s then local list = findByName({"code", "kode"}) for _, c in ipairs(list) do addESP(c, Color3.fromRGB(0, 200, 255), "Code") end end
end})
VisTab:CreateToggle({Name = "ESP Nenek/Opah", CurrentValue = false, Callback = function(s)
    if s then local list = findByName({"nenek", "opah", "grandma"}) for _, n in ipairs(list) do addESP(n, Color3.fromRGB(255, 0, 0), "Opah") end end
end})
VisTab:CreateToggle({Name = "ESP Sendal", CurrentValue = false, Callback = function(s)
    if s then local list = findByName({"sendal", "flip", "sandal"}) for _, sl in ipairs(list) do addESP(sl, Color3.fromRGB(180, 100, 50), "Sendal") end end
end})

-- ===== TAB FARM =====
local FarmTab = Window:CreateTab("Farm", 4483362458)
FarmTab:CreateSection("Auto Collect")

FarmTab:CreateToggle({Name = "Auto Collect Flip Flop", CurrentValue = false, Callback = function(s)
    CFG.autoFarmFlip = s
    task.spawn(function()
        while CFG.autoFarmFlip do
            local c = char()
            if c and c:FindFirstChild("HumanoidRootPart") then
                local startCF = c.HumanoidRootPart.CFrame
                local flips = findByName({"flip", "sendal", "sandal"})
                for _, f in ipairs(flips) do if not CFG.autoFarmFlip then break end c.HumanoidRootPart.CFrame = f.CFrame task.wait(0.05) end
                task.wait(0.2) c.HumanoidRootPart.CFrame = startCF
            end
            task.wait(1)
        end
    end)
end})

FarmTab:CreateToggle({Name = "Auto Farm Kunci + Gembok", CurrentValue = false, Callback = function(s)
    CFG.autoFarmKunci = s
    task.spawn(function()
        while CFG.autoFarmKunci do
            local c = char()
            if c and c:FindFirstChild("HumanoidRootPart") then
                local keys = findByName({"key", "kunci"})
                for _, k in ipairs(keys) do if not CFG.autoFarmKunci then break end c.HumanoidRootPart.CFrame = k.CFrame task.wait(0.1) end
                local locks = findByName({"gembok", "lock"})
                for _, l in ipairs(locks) do if not CFG.autoFarmKunci then break end c.HumanoidRootPart.CFrame = l.CFrame task.wait(0.1) l:FireTouchInterest(c.HumanoidRootPart, l, 0) task.wait(0.05) l:FireTouchInterest(c.HumanoidRootPart, l, 1) end
            end
            task.wait(0.5)
        end
    end)
end})

-- ===== TAB EKSKLUSIF (FITUR BARU) =====
local ExTab = Window:CreateTab("Eksklusif", 4483362458)
ExTab:CreateSection("Fitur Spesial")

ExTab:CreateToggle({Name = "Fling Player (Terbang jika tersentuh)", CurrentValue = false, Callback = function(s)
    CFG.flingPlayer = s
    task.spawn(function()
        while CFG.flingPlayer do
            local c = char()
            if c and c:FindFirstChild("HumanoidRootPart") then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        if (p.Character.HumanoidRootPart.Position - c.HumanoidRootPart.Position).Magnitude < 5 then
                            local bv = Instance.new("BodyVelocity", p.Character.HumanoidRootPart)
                            bv.Velocity = Vector3.new(math.random(-500,500), 500, math.random(-500,500))
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            game:GetService("Debris"):AddItem(bv, 0.5)
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end})

ExTab:CreateToggle({Name = "Auto Run (Kabur saat dilihat Nenek)", CurrentValue = false, Callback = function(s)
    CFG.autoRun = s
    task.spawn(function()
        while CFG.autoRun do
            local c = char()
            local n = getNenek()
            if c and n and n:FindFirstChild("HumanoidRootPart") then
                if (n.HumanoidRootPart.Position - c.HumanoidRootPart.Position).Magnitude < 35 then
                    local startCF = c.HumanoidRootPart.CFrame
                    local safe = findByName({"safe", "spawn"})
                    if safe[1] then
                        c.HumanoidRootPart.CFrame = safe[1].CFrame + Vector3.new(0,5,0)
                        task.wait(3)
                        c.HumanoidRootPart.CFrame = startCF
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end})

ExTab:CreateToggle({Name = "Unlimited Stamina", CurrentValue = false, Callback = function(s)
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
end})

ExTab:CreateToggle({Name = "No Hide (Lemari tidak bisa dibuka)", CurrentValue = false, Callback = function(s)
    CFG.noHide = s
    if s then
        local hides = findByName({"hide", "lemari"})
        for _, obj in ipairs(hides) do for _, desc in ipairs(obj:GetDescendants()) do if desc:IsA("ProximityPrompt") then desc.Enabled = false end end end
    end
end})

ExTab:CreateToggle({Name = "Freeze Opah / Nenek", CurrentValue = false, Callback = function(s)
    CFG.freezeOpah = s
    local n = getNenek()
    if n then
        local hum = n:FindFirstChildOfClass("Humanoid") local hrp = n:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            hum.WalkSpeed = s and 0 or 16 hum.JumpPower = s and 0 or 50
            hrp.Anchored = s
        end
    end
end})

-- Fitur Warning Sign
local warningGui = Instance.new("ScreenGui")
warningGui.Name = "OpahWarning"
warningGui.Parent = game:GetService("CoreGui")
warningGui.Enabled = false

local warningText = Instance.new("TextLabel")
warningText.Size = UDim2.new(0, 100, 0, 100)
warningText.Position = UDim2.new(0.5, -50, 0, 50)
warningText.BackgroundTransparency = 1
warningText.Text = "!"
warningText.TextColor3 = Color3.new(1,1,1)
warningText.Font = Enum.Font.GothamBold
warningText.TextSize = 80
warningText.TextStrokeTransparency = 0
warningText.TextStrokeColor3 = Color3.new(0,0,0)
warningText.Parent = warningGui

ExTab:CreateToggle({Name = "Warning Sign (Indikator Jarak)", CurrentValue = false, Callback = function(s)
    CFG.warningSign = s
    warningGui.Enabled = s
end})

RunService.RenderStepped:Connect(function()
    if CFG.warningSign then
        local c = char()
        local n = getNenek()
        if c and n and n:FindFirstChild("HumanoidRootPart") then
            local dist = (n.HumanoidRootPart.Position - c.HumanoidRootPart.Position).Magnitude
            if dist > 100 then warningText.TextColor3 = Color3.fromRGB(255, 255, 255)
            elseif dist > 40 then warningText.TextColor3 = Color3.fromRGB(255, 255, 0)
            else warningText.TextColor3 = Color3.fromRGB(255, 0, 0) end
        end
    end
end)
