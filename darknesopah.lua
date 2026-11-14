--[[ DARKNES HUB - RUMAH OPA / OPAH ]]
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
      FileName = "RumahOpaConfig"
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

local function tpTo(cframeOrPos)
    local root = getRoot()
    if not root then return end
    if typeof(cframeOrPos) == "CFrame" then
        root.CFrame = cframeOrPos + Vector3.new(0, 3, 0)
    elseif typeof(cframeOrPos) == "Vector3" then
        root.CFrame = CFrame.new(cframeOrPos + Vector3.new(0, 3, 0))
    end
end

local function getObjPos(obj)
    if obj:IsA("BasePart") then return obj.CFrame end
    if obj:IsA("Model") then
        if obj.PrimaryPart then return obj.PrimaryPart.CFrame end
        local part = obj:FindFirstChildWhichIsA("BasePart", true)
        if part then return part.CFrame end
    end
    return nil
end

local function interactWith(obj)
    local root = getRoot()
    if not root then return end
    for _, v in ipairs(obj:GetDescendants()) do
        if v:IsA("TouchTransmitter") and v.Parent:IsA("BasePart") and firetouchinterest then
            firetouchinterest(root, v.Parent, 0)
            task.wait()
            firetouchinterest(root, v.Parent, 1)
        elseif v:IsA("ProximityPrompt") and fireproximityprompt then
            fireproximityprompt(v)
        elseif v:IsA("ClickDetector") and fireclickdetector then
            fireclickdetector(v)
        end
    end
    if obj:IsA("BasePart") and obj:FindFirstChildOfClass("TouchTransmitter") and firetouchinterest then
        firetouchinterest(root, obj, 0)
        task.wait()
        firetouchinterest(root, obj, 1)
    end
end

local function findEntities(keywords, excludeKeywords)
    local found = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("Tool") then
            local name = obj.Name:lower()
            local match = false
            for _, kw in ipairs(keywords) do
                if name:find(kw) then match = true break end
            end
            if match and excludeKeywords then
                for _, ex in ipairs(excludeKeywords) do
                    if name:find(ex) then match = false break end
                end
            end
            if match and not obj:IsDescendantOf(LocalPlayer.Character or Workspace) then
                if not Players:GetPlayerFromCharacter(obj) and not Players:GetPlayerFromCharacter(obj.Parent) then
                    table.insert(found, obj)
                end
            end
        end
    end
    return found
end

local function findOpah()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            local name = obj.Name:lower()
            if (name:find("opa") or name:find("nenek") or name:find("granny") or name:find("enemy") or name:find("monster")) and not Players:GetPlayerFromCharacter(obj) then
                return obj
            end
        end
    end
    return nil
end

local espHighlights = {}
local function clearESP(category)
    if espHighlights[category] then
        for _, hl in ipairs(espHighlights[category]) do
            if hl and hl.Parent then hl:Destroy() end
        end
    end
    espHighlights[category] = {}
end

local function applyESP(category, targets, color, labelPrefix)
    clearESP(category)
    for _, target in ipairs(targets) do
        local hl = Instance.new("Highlight")
        hl.Name = "DarknesESP_" .. category
        hl.FillColor = color
        hl.OutlineColor = Color3.new(1, 1, 1)
        hl.FillTransparency = 0.4
        hl.OutlineTransparency = 0
        hl.Parent = target
        table.insert(espHighlights[category], hl)

        local part = target:IsA("BasePart") and target or target:FindFirstChildWhichIsA("BasePart", true)
        if part and not part:FindFirstChild("DarknesTag") then
            local bg = Instance.new("BillboardGui")
            bg.Name = "DarknesTag"
            bg.Size = UDim2.new(0, 120, 0, 30)
            bg.StudsOffset = Vector3.new(0, 2.5, 0)
            bg.AlwaysOnTop = true
            bg.Parent = part

            local txt = Instance.new("TextLabel")
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.Text = labelPrefix .. target.Name
            txt.TextColor3 = color
            txt.TextStrokeTransparency = 0
            txt.TextScaled = true
            txt.Font = Enum.Font.GothamBold
            txt.Parent = bg
            table.insert(espHighlights[category], bg)
        end
    end
end

-- ==========================================
-- TAB 1: MAIN
-- ==========================================
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateParagraph({
   Title = "Welcome, " .. LocalPlayer.Name .."!",
   Content = "Note: This script is still in development and uses Rayfield UI. Please wait for official updates from admins in our community.\n\nJoin Darknes Hub Discord:\nhttps://discord.gg/jzDxbbJhy"
})

