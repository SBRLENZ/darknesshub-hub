local Plrs = game:GetService("Players")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local Lgt = game:GetService("Lighting")
local LP = Plrs.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Hapus UI lama jika ada
if CoreGui:FindFirstChild("DarknesCustomHub") then
    CoreGui.DarknesCustomHub:Destroy()
end

-- ScreenGui Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarknesCustomHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 1. Floating Toggle Button (Logo D / Bisa Digeser)
local FloatBtn = Instance.new("ImageButton")
FloatBtn.Name = "FloatToggle"
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0, 30, 0, 200)
FloatBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
FloatBtn.Image = "rbxassetid://0"
FloatBtn.Active = true
FloatBtn.Draggable = true
FloatBtn.Parent = ScreenGui

Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 12)
local FloatStroke = Instance.new("UIStroke", FloatBtn)
FloatStroke.Color = Color3.fromRGB(0, 160, 255)
FloatStroke.Transparency = 0.2
FloatStroke.Thickness = 2

local FloatText = Instance.new("TextLabel")
FloatText.Size = UDim2.new(1, 0, 1, 0)
FloatText.BackgroundTransparency = 1
FloatText.TextColor3 = Color3.fromRGB(0, 180, 255)
FloatText.TextSize = 20
FloatText.Font = Enum.Font.GothamBold
FloatText.Text = "D"
FloatText.Parent = FloatBtn

-- 2. Kotak Besar Utama (Layout ala Rayfield: Sidebar Kiri, Konten Kanan)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainWindow"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 14, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 140, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.4

local UIGradient = Instance.new("UIGradient", MainFrame)
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 45, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 18))
})
UIGradient.Rotation = 90

-- Topbar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 350, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(240, 245, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "DARKNES HUB | Animal Hospital"
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 2.5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.Parent = TopBar
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 35, 0, 35)
MinBtn.Position = UDim2.new(1, -75, 0, 2.5)
MinBtn.BackgroundTransparency = 1
MinBtn.TextColor3 = Color3.fromRGB(180, 200, 220)
MinBtn.TextSize = 18
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "-"
MinBtn.Parent = TopBar

local isOpen = true
MinBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    local targetSize = isOpen and UDim2.new(0, 580, 0, 380) or UDim2.new(0, 580, 0, 40)
    TS:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

local menuVisible = true
FloatBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    if menuVisible then
        MainFrame.Visible = true
        TS:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 580, 0, 380)}):Play()
    else
        local tw = TS:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        tw:Play()
        tw.Completed:Connect(function() if not menuVisible then MainFrame.Visible = false end end)
    end
end)

-- Animasi Buka Pertama Kali
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TS:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 580, 0, 380)}):Play()

-- Sidebar di Kiri
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 140, 1, -50)
Sidebar.Position = UDim2.new(0, 10, 0, 45)
Sidebar.BackgroundTransparency = 1
Sidebar.CanvasSize = UDim2.new(0, 0, 1, 0)
Sidebar.ScrollBarThickness = 2
Sidebar.Parent = MainFrame

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Padding = UDim.new(0, 6)

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -165, 1, -50)
ContentContainer.Position = UDim2.new(0, 155, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local firstTab = true
local function CreateTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 32)
    tabBtn.BackgroundColor3 = Color3.fromRGB(20, 26, 42)
    tabBtn.TextColor3 = Color3.fromRGB(180, 205, 235)
    tabBtn.TextSize = 13
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.Text = name
    tabBtn.Parent = Sidebar
    
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.CanvasSize = UDim2.new(0, 0, 3, 0)
    tabContent.ScrollBarThickness = 3
    tabContent.Visible = firstTab
    tabContent.Parent = ContentContainer
    
    local contentLayout = Instance.new("UIListLayout", tabContent)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    
    if firstTab then
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        firstTab = false
    end
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, child in ipairs(ContentContainer:GetChildren()) do
            if child:IsA("ScrollingFrame") then child.Visible = false end
        end
        for _, btn in ipairs(Sidebar:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(20, 26, 42)
                btn.TextColor3 = Color3.fromRGB(180, 205, 235)
            end
        end
        tabContent.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    return tabContent
end

local function AddToggle(tab, text, callback)
    local tBtn = Instance.new("TextButton")
    tBtn.Size = UDim2.new(1, -5, 0, 35)
    tBtn.BackgroundColor3 = Color3.fromRGB(18, 24, 38)
    tBtn.TextColor3 = Color3.fromRGB(220, 230, 245)
    tBtn.TextSize = 12
    tBtn.Font = Enum.Font.GothamMedium
    tBtn.Text = text .. ": [ OFF ]"
    tBtn.TextXAlignment = Enum.TextXAlignment.Left
    tBtn.Parent = tab
    
    local pad = Instance.new("UIPadding", tBtn)
    pad.PaddingLeft = UDim.new(0, 10)
    
    Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 6)
    
    local state = false
    tBtn.MouseButton1Click:Connect(function()
        state = not state
        tBtn.Text = text .. ": [ " .. (state and "ON" .. " ]" or "OFF" .. " ]")
        tBtn.TextColor3 = state and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(220, 230, 245)
        callback(state)
    end)
