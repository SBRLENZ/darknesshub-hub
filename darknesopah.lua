--[[ DARKNES HUB - Malam Bersama Opah (Rayfield) ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInput = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local CFG = { 
    walkSpeed = 16, jumpPower = 50, flyEnabled = false, flySpeed = 60, 
    noclip = false, autoFarmFlip = false, autoFarmKunci = false, unlimitedStamina = false 
}

local function char() 
    local c = LocalPlayer.Character
    return c, c and c:FindFirstChildOfClass("Humanoid") 
end

local function findByName(keyword, class) 
    local list = {} 
    for _, obj in ipairs(Workspace:GetDescendants()) do 
        if obj:IsA(class or "BasePart") and obj.Name:lower():find(keyword:lower()) then 
            table.insert(list, obj) 
        end 
    end 
    return list 
end

local function tpTo(cf, offsetY) 
    local c = LocalPlayer.Character
    if c and c:FindFirstChild("HumanoidRootPart") then
        c.HumanoidRootPart.CFrame = cf + Vector3.new(0, offsetY or 3, 0) 
    end 
end

local Window = Rayfield:CreateWindow({ 
    Name = "☠ DARKNES HUB - OPAH ☠", 
    LoadingTitle = "Memuat Opah...", 
    ConfigurationSaving = {Enabled = false}, 
    KeySystem = false 
})

-- ===== TAB PLAYER / MAIN =====
local MainTab = Window:CreateTab("Player", 4483362458)
MainTab:CreateSlider({Name = "WalkSpeed (Bypass)", Range = {16, 300}, Increment = 1, Suffix = "Speed", CurrentValue = 16, Callback = function(v) CFG.walkSpeed = v end})
MainTab:CreateSlider({Name = "JumpPower", Range = {50, 300}, Increment = 1, Suffix = "JP", CurrentValue = 50, Callback = function(v) CFG.jumpPower = v end})
MainTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(s) CFG.noclip = s end})

MainTab:CreateToggle({
    Name = "Fly (WASD + Space)", 
    CurrentValue = false, 
    Callback = function(state)
        CFG.flyEnabled = state
        local c = char() 
        if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart") 
        if not root then return end
        
        if state then
            local bv = Instance.new("BodyVelocity", root) 
            bv.Name = "FlyBody" 
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5) 
            bv.Velocity = Vector3.zero
            local bg = Instance.new("BodyGyro", root) 
            bg.Name = "FlyGyro" 
            bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5) 
            bg.P = 1000 bg.D = 50
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
                if root:FindFirstChild("FlyBody") then root.FlyBody:Destroy() end
                if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
            end)
        else
            local b = root:FindFirstChild("FlyBody") if b then b:Destroy() end
            local g = root:FindFirstChild("FlyGyro") if g then g:Destroy() end
        end
    end,
})

RunService.Stepped:Connect(function() 
    local c, hum = char() 
    if hum then 
        if math.abs(hum.WalkSpeed - CFG.walkSpeed) > 0.1 then hum.WalkSpeed = CFG.walkSpeed end 
        if math.abs(hum.JumpPower - CFG.jumpPower) > 0.1 then hum.JumpPower = CFG.jumpPower end
    end 
    if CFG.noclip and c then 
        for _, v in ipairs(c:GetDescendants()) do 
            if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end 
        end 
    end 
end)

