--[[ DARKNES HUB - Granny Multiplayer (Rayfield) ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local CFG = { walkSpeed = 16, autoHit = false, noclip = false }
local SelectedItemName = nil

local function char() local c = LocalPlayer.Character return c, c and c:FindFirstChildOfClass("Humanoid") end
local function findObjs(class, kw) local list = {} for _, obj in ipairs(Workspace:GetDescendants()) do if obj:IsA(class) and (not kw or obj.Name:lower():find(kw:lower())) then table.insert(list, obj) end end return list end

local function scanItems()
    local itemNames, seen = {}, {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and not seen[obj.Name] then table.insert(itemNames, obj.Name) seen[obj.Name] = true end
        if obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("key") or n:find("kunci") or n:find("hammer") or n:find("plank") or n:find("screwdriver") or n:find("wrench") or n:find("cog") or n:find("battery") or n:find("padlock") then
                if not seen[obj.Name] then table.insert(itemNames, obj.Name) seen[obj.Name] = true end
            end
        end
    end
    table.sort(itemNames)
    return itemNames
end

local Window = Rayfield:CreateWindow({ Name = "☠ DARKNES HUB - GRANNY ☠", LoadingTitle = "Memuat...", ConfigurationSaving = {Enabled = false}, KeySystem = false })

-- TAB MAIN
local MainTab = Window:CreateTab("Player", 4483362458)
MainTab:CreateSlider({Name = "WalkSpeed", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) CFG.walkSpeed = v end})
RunService.Stepped:Connect(function() local c, hum = char() if hum and math.abs(hum.WalkSpeed - CFG.walkSpeed) > 0.1 then hum.WalkSpeed = CFG.walkSpeed end if CFG.noclip and c then for _, v in ipairs(c:GetDescendants()) do if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end end end end)
MainTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(s) CFG.noclip = s end})

-- TAB ITEM SCANNER
local ItemTab = Window:CreateTab("Item Scanner", 4483362458)
ItemTab:CreateSection("Pilih & Koleksi Item")
local Dropdown = ItemTab:CreateDropdown({
    Name = "Daftar Item",
    Options = {"Belum Discan"},
    CurrentOption = {"Belum Discan"},
    MultipleOptions = false,
    Callback = function(Option) SelectedItemName = Option[1] end,
})

ItemTab:CreateButton({Name = "Refresh Daftar Item", Callback = function()
    local items = scanItems()
    if #items > 0 then Dropdown:Refresh(items) else Dropdown:Refresh({"Tidak ada item"}) end
end})

ItemTab:CreateButton({Name = "Teleport & Koleksi Item", Callback = function()
    if not SelectedItemName or SelectedItemName == "Belum Discan" or SelectedItemName == "Tidak ada item" then return end
    local c = char()
    if c and c:FindFirstChild("HumanoidRootPart") then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == SelectedItemName then
                local target = obj
                if obj:IsA("Tool") and obj:FindFirstChild("Handle") then target = obj.Handle
                elseif obj:IsA("Model") and obj.PrimaryPart then target = obj.PrimaryPart end
                if target and target:IsA("BasePart") then
                    c.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0, 2, 0)
                    task.wait(0.15)
                    pcall(function()
                        firetouchinterest(c.HumanoidRootPart, target, 0) task.wait(0.05) firetouchinterest(c.HumanoidRootPart, target, 1)
                    end)
                end
            end
        end
    end
end})

-- TAB GRANNY 1,2,3
local function createGrannyTab(name)
    local T = Window:CreateTab(name, 4483362458)
    T:CreateButton({Name = "TP Main Door", Callback = function() local d = findObjs("BasePart", "door") if d[1] then char().HumanoidRootPart.CFrame = d[1].CFrame end end})
    T:CreateButton({Name = "TP Basement", Callback = function() local b = findObjs("BasePart", "basement") if b[1] then char().HumanoidRootPart.CFrame = b[1].CFrame end end})
    T:CreateButton({Name = "TP Atap", Callback = function() local a = findObjs("BasePart", "attic") if a[1] then char().HumanoidRootPart.CFrame = a[1].CFrame end end})
end
createGrannyTab("Granny 1") createGrannyTab("Granny 2") createGrannyTab("Granny 3")

-- TAB AKSI
local AksiTab = Window:CreateTab("Aksi", 4483362458)
AksiTab:CreateToggle({Name = "Auto Hit Granny", CurrentValue = false, Callback = function(s)
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
end})