end

-- Floating Ping & FPS Widget
local pingGui = Instance.new("ScreenGui")
pingGui.Name = "DarknesPingGui"
pingGui.Parent = CoreGui
pingGui.Enabled = true

local pingFrame = Instance.new("Frame")
pingFrame.Size = UDim2.new(0, 160, 0, 35)
pingFrame.Position = UDim2.new(0, 50, 0, 50)
pingFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
pingFrame.BorderSizePixel = 0
pingFrame.Active = true
pingFrame.Draggable = true
pingFrame.Parent = pingGui

Instance.new("UICorner", pingFrame).CornerRadius = UDim.new(0, 6)
local pStroke = Instance.new("UIStroke", pingFrame)
pStroke.Color = Color3.fromRGB(0, 150, 255)
pStroke.Thickness = 1.5

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(1, 0, 1, 0)
pingLabel.BackgroundTransparency = 1
pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
pingLabel.TextSize = 13
pingLabel.Font = Enum.Font.Code
pingLabel.Text = "Ping: ...ms | FPS: ..."
pingLabel.Parent = pingFrame

local statsConn = RS.RenderStepped:Connect(function()
    local pVal = math.floor(LP:GetNetworkPing() * 1000 + 0.5)
    local fVal = math.floor(1 / RS.RenderStepped:Wait())
    pingLabel.Text = string.format("Ping: %dms | FPS: %d", pVal, fVal)
end)

-- Tabs
local tVisual = CreateTab("Visual & ESP")
local tFarm = CreateTab("Auto Farm")
local tEx = CreateTab("Exclusive")
local tUtil = CreateTab("Utility")

local function root() return LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") end
local function hum() return LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") end
local function match(str, list)
    if not str then return false end
    local low = str:lower()
    for _, k in ipairs(list) do
        if low:find(k) then return true end
    end
    return false
end

local kwAnomali = {"anomaly", "anomali", "glitch", "candle", "monster", "ghost", "boss", "shock", "fire"}
local kwPasien  = {"patient", "animal", "pet"}
local kwTugas   = {"board", "photo", "computer", "printer", "clip", "file"}

-- Visual Tab
AddToggle(tVisual, "ESP Anomaly (Red)", function(v)
    task.spawn(function()
        while v do
            for _, o in ipairs(WS:GetDescendants()) do
                if (o:IsA("Model") or o:IsA("BasePart")) and not Plrs:GetPlayerFromCharacter(o) then
                    if match(o.Name, kwAnomali) and not o:FindFirstChild("_espAnom") then
                        local h = Instance.new("Highlight", o)
                        h.Name = "_espAnom"
                        h.FillColor = Color3.fromRGB(255, 0, 0)
                    end
                end
            end
            task.wait(1.5)
        end
    end)
end)

