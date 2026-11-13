--[[ DARKNES HUB - Granny / Nenek Multiplayer (Item Selector) ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local DARKNES_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/SBRLENZ/darknesshub-hub/main/DARKNES_UI.lua"))()
local UI = DARKNES_UI.new("DARKNES HUB", "rbxassetid://0") 

local CFG = { walkSpeed = 16, autoHit = false, flingGranny = false, noclip = false }
local SelectedItemName = nil

local function char() local c = LocalPlayer.Character return c, c and c:FindFirstChildOfClass("Humanoid") end
local function findObjs(class, kw) local list = {} for _, obj in ipairs(Workspace:GetDescendants()) do if obj:IsA(class) and (not kw or obj.Name:lower():find(kw:lower())) then table.insert(list, obj) end end return list end

-- Fungsi untuk scan item (Tool atau Model yg namanya mirip kunci/barang)
local function scanItems()
    local itemNames = {}
    local seen = {}
    
    -- Scan semua Tool
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            if not seen[obj.Name] then
                table.insert(itemNames, obj.Name)
                seen[obj.Name] = true
            end
        end
        -- Kadang ada item yg bukan Tool tapi BasePart (misal Kunci di lantai)
        if obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("key") or n:find("kunci") or n:find("hammer") or n:find("plank") or n:find("screwdriver") or n:find("wrench") or n:find("cog") or n:find("battery") or n:find("padlock") then
                if not seen[obj.Name] then
                    table.insert(itemNames, obj.Name)
                    seen[obj.Name] = true
                end
            end
        end
    end
    table.sort(itemNames)
    return itemNames
end

local MainTab = UI:AddTab("Main / Player")
MainTab:AddSection("Player Mods")
MainTab:AddSlider("WalkSpeed", 16, 300, 16, function(v) CFG.walkSpeed = v end)
MainTab:AddToggle("Noclip", false, function(s) CFG.noclip = s end)
RunService.Stepped:Connect(function() 
    local c, hum = char() 
    if hum and math.abs(hum.WalkSpeed - CFG.walkSpeed) > 0.1 then hum.WalkSpeed = CFG.walkSpeed end 
    if CFG.noclip and c then for _, v in ipairs(c:GetDescendants()) do if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end end end
end)

-- TAB BARU: ITEM SCANNER
local ItemTab = UI:AddTab("Item Scanner")
ItemTab:AddSection("Pilih & Koleksi Item")

local DropdownAPI = ItemTab:AddDropdown("Daftar Item", {"Belum Discan"}, function(item)
    SelectedItemName = item
end)

ItemTab:AddButton("Refresh Daftar Item", function()
    local items = scanItems()
    if #items > 0 then
        DropdownAPI.Refresh(items)
    else
        DropdownAPI.Refresh({"Tidak ada item ditemukan"})
    end
end)

ItemTab:AddButton("Teleport & Koleksi Item Terpilih", function()
    if not SelectedItemName or SelectedItemName == "Belum Discan" or SelectedItemName == "Tidak ada item ditemukan" then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="Error", Text="Pilih item terlebih dahulu!", Duration=2})
        return
    end
    
    local c = char()
    if c and c:FindFirstChild("HumanoidRootPart") then
        local collected = false
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == SelectedItemName then
                local target = obj
                if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                    target = obj.Handle
                elseif obj:IsA("Model") and obj.PrimaryPart then
                    target = obj.PrimaryPart
                end
                
                if target and target:IsA("BasePart") then
                    -- Teleport ke lokasi item
                    c.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0, 2, 0)
                    task.wait(0.15)
                    -- Trigger sentuhan (Ambil/Touch)
                    pcall(function()
                        firetouchinterest(c.HumanoidRootPart, target, 0)
                        task.wait(0.05)
                        firetouchinterest(c.HumanoidRootPart, target, 1)
                    end)
                    collected = true
                    task.wait(0.1)
                end
            end
        end
        
        if collected then
            game:GetService("StarterGui"):SetCore("SendNotification", {Title="Sukses", Text="Mengambil: " .. SelectedItemName, Duration=2})
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {Title="Info", Text="Item sudah tidak ada di map / sudah diambil.", Duration=2})
        end
    end
end)

local AksiTab = UI:AddTab("Aksi Kriminal")
AksiTab:AddSection("Hadapi Granny")
AksiTab:AddToggle("Auto Hit/Shoot Granny", false, function(s)
    CFG.autoHit = s
    task.spawn(function()
        while CFG.autoHit do
            local granny = findObjs("Model", "granny") local nenek = findObjs("Model", "nenek")
            local target = granny[1] or nenek[1]
            if target and target:FindFirstChild("HumanoidRootPart") then
                local c = char()
                if c then
                    c.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    pcall(function() game:GetService("VirtualUser"):ClickButton1(Vector2.new()) end)
                end
            end
            task.wait(0.1)
        end
    end)
end)

