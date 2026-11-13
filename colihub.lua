--[[ COLI HUB - Brookhaven Custom Edition ]]
local Plrs = game:GetService("Players")
local LP = Plrs.LocalPlayer
local Ws = game:GetService("Workspace")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local SS = game:GetService("SoundService")
local Ray = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local cfg = { spd = 16, jmp = 50, noclip = false, rgbAvatar = false, flingItem = false, bring = false, freeze = false, spec = false }
local targetName = nil
local selectedHome = nil
local musicObj = nil
local isMusicPlaying = false

local function getChar() local c = LP.Character return c, c and c:FindFirstChildOfClass("Humanoid") end
local function getPlrs() local tbl = {} for _, p in pairs(Plrs:GetPlayers()) do if p ~= LP then table.insert(tbl, p.Name) end end return tbl end
local function getTarget() if targetName then return Plrs:FindFirstChild(targetName) end return nil end
local function tp(cf) local c = getChar() if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame = cf + Vector3.new(0,3,0) end end

-- UBAH TITLE JADI COLI HUB MERAH
local function applyTitle(char)
    local head = char:WaitForChild("Head", 5)
    if head then
        local old = head:FindFirstChild("ColiTitle")
        if old then old:Destroy() end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
        
        local bill = Instance.new("BillboardGui")
        bill.Name = "ColiTitle"
        bill.Size = UDim2.new(0, 200, 0, 50)
        bill.StudsOffset = Vector3.new(0, 2.5, 0)
        bill.AlwaysOnTop = true
        bill.Parent = head
        
        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Text = "Coli Hub"
        txt.TextColor3 = Color3.fromRGB(255, 0, 0) -- Merah
        txt.TextStrokeTransparency = 0
        txt.TextStrokeColor3 = Color3.new(0,0,0)
        txt.Font = Enum.Font.GothamBlack
        txt.TextSize = 20
        txt.Parent = bill
    end
end

LP.CharacterAdded:Connect(applyTitle)
if LP.Character then applyTitle(LP.Character) end

-- UI RAYFIELD
local win = Ray:CreateWindow({ Name = "COLI HUB", LoadingTitle = "Loading COLI HUB...", LoadingSubtitle = "Brookhaven Custom", ConfigurationSaving = { Enabled = false }, KeySystem = false })

-- ================= TAB 1: MAIN =================
local mTab = win:CreateTab("Main", 4483362458)
mTab:CreateParagraph({ Title = "Welcome!", Content = "Halo @" .. LP.Name .. ", welcome to coli hub!" })

-- ================= TAB 2: TELEPORT =================
local tTab = win:CreateTab("Teleport", 4483362458)
local pDrop = tTab:CreateDropdown({Name = "Select Player", Options = getPlrs(), CurrentOption = {"None"}, MultipleOptions = false, Callback = function(o) targetName = o[1] end})
tTab:CreateButton({Name = "Refresh Player List", Callback = function() pDrop:Refresh(getPlrs()) end})

tTab:CreateButton({Name = "Teleport to Player (Selected)", Callback = function() local p = getTarget() if p and p.Character then tp(p.Character.HumanoidRootPart.CFrame) end end})
tTab:CreateButton({Name = "Teleport to Lobby (Spawn)", Callback = function() local s = Ws:FindFirstChildOfClass("SpawnLocation") if s then tp(s.CFrame) else tp(CFrame.new(0,50,0)) end end})

local hDrop = tTab:CreateDropdown({Name = "Select Home", Options = {"House 1", "House 2", "House 3", "House 4", "House 5"}, CurrentOption = {"House 1"}, MultipleOptions = false, Callback = function(o) selectedHome = o[1] end})
tTab:CreateButton({Name = "Teleport to Home (Selected)", Callback = function()
    if selectedHome then
        local num = selectedHome:match("%d+")
        for _, obj in pairs(Ws:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():find("house") or obj.Name:lower():find("home")) and obj.Name:find(num) then
                if obj.PrimaryPart then tp(obj.PrimaryPart.CFrame) return end
            end
        end
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="Info", Text="Rumah "..num.." tidak ditemukan", Duration=3})
    end
end})

