--[[
    DARKNES HUB - Life in Prison (Kehidupan di Penjara)
    Categories: Police, Person, Criminal
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInput = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local CFG = { 
    walkSpeed = 16, flyEnabled = false, flySpeed = 60, noclip = false, 
    autoArrest = false, killAura = false, autoEscape = false 
}

-- ===== HELPERS =====
local function char() local c = LocalPlayer.Character return c, c and c:FindFirstChildOfClass("Humanoid") end
local function findByName(keyword, class) local list = {} for _, obj in ipairs(Workspace:GetDescendants()) do if obj:IsA(class or "BasePart") and obj.Name:lower():find(keyword:lower()) then table.insert(list, obj) end end return list end
local function tpTo(cf, offsetY) local c = LocalPlayer.Character if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame = cf + Vector3.new(0, offsetY or 3, 0) end end

local function getNearestPlayer(radius)
    local closest, dist = nil, radius or math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pPos = p.Character.HumanoidRootPart.Position
            local d = (pPos - myPos).Magnitude
            if d < dist then closest, dist = p, d end
        end
    end
    return closest
end

-- ===== UI =====
local Window = Rayfield:CreateWindow({
   Name = "☠ DARKNES HUB - PRISON ☠",
   LoadingTitle = "Memuat Life in Prison...",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false
})

-- ===== TAB MAIN / UTILITY =====
local MainTab = Window:CreateTab("Main / Utility", 4483362458)
MainTab:CreateParagraph({Title = "Halo @" .. LocalPlayer.Name, Content = "Map: Kehidupan di Penjara (Life in Prison)"})

MainTab:CreateSlider({
    Name = "WalkSpeed", Range = {16, 300}, Increment = 1, Suffix = "Speed", CurrentValue = 16,
    Callback = function(Value) CFG.walkSpeed = Value end,
})

RunService.Stepped:Connect(function()
    local c, hum = char()
    if hum and math.abs(hum.WalkSpeed - CFG.walkSpeed) > 0.1 then hum.WalkSpeed = CFG.walkSpeed end
    if CFG.noclip and c then
        for _, v in ipairs(c:GetDescendants()) do if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end end
    end
end)

MainTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(s) CFG.noclip = s end})
MainTab:CreateToggle({
    Name = "Fly", CurrentValue = false,
    Callback = function(state)
        CFG.flyEnabled = state
        local c = char() if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart") if not root then return end
        if state then
            local bv = Instance.new("BodyVelocity", root) bv.Name = "FlyBody" bv.MaxForce = Vector3.new(1e5, 1e5, 1e5) bv.Velocity = Vector3.zero
            local bg = Instance.new("BodyGyro", root) bg.Name = "FlyGyro" bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5) bg.P = 1000 bg.D = 50
            task.spawn(function()
                while CFG.flyEnabled and root.Parent do
                    local cam = Workspace.CurrentCamera
                    local dir = Vector3.zero
                    if UserInput:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                    if UserInput:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                    if UserInput:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                    if UserInput:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                    if UserInput:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
                    if UserInput:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
                    bv.Velocity = dir * CFG.flySpeed
                    bg.CFrame = cam.CFrame
                    task.wait()
                end
                root:FindFirstChild("FlyBody"):Destroy() root:FindFirstChild("FlyGyro"):Destroy()
            end)
        else
            local b = root:FindFirstChild("FlyBody") if b then b:Destroy() end
            local g = root:FindFirstChild("FlyGyro") if g then g:Destroy() end
        end
    end,
})