MainTab:CreateButton({
   Name = "Copy Discord Link",
   Callback = function()
       if setclipboard then
           setclipboard("https://discord.gg/jzDxbbJhy")
           Rayfield:Notify({Title = "Success", Content = "Discord link copied to clipboard!", Duration = 3})
       end
   end,
})

-- ==========================================
-- TAB 2: VISUAL
-- ==========================================
local VisualTab = Window:CreateTab("Visual", 4483362458)
VisualTab:CreateSection("ESP Features")

local espLoops = {}

VisualTab:CreateToggle({
   Name = "ESP Opah",
   CurrentValue = false,
   Flag = "EspNenek",
   Callback = function(Value)
       espLoops.Nenek = Value
       if not Value then clearESP("Nenek") return end
       task.spawn(function()
           while espLoops.Nenek do
               local opah = findOpah()
               if opah then applyESP("Nenek", {opah}, Color3.fromRGB(255, 0, 0), "[OPAH] ") end
               task.wait(1.5)
           end
       end)
   end,
})

VisualTab:CreateToggle({
   Name = "ESP Keys (Excludes Locks)",
   CurrentValue = false,
   Flag = "EspKunci",
   Callback = function(Value)
       espLoops.Kunci = Value
       if not Value then clearESP("Kunci") return end
       task.spawn(function()
           while espLoops.Kunci do
               local keys = findEntities({"key", "kunci"}, {"lock", "gembok", "padlock", "door", "pintu"})
               applyESP("Kunci", keys, Color3.fromRGB(255, 215, 0), "[KEY] ")
               task.wait(2)
           end
       end)
   end,
})

VisualTab:CreateToggle({
   Name = "ESP Codes",
   CurrentValue = false,
   Flag = "EspCode",
   Callback = function(Value)
       espLoops.Code = Value
       if not Value then clearESP("Code") return end
       task.spawn(function()
           while espLoops.Code do
               local codes = findEntities({"code", "kode", "paper", "kertas", "note", "catatan", "password", "pin"})
               applyESP("Code", codes, Color3.fromRGB(0, 255, 255), "[CODE] ")
               task.wait(2)
           end
       end)
   end,
})

VisualTab:CreateToggle({
   Name = "ESP Flip Flop",
   CurrentValue = false,
   Flag = "EspFlipFlop",
   Callback = function(Value)
       espLoops.FlipFlop = Value
       if not Value then clearESP("FlipFlop") return end
       task.spawn(function()
           while espLoops.FlipFlop do
               local sandals = findEntities({"flip", "flop", "sandal", "sendal", "slipper"})
               applyESP("FlipFlop", sandals, Color3.fromRGB(0, 255, 100), "[FLIP-FLOP] ")
               task.wait(2)
           end
       end)
   end,
})

-- OPAH WARNING INDICATOR (!)
local warnGui = Instance.new("ScreenGui")
warnGui.Name = "OpahWarningGui"
warnGui.ResetOnSpawn = false
warnGui.Parent = game:GetService("CoreGui")

local warnLabel = Instance.new("TextLabel")
warnLabel.Size = UDim2.new(0, 80, 0, 80)
warnLabel.Position = UDim2.new(0.5, -40, 0.12, 0)
warnLabel.BackgroundTransparency = 1
warnLabel.Text = "!"
warnLabel.TextSize = 65
warnLabel.Font = Enum.Font.GothamBlack
warnLabel.TextStrokeTransparency = 0
warnLabel.Visible = false
warnLabel.Parent = warnGui

local warningActive = false
VisualTab:CreateToggle({
   Name = "Opah Warning Indicator (!)",
   CurrentValue = false,
   Flag = "OpahWarning",
   Callback = function(Value)
       warningActive = Value
       warnLabel.Visible = Value
       if Value then
           task.spawn(function()
               while warningActive do
                   local opah = findOpah()
                   local root = getRoot()
                   if opah and root then
                       local opahPos = getObjPos(opah)
                       if opahPos then
                           local dist = (root.Position - opahPos.Position).Magnitude
                           if dist <= 30 then
                               warnLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Very Close: Red
                           elseif dist <= 65 then
                               warnLabel.TextColor3 = Color3.fromRGB(255, 230, 0) -- Close: Yellow
                           else
                               warnLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Far: White
                           end
                       end
                   else
                       warnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                   end
                   task.wait(0.2)
               end
           end)
       end
   end,
})

VisualTab:CreateSection("Environment")

local fbLoop = false
VisualTab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Flag = "Fullbright",
   Callback = function(Value)
       fbLoop = Value
       if Value then
           task.spawn(function()
               while fbLoop do
                   Lighting.Brightness = 2
                   Lighting.ClockTime = 14
                   Lighting.GlobalShadows = false
                   Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
                   task.wait(0.5)
               end
           end)
       else
           Lighting.GlobalShadows = true
       end
   end,
})

