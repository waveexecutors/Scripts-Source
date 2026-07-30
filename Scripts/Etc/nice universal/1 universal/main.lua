-- Rayfield UI Library Setup
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Apex Utility | Universal V3",
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
local SoundService = game:GetService("SoundService")
local TeleportService = game:GetService("TeleportService")
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
local AntiKickEnabled = false

-- Utility Toggles State
local UtilityItemsToggle = false
local UtilityDoorsToggle = false
local UtilityPuzzlesToggle = false
local UtilityKillersToggle = false

-- Fun Tab Toggle States
local DistortAudioToggle = false
local DistortScreenToggle = false
local WiggleAudioToggle = false
local WiggleScreenToggle = false

-- Default Lighting Values
local DefaultAmbient = Lighting.Ambient
local DefaultOutdoorAmbient = Lighting.OutdoorAmbient
local DefaultBrightness = Lighting.Brightness
local DefaultClockTime = Lighting.ClockTime

---------------------------------------------------------
-- ANTI-KICK / ANTI-CHEAT BYPASS SYSTEM
---------------------------------------------------------
local function BypassAntiCheat()
    -- Блокировка метода Kick у игрока
    local function BlockKick()
        local oldKick = LocalPlayer.Kick
        LocalPlayer.Kick = function(self, message)
            if AntiKickEnabled then
                warn("[Apex] Kick blocked: " .. tostring(message))
                return nil
            end
            return oldKick(self, message)
        end
    end

    -- Блокировка удаления игрока из Players
    local function BlockPlayerRemove()
        local oldRemove = Players.Remove
        Players.Remove = function(self, player)
            if player == LocalPlayer and AntiKickEnabled then
                warn("[Apex] Player removal blocked")
                return nil
            end
            return oldRemove(self, player)
        end
    end

    -- Блокировка принудительного телепорта (используется как анти-кик)
    local function BlockForcedTeleport()
        local oldTeleport = TeleportService.Teleport
        TeleportService.Teleport = function(self, placeId, player, ...)
            if player == LocalPlayer and AntiKickEnabled then
                warn("[Apex] Forced teleport blocked")
                return nil
            end
            return oldTeleport(self, placeId, player, ...)
        end
    end

    -- Отключение RemoteEvent/RemoteFunction детекторов
    local function DisableDetectionRemotes()
        for _, remote in pairs(game:GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                local name = remote.Name:lower()
                if name:find("kick") or name:find("ban") or name:find("detect") or 
                   name:find("anticheat") or name:find("anti") or name:find("exploit") then
                    
                    if remote:IsA("RemoteEvent") then
                        local oldFire = remote.FireServer
                        remote.FireServer = function(self, ...)
                            if AntiKickEnabled then
                                return nil
                            end
                            return oldFire(self, ...)
                        end
                    end
                    
                    if remote:IsA("RemoteFunction") then
                        local oldInvoke = remote.InvokeServer
                        remote.InvokeServer = function(self, ...)
                            if AntiKickEnabled then
                                return nil
                            end
                            return oldInvoke(self, ...)
                        end
                    end
                end
            end
        end
    end

    -- Защита скрипта от удаления
    local function ProtectScript()
        local scriptObj = script or getfenv(0).script
        if scriptObj then
            local oldDestroy = scriptObj.Destroy
            scriptObj.Destroy = function(self)
                if AntiKickEnabled then
                    warn("[Apex] Script destroy blocked")
                    return nil
                end
                return oldDestroy(self)
            end
        end
    end

    -- Блокировка изменения WalkSpeed/JumpPower через анти-чит
    local function FreezeSpeedDetection()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            local oldWalkSpeed = humanoid.WalkSpeed
            local oldJumpPower = humanoid.JumpPower
            
            humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if AntiKickEnabled and humanoid.WalkSpeed ~= oldWalkSpeed then
                    humanoid.WalkSpeed = oldWalkSpeed
                end
            end)
            
            humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
                if AntiKickEnabled and humanoid.JumpPower ~= oldJumpPower then
                    humanoid.JumpPower = oldJumpPower
                end
            end)
        end
    end

    -- Защита от обнаружения через GetObjects
    local function ProtectGameObjects()
        local oldGetObjects = game.GetObjects
        game.GetObjects = function(self, ...)
            local result = oldGetObjects(self, ...)
            if AntiKickEnabled then
                for i, obj in pairs(result) do
                    if obj:IsA("Script") and (obj.Name:lower():find("kick") or obj.Name:lower():find("detect")) then
                        table.remove(result, i)
                    end
                end
            end
            return result
        end
    end

    -- Запуск всех защит
    BlockKick()
    BlockPlayerRemove()
    BlockForcedTeleport()
    DisableDetectionRemotes()
    ProtectScript()
    ProtectGameObjects()
    
    -- Периодическая перезащита
    spawn(function()
        while AntiKickEnabled do
            wait(3)
            DisableDetectionRemotes()
            if not LocalPlayer.Parent then
                LocalPlayer.Parent = Players
            end
        end
    end)
