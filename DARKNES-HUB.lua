--[[
    DARKNES HUB
    Map: Malam Bersama Opah
    Author: ManzXD
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInput = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ===== STATE =====
local CFG = {
    walkSpeed = 16, jumpPower = 50, flySpeed = 60,
    flyEnabled = false, noclip = false, invisible = false,
    espKeys = false, espCodes = false, espNenek = false,
    espPlayer = false, espSendal = false,
    autoFarmKeys = false, autoExit = false,
    noFog = false, fullbright = false,
}

-- ===== HELPERS =====
local function char()
    local c = LocalPlayer.Character
    if not c then return nil, nil end
    return c, c:FindFirstChildOfClass("Humanoid")
end

local function notify(txt)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DARKNES HUB", Text = tostring(txt), Duration = 2,
        })
    end)
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

local function tpTo(cf)
    local c = LocalPlayer.Character
    if c and c:FindFirstChild("HumanoidRootPart") then
        c.HumanoidRootPart.CFrame = cf + Vector3.new(0, 3, 0)
    end
end

-- ===== UI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DARKNES_HUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 480, 0, 430)
Main.Position = UDim2.new(0.5, -240, 0.5, -215)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 0, 50)
Title.Text = "☠ DARKNES HUB ☠"
Title.TextColor3 = Color3.fromRGB(180, 0, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Main

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = Main
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -10, 0, 32)
TabBar.Position = UDim2.new(0, 5, 0, 45)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TabBar.BorderSizePixel = 0
TabBar.Parent = Main

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -10, 1, -85)
Content.Position = UDim2.new(0, 5, 0, 82)
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Content.BorderSizePixel = 0
Content.Parent = Main

local tabs = {}
local tabNames = {"Main", "Teleport", "Visual", "Farm", "Setting"}

local function makeToggle(parent, text, yPos, default, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    btn.BorderSizePixel = 0
    btn.Text = "  " .. text .. " [" .. (default and "ON" or "OFF") .. "]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    local state = default or false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = "  " .. text .. " [" .. (state and "ON" or "OFF") .. "]"
        btn.BackgroundColor3 = state and Color3.fromRGB(90, 0, 130) or Color3.fromRGB(35, 35, 50)
        if cb then cb(state) end
    end)
end

local function makeButton(parent, text, yPos, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(60, 0, 100)
    btn.BorderSizePixel = 0
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    btn.MouseButton1Click:Connect(cb)
end

local function makeDropdown(parent, text, yPos, items, cb)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.Position = UDim2.new(0, 5, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. " ▼"
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, 0, 0, 120)
    list.Position = UDim2.new(0, 0, 1, 2)
    list.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    list.BorderSizePixel = 0
    list.Visible = false
    list.ScrollBarThickness = 3
    list.Parent = frame

    local function refresh(newItems)
        for _, v in ipairs(list:GetChildren()) do
            if v:IsA("TextButton") then v:Destroy() end
        end
        for i, item in ipairs(newItems) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -4, 0, 24)
            b.Position = UDim2.new(0, 2, 0, (i-1)*26)
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            b.Text = tostring(item.Name or item)
            b.TextColor3 = Color3.fromRGB(220, 220, 220)
            b.Font = Enum.Font.Gotham
            b.TextSize = 12
            b.Parent = list
            b.MouseButton1Click:Connect(function()
                lbl.Text = text .. ": " .. tostring(item.Name or item) .. " ▼"
                list.Visible = false
                if cb then cb(item) end
            end)
        end
        list.CanvasSize = UDim2.new(0, 0, 0, #newItems * 26)
    end

    refresh(items)
    lbl.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            list.Visible = not list.Visible
        end
    end)
    return {refresh = refresh}
end

for i, name in ipairs(tabNames) do
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0, 92, 1, 0)
    tab.Position = UDim2.new(0, (i-1)*94, 0, 0)
    tab.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    tab.BorderSizePixel = 0
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(200, 200, 200)
    tab.Font = Enum.Font.GothamBold
    tab.TextSize = 12
    tab.Parent = TabBar

    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 4
    frame.CanvasSize = UDim2.new(0, 0, 0, 600)
    frame.Visible = (i == 1)
    frame.Parent = Content

    tab.MouseButton1Click:Connect(function()
        for _, t in ipairs(tabs) do t.frame.Visible = false; t.tab.BackgroundColor3 = Color3.fromRGB(35,35,50) end
        frame.Visible = true
        tab.BackgroundColor3 = Color3.fromRGB(90, 0, 130)
    end)
    table.insert(tabs, {tab = tab, frame = frame})