local noFogLoop = false
VisualTab:CreateToggle({
   Name = "No Fog",
   CurrentValue = false,
   Flag = "NoFog",
   Callback = function(Value)
       noFogLoop = Value
       if Value then
           task.spawn(function()
               while noFogLoop do
                   Lighting.FogEnd = 100000
                   for _, v in ipairs(Lighting:GetDescendants()) do
                       if v:IsA("Atmosphere") then v.Density = 0 end
                   end
                   task.wait(0.5)
               end
           end)
       end
   end,
})

-- ==========================================
-- TAB 3: TELEPORT
-- ==========================================
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
TeleportTab:CreateSection("Location Teleports")

TeleportTab:CreateButton({
   Name = "Teleport to Kitchen Table",
   Callback = function()
       local tables = findEntities({"kitchen", "dapur", "meja", "table"})
       for _, t in ipairs(tables) do
           local cf = getObjPos(t)
           if cf then
               tpTo(cf + Vector3.new(0, 4, 0))
               Rayfield:Notify({Title = "Teleport", Content = "Teleported to Kitchen Table!", Duration = 2})
               return
           end
       end
       Rayfield:Notify({Title = "Failed", Content = "Kitchen table not found automatically.", Duration = 3})
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport to Safe Zone (Respawn)",
   Callback = function()
       local spawn = Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
       if spawn then
           tpTo(spawn.CFrame)
           Rayfield:Notify({Title = "Teleport", Content = "Teleported to Safe Zone!", Duration = 2})
       else
           local safes = findEntities({"safe", "spawn", "lobby", "start"})
           if safes[1] and getObjPos(safes[1]) then tpTo(getObjPos(safes[1])) end
       end
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport to Opah",
   Callback = function()
       local opah = findOpah()
       if opah and getObjPos(opah) then tpTo(getObjPos(opah))
       else Rayfield:Notify({Title = "Info", Content = "Opah is not currently spawned.", Duration = 3}) end
   end,
})

TeleportTab:CreateSection("Item Teleports")

local selectedKeyName = ""
local keyDropdown = TeleportTab:CreateDropdown({
   Name = "Select Key",
   Options = {"Refresh Keys First"},
   CurrentOption = "Refresh Keys First",
   Flag = "SelectKey",
   Callback = function(Option)
       selectedKeyName = type(Option) == "table" and Option[1] or Option
   end,
})

TeleportTab:CreateButton({
   Name = "Refresh Key List",
   Callback = function()
       local keys = findEntities({"key", "kunci"}, {"lock", "gembok", "padlock", "door"})
       local names = {}
       for _, k in ipairs(keys) do table.insert(names, k.Name) end
       if #names == 0 then names = {"No keys found"} end
       keyDropdown:Refresh(names)
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport to Selected Key",
   Callback = function()
       local keys = findEntities({"key", "kunci"}, {"lock", "gembok", "padlock", "door"})
       for _, k in ipairs(keys) do
           if k.Name == selectedKeyName or selectedKeyName == "" then
               local cf = getObjPos(k)
               if cf then tpTo(cf) return end
           end
       end
       Rayfield:Notify({Title = "Info", Content = "Key not found!", Duration = 2})
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport to Code",
   Callback = function()
       local codes = findEntities({"code", "kode", "paper", "kertas", "note", "catatan"})
       for _, c in ipairs(codes) do
           local cf = getObjPos(c)
           if cf then tpTo(cf) return end
       end
       Rayfield:Notify({Title = "Info", Content = "Code not found!", Duration = 2})
   end,
})

-- ==========================================
-- TAB 4: AUTO FARM
-- ==========================================
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local farmFlipFlop = false
FarmTab:CreateToggle({
   Name = "Auto Farm Flip Flop (Collect All)",
   CurrentValue = false,
   Flag = "FarmFlipFlop",
   Callback = function(Value)
       farmFlipFlop = Value
       if Value then
           task.spawn(function()
               while farmFlipFlop do
                   local sandals = findEntities({"flip", "flop", "sandal", "sendal", "slipper"})
                   for _, s in ipairs(sandals) do
                       if not farmFlipFlop then break end
                       local cf = getObjPos(s)
                       if cf then tpTo(cf) task.wait(0.15) interactWith(s) end
                   end
                   task.wait(1)
               end
           end)
       end
   end,
})

-- ==========================================
-- TAB 5: EXCLUSIVE
-- ==========================================
local EksklusifTab = Window:CreateTab("Exclusive", 4483362458)
EksklusifTab:CreateSection("Player Mods")