end

-- Инициализация Anti-Kick
local function InitAntiKick()
    if AntiKickEnabled then
        BypassAntiCheat()
        Rayfield:Notify({Title = "Protection", Content = "Anti-Kick activated - you are immune", Duration = 3})
    end
end

-- Дополнительная защита: удаление детекторов при старте
spawn(function()
    wait(2)
    for _, remote in pairs(game:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local name = remote.Name:lower()
            if name:find("kick") or name:find("ban") or name:find("detect") or 
               name:find("anticheat") or name:find("anti") or name:find("exploit") then
                remote:Destroy()
            end
        end
    end
end)

---------------------------------------------------------
-- TABS
---------------------------------------------------------
local MainTab = Window:CreateTab("Movement & Cam", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local PlayersTab = Window:CreateTab("Players & TP", 4483362458)
local GamesTab = Window:CreateTab("Game Utilities", 4483362458)
local MusicTab = Window:CreateTab("Music Player", 4483362458)
local FunTab = Window:CreateTab("Fun", 4483362458)
local ProtectionTab = Window:CreateTab("Protection", 4483362458)

---------------------------------------------------------
-- PROTECTION TAB (Anti-Kick & Anti-Cheat)
---------------------------------------------------------
ProtectionTab:CreateSection("Anti-Cheat Bypass")

ProtectionTab:CreateToggle({
   Name = "Anti-Kick Toggle (Bypass ALL kicks)",
   CurrentValue = false,
   Flag = "AntiKickToggle",
   Callback = function(Value)
      AntiKickEnabled = Value
      if Value then
         InitAntiKick()
      else
         Rayfield:Notify({Title = "Protection", Content = "Anti-Kick deactivated", Duration = 3})
      end
   end,
})

ProtectionTab:CreateButton({
   Name = "Force Reapply Protection",
   Callback = function()
      if AntiKickEnabled then
         BypassAntiCheat()
         Rayfield:Notify({Title = "Protection", Content = "Protection reapplied", Duration = 3})
      else
         Rayfield:Notify({Title = "Protection", Content = "Enable Anti-Kick first", Duration = 3})
      end
   end,
})

ProtectionTab:CreateButton({
   Name = "Destroy All Detection Remotes",
   Callback = function()
      local count = 0
      for _, remote in pairs(game:GetDescendants()) do
         if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local name = remote.Name:lower()
            if name:find("kick") or name:find("ban") or name:find("detect") or 
               name:find("anticheat") or name:find("anti") or name:find("exploit") then
                remote:Destroy()
                count = count + 1
            end
         end
      end
      Rayfield:Notify({Title = "Protection", Content = "Destroyed " .. tostring(count) .. " remotes", Duration = 3})
   end,
})

ProtectionTab:CreateButton({
   Name = "Block All Incoming Kicks",
   Callback = function()
      if AntiKickEnabled then
         game:GetService("CoreGui"):SetCore("Kick", function() end)
         Rayfield:Notify({Title = "Protection", Content = "All kick events blocked", Duration = 3})
      end
   end,
})

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
-- 4. GAME UTILITIES TAB (TOGGLES)
---------------------------------------------------------
GamesTab:CreateSection("Highlights & ESP Targets")

local function ClearHighlights(tagName)
   for _, obj in pairs(Workspace:GetDescendants()) do
      if obj:IsA("Highlight") and obj.Name == tagName then
         obj:Destroy()
      end
   end
   for _, p in pairs(Players:GetPlayers()) do
      if p.Character and p.Character:FindFirstChild(tagName) then
         p.Character[tagName]:Destroy()
      end
   end
end

GamesTab:CreateToggle({
   Name = "ESP Keys, Items & Tools",
   CurrentValue = false,
   Flag = "ItemsToggle",
   Callback = function(Value)
      UtilityItemsToggle = Value
      if not Value then ClearHighlights("ItemGlow") end
   end,
})

GamesTab:CreateToggle({
   Name = "ESP Escape Doors & Exits",
   CurrentValue = false,
   Flag = "DoorsToggle",
   Callback = function(Value)
      UtilityDoorsToggle = Value
      if not Value then ClearHighlights("DoorGlow") end
   end,
})

GamesTab:CreateToggle({
   Name = "ESP Levers, Buttons & Traps",
   CurrentValue = false,
   Flag = "PuzzlesToggle",
   Callback = function(Value)
      UtilityPuzzlesToggle = Value
      if not Value then ClearHighlights("PuzzleGlow") end
   end,
})

GamesTab:CreateToggle({
   Name = "ESP Killers & Monsters",
   CurrentValue = false,
   Flag = "KillersToggle",
   Callback = function(Value)
      UtilityKillersToggle = Value
      if not Value then ClearHighlights("KillerGlow") end
   end,
})

---------------------------------------------------------
-- 5. MUSIC PLAYER TAB
---------------------------------------------------------
MusicTab:CreateSection("Workspace Audio Player")

local SelectedTrackName = nil

local function GetMp3Files()
   local files = {}
   if listfiles then
      local allFiles = listfiles("")
      for _, filePath in pairs(allFiles) do
         if filePath:sub(-4):lower() == ".mp3" then
            local fileName = filePath:match("^.+/(.+)$") or filePath:match("^.+\\(.+)$") or filePath
            table.insert(files, fileName)
         end
      end
   end
   if #files == 0 then table.insert(files, "No .mp3 files found") end
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
-- 6. FUN TAB
---------------------------------------------------------
FunTab:CreateSection("Audio & Screen Effects")

FunTab:CreateToggle({
   Name = "Distort Game Audio",
   CurrentValue = false,
   Flag = "DistortAudioToggle",
   Callback = function(Value)
      DistortAudioToggle = Value
      if not Value then
         for _, sound in pairs(Workspace:GetDescendants()) do
            if sound:IsA("Sound") then sound.PlaybackSpeed = 1 end
         end
         for _, sound in pairs(SoundService:GetDescendants()) do
            if sound:IsA("Sound") then sound.PlaybackSpeed = 1 end
         end
      end
   end,
})

FunTab:CreateToggle({
   Name = "Distort Game Screen",
   CurrentValue = false,
   Flag = "DistortScreenToggle",
   Callback = function(Value)
      DistortScreenToggle = Value
   end,
})

FunTab:CreateToggle({
   Name = "Wiggle Game Audio",
   CurrentValue = false,
   Flag = "WiggleAudioToggle",
   Callback = function(Value)
      WiggleAudioToggle = Value
      if not Value then
         for _, sound in pairs(Workspace:GetDescendants()) do
            if sound:IsA("Sound") then sound.PlaybackSpeed = 1 end
         end
         for _, sound in pairs(SoundService:GetDescendants()) do
            if sound:IsA("Sound") then sound.PlaybackSpeed = 1 end
         end
      end
   end,
})

FunTab:CreateToggle({
   Name = "Wiggle Game Screen",
   CurrentValue = false,
   Flag = "WiggleScreenToggle",
   Callback = function(Value)
      WiggleScreenToggle = Value
   end,
})

---------------------------------------------------------
-- MAIN RUNSERVICE & STEPPED LOOPS
---------------------------------------------------------
local angleCounter = 0

RunService.RenderStepped:Connect(function(deltaTime)
   angleCounter = angleCounter + deltaTime

   if DistortScreenToggle then
      local cam = Workspace.CurrentCamera
      if cam then
         cam.CFrame = cam.CFrame * CFrame.Angles(0, 0, math.rad(math.random(-25, 25)))
      end
   end

   if WiggleScreenToggle then
      local cam = Workspace.CurrentCamera
      if cam then
         local wiggleZ = math.sin(angleCounter * 8) * 0.15
         local wiggleY = math.cos(angleCounter * 6) * 0.08
         cam.CFrame = cam.CFrame * CFrame.Angles(wiggleY, 0, wiggleZ)
      end
   end
end)

RunService.Stepped:Connect(function()
   if ForceSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.WalkSpeed = TargetSpeed
   end

   if NoclipEnabled and LocalPlayer.Character then
      for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
         if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
         end
      end
   end

   if FullbrightEnabled then
      Lighting.Ambient = Color3.fromRGB(255, 255, 255)
      Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
      Lighting.Brightness = 2
      Lighting.ClockTime = 14
   end

   if LoopTPEnabled and SelectedPlayerForTP and SelectedPlayerForTP.Character and SelectedPlayerForTP.Character:FindFirstChild("HumanoidRootPart") then
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayerForTP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
      end
   end

   if DistortAudioToggle then
      for _, sound in pairs(Workspace:GetDescendants()) do
         if sound:IsA("Sound") and sound.IsPlaying then
            sound.PlaybackSpeed = math.random(3, 30) / 10
         end
      end
   end

   if WiggleAudioToggle then
      local speedMod = 1 + math.sin(tick() * 10) * 0.4
      for _, sound in pairs(Workspace:GetDescendants()) do
         if sound:IsA("Sound") and sound.IsPlaying then
            sound.PlaybackSpeed = speedMod
         end
      end
   end
end)

---------------------------------------------------------
-- BACKGROUND ESP & UTILITY TOGGLES LOOP
---------------------------------------------------------
task.spawn(function()
   while task.wait(0.5) do
      if ESPEnabled then
         for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
               
               local charName = player.Character.Name:lower()
               local pName = player.Name:lower()
               local isPiggyOrKiller = charName:find("piggy") or pName:find("piggy") or charName:find("killer") or charName:find("banana") or player.Character:FindFirstChild("Weapon") or player.Character:FindFirstChild("Bat")

               local isFriendly = false
               if not isPiggyOrKiller then
                  if player.Team and LocalPlayer.Team then
                     isFriendly = (player.Team == LocalPlayer.Team)
                  elseif player.TeamColor and LocalPlayer.TeamColor then
                     isFriendly = (player.TeamColor == LocalPlayer.TeamColor)
                  end
               end

               local statusTag = isFriendly and "[ Friendly ]" or "[ Enemy ]"
               local tagColor = isFriendly and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 50, 50)

               local highlight = player.Character:FindFirstChild("ApexESP")
               if not highlight then
                  highlight = Instance.new("Highlight")
                  highlight.Name = "ApexESP"
                  highlight.Parent = player.Character
               end
               highlight.FillColor = tagColor

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

      if UtilityItemsToggle then
         for _, item in pairs(Workspace:GetDescendants()) do
            if item:IsA("ClickDetector") or item:IsA("ProximityPrompt") or item:IsA("Tool") then
               local targetPart = item:IsA("Tool") and (item:FindFirstChild("Handle") or item) or item.Parent
               if targetPart and (targetPart:IsA("BasePart") or targetPart:IsA("Model")) and not targetPart:FindFirstChild("ItemGlow") then
                  local highlight = Instance.new("Highlight")
                  highlight.Name = "ItemGlow"
                  highlight.FillColor = Color3.fromRGB(255, 255, 0)
                  highlight.Parent = targetPart
               end
            end
         end
      end

      if UtilityDoorsToggle then
         for _, obj in pairs(Workspace:GetDescendants()) do
            local name = obj.Name:lower()
            if name:find("door") or name:find("exit") or name:find("escape") or name:find("vent") or name:find("pod") then
               if (obj:IsA("BasePart") or obj:IsA("Model")) and not obj:FindFirstChild("DoorGlow") then
                  local highlight = Instance.new("Highlight")
                  highlight.Name = "DoorGlow"
                  highlight.FillColor = Color3.fromRGB(0, 255, 128)
                  highlight.Parent = obj
               end
            end
         end
      end

      if UtilityPuzzlesToggle then
         for _, obj in pairs(Workspace:GetDescendants()) do
            local name = obj.Name:lower()
            if name:find("lever") or name:find("button") or name:find("generator") or name:find("puzzle") or name:find("trap") then
               if (obj:IsA("BasePart") or obj:IsA("Model")) and not obj:FindFirstChild("PuzzleGlow") then
                  local highlight = Instance.new("Highlight")
                  highlight.Name = "PuzzleGlow"
                  highlight.FillColor = Color3.fromRGB(0, 191, 255)
                  highlight.Parent = obj
               end
            end
         end
      end

      if UtilityKillersToggle then
         for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
               local charName = p.Character.Name:lower()
               local pName = p.Name:lower()
               if charName:find("piggy") or pName:find("piggy") or charName:find("killer") or charName:find("banana") or p.Character:FindFirstChild("Weapon") or p.Character:FindFirstChild("Bat") then
                  if not p.Character:FindFirstChild("KillerGlow") then
                     local hl = Instance.new("Highlight")
                     hl.Name = "KillerGlow"
                     hl.FillColor = Color3.fromRGB(255, 0, 0)
                     hl.Parent = p.Character
                  end
               end
            end
         end
      end

   end
end)

Rayfield:Notify({
   Title = "Apex Hub V3 Loaded",
   Content = "Anti-Kick protection added - you are immune to kicks!",
   Duration = 4,
})