tTab:CreateButton({Name = "Teleport to Sky", Callback = function() tp(CFrame.new(0, 1000, 0)) end})
tTab:CreateButton({Name = "Teleport to Pabrik", Callback = function()
    for _, o in pairs(Ws:GetDescendants()) do
        if o.Name:lower():find("pabrik") or o.Name:lower():find("factory") then
            if o:IsA("BasePart") then tp(o.CFrame) return
            elseif o:IsA("Model") and o.PrimaryPart then tp(o.PrimaryPart.CFrame) return end
        end
    end
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="Info", Text="Pabrik tidak ditemukan", Duration=3})
end})

-- ================= TAB 3: VISUAL =================
local vTab = win:CreateTab("Visual", 4483362458)
vTab:CreateToggle({Name = "Avatar Warna Warni (RGB)", CurrentValue = false, Callback = function(v) cfg.rgbAvatar = v end})

RS.Heartbeat:Connect(function()
    if cfg.rgbAvatar then
        local c = getChar()
        if c then
            local hue = tick() % 2 / 2
            local col = Color3.fromHSV(hue, 1, 1)
            for _, part in pairs(c:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Color = col
                end
            end
        end
    end
end)

-- ================= TAB 4: TROLL =================
local trTab = win:CreateTab("Troll", 4483362458)
local pDrop2 = trTab:CreateDropdown({Name = "Select Target", Options = getPlrs(), CurrentOption = {"None"}, MultipleOptions = false, Callback = function(o) targetName = o[1] end})
trTab:CreateButton({Name = "Refresh Target List", Callback = function() pDrop2:Refresh(getPlrs()) end})

-- Fling Item
trTab:CreateToggle({Name = "Fling Item (Sentuh = Fling)", CurrentValue = false, Callback = function(v)
    cfg.flingItem = v
    local c = getChar()
    if v and c then
        c.Touched:Connect(function(hit)
            if cfg.flingItem and hit.Parent then
                local hum = hit.Parent:FindFirstChildOfClass("Humanoid")
                if hum and hit.Parent ~= c then
                    local hrp = hit.Parent:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local bv = Instance.new("BodyVelocity", hrp)
                        bv.Velocity = Vector3.new(math.random(-500,500), 500, math.random(-500,500))
                        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
                        game:GetService("Debris"):AddItem(bv, 0.5)
                    end
                end
            end
        end)
    end
end})

trTab:CreateButton({Name = "Fling (Target)", Callback = function()
    local p = getTarget()
    if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        local bv = Instance.new("BodyAngularVelocity", p.Character.HumanoidRootPart)
        bv.AngularVelocity = Vector3.new(9999, 9999, 9999) bv.MaxTorque = Vector3.new(9999, 9999, 9999)
        game:GetService("Debris"):AddItem(bv, 1)
    end
end})

trTab:CreateToggle({Name = "Bring Player (Persistent)", CurrentValue = false, Callback = function(v)
    cfg.bring = v
    task.spawn(function()
        while cfg.bring do
            local c = getChar() local p = getTarget()
            if c and p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            end
            task.wait(0.1)
        end
    end)
end})

trTab:CreateButton({Name = "Kill Player (Target)", Callback = function()
    local p = getTarget()
    if p and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
        p.Character.Humanoid.Health = 0
    end
end})

trTab:CreateToggle({Name = "Freeze Player (Target)", CurrentValue = false, Callback = function(v)
    cfg.freeze = v
    task.spawn(function()
        while cfg.freeze do
            local p = getTarget()
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local bp = hrp:FindFirstChild("ColiFreeze")
                if not bp then
                    bp = Instance.new("BodyPosition", hrp)
                    bp.Name = "ColiFreeze"
                    bp.Position = hrp.Position
                    bp.MaxForce = Vector3.new(1e5,1e5,1e5)
                else
                    bp.Position = hrp.Position
                end
            end
            task.wait(0.1)
        end
    end)
end})

trTab:CreateButton({Name = "Fling with Bus 🚌 (Target)", Callback = function()
    local p = getTarget()
    if not p or not p.Character then return end
    for _, v in pairs(Ws:GetDescendants()) do
        if v:IsA("VehicleSeat") and v.Parent and v.Parent:IsA("Model") and (v.Parent.Name:lower():find("bus")) then
            v.Parent:SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0))
            task.wait(0.1)
            local bv = Instance.new("BodyVelocity", v.Parent.PrimaryPart)
            bv.Velocity = Vector3.new(math.random(-1000,1000), 1000, math.random(-1000,1000))
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            game:GetService("Debris"):AddItem(bv, 2)
            return
        end
    end
end})

