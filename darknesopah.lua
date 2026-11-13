--[[ DARKNES HUB - OPAH UNIVERSE (EXCLUSIVE COMPLETE VERSION) ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local CFG = {
    WalkSpeed = 16,
    JumpPower = 50,
    Noclip = false,
    Fly = false,
    FlySpeed = 50,
    Fullbright = false,
    AutoCollect = false,
    AutoFarmGembok = false,
    InfiniteStamina = false,
    NoHide = false,
    WarningSign = false,
    FlingOpah = false
}

local function getChar()
    local char = LocalPlayer.Character
    return char, char and char:FindFirstChildOfClass("Humanoid"), char and char:FindFirstChild("HumanoidRootPart")
end

local function findAll(names)
    local results = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        for _, name in ipairs(names) do
            if obj.Name:lower():find(name:lower()) then
                table.insert(results, obj)
                break
            end
        end
    end
    return results
end

local function getOpah()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("opah") or obj.Name:lower():find("nenek") or obj.Name:lower():find("grandma")) then
            if obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") then
                return obj
            end
        end
    end
    return nil
end

local Window = Rayfield:CreateWindow({
    Name = "☠ DARKNES HUB - OPAH EXCLUSIVE ☠",
    LoadingTitle = "Memuat Fitur Eksklusif...",
    LoadingSubtitle = "by DARKNES-Hub",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- // TAB 1: PLAYER
local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 250},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v) CFG.WalkSpeed = v end
})
PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 350},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(v) CFG.JumpPower = v end
})
PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(s) CFG.Noclip = s end
})
PlayerTab:CreateToggle({
    Name = "Fly (WASD + Space/Shift)",
    CurrentValue = false,
    Callback = function(state)
        CFG.Fly = state
        local char, _, hrp = getChar()
        if not hrp then return end
        if state then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Name = "DarknesFlyVel"
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.zero
            local bg = Instance.new("BodyGyro", hrp)
            bg.Name = "DarknesFlyGyro"
            bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bg.P = 1000
            task.spawn(function()
                while CFG.Fly and hrp.Parent do
                    local cam = Workspace.CurrentCamera
                    local moveDir = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                    bv.Velocity = moveDir * CFG.FlySpeed
                    bg.CFrame = cam.CFrame
                    task.wait()
                end
                if hrp:FindFirstChild("DarknesFlyVel") then hrp.DarknesFlyVel:Destroy() end
                if hrp:FindFirstChild("DarknesFlyGyro") then hrp.DarknesFlyGyro:Destroy() end
            end)
        else
            if hrp:FindFirstChild("DarknesFlyVel") then hrp.DarknesFlyVel:Destroy() end
            if hrp:FindFirstChild("DarknesFlyGyro") then hrp.DarknesFlyGyro:Destroy() end
        end
    end
})

RunService.Stepped:Connect(function()
    local _, hum, hrp = getChar()
    if hum then
        if hum.WalkSpeed ~= CFG.WalkSpeed then hum.WalkSpeed = CFG.WalkSpeed end
        if hum.JumpPower ~= CFG.JumpPower then hum.JumpPower = CFG.JumpPower end
    end
    if CFG.Noclip and hrp then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- // TAB 2: TELEPORT
local TpTab = Window:CreateTab("Teleport", 4483362458)
TpTab:CreateButton({
    Name = "TP ke Posisi Opah",
    Callback = function()
        local opah = getOpah()
        local _, _, hrp = getChar()
        if opah and hrp then
            local targetPart = opah:FindFirstChild("HumanoidRootPart") or opah:FindFirstChildWhichIsA("BasePart")
            if targetPart then hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0) end
        end
    end
})
TpTab:CreateButton({
    Name = "TP ke Area Dapur / Spawn",
    Callback = function()
        local spots = findAll({"kitchen", "dapur", "spawn", "safe"})
        local _, _, hrp = getChar()
        if #spots > 0 and hrp then
            local part = spots[1]:IsA("Model") and spots[1].PrimaryPart or spots[1]
            if part and part:IsA("BasePart") then hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0) end
        end
    end
})

-- // TAB 3: VISUAL / ESP
local VisualTab = Window:CreateTab("Visual", 4483362458)
VisualTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Callback = function(s)
        local lighting = game:GetService("Lighting")
        lighting.Brightness = s and 3 or 1
        lighting.ClockTime = s and 12 or 0
        lighting.GlobalShadows = not s
    end
})

