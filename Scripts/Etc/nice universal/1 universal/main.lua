-- Rayfield UI Library Setup
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Apex Utility | Universal V2",
   LoadingTitle = "Apex Hub",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ApexHubConfig",
      FileName = "Settings"
   },
   Discord = { Enabled = false },
   KeySystem = true,
   KeySettings = {
      Title = "Apex Hub | Verification",
      Subtitle = "Key System",
      Note = "Enter the access key to continue",
      FileName = "ApexKey",
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = {"300"}
   }
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- State Variables
local ForceSpeedEnabled = false
local TargetSpeed = 16
local NoclipEnabled = false
local FullbrightEnabled = false
local ESPEnabled = false
local LoopTPEnabled = false
local SelectedPlayerForTP = nil
local CurrentSoundTrack = nil

-- Default Lighting Values
local DefaultAmbient = Lighting.Ambient
local DefaultOutdoorAmbient = Lighting.OutdoorAmbient
local DefaultBrightness = Lighting.Brightness
local DefaultClockTime = Lighting.ClockTime

---------------------------------------------------------
-- TABS
---------------------------------------------------------
local MainTab = Window:CreateTab("Movement & Cam", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local PlayersTab = Window:CreateTab("Players & TP", 4483362458)
local GamesTab = Window:CreateTab("Game Utilities", 4483362458)
local MusicTab = Window:CreateTab("Music Player", 4483362458)

---------------------------------------------------------
-- 1. MOVEMENT & CAMERA TAB
---------------------------------------------------------
MainTab:CreateSection("Speed & Movement")

MainTab:CreateToggle({
   Name = "Force Speed",
   CurrentValue = false,
   Flag = "ForceSpeedToggle",
   Callback = function(Value)
      ForceSpeedEnabled = Value
   end,
})

MainTab:CreateSlider({
   Name = "Speed Value",
   Range = {16, 250},
   Increment = 1,
   Suffix = " Studs/s",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      TargetSpeed = Value
   end,
})

MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      NoclipEnabled = Value
   end,
})

MainTab:CreateSection("Camera & Performance")

MainTab:CreateSlider({
   Name = "Camera FOV",
   Range = {70, 120},
   Increment = 1,
   Suffix = "°",
   CurrentValue = 70,
   Flag = "FOVSlider",
   Callback = function(Value)
      Workspace.CurrentCamera.FieldOfView = Value
   end,
})

MainTab:CreateToggle({
   Name = "Unlock 120 FPS Cap",
   CurrentValue = false,
   Flag = "FPS120Toggle",
   Callback = function(Value)
      if setfpscap then
         setfpscap(Value and 120 or 60)
      else
         Rayfield:Notify({Title = "Error", Content = "Your executor does not support setfpscap()", Duration = 3})
      end
   end,
})

---------------------------------------------------------
-- 2. VISUALS TAB
---------------------------------------------------------
VisualsTab:CreateSection("World & ESP")

VisualsTab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Flag = "FullbrightToggle",
   Callback = function(Value)
      FullbrightEnabled = Value
      if not Value then
         Lighting.Ambient = DefaultAmbient
         Lighting.OutdoorAmbient = DefaultOutdoorAmbient
         Lighting.Brightness = DefaultBrightness
         Lighting.ClockTime = DefaultClockTime
      end
   end,
})

local function CleanupESP()
   for _, player in pairs(Players:GetPlayers()) do
      if player.Character then
         if player.Character:FindFirstChild("ApexESP") then player.Character.ApexESP:Destroy() end
         if player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("ApexNameESP") then
            player.Character.Head.ApexNameESP:Destroy()
         end
      end
   end
end

VisualsTab:CreateToggle({
   Name = "Player & Name ESP (Team/Status)",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      ESPEnabled = Value
      if not Value then
         CleanupESP()
      end
   end,
})

---------------------------------------------------------
-- 3. PLAYERS & TELEPORT TAB
---------------------------------------------------------
PlayersTab:CreateSection("Player Selector")

