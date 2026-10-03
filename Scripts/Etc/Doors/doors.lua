-- Rayfield Interface Suite Loader with Key System
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "BYPASS | DOORS GOD-TIER OVERPOWERED HUB",
   LoadingTitle = "BYPASS Ultimate God Mode & Exploits Suite",
   LoadingSubtitle = "by bypass.go-live.me",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BypassDoorsOfficial",
      FileName = "BypassConfig"
   },
   Discord = {
      Enabled = true,
      Invite = "doorshub",
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "Key Required | bypass.go-live.me",
      Subtitle = "Support our keyless exploit project",
      Note = "Get your free key at bypass.go-live.me (Key: opdoor)",
      FileName = "BypassDoorsKey",
      SaveKey = true,
      GrabKeyFromSite = true, -- Set to true to point users to your platform
      Key = {"opdoor"}
   }
})

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Global State Variables for Toggles
local ESPEnabled = false
local FullbrightEnabled = false
local NoclipEnabled = false
local AutoInteractEnabled = false
local GodModeEnabled = false
local NotifyEntities = true
local SpeedBoostValue = 16
local AutoAimbotEyes = false
local BypassFigureBlindness = false
local ChestStealAura = false

-- Storage tables for ESP
local ESPObjects = {}

-- Tabs Setup
local MainTab = Window:CreateTab("Main / ESP Radar", 4483362458)
local ExploitTab = Window:CreateTab("Exploits & OP", 4483362458)
local GodTab = Window:CreateTab("God Mode & Combat", 4483362458)
local AutoTab = Window:CreateTab("Auto-Farm & Rooms", 4483362458)
local TeleportTab = Window:CreateTab("Teleports & Map", 4483362458)
local MiscTab = Window:CreateTab("Bypasses & Fun", 4483362458)

--------------------------------------------------------------------------------
-- MAIN TAB / ESP RADAR
--------------------------------------------------------------------------------

MainTab:CreateSection("Advanced Entity Radar & ESP")

MainTab:CreateToggle({
   Name = "Entity ESP (Rush, Ambush, Eyes, Seek, Figure, Halt)",
   CurrentValue = false,
   Flag = "EntityESP",
   Callback = function(Value)
      ESPEnabled = Value
      if not Value then
         for _, obj in pairs(ESPObjects) do
            if obj then obj:Destroy() end
         end
         ESPObjects = {}
      end
   end,
})

MainTab:CreateToggle({
   Name = "Live Entity Screen Alerts (Audio + Popup)",
   CurrentValue = true,
   Flag = "EntityNotify",
   Callback = function(Value)
      NotifyEntities = Value
   end,
})

MainTab:CreateToggle({
   Name = "Item, Key, & Gold Highlighting",
   CurrentValue = false,
   Flag = "ItemESP",
   Callback = function(Value)
      for _, v in pairs(Workspace:GetDescendants()) do
         if v:IsA("Model") and (v.Name == "KeyObtain" or v.Name == "Book" or v.Name == "Lighter" or v.Name == "Flashlight" or v.Name == "Vitamins" or v.Name == "GoldPile" or v.Name == "Lockpick") then
            local highlight = v:FindFirstChild("ItemHighlight")
            if Value then
               if not highlight then
                  local hl = Instance.new("Highlight")
                  hl.Name = "ItemHighlight"
                  hl.Adornee = v
                  hl.FillColor = Color3.fromRGB(255, 215, 0)
                  hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                  hl.Parent = v
               end
            else
               if highlight then highlight:Destroy() end
            end
         end
      end
   end,
})

MainTab:CreateToggle({
   Name = "Wardrobe & Safe Hiding Spot ESP",
   CurrentValue = false,
   Flag = "WardrobeESP",
   Callback = function(Value)
      for _, v in pairs(Workspace:GetDescendants()) do
         if v.Name == "Closet" or v.Name == "Wardrobe" or v.Name == "Bed" then
            local highlight = v:FindFirstChild("WardrobeHighlight")
            if Value then
               if not highlight then
                  local hl = Instance.new("Highlight")
                  hl.Name = "WardrobeHighlight"
                  hl.Adornee = v
                  hl.FillColor = Color3.fromRGB(0, 150, 255)
                  hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                  hl.Parent = v
               end
            else
               if highlight then highlight:Destroy() end
            end
         end
      end
   end,
})

--------------------------------------------------------------------------------
-- EXPLOIT TAB (CORE DOORS GAME EXPLOITS)
--------------------------------------------------------------------------------

ExploitTab:CreateSection("Game-Specific DOORS Exploits")

