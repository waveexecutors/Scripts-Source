local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players, RunService, Lighting, Workspace, UserInputService = game:GetService("Players"), game:GetService("RunService"), game:GetService("Lighting"), game:GetService("Workspace"), game:GetService("UserInputService")
local LocalPlayer, Camera = Players.LocalPlayer, Workspace.CurrentCamera

local Window = Rayfield:CreateWindow({
   Name = "⚡ Apex Utility | Universal V5", LoadingTitle = "Apex Hub", ConfigurationSaving = {Enabled = false},
   KeySystem = true, KeySettings = {Title = "Apex Hub", Subtitle = "Key System", Note = "Key: 300", SaveKey = false, Key = {"300"}}
})

-- State Variables
local Config = {Speed = 16, ForceSpeed = false, Noclip = false, Fullbright = false, ESP = false, LoopTP = false, Target = nil}
local Utils = {Items = false, Doors = false, Puzzles = false, Killers = false}
local Fun = {DAudio = false, DScreen = false, WAudio = false, WScreen = false}
local Aim = {Normal = false, Silent = false, MaxDistance = 2000}
local FPSCapEnabled = false

local DefaultL = {Ambient = Lighting.Ambient, Outdoor = Lighting.OutdoorAmbient, Brightness = Lighting.Brightness, Time = Lighting.ClockTime}