local function GetPlayerList()
   local list = {}
   for _, p in pairs(Players:GetPlayers()) do
      if p ~= LocalPlayer then
         table.insert(list, p.DisplayName .. " (@" .. p.Name .. ")")
      end
   end
   return list
end

local PlayerDropdown = PlayersTab:CreateDropdown({
   Name = "Select Target Player",
   Options = GetPlayerList(),
   CurrentOption = {"None"},
   MultipleOptions = false,
   Flag = "TargetPlayerDropdown",
   Callback = function(Option)
      local chosenText = Option[1]
      for _, p in pairs(Players:GetPlayers()) do
         if (p.DisplayName .. " (@" .. p.Name .. ")") == chosenText then
            SelectedPlayerForTP = p
            break
         end
      end
   end,
})

PlayersTab:CreateButton({
   Name = "Refresh Player List",
   Callback = function()
      PlayerDropdown:Refresh(GetPlayerList())
   end,
})

PlayersTab:CreateButton({
   Name = "Teleport To Target",
   Callback = function()
      if SelectedPlayerForTP and SelectedPlayerForTP.Character and SelectedPlayerForTP.Character:FindFirstChild("HumanoidRootPart") then
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayerForTP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
         end
      else
         Rayfield:Notify({Title = "Teleport Error", Content = "Target player or character not found!", Duration = 3})
      end
   end,
})

PlayersTab:CreateToggle({
   Name = "Loop Teleport To Target",
   CurrentValue = false,
   Flag = "LoopTPToggle",
   Callback = function(Value)
      LoopTPEnabled = Value
   end,
})

---------------------------------------------------------
-- 4. GAME UTILITIES TAB
---------------------------------------------------------
GamesTab:CreateSection("Highlights & ESP Targets")

GamesTab:CreateButton({
   Name = "Highlight Keys, Items & Tools",
   Callback = function()
      local count = 0
      for _, item in pairs(Workspace:GetDescendants()) do
         if item:IsA("ClickDetector") or item:IsA("ProximityPrompt") or item:IsA("Tool") then
            local targetPart = item:IsA("Tool") and (item:FindFirstChild("Handle") or item) or item.Parent
            if targetPart and (targetPart:IsA("BasePart") or targetPart:IsA("Model")) and not targetPart:FindFirstChild("ItemGlow") then
               local highlight = Instance.new("Highlight")
               highlight.Name = "ItemGlow"
               highlight.FillColor = Color3.fromRGB(255, 255, 0)
               highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
               highlight.Parent = targetPart
               count = count + 1
            end
         end
      end
      Rayfield:Notify({Title = "Utility", Content = "Highlighted " .. tostring(count) .. " keys & items!", Duration = 3})
   end,
})

GamesTab:CreateButton({
   Name = "Highlight Escape Doors, Exits & Vents",
   Callback = function()
      local count = 0
      for _, obj in pairs(Workspace:GetDescendants()) do
         local name = obj.Name:lower()
         if name:find("door") or name:find("exit") or name:find("escape") or name:find("vent") or name:find("pod") then
            if (obj:IsA("BasePart") or obj:IsA("Model")) and not obj:FindFirstChild("DoorGlow") then
               local highlight = Instance.new("Highlight")
               highlight.Name = "DoorGlow"
               highlight.FillColor = Color3.fromRGB(0, 255, 128)
               highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
               highlight.Parent = obj
               count = count + 1
            end
         end
      end
      Rayfield:Notify({Title = "Utility", Content = "Highlighted " .. tostring(count) .. " doors & exits!", Duration = 3})
   end,
})

