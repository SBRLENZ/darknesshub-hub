--[[ DARKNES HUB - Balapan Menara Matematika (Smart Solver) ]]
local Plrs = game:GetService("Players")
local LP = Plrs.LocalPlayer
local Ws = game:GetService("Workspace")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Ray = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local cfg = { spd = 16, jmp = 50, fly = false, autoSolve = false, delay = 0.5 }

local function getChar() local c = LP.Character return c, c and c:FindFirstChildOfClass("Humanoid") end

-- Fungsi untuk memecahkan soal matematika dari teks
local function solveMath(text)
    -- Bersihkan teks
    text = text:gsub("x", "*"):gsub("X", "*"):gsub("×", "*"):gsub("÷", "/")
    
    -- Cari pola angka dan operator (contoh: "12 + 4")
    local num1, op, num2 = text:match("(%d+)%s*([%+%-%*%/])%s*(%d+)")
    if not num1 or not op or not num2 then return nil end
    
    local n1, n2 = tonumber(num1), tonumber(num2)
    if not n1 or not n2 then return nil end
    
    if op == "+" then return n1 + n2 end
    if op == "-" then return n1 - n2 end
    if op == "*" then return n1 * n2 end
    if op == "/" then return n1 / n2 end
    return nil
end

-- Fungsi untuk mencari soal di dalam game
local function findAndSolve()
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("SurfaceGui") then
            local text = obj.Text or (obj:FindFirstChild("TextLabel") and obj.TextLabel.Text)
            if text and text:find("%d") then
                local ans = solveMath(text)
                if ans then 
                    return ans, text
                end
            end
        end
    end
    return nil
end

-- Fungsi untuk nge-klik jawaban
local function submitAnswer(ans)
    ans = tostring(ans)
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("TextButton") and obj.Text:find(ans) then
            obj:Activate()
            return true
        elseif obj:IsA("BasePart") and obj.Name:find(ans) then
            local c = getChar()
            if c and c:FindFirstChild("HumanoidRootPart") then
                c.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.1)
                pcall(function()
                    firetouchinterest(c.HumanoidRootPart, obj, 0)
                    firetouchinterest(c.HumanoidRootPart, obj, 1)
                end)
            end
            return true
        end
    end
    return false
end

local win = Ray:CreateWindow({ 
    Name = "☠ DARKNES HUB - MATH ☠", 
    LoadingTitle = "Memuat Smart Solver...", 
    LoadingSubtitle = "by SBRLENZ", 
    ConfigurationSaving = {Enabled = false}, 
    KeySystem = false 
})

-- ===== TAB PLAYER =====
local pTab = win:CreateTab("Player", 4483362458)
pTab:CreateSlider({Name = "WalkSpeed", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) cfg.spd = v end})
pTab:CreateSlider({Name = "JumpPower", Range = {50, 300}, Increment = 1, CurrentValue = 50, Callback = function(v) cfg.jmp = v end})
pTab:CreateToggle({Name = "Fly (WASD)", CurrentValue = false, Callback = function(v)
    cfg.fly = v
    local c = getChar() if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart") if not r then return end
    if v then
        local bv = Instance.new("BodyVelocity", r) bv.Name = "MathFly" bv.MaxForce = Vector3.new(1e5,1e5,1e5) bv.Velocity = Vector3.zero
        local bg = Instance.new("BodyGyro", r) bg.Name = "MathGyro" bg.MaxTorque = Vector3.new(1e5,1e5,1e5) bg.P = 1000
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
    else local b = r:FindFirstChild("MathFly") if b then b:Destroy() end local g = r:FindFirstChild("MathGyro") if g then g:Destroy() end end
end})

-- ===== TAB EXPLOIT (AUTO SOLVE) =====
local eTab = win:CreateTab("Auto Solve", 4483362458)
eTab:CreateSection("Smart Solver")

eTab:CreateToggle({Name = "Auto Solve (Baca Teks & Jawab)", CurrentValue = false, Callback = function(v)
    cfg.autoSolve = v
    task.spawn(function()
        while cfg.autoSolve do
            local ans, eq = findAndSolve()
            if ans then
                Ray:Notify({Title = "Math", Content = "Soal: " .. eq .. " | Jawaban: " .. tostring(ans), Duration = 2})
                submitAnswer(ans)
                task.wait(cfg.delay) -- Jeda biar nggak kena kick
            end
            task.wait(1)
        end
    end)
end})

eTab:CreateSlider({Name = "Answer Delay (Detik)", Range = {0.1, 3}, Increment = 0.1, CurrentValue = 0.5, Callback = function(v) cfg.delay = v end})

eTab:CreateSection("Bypass / Teleport")
eTab:CreateButton({Name = "Teleport ke Finish (Auto Win)", Callback = function()
    local c = getChar()
    if c and c:FindFirstChild("HumanoidRootPart") then
        for _, obj in pairs(Ws:GetDescendants()) do
            local name = obj.Name:lower()
            if name:find("finish") or name:find("end") or name:find("win") then
                if obj:IsA("BasePart") then
                    c.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                    Ray:Notify({Title = "TP", Content = "Loncat ke Finish!", Duration = 3})
                    return
                end
            end
        end
        Ray:Notify({Title = "Gagal", Content = "Finish tidak ditemukan.", Duration = 3})
    end
end})

-- ===== CORE LOOP =====
RS.Stepped:Connect(function()
    local c, h = getChar()
    if h then h.WalkSpeed = cfg.spd h.JumpPower = cfg.jmp end
end)
