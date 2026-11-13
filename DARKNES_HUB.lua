--[[ DARKNES HUB - MAIN LOADER & UI LIBRARY ]]
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- ==========================================
-- 1. UI LIBRARY (Disimpan di getgenv)
-- ==========================================
local UI_Lib = {}
UI_Lib.__index = UI_Lib

local Theme = {
    Background = Color3.fromRGB(20, 20, 20),
    Sidebar = Color3.fromRGB(12, 12, 12),
    Accent = Color3.fromRGB(138, 43, 226),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(150, 150, 150),
    Border = Color3.fromRGB(60, 60, 60)
}

function UI_Lib.new(titleText, logoId)
    local self = setmetatable({}, UI_Lib)
    self.Tabs = {}
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "DARKNES_HUB_UI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = CoreGui

    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 600, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    self.MainFrame.BackgroundColor3 = Theme.Background
    self.MainFrame.BorderSizePixel = 1
    self.MainFrame.BorderColor3 = Theme.Border
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    self.MainFrame.Parent = self.ScreenGui
    Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", self.MainFrame)
    stroke.Color = Theme.Border
    stroke.Thickness = 1.5
    stroke.Transparency = 0.5

    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, 140, 1, 0)
    self.Sidebar.BackgroundColor3 = Theme.Sidebar
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.MainFrame
    Instance.new("UICorner", self.Sidebar).CornerRadius = UDim.new(0, 8)
    
    local sidebarFix = Instance.new("Frame", self.Sidebar)
    sidebarFix.Size = UDim2.new(0, 10, 1, 0)
    sidebarFix.Position = UDim2.new(1, -10, 0, 0)
    sidebarFix.BackgroundColor3 = Theme.Sidebar
    sidebarFix.BorderSizePixel = 0
    sidebarFix.ZIndex = 2

    self.LogoBox = Instance.new("Frame")
    self.LogoBox.Size = UDim2.new(1, -20, 0, 100)
    self.LogoBox.Position = UDim2.new(0, 10, 0, 10)
    self.LogoBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.LogoBox.BackgroundTransparency = 0.5
    self.LogoBox.BorderSizePixel = 1
    self.LogoBox.BorderColor3 = Theme.Accent
    self.LogoBox.ZIndex = 3
    self.LogoBox.Parent = self.Sidebar
    Instance.new("UICorner", self.LogoBox).CornerRadius = UDim.new(0, 6)
    
    local logoStroke = Instance.new("UIStroke", self.LogoBox)
    logoStroke.Color = Theme.Accent
    logoStroke.Thickness = 1
    logoStroke.Transparency = 0.6

    local logoImg = Instance.new("ImageLabel")
    logoImg.Size = UDim2.new(1, -10, 1, -10)
    logoImg.Position = UDim2.new(0, 5, 0, 5)
    logoImg.BackgroundTransparency = 1
    logoImg.Image = logoId or "rbxassetid://0"
    logoImg.ScaleType = Enum.ScaleType.Fit
    logoImg.Parent = self.LogoBox

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Position = UDim2.new(0, 0, 1, 5)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = Theme.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.Parent = self.LogoBox

    self.TabContainer = Instance.new("ScrollingFrame")
    self.TabContainer.Size = UDim2.new(1, -20, 1, -130)
    self.TabContainer.Position = UDim2.new(0, 10, 0, 120)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.ScrollBarThickness = 2
    self.TabContainer.ScrollBarImageColor3 = Theme.Accent
    self.TabContainer.ZIndex = 3
    self.TabContainer.Parent = self.Sidebar

    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Size = UDim2.new(1, -150, 1, -20)
    self.ContentContainer.Position = UDim2.new(0, 145, 0, 10)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.Parent = self.MainFrame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -30, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Theme.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 5
    closeBtn.Parent = self.MainFrame
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)
    
    closeBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)

    return self
end