-- Tabs
local MainTab = Window:CreateTab("Movement & Aim", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local PlayersTab = Window:CreateTab("Players & TP", 4483362458)
local GamesTab = Window:CreateTab("Game Utilities", 4483362458)
local MusicTab = Window:CreateTab("Music Player", 4483362458)
local FunTab = Window:CreateTab("Fun", 4483362458)

---------------------------------------------------------
-- 1. MOVEMENT & AIMBOT (INSTANT LOCK & REAL 120 FPS)
---------------------------------------------------------
MainTab:CreateSection("Aimbot (Instant & Head Precision)")
MainTab:CreateToggle({
   Name = "Aimbot Normal (Lock Instantâneo na Cabeça)", 
   Callback = function(v) Aim.Normal = v end
})

MainTab:CreateToggle({
   Name = "Silent Aim (Head Precision)", 
   Callback = function(v) Aim.Silent = v end
})

MainTab:CreateSection("Movement & FPS Boost")
MainTab:CreateToggle({Name = "Force Speed", Callback = function(v) Config.ForceSpeed = v end})
MainTab:CreateSlider({Name = "Speed Value", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(v) Config.Speed = v end})
MainTab:CreateToggle({Name = "Noclip", Callback = function(v) Config.Noclip = v end})
MainTab:CreateSlider({Name = "Camera FOV", Range = {70, 120}, Increment = 1, CurrentValue = 70, Callback = function(v) Camera.FieldOfView = v end})

MainTab:CreateToggle({
   Name = "Unlock 120 FPS REAL + Engine Booster", 
   Callback = function(v) 
      FPSCapEnabled = v
      if setfpscap then 
         setfpscap(v and 120 or 60) 
      end
      -- Otimização interna da engine para alcance de 120 FPS reais
      if v then
         sethiddenproperty(workspace, "InterpolationThrottling", Enum.InterpolationThrottlingMode.Disabled)
         settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
      else
         settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
      end
   end
})

---------------------------------------------------------
-- VISUALS & ESP
---------------------------------------------------------
VisualsTab:CreateToggle({Name = "Fullbright", Callback = function(v)
   Config.Fullbright = v
   if not v then Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.Brightness, Lighting.ClockTime = DefaultL.Ambient, DefaultL.Outdoor, DefaultL.Brightness, DefaultL.Time end
end})

local function CleanupESP()
   for _, p in pairs(Players:GetPlayers()) do
      if p.Character then
         if p.Character:FindFirstChild("ApexESP") then p.Character.ApexESP:Destroy() end
         if p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("ApexNameESP") then p.Character.Head.ApexNameESP:Destroy() end
      end
   end
end
VisualsTab:CreateToggle({Name = "Player & Name ESP", Callback = function(v) Config.ESP = v if not v then CleanupESP() end end})

---------------------------------------------------------
-- PLAYERS & TELEPORT
---------------------------------------------------------
local function GetPLs()
   local t = {} for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(t, p.DisplayName.." (@"..p.Name..")") end end return t
end
local PDropdown = PlayersTab:CreateDropdown({Name = "Select Target", Options = GetPLs(), CurrentOption = {"None"}, Callback = function(o)
   for _, p in pairs(Players:GetPlayers()) do if (p.DisplayName.." (@"..p.Name..")") == o[1] then Config.Target = p break end end
end})
PlayersTab:CreateButton({Name = "Refresh Players", Callback = function() PDropdown:Refresh(GetPLs()) end})
PlayersTab:CreateButton({Name = "Teleport To Target", Callback = function()
   if Config.Target and Config.Target.Character and Config.Target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
      LocalPlayer.Character.HumanoidRootPart.CFrame = Config.Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
   end
end})
PlayersTab:CreateToggle({Name = "Loop Teleport", Callback = function(v) Config.LoopTP = v end})

---------------------------------------------------------
-- GAME UTILITIES
---------------------------------------------------------
local function ClearHL(tag)
   for _, o in pairs(Workspace:GetDescendants()) do if o:IsA("Highlight") and o.Name == tag then o:Destroy() end end
end
GamesTab:CreateToggle({Name = "ESP Keys & Tools", Callback = function(v) Utils.Items = v if not v then ClearHL("ItemGlow") end end})
GamesTab:CreateToggle({Name = "ESP Doors & Exits", Callback = function(v) Utils.Doors = v if not v then ClearHL("DoorGlow") end end})
GamesTab:CreateToggle({Name = "ESP Levers & Traps", Callback = function(v) Utils.Puzzles = v if not v then ClearHL("PuzzleGlow") end end})
GamesTab:CreateToggle({Name = "ESP Killers & Monsters", Callback = function(v) Utils.Killers = v if not v then ClearHL("KillerGlow") end end})

---------------------------------------------------------
-- MUSIC PLAYER
---------------------------------------------------------
local SelectedTrack, CurrentTrack = nil, nil
local function GetMp3()
   local t = {} if listfiles then for _, f in pairs(listfiles("")) do if f:sub(-4):lower() == ".mp3" then table.insert(t, f:match("^.+/(.+)$") or f) end end end
   return #t > 0 and t or {"No .mp3 files found"}
end
local MDropdown = MusicTab:CreateDropdown({Name = "Select MP3", Options = GetMp3(), CurrentOption = {"None"}, Callback = function(o) SelectedTrack = o[1] end})
MusicTab:CreateButton({Name = "Refresh MP3s", Callback = function() MDropdown:Refresh(GetMp3()) end})
MusicTab:CreateButton({Name = "Play MP3", Callback = function()
   if not SelectedTrack or SelectedTrack == "None" or SelectedTrack == "No .mp3 files found" then return end
   local func = getcustomasset or getsynasset
   if CurrentTrack then CurrentTrack:Stop() CurrentTrack:Destroy() end
   if func then
      CurrentTrack = Instance.new("Sound", Workspace)
      CurrentTrack.SoundId, CurrentTrack.Volume, CurrentTrack.Looped = func(SelectedTrack), 1, true
      CurrentTrack:Play()
   end
end})
MusicTab:CreateButton({Name = "Stop Music", Callback = function() if CurrentTrack then CurrentTrack:Stop() CurrentTrack:Destroy() CurrentTrack = nil end end})
MusicTab:CreateSlider({Name = "Volume", Range = {0, 10}, Increment = 0.1, CurrentValue = 1, Callback = function(v) if CurrentTrack then CurrentTrack.Volume = v end end})

---------------------------------------------------------
-- FUN TAB
---------------------------------------------------------
FunTab:CreateToggle({Name = "Distort Game Audio", Callback = function(v) Fun.DAudio = v end})
FunTab:CreateToggle({Name = "Distort Game Screen", Callback = function(v) Fun.DScreen = v end})
FunTab:CreateToggle({Name = "Wiggle Game Audio", Callback = function(v) Fun.WAudio = v end})
FunTab:CreateToggle({Name = "Wiggle Game Screen", Callback = function(v) Fun.WScreen = v end})

---------------------------------------------------------
-- HIGH PRECISION AIMBOT CALCULATOR
---------------------------------------------------------
local function GetClosestTargetHead()
   local closest, maxDist = nil, math.huge
   local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

   for _, p in pairs(Players:GetPlayers()) do
      if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChildOfClass("Humanoid") then
         local hum = p.Character:FindFirstChildOfClass("Humanoid")
         if hum and hum.Health > 0 then
            local head = p.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
               local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
               if dist < maxDist then 
                  closest = head 
                  maxDist = dist 
               end
            end
         end
      end
   end
   return closest
end

-- Silent Aim Hook
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
   local method = getnamecallmethod()
   if Aim.Silent and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
      local targetHead = GetClosestTargetHead()
      if targetHead then
         if method == "Raycast" then
            local args = {...}
            return Workspace:Raycast(args[1], (targetHead.Position - args[1]).Unit * 1000, args[3])
         end
      end
   end
   return oldNamecall(self, ...)
end)

---------------------------------------------------------
-- MAIN RENDER & STEPPED LOOPS
---------------------------------------------------------
local angle = 0
RunService.RenderStepped:Connect(function(dt)
   angle = angle + dt
   
   -- Lock Instantâneo na Cabeça
   if Aim.Normal then
      local head = GetClosestTargetHead()
      if head then
         Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
      end
   end

   -- FPS Maintainer Lock
   if FPSCapEnabled and setfpscap then
      setfpscap(120)
   end

   -- Fun Screen Effects
   if Fun.DScreen then Camera.CFrame = Camera.CFrame * CFrame.Angles(0, 0, math.rad(math.random(-25, 25))) end
   if Fun.WScreen then Camera.CFrame = Camera.CFrame * CFrame.Angles(math.cos(angle * 6) * 0.08, 0, math.sin(angle * 8) * 0.15) end
end)