end

-- ===== MAIN =====
local MainTab = tabs[1].frame
makeDropdown(MainTab, "Bahasa", 5, {"Indonesia", "English"}, function(lang)
    notify("Bahasa: " .. lang)
end)

local greet = Instance.new("TextLabel")
greet.Size = UDim2.new(1, -10, 0, 130)
greet.Position = UDim2.new(0, 5, 0, 45)
greet.BackgroundColor3 = Color3.fromRGB(30, 0, 45)
greet.BorderSizePixel = 0
greet.Text = "Halo @" .. LocalPlayer.Name .. "!\n\nNote: Script ini belum sepenuhnya berfungsi karena masih tahap pengembangan.\nJoin Komunitas resmi kami agar dapat mengetahui update selanjutnya!\n\n- ManzXD -"
greet.TextColor3 = Color3.fromRGB(220, 200, 255)
greet.Font = Enum.Font.Gotham
greet.TextSize = 13
greet.TextWrapped = true
greet.Parent = MainTab

local discord = Instance.new("TextButton")
discord.Size = UDim2.new(1, -10, 0, 30)
discord.Position = UDim2.new(0, 5, 0, 185)
discord.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
discord.BorderSizePixel = 0
discord.Text = "Discord: https://discord.gg/cRnpHNZeu"
discord.TextColor3 = Color3.fromRGB(120, 180, 255)
discord.Font = Enum.Font.GothamBold
discord.TextSize = 13
discord.Parent = MainTab
discord.MouseButton1Click:Connect(function()
    pcall(function() setclipboard("https://discord.gg/cRnpHNZeu") end)
    notify("Link Discord dicopy!")
end)

-- ===== TELEPORT =====
local TpTab = tabs[2].frame

local keysList = findByName("key", "BasePart")
if #keysList == 0 then keysList = findByName("kunci", "BasePart") end
makeDropdown(TpTab, "Teleport ke Kunci", 5, keysList, function(k) tpTo(k.CFrame) end)

local codesList = findByName("code", "BasePart")
if #codesList == 0 then codesList = findByName("kode", "BasePart") end
makeDropdown(TpTab, "Teleport ke Code", 40, codesList, function(c) tpTo(c.CFrame) end)

makeButton(TpTab, "Teleport ke Nenek", 75, function()
    local n = findByName("nenek", "BasePart")
    if #n == 0 then n = findByName("grandma", "BasePart") end
    if n[1] then tpTo(n[1].CFrame); notify("TP ke Nenek") else notify("Nenek tidak ditemukan") end
end)

local plrList = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(plrList, p) end
end
makeDropdown(TpTab, "Teleport ke Pemain", 110, plrList, function(p)
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        tpTo(p.Character.HumanoidRootPart.CFrame)
    end
end)

makeButton(TpTab, "Teleport ke Safe Zone", 145, function()
    local s = findByName("safe", "BasePart")
    if #s == 0 then s = findByName("spawn", "BasePart") end
    if s[1] then tpTo(s[1].CFrame); notify("TP ke Safe Zone") else notify("Safe Zone tidak ditemukan") end
end)

makeButton(TpTab, "Teleport ke Dapur", 180, function()
    local d = findByName("kitchen", "BasePart")
    if #d == 0 then d = findByName("dapur", "BasePart") end
    if d[1] then tpTo(d[1].CFrame); notify("TP ke Dapur") else notify("Dapur tidak ditemukan") end
end)

makeButton(TpTab, "Teleport ke Pintu Keluar", 215, function()
    local p = findByName("exit", "BasePart")
    if #p == 0 then p = findByName("door", "BasePart") end
    if p[1] then tpTo(p[1].CFrame); notify("TP ke Pintu Keluar") else notify("Pintu tidak ditemukan") end
end)

-- ===== VISUAL =====
local VisTab = tabs[3].frame
local espObjects = {}

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

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name or obj.Name
    lbl.TextColor3 = color
    lbl.TextStrokeTransparency = 0
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.Parent = bill

    table.insert(espObjects, {part = obj, box = box, bill = bill})
end

local function clearESP(type)
    for i = #espObjects, 1, -1 do
        local e = espObjects[i]
        if type == nil or (e.part and e.part.Name:lower():find(type)) then
            if e.box then e.box:Destroy() end
            if e.bill then e.bill:Destroy() end
            table.remove(espObjects, i)
        end
    end