ExploitTab:CreateButton({
   Name = "Destroy All Active Entities (Despawn Rush/Ambush)",
   Callback = function()
      pcall(function()
         for _, v in pairs(Workspace:GetChildren()) do
            if v.Name == "RushMoving" or v.Name == "AmbushMoving" or v.Name == "Eyes" or v.Name == "SeekMoving" then
               v:Destroy()
            end
         end
         Rayfield:Notify({Title = "BYPASS Exploit", Content = "Forced destruction of active entities.", Duration = 3})
      end)
   end,
})

ExploitTab:CreateButton({
   Name = "Bypass Screech (Prevents Screech Attacks Completely)",
   Callback = function()
      pcall(function()
         for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name == "Screech" then
               v:Destroy()
            end
         end
         Rayfield:Notify({Title = "BYPASS Success", Content = "Deleted active Screech instances.", Duration = 3})
      end)
   end,
})

ExploitTab:CreateButton({
   Name = "Bypass Door Locks (Instantly Unlocks Locked Doors)",
   Callback = function()
      pcall(function()
         for _, v in pairs(Workspace.CurrentRooms:GetDescendants()) do
            if v.Name == "Door" and v:FindFirstChild("Lock") then
               v.Lock:Destroy()
            end
         end
         Rayfield:Notify({Title = "BYPASS Success", Content = "All door padlocks/locks removed.", Duration = 3})
      end)
   end,
})

ExploitTab:CreateButton({
   Name = "Give Infinite Skeleton Keys (Server Item Hack)",
   Callback = function()
      pcall(function()
         local tool = ReplicatedStorage.Items.SkeletonKey:Clone()
         tool.Parent = LocalPlayer.Backpack
         Rayfield:Notify({Title = "BYPASS Inventory", Content = "Added Skeleton Key to inventory.", Duration = 3})
      end)
   end,
})

ExploitTab:CreateButton({
   Name = "Give Crucifix (Instantly Equip Entity Repel Tool)",
   Callback = function()
      pcall(function()
         local tool = ReplicatedStorage.Items.Crucifix:Clone()
         tool.Parent = LocalPlayer.Backpack
         Rayfield:Notify({Title = "BYPASS Inventory", Content = "Check your inventory/hotbar.", Duration = 3})
      end)
   end,
})

