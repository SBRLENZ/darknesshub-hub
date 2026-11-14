local Lib = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Plrs = game:GetService("Players")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local Lgt = game:GetService("Lighting")
local LP = Plrs.LocalPlayer

local Win = Lib:CreateWindow({
   Name = "DARKNES HUB | Animal Hospital (ID/EN)",
   LoadingTitle = "DARKNES HUB ULTIMATE",
   LoadingSubtitle = "SBRLENZ",
   ConfigurationSaving = { Enabled = true, FolderName = "DarknesCfg", FileName = "AnimalHospitalDual" },
   KeySystem = false
})

local function root() return LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") end
local function hum() return LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") end

-- Helper pencocokan kata kunci Indo & Inggris
local function match(str, list)
    if not str then return false end
    local low = str:lower()
    for _, k in ipairs(list) do
        if low:find(k) then return true end
    end
    return false
end

local kwAnomali = {"anomaly", "anomali", "glitch", "lilin", "candle", "monster", "ghost", "hantu", "rare", "boss"}
local kwPasien  = {"patient", "pasien", "animal", "hewan", "pet", "kucing", "anjing", "cat", "dog"}
local kwObat    = {"med", "obat", "cure", "sembuh", "potion", "syringe", "suntik", "darah", "blood", "vitamin"}
local kwDaftar  = {"register", "daftar", "reception", "resepsionis", "antri", "queue", "check in"}
local kwPeriksa = {"treat", "obati", "examine", "periksa", "heal", "operasi", "surgery", "bedah"}
local kwBeli    = {"buy", "beli", "purchase", "shop", "toko", "store"}
local kwKopi    = {"coffee", "kopi", "brew", "seduh", "espresso"}
local kwDokter  = {"doctor", "dokter", "timer", "waktu", "shift", "arrival", "datang"}

-- ==========================================
-- TAB 1: VISUAL (ESP & TIME DOCTOR)
-- ==========================================
local t1 = Win:CreateTab("Visual", 4483362458)
local espAnom, espPat, espPlr = false, false, false