-- ===== TAB TELEPORT =====
local TpTab = Window:CreateTab("Teleport", 4483362458)
TpTab:CreateSection("Lokasi Penting")
TpTab:CreateButton({Name = "TP ke Nenek", Callback = function() local n = findByName("nenek") if n[1] then tpTo(n[1].CFrame) end end})
TpTab:CreateButton({Name = "TP ke Dapur (Fixed)", Callback = function() local d = findByName("kitchen") if #d == 0 then d = findByName("dapur") end if d[1] then tpTo(d[1].CFrame, -3) end end})
TpTab:CreateButton({Name = "TP ke Safe Zone", Callback = function() local s = findByName("safe") if #s == 0 then s = findByName("spawn") end if s[1] then tpTo(s[1].CFrame) end end})
TpTab:CreateButton({Name = "TP ke Pintu Keluar", Callback = function() local e = findByName("exit") if #e == 0 then e = findByName("door") end if e[1] then tpTo(e[1].CFrame) end end})

local plrList = {}
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(plrList, p) end end
TpTab:CreateDropdown({
    Name = "Teleport ke Pemain",
    Options = plrList,
    CurrentOption = {"Pilih Pemain"},
    MultipleOptions = false,
    Callback = function(Option) 
        local pName = Option[1]
        local targetPlr = Players:FindFirstChild(pName)
        if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
            tpTo(targetPlr.Character.HumanoidRootPart.CFrame)
        end
    end,
})

-- ===== TAB VISUAL =====
local VisTab = Window:CreateTab("Visual (ESP)", 4483362458)
VisTab:CreateSection("ESP Settings")

local function addESP(obj, color, name)
    if not obj or obj:FindFirstChild("DarknesESP") then return end
    local box = Instance.new("BoxHandleAdornment") 
    box.Name = "DarknesESP" 
    box.Adornee = obj 
    box.Size = obj.Size 
    box.AlwaysOnTop = true 
    box.ZIndex = 5 
    box.Transparency = 0.4 
    box.Color3 = color 
    box.Parent = obj

    local bill = Instance.new("BillboardGui") 
    bill.Name = "DarknesLabel" 
    bill.Size = UDim2.new(0, 100, 0, 25) 
    bill.StudsOffset = Vector3.new(0, obj.Size.Y/2 + 1, 0) 
    bill.AlwaysOnTop = true 
    bill.Adornee = obj 
    bill.Parent = obj

    local lbl = Instance.new("TextLabel", bill) 
    lbl.Size = UDim2.new(1, 0, 1, 0) 
    lbl.BackgroundTransparency = 1 
    lbl.Text = name or obj.Name 
    lbl.TextColor3 = color 
    lbl.TextStrokeTransparency = 0 
    lbl.Font = Enum.Font.GothamBold 
    lbl.TextSize = 12
end

VisTab:CreateToggle({Name = "ESP Kunci (Kuning)", CurrentValue = false, Callback = function(s)
    if s then
        local list = findByName("key") if #list == 0 then list = findByName("kunci") end
        for _, k in ipairs(list) do addESP(k, Color3.fromRGB(255, 215, 0), "Kunci") end
    end
end})

VisTab:CreateToggle({Name = "ESP Code (Biru)", CurrentValue = false, Callback = function(s)
    if s then
        local list = findByName("code") if #list == 0 then list = findByName("kode") end
        for _, c in ipairs(list) do addESP(c, Color3.fromRGB(0, 200, 255), "Code") end
    end
end})

VisTab:CreateToggle({Name = "ESP Nenek (Merah)", CurrentValue = false, Callback = function(s)
    if s then
        local list = findByName("nenek") if #list == 0 then list = findByName("grandma") end
        for _, n in ipairs(list) do addESP(n, Color3.fromRGB(255, 0, 0), "Nenek") end
    end
end})

VisTab:CreateToggle({Name = "ESP Sendal (Coklat)", CurrentValue = false, Callback = function(s)
    if s then
        local list = findByName("sendal") if #list == 0 then list = findByName("flip") end
        for _, sl in ipairs(list) do addESP(sl, Color3.fromRGB(180, 100, 50), "Sendal") end
    end
end})

-- ===== TAB FARM =====
local FarmTab = Window:CreateTab("Farm", 4483362458)
FarmTab:CreateSection("Auto Collect")

FarmTab:CreateToggle({
    Name = "Auto Collect Flip Flop (Fast)", 
    CurrentValue = false, 
    Callback = function(s)
        CFG.autoFarmFlip = s
        task.spawn(function()
            while CFG.autoFarmFlip do
                local c = char()
                if c and c:FindFirstChild("HumanoidRootPart") then
                    local startCF = c.HumanoidRootPart.CFrame
                    local flips = findByName("flip") 
                    if #flips == 0 then flips = findByName("sendal") end
                    
                    for _, f in ipairs(flips) do 
                        if not CFG.autoFarmFlip then break end
                        c.HumanoidRootPart.CFrame = f.CFrame 
                        task.wait(0.05) 
                    end
                    
                    task.wait(0.2)
                    if c and c:FindFirstChild("HumanoidRootPart") then
                        c.HumanoidRootPart.CFrame = startCF
                    end
                end
                task.wait(1)
            end
        end)
    end
})

FarmTab:CreateToggle({
    Name = "Auto Farm Kunci + Gembok", 
    CurrentValue = false, 
    Callback = function(s)
        CFG.autoFarmKunci = s
        task.spawn(function()
            while CFG.autoFarmKunci do
                local c = char()
                if c and c:FindFirstChild("HumanoidRootPart") then
                    -- 1. Ambil Kunci
                    local keys = findByName("key") 
                    if #keys == 0 then keys = findByName("kunci") end
                    for _, k in ipairs(keys) do 
                        if not CFG.autoFarmKunci then break end
                        c.HumanoidRootPart.CFrame = k.CFrame 
                        task.wait(0.1) 
                    end
                    
                    -- 2. Buka Gembok
                    local locks = findByName("gembok") 
                    if #locks == 0 then locks = findByName("lock") end
                    for _, l in ipairs(locks) do 
                        if not CFG.autoFarmKunci then break end
                        c.HumanoidRootPart.CFrame = l.CFrame 
                        task.wait(0.1)
                        pcall(function()
                            l:FireTouchInterest(c.HumanoidRootPart, l, 0) 
                            task.wait(0.05) 
                            l:FireTouchInterest(c.HumanoidRootPart, l, 1)
                        end)
                    end
                end
                task.wait(0.5)
            end
        end)
    end
})

-- ===== TAB LAINNYA =====
local LainTab = Window:CreateTab("Lainnya", 4483362458)
LainTab:CreateSection("Ekstra Fitur")

LainTab:CreateToggle({
    Name = "Freeze Opah / Nenek", 
    CurrentValue = false, 
    Callback = function(s)
        local n = findByName("nenek") if #n == 0 then n = findByName("grandma") end
        for _, v in ipairs(n) do 
            local hum = v.Parent and v.Parent:FindFirstChildOfClass("Humanoid") 
            if hum then hum.WalkSpeed = s and 0 or 16 end 
        end
    end
})

LainTab:CreateToggle({
    Name = "Unlimited Stamina", 
    CurrentValue = false, 
    Callback = function(s)
        CFG.unlimitedStamina = s
        if s then
            task.spawn(function()
                while CFG.unlimitedStamina do
                    local c = char()
                    if c then 
                        for _, v in ipairs(c:GetDescendants()) do 
                            if v:IsA("ValueBase") and v.Name:lower():find("stamina") then v.Value = 9999 end 
                        end 
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

LainTab:CreateButton({
    Name = "Auto Buka Pintu Keluar",
    Callback = function()
        local exits = findByName("exit") if #exits == 0 then exits = findByName("door") end
        local c = char()
        if c and c:FindFirstChild("HumanoidRootPart") then
            for _, e in ipairs(exits) do
                c.HumanoidRootPart.CFrame = e.CFrame
                task.wait(0.1)
                pcall(function()
                    e:FireTouchInterest(c.HumanoidRootPart, e, 0)
                    task.wait(0.05)
                    e:FireTouchInterest(c.HumanoidRootPart, e, 1)
                end)
            end
        end
    end
})
