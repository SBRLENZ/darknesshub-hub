--[[ COLI HUB - Brookhaven Edition (60+ Features) ]]
local Plrs = game:GetService("Players")
local LP = Plrs.LocalPlayer
local Ws = game:GetService("Workspace")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Ray = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local cfg = { spd = 16, jmp = 50, fly = false, noclip = false, infJump = false, flingTouch = false }
local targetPlr = nil

local function getChar() local c = LP.Character return c, c and c:FindFirstChildOfClass("Humanoid") end
local function getPlrs() local tbl = {} for _, p in pairs(Plrs:GetPlayers()) do if p ~= LP then table.insert(tbl, p.Name) end end return tbl end
local function getNearest() local c = getChar() if not c then return nil end local p1 = c.HumanoidRootPart.Position local near, dist = nil, 9999 for _, p in pairs(Plrs:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local d = (p.Character.HumanoidRootPart.Position - p1).Magnitude if d < dist then near, dist = p, d end end end return near end
local function tp(cf) local c = getChar() if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame = cf + Vector3.new(0,3,0) end end

local win = Ray:CreateWindow({ Name = "COLI HUB", LoadingTitle = "Injecting COLI...", LoadingSubtitle = "Brookhaven Gacor", ConfigurationSaving = { Enabled = false }, KeySystem = false })

-- ================= TAB 1: PLAYER MODS =================
local pTab = win:CreateTab("Player", 4483362458)
pTab:CreateSlider({Name = "WalkSpeed", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) cfg.spd = v end})
pTab:CreateSlider({Name = "JumpPower", Range = {50, 300}, Increment = 1, CurrentValue = 50, Callback = function(v) cfg.jmp = v end})
pTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) cfg.noclip = v end})
pTab:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) cfg.infJump = v end})
pTab:CreateToggle({Name = "Fly (WASD)", CurrentValue = false, Callback = function(v)
    cfg.fly = v
    local c = getChar() if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart") if not r then return end
    if v then
        local bv = Instance.new("BodyVelocity", r) bv.Name = "ColiFly" bv.MaxForce = Vector3.new(1e5,1e5,1e5) bv.Velocity = Vector3.zero
        local bg = Instance.new("BodyGyro", r) bg.Name = "ColiGyro" bg.MaxTorque = Vector3.new(1e5,1e5,1e5) bg.P = 1000
        task.spawn(function()
            while cfg.fly and r.Parent do
                local cam = Ws.CurrentCamera local move = Vector3.zero
                if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
                bv.Velocity = move * 60 bg.CFrame = cam.CFrame task.wait()
            end
        end)
    else local b = r:FindFirstChild("ColiFly") if b then b:Destroy() end local g = r:FindFirstChild("ColiGyro") if g then g:Destroy() end end
end})

-- ================= TAB 2: VISUAL (ESP) =================
local vTab = win:CreateTab("Visual", 4483362458)
vTab:CreateToggle({Name = "Fullbright", CurrentValue = false, Callback = function(v) local L = game:GetService("Lighting") if v then L.Brightness = 3 L.ClockTime = 12 for _, x in pairs(L:GetChildren()) do if x:IsA("PostEffect") then x.Enabled = false end end else L.Brightness = 1 L.ClockTime = 0 end end})
vTab:CreateToggle({Name = "No Fog", CurrentValue = false, Callback = function(v) game:GetService("Lighting").FogEnd = v and 999999 or 100 end})

local function esp(o, c, n)
    if not o or o:FindFirstChild("ColiESP") then return end
    local b = Instance.new("BoxHandleAdornment") b.Name = "ColiESP" b.Adornee = o b.Size = o:IsA("Model") and o:GetExtentsSize() or o.Size b.AlwaysOnTop = true b.Transparency = 0.5 b.Color3 = c b.Parent = o:IsA("Model") and o.PrimaryPart or o
    local bill = Instance.new("BillboardGui", o:IsA("Model") and o.PrimaryPart or o) bill.Name = "ColiLbl" bill.Size = UDim2.new(0,100,0,25) bill.AlwaysOnTop = true bill.StudsOffset = Vector3.new(0,3,0) bill.Adornee = o:IsA("Model") and o.PrimaryPart or o
    local txt = Instance.new("TextLabel", bill) txt.Size = UDim2.new(1,0,1,0) txt.BackgroundTransparency = 1 txt.Text = n or o.Name txt.TextColor3 = c txt.TextStrokeTransparency = 0 txt.Font = Enum.Font.GothamBold