RunService.Stepped:Connect(function()
   if Config.ForceSpeed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = Config.Speed end
   if Config.Noclip and LocalPlayer.Character then for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
   if Config.Fullbright then Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.Brightness, Lighting.ClockTime = Color3.new(1,1,1), Color3.new(1,1,1), 2, 14 end
   if Config.LoopTP and Config.Target and Config.Target.Character and Config.Target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
      LocalPlayer.Character.HumanoidRootPart.CFrame = Config.Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
   end
   if Fun.DAudio then for _, s in pairs(Workspace:GetDescendants()) do if s:IsA("Sound") and s.IsPlaying then s.PlaybackSpeed = math.random(3, 30)/10 end end end
   if Fun.WAudio then local sp = 1 + math.sin(tick() * 10) * 0.4 for _, s in pairs(Workspace:GetDescendants()) do if s:IsA("Sound") and s.IsPlaying then s.PlaybackSpeed = sp end end end
end)

---------------------------------------------------------
-- ESP & UTILITIES BACKGROUND WORKER
---------------------------------------------------------
task.spawn(function()
   while task.wait(0.5) do
      if Config.ESP then
         for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
               local char = p.Character
               local hl = char:FindFirstChild("ApexESP") or Instance.new("Highlight", char)
               hl.Name, hl.FillColor = "ApexESP", Color3.fromRGB(255, 50, 50)

               local gui = char.Head:FindFirstChild("ApexNameESP") or Instance.new("BillboardGui", char.Head)
               if gui.Name ~= "ApexNameESP" then
                  gui.Name, gui.Size, gui.StudsOffset, gui.AlwaysOnTop = "ApexNameESP", UDim2.new(0, 200, 0, 50), Vector3.new(0, 3, 0), true
                  local l = Instance.new("TextLabel", gui)
                  l.Name, l.Size, l.BackgroundTransparency, l.TextSize, l.Font, l.TextStrokeTransparency = "ESPLabel", UDim2.new(1, 0, 1, 0), 1, 13, Enum.Font.SourceSansBold, 0
               end
               local dist = LocalPlayer.Character and math.floor((LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude) or 0
               gui.ESPLabel.Text = p.DisplayName.." (@"..p.Name..")\n[ Target ] - "..dist.."m"
               gui.ESPLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
         end
      end
      if Utils.Items then
         for _, i in pairs(Workspace:GetDescendants()) do
            if i:IsA("ClickDetector") or i:IsA("ProximityPrompt") or i:IsA("Tool") then
               local p = i:IsA("Tool") and (i:FindFirstChild("Handle") or i) or i.Parent
               if p and (p:IsA("BasePart") or p:IsA("Model")) and not p:FindFirstChild("ItemGlow") then Instance.new("Highlight", p).Name = "ItemGlow" end
            end
         end
      end
      if Utils.Doors then
         for _, o in pairs(Workspace:GetDescendants()) do
            local n = o.Name:lower()
            if (n:find("door") or n:find("exit") or n:find("escape") or n:find("vent") or n:find("pod")) and (o:IsA("BasePart") or o:IsA("Model")) and not o:FindFirstChild("DoorGlow") then
               local h = Instance.new("Highlight", o) h.Name, h.FillColor = "DoorGlow", Color3.fromRGB(0, 255, 128)
            end
         end
      end
      if Utils.Puzzles then
         for _, o in pairs(Workspace:GetDescendants()) do
            local n = o.Name:lower()
            if (n:find("lever") or n:find("button") or n:find("generator") or n:find("puzzle") or n:find("trap")) and (o:IsA("BasePart") or o:IsA("Model")) and not o:FindFirstChild("PuzzleGlow") then
               local h = Instance.new("Highlight", o) h.Name, h.FillColor = "PuzzleGlow", Color3.fromRGB(0, 191, 255)
            end
         end
      end
      if Utils.Killers then
         for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
               local n = p.Character.Name:lower()
               if (n:find("piggy") or n:find("killer") or n:find("banana") or p.Character:FindFirstChild("Weapon") or p.Character:FindFirstChild("Bat")) and not p.Character:FindFirstChild("KillerGlow") then
                  local h = Instance.new("Highlight", p.Character) h.Name, h.FillColor = "KillerGlow", Color3.fromRGB(255, 0, 0)
               end
            end
         end
      end
   end
end)

Rayfield:Notify({Title = "Apex Hub V5 Real", Content = "Instant Lock na Cabeça + Unlock 120 FPS Real ativados!", Duration = 4})
