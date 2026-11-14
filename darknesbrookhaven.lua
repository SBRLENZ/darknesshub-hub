--[[ DARKNES HUB - BROOKHAVEN RP (TROLLING & PRO EDITION) ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "DARKNES HUB | Brookhaven Troller",
   LoadingTitle = "DARKNES HUB",
   LoadingSubtitle = "by SBRLENZ",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "DarknesHubConfig",
      FileName = "BrookhavenTrollConfig"
   },
   KeySystem = false
})

-- ==========================================
-- AUTOMATIC CUSTOM TITLE (DARKNES Hub - RED)
-- ==========================================
task.spawn(function()
    task.wait(1)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local head = char:FindFirstChild("Head")
    if head then
        local oldTag = head:FindFirstChild("DarknesTitleTag")
        if oldTag then oldTag:Destroy() end

        local bg = Instance.new("BillboardGui")
        bg.Name = "DarknesTitleTag"
        bg.Size = UDim2.new(0, 200, 0, 50)
        bg.StudsOffset = Vector3.new(0, 3, 0)
        bg.AlwaysOnTop = true
        bg.Parent = head

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Text = "DARKNES Hub"
        txt.TextColor3 = Color3.fromRGB(255, 0, 0) -- Warna Merah
        txt.TextStrokeTransparency = 0
        txt.TextScaled = true
        txt.Font = Enum.Font.GothamBlack
        txt.Parent = bg
    end
    
    Rayfield:Notify({
        Title = "DARKNES HUB ACTIVE",
        Content = "Custom Red Title 'DARKNES Hub' Applied!",
        Duration = 4
    })
end)

-- ==========================================
-- HELPER FUNCTIONS
-- ==========================================
local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function tpTo(pos)
    local root = getRoot()
    if root and pos then
        root.CFrame = typeof(pos) == "CFrame" and pos + Vector3.new(0, 3, 0) or CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

-- ==========================================
-- TAB 1: MAIN & PLAYER
-- ==========================================
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSection("Player & Movement")

local targetSpeed = 16
MainTab:CreateSlider({
   Name = "WalkSpeed Boost",
   Range = {16, 120},
   Increment = 1,
   Suffix = " Spd",
   CurrentValue = 16,
   Callback = function(v) targetSpeed = v end,
})

RunService.Heartbeat:Connect(function()
    if targetSpeed > 16 and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= targetSpeed then hum.WalkSpeed = targetSpeed end
    end
end)

local targetJump = 50
MainTab:CreateSlider({
   Name = "JumpPower Boost",
   Range = {50, 200},
   Increment = 5,
   Suffix = " JP",
   CurrentValue = 50,
   Callback = function(v) targetJump = v end,
})

RunService.Heartbeat:Connect(function()
    if targetJump > 50 and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.JumpPower ~= targetJump then hum.JumpPower = targetJump end
    end
end)

local noclipActive = false
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)
MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(v) noclipActive = v end,
})

-- ==========================================
-- TAB 2: VISUAL & ESP
-- ==========================================
local VisualTab = Window:CreateTab("Visual", 4483362458)
VisualTab:CreateSection("ESP Options")

local espPlayersActive = false
local playerHls = {}
VisualTab:CreateToggle({
   Name = "ESP All Players",
   CurrentValue = false,
   Callback = function(v)
       espPlayersActive = v
       if not v then
           for _, hl in pairs(playerHls) do if hl then hl:Destroy() end end
           playerHls = {}
           return
       end
       task.spawn(function()
           while espPlayersActive do
               for _, p in ipairs(Players:GetPlayers()) do
                   if p ~= LocalPlayer and p.Character and not playerHls[p] then
                       local hl = Instance.new("Highlight")
                       hl.FillColor = Color3.fromRGB(255, 0, 0)
                       hl.OutlineColor = Color3.new(1, 1, 1)
                       hl.FillTransparency = 0.5
                       hl.Parent = p.Character
                       playerHls[p] = hl
                   end
               end
               task.wait(2)
           end
       end)
   end,
})

VisualTab:CreateToggle({
   Name = "Fullbright Lighting",
   CurrentValue = false,
   Callback = function(v)
       if v then
           Lighting.Brightness = 2
           Lighting.ClockTime = 14
           Lighting.GlobalShadows = false
       else
           Lighting.GlobalShadows = true
       end
   end,
})

-- ==========================================
-- TAB 3: 25 EXCLUSIVE TROLL SUITE
-- ==========================================
local TrollTab = Window:CreateTab("Troll Suite", 4483362458)
TrollTab:CreateSection("25 Pro Trolling Features")

TrollTab:CreateButton({
   Name = "Spin Character Fast",
   Callback = function()
       local r = getRoot()
       if r then
           for i = 1, 30 do
               r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(20), 0)
               task.wait(0.01)
           end
       end
   end,
})

TrollTab:CreateButton({
   Name = "Jitter / Shake Screen",
   Callback = function()
       local cam = Workspace.CurrentCamera
       for i = 1, 15 do
           cam.CFrame = cam.CFrame * CFrame.new(math.random(-2,2), math.random(-2,2), 0)
           task.wait(0.02)
       end
   end,
})