function UI_Lib:AddTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 30)
    tabBtn.Position = UDim2.new(0, 0, 0, #self.Tabs * 35)
    tabBtn.BackgroundColor3 = Theme.Sidebar
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = "  " .. name
    tabBtn.TextColor3 = Theme.SubText
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.TextSize = 13
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.ZIndex = 3
    tabBtn.Parent = self.TabContainer

    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 2, 1, 0)
    line.BackgroundColor3 = Theme.Accent
    line.BorderSizePixel = 0
    line.Visible = false
    line.Parent = tabBtn

    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = Theme.Accent
    contentFrame.Visible = false
    contentFrame.Parent = self.ContentContainer

    local tabData = { Button = tabBtn, Content = contentFrame, Line = line }
    table.insert(self.Tabs, tabData)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.Tabs) do
            t.Content.Visible = false
            t.Button.TextColor3 = Theme.SubText
            t.Line.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Sidebar}):Play()
        end
        contentFrame.Visible = true
        tabBtn.TextColor3 = Theme.Text
        line.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
    end)

    if #self.Tabs == 1 then
        contentFrame.Visible = true
        tabBtn.TextColor3 = Theme.Text
        line.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end

    self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, #self.Tabs * 35)

    local api = {}
    function api:AddSection(text)
        local sect = Instance.new("TextLabel")
        sect.Size = UDim2.new(1, 0, 0, 25)
        sect.BackgroundTransparency = 1
        sect.Text = text
        sect.TextColor3 = Theme.Accent
        sect.Font = Enum.Font.GothamBold
        sect.TextSize = 14
        sect.TextXAlignment = Enum.TextXAlignment.Left
        sect.Parent = contentFrame
        return sect
    end

    function api:AddButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        btn.Text = text
        btn.TextColor3 = Theme.Text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.Parent = contentFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    function api:AddToggle(text, default, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        btn.Text = "  " .. text .. " [" .. (default and "ON" or "OFF") .. "]"
        btn.TextColor3 = Theme.Text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = contentFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        local state = default or false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = "  " .. text .. " [" .. (state and "ON" or "OFF") .. "]"
            btn.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(35, 35, 35)
            if callback then callback(state) end
        end)
        return btn
    end
    
    function api:AddSlider(text, min, max, default, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        btn.Text = "  " .. text .. ": " .. default
        btn.TextColor3 = Theme.Text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = contentFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        local dragging = false
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = math.clamp((input.Position.X - btn.AbsolutePosition.X) / btn.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + ((max - min) * percent))
                btn.Text = "  " .. text .. ": " .. val
                if callback then callback(val) end
            end
        end)
        return btn
    end

    function api:AddDropdown(text, items, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 35)
        frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        frame.Parent = contentFrame
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = "  " .. text .. " ▼"
        btn.TextColor3 = Theme.Text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = frame

        local list = Instance.new("ScrollingFrame")
        list.Size = UDim2.new(1, 0, 0, 120)
        list.Position = UDim2.new(0, 0, 1, 5)
        list.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        list.BorderSizePixel = 0
        list.Visible = false
        list.ZIndex = 10
        list.ScrollBarThickness = 3
        list.Parent = frame
        Instance.new("UICorner", list).CornerRadius = UDim.new(0, 6)

        local function refreshList(newItems)
            for _, v in ipairs(list:GetChildren()) do
                if v:IsA("TextButton") then v:Destroy() end
            end
            for i, item in ipairs(newItems) do
                local itemBtn = Instance.new("TextButton")
                itemBtn.Size = UDim2.new(1, -4, 0, 25)
                itemBtn.Position = UDim2.new(0, 2, 0, (i-1)*26)
                itemBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                itemBtn.Text = tostring(item)
                itemBtn.TextColor3 = Theme.Text
                itemBtn.Font = Enum.Font.Gotham
                itemBtn.TextSize = 12
                itemBtn.Parent = list
                Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0, 4)
                
                itemBtn.MouseButton1Click:Connect(function()
                    btn.Text = "  " .. text .. ": " .. tostring(item) .. " ▼"
                    list.Visible = false
                    if callback then callback(item) end
                end)
            end
            list.CanvasSize = UDim2.new(0, 0, 0, #newItems * 26)
        end

        refreshList(items)
        btn.MouseButton1Click:Connect(function()
            list.Visible = not list.Visible
        end)
        
        return {Refresh = refreshList}
    end

    return api
end

-- Simpan fungsi pembuat UI ke getgenv agar bisa diakses script map
getgenv().DARKNES_UI = UI_Lib

-- ==========================================
-- 2. GAME DETECTION & MAP LOADER
-- ==========================================
local baseUrl = "https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/"

local success, gameName = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

if not success or not gameName then gameName = "Unknown" end
local lowerName = gameName:lower()

local function loadMapScript(file)
    pcall(function()
        loadstring(game:HttpGet(baseUrl .. file))()
    end)
end

-- Deteksi Map
if lowerName:find("granny") or lowerName:find("nenek") or lowerName:find("rumah") then
    loadMapScript("darknesgrannymp.lua")
elseif lowerName:find("opah") or lowerName:find("malam") then
    loadMapScript("darknesopah.lua")
elseif lowerName:find("evade") then
    loadMapScript("darknesevade.lua")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DARKNES HUB",
        Text = "Map tidak didukung: " .. gameName,
        Duration = 3
    })
end