end

makeToggle(VisTab, "ESP Kunci", 5, false, function(s)
    CFG.espKeys = s
    if s then
        local list = findByName("key", "BasePart")
        if #list == 0 then list = findByName("kunci", "BasePart") end
        for _, k in ipairs(list) do addESP(k, Color3.fromRGB(255, 215, 0), "Kunci") end
    else clearESP("kunci"); clearESP("key") end
end)

makeToggle(VisTab, "ESP Code", 40, false, function(s)
    CFG.espCodes = s
    if s then
        local list = findByName("code", "BasePart")
        if #list == 0 then list = findByName("kode", "BasePart") end
        for _, c in ipairs(list) do addESP(c, Color3.fromRGB(0, 200, 255), "Code") end
    else clearESP("code"); clearESP("kode") end
end)

makeToggle(VisTab, "ESP Nenek", 75, false, function(s)
    CFG.espNenek = s
    if s then
        local list = findByName("nenek", "BasePart")
        if #list == 0 then list = findByName("grandma", "BasePart") end
        for _, n in ipairs(list) do addESP(n, Color3.fromRGB(255, 0, 0), "Nenek") end
    else clearESP("nenek"); clearESP("grandma") end
end)

makeToggle(VisTab, "ESP Player", 110, false, function(s)
    CFG.espPlayer = s
    if s then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then addESP(hrp, Color3.fromRGB(0, 255, 0), p.Name) end
            end
        end
    else clearESP() end
end)

makeToggle(VisTab, "ESP Sendal", 145, false, function(s)
    CFG.espSendal = s
    if s then
        local list = findByName("sendal", "BasePart")
        if #list == 0 then list = findByName("sandal", "BasePart") end
        for _, sl in ipairs(list) do addESP(sl, Color3.fromRGB(180, 100, 50), "Sendal") end
    else clearESP("sendal"); clearESP("sandal") end
end)

-- ===== FARM =====
local FarmTab = tabs[4].frame

makeToggle(FarmTab, "Auto Ambil Kunci", 5, false, function(s)
    CFG.autoFarmKeys = s
    if s then
        task.spawn(function()
            while CFG.autoFarmKeys do
                local list = findByName("key", "BasePart")
                if #list == 0 then list = findByName("kunci", "BasePart") end
                for _, k in ipairs(list) do
                    if not CFG.autoFarmKeys then break end
                    local c = LocalPlayer.Character
                    if c and c:FindFirstChild("HumanoidRootPart") then
                        c.HumanoidRootPart.CFrame = k.CFrame
                        task.wait(0.3)
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

makeToggle(FarmTab, "Auto Exit (Full Clear)", 40, false, function(s)
    CFG.autoExit = s
    if s then
        task.spawn(function()
            local keys = findByName("key", "BasePart")
            if #keys == 0 then keys = findByName("kunci", "BasePart") end
            for _, k in ipairs(keys) do
                if not CFG.autoExit then return end
                local c = LocalPlayer.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    c.HumanoidRootPart.CFrame = k.CFrame
                    task.wait(0.25)
                end
            end
            local codes = findByName("code", "BasePart")
            if #codes == 0 then codes = findByName("kode", "BasePart") end
            for _, code in ipairs(codes) do
                if not CFG.autoExit then return end
                local c = LocalPlayer.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    c.HumanoidRootPart.CFrame = code.CFrame
                    task.wait(0.25)
                end
            end
            local doors = findByName("door", "BasePart")
            local exits = findByName("exit", "BasePart")
            for _, d in ipairs(doors) do
                if not CFG.autoExit then return end
                local c = LocalPlayer.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    c.HumanoidRootPart.CFrame = d.CFrame
                    task.wait(0.2)
                    d:FireTouchInterest(c.HumanoidRootPart, d, 0)
                    task.wait(0.05)
                    d:FireTouchInterest(c.HumanoidRootPart, d, 1)
                    task.wait(0.2)
                end
            end
            for _, e in ipairs(exits) do
                if not CFG.autoExit then return end
                local c = LocalPlayer.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    c.HumanoidRootPart.CFrame = e.CFrame
                    task.wait(0.2)
                    e:FireTouchInterest(c.HumanoidRootPart, e, 0)
                    task.wait(0.05)
                    e:FireTouchInterest(c.HumanoidRootPart, e, 1)
                    task.wait(0.2)
                end
            end
            notify("Auto Exit selesai!")
            CFG.autoExit = false
        end)
    end
end)

makeButton(FarmTab, "Ambil Semua Kunci Sekarang", 75, function()
    local keys = findByName("key", "BasePart")
    if #keys == 0 then keys = findByName("kunci", "BasePart") end
    task.spawn(function()
        for _, k in ipairs(keys) do
            local c = LocalPlayer.Character
            if c and c:FindFirstChild("HumanoidRootPart") then
                c.HumanoidRootPart.CFrame = k.CFrame
                task.wait(0.25)
            end
        end
        notify("Selesai ambil " .. #keys .. " kunci")
    end)
end)

-- ===== SETTING =====
local SetTab = tabs[5].frame

local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(1, -10, 0, 22)
wsLabel.Position = UDim2.new(0, 5, 0, 5)
wsLabel.BackgroundTransparency = 1
wsLabel.Text = "WalkSpeed: 16"
wsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
wsLabel.Font = Enum.Font.Gotham
wsLabel.TextSize = 13
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Parent = SetTab

local wsBar = Instance.new("TextButton")
wsBar.Size = UDim2.new(1, -10, 0, 18)
wsBar.Position = UDim2.new(0, 5, 0, 28)
wsBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
wsBar.BorderSizePixel = 0
wsBar.Text = ""
wsBar.Parent = SetTab

local wsFill = Instance.new("Frame")
wsFill.Size = UDim2.new(0.05, 0, 1, 0)
wsFill.BackgroundColor3 = Color3.fromRGB(120, 100, 255)
wsFill.BorderSizePixel = 0
wsFill.Parent = wsBar

wsBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        local conn = UserInput.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = math.clamp((input.Position.X - wsBar.AbsolutePosition.X) / wsBar.AbsoluteSize.X, 0, 1)
                local val = math.floor(16 + pos * 284)
                wsFill.Size = UDim2.new(pos, 0, 1, 0)
                wsLabel.Text = "WalkSpeed: " .. val
                CFG.walkSpeed = val
                local _, hum = char()
                if hum then hum.WalkSpeed = val end
            end
        end)
        local stop
        stop = UserInput.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                conn:Disconnect(); stop:Disconnect()
            end
        end)
    end
end)

