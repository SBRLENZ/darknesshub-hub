local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local LP = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "DARKNES HUB | Rumah Opah",
    LoadingTitle = "DARKNES HUB",
    LoadingSubtitle = "Malam Bersama Opah",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DarknesHub",
        FileName = "RumahOpahV2"
    },
    KeySystem = false
})

-- TABS
local TabMain = Window:CreateTab("Main & Lobby", 4483362458)
local TabEnding = Window:CreateTab("Secret Ending", 4483362458)
local TabFarm = Window:CreateTab("Auto & Bring", 4483362458)
local TabVisual = Window:CreateTab("Visual & ESP", 4483362458)
local TabEx = Window:CreateTab("Protection & Excl", 4483362458)
local TabUtil = Window:CreateTab("Utility & Music", 4483362458)

-- HELPERS
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
local kwCode = {"code", "password", "sandi", "pin", "kode", "note", "kertas"}
local kwLemari = {"lemari", "cabinet", "closet", "wardrobe", "hide", "cupboard"}
local kwOpah = {"opah", "granny", "nenek", "npc", "monster"}
local kwSecret = {"secret", "attic", "loteng", "rahasia", "ending", "altar", "ritual", "basement", "bawah"}

local function findParts(keywords)
    local found = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") yor obj:IsA("Model") then
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