local function applyESP(obj, color, labelText)
    if not obj or obj:FindFirstChild("DarknesESPBox") then return end
    local base = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
    if not base or not base:IsA("BasePart") then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Name = "DarknesESPBox"
    box.Adornee = base
    box.Size = base.Size + Vector3.new(0.2, 0.2, 0.2)
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Transparency = 0.4
    box.Color3 = color
    box.Parent = base

    local bill = Instance.new("BillboardGui")
    bill.Name = "DarknesESPText"
    bill.Size = UDim2.new(0, 100, 0, 25)
    bill.StudsOffset = Vector3.new(0, base.Size.Y / 2 + 1, 0)
    bill.AlwaysOnTop = true
    bill.Adornee = base
    bill.Parent = base

    local txt = Instance.new("TextLabel", bill)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = labelText or obj.Name
    txt.TextColor3 = color
    txt.TextStrokeTransparency = 0
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 12
end

VisualTab:CreateToggle({
    Name = "ESP Kunci / Key",
    CurrentValue = false,
    Callback = function(s)
        if s then
            for _, item in ipairs(findAll({"key", "kunci"})) do
                applyESP(item, Color3.fromRGB(255, 215, 0), "Kunci")
            end
        end
    end
})

VisualTab:CreateToggle({
    Name = "ESP Opah / Nenek",
    CurrentValue = false,
    Callback = function(s)
        if s then
            local opah = getOpah()
            if opah then applyESP(opah, Color3.fromRGB(255, 0, 0), "OPAH") end
        end
    end
})

-- // TAB 4: FARM
local FarmTab = Window:CreateTab("Farm", 4483362458)
FarmTab:CreateToggle({
    Name = "Auto Collect Kunci & Item",
    CurrentValue = false,
    Callback = function(s)
        CFG.AutoCollect = s
        task.spawn(function()
            while CFG.AutoCollect do
                local _, _, hrp = getChar()
                if hrp then
                    for _, item in ipairs(findAll({"key", "kunci", "item", "flip", "sandal"})) do
                        if not CFG.AutoCollect then break end
                        local part = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or item
                        if part and part:IsA("BasePart") then
                            hrp.CFrame = part.CFrame
                            task.wait(0.1)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
})

-- // TAB 5: EKSKLUSIF (FITUR SPESIAL OPAH)
local ExTab = Window:CreateTab("Eksklusif", 4483362458)

ExTab:CreateToggle({
    Name = "Unlimited Stamina",
    CurrentValue = false,
    Callback = function(s)
        CFG.InfiniteStamina = s
        task.spawn(function()
            while CFG.InfiniteStamina do
                local char = getChar()
                if char then
                    for _, v in ipairs(char:GetDescendants()) do
                        if v:IsA("ValueBase") and v.Name:lower():find("stamina") then
                            v.Value = 9999
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})

ExTab:CreateToggle({
    Name = "No Hide Prompt (Disable Lemari Interaksi)",
    CurrentValue = false,
    Callback = function(s)
        CFG.NoHide = s
        if s then
            for _, obj in ipairs(findAll({"hide", "lemari"})) do
                for _, desc in ipairs(obj:GetDescendants()) do
                    if desc:IsA("ProximityPrompt") then desc.Enabled = false end
                end
            end
        end
    end
})

ExTab:CreateToggle({
    Name = "Freeze / Lock Opah Movement",
    CurrentValue = false,
    Callback = function(s)
        local opah = getOpah()
        if opah then
            local hum = opah:FindFirstChildOfClass("Humanoid")
            local hrp = opah:FindFirstChild("HumanoidRootPart")
            if hum then hum.WalkSpeed = s and 0 or 16 hum.JumpPower = s and 0 or 50 end
            if hrp then hrp.Anchored = s end
        end
    end
})

local warningGui = Instance.new("ScreenGui", CoreGui)
warningGui.Name = "OpahWarningGui"
warningGui.Enabled = false
local warningLabel = Instance.new("TextLabel", warningGui)
warningLabel.Size = UDim2.new(0, 120, 0, 60)
warningLabel.Position = UDim2.new(0.5, -60, 0, 20)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "⚠ OPAH DEKAT!"
warningLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
warningLabel.TextScaled = true
warningLabel.Font = Enum.Font.GothamBold
warningLabel.TextStrokeTransparency = 0

ExTab:CreateToggle({
    Name = "Danger Warning Indicator (Peringatan Jarak Opah)",
    CurrentValue = false,
    Callback = function(s)
        CFG.WarningSign = s
        warningGui.Enabled = s
    end
})

RunService.RenderStepped:Connect(function()
    if CFG.WarningSign then
        local _, _, hrp = getChar()
        local opah = getOpah()
        if hrp and opah and opah:FindFirstChild("HumanoidRootPart") then
            local dist = (opah.HumanoidRootPart.Position - hrp.Position).Magnitude
            if dist <= 25 then
                warningLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                warningLabel.Text = "BAHAYA"
            elseif dist <= 60 then
                warningLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                warningLabel.Text = "Hati-hati"
            else
                warningLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                warningLabel.Text = "Aman"
            end
        end
    end
end