GamesTab:CreateButton({
   Name = "Highlight Puzzle Levers, Buttons & Traps",
   Callback = function()
      local count = 0
      for _, obj in pairs(Workspace:GetDescendants()) do
         local name = obj.Name:lower()
         if name:find("lever") or name:find("button") or name:find("generator") or name:find("puzzle") or name:find("trap") then
            if (obj:IsA("BasePart") or obj:IsA("Model")) and not obj:FindFirstChild("PuzzleGlow") then
               local highlight = Instance.new("Highlight")
               highlight.Name = "PuzzleGlow"
               highlight.FillColor = Color3.fromRGB(0, 191, 255)
               highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
               highlight.Parent = obj
               count = count + 1
            end
         end
      end
      Rayfield:Notify({Title = "Utility", Content = "Highlighted " .. tostring(count) .. " interactive objects!", Duration = 3})
   end,
})

GamesTab:CreateButton({
   Name = "Highlight Killers & Monsters",
   Callback = function()
      local count = 0
      for _, p in pairs(Players:GetPlayers()) do
         if p ~= LocalPlayer and p.Character then
            if (p.Team and (p.Team.Name:lower():find("killer") or p.Team.Name:lower():find("piggy") or p.Team.Name:lower():find("banana"))) 
               or p.Character:FindFirstChildOfClass("Tool") then
               
               if not p.Character:FindFirstChild("KillerGlow") then
                  local hl = Instance.new("Highlight")
                  hl.Name = "KillerGlow"
                  hl.FillColor = Color3.fromRGB(255, 0, 0)
                  hl.Parent = p.Character
                  count = count + 1
               end
            end
         end
      end
      Rayfield:Notify({Title = "Utility", Content = "Highlighted " .. tostring(count) .. " killers/monsters!", Duration = 3})
   end,
})

---------------------------------------------------------
-- 5. MUSIC PLAYER TAB (Delta Workspace MP3 Loader)
---------------------------------------------------------
MusicTab:CreateSection("Workspace Audio Player")

local SelectedTrackName = nil

local function GetMp3Files()
   local files = {}
   if listfiles then
      local allFiles = listfiles("")
      for _, filePath in pairs(allFiles) do
         if filePath:sub(-4):lower() == ".mp3" then
            -- Clean path string to extract filename
            local fileName = filePath:match("^.+/(.+)$") or filePath:match("^.+\\(.+)$") or filePath
            table.insert(files, fileName)
         end
      end
   end
   if #files == 0 then
      table.insert(files, "No .mp3 files found")
   end
   return files
end

local MusicDropdown = MusicTab:CreateDropdown({
   Name = "Select MP3 File",
   Options = GetMp3Files(),
   CurrentOption = {"None"},
   MultipleOptions = false,
   Flag = "MusicDropdown",
   Callback = function(Option)
      SelectedTrackName = Option[1]
   end,
})

MusicTab:CreateButton({
   Name = "Refresh MP3 List",
   Callback = function()
      MusicDropdown:Refresh(GetMp3Files())
   end,
})

MusicTab:CreateButton({
   Name = "Play Selected MP3",
   Callback = function()
      if not SelectedTrackName or SelectedTrackName == "No .mp3 files found" or SelectedTrackName == "None" then
         Rayfield:Notify({Title = "Music Error", Content = "Please select a valid .mp3 file first!", Duration = 3})
         return
      end

      if not (getcustomasset or getsynasset) then
         Rayfield:Notify({Title = "Executor Error", Content = "Your executor lacks getcustomasset support!", Duration = 3})
         return
      end

      local customAssetFunc = getcustomasset or getsynasset

      if CurrentSoundTrack then
         CurrentSoundTrack:Stop()
         CurrentSoundTrack:Destroy()
      end

      local sound = Instance.new("Sound")
      sound.Name = "DeltaCustomMusic"
      sound.SoundId = customAssetFunc(SelectedTrackName)
      sound.Volume = 1
      sound.Looped = true
      sound.Parent = Workspace
      sound:Play()

      CurrentSoundTrack = sound
      Rayfield:Notify({Title = "Music Player", Content = "Now Playing: " .. SelectedTrackName, Duration = 3})
   end,
})

