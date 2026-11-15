local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "DARKNES HUB | Rumah Opah",
    LoadingTitle = "DARKNES HUB",
    LoadingSubtitle = "Rumah Opah",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DarknesHub",
        FileName = "RumahOpahConfig"
    },
    KeySystem = false
})

local TabMain = Window:CreateTab("Main & Info", 4483362458)
local TabVisual = Window:CreateTab("Visual & ESP", 4483362458)
local TabFarm = Window:CreateTab("Farming & Bring", 4483362458)
local TabTP = Window:CreateTab("Teleport", 4483362458)
local TabEx = Window:CreateTab("Eksklusif", 4483362458)
local TabUtil = Window:CreateTab("Utility & Music", 4483362458)

local function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function hum()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function matchName(str, list)
    if not str then return false end
    local low = string.lower(str)
    for _, k in ipairs(list) do
        if low:find(k, 1, true) then return true end
    end
    return false
end

local kwKey = {"key", "kunci"}
local kwFlip = {"flip", "flop", "sandal", "shoe", "slippers", "sendal"}
local kwCode = {"code", "password", "sandi", "pin", "kode"}
local kwLemari = {"lemari", "cabinet", "closet", "wardrobe", "hide", "cupboard"}
local kwOpah = {"opah", "granny", "nenek", "npc", "monster"}
local kwMotor = {"motor", "bike", "motorcycle", "scooter", "vehicle", "seat"}

local function findParts(keywords)
    local found = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            if matchName(obj.Name, keywords) then
                local part = obj
                if obj:IsA("Model") then
                    part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                end
                if part and part:IsA("BasePart") then
                    table.insert(found, part)
                end
            end
        end
    end
    return found
end

local function findOpah()
    for _, m in ipairs(Workspace:GetDescendants()) do
        if m:IsA("Model") and matchName(m.Name, kwOpah) then
            local hrp = m:FindFirstChild("HumanoidRootPart") or m:FindFirstChildWhichIsA("BasePart")
            if hrp then return m, hrp end
        end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and matchName(p.Name, kwOpah) then
            local c = p.Character
            if c then
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hrp then return c, hrp end
            end
        end
    end
    return nil, nil
end

local function tpTo(cf)
    local r = getRoot()
    if r then r.CFrame = cf end
end

-- ESP System via Rayfield Toggles
local espFolder = Instance.new("Folder")
espFolder.Name = "DarknesRayfieldESP"
espFolder.Parent = CoreGui

local function clearESP()
    for _, obj in ipairs(CoreGui:GetDescendants()) do
        if obj.Name == "DarknesESP_HL" then obj:Destroy() end
    end
end

local function applyESP(keywords, color)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("Model")) and matchName(obj.Name, keywords) then
            local target = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
            if target and not target:FindFirstChild("DarknesESP_HL") then
                local h = Instance.new("Highlight", target)
                h.Name = "DarknesESP_HL"
                h.FillColor = color
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.FillTransparency = 0.4
            end
        end
    end
end

-- TAB 1: MAIN & INFO
TabMain:CreateSection("Informasi Hub")
TabMain:CreateLabel("Halo @" .. (LP.DisplayName or LP.Name))
TabMain:CreateLabel("DARKNES HUB")
TabMain:CreateButton({
    Name = "Copy Link Discord Komunitas",
    Callback = function()
        pcall(function() setclipboard("https://discord.gg/jzDxbbJhy") end)
        Rayfield:Notify({Title = "Discord", Content = "Link Discord berhasil disalin.", Duration = 2})
    end
})

-- TAB 2: VISUAL & ESP
TabVisual:CreateSection("ESP Options")

TabVisual:CreateToggle({
    Name = "ESP Opah",
    CurrentValue = false,
    Callback = function(v)
        if v then
            task.spawn(function()
                while v do
                    local model, _ = findOpah()
                    if model and not model:FindFirstChild("DarknesESP_HL") then
                        local h = Instance.new("Highlight", model)
                        h.Name = "DarknesESP_HL"
                        h.FillColor = Color3.fromRGB(255, 40, 40)
                    end
                    task.wait(2)
                end
            end)
        else
            clearESP()
        end
    end
})

TabVisual:CreateToggle({
    Name = "ESP Kunci",
    CurrentValue = false,
    Callback = function(v)
        if v then applyESP(kwKey, Color3.fromRGB(255, 220, 50)) else clearESP() end
    end
})