TrollTab:CreateButton({
   Name = "Force Sit Down",
   Callback = function()
       local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
       if hum then hum.Sit = true end
   end,
})

TrollTab:CreateButton({
   Name = "Force Jump Action",
   Callback = function()
       local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
       if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
   end,
})

TrollTab:CreateButton({
   Name = "Invisible Body Trolling",
   Callback = function()
       local char = LocalPlayer.Character
       if char then
           for _, p in ipairs(char:GetDescendants()) do
               if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                   p.Transparency = p.Transparency == 1 and 0 or 1
               end
           end
       end
   end,
})

TrollTab:CreateButton({
   Name = "Velocity Forward Launch",
   Callback = function()
       local r = getRoot()
       if r then r.Velocity = r.CFrame.LookVector * 120 end
   end,
})

TrollTab:CreateButton({
   Name = "Velocity Upward Launch",
   Callback = function()
       local r = getRoot()
       if r then r.Velocity = Vector3.new(0, 150, 0) end
   end,
})

TrollTab:CreateButton({
   Name = "Zero Gravity Toggle",
   Callback = function()
       Workspace.Gravity = Workspace.Gravity == 0 and 196.2 or 0
       Rayfield:Notify({Title = "Troll", Content = "Gravity set to: " .. Workspace.Gravity, Duration = 2})
   end,
})

TrollTab:CreateButton({
   Name = "Moon Gravity Effect",
   Callback = function()
       Workspace.Gravity = 30
       Rayfield:Notify({Title = "Troll", Content = "Moon gravity enabled!", Duration = 2})
   end,
})

TrollTab:CreateButton({
   Name = "Heavy Gravity Effect",
   Callback = function()
       Workspace.Gravity = 600
       Rayfield:Notify({Title = "Troll", Content = "Heavy gravity enabled!", Duration = 2})
   end,
})

TrollTab:CreateButton({
   Name = "Reset Gravity Normal",
   Callback = function()
       Workspace.Gravity = 196.2
   end,
})

TrollTab:CreateButton({
   Name = "Teleport Sky High Trolling",
   Callback = function()
       local r = getRoot()
       if r then r.CFrame = r.CFrame + Vector3.new(0, 200, 0) end
   end,
})

TrollTab:CreateButton({
   Name = "Teleport Underground Trolling",
   Callback = function()
       local r = getRoot()
       if r then r.CFrame = r.CFrame - Vector3.new(0, 20, 0) end
   end,
})

TrollTab:CreateButton({
   Name = "Flip Character Upside Down",
   Callback = function()
       local r = getRoot()
       if r then r.CFrame = r.CFrame * CFrame.Angles(math.pi, 0, 0) end
   end,
})

TrollTab:CreateButton({
   Name = "Remove All Decals / Posters",
   Callback = function()
       for _, o in ipairs(Workspace:GetDescendants()) do
           if o:IsA("Decal") then o:Destroy() end
       end
   end,
})

TrollTab:CreateButton({
   Name = "Remove All Textures",
   Callback = function()
       for _, o in ipairs(Workspace:GetDescendants()) do
           if o:IsA("Texture") then o:Destroy() end
       end
   end,
})

TrollTab:CreateButton({
   Name = "Smooth Plastic Troll Style",
   Callback = function()
       for _, p in ipairs(Workspace:GetDescendants()) do
           if p:IsA("BasePart") then p.Material = Enum.Material.SmoothPlastic p.Reflectance = 0 end
       end
   end,
})

TrollTab:CreateButton({
   Name = "Stop All Sound Effects",
   Callback = function()
       for _, s in ipairs(Workspace:GetDescendants()) do
           if s:IsA("Sound") then s:Stop() end
       end
   end,
})

TrollTab:CreateButton({
   Name = "Fake Kill / Health Zero",
   Callback = function()
       local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
       if hum then hum.Health = 0 end
   end,
})

TrollTab:CreateButton({
   Name = "Anchor / Freeze Character",
   Callback = function()
       local r = getRoot()
       if r then r.Anchored = not r.Anchored end
   end,
})

TrollTab:CreateButton({
   Name = "Wide FOV Trolling",
   Callback = function()
       Workspace.CurrentCamera.FieldOfView = 120
   end,
})

TrollTab:CreateButton({
   Name = "Tiny FOV Trolling",
   Callback = function()
       Workspace.CurrentCamera.FieldOfView = 20
   end,
})

TrollTab:CreateButton({
   Name = "Reset Camera FOV",
   Callback = function()
       Workspace.CurrentCamera.FieldOfView = 70
   end,
})

TrollTab:CreateButton({
   Name = "Simulate Lag Spike (Freeze 2s)",
   Callback = function()
       task.wait(2)
   end,
})

TrollTab:CreateButton({
   Name = "Rejoin Current Server",
   Callback = function()
       game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
   end,
})
