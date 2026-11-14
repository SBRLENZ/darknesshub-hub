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

-- 2. Kotak Besar Utama (Layout ala Vexus: Sidebar Kiri, Konten Kanan)
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
TitleLabel.Size = UDim2.new(0, 380, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(240, 245, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "DARKNES HUB | Rumah Opah"
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

local function AddButton(tab, text, callback)
    local bBtn = Instance.new("TextButton")
    bBtn.Size = UDim2.new(1, -5, 0, 35)
    bBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    bBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    bBtn.TextSize = 12
    bBtn.Font = Enum.Font.GothamBold
    bBtn.Text = text
    bBtn.Parent = tab
    
    Instance.new("UICorner", bBtn).CornerRadius = UDim.new(0, 6)
    bBtn.MouseButton1Click:Connect(callback)
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
local tMain = CreateTab("Main Items")
local tVisual = CreateTab("Visual")
local tUtil = CreateTab("Utility")

local function root() return LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") end
local function match(str, list)
    if not str then return false end
    local low = str:lower()
    for _, k in ipairs(list) do
        if low:find(k) then return true end
    end
    return false
end

-- Keywords untuk Rumah Opah
local kwKey = {"key", "kunci"}
local kwFlipFlop = {"flip", "flop", "sandal", "shoe", "slippers"}
local kwCode = {"code", "password", "sandi", "pin"}

-- Fungsi Bring Items (Teleport item ke Player)
local function bringItems(keywords)
    local r = root()
    if not r then return end
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            if match(obj.Name, keywords) then
                local part = obj:IsA("Model") and (obj:PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                if part and part:IsA("BasePart") then
                    part.CFrame = r.CFrame + Vector3.new(0, 2, 0)
                end
            end
        end
    end
end

-- Main Items Tab
AddButton(tMain, "Bring All Keys", function()
    bringItems(kwKey)
end)

AddButton(tMain, "Bring All Flip Flops", function()
    bringItems(kwFlipFlop)
end)

AddButton(tMain, "Bring Code", function()
    bringItems(kwCode)
end)

-- Visual Tab
AddToggle(tVisual, "Fullbright", function(v)
    Lgt.Brightness = v and 3 or 1
    Lgt.GlobalShadows = not v
end)

AddToggle(tVisual, "Ping Widget On/Off", function(v)
    pingGui.Enabled = v
end)

-- Utility Tab
AddToggle(tUtil, "Instant Interact", function(v)
    task.spawn(function()
        while v do
            for _, p in ipairs(WS:GetDescendants()) do
                if p:IsA("ProximityPrompt") then p.HoldDuration = 0 end
            end
            task.wait(1)
        end
    end)
end)

local unBtn = Instance.new("TextButton")
unBtn.Size = UDim2.new(1, -5, 0, 35)
unBtn.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
unBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
unBtn.TextSize = 13
unBtn.Font = Enum.Font.GothamBold
unBtn.Text = "Unload Hub"
unBtn.Parent = tUtil
Instance.new("UICorner", unBtn).CornerRadius = UDim.new(0, 6)
unBtn.MouseButton1Click:Connect(function()
    if pingGui then pingGui:Destroy() end
    if statsConn then statsConn:Disconnect() end
    ScreenGui:Destroy()
end)

print("DARKNES HUB | Rumah Opah Loaded Successfully!")