TabVisual:CreateToggle({
    Name = "ESP Code",
    CurrentValue = false,
    Callback = function(v)
        if v then applyESP(kwCode, Color3.fromRGB(100, 255, 140)) else clearESP() end
    end
})

TabVisual:CreateToggle({
    Name = "ESP Flip Flop",
    CurrentValue = false,
    Callback = function(v)
        if v then applyESP(kwFlip, Color3.fromRGB(255, 140, 80)) else clearESP() end
    end
})

TabVisual:CreateToggle({
    Name = "ESP Lemari Hide",
    CurrentValue = false,
    Callback = function(v)
        if v then applyESP(kwLemari, Color3.fromRGB(160, 120, 255)) else clearESP() end
    end
})

TabVisual:CreateSection("Environment")

local origBrightness = Lighting.Brightness
local origShadows = Lighting.GlobalShadows
local origFogEnd = Lighting.FogEnd

TabVisual:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Callback = function(v)
        if v then
            Lighting.Brightness = 3
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 14
        else
            Lighting.Brightness = origBrightness
            Lighting.GlobalShadows = origShadows
        end
    end
})

TabVisual:CreateToggle({
    Name = "No Fog",
    CurrentValue = false,
    Callback = function(v)
        if v then
            Lighting.FogEnd = 100000
        else
            Lighting.FogEnd = origFogEnd or 1000
        end
    end
})

-- TAB 3: FARMING & BRING
TabFarm:CreateSection("Auto Collect & Bring")

TabFarm:CreateButton({
    Name = "Auto Collect All Flip Flop",
    Callback = function()
        local parts = findParts(kwFlip)
        task.spawn(function()
            for _, p in ipairs(parts) do
                local r = getRoot()
                if r then
                    r.CFrame = p.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.2)
                    pcall(function()
                        firetouchinterest(r, p, 0)
                        firetouchinterest(r, p, 1)
                    end)
                end
                task.wait(0.1)
            end
            Rayfield:Notify({Title = "Farming", Content = "Selesai mengumpulkan Flip Flop.", Duration = 2})
        end)
    end
})

TabFarm:CreateButton({
    Name = "Auto Collect All Kunci",
    Callback = function()
        local parts = findParts(kwKey)
        task.spawn(function()
            for _, p in ipairs(parts) do
                local r = getRoot()
                if r then
                    r.CFrame = p.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.2)
                    pcall(function()
                        firetouchinterest(r, p, 0)
                        firetouchinterest(r, p, 1)
                    end)
                    for _, d in ipairs(p:GetDescendants()) do
                        if d:IsA("ProximityPrompt") then pcall(function() fireproximityprompt(d) end) end
                    end
                end
                task.wait(0.15)
            end
            Rayfield:Notify({Title = "Farming", Content = "Selesai mengumpulkan Kunci.", Duration = 2})
        end)
    end
})

-- TAB 4: TELEPORT
TabTP:CreateSection("Location Teleport")

TabTP:CreateButton({
    Name = "Teleport ke Dapur",
    Callback = function()
        local parts = findParts({"dapur", "kitchen", "cook"})
        if #parts > 0 then tpTo(parts[1].CFrame + Vector3.new(0, 3, 0)) end
    end
})

TabTP:CreateButton({
    Name = "Teleport ke Safe Zone",
    Callback = function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("SpawnLocation") then tpTo(obj.CFrame + Vector3.new(0, 3, 0)) return end
        end
    end
})

TabTP:CreateButton({
    Name = "Teleport ke Opah",
    Callback = function()
        local _, hrp = findOpah()
        if hrp then tpTo(hrp.CFrame * CFrame.new(0, 0, 5)) end
    end
})

TabTP:CreateButton({
    Name = "Teleport ke Code",
    Callback = function()
        local parts = findParts(kwCode)
        if #parts > 0 then tpTo(parts[1].CFrame + Vector3.new(0, 3, 0)) end
    end
})

TabTP:CreateButton({
    Name = "Teleport ke Pintu",
    Callback = function()
        local parts = findParts({"pintu", "door", "front", "entrance"})
        if #parts > 0 then tpTo(parts[1].CFrame + Vector3.new(0, 0, 4)) end
    end
})

-- TAB 5: EKSKLUSIF
TabEx:CreateSection("Eksklusif")

