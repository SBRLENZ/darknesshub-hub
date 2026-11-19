--[[ DARKNES HUB - Math Race Ultra Solver ]]
local Plrs = game:GetService("Players")
local LP = Plrs.LocalPlayer
local Ws = game:GetService("Workspace")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Ray = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local cfg = { spd = 16, fly = false, autoSolve = false, delay = 0.5 }

local function getChar() local c = LP.Character return c, c and c:FindFirstChildOfClass("Humanoid") end

-- Parser matematika yang lebih pintar
local function solveMath(text)
    if not text then return nil end
    -- Bersihkan teks dari karakter aneh
    text = tostring(text):gsub("x", "*"):gsub("X", "*"):gsub("×", "*"):gsub("÷", "/"):gsub("%s+", " ")
    
    -- Cari pola: Angka, Operator, Angka
    local n1, op, n2 = string.match(text, "(%d+)%s*([%+%-%*/])%s*(%d+)")
    if n1 and op and n2 then
        local num1, num2 = tonumber(n1), tonumber(n2)
        if op == "+" then return num1 + num2 end
        if op == "-" then return num1 - num2 end
        if op == "*" then return num1 * num2 end
        if op == "/" then return num1 / num2 end
    end
    return nil
end

-- Scan seluruh game untuk mencari soal
local function scanForMath()
    for _, obj in pairs(game:GetDescendants()) do
        local text = nil
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then text = obj.Text
        elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
            local lbl = obj:FindFirstChildWhichIsA("TextLabel")
            if lbl then text = lbl.Text end
        end
        
        if text and text:match("%d") then
            local ans = solveMath(text)
            if ans then return tostring(ans), text end
        end
    end
    return nil, nil
end

-- Fungsi brutal untuk nyentuh/klik jawaban
local function submitAnswer(ans)
    for _, obj in pairs(game:GetDescendants()) do
        -- Jika objeknya part dengan nama jawaban
        if obj:IsA("BasePart") and obj.Name:find(ans) then
            local c = getChar()
            if c and c:FindFirstChild("HumanoidRootPart") then
                c.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0) task.wait(0.1)
                pcall(function() firetouchinterest(c.HumanoidRootPart, obj, 0) firetouchinterest(c.HumanoidRootPart, obj, 1) end)
                local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then pcall(function() prompt:InputHoldBegin() task.wait(0.2) prompt:InputHoldEnd() end) end
                return true
            end
        -- Jika objeknya TextButton dengan teks jawaban
        elseif obj:IsA("TextButton") and obj.Text:find(ans) then
            pcall(function() obj:Activate() end)
            pcall(function() obj.MouseButton1Click:Fire() end) -- Fire klik secara paksa
            return true
        end
    end
    return false
end

local win = Ray:CreateWindow({ 
    Name = "☠ DARKNES HUB - MATH SOLVER V2 ☠", 
    LoadingTitle = "Memuat Solver V2...", 
    ConfigurationSaving = {Enabled = false}, KeySystem = false 
})

local pTab = win:CreateTab("Exploit", 4483362458)
pTab:CreateSection("Auto Solve")

pTab:CreateToggle({Name = "Auto Solve (Agresif)", CurrentValue = false, Callback = function(v)
    cfg.autoSolve = v
    task.spawn(function()
        while cfg.autoSolve do
            local ans, eq = scanForMath()
            if ans then
                Ray:Notify({Title = "Math", Content = "Soal: " .. eq .. " | Jawab: " .. ans, Duration = 2})
                local success = submitAnswer(ans)
                if not success then
                    Ray:Notify({Title = "Gagal", Content = "Jawaban ketemu, tapi tombol tidak ada.", Duration = 3})
                end
                task.wait(cfg.delay)
            end
            task.wait(0.5)
        end
    end)
end})

pTab:CreateSlider({Name = "Delay (Detik)", Range = {0.1, 3}, Increment = 0.1, CurrentValue = 0.5, Callback = function(v) cfg.delay = v end})

pTab:CreateSection("Debug / Dumper")
pTab:CreateButton({Name = "Dump Semua Teks & Part (Cek Console F9)", Callback = function()
    print("=== DUMPING GAME DATA ===")
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            print("[TEXT] " .. obj.ClassName .. " | Name: " .. obj.Name .. " | Text: " .. obj.Text)
        elseif obj:IsA("BasePart") and obj.Name:match("%d") then
            print("[PART] " .. obj.Name)
        end
    end
    Ray:Notify({Title = "Debug", Content = "Buka Console (F9) untuk melihat hasil!", Duration = 4})
end})

pTab:CreateButton({Name = "Teleport ke Finish", Callback = function()
    local c = getChar()
    if c and c:FindFirstChild("HumanoidRootPart") then
        for _, obj in pairs(Ws:GetDescendants()) do
            local name = obj.Name:lower()
            if (name:find("finish") or name:find("end") or name:find("win")) and obj:IsA("BasePart") then
                c.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0) return
            end
        end
    end
end})

RS.Stepped:Connect(function() local c, h = getChar() if h then h.WalkSpeed = cfg.spd end end)