trTab:CreateToggle({Name = "Spectator Target", CurrentValue = false, Callback = function(v)
    cfg.spec = v
    if v then
        local p = getTarget()
        if p and p.Character and p.Character:FindFirstChild("Humanoid") then
            Ws.CurrentCamera.CameraSubject = p.Character.Humanoid
        end
    else
        local c, h = getChar()
        if h then Ws.CurrentCamera.CameraSubject = h end
    end
end})

trTab:CreateButton({Name = "Bring to Sky (Target)", Callback = function()
    local p = getTarget()
    if p and p.Character then p.Character.HumanoidRootPart.CFrame = CFrame.new(0, 1000, 0) end
end})

trTab:CreateButton({Name = "Bring to Void (Target)", Callback = function()
    local p = getTarget()
    if p and p.Character then p.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0) end
end})

trTab:CreateButton({Name = "Delete Home (Target)", Callback = function()
    local p = getTarget()
    if not p then return end
    for _, obj in pairs(Ws:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("house") or obj.Name:lower():find("home")) then
            -- Cek apakah ada nama pemilik di dalam rumah
            for _, child in pairs(obj:GetDescendants()) do
                if child:IsA("TextLabel") and child.Text:lower():find(p.Name:lower()) then
                    obj:Destroy()
                    game:GetService("StarterGui"):SetCore("SendNotification", {Title="Troll", Text="Rumah "..p.Name.." dihapus!", Duration=3})
                    return
                end
            end
        end
    end
end})

-- ================= TAB 5: UTILITY =================
local uTab = win:CreateTab("Utility", 4483362458)
local pDrop3 = uTab:CreateDropdown({Name = "Select Player", Options = getPlrs(), CurrentOption = {"None"}, MultipleOptions = false, Callback = function(o) targetName = o[1] end})
uTab:CreateButton({Name = "Refresh Player List", Callback = function() pDrop3:Refresh(getPlrs()) end})

uTab:CreateButton({Name = "Copy Avatar (Target)", Callback = function()
    local p = getTarget()
    local c, h = getChar()
    if p and p.Character and p.Character:FindFirstChild("Humanoid") and h then
        local desc = p.Character.Humanoid:GetAppliedDescription()
        h:ApplyDescription(desc)
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="Utility", Text="Berhasil copy avatar "..p.Name, Duration=3})
    end
end})

local musicId = ""
uTab:CreateInput({Name = "Music ID", PlaceholderText = "Masukkan ID lagu...", RemoveTextAfterFocusLost = false, Callback = function(txt) musicId = txt end})

uTab:CreateToggle({Name = "Putar Lagu (On/Off)", CurrentValue = false, Callback = function(v)
    if v then
        if musicId ~= "" then
            if musicObj then musicObj:Destroy() end
            musicObj = Instance.new("Sound", SS)
            musicObj.SoundId = "rbxassetid://" .. musicId
            musicObj.Looped = true
            musicObj:Play()
            isMusicPlaying = true
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {Title="Error", Text="Isi ID Lagu dulu!", Duration=3})
        end
    else
        if musicObj then musicObj:Destroy() musicObj = nil end
        isMusicPlaying = false
    end
end})

uTab:CreateButton({Name = "Auto Claim Item (Target)", Callback = function()
    local p = getTarget()
    if p and p.Character then
        local c = getChar()
        task.spawn(function()
            for _, obj in pairs(Ws:GetDescendants()) do
                if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                    c.HumanoidRootPart.CFrame = obj.Handle.CFrame + Vector3.new(0,2,0)
                    task.wait(0.1)
                    pcall(function() firetouchinterest(c.HumanoidRootPart, obj.Handle, 0) firetouchinterest(c.HumanoidRootPart, obj.Handle, 1) end)
                end
            end
        end)
    end
end})

uTab:CreateButton({Name = "Auto Claim Worker (Target)", Callback = function()
    local c = getChar()
    local jobs = {"pizza", "hospital", "police", "fire", "bank", "grocery"}
    task.spawn(function()
        for _, job in pairs(jobs) do
            for _, obj in pairs(Ws:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find(job) then
                    c.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0,3,0)
                    task.wait(0.2)
                    pcall(function() firetouchinterest(c.HumanoidRootPart, obj, 0) firetouchinterest(c.HumanoidRootPart, obj, 1) end)
                end
            end
        end
    end)
end})