MusicTab:CreateButton({
   Name = "Stop Playing",
   Callback = function()
      if CurrentSoundTrack then
         CurrentSoundTrack:Stop()
         CurrentSoundTrack:Destroy()
         CurrentSoundTrack = nil
         Rayfield:Notify({Title = "Music Player", Content = "Audio stopped.", Duration = 3})
      end
   end,
})

MusicTab:CreateSlider({
   Name = "Volume",
   Range = {0, 10},
   Increment = 0.1,
   Suffix = "",
   CurrentValue = 1,
   Flag = "MusicVolumeSlider",
   Callback = function(Value)
      if CurrentSoundTrack then
         CurrentSoundTrack.Volume = Value
      end
   end,
})

---------------------------------------------------------
-- MAIN RUNSERVICE LOOPS
---------------------------------------------------------
RunService.Stepped:Connect(function()
   -- Force Speed Logic
   if ForceSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.WalkSpeed = TargetSpeed
   end

   -- Noclip Logic
   if NoclipEnabled and LocalPlayer.Character then
      for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
         if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
         end
      end
   end

   -- Fullbright Logic
   if FullbrightEnabled then
      Lighting.Ambient = Color3.fromRGB(255, 255, 255)
      Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
      Lighting.Brightness = 2
      Lighting.ClockTime = 14
   end

   -- Loop Teleport Logic
   if LoopTPEnabled and SelectedPlayerForTP and SelectedPlayerForTP.Character and SelectedPlayerForTP.Character:FindFirstChild("HumanoidRootPart") then
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayerForTP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
      end
   end
end)

-- Dynamic Team & Name ESP Loop
task.spawn(function()
   while task.wait(0.5) do
      if ESPEnabled then
         for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
               
               -- Determine Team Status & Color
               local isFriendly = false
               if player.Team and LocalPlayer.Team then
                  isFriendly = (player.Team == LocalPlayer.Team)
               elseif player.TeamColor and LocalPlayer.TeamColor then
                  isFriendly = (player.TeamColor == LocalPlayer.TeamColor)
               end

               local statusTag = isFriendly and "[ Friendly ]" or "[ Enemy ]"
               local tagColor = isFriendly and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 50, 50)

               -- 1. Highlight Box ESP
               local highlight = player.Character:FindFirstChild("ApexESP")
               if not highlight then
                  highlight = Instance.new("Highlight")
                  highlight.Name = "ApexESP"
                  highlight.Parent = player.Character
               end
               highlight.FillColor = tagColor

               -- 2. Name & Distance Billboard GUI
               local head = player.Character.Head
               local nameGui = head:FindFirstChild("ApexNameESP")
               if not nameGui then
                  nameGui = Instance.new("BillboardGui")
                  nameGui.Name = "ApexNameESP"
                  nameGui.Size = UDim2.new(0, 200, 0, 50)
                  nameGui.StudsOffset = Vector3.new(0, 3, 0)
                  nameGui.AlwaysOnTop = true

                  local label = Instance.new("TextLabel")
                  label.Name = "ESPLabel"
                  label.Size = UDim2.new(1, 0, 1, 0)
                  label.BackgroundTransparency = 1
                  label.TextSize = 13
                  label.Font = Enum.Font.SourceSansBold
                  label.TextStrokeTransparency = 0
                  label.Parent = nameGui

                  nameGui.Parent = head
               end

               -- Distance Calculation
               local dist = 0
               if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                  dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude)
               end

               local textLabel = nameGui:FindFirstChild("ESPLabel")
               if textLabel then
                  textLabel.Text = player.DisplayName .. " (@" .. player.Name .. ")\n" .. statusTag .. " - " .. tostring(dist) .. "m"
                  textLabel.TextColor3 = tagColor
               end
            end
         end
      end
   end
end)

Rayfield:Notify({
   Title = "Apex Hub V2 Loaded",
   Content = "Added Music Player & Enhanced ESP successfully!",
   Duration = 4,
})