end

vTab:CreateToggle({Name = "ESP Players", CurrentValue = false, Callback = function(v)
    if v then for _, p in pairs(Plrs:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then esp(p.Character.HumanoidRootPart, Color3.fromRGB(0,255,0), p.Name) end end end
end})
vTab:CreateToggle({Name = "ESP Vehicles", CurrentValue = false, Callback = function(v)
    if v then for _, o in pairs(Ws:GetDescendants()) do if o:IsA("VehicleSeat") and o.Parent and o.Parent:IsA("Model") then esp(o.Parent, Color3.fromRGB(0,150,255), "Vehicle") end end end
end})
vTab:CreateToggle({Name = "ESP Items (Tools)", CurrentValue = false, Callback = function(v)
    if v then for _, o in pairs(Ws:GetDescendants()) do if o:IsA("Tool") and o:FindFirstChild("Handle") then esp(o.Handle, Color3.fromRGB(255,215,0), o.Name) end end end
end})

-- ================= TAB 3: TELEPORT =================
local tTab = win:CreateTab("Teleport", 4483362458)
tTab:CreateButton({Name = "TP to Spawn", Callback = function() local s = Ws:FindFirstChildOfClass("SpawnLocation") if s then tp(s.CFrame) end end})
tTab:CreateButton({Name = "TP to Nearest Player", Callback = function() local p = getNearest() if p and p.Character then tp(p.Character.HumanoidRootPart.CFrame) end end})
tTab:CreateButton({Name = "TP to Random Player", Callback = function() local plrs = Plrs:GetPlayers() local r = plrs[math.random(1, #plrs)] if r ~= LP and r.Character then tp(r.Character.HumanoidRootPart.CFrame) end end})
tTab:CreateButton({Name = "TP to Highest Point (Sky)", Callback = function() tp(CFrame.new(0, 500, 0)) end})

local tDrop = tTab:CreateDropdown({Name = "Select Player", Options = getPlrs(), CurrentOption = {"None"}, MultipleOptions = false, Callback = function(o) targetPlr = o[1] end})
tTab:CreateButton({Name = "TP to Selected Player", Callback = function() if targetPlr then local p = Plrs:FindFirstChild(targetPlr) if p and p.Character then tp(p.Character.HumanoidRootPart.CFrame) end end end})
tTab:CreateButton({Name = "Refresh Player List", Callback = function() tDrop:Refresh(getPlrs()) end})

-- ================= TAB 4: TROLL (MASS) =================
local trTab = win:CreateTab("Troll Massal", 4483362458)
trTab:CreateButton({Name = "Fling All Players", Callback = function()
    for _, p in pairs(Plrs:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local bv = Instance.new("BodyAngularVelocity", p.Character.HumanoidRootPart) bv.AngularVelocity = Vector3.new(9999,9999,9999) bv.MaxTorque = Vector3.new(9999,9999,9999) game:GetService("Debris"):AddItem(bv, 1) end end
end})
trTab:CreateButton({Name = "Kill All Players", Callback = function()
    for _, p in pairs(Plrs:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("Humanoid") then p.Character.Humanoid.Health = 0 end end
end})
trTab:CreateButton({Name = "Bring All Players to Me", Callback = function()
    local c = getChar() if not c then return end
    for _, p in pairs(Plrs:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame + Vector3.new(math.random(-5,5), 3, math.random(-5,5)) end end
end})
trTab:CreateButton({Name = "Freeze All Players", Callback = function()
    for _, p in pairs(Plrs:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local bp = Instance.new("BodyPosition", p.Character.HumanoidRootPart) bp.Position = p.Character.HumanoidRootPart.Position bp.MaxForce = Vector3.new(1e5,1e5,1e5) game:GetService("Debris"):AddItem(bp, 5) end end
end})
trTab:CreateButton({Name = "Sky Drop All", Callback = function()
    for _, p in pairs(Plrs:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 500, 0) end end
end})
trTab:CreateButton({Name = "Void Drop All", Callback = function()
    for _, p in pairs(Plrs:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0) end end
end})

-- ================= TAB 5: TROLL (TARGET) =================
local trgTab = win:CreateTab("Troll Target", 4483362458)
local tDrop2 = trgTab:CreateDropdown({Name = "Select Target", Options = getPlrs(), CurrentOption = {"None"}, MultipleOptions = false, Callback = function(o) targetPlr = o[1] end})
trgTab:CreateButton({Name = "Refresh Target List", Callback = function() tDrop2:Refresh(getPlrs()) end})

trgTab:CreateButton({Name = "Fling Target", Callback = function()
    if targetPlr then local p = Plrs:FindFirstChild(targetPlr) if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local bv = Instance.new("BodyAngularVelocity", p.Character.HumanoidRootPart) bv.AngularVelocity = Vector3.new(9999,9999,9999) bv.MaxTorque = Vector3.new(9999,9999,9999) game:GetService("Debris"):AddItem(bv, 1) end end
end})
trgTab:CreateButton({Name = "Freeze Target", Callback = function()
    if targetPlr then local p = Plrs:FindFirstChild(targetPlr) if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local bp = Instance.new("BodyPosition", p.Character.HumanoidRootPart) bp.Position = p.Character.HumanoidRootPart.Position bp.MaxForce = Vector3.new(1e5,1e5,1e5) game:GetService("Debris"):AddItem(bp, 5) end end
end})
trgTab:CreateButton({Name = "Kill Target", Callback = function()
    if targetPlr then local p = Plrs:FindFirstChild(targetPlr) if p and p.Character and p.Character:FindFirstChild("Humanoid") then p.Character.Humanoid.Health = 0 end end
end})
trgTab:CreateButton({Name = "Bring Target to Me", Callback = function()
    local c = getChar() if not c then return end if targetPlr then local p = Plrs:FindFirstChild(targetPlr) if p and p.Character then p.Character.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.new(0,0,-3) end end
end})
trgTab:CreateButton({Name = "Sky Drop Target", Callback = function()
    if targetPlr then local p = Plrs:FindFirstChild(targetPlr) if p and p.Character then p.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 500, 0) end end
end})
trgTab:CreateButton({Name = "Void Drop Target", Callback = function()
    if targetPlr then local p = Plrs:FindFirstChild(targetPlr) if p and p.Character then p.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0) end end
end})
trgTab:CreateButton({Name = "Orbit Target", Callback = function()
    if targetPlr then local p = Plrs:FindFirstChild(targetPlr) local c = getChar() if p and p.Character and c then task.spawn(function() for i=1,100 do c.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(i*10), 0) * CFrame.new(0,3,5) task.wait(0.05) end end) end end
end})
trgTab:CreateButton({Name = "Glue to Target", Callback = function()
    if targetPlr then local p = Plrs:FindFirstChild(targetPlr) local c = getChar() if p and p.Character and c then local w = Instance.new("WeldConstraint") w.Part0 = c.HumanoidRootPart w.Part1 = p.Character.HumanoidRootPart w.Parent = c.HumanoidRootPart game:GetService("Debris"):AddItem(w, 10) end end
end})
trgTab:CreateButton({Name = "Headsit Target", Callback = function()
    if targetPlr then local p = Plrs:FindFirstChild(targetPlr) local c = getChar() if p and p.Character and c and p.Character:FindFirstChild("Head") then c.HumanoidRootPart.CFrame = p.Character.Head.CFrame + Vector3.new(0,2,0) end end
end})
trgTab:CreateButton({Name = "Spectate Target", Callback = function()
    if targetPlr then local p = Plrs:FindFirstChild(targetPlr) if p and p.Character and p.Character:FindFirstChild("Humanoid") then Ws.CurrentCamera.CameraSubject = p.Character.Humanoid end end
end})
trgTab:CreateButton({Name = "Child Troll (Pocong)", Callback = function()
    if targetPlr then local p = Plrs:FindFirstChild(targetPlr) if not p or not p.Character then return end
    local child = Instance.new("Part") child.Size = Vector3.new(1,2,1) child.Color = Color3.new(0,0,0) child.Material = Enum.Material.Neon child.Parent = Ws
    local bill = Instance.new("BillboardGui", child) bill.Size = UDim2.new(0,100,0,50) bill.StudsOffset = Vector3.new(0,2,0)
    local txt = Instance.new("TextLabel", bill) txt.Size = UDim2.new(1,0,1,0) txt.BackgroundTransparency = 1 txt.Text = "👻" txt.TextScaled = true
    task.spawn(function() for i=1,200 do if not child.Parent then break end if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then child.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-5,5), 3, math.random(-5,5)) end task.wait(0.1) end child:Destroy() end)
    end
end})
trgTab:CreateButton({Name = "Fling Target with Bus 🚌", Callback = function()
    if targetPlr then local p = Plrs:FindFirstChild(targetPlr) if not p or not p.Character then return end
    local bus = Ws:FindFirstChild("Bus") or Ws:FindFirstChild("bus")
    if bus and bus:IsA("Model") and bus.PrimaryPart then
        bus:SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)) task.wait(0.1)
        local bv = Instance.new("BodyVelocity", bus.PrimaryPart) bv.Velocity = Vector3.new(math.random(-1000,1000), 1000, math.random(-1000,1000)) bv.MaxForce = Vector3.new(1e5,1e5,1e5) game:GetService("Debris"):AddItem(bv, 2)
    end
    end
end})

-- ================= TAB 6: UTILITY & RP =================
local uTab = win:CreateTab("Utility & RP", 4483362458)
uTab:CreateToggle({Name = "Invisible + Hide Name", CurrentValue = false, Callback = function(v)
    local c, h = getChar() if not c then return end
    for _, x in pairs(c:GetDescendants()) do if x:IsA("BasePart") and x.Name ~= "HumanoidRootPart" then x.Transparency = v and 1 or 0 x.CanCollide = not v elseif x:IsA("Decal") then x.Transparency = v and 1 or 0 end end
    if h then h.DisplayDistanceType = v and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer end
end})
uTab:CreateButton({Name = "Auto Collect All Tools", Callback = function()
    local c = getChar() if not c then return end
    task.spawn(function() for _, t in pairs(Ws:GetDescendants()) do if t:IsA("Tool") and t:FindFirstChild("Handle") then c.HumanoidRootPart.CFrame = t.Handle.CFrame task.wait(0.1) end end end)
end})
uTab:CreateButton({Name = "Bring All Vehicles", Callback = function()
    local c = getChar() if not c then return end
    for _, v in pairs(Ws:GetDescendants()) do if v:IsA("VehicleSeat") and v.Parent and v.Parent:IsA("Model") then v.Parent:SetPrimaryPartCFrame(c.HumanoidRootPart.CFrame + Vector3.new(math.random(-10,10),3,math.random(-10,10))) end end
end})
uTab:CreateButton({Name = "Delete All Vehicles", Callback = function()
    for _, v in pairs(Ws:GetDescendants()) do if v:IsA("VehicleSeat") and v.Parent and v.Parent:IsA("Model") then v.Parent:Destroy() end end
end})
uTab:CreateButton({Name = "Spam Chat 'COLI HUB'", Callback = function()
    task.spawn(function() for i=1,10 do local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") if chat and chat:FindFirstChild("SayMessageRequest") then chat.SayMessageRequest:FireServer("COLI HUB ON TOP! 😈", "All") end task.wait(0.5) end end)
end})
uTab:CreateButton({Name = "Server Hop", Callback = function()
    pcall(function() local mod = game:GetService("TeleportService") local servers = mod:GetSortedDataAsync() for _, s in pairs(servers) do if s.PlayerTokens and not s.PlayerTokens[LP.UserId] then mod:TeleportToPlaceInstance(game.PlaceId, s.Id, LP) return end end mod:Teleport(game.PlaceId) end)
end})
uTab:CreateButton({Name = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end})

-- CORE LOOPS
UIS.JumpRequest:Connect(function() if cfg.infJump then local c, h = getChar() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end)
RS.Stepped:Connect(function()
    local c, h = getChar()
    if h then h.WalkSpeed = cfg.spd h.JumpPower = cfg.jmp end
    if cfg.noclip and c then for _, x in pairs(c:GetDescendants()) do if x:IsA("BasePart") then x.CanCollide = false end end end
end)