local warnActive = false
local warnConn
TabEx:CreateToggle({
    Name = "Indicator Warn",
    CurrentValue = false,
    Callback = function(v)
        warnActive = v
        if warnConn then warnConn:Disconnect() warnConn = nil end
        if v then
            warnConn = RunService.RenderStepped:Connect(function()
                local r = getRoot()
                local _, ohrp = findOpah()
                if not r or not ohrp then return end
                local dist = (r.Position - ohrp.Position).Magnitude
                if dist < 25 then
                    Rayfield:Notify({Title = "WARNING", Content = "Opah sangat dekat! Jarak: " .. math.floor(dist) .. " meter", Duration = 0.5})
                end
            end)
        end
    end
})

local autoRunActive = false
local autoRunConn
TabEx:CreateToggle({
    Name = "Auto Run",
    CurrentValue = false,
    Callback = function(v)
        autoRunActive = v
        if autoRunConn then autoRunConn:Disconnect() autoRunConn = nil end
        if v then
            autoRunConn = RunService.Heartbeat:Connect(function()
                local r = getRoot()
                local _, ohrp = findOpah()
                if not r or not ohrp then return end
                if (r.Position - ohrp.Position).Magnitude < 18 then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("SpawnLocation") then r.CFrame = obj.CFrame + Vector3.new(0, 3, 0) return end
                    end
                end
            end)
        end
    end
})

local invisActive = false
TabEx:CreateToggle({
    Name = "Invisible",
    CurrentValue = false,
    Callback = function(v)
        invisActive = v
        local char = LP.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.LocalTransparencyModifier = v and 1 or 0
            end
        end
    end
})

local autoDriveActive = false
local driveConn
TabEx:CreateToggle({
    Name = "Auto Drive",
    CurrentValue = false,
    Callback = function(v)
        autoDriveActive = v
        if driveConn then driveConn:Disconnect() driveConn = nil end
        if not v then return end
        driveConn = RunService.Heartbeat:Connect(function()
            local char = LP.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.SeatPart == nil then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("VehicleSeat") then
                        local r = getRoot()
                        if r and (obj.Position - r.Position).Magnitude < 25 then
                            r.CFrame = obj.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.1)
                            obj:Sit(humanoid)
                        end
                    end
                end
            end
        end)
    end
})

local infStaminaActive = false
local staminaConn
TabEx:CreateToggle({
    Name = "Infinity Stamina",
    CurrentValue = false,
    Callback = function(v)
        infStaminaActive = v
        if staminaConn then staminaConn:Disconnect() staminaConn = nil end
        if v then
            staminaConn = RunService.Heartbeat:Connect(function()
                local char = LP.Character
                if char then
                    for _, v in ipairs(char:GetDescendants()) do
                        if v:IsA("NumberValue") or v:IsA("ValueBase") then
                            local name = v.Name:lower()
                            if name:find("stamina") or name:find("energy") or name:find("fatigue") or name:find("tired") then
                                v.Value = 100
                            end
                        end
                    end
                end
                local pGui = LP:FindFirstChild("PlayerGui")
                if pGui then
                    for _, d in ipairs(pGui:GetDescendants()) do
                        if d:IsA("NumberValue") or d:IsA("IntValue") then
                            local name = d.Name:lower()
                            if name:find("stamina") or name:find("energy") or name:find("fatigue") then
                                d.Value = 100
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- TAB 6: UTILITY & MUSIC
TabUtil:CreateSection("Music Player")

local musicSound = Instance.new("Sound")
musicSound.Name = "DarknesMusic"
musicSound.Looped = true
musicSound.Volume = 1
musicSound.Parent = Workspace

TabUtil:CreateInput({
    Name = "Roblox Audio ID",
    PlaceholderText = "Contoh: 1848354536",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local id = text:gsub("%s+", "")
        if id ~= "" then
            musicSound.SoundId = "rbxassetid://" .. id
            musicSound:Play()
        end
    end
})

TabUtil:CreateButton({
    Name = "Stop Music",
    Callback = function()
        musicSound:Stop()
    end
})

TabUtil:CreateSection("Server Utility")

TabUtil:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        local placeId = game.PlaceId
        local ok, servers = pcall(function()
            local req = game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")
            return HttpService:JSONDecode(req)
        end)
        if ok and servers and servers.data then
            for _, s in ipairs(servers.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(placeId, s.id, LP)
                    return
                end
            end
        end
        TeleportService:Teleport(placeId, LP)
    end
})

TabUtil:CreateButton({
    Name = "Copy Telegram Owner Link",
    Callback = function()
        pcall(function() setclipboard("https://t.me/ManzXDzx") end)
        Rayfield:Notify({Title = "Telegram", Content = "Link Telegram berhasil disalin.", Duration = 2})
    end
})

Rayfield:LoadConfiguration()