t1:CreateToggle({ Name = "ESP Anomali (Red)", CurrentValue = false, Callback = function(v)
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

t1:CreateToggle({ Name = "ESP Patient / Pasien (Blue)", CurrentValue = false, Callback = function(v)
    espPat = v
    task.spawn(function()
        while espPat do
            for _, o in ipairs(WS:GetDescendants()) do
                if o:IsA("Model") and not Plrs:GetPlayerFromCharacter(o) then
                    if match(o.Name, kwPasien) and not o:FindFirstChild("_espPat") then
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

local docPara = t1:CreateParagraph({ Title = "Time Doctor / Waktu Dokter", Content = "Scanning timer..." })
task.spawn(function()
    while true do
        local foundText = "Menunggu jadwal dokter / Waiting..."
        for _, obj in ipairs(WS:GetDescendants()) do
            if obj:IsA("TextLabel") and (match(obj.Name, kwDokter) or match(obj.Text, kwDokter)) then
                if obj.Text ~= "" then
                    foundText = obj.Text
                    break
                end
            end
        end
        docPara:Set({ Title = "Time Doctor / Waktu Dokter", Content = foundText })
        task.wait(2)
    end
end)

-- ==========================================
-- TAB 2: AUTO FARM (ID & EN SCANNER)
-- ==========================================
local t2 = Win:CreateTab("Auto", 4483362458)
local autoPatSeq, autoBuyFlag, autoTreatAll, autoKillAnom = false, false, false, false
local selectedRoom = "Kamar 1 / Room 1"

t2:CreateDropdown({
    Name = "Pilih Kamar / Select Room",
    Options = {"Kamar 1 / Room 1", "Kamar 2 / Room 2", "Kamar 3 / Room 3", "Kamar 4 / Room 4", "Kamar 5 / Room 5", "Kamar 6 / Room 6", "Kamar 7 / Room 7", "Kamar 8 (Operasi/Surgery)"},
    CurrentOption = "Kamar 1 / Room 1",
    Callback = function(v) selectedRoom = v end
})

t2:CreateToggle({ Name = "Auto Patient (Ambil Obat 1-1)", CurrentValue = false, Callback = function(v)
    autoPatSeq = v
    task.spawn(function()
        while autoPatSeq do
            local r = root()
            if r then
                for _, obj in ipairs(WS:GetDescendants()) do
                    if not autoPatSeq then break end
                    if (obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("BasePart")) and match(obj.Name, kwObat) then
                        local target = obj:IsA("Model") and (obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")) or (obj:IsA("Tool") and obj:FindFirstChild("Handle") or obj)
                        if target and target:IsA("BasePart") then
                            r.CFrame = target.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.35)
                            for _, pr in ipairs(obj:GetDescendants()) do
                                if pr:IsA("ProximityPrompt") and fireproximityprompt then fireproximityprompt(pr) end
                            end
                            task.wait(0.4)
                        end
                    end
                end
            end
            task.wait(1.5)
        end
    end)
end })

t2:CreateToggle({ Name = "Auto Buy Item (Toko / Shop)", CurrentValue = false, Callback = function(v)
    autoBuyFlag = v
    task.spawn(function()
        while autoBuyFlag do
            local r = root()
            if r then
                for _, pr in ipairs(WS:GetDescendants()) do
                    if not autoBuyFlag then break end
                    if pr:IsA("ProximityPrompt") and (match(pr.ActionText, kwBeli) or match(pr.ObjectText, kwBeli)) then
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
            task.wait(2)
        end
    end)
end })

t2:CreateToggle({ Name = "Auto Obati Semua Pasien & Kamar 8", CurrentValue = false, Callback = function(v)
    autoTreatAll = v
    task.spawn(function()
        while autoTreatAll do
            local r = root()
            if r then
                for _, obj in ipairs(WS:GetDescendants()) do
                    if not autoTreatAll then break end
                    if obj:IsA("Model") and match(obj.Name, kwPasien) and not Plrs:GetPlayerFromCharacter(obj) then
                        local part = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                        if part then
                            r.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.35)
                            for _, pr in ipairs(obj:GetDescendants()) do
                                if pr:IsA("ProximityPrompt") and fireproximityprompt then fireproximityprompt(pr) end
                            end
                            task.wait(0.5)
                        end
                    end
                end
            end
            task.wait(1.5)
        end
    end)
end })

t2:CreateToggle({ Name = "Auto Kill Anomali & Lilin (Candles)", CurrentValue = false, Callback = function(v)
    autoKillAnom = v
    task.spawn(function()
        while autoKillAnom do
            local r = root()
            if r then
                for _, obj in ipairs(WS:GetDescendants()) do
                    if not autoKillAnom then break end
                    if (obj:IsA("Model") or obj:IsA("BasePart")) and match(obj.Name, kwAnomali) and not Plrs:GetPlayerFromCharacter(obj) then
                        local target = obj:IsA("Model") and (obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")) or obj
                        if target and target:IsA("BasePart") then
                            r.CFrame = target.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.25)
                            for _, pr in ipairs(obj:GetDescendants()) do
                                if pr:IsA("ProximityPrompt") and fireproximityprompt then fireproximityprompt(pr) end
                            end
                            task.wait(0.3)
                        end
                    end
                end
            end
            task.wait(1)
        end
    end)
end })

-- ==========================================
-- TAB 3: EXCLUSIVE (SAFE NOCLIP, KOPI, DAFTAR)
-- ==========================================
local t3 = Win:CreateTab("Exclusive", 4483362458)
local safeNoclip, autoCoffee, autoRegAll = false, false, false

t3:CreateButton({ Name = "Instant Interact (1x Pencet)", Callback = function()
    for _, p in ipairs(WS:GetDescendants()) do if p:IsA("ProximityPrompt") then p.HoldDuration = 0 end end
end })

t3:CreateToggle({ Name = "Safe Noclip (Anti Tembus Lantai)", CurrentValue = false, Callback = function(v)
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

t3:CreateToggle({ Name = "Auto Ambil Kopi (TP Ready)", CurrentValue = false, Callback = function(v)
    autoCoffee = v
    task.spawn(function()
        while autoCoffee do
            local r = root()
            if r then
                for _, obj in ipairs(WS:GetDescendants()) do
                    if match(obj.Name, kwKopi) then
                        local target = obj:IsA("Model") and (obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")) or (obj:IsA("BasePart") and obj)
                        if target then
                            r.CFrame = target.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.3)
                            for _, pr in ipairs(obj:GetDescendants()) do
                                if pr:IsA("ProximityPrompt") and fireproximityprompt then fireproximityprompt(pr) end
                            end
                        end
                    end
                end
            end
            task.wait(2.5)
        end
    end)
end })

t3:CreateToggle({ Name = "Instant Daftar Pasien & Respawn", CurrentValue = false, Callback = function(v)
    autoRegAll = v
    task.spawn(function()
        while autoRegAll do
            local r = root()
            if r then
                for _, pr in ipairs(WS:GetDescendants()) do
                    if pr:IsA("ProximityPrompt") and (match(pr.ActionText, kwDaftar) or match(pr.ObjectText, kwDaftar)) then
                        local part = pr.Parent:IsA("BasePart") and pr.Parent or pr.Parent:FindFirstChildWhichIsA("BasePart")
                        if part then
                            r.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.25)
                            if fireproximityprompt then fireproximityprompt(pr) end
                            task.wait(0.3)
                            local sp = WS:FindFirstChildWhichIsA("SpawnLocation", true)
                            if sp then r.CFrame = sp.CFrame + Vector3.new(0, 3, 0) end
                        end
                    end
                end
            end
            task.wait(1.5)
        end
    end)
end })

-- ==========================================
-- TAB 4: UTILITY & TELEGRAM
-- ==========================================
local t4 = Win:CreateTab("Utility", 4483362458)
local sid, svol, snd = "6023426915", 1, nil

t4:CreateInput({ Name = "Putar Lagu (Roblox Audio ID)", PlaceholderText = "Sound ID", Callback = function(t) sid = t end })
t4:CreateSlider({ Name = "Volume Lagu", Range = {0.1, 5}, Increment = 0.1, CurrentValue = 1, Callback = function(v) svol = v if snd then snd.Volume = v end end })
t4:CreateToggle({ Name = "Play / Stop Lagu", CurrentValue = false, Callback = function(s)
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
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "DARKNES HUB", Text = "Link Telegram disalin: https://t.me/ManzXDzx", Duration = 5 })
    end
end })

t4:CreateButton({ Name = "Auto Skip Dokter (Dialogue)", Callback = function()
    for _, gui in ipairs(LP.PlayerGui:GetDescendants()) do
        if gui:IsA("TextButton") and (gui.Text:lower():find("skip") or gui.Text:lower():find("lewati") or gui.Text:lower():find("next") or gui.Text:lower():find("lanjut")) then
            if getconnections then
                for _, conn in ipairs(getconnections(gui.MouseButton1Click)) do conn:Fire() end
            end
        end
    end
end })

t4:CreateButton({ Name = "Unload UI Hub", Callback = function() Lib:Destroy() end })
