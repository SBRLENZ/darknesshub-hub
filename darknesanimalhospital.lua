local Lib = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Plrs = game:GetService("Players")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local Lgt = game:GetService("Lighting")
local LP = Plrs.LocalPlayer

local Win = Lib:CreateWindow({
   Name = "DARKNES HUB | Animal Hospital (EN Language)",
   LoadingTitle = "DARKNES HUB ULTIMATE",
   LoadingSubtitle = "SBRLENZ x VEXUS STYLE",
   ConfigurationSaving = { Enabled = true, FolderName = "DarknesCfg", FileName = "AnimalHospitalEN" },
   KeySystem = false
})

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

local kwAnomali = {"anomaly", "glitch", "candle", "monster", "ghost", "boss", "shock", "fire"}
local kwPasien  = {"patient", "animal", "pet"}
local kwObat    = {"med", "medicine", "cure", "potion", "syringe", "blood", "vitamin"}
local kwDaftar  = {"register", "reception", "queue", "check in"}
local kwBeli    = {"buy", "purchase", "shop", "store"}
local kwKopi    = {"coffee", "brew", "espresso"}
local kwDokter  = {"doctor", "timer", "shift", "arrival"}
local kwTugas   = {"board", "photo", "computer", "printer", "clip", "file"}

-- ==========================================
-- FLOATING PING & MS WIDGET (Draggable & Toggleable)
-- ==========================================
local pingGui = Instance.new("ScreenGui")
pingGui.Name = "DarknesPingGui"
pingGui.Parent = game:GetService("CoreGui")
pingGui.Enabled = true

local pingFrame = Instance.new("Frame")
pingFrame.Size = UDim2.new(0, 160, 0, 35)
pingFrame.Position = UDim2.new(0, 50, 0, 50)
pingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
pingFrame.BorderSizePixel = 0
pingFrame.Active = true
pingFrame.Draggable = true
pingFrame.Parent = pingGui

local corner = Instance.new("UICorner", pingFrame)
corner.CornerRadius = UDim.new(0, 6)

local stroke = Instance.new("UIStroke", pingFrame)
stroke.Color = Color3.fromRGB(0, 150, 255)
stroke.Thickness = 1.5

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

-- ==========================================
-- TAB 0: MAIN (Language Settings & Overview)
-- ==========================================
local tMain = Win:CreateTab("Main", 4483362458)
tMain:CreateDropdown({
    Name = "Select Language / Pilih Bahasa",
    Options = {"English (Default)", "Indonesia (Translation Note)"},
    CurrentOption = "English (Default)",
    Callback = function(v)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DARKNES HUB",
            Text = "Language set to: " .. v,
            Duration = 3
        })
    end
})

tMain:CreateParagraph({ Title = "Hub Information", Content = "DARKNES HUB is fully optimized for Animal Hospital with Vexus features integrated. All texts and logs are now in English." })

-- ==========================================
-- TAB 1: VISUAL (ESP & DOCTOR TIMER)
-- ==========================================
local t1 = Win:CreateTab("Visual", 4483362458)
local espAnom, espPat, espPlr = false, false, false

t1:CreateToggle({ Name = "ESP Anomaly (Red)", CurrentValue = false, Callback = function(v)
    espAnom = v
    task.spawn(function()
        while espAnom do
            for _, o in ipairs(WS:GetDescendants()) do
                if (o:IsA("Model") or o:IsA("BasePart")) and not Plrs:GetPlayerFromCharacter(o) then
                    if match(o.Name, kwAnomali) and not o:FindFirstChild("_espAnom") then
                        local h = Instance.new("Highlight", o)
                        h.Name = "_espAnom"
                        h.FillColor = Color3.fromRGB(255, 0, 0)
                        h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end
                end
            end
            task.wait(1.5)
        end
    end)
end })

