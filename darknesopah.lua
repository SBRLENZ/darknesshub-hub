--[[ DARKNES HUB - RUMAH OPA (WITH AUDIO PLAYER) ]]
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
      FileName = "RumahOpaConfigAudio"
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
-- TAB: UTILITY (AUDIO PLAYER & MORE)
-- ==========================================
local UtilityTab = Window:CreateTab("Utility", 4483362458)
UtilityTab:CreateSection("Custom Audio Player")

local customSoundId = "6023426915" -- Default Roblox ID
local customVolume = 1
local soundInstance = nil

UtilityTab:CreateInput({
   Name = "Roblox Audio ID",
   PlaceholderText = "Enter Sound ID here (e.g., 6023426915)",
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