AddToggle(tVisual, "ESP Patient (Blue)", function(v)
    task.spawn(function()
        while v do
            for _, o in ipairs(WS:GetDescendants()) do
                if o:IsA("Model") and not Plrs:GetPlayerFromCharacter(o) then
                    if (match(o.Name, kwPasien) or o:FindFirstChildOfClass("Humanoid")) and not o:FindFirstChild("_espPat") then
                        local h = Instance.new("Highlight", o)
                        h.Name = "_espPat"
                        h.FillColor = Color3.fromRGB(0, 150, 255)
                    end
                end
            end
            task.wait(1.5)
        end
    end)
end)

AddToggle(tVisual, "Fullbright", function(v)
    Lgt.Brightness = v and 3 or 1
    Lgt.GlobalShadows = not v
end)

AddToggle(tVisual, "Ping Widget On/Off", function(v)
    pingGui.Enabled = v
end)

-- Auto Farm Tab
AddToggle(tFarm, "Auto Service & Shock Anomaly", function(v)
    task.spawn(function()
        while v do
            local r = root()
            if r then
                local anomalyFound = false
                for _, obj in ipairs(WS:GetDescendants()) do
                    if not v then break end
                    if (obj:IsA("Model") or obj:IsA("BasePart")) and match(obj.Name, kwAnomali) and not Plrs:GetPlayerFromCharacter(obj) then
                        local target = obj:IsA("Model") and (obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")) or obj
                        if target and target:IsA("BasePart") then
                            anomalyFound = true
                            r.CFrame = target.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.2)
                            for _, pr in ipairs(obj:GetDescendants()) do
                                if pr:IsA("ProximityPrompt") and fireproximityprompt then fireproximityprompt(pr) end
                            end
                            task.wait(0.4)
                            break
                        end
                    end
                end

                if not anomalyFound then
                    for _, obj in ipairs(WS:GetDescendants()) do
                        if not v then break end
                        if match(obj.Name, kwTugas) or obj:IsA("ProximityPrompt") then
                            local prompt = obj:IsA("ProximityPrompt") and obj or obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                            local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")) or obj.Parent)
                            if prompt and part and part:IsA("BasePart") then
                                r.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                                task.wait(0.3)
                                if fireproximityprompt then fireproximityprompt(prompt) end
                                task.wait(0.5)
                            end
                        end
                    end
                end
            end
            task.wait(1)
        end
    end)
end)

AddToggle(tFarm, "Infinite Sanity (Vexus)", function(v)
    task.spawn(function()
        while v do
            pcall(function()
                for _, stat in ipairs(LP:GetDescendants()) do
                    if stat.Name:lower():find("sanity") or stat.Name:lower():find("fear") then
                        if stat:IsA("NumberValue") or stat:IsA("IntValue") then stat.Value = 100 end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)

AddToggle(tFarm, "Auto Revive (Vexus)", function(v)
    task.spawn(function()
        while v do
            pcall(function()
                local h = hum()
                if h and h.Health <= 0 then
                    local char = LP.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local pos = char.HumanoidRootPart.CFrame
                        LP.Character:BreakJoints()
                        LP.CharacterAdded:Wait()
                        task.wait(0.5)
                        if root() then root().CFrame = pos end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end)

-- Exclusive Tab
AddToggle(tEx, "Instant Interact", function(v)
    task.spawn(function()
        while v do
            for _, p in ipairs(WS:GetDescendants()) do
                if p:IsA("ProximityPrompt") then p.HoldDuration = 0 end
            end
            task.wait(1)
        end
    end)
end)

-- Utility Tab
local unBtn = Instance.new("TextButton")
unBtn.Size = UDim2.new(1, -5, 0, 35)
unBtn.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
unBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
unBtn.TextSize = 13
unBtn.Font = Enum.Font.GothamBold
unBtn.Text = "Unload Darknes Hub"
unBtn.Parent = tUtil
Instance.new("UICorner", unBtn).CornerRadius = UDim.new(0, 6)
unBtn.MouseButton1Click:Connect(function()
    if pingGui then pingGui:Destroy() end
    if statsConn then statsConn:Disconnect() end
    ScreenGui:Destroy()
end)

print("DARKNES HUB Loaded Successfully!")