makeToggle(SetTab, "Noclip", 55, false, function(s)
    CFG.noclip = s
end)

RunService.Stepped:Connect(function()
    if CFG.noclip then
        local c = LocalPlayer.Character
        if c then
            for _, v in ipairs(c:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
    end
end)

makeToggle(SetTab, "Fly (WASD + Space)", 90, false, function(s)
    CFG.flyEnabled = s
    local c, hum = char()
    if not c then return end
    local root = c:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if s then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyBody"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.zero
        bv.Parent = root
        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyGyro"
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.P = 1000
        bg.D = 50
        bg.Parent = root
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
            local b = root:FindFirstChild("FlyBody"); if b then b:Destroy() end
            local g = root:FindFirstChild("FlyGyro"); if g then g:Destroy() end
        end)
    else
        local b = root:FindFirstChild("FlyBody"); if b then b:Destroy() end
        local g = root:FindFirstChild("FlyGyro"); if g then g:Destroy() end
    end
end)

makeToggle(SetTab, "Invisible (kecuali Nenek)", 125, false, function(s)
    CFG.invisible = s
    local c = LocalPlayer.Character
    if c then
        for _, v in ipairs(c:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.Transparency = s and 1 or 0
                v.CanCollide = not s
            elseif v:IsA("Decal") then
                v.Transparency = s and 1 or 0
            end
        end
    end
end)

makeToggle(SetTab, "Boost FPS", 160, false, function(s)
    if s then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") then
                    v.Enabled = false
                end
            end
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v.Enabled = false
                end
            end
        end)
        notify("Boost FPS: ON")
    end
end)

makeButton(SetTab, "Hop Server", 195, function()
    pcall(function()
        local mod = game:GetService("TeleportService")
        mod:Teleport(game.PlaceId)
    end)
    notify("Hopping...")
end)

makeButton(SetTab, "Refresh Hub", 230, function()
    local old = game:GetService("CoreGui"):FindFirstChild("DARKNES_HUB")
    if old then old:Destroy() end
    notify("Hub di-refresh, jalankan ulang loadstring")
end)

notify("DARKNES HUB loaded ☠")