-- 1. NOCLIP
local noclipActive = false
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

EksklusifTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value) noclipActive = Value end,
})

-- 2. WALKSPEED
local targetSpeed = 16
EksklusifTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 150},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
       targetSpeed = Value
       local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
       if hum then hum.WalkSpeed = Value end
   end,
})

RunService.Heartbeat:Connect(function()
    if targetSpeed > 16 and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= targetSpeed then hum.WalkSpeed = targetSpeed end
    end
end)

-- 3. AUTO RUN (Anti Opah Detect -> Teleport Safezone -> Return)
local autoRunActive = false
EksklusifTab:CreateToggle({
   Name = "Auto Run (Escape to Safe Zone)",
   CurrentValue = false,
   Flag = "AutoRun",
   Callback = function(Value)
       autoRunActive = Value
       if Value then
           task.spawn(function()
               local savedPos = nil
               local isHiding = false
               while autoRunActive do
                   local opah = findOpah()
                   local root = getRoot()
                   local spawn = Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
                   if opah and root and spawn then
                       local opahPos = getObjPos(opah)
                       if opahPos then
                           local dist = (root.Position - opahPos.Position).Magnitude
                           if dist < 28 and not isHiding then
                               savedPos = root.CFrame
                               isHiding = true
                               tpTo(spawn.CFrame)
                               Rayfield:Notify({Title = "Auto Run", Content = "Opah is too close! Escaping to Safe Zone...", Duration = 2})
                           elseif dist > 45 and isHiding and savedPos then
                               tpTo(savedPos)
                               isHiding = false
                               savedPos = nil
                               Rayfield:Notify({Title = "Auto Run", Content = "Opah left, returning to previous position.", Duration = 2})
                           end
                       end
                   end
                   task.wait(0.25)
               end
           end)
       end
   end,
})

-- 4. INVISIBLE
EksklusifTab:CreateToggle({
   Name = "Invisible (Hide Body & Name)",
   CurrentValue = false,
   Flag = "Invisible",
   Callback = function(Value)
       local char = LocalPlayer.Character
       if not char then return end
       for _, v in ipairs(char:GetDescendants()) do
           if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
               v.Transparency = Value and 1 or 0
           elseif v:IsA("Decal") or v:IsA("Texture") then
               v.Transparency = Value and 1 or 0
           elseif v:IsA("BillboardGui") then
               v.Enabled = not Value
           end
       end
       local hum = char:FindFirstChildOfClass("Humanoid")
       if hum then
           hum.DisplayDistanceType = Value and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer
       end
   end,
})

-- 5. INSTANT UNLOCK LOCK
local instantUnlockActive = false
EksklusifTab:CreateToggle({
   Name = "Instant Unlock Lock (Auto Match Key)",
   CurrentValue = false,
   Flag = "InstantUnlock",
   Callback = function(Value)
       instantUnlockActive = Value
       if Value then
           task.spawn(function()
               while instantUnlockActive do
                   local char = LocalPlayer.Character
                   local backpack = LocalPlayer:FindFirstChild("Backpack")
                   local heldTools = {}

                   if char then
                       for _, t in ipairs(char:GetChildren()) do
                           if t:IsA("Tool") then table.insert(heldTools, t) end
                       end
                   end
                   if backpack then
                       for _, t in ipairs(backpack:GetChildren()) do
                           if t:IsA("Tool") then table.insert(heldTools, t) end
                       end
                   end

                   for _, tool in ipairs(heldTools) do
                       local tName = tool.Name:lower()
                       if tName:find("key") or tName:find("kunci") then
                           local cleanKey = tName:gsub("key", ""):gsub("kunci", ""):gsub("%s+", "")
                           local locks = findEntities({"lock", "gembok", "padlock", "door", "pintu"}, {"key", "kunci"})
                           
                           for _, lock in ipairs(locks) do
                               local lName = lock.Name:lower()
                               if (cleanKey ~= "" and lName:find(cleanKey)) or cleanKey == "" then
                                   local cf = getObjPos(lock)
                                   if cf then
                                       local hum = char and char:FindFirstChildOfClass("Humanoid")
                                       if hum and tool.Parent == backpack then
                                           hum:EquipTool(tool)
                                           task.wait(0.1)
                                       end
                                       tpTo(cf)
                                       task.wait(0.15)
                                       interactWith(lock)
                                       Rayfield:Notify({Title = "Instant Unlock", Content = "Unlocked using: " .. tool.Name, Duration = 2})
                                       task.wait(1)
                                       break
                                   end
                               end
                           end
                       end
                   end
                   task.wait(0.5)
               end
           end)
       end
   end,
})
