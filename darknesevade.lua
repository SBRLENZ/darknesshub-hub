--[[ DARKNES HUB - EVADE (27 PRO FEATURES) ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "DARKNES HUB | Evade (27 Features)",
   LoadingTitle = "DARKNES HUB",
   LoadingSubtitle = "by SBRLENZ",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "DarknesHubConfig",
      FileName = "EvadeConfig27"
   },
   KeySystem = false
})

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
-- TAB 1: MAIN
-- ==========================================
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateParagraph({
   Title = "Welcome, " .. LocalPlayer.Name .. "!",
   Content = "Darknes Hub Evade Edition loaded with 27 custom features.\n\nJoin Discord:\nhttps://discord.gg/jzDxbbJhy"
})

-- Fitur 1
MainTab:CreateButton({
   Name = "1. Copy Discord Link",
   Callback = function()
       if setclipboard then
           setclipboard("https://discord.gg/jzDxbbJhy")
           Rayfield:Notify({Title = "Success", Content = "Discord link copied!", Duration = 3})
       end
   end,
})

-- Fitur 2
MainTab:CreateButton({
   Name = "2. Rejoin Server",
   Callback = function()
       game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
   end,
})

-- Fitur 3
MainTab:CreateButton({
   Name = "3. Server Hop (Find New Lobby)",
   Callback = function()
       local ts = game:GetService("TeleportService")
       local p = game:GetService("Players").LocalPlayer
       ts:Teleport(game.PlaceId, p)
   end,
})

-- ==========================================
-- TAB 2: VISUAL (ESP)
-- ==========================================
local VisualTab = Window:CreateTab("Visual", 4483362458)
VisualTab:CreateSection("ESP Suite")

local espNextbotActive = false
local nextbotHls = {}
-- Fitur 4
VisualTab:CreateToggle({
   Name = "4. ESP Nextbots / Enemy",
   CurrentValue = false,
   Callback = function(v)
       espNextbotActive = v
       if not v then
           for _, hl in pairs(nextbotHls) do if hl then hl:Destroy() end end
           nextbotHls = {}
           return
       end
       task.spawn(function()
           while espNextbotActive do
               for _, obj in ipairs(Workspace:GetDescendants()) do
                   if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                       if not nextbotHls[obj] then
                           local hl = Instance.new("Highlight")
                           hl.FillColor = Color3.fromRGB(255, 0, 0)
                           hl.OutlineColor = Color3.new(1, 1, 1)
                           hl.FillTransparency = 0.4
                           hl.Parent = obj
                           nextbotHls[obj] = hl
                       end
                   end
               end
               task.wait(2)
           end
       end)
   end,
})