ExploitTab:CreateButton({
   Name = "Instant Floor 2 / Backdoor Teleport Sequence",
   Callback = function()
      pcall(function()
         local currentRooms = Workspace.CurrentRooms
         local latestRoom = currentRooms:FindFirstChild("100") or currentRooms:GetChildren()[#currentRooms:GetChildren()]
         if latestRoom and latestRoom:FindFirstChild("Door") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = latestRoom.Door.CFrame + Vector3.new(0, 3, 0)
            Rayfield:Notify({Title = "BYPASS Teleport", Content = "Sent to the final/deepest loaded room.", Duration = 3})
         end
      end)
   end,
})

--------------------------------------------------------------------------------
-- GOD MODE & COMBAT TAB
--------------------------------------------------------------------------------

GodTab:CreateSection("Invincibility & Physics Alterations")

GodTab:CreateToggle({
   Name = "God Mode (Desync Hitboxes & Entity Proof)",
   CurrentValue = false,
   Flag = "GodModeToggle",
   Callback = function(Value)
      GodModeEnabled = Value
      pcall(function()
         if GodModeEnabled then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(0.01, 0.01, 0.01)
            end
         else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            end
         end
      end)
   end,
})

GodTab:CreateToggle({
   Name = "Auto-Look Away From 'Eyes' Entity",
   CurrentValue = false,
   Flag = "EyesAimbot",
   Callback = function(Value)
      AutoAimbotEyes = Value
   end,
})

GodTab:CreateToggle({
   Name = "Figure Blindness Bypass (Walk Freely)",
   CurrentValue = false,
   Flag = "FigureBypass",
   Callback = function(Value)
      BypassFigureBlindness = Value
      pcall(function()
         if BypassFigureBlindness then
            for _, v in pairs(Workspace:GetDescendants()) do
               if v.Name == "Figure" then
                  local hb = v:FindFirstChild("HumanoidRootPart")
                  if hb then hb.CanCollide = false end
               end
            end
         end
      end)
   end,
})

GodTab:CreateSlider({
   Name = "Speed Multiplier Hack",
   Range = {16, 50},
   Increment = 1,
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
      SpeedBoostValue = Value
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

GodTab:CreateToggle({
   Name = "Universal Noclip (Walk Through Walls)",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      NoclipEnabled = Value
   end,
})

GodTab:CreateButton({
   Name = "Infinite Flight Jump (Fly Anywhere)",
   Callback = function()
      UserInputService.JumpRequest:Connect(function()
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
         end
      end)
      Rayfield:Notify({Title = "BYPASS Fly", Content = "Spam your jump button to fly over rooms.", Duration = 3})
   end,
})

--------------------------------------------------------------------------------
-- AUTO-FARM & ROOMS TAB
--------------------------------------------------------------------------------

AutoTab:CreateSection("Automation & Speedruns")

AutoTab:CreateToggle({
   Name = "Auto-Interact Aura (Instantly Grabs Keys, Items, Open Doors)",
   CurrentValue = false,
   Flag = "AutoInteractToggle",
   Callback = function(Value)
      AutoInteractEnabled = Value
      task.spawn(function()
         while AutoInteractEnabled do
            task.wait(0.05)
            pcall(function()
               for _, v in pairs(Workspace.CurrentRooms:GetDescendants()) do
                  if v:IsA("ProximityPrompt") and v.Enabled then
                     fireproximityprompt(v)
                  end
               end
            end)
         end
      end)
   end,
})

AutoTab:CreateToggle({
   Name = "Chest Loot Aura (Instantly Collects Gold/Items from Chests)",
   CurrentValue = false,
   Flag = "ChestAura",
   Callback = function(Value)
      ChestStealAura = Value
      task.spawn(function()
         while ChestStealAura do
            task.wait(0.1)
            pcall(function()
               for _, room in pairs(Workspace.CurrentRooms:GetChildren()) do
                  local assets = room:FindFirstChild("Assets")
                  if assets then
                     for _, chest in pairs(assets:GetChildren()) do
                        if chest.Name:find("Chest") then
                           local prompt = chest:FindFirstChild("Prompt", true) or chest:FindFirstChildWhichIsA("ProximityPrompt", true)
                           if prompt then
                              fireproximityprompt(prompt)
                           end
                        end
                     end
                  end
               end
            end)
         end
      end)
   end,
})

AutoTab:CreateButton({
   Name = "Auto-Solve Breaker Box / Electrical Puzzle",
   Callback = function()
      pcall(function()
         for _, v in pairs(Workspace.CurrentRooms:GetDescendants()) do
            if v.Name == "BreakerBox" or v.Name == "Puzzle" then
               local switch = v:FindFirstChildWhichIsA("ProximityPrompt", true)
               if switch then fireproximityprompt(switch) end
            end
         end
         Rayfield:Notify({Title = "BYPASS Automation", Content = "Triggered breaker box interaction sequences.", Duration = 3})
      end)
   end,
})

AutoTab:CreateButton({
   Name = "Auto-Unlock Padlocks (Forces Keypad Solvers)",
   Callback = function()
      pcall(function()
         for _, v in pairs(Workspace.CurrentRooms:GetDescendants()) do
            if v.Name == "Padlock" then
               local prompt = v:FindFirstChildWhichIsA("ProximityPrompt", true)
               if prompt then fireproximityprompt(prompt) end
            end
         end
         Rayfield:Notify({Title = "BYPASS Padlock", Content = "Attempted opening sequence hack.", Duration = 3})
      end)
   end,
})

--------------------------------------------------------------------------------
-- TELEPORTS & MAP TAB
--------------------------------------------------------------------------------

TeleportTab:CreateSection("Room Skipping & Map Navigation")

TeleportTab:CreateButton({
   Name = "Instant Skip Current Room (Teleport to Next Door)",
   Callback = function()
      pcall(function()
         local currentRooms = Workspace.CurrentRooms
         local currentAttr = LocalPlayer:GetAttribute("CurrentRoom")
         if currentAttr then
            local nextRoom = currentRooms:FindFirstChild(tostring(tonumber(currentAttr) + 1))
            if nextRoom and nextRoom:FindFirstChild("Door") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = nextRoom.Door.CFrame + Vector3.new(0, 3, 0)
               Rayfield:Notify({Title = "BYPASS Teleport", Content = "Successfully skipped ahead 1 room.", Duration = 2})
            end
         end
      end)
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport to Exit Elevator (End of Run)",
   Callback = function()
      pcall(function()
         for _, room in pairs(Workspace.CurrentRooms:GetChildren()) do
            local elevator = room:FindFirstChild("Elevator") or room:FindFirstChild("ExitDoor")
            if elevator then
               local part = elevator:FindFirstChild("Door") or elevator:FindFirstChildWhichIsA("BasePart")
               if part then
                  LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                  Rayfield:Notify({Title = "BYPASS Teleport", Content = "Teleported to safety area.", Duration = 3})
               end
            end
         end
      end)
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport Back to Safety (If Stuck)",
   Callback = function()
      pcall(function()
         local currentRooms = Workspace.CurrentRooms
         local currentAttr = LocalPlayer:GetAttribute("CurrentRoom")
         if currentAttr then
            local room = currentRooms:FindFirstChild(tostring(currentAttr))
            if room and room:FindFirstChild("RoomStart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = room.RoomStart.CFrame + Vector3.new(0, 3, 0)
               Rayfield:Notify({Title = "BYPASS Safety", Content = "Teleported back to the current room start.", Duration = 2})
            end
         end
      end)
   end,
})

--------------------------------------------------------------------------------
-- MISC, BYPASSES & FUN TAB
--------------------------------------------------------------------------------

MiscTab:CreateSection("Visual Enhancements & Exploits")

MiscTab:CreateToggle({
   Name = "Absolute Fullbright (Disable All Shadows & Fog)",
   CurrentValue = false,
   Flag = "FullbrightToggle",
   Callback = function(Value)
      FullbrightEnabled = Value
      if FullbrightEnabled then
         Lighting.Brightness = 4
         Lighting.ClockTime = 14
         Lighting.GlobalShadows = false
         Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
         Lighting.FogEnd = 999999
         for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("Atmosphere") or v:IsA("PostEffect") then
               v.Enabled = false
            end
         end
      else
         Lighting.Brightness = 1
         Lighting.ClockTime = 0
         Lighting.GlobalShadows = true
         Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
      end
   end,
})

MiscTab:CreateSlider({
   Name = "Field of View (FOV Slider)",
   Range = {70, 130},
   Increment = 1,
   CurrentValue = 70,
   Flag = "FOVMod",
   Callback = function(Value)
      workspace.CurrentCamera.FieldOfView = Value
   end,
})

MiscTab:CreateButton({
   Name = "Instant Server Revive Trigger",
   Callback = function()
      pcall(function()
         ReplicatedStorage.RemotesFolder.Revive:FireServer()
         Rayfield:Notify({Title = "BYPASS Revive", Content = "Sent direct server revive request packet.", Duration = 2})
      end)
   end,
})

MiscTab:CreateButton({
   Name = "Anti-AFK Safeguard (Never Get Kicked)",
   Callback = function()
      LocalPlayer.Idled:Connect(function()
         VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
         task.wait(1)
         VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
      end)
      Rayfield:Notify({Title = "BYPASS Anti-AFK", Content = "Connection persistence active.", Duration = 3})
   end,
})

--------------------------------------------------------------------------------
-- BACKGROUND EXECUTION ENGINE LOOPS
--------------------------------------------------------------------------------

RunService.RenderStepped:Connect(function()
   -- Enforce Universal Noclip Loop
   if NoclipEnabled and LocalPlayer.Character then
      for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
         if part:IsA("BasePart") then
            part.CanCollide = false
         end
      end
   end

   -- Maintain Custom WalkSpeed
   if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      if LocalPlayer.Character.Humanoid.WalkSpeed ~= SpeedBoostValue then
         LocalPlayer.Character.Humanoid.WalkSpeed = SpeedBoostValue
      end
   end

   -- Auto Aimbot Eyes Handler (Rotates camera away instantly)
   if AutoAimbotEyes then
      pcall(function()
         for _, v in pairs(Workspace:GetChildren()) do
            if v.Name == "Eyes" then
               local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildWhichIsA("BasePart")
               if root and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                  local lookVector = LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
                  workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position - lookVector * 10)
               end
            end
         end
      end)
   end

   -- Dynamic Entity Radar ESP Loop
   if ESPEnabled then
      pcall(function()
         for _, v in pairs(Workspace:GetChildren()) do
            if v.Name == "RushMoving" or v.Name == "AmbushMoving" or v.Name == "Eyes" or v.Name == "SeekMoving" or v.Name == "FigureSetup" or v.Name == "Halt" then
               if not ESPObjects[v] then
                  local hl = Instance.new("Highlight")
                  hl.Adornee = v
                  hl.FillColor = Color3.fromRGB(255, 0, 0)
                  hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                  hl.Parent = v
                  ESPObjects[v] = hl

                  if NotifyEntities then
                     Rayfield:Notify({
                        Title = "BYPASS DANGER: " .. v.Name,
                        Content = "Lethal entity has spawned! Take immediate cover!",
                        Duration = 4
                     })
                  end
               end
            else
               if ESPObjects[v] then
                  ESPObjects[v]:Destroy()
                  ESPObjects[v] = nil
               end
            end
         end
      end)
   end
end)

Rayfield:LoadConfiguration()