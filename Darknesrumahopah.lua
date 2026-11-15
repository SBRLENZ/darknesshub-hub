local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "DARKNES HUB | Rumah Opah",
    LoadingTitle = "DARKNES HUB ULTIMATE",
    LoadingSubtitle = "Rumah Opah Exclusive Edition",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DarknesHub",
        FileName = "RumahOpahConfig"
    },
    KeySystem = false
})

local TabMain = Window:CreateTab("Item Teleport", 4483362458)
local TabVisual = Window:CreateTab("Visual & ESP", 4483362458)
local TabExcl = Window:CreateTab("Exclusive Features", 4483362458)
local TabPlayer = Window:CreateTab("Player & Misc", 4483362458)
local TabUtil = Window:CreateTab("Utility", 4483362458)

local function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
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

local function bringItems(keywords)
    local r = getRoot()
    if not r then return end
    local count = 0
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("Tool")) and not Players:GetPlayerFromCharacter(obj) then
            if matchName(obj.Name, keywords) then
                local part = nil
                if obj:IsA("Tool") then
                    part = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                elseif obj:IsA("Model") then
                    part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                elseif obj:IsA("BasePart") then
                    part = obj
                end
                if part then
                    part.CFrame = r.CFrame * CFrame.new(0, 2, -2)
                    count = count + 1
                end
            end
        end
    end
    Rayfield:Notify({
        Title = "Bring Items",
        Content = "Berhasil menarik " .. tostring(count) .. " item ke posisi anda.",
        Duration = 2
    })
end

-- TAB 1: ITEM TELEPORT / BRING
TabMain:CreateSection("Objective Items")

TabMain:CreateButton({
    Name = "Bring All Keys",
    Callback = function()
        bringItems(kwKey)
    end
})

TabMain:CreateButton({
    Name = "Bring All Flip Flops",
    Callback = function()
        bringItems(kwFlip)
    end
})

TabMain:CreateButton({
    Name = "Bring Code / Note",
    Callback = function()
        bringItems(kwCode)
    end
})

TabMain:CreateSection("Teleport Lokasi Penting")

TabMain:CreateButton({
    Name = "Teleport ke Dapur",
    Callback = function()
        local parts = findParts({"dapur", "kitchen", "cook"})
        if #parts > 0 then
            local r = getRoot()
            if r then r.CFrame = parts[1].CFrame + Vector3.new(0, 3, 0) end
        end
    end
})

TabMain:CreateButton({
    Name = "Teleport ke Safe Zone",
    Callback = function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("SpawnLocation") then
                local r = getRoot()
                if r then r.CFrame = obj.CFrame + Vector3.new(0, 3, 0) return end
            end
        end
    end
})

TabMain:CreateButton({
    Name = "Teleport ke Opah",
    Callback = function()
        local _, hrp = findOpah()
        local r = getRoot()
        if hrp and r then
            r.CFrame = hrp.CFrame * CFrame.new(0, 0, 4)
        end
    end
})

-- TAB 2: VISUAL & ESP
local espFolder = Instance.new("Folder")
espFolder.Name = "DarknesRayfieldESP"
espFolder.Parent = CoreGui

local function clearHighlights()
    for _, obj in ipairs(CoreGui:GetDescendants()) do
        if obj.Name == "DarknesESP_HL" then obj:Destroy() end
    end
end

TabVisual:CreateSection("ESP Settings")

TabVisual:CreateToggle({
    Name = "ESP Opah / Monster",
    CurrentValue = false,
    Callback = function(v)
        if v then
            task.spawn(function()
                while v do
                    local model, hrp = findOpah()
                    if model and not model:FindFirstChild("DarknesESP_HL") then
                        local h = Instance.new("Highlight", model)
                        h.Name = "DarknesESP_HL"
                        h.FillColor = Color3.fromRGB(255, 40, 40)
                    end
                    task.wait(2)
                end
            end)
        else
            clearHighlights()
        end
    end
})

TabVisual:CreateToggle({
    Name = "ESP Important Items (Keys/Code/Sandal)",
    CurrentValue = false,
    Callback = function(v)
        if v then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if (obj:IsA("BasePart") or obj:IsA("Model")) and matchName(obj.Name, {"key", "kunci", "flip", "flop", "sandal", "code", "kode"}) then
                    local target = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                    if target and not target:FindFirstChild("DarknesESP_HL") then
                        local h = Instance.new("Highlight", target)
                        h.Name = "DarknesESP_HL"
                        h.FillColor = Color3.fromRGB(0, 170, 255)
                    end
                end
            end
        else
            clearHighlights()
        end
    end
})

TabVisual:CreateSection("Environment")

local origBrightness = Lighting.Brightness
local origShadows = Lighting.GlobalShadows

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

-- TAB 3: EXCLUSIVE FEATURES
TabExcl:CreateSection("Opah & Player Actions")

TabExcl:CreateButton({
    Name = "Bring Opah to Me",
    Callback = function()
        local r = getRoot()
        local _, hrp = findOpah()
        if r and hrp and not hrp.Anchored then
            hrp.CFrame = r.CFrame * CFrame.new(0, 0, -5)
        end
    end
})

local godModeActive = false
TabExcl:CreateToggle({
    Name = "Godmode / Anti-Damage Bypass",
    CurrentValue = false,
    Callback = function(v)
        godModeActive = v
        task.spawn(function()
            while godModeActive do
                if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                    LP.Character.Humanoid.Health = LP.Character.Humanoid.MaxHealth
                end
                task.wait(0.1)
            end
        end)
    end
})

-- TAB 4: PLAYER & MISC
local noclipActive = false
local targetWalkSpeed = 16

TabPlayer:CreateSection("Movement")

TabPlayer:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 80},
    Increment = 1,
    Suffix = " Speed",
    CurrentValue = 16,
    Callback = function(val)
        targetWalkSpeed = val
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.WalkSpeed = val
        end
    end
})

TabPlayer:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(v)
        noclipActive = v
    end
})

RunService.Stepped:Connect(function()
    if noclipActive and LP.Character then
        for _, part in ipairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

TabPlayer:CreateSection("Interaction")

TabPlayer:CreateToggle({
    Name = "Instant Interact (No Hold)",
    CurrentValue = false,
    Callback = function(v)
        task.spawn(function()
            while v do
                for _, prompt in ipairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0
                    end
                end
                task.wait(1)
            end
        end)
    end
})

-- TAB 5: UTILITY
TabUtil:CreateSection("Server & Community")

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
        pcall(function()
            setclipboard("https://t.me/ManzXDzx")
        end)
        Rayfield:Notify({Title = "Utility", Content = "Link Telegram berhasil disalin.", Duration = 2})
    end
})

Rayfield:LoadConfiguration()