local function triggerAllPrompts(parentObj)
    for _, d in ipairs(parentObj:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            pcall(function() fireproximityprompt(d) end)
        end
    end
end

-- ==========================================
-- TAB 1: MAIN & LOBBY
-- ==========================================
TabMain:CreateSection("Hub Information")
TabMain:CreateLabel("User: @" .. (LP.DisplayName or LP.Name))
TabMain:CreateButton({
    Name = "Copy Discord Community",
    Callback = function()
        pcall(function() setclipboard("https://discord.gg/jzDxbbJhy") end)
        Rayfield:Notify({Title = "Discord", Content = "Link Discord disalin ke clipboard.", Duration = 2})
    end
})

TabMain:CreateSection("Lobby & Gacha Utilities")

TabMain:CreateButton({
    Name = "Teleport to Lobby / Spawn",
    Callback = function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("SpawnLocation") then
                tpTo(obj.CFrame + Vector3.new(0, 3, 0))
                Rayfield:Notify({Title = "Teleport", Content = "Berhasil kembali ke Spawn.", Duration = 2})
                return
            end
        end
    end
})

TabMain:CreateButton({
    Name = "Auto Trigger Gacha / Spin Prompts",
    Callback = function()
        local triggered = 0
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if matchName(obj.Name, {"gacha", "spin", "roll", "skill", "crate", "shop"}) then
                triggerAllPrompts(obj)
                triggered = triggered + 1
            end
        end
        Rayfield:Notify({Title = "Lobby Gacha", Content = "Mencoba memicu " .. tostring(triggered) .. " objek gacha.", Duration = 2})
    end
})

-- ==========================================
-- TAB 2: SECRET ENDING HELPER
-- ==========================================
TabEnding:CreateSection("Secret Ending Automation")

TabEnding:CreateButton({
    Name = "Scan & Notify Passcode / Clues",
    Callback = function()
        local foundCodes = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
                for _, lbl in ipairs(obj:GetDescendants()) do
                    if lbl:IsA("TextLabel") and lbl.Text:match("%d%d%d+") then
                        table.insert(foundCodes, lbl.Text)
                    end
                end
            end
        end
        if #foundCodes > 0 then
            Rayfield:Notify({Title = "Code Terdeteksi", Content = "Ditemukan angka: " .. table.concat(foundCodes, ", "), Duration = 6})
        else
            Rayfield:Notify({Title = "Code Scanner", Content = "Belum ada angka kode terlihat di layar/kertas.", Duration = 3})
        end
    end
})

TabEnding:CreateButton({
    Name = "Auto Input / Trigger Keypad & Locks",
    Callback = function()
        local count = 0
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if matchName(obj.Name, {"keypad", "padlock", "lock", "brankas", "safe", "door", "pintu", "passcode"}) then
                triggerAllPrompts(obj)
                count = count + 1
            end
        end
        Rayfield:Notify({Title = "Passcode Helper", Content = "Memicu interaksi pada " .. tostring(count) .. " kunci/keypad.", Duration = 2})
    end
})

TabEnding:CreateButton({
    Name = "Teleport to Secret Area / Attic",
    Callback = function()
        local parts = findParts(kwSecret)
        if #parts > 0 then
            tpTo(parts[1].CFrame + Vector3.new(0, 3, 0))
            Rayfield:Notify({Title = "Secret Ending", Content = "Teleport ke area rahasia: " .. parts[1].Name, Duration = 3})
        else
            Rayfield:Notify({Title = "Secret Ending", Content = "Area rahasia belum ter-load di map.", Duration = 3})
        end
    end
})

TabEnding:CreateButton({
    Name = "Collect All Secret Ritual Items",
    Callback = function()
        local parts = findParts({"ritual", "boneka", "doll", "foto", "photo", "diary", "buku", "book", "artifact", "secret"})
        task.spawn(function()
            local r = getRoot()
            if not r then return end
            local orig = r.CFrame
            for _, p in ipairs(parts) do
                r.CFrame = p.CFrame + Vector3.new(0, 2, 0)
                task.wait(0.2)
                pcall(function()
                    firetouchinterest(r, p, 0)
                    firetouchinterest(r, p, 1)
                end)
                if p.Parent then triggerAllPrompts(p.Parent) end
                task.wait(0.15)
            end
            r.CFrame = orig
            Rayfield:Notify({Title = "Secret Ending", Content = "Selesai mengecek " .. tostring(#parts) .. " item rahasia.", Duration = 3})
        end)
    end
})

-- ==========================================
-- TAB 3: AUTO FARM & BRING
-- ==========================================
TabFarm:CreateSection("Auto Collect Items")

TabFarm:CreateButton({
    Name = "Auto Collect All Kunci (Keys)",
    Callback = function()
        local parts = findParts(kwKey)
        task.spawn(function()
            local r = getRoot()
            if not r then return end
            local orig = r.CFrame
            for _, p in ipairs(parts) do
                r.CFrame = p.CFrame + Vector3.new(0, 2, 0)
                task.wait(0.2)
                pcall(function()
                    firetouchinterest(r, p, 0)
                    firetouchinterest(r, p, 1)
                end)
                if p.Parent then triggerAllPrompts(p.Parent) end
                task.wait(0.15)
            end
            r.CFrame = orig
            Rayfield:Notify({Title = "Auto Collect", Content = "Selesai mengumpulkan Kunci.", Duration = 2})
        end)
    end
})

TabFarm:CreateButton({
    Name = "Auto Collect All Flip Flops",
    Callback = function()
        local parts = findParts(kwFlip)
        task.spawn(function()
            local r = getRoot()
            if not r then return end
            local orig = r.CFrame
            for _, p in ipairs(parts) do
                r.CFrame = p.CFrame + Vector3.new(0, 2, 0)
                task.wait(0.2)
                pcall(function()
                    firetouchinterest(r, p, 0)
                    firetouchinterest(r, p, 1)
                end)
                task.wait(0.1)
            end
            r.CFrame = orig
            Rayfield:Notify({Title = "Auto Collect", Content = "Selesai mengumpulkan Flip Flop.", Duration = 2})
        end)
    end
})

TabFarm:CreateSection("Direct Teleports")

TabFarm:CreateButton({
    Name = "Teleport to Code / Note",
    Callback = function()
        local parts = findParts(kwCode)
        if #parts > 0 then tpTo(parts[1].CFrame + Vector3.new(0, 3, 0)) end
    end
})

TabFarm:CreateButton({
    Name = "Teleport to Dapur",
    Callback = function()
        local parts = findParts({"dapur", "kitchen", "cook"})
        if #parts > 0 then tpTo(parts[1].CFrame + Vector3.new(0, 3, 0)) end
    end
})

TabFarm:CreateButton({
    Name = "Teleport to Pintu Utama",
    Callback = function()
        local parts = findParts({"pintu", "door", "front", "entrance"})
        if #parts > 0 then tpTo(parts[1].CFrame + Vector3.new(0, 0, 4)) end
    end
})

-- ==========================================
-- TAB 4: VISUAL & ESP
-- ==========================================
local function clearESPByTag(tag)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == tag then obj:Destroy() end
    end
end

local function applyESPByTag(keywords, color, tag)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("Model")) and not Players:GetPlayerFromCharacter(obj) then
            if matchName(obj.Name, keywords) then
                local target = obj:IsA("Model") and obj or obj
                if target and not target:FindFirstChild(tag) then
                    local h = Instance.new("Highlight", target)
                    h.Name = tag
                    h.FillColor = color
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.FillTransparency = 0.4
                end
            end
        end
    end
end

TabVisual:CreateSection("Entity & Item ESP")

local espOpahOn = false
TabVisual:CreateToggle({
    Name = "ESP Opah / Monster",
    CurrentValue = false,
    Callback = function(v)
        espOpahOn = v
        if not v then clearESPByTag("_ESPOpah") return end
        task.spawn(function()
            while espOpahOn do
                local model, _ = findOpah()
                if model and not model:FindFirstChild("_ESPOpah") then
                    local h = Instance.new("Highlight", model)
                    h.Name = "_ESPOpah"
                    h.FillColor = Color3.fromRGB(255, 35, 35)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
                task.wait(1.5)
            end
        end)
    end
})

local espPlrOn = false
TabVisual:CreateToggle({
    Name = "ESP Players",
    CurrentValue = false,
    Callback = function(v)
        espPlrOn = v
        if not v then clearESPByTag("_ESPPlayer") return end
        task.spawn(function()
            while espPlrOn do
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and not p.Character:FindFirstChild("_ESPPlayer") then
                        local h = Instance.new("Highlight", p.Character)
                        h.Name = "_ESPPlayer"
                        h.FillColor = Color3.fromRGB(0, 200, 255)
                    end
                end
                task.wait(2)
            end
        end)
    end
})

TabVisual:CreateToggle({
    Name = "ESP Kunci (Keys)",
    CurrentValue = false,
    Callback = function(v)
        if v then applyESPByTag(kwKey, Color3.fromRGB(255, 220, 50), "_ESPKey") else clearESPByTag("_ESPKey") end
    end
})

TabVisual:CreateToggle({
    Name = "ESP Code / Notes",
    CurrentValue = false,
    Callback = function(v)
        if v then applyESPByTag(kwCode, Color3.fromRGB(80, 255, 120), "_ESPCode") else clearESPByTag("_ESPCode") end
    end
})

TabVisual:CreateToggle({
    Name = "ESP Flip Flop",
    CurrentValue = false,
    Callback = function(v)
        if v then applyESPByTag(kwFlip, Color3.fromRGB(255, 140, 60), "_ESPFlip") else clearESPByTag("_ESPFlip") end
    end
})

TabVisual:CreateToggle({
    Name = "ESP Lemari Hide",
    CurrentValue = false,
    Callback = function(v)
        if v then applyESPByTag(kwLemari, Color3.fromRGB(170, 110, 255), "_ESPLemari") else clearESPByTag("_ESPLemari") end
    end
})

TabVisual:CreateSection("Lighting")

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
        Lighting.FogEnd = v and 100000 or (origFogEnd or 1000)
    end
})

-- ==========================================
-- TAB 5: PROTECTION & EXCLUSIVE
-- ==========================================
TabEx:CreateSection("Sprint & Movement")

local staminaConn
TabEx:CreateToggle({
    Name = "Infinity Stamina",
    CurrentValue = false,
    Callback = function(v)
        if staminaConn then staminaConn:Disconnect() staminaConn = nil end
        if v then
            staminaConn = RunService.Heartbeat:Connect(function()
                local char = LP.Character
                if char then
                    for _, val in ipairs(char:GetDescendants()) do
                        if val:IsA("NumberValue") or val:IsA("IntValue") then
                            local n = val.Name:lower()
                            if n:find("stamina") or n:find("energy") or n:find("fatigue") or n:find("sprint") then
                                val.Value = 100
                            end
                        end
                    end
                end
                local pGui = LP:FindFirstChild("PlayerGui")
                if pGui then
                    for _, val in ipairs(pGui:GetDescendants()) do
                        if val:IsA("NumberValue") or val:IsA("IntValue") then
                            local n = val.Name:lower()
                            if n:find("stamina") or n:find("energy") or n:find("fatigue") then
                                val.Value = 100
                            end
                        end
                    end
                end
            end)
        end
    end
})

local targetSpeed = 16
local lockSpeed = false
TabEx:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 75},
    Increment = 1,
    Suffix = " WS",
    CurrentValue = 16,
    Callback = function(val)
        targetSpeed = val
        if hum() then hum().WalkSpeed = val end
    end
})