t1:CreateToggle({ Name = "ESP Patient (Blue)", CurrentValue = false, Callback = function(v)
    espPat = v
    task.spawn(function()
        while espPat do
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
end })

t1:CreateToggle({ Name = "ESP Player (Green)", CurrentValue = false, Callback = function(v)
    espPlr = v
    task.spawn(function()
        while espPlr do
            for _, p in ipairs(Plrs:GetPlayers()) do
                if p ~= LP and p.Character and not p.Character:FindFirstChild("_espPlr") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "_espPlr"
                    h.FillColor = Color3.fromRGB(0, 255, 0)
                end
            end
            task.wait(1.5)
        end
    end)
end })

t1:CreateToggle({ Name = "Fullbright", CurrentValue = false, Callback = function(v)
    Lgt.Brightness = v and 3 or 1
    Lgt.GlobalShadows = not v
end })

t1:CreateToggle({ Name = "Ping & MS Widget (On/Off)", CurrentValue = true, Callback = function(v)
    pingGui.Enabled = v
end })

local docPara = t1:CreateParagraph({ Title = "Doctor Schedule / Shift Timer", Content = "Scanning timer..." })
task.spawn(function()
    while true do
        local foundText = "Waiting for doctor shift..."
        for _, obj in ipairs(WS:GetDescendants()) do
            if obj:IsA("TextLabel") and (match(obj.Name, kwDokter) or match(obj.Text, kwDokter)) then
                if obj.Text ~= "" then
                    foundText = obj.Text
                    break
                end
            end
        end
        docPara:Set({ Title = "Doctor Schedule / Shift Timer", Content = foundText })
        task.wait(2)
    end
end)

-- ==========================================
-- TAB 2: AUTO FARM & VEXUS FEATURES (Sanity, Revive, Tasks)
-- ==========================================
local t2 = Win:CreateTab("Auto Farm", 4483362458)
local autoServiceAll, autoBuyFlag, infiniteSanity, autoReviveFlag = false, false, false, false

t2:CreateToggle({ Name = "Auto Service Patients & Shock Anomaly", CurrentValue = false, Callback = function(v)
    autoServiceAll = v
    task.spawn(function()
        while autoServiceAll do
            local r = root()
            if r then
                local anomalyFound = false
                for _, obj in ipairs(WS:GetDescendants()) do
                    if not autoServiceAll then break end
                    if (obj:IsA("Model") or obj:IsA("BasePart")) and match(obj.Name, kwAnomali) and not Plrs:GetPlayerFromCharacter(obj) then
                        local target = obj:IsA("Model") and (obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")) or obj
                        if target and target:IsA("BasePart") then
                            anomalyFound = true
                            r.CFrame = target.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.2)
                            for _, pr in ipairs(obj:GetDescendants()) do
                                if pr:IsA("ProximityPrompt") and fireproximityprompt then 
                                    fireproximityprompt(pr) 
                                end
                            end
                            task.wait(0.4)
                            break
                        end
                    end
                end

                if not anomalyFound then
                    for _, obj in ipairs(WS:GetDescendants()) do
                        if not autoServiceAll then break end
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
end })

-- Vexus Feature: Infinite Sanity (Mencegah Sanity Habis / Jumpscare)
t2:CreateToggle({ Name = "Infinite Sanity (Vexus Feature)", CurrentValue = false, Callback = function(v)
    infiniteSanity = v
    task.spawn(function()
        while infiniteSanity do
            pcall(function()
                for _, stat in ipairs(LP:GetDescendants()) do
                    if stat.Name:lower():find("sanity") or stat.Name:lower():find("fear") or stat.Name:lower():find("kewarasan") then
                        if stat:IsA("NumberValue") or stat:IsA("IntValue") then
                            stat.Value = 100
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end })

-- Vexus Feature: Auto Revive (Bangkit otomatis saat down/mati)
t2:CreateToggle({ Name = "Auto Revive (Vexus Feature)", CurrentValue = false, Callback = function(v)
    autoReviveFlag = v
    task.spawn(function()
        while autoReviveFlag do
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
end })

t2:CreateToggle({ Name = "Auto Buy Items (Exclude Robux)", CurrentValue = false, Callback = function(v)
    autoBuyFlag = v
    task.spawn(function()
        while autoBuyFlag do
            local r = root()
            if r then
                for _, pr in ipairs(WS:GetDescendants()) do
                    if not autoBuyFlag then break end
                    if pr:IsA("ProximityPrompt") then
                        local textAll = (pr.ActionText .. " " .. pr.ObjectText):lower()
                        if (match(textAll, kwBeli) or match(textAll, kwObat)) and not textAll:find("robux") then
                            local part = pr.Parent:IsA("BasePart") and pr.Parent or pr.Parent:FindFirstChildWhichIsA("BasePart")
                            if part then
                                r.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                                task.wait(0.3)
                                if fireproximityprompt then fireproximityprompt(pr) end
                                task.wait(0.5)
                            end
                        end
                    end
                end
            end
            task.wait(2)
        end
    end)
end })

-- ==========================================
-- TAB 3: EXCLUSIVE (Room TP, Spectate, NPC Scanner)
-- ==========================================
local t3 = Win:CreateTab("Exclusive", 4483362458)

t3:CreateDropdown({
    Name = "Teleport to Room / Lobby",
    Options = {"Main Lobby (Respawn)", "Room 1", "Room 2", "Room 3", "Room 4", "Room 5", "Room 6", "Room 7", "Room 8 (Surgery)"},
    CurrentOption = "Main Lobby (Respawn)",
    Callback = function(v)
        local r = root()
        if not r then return end
        if v:find("Lobby") then
            local sp = WS:FindFirstChildWhichIsA("SpawnLocation", true)
            if sp then r.CFrame = sp.CFrame + Vector3.new(0, 3, 0) end
        else
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("BasePart") and match(obj.Name, {v:lower()}) then
                    r.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                    break
                end
            end
        end
    end
})

-- Spectate Player + Next Button (Arrows)
local spectateOn = false
local specIndex = 1
t3:CreateToggle({ Name = "Spectate Player (On/Off)", CurrentValue = false, Callback = function(v)
    spectateOn = v
    if not spectateOn then
        workspace.CurrentCamera.CameraSubject = hum()
    end
end })

t3:CreateButton({ Name = "Next Player to Spectate [ > ]", Callback = function()
    if not spectateOn then return end
    local pList = Plrs:GetPlayers()
    specIndex = specIndex + 1
    if specIndex > #pList then specIndex = 1 end
    local targetPlr = pList[specIndex]
    if targetPlr == LP then
        specIndex = specIndex + 1
        if specIndex > #pList then specIndex = 1 end
        targetPlr = pList[specIndex]
    end
    if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChildOfClass("Humanoid") then
        workspace.CurrentCamera.CameraSubject = targetPlr.Character:FindFirstChildOfClass("Humanoid")
    end
end })

task.spawn(function()
    while true do
        if spectateOn then
            local pList = Plrs:GetPlayers()
            local targetPlr = pList[specIndex]
            if targetPlr and targetPlr ~= LP and targetPlr.Character and targetPlr.Character:FindFirstChildOfClass("Humanoid") then
                workspace.CurrentCamera.CameraSubject = targetPlr.Character:FindFirstChildOfClass("Humanoid")
            end
        end
        task.wait(2)
    end
end)

-- Auto Scanner NPC Status (None / Normal / Anomaly)
local scanPara = t3:CreateParagraph({ Title = "Auto NPC Scanner Status", Content = "NPC Status: None" })
task.spawn(function()
    while true do
        local statusText = "NPC Status: None"
        for _, obj in ipairs(WS:GetDescendants()) do
            if obj:IsA("Model") and not Plrs:GetPlayerFromCharacter(obj) then
                if match(obj.Name, kwAnomali) then
                    statusText = "NPC Status: ⚠️ ANOMALY DETECTED! (" .. obj.Name .. ")"
                    break
                elseif match(obj.Name, kwPasien) or obj:FindFirstChildOfClass("Humanoid") then
                    statusText = "NPC Status: ✅ NORMAL (Patient ready)"
                end
            end
        end
        scanPara:Set({ Title = "Auto NPC Scanner Status", Content = statusText })
        task.wait(1.5)
    end
end)

local instantInteractOn = false
t3:CreateToggle({ Name = "Instant Interact (On/Off Toggle)", CurrentValue = false, Callback = function(v)
    instantInteractOn = v
    task.spawn(function()
        while instantInteractOn do
            for _, p in ipairs(WS:GetDescendants()) do
                if p:IsA("ProximityPrompt") then
                    p.HoldDuration = 0
                end
            end
            task.wait(1)
        end
    end)
end })

local safeNoclip, tpCoffeeLoop = false, false
t3:CreateToggle({ Name = "Safe Noclip (Anti-Fall)", CurrentValue = false, Callback = function(v)
    safeNoclip = v
end })

RS.Stepped:Connect(function()
    if safeNoclip and LP.Character then
        for _, p in ipairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" and p.Name ~= "LeftFoot" and p.Name ~= "RightFoot" and p.Name ~= "LowerTorso" then
                p.CanCollide = false
            end
        end
    end
end)

t3:CreateToggle({ Name = "Teleport to Coffee (TP, Take & Return)", CurrentValue = false, Callback = function(v)
    tpCoffeeLoop = v
    task.spawn(function()
        while tpCoffeeLoop do
            local r = root()
            if r then
                local savedPos = r.CFrame
                for _, obj in ipairs(WS:GetDescendants()) do
                    if not tpCoffeeLoop then break end
                    if match(obj.Name, kwKopi) then
                        local target = obj:IsA("Model") and (obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")) or (obj:IsA("BasePart") and obj)
                        if target then
                            for _, pr in ipairs(obj:GetDescendants()) do
                                if pr:IsA("ProximityPrompt") then
                                    local pText = (pr.ActionText .. " " .. pr.ObjectText):lower()
                                    if not pText:find("robux") and not pText:find("buy") then
                                        r.CFrame = target.CFrame + Vector3.new(0, 3, 0)
                                        task.wait(0.3)
                                        if fireproximityprompt then fireproximityprompt(pr) end
                                        task.wait(0.4)
                                        r.CFrame = savedPos
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(4)
        end
    end)
end })

-- ==========================================
-- TAB 4: UTILITY & TELEGRAM
-- ==========================================
local t4 = Win:CreateTab("Utility", 4483362458)
local sid, svol, snd = "6023426915", 1, nil

t4:CreateInput({ Name = "Play Music (Roblox Audio ID)", PlaceholderText = "Sound ID", Callback = function(t) sid = t end })
t4:CreateSlider({ Name = "Music Volume", Range = {0.1, 5}, Increment = 0.1, CurrentValue = 1, Callback = function(v) svol = v if snd then snd.Volume = v end end })
t4:CreateToggle({ Name = "Play / Stop Music", CurrentValue = false, Callback = function(s)
    if s then
        if snd then snd:Destroy() end
        local r = root()
        if r then
            snd = Instance.new("Sound", r)
            snd.SoundId = "rbxassetid://" .. tostring(sid)
            snd.Volume = svol
            snd.Looped = true
            snd:Play()
        end
    else
        if snd then snd:Stop() snd:Destroy() snd = nil end
    end
end })

t4:CreateButton({ Name = "Chat Owner via Telegram (@ManzXDzx)", Callback = function()
    if setclipboard then
        setclipboard("https://t.me/ManzXDzx")
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "DARKNES HUB", Text = "Telegram copied: https://t.me/ManzXDzx", Duration = 5 })
    end
end })

t4:CreateButton({ Name = "Auto Skip Doctor Dialogue", Callback = function()
    for _, gui in ipairs(LP.PlayerGui:GetDescendants()) do
        if gui:IsA("TextButton") and (gui.Text:lower():find("skip") or gui.Text:lower():find("next") or gui.Text:lower():find("continue")) then
            if getconnections then
                for _, conn in ipairs(getconnections(gui.MouseButton1Click)) do conn:Fire() end
            end
        end
    end
end })

t4:CreateButton({ Name = "Unload Hub UI", Callback = function() 
    if pingGui then pingGui:Destroy() end
    if statsConn then statsConn:Disconnect() end
    Lib:Destroy() 
end })