-- ===== TAB TELEPORT =====
local TpTab = Window:CreateTab("Teleport", 4483362458)
TpTab:CreateSection("Lokasi Penting")
TpTab:CreateButton({Name = "TP ke Armory (Senjata)", Callback = function() local a = findByName("armory") if a[1] then tpTo(a[1].CFrame) end end})
TpTab:CreateButton({Name = "TP ke Yard (Lapangan)", Callback = function() local y = findByName("yard") if y[1] then tpTo(y[1].CFrame) end end})
TpTab:CreateButton({Name = "TP ke Cell (Sel Tahanan)", Callback = function() local c = findByName("cell") if c[1] then tpTo(c[1].CFrame) end end})
TpTab:CreateButton({Name = "TP ke Pintu Keluar", Callback = function() local e = findByName("exit") if #e == 0 then e = findByName("door") end if e[1] then tpTo(e[1].CFrame) end end})

-- ===== TAB POLICE =====
local PolTab = Window:CreateTab("Police", 4483362458)
PolTab:CreateSection("Fitur Polisi")
PolTab:CreateToggle({
    Name = "Auto Arrest (Borgol)", CurrentValue = false,
    Callback = function(state)
        CFG.autoArrest = state
        if state then
            task.spawn(function()
                while CFG.autoArrest do
                    local c = char()
                    if c then
                        local target = getNearestPlayer(15)
                        if target then
                            c.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                            task.wait(0.1)
                            -- Fire touch interest ke target untuk memicu borgol jika ada tool
                            for _, v in ipairs(c:GetChildren()) do
                                if v:IsA("Tool") and v.Name:lower():find("handcuff") then
                                    v.Parent = c
                                end
                            end
                            pcall(function()
                                target.Character.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame
                            end)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end,
})
PolTab:CreateButton({Name = "TP ke Tahanan Terdekat", Callback = function() local t = getNearestPlayer(500) if t then tpTo(t.Character.HumanoidRootPart.CFrame) end end})

-- ===== TAB PERSON (TAHANAN) =====
local PerTab = Window:CreateTab("Person", 4483362458)
PerTab:CreateSection("Fitur Tahanan")
PerTab:CreateToggle({
    Name = "Auto Escape (Buka Pintu)", CurrentValue = false,
    Callback = function(state)
        CFG.autoEscape = state
        if state then
            task.spawn(function()
                while CFG.autoEscape do
                    local exits = findByName("exit") if #exits == 0 then exits = findByName("door") end
                    local c = char()
                    if c and c:FindFirstChild("HumanoidRootPart") then
                        for _, e in ipairs(exits) do
                            c.HumanoidRootPart.CFrame = e.CFrame
                            task.wait(0.1)
                            e:FireTouchInterest(c.HumanoidRootPart, e, 0)
                            task.wait(0.05)
                            e:FireTouchInterest(c.HumanoidRootPart, e, 1)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end,
})
PerTab:CreateButton({
    Name = "Auto Ambil Keycard",
    Callback = function()
        local cards = findByName("card") if #cards == 0 then cards = findByName("key") end
        local c = char()
        if c then
            for _, k in ipairs(cards) do
                c.HumanoidRootPart.CFrame = k.CFrame
                task.wait(0.2)
            end
        end
    end,
})

-- ===== TAB CRIMINAL =====
local CriTab = Window:CreateTab("Criminal", 4483362458)
CriTab:CreateSection("Aksi Kriminal")
CriTab:CreateToggle({
    Name = "Kill Aura (Senjata Otomatis)", CurrentValue = false,
    Callback = function(state)
        CFG.killAura = state
        if state then
            task.spawn(function()
                while CFG.killAura do
                    local c = char()
                    if c then
                        -- Pindah ke player terdekat dan tembak/bacok
                        local target = getNearestPlayer(20)
                        if target then
                            c.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            -- Pancing klik mouse (shoot)
                            pcall(function()
                                local vu = game:GetService("VirtualUser")
                                vu:CaptureController()
                                vu:ClickButton1(Vector2.new(0,0))
                            end)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end,
})
CriTab:CreateButton({
    Name = "Ambil Senjata (Armory Hack)",
    Callback = function()
        local weapons = findByName("gun") 
        for _, w in ipairs(weapons) do
            local t = w:FindFirstChildWhichIsA("Tool")
            if t and LocalPlayer.Character then t.Parent = LocalPlayer.Character end
        end
        Rayfield:Notify({Title = "Criminal", Content = "Mencoba mengambil senjata...", Duration = 2})
    end,
})

-- ===== TAB VISUAL =====
local VisTab = Window:CreateTab("Visual", 4483362458)
VisTab:CreateSection("ESP")

local function addESP(obj, color, name)
    if not obj or obj:FindFirstChild("DarknesESP") then return end
    local box = Instance.new("BoxHandleAdornment") box.Name = "DarknesESP" box.Adornee = obj box.Size = obj.Size box.AlwaysOnTop = true box.Transparency = 0.5 box.Color3 = color box.Parent = obj
    local bill = Instance.new("BillboardGui") bill.Name = "DarknesLabel" bill.Size = UDim2.new(0, 100, 0, 25) bill.StudsOffset = Vector3.new(0, obj.Size.Y/2 + 1, 0) bill.AlwaysOnTop = true bill.Adornee = obj bill.Parent = obj
    local lbl = Instance.new("TextLabel", bill) lbl.Size = UDim2.new(1, 0, 1, 0) lbl.BackgroundTransparency = 1 lbl.Text = name or obj.Name lbl.TextColor3 = color lbl.TextStrokeTransparency = 0 lbl.Font = Enum.Font.GothamBold lbl.TextSize = 12
end

VisTab:CreateToggle({Name = "ESP Player (Semua)", CurrentValue = false, Callback = function(s)
    if s then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                addESP(p.Character.HumanoidRootPart, Color3.new(0,1,0), p.Name)
            end
        end
    end
end})

VisTab:CreateToggle({Name = "ESP Senjata (Gun/Knife)", CurrentValue = false, Callback = function(s)
    if s then
        local weps = findByName("gun") local knives = findByName("knife")
        for _, w in ipairs(weps) do addESP(w, Color3.new(1,0.5,0), "Gun") end
        for _, k in ipairs(knives) do addESP(k, Color3.new(1,0,0), "Knife") end
    end
end})

Rayfield:LoadConfiguration()
