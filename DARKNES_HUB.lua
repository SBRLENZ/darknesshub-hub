--[[
    DARKNES HUB (Rayfield Edition - TESTING)
    Map: Malam Bersama Opah
    Author: ManzXD
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Panggil Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ===== STATE =====
local CFG = {
    walkSpeed = 16, jumpPower = 50, flySpeed = 60,
    flyEnabled = false, noclip = false,
    autoFarmKeys = false, autoExit = false,
}

-- ===== HELPERS =====
local function char()
    local c = LocalPlayer.Character
    if not c then return nil, nil end
    return c, c:FindFirstChildOfClass("Humanoid")
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

-- ===== UI RAYFIELD =====
local Window = Rayfield:CreateWindow({
   Name = "☠ DARKNES HUB ☠",
   LoadingTitle = "Memuat DARKNES HUB...",
   LoadingSubtitle = "by ManzXD",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false
})

-- ===== TAB MAIN =====
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSection("Informasi")
MainTab:CreateParagraph({
    Title = "Halo @" .. LocalPlayer.Name .. "!",
    Content = "Note: Script ini belum sepenuhnya berfungsi karena masih tahap pengembangan.\nJoin Komunitas resmi kami agar dapat mengetahui update selanjutnya!\n\n- ManzXD -"
})
MainTab:CreateButton({
    Name = "Copy Link Discord",
    Callback = function()
        setclipboard("https://discord.gg/cRnpHNZeu")
        Rayfield:Notify({Title = "Berhasil", Content = "Link Discord dicopy!", Duration = 3, Image = 4483362458})
    end
})

-- ===== TAB TELEPORT =====
local TpTab = Window:CreateTab("Teleport", 4483362458)
TpTab:CreateSection("Teleport Cepat")

TpTab:CreateButton({
    Name = "Teleport ke Nenek",
    Callback = function()
        local n = findByName("nenek", "BasePart")
        if #n == 0 then n = findByName("grandma", "BasePart") end
        if n[1] then tpTo(n[1].CFrame); Rayfield:Notify({Title = "Teleport", Content = "Berhasil TP ke Nenek", Duration = 2}) else Rayfield:Notify({Title = "Gagal", Content = "Nenek tidak ditemukan", Duration = 2}) end
    end
})

TpTab:CreateButton({
    Name = "Teleport ke Safe Zone",
    Callback = function()
        local s = findByName("safe", "BasePart")
        if #s == 0 then s = findByName("spawn", "BasePart") end
        if s[1] then tpTo(s[1].CFrame); Rayfield:Notify({Title = "Teleport", Content = "Berhasil TP ke Safe Zone", Duration = 2}) else Rayfield:Notify({Title = "Gagal", Content = "Safe Zone tidak ditemukan", Duration = 2}) end
    end
})

TpTab:CreateButton({
    Name = "Teleport ke Dapur",
    Callback = function()
        local d = findByName("kitchen", "BasePart")
        if #d == 0 then d = findByName("dapur", "BasePart") end
        if d[1] then tpTo(d[1].CFrame); Rayfield:Notify({Title = "Teleport", Content = "Berhasil TP ke Dapur", Duration = 2}) else Rayfield:Notify({Title = "Gagal", Content = "Dapur tidak ditemukan", Duration = 2}) end
    end
})

TpTab:CreateButton({
    Name = "Teleport ke Pintu Keluar",
    Callback = function()
        local p = findByName("exit", "BasePart")
        if #p == 0 then p = findByName("door", "BasePart") end
        if p[1] then tpTo(p[1].CFrame); Rayfield:Notify({Title = "Teleport", Content = "Berhasil TP ke Pintu Keluar", Duration = 2}) else Rayfield:Notify({Title = "Gagal", Content = "Pintu tidak ditemukan", Duration = 2}) end
    end
})

-- ===== TAB VISUAL =====
local VisTab = Window:CreateTab("Visual", 4483362458)
VisTab:CreateSection("ESP")

-- (Fitur ESP dihilangkan sementara untuk versi test Rayfield ini, fokus ke UI dan Farm)

-- ===== TAB FARM =====
local FarmTab = Window:CreateTab("Farm", 4483362458)
FarmTab:CreateSection("Auto Farm")

FarmTab:CreateToggle({
    Name = "Auto Ambil Kunci",
    CurrentValue = false,
    Flag = "AutoKunci",
    Callback = function(state)
        CFG.autoFarmKeys = state
        if state then
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
    end,
})

FarmTab:CreateButton({
    Name = "Auto Collect Flip Flop",
    Callback = function()
        Rayfield:Notify({Title = "Farm", Content = "Mengambil semua Sendal/Flip Flop...", Duration = 2})
        task.spawn(function()
            local c = LocalPlayer.Character
            if not c or not c:FindFirstChild("HumanoidRootPart") then return end
            local startCFrame = c.HumanoidRootPart.CFrame
            local flipFlops = findByName("flip", "BasePart")
            if #flipFlops == 0 then flipFlops = findByName("sendal", "BasePart") end
            if #flipFlops == 0 then flipFlops = findByName("sandal", "BasePart") end

            local count = 0
            for _, ff in ipairs(flipFlops) do
                if c and c:FindFirstChild("HumanoidRootPart") then
                    c.HumanoidRootPart.CFrame = ff.CFrame
                    task.wait(0.2)
                    count += 1
                end
            end

            task.wait(0.2)
            if c and c:FindFirstChild("HumanoidRootPart") then
                c.HumanoidRootPart.CFrame = startCFrame
            end
            Rayfield:Notify({Title = "Sukses", Content = "Mengambil " .. count .. " Sendal dan kembali", Duration = 3})
        end)
    end
})

-- ===== TAB SETTING =====
local SetTab = Window:CreateTab("Setting", 4483362458)
SetTab:CreateSection("Player Mods")

SetTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        CFG.walkSpeed = Value
        local _, hum = char()
        if hum then hum.WalkSpeed = Value end
    end,
})

SetTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(state)
        CFG.noclip = state
    end,
})

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

SetTab:CreateSection("Lainnya")
SetTab:CreateButton({
    Name = "Hop Server",
    Callback = function()
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId)
        end)
        Rayfield:Notify({Title = "Server", Content = "Hopping...", Duration = 2})
    end
})

Rayfield:LoadConfiguration()