TabEx:CreateToggle({
    Name = "Lock WalkSpeed",
    CurrentValue = false,
    Callback = function(v)
        lockSpeed = v
        task.spawn(function()
            while lockSpeed do
                if hum() then hum().WalkSpeed = targetSpeed end
                task.wait(0.2)
            end
        end)
    end
})

local noclipOn = false
TabEx:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(v)
        noclipOn = v
    end
})

RunService.Stepped:Connect(function()
    if noclipOn and LP.Character then
        for _, part in ipairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

TabEx:CreateSection("Opah Protection & Anti-Jumpscare")

local warnConn
TabEx:CreateToggle({
    Name = "Proximity Warn (Deteksi Jarak Opah)",
    CurrentValue = false,
    Callback = function(v)
        if warnConn then warnConn:Disconnect() warnConn = nil end
        if v then
            local lastWarn = 0
            warnConn = RunService.Heartbeat:Connect(function()
                local r = getRoot()
                local _, ohrp = findOpah()
                if r and ohrp then
                    local dist = (r.Position - ohrp.Position).Magnitude
                    if dist < 25 and (tick() - lastWarn) > 2 then
                        lastWarn = tick()
                        Rayfield:Notify({Title = "PERINGATAN", Content = "Opah mendekat! Jarak: " .. math.floor(dist) .. " studs", Duration = 1.5})
                    end
                end
            end)
        end
    end
})

local autoDodgeConn
TabEx:CreateToggle({
    Name = "Anti-Jumpscare / Auto Evade Opah",
    CurrentValue = false,
    Callback = function(v)
        if autoDodgeConn then autoDodgeConn:Disconnect() autoDodgeConn = nil end
        if v then
            autoDodgeConn = RunService.Heartbeat:Connect(function()
                local r = getRoot()
                local _, ohrp = findOpah()
                if r and ohrp and (r.Position - ohrp.Position).Magnitude < 16 then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("SpawnLocation") then
                            r.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                            return
                        end
                    end
                end
            end)
        end
    end
})

TabEx:CreateToggle({
    Name = "Invisible (Client Transparency)",
    CurrentValue = false,
    Callback = function(v)
        local char = LP.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.LocalTransparencyModifier = v and 1 or 0
            end
        end
    end
})

-- ==========================================
-- TAB 6: UTILITY & MUSIC
-- ==========================================
TabUtil:CreateSection("Interaction & Anti-AFK")

local instantInteractOn = false
TabUtil:CreateToggle({
    Name = "Instant Interact (No Hold)",
    CurrentValue = false,
    Callback = function(v)
        instantInteractOn = v
        task.spawn(function()
            while instantInteractOn do
                for _, p in ipairs(Workspace:GetDescendants()) do
                    if p:IsA("ProximityPrompt") then p.HoldDuration = 0 end
                end
                task.wait(1)
            end
        end)
    end
})

local antiAfkConn
TabUtil:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Callback = function(v)
        if antiAfkConn then antiAfkConn:Disconnect() antiAfkConn = nil end
        if v then
            antiAfkConn = LP.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
})

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

TabUtil:CreateSection("Server & Owner")

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
    Name = "Copy Telegram Owner (t.me/ManzXDzx)",
    Callback = function()
        pcall(function() setclipboard("https://t.me/ManzXDzx") end)
        Rayfield:Notify({Title = "Telegram", Content = "Link Telegram disalin.", Duration = 2})
    end
})

Rayfield:LoadConfiguration()
