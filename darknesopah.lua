--[[ DARKNES HUB - MALAM BERSAMA NENEK & RUMAH OPAH (SABUN STUDIOS) ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DARKNES HUB | Malam Bersama Nenek / Rumah Opah",
   LoadingTitle = "DARKNES HUB",
   LoadingSubtitle = "by SBRLENZ",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "DarknesHubConfig",
      FileName = "OpahConfig"
   },
   KeySystem = false
})

-- NOTIFIKASI / CATATAN UTAMA
Rayfield:Notify({
   Title = "DARKNES HUB",
   Content = "Script masih tahap pengembangan. Join Discord kami: https://discord.gg/jzDxbbJhy",
   Duration = 6,
   Image = 4483362458,
})

-- ==========================================
-- TAB 1: MAIN (INFO & NOTIS)
-- ==========================================
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("Informasi Hub")

MainTab:CreateParagraph({
   Title = "Selamat Datang!",
   Content = "Note: Script ini masih tahap pengembangan dan masih bertemakan Rayfield, tunggu update dari admin di komunitas resmi Darknes Hub.\n\nJoin Discord Darknes Hub:\nhttps://discord.gg/jzDxbbJhy"
})

-- ==========================================
-- TAB 2: VISUAL
-- ==========================================
local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateSection("ESP Options")

VisualTab:CreateToggle({
   Name = "ESP Nenek",
   CurrentValue = false,
   Flag = "EspNenek",
   Callback = function(Value)
       print("ESP Nenek:", Value)
   end,
})

VisualTab:CreateToggle({
   Name = "ESP Kunci (Bukan Gembok)",
   CurrentValue = false,
   Flag = "EspKunci",
   Callback = function(Value)
       print("ESP Kunci:", Value)
   end,
})

VisualTab:CreateToggle({
   Name = "ESP Code",
   CurrentValue = false,
   Flag = "EspCode",
   Callback = function(Value)
       print("ESP Code:", Value)
   end,
})

VisualTab:CreateToggle({
   Name = "ESP Flip Flop",
   CurrentValue = false,
   Flag = "EspFlipFlop",
   Callback = function(Value)
       print("ESP Flip Flop:", Value)
   end,
})

VisualTab:CreateToggle({
   Name = "Opah Warning Indicator",
   CurrentValue = false,
   Flag = "OpahWarning",
   Callback = function(Value)
       print("Opah Warning:", Value)
       -- Logika: Jauh = Putih, Agak Dekat = Kuning, Sangat Dekat = Merah
   end,
})

VisualTab:CreateSection("World Visuals")

VisualTab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Flag = "Fullbright",
   Callback = function(Value)
       print("Fullbright:", Value)
   end,
})

VisualTab:CreateToggle({
   Name = "No Fog",
   CurrentValue = false,
   Flag = "NoFog",
   Callback = function(Value)
       print("No Fog:", Value)
   end,
})

-- ==========================================
-- TAB 3: TELEPORT
-- ==========================================
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

TeleportTab:CreateSection("Location Teleports")

TeleportTab:CreateButton({
   Name = "Teleport ke Dapur (Atas Meja)",
   Callback = function()
       print("Teleport to Kitchen Table")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport ke Safe Zone (Respawn)",
   Callback = function()
       print("Teleport to Safe Zone")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport ke Nenek (Opah)",
   Callback = function()
       print("Teleport to Opah")
   end,
})

TeleportTab:CreateSection("Item Teleports")

TeleportTab:CreateDropdown({
   Name = "Pilih Kunci",
   Options = {"Kunci 1", "Kunci 2", "Kunci 3"},
   CurrentOption = "Kunci 1",
   Flag = "SelectKey",
   Callback = function(Option)
       print("Selected Key:", Option)
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport ke Kunci Terpilih",
   Callback = function()
       print("Teleporting to Selected Key")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport ke Code",
   Callback = function()
       print("Teleport to Code")
   end,
})

-- ==========================================
-- TAB 4: AUTO FARM
-- ==========================================
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

FarmTab:CreateSection("Farm Options")

FarmTab:CreateToggle({
   Name = "Auto Farm Flip Flop",
   CurrentValue = false,
   Flag = "AutoFlipFlop",
   Callback = function(Value)
       print("Auto Farm Flip Flop:", Value)
       -- Mengambil/claim semua sandal tanpa sisa secara otomatis
   end,
})

-- ==========================================
-- TAB 5: EKSKLUSIF
-- ==========================================
local EksklusifTab = Window:CreateTab("Eksklusif", 4483362458)

EksklusifTab:CreateSection("Player Mods")

EksklusifTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
       print("Noclip:", Value)
   end,
})

EksklusifTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 150},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
       local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
       if hum then
           hum.WalkSpeed = Value
       end
   end,
})

EksklusifTab:CreateToggle({
   Name = "Auto Run (Anti Opah Detect)",
   CurrentValue = false,
   Flag = "AutoRun",
   Callback = function(Value)
       print("Auto Run:", Value)
       -- Jika opah melihat target, otomatis teleport ke safezone sampai opah pergi lalu kembali
   end,
})

EksklusifTab:CreateToggle({
   Name = "Invisible",
   CurrentValue = false,
   Flag = "Invisible",
   Callback = function(Value)
       print("Invisible:", Value)
       -- Nama & semua tubuh tersembunyi, tapi opah masih dapat mengejar
   end,
})