local espPlayersActive = false
local playerHls = {}
-- Fitur 5
VisualTab:CreateToggle({
   Name = "5. ESP Players / Teammates",
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
                       hl.FillColor = Color3.fromRGB(0, 150, 255)
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

-- Fitur 6
VisualTab:CreateToggle({
   Name = "6. Fullbright (Remove Darkness)",
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

-- Fitur 7
VisualTab:CreateToggle({
   Name = "7. Remove Fog",
   CurrentValue = false,
   Callback = function(v)
       if v then
           Lighting.FogEnd = 100000
           for _, obj in ipairs(Lighting:GetDescendants()) do
               if obj:IsA("Atmosphere") then obj.Density = 0 end
           end
       end
   end,
})

-- Fitur 8
VisualTab:CreateToggle({
   Name = "8. Camera FOV Changer (120)",
   CurrentValue = false,
   Callback = function(v)
       workspace.CurrentCamera.FieldOfView = v and 120 or 70
   end,
})

-- ==========================================
-- TAB 3: PLAYER & MOVEMENT
-- ==========================================
local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateSection("Movement Tweaks")

local targetSpeed = 16
-- Fitur 9
PlayerTab:CreateSlider({
   Name = "9. WalkSpeed Boost",
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
-- Fitur 10
PlayerTab:CreateSlider({
   Name = "10. JumpPower Boost",
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

-- Fitur 11
local noclipActive = false
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)
PlayerTab:CreateToggle({
   Name = "11. Noclip (Walk Through Walls)",
   CurrentValue = false,
   Callback = function(v) noclipActive = v end,
})

-- Fitur 12
local bhopActive = false
PlayerTab:CreateToggle({
   Name = "12. Auto Bunny Hop (BHOP)",
   CurrentValue = false,
   Callback = function(v)
       bhopActive = v
       task.spawn(function()
           while bhopActive do
               local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
               if hum and hum.FloorMaterial ~= Enum.Material.Air then
                   hum:ChangeState(Enum.HumanoidStateType.Jumping)
               end
               task.wait(0.05)
           end
       end)
   end,
})

-- Fitur 13
local infJump = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)
PlayerTab:CreateToggle({
   Name = "13. Infinite Jump",
   CurrentValue = false,
   Callback = function(v) infJump = v end,
})

-- ==========================================
-- TAB 4: TELEPORT
-- ==========================================
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
TeleportTab:CreateSection("Quick Teleports")

-- Fitur 14
TeleportTab:CreateButton({
   Name = "14. TP to Random Player",
   Callback = function()
       local players = Players:GetPlayers()
       for _, p in ipairs(players) do
           if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
               tpTo(p.Character.HumanoidRootPart.CFrame)
               break
           end
       end
   end,
})

-- Fitur 15
TeleportTab:CreateButton({
   Name = "15. TP to Spawn / Lobby",
   Callback = function()
       local spawn = Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
       if spawn then tpTo(spawn.CFrame) end
   end,
})

-- Fitur 16
TeleportTab:CreateButton({
   Name = "16. TP to Sky (Safe High Position)",
   Callback = function()
       local root = getRoot()
       if root then root.CFrame = root.CFrame + Vector3.new(0, 150, 0) end
   end,
})

-- ==========================================
-- TAB 5: UTILITY & FARM
-- ==========================================
local UtilityTab = Window:CreateTab("Utility", 4483362458)
UtilityTab:CreateSection("Quality of Life")

-- Fitur 17
UtilityTab:CreateButton({
   Name = "17. Respawn / Reset Character",
   Callback = function()
       local char = LocalPlayer.Character
       if char and char:FindFirstChildOfClass("Humanoid") then
           char:FindFirstChildOfClass("Humanoid").Health = 0
       end
   end,
})

-- Fitur 18
local autoRevive = false
UtilityTab:CreateToggle({
   Name = "18. Auto Revive Teammates (Nearby)",
   CurrentValue = false,
   Callback = function(v)
       autoRevive = v
       task.spawn(function()
           while autoRevive do
               local root = getRoot()
               if root then
                   for _, obj in ipairs(Workspace:GetDescendants()) do
                       if obj:IsA("Model") and (obj.Name:lower():find("down") or obj.Name:lower():find("player")) then
                           local part = obj:FindFirstChild("HumanoidRootPart")
                           if part and (root.Position - part.Position).Magnitude < 15 then
                               tpTo(part.CFrame)
                               if fireproximityprompt then
                                   for _, p in ipairs(obj:GetDescendants()) do
                                       if p:IsA("ProximityPrompt") then fireproximityprompt(p) end
                                   end
                               end
                           end
                       end
                   end
               end
               task.wait(0.5)
           end
       end)
   end,
})

-- Fitur 19
UtilityTab:CreateButton({
   Name = "19. Remove Blur Effects",
   Callback = function()
       for _, obj in ipairs(Lighting:GetDescendants()) do
           if obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") then obj:Destroy() end
       end
   end,
})

-- Fitur 20
UtilityTab:CreateButton({
   Name = "20. Anti-AFK (Bypass Kick)",
   Callback = function()
       local vu = game:GetService("VirtualUser")
       LocalPlayer.Idled:Connect(function()
           vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
           task.wait(1)
           vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
       end)
       Rayfield:Notify({Title = "Anti-AFK", Content = "Anti-AFK successfully activated!", Duration = 3})
   end,
})

-- ==========================================
-- TAB 6: EXCLUSIVE (GODMODE & OTHERS)
-- ==========================================
local ExclusiveTab = Window:CreateTab("Exclusive", 4483362458)
ExclusiveTab:CreateSection("Overpowered Hacks")

-- Fitur 21: Godmode / Auto-Dodge
local smartGodmode = false
ExclusiveTab:CreateToggle({
   Name = "21. Smart Godmode (Auto-Dodge Nextbots)",
   CurrentValue = false,
   Callback = function(v)
       smartGodmode = v
       task.spawn(function()
           while smartGodmode do
               local root = getRoot()
               if root then
                   for _, obj in ipairs(Workspace:GetDescendants()) do
                       if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                           local enemyRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                           if enemyRoot then
                               local dist = (root.Position - enemyRoot.Position).Magnitude
                               if dist < 28 then
                                   local dir = (root.Position - enemyRoot.Position).Unit
                                   root.CFrame = root.CFrame + (dir * 40) + Vector3.new(0, 15, 0)
                                   break
                               end
                           end
                       end
                   end
               end
               task.wait(0.1)
           end
       end)
   end,
})

-- Fitur 22
local invisActive = false
ExclusiveTab:CreateToggle({
   Name = "22. Invisible (Hide Character)",
   CurrentValue = false,
   Callback = function(v)
       invisActive = v
       local char = LocalPlayer.Character
       if char then
           for _, part in ipairs(char:GetDescendants()) do
               if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                   part.Transparency = v and 1 or 0
               end
           end
       end
   end,
})

-- Fitur 23
ExclusiveTab:CreateButton({
   Name = "23. Speed Hack Burst (+50 Velocity)",
   Callback = function()
       local root = getRoot()
       if root then
           root.Velocity = root.CFrame.LookVector * 150
       end
   end,
})

-- Fitur 24
ExclusiveTab:CreateButton({
   Name = "24. Instant Spin / 360 Trick",
   Callback = function()
       local root = getRoot()
       if root then
           for i = 1, 10 do
               root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(36), 0)
               task.wait(0.01)
           end
       end
   end,
})

-- Fitur 25
ExclusiveTab:CreateToggle({
   Name = "25. Ultra High Performance (Low GFX)",
   CurrentValue = false,
   Callback = function(v)
       if v then
           settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
           for _, p in ipairs(Workspace:GetDescendants()) do
               if p:IsA("BasePart") then p.Material = Enum.Material.SmoothPlastic p.Reflectance = 0 end
           end
       end
   end,
})

-- Fitur 26
ExclusiveTab:CreateButton({
   Name = "26. Zero Gravity Mode",
   Callback = function()
       Workspace.Gravity = Workspace.Gravity == 0 and 196.2 or 0
       Rayfield:Notify({Title = "Gravity", Content = "Toggled Gravity to " .. Workspace.Gravity, Duration = 2})
   end,
})

-- Fitur 27
ExclusiveTab:CreateButton({
   Name = "27. Emergency Teleport to Sky Safe",
   Callback = function()
       local root = getRoot()
       if root then
           root.CFrame = CFrame.new(root.Position + Vector3.new(0, 300, 0))
           Rayfield:Notify({Title = "Emergency", Content = "Safely teleported high into the sky!", Duration = 3})
       end
   end,
})
