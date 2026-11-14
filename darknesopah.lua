--[[ DARKNES HUB - RUMAH OPA (FULL + AUDIO PLAYER) ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "DARKNES HUB | Rumah Opa",
   LoadingTitle = "DARKNES HUB",
   LoadingSubtitle = "by SBRLENZ",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "DarknesHubConfig",
      FileName = "RumahOpaFull"
   },
   KeySystem = false
})

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
   Content = "Darknes Hub Rumah Opa loaded successfully.\n\nJoin Discord:\nhttps://discord.gg/jzDxbbJhy"
})

MainTab:CreateButton({
   Name = "Copy Discord Link",
   Callback = function()
       if setclipboard then
           setclipboard("https://discord.gg/jzDxbbJhy")
           Rayfield:Notify({Title = "Success", Content = "Discord link copied!", Duration = 3})
       end
   end,
})

MainTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
       game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
   end,
})

-- ==========================================
-- TAB 2: VISUAL & ESP
-- ==========================================
local VisualTab = Window:CreateTab("Visual", 4483362458)
VisualTab:CreateSection("ESP Suite")

local espEnemyActive = false
local enemyHls = {}
VisualTab:CreateToggle({
   Name = "ESP Opa / Enemy",
   CurrentValue = false,
   Callback = function(v)
       espEnemyActive = v
       if not v then
           for _, hl in pairs(enemyHls) do if hl then hl:Destroy() end end
           enemyHls = {}
           return
       end
       task.spawn(function()
           while espEnemyActive do
               for _, obj in ipairs(Workspace:GetDescendants()) do
                   if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                       if not enemyHls[obj] then
                           local hl = Instance.new("Highlight")
                           hl.FillColor = Color3.fromRGB(255, 0, 0)
                           hl.OutlineColor = Color3.new(1, 1, 1)
                           hl.FillTransparency = 0.4
                           hl.Parent = obj
                           enemyHls[obj] = hl
                       end
                   end
               end
               task.wait(2)
           end
       end)
   end,
})

local espItemActive = false
local itemHls = {}
VisualTab:CreateToggle({
   Name = "ESP Keys & Items",
   CurrentValue = false,
   Callback = function(v)
       espItemActive = v
       if not v then
           for _, hl in pairs(itemHls) do if hl then hl:Destroy() end end
           itemHls = {}
           return
       end
       task.spawn(function()
           while espItemActive do
               for _, obj in ipairs(Workspace:GetDescendants()) do
                   if obj:IsA("Tool") or (obj:IsA("BasePart") and (obj.Name:lower():find("key") or obj.Name:lower():find("kunci"))) then
                       if not itemHls[obj] then
                           local hl = Instance.new("Highlight")
                           hl.FillColor = Color3.fromRGB(255, 215, 0)
                           hl.OutlineColor = Color3.new(1, 1, 1)
                           hl.FillTransparency = 0.3
                           hl.Parent = obj
                           itemHls[obj] = hl
                       end
                   end
               end
               task.wait(2)
           end
       end)
   end,
})

VisualTab:CreateToggle({
   Name = "Fullbright",
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
-- TAB 3: PLAYER
-- ==========================================
local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateSection("Movement Tweaks")

local targetSpeed = 16
PlayerTab:CreateSlider({
   Name = "WalkSpeed Boost",
   Range = {16, 100},
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

local noclipActive = false
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)
PlayerTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(v) noclipActive = v end,
})

-- ==========================================
-- TAB 4: EXCLUSIVE BYPASS
-- ==========================================
local ExclusiveTab = Window:CreateTab("Exclusive", 4483362458)
ExclusiveTab:CreateSection("Game Bypass")

ExclusiveTab:CreateButton({
   Name = "Instant Interact / Trigger Prompts",
   Callback = function()
       for _, p in ipairs(Workspace:GetDescendants()) do
           if p:IsA("ProximityPrompt") then
               p.HoldDuration = 0
           end
       end
       Rayfield:Notify({Title = "Success", Content = "All prompts set to instant interact!", Duration = 3})
   end,
})

ExclusiveTab:CreateButton({
   Name = "Collect All Keys / Items",
   Callback = function()
       local root = getRoot()
       if not root then return end
       for _, obj in ipairs(Workspace:GetDescendants()) do
           if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
               obj.Handle.CFrame = root.CFrame
           end
       end
       Rayfield:Notify({Title = "Items", Content = "Attempted to pull available items!", Duration = 3})
   end,
})

ExclusiveTab:CreateButton({
   Name = "TP to Spawn / Safe Area",
   Callback = function()
       local spawn = Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
       if spawn then tpTo(spawn.CFrame) end
   end,
})

-- ==========================================
-- TAB 5: UTILITY & AUDIO PLAYER
-- ==========================================
local UtilityTab = Window:CreateTab("Utility", 4483362458)
UtilityTab:CreateSection("Custom Audio Player")

local customSoundId = "6023426915"
local customVolume = 1
local soundInstance = nil

UtilityTab:CreateInput({
   Name = "Roblox Audio ID",
   PlaceholderText = "Enter Sound ID here",
   RemoveTextAfterFocusLost = false,
   Callback = function(text)
       customSoundId = text
   end,
})

UtilityTab:CreateSlider({
   Name = "Audio Volume",
   Range = {0.1, 5},
   Increment = 0.1,
   Suffix = " Vol",
   CurrentValue = 1,
   Callback = function(val)
       customVolume = val
       if soundInstance then soundInstance.Volume = val end
   end,
})

UtilityTab:CreateToggle({
   Name = "Play Sound (On/Off)",
   CurrentValue = false,
   Callback = function(state)
       if state then
           if soundInstance then soundInstance:Destroy() end
           local root = getRoot()
           if root then
               soundInstance = Instance.new("Sound")
               soundInstance.SoundId = "rbxassetid://" .. tostring(customSoundId)
               soundInstance.Volume = customVolume
               soundInstance.Looped = true
               soundInstance.Parent = root
               soundInstance:Play()
               Rayfield:Notify({Title = "Audio Player", Content = "Playing sound ID: " .. customSoundId, Duration = 3})
           end
       else
           if soundInstance then
               soundInstance:Stop()
               soundInstance:Destroy()
               soundInstance = nil
               Rayfield:Notify({Title = "Audio Player", Content = "Sound stopped.", Duration = 2})
           end
       end
   end,
})

UtilityTab:CreateSection("Client Tools")
UtilityTab:CreateButton({
   Name = "Anti-AFK",
   Callback = function()
       local vu = game:GetService("VirtualUser")
       LocalPlayer.Idled:Connect(function()
           vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
           task.wait(1)
           vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
       end)
       Rayfield:Notify({Title = "Anti-AFK", Content = "Anti-AFK activated!", Duration = 3})
   end,
})
