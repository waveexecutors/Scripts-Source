local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "bypass.go-live.me",
   LoadingTitle = "Bypass Hub",
   LoadingSubtitle = "MM2 | bypass.go-live.me on top",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false
})

local Tabs = {
   Main = Window:CreateTab("Combat", 4483362458),
   Strict = Window:CreateTab("Strict Cheats", 4483362458),
   Sheriff = Window:CreateTab("Sheriff Cheats", 4483362458),
   Murderer = Window:CreateTab("Murderer Cheats", 4483362458),
   Innocent = Window:CreateTab("Innocent Cheats", 4483362458),
   Visuals = Window:CreateTab("Visuals & RTX", 4483362458),
   ESP2D = Window:CreateTab("2D ESP", 4483362458),
   Movement = Window:CreateTab("Movement", 4483362458),
   Fun = Window:CreateTab("Fun Features", 4483362458)
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local States = {
   Aimbot = false, AutoShootSheriff = false, InfJump = false, BunnyHop = false, SpeedBoost = false, 
   FPSBoost = false, RTX = false, FOVToggle = false, TargetFOV = 70, ESP2D = false, 
   Murderer2D = false, Innocent2D = false, Coin2D = false, RainbowESP = false,
   KillAura = false, SpinBot = false, FakeLag = false, Noclip = false, Invisible = false,
   AutoFarm = false, SheriffESP = false, MurdererFinder = false, InnocentGodMode = false,
   AutoCollectGun = false, UltimateSurvivor = false, ChatSpammer = false, RainbowCharacter = false,
   Headless = false, CorruptSky = false, StrictGodMode = false, StrictAntiCheatBypass = false,
   StrictSilentAim = false, StrictKillAll = false
}

local Config = {
   RainbowSpeed = 3,
   MaxFPS = 360,
   AutoShootRange = 35,
   SpamMessage = "Bypass Hub Superiority - MM2 Dominated!"
}

local Drawings2D = {}

local function clear2D()
   for _, data in pairs(Drawings2D) do
      if data and data.Drawings then
         for _, d in pairs(data.Drawings) do
            if d then d:Remove() end
         end
      end
   end
   Drawings2D = {}
end

local function getPlayerRole(p)
   if not p.Character then return "Innocent", false end
   local backpack, char = p:FindFirstChild("Backpack"), p.Character
   if (backpack and backpack:FindFirstChild("Knife")) or char:FindFirstChild("Knife") then
      return "Murderer", true
   end
   if (backpack and backpack:FindFirstChild("Gun")) or char:FindFirstChild("Gun") then
      return "Sheriff", false
   end
   return "Innocent", false
end

local function getRainbowColor()
   local hue = (tick() * Config.RainbowSpeed) % 1
   return Color3.fromHSV(hue, 1, 1)
end

-- ==================== COMBAT TAB ====================
Tabs.Main:CreateSection("Targeting & Autonomous Defense")
Tabs.Main:CreateToggle({
   Name = "Smooth Instant Lock Aimbot (Murderer)",
   CurrentValue = false,
   Flag = "Aimbot",
   Callback = function(v)
      States.Aimbot = v
   end
})

Tabs.Main:CreateToggle({
   Name = "Auto-Shoot Murderer (Sheriff Defense)",
   CurrentValue = false,
   Flag = "AutoShoot",
   Callback = function(v)
      States.AutoShootSheriff = v
   end
})

Tabs.Main:CreateSlider({
   Name = "Auto-Shoot Trigger Range",
   Range = {10, 100},
   Increment = 5,
   Suffix = "Studs",
   CurrentValue = 35,
   Flag = "ASRange",
   Callback = function(v)
      Config.AutoShootRange = v
   end
})

-- ==================== STRICT CHEATS TAB ====================
Tabs.Strict:CreateSection("High-Level Strict Exploits")
Tabs.Strict:CreateToggle({
   Name = "Strict Server-Side Anti-Cheat Bypass",
   CurrentValue = false,
   Flag = "StrictAC",
   Callback = function(v)
      States.StrictAntiCheatBypass = v
   end
})

Tabs.Strict:CreateToggle({
   Name = "Strict Bullet & Knife Silent Aim",
   CurrentValue = false,
   Flag = "StrictSilent",
   Callback = function(v)
      States.StrictSilentAim = v
   end
})

Tabs.Strict:CreateToggle({
   Name = "Strict Global Kill All (Requires Knife/Gun)",
   CurrentValue = false,
   Flag = "StrictKA",
   Callback = function(v)
      States.StrictKillAll = v
      if v and LocalPlayer.Character then
         local char = LocalPlayer.Character
         local backpack = LocalPlayer:FindFirstChild("Backpack")
         local tool = (backpack and (backpack:FindFirstChild("Knife") or backpack:FindFirstChild("Gun"))) or char:FindFirstChild("Knife") or char:FindFirstChild("Gun")
         if tool then
            for _, p in ipairs(Players:GetPlayers()) do
               if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                  tool.Parent = char
                  pcall(function()
                     tool:Activate()
                  end)
               end
            end
         end
      end
   end
})

Tabs.Strict:CreateToggle({
   Name = "Strict Invulnerability GodMode State",
   CurrentValue = false,
   Flag = "StrictGod",
   Callback = function(v)
      States.StrictGodMode = v
      if v and LocalPlayer.Character then
         local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
         if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
         end
      end
   end
})

-- ==================== SHERIFF CHEATS TAB ====================
Tabs.Sheriff:CreateSection("Sheriff Enhancements & Utilities")
Tabs.Sheriff:CreateToggle({
   Name = "Sheriff Gun Drop ESP & Tracker",
   CurrentValue = false,
   Flag = "GunESP",
   Callback = function(v)
      States.SheriffESP = v
   end
})

Tabs.Sheriff:CreateToggle({
   Name = "Instant Gun Equip & Direct Draw",
   CurrentValue = false,
   Flag = "InstGun",
   Callback = function(v)
      if v and LocalPlayer.Character then
         local backpack = LocalPlayer:FindFirstChild("Backpack")
         if backpack and backpack:FindFirstChild("Gun") then
            backpack.Gun.Parent = LocalPlayer.Character
         end
      end
   end
})

-- ==================== MURDERER CHEATS TAB ====================
Tabs.Murderer:CreateSection("Murderer Offensive Tools")
Tabs.Murderer:CreateToggle({
   Name = "Aggressive Kill Aura (Knife)",
   CurrentValue = false,
   Flag = "KAura",
   Callback = function(v)
      States.KillAura = v
   end
})

Tabs.Murderer:CreateToggle({
   Name = "Silent Knife Throw Predictor",
   CurrentValue = false,
   Flag = "SilentThrow",
   Callback = function(v) end
})

Tabs.Murderer:CreateToggle({
   Name = "Auto-Collect All Map Coins",
   CurrentValue = false,
   Flag = "ACoins",
   Callback = function(v)
      States.AutoFarm = v
   end
})

-- ==================== INNOCENT CHEATS TAB ====================
Tabs.Innocent:CreateSection("Innocent Survival & Detective Utilities")
Tabs.Innocent:CreateToggle({
   Name = "Murderer Radar & Proximity Warning Alert",
   CurrentValue = false,
   Flag = "MInd",
   Callback = function(v)
      States.MurdererFinder = v
   end
})

Tabs.Innocent:CreateToggle({
   Name = "Auto-Collect Dropped Sheriff Gun",
   CurrentValue = false,
   Flag = "AutoGun",
   Callback = function(v)
      States.AutoCollectGun = v
   end
})

Tabs.Innocent:CreateToggle({
   Name = "Ultimate Survivor Evasion Speed Boost",
   CurrentValue = false,
   Flag = "SurvBoost",
   Callback = function(v)
      States.UltimateSurvivor = v
   end
})

Tabs.Innocent:CreateToggle({
   Name = "Innocent Damage Reduction Simulation",
   CurrentValue = false,
   Flag = "InnocentGod",
   Callback = function(v)
      States.InnocentGodMode = v
   end
})

-- ==================== VISUALS & RTX TAB ====================
Tabs.Visuals:CreateSection("Performance & Optimization")
Tabs.Visuals:CreateToggle({
   Name = "Extreme FPS Boost (Deep Cleanup)",
   CurrentValue = false,
   Flag = "FPSB",
   Callback = function(v)
      States.FPSBoost = v
      settings().Rendering.QualityLevel = v and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
      Lighting.GlobalShadows = not v
      Lighting.Technology = v and Enum.Technology.Compatibility or Enum.Technology.ShadowMap
      for _, o in ipairs(Workspace:GetDescendants()) do
         if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Fire") or o:IsA("Smoke") or o:IsA("Sparkles") then
            o.Enabled = not v
         elseif v and (o:IsA("BasePart") or o:IsA("MeshPart")) then
            o.Material = Enum.Material.SmoothPlastic
         end
      end
   end
})

Tabs.Visuals:CreateSlider({
   Name = "Custom FPS Cap",
   Range = {30, 1000},
   Increment = 10,
   Suffix = "FPS",
   CurrentValue = 360,
   Flag = "CFPS",
   Callback = function(v)
      Config.MaxFPS = v
      pcall(function() setfpscap(v) end)
   end
})

Tabs.Visuals:CreateSection("Ultra Realistic RTX Processing (Safe Engine Pipeline)")
local CC, Bloom, SunRays, Atmo
local rtxInitialized = false

local function initRTXObjects()
   if rtxInitialized then return end
   rtxInitialized = true
   pcall(function()
      CC = Instance.new("ColorCorrectionEffect", Lighting)
      Bloom = Instance.new("BloomEffect", Lighting)
      SunRays = Instance.new("SunRaysEffect", Lighting)
      Atmo = Instance.new("Atmosphere", Lighting)

      CC.Saturation, CC.Contrast, CC.Brightness, CC.TintColor = 0.35, 0.40, 0.05, Color3.fromRGB(255, 248, 235)
      Bloom.Intensity, Bloom.Size, Bloom.Threshold = 1.2, 56, 0.65
      SunRays.Intensity, SunRays.Spread = 0.75, 1.0
      Atmo.Density, Atmo.Offset, Atmo.Color, Atmo.Decay, Atmo.Glare, Atmo.Haze = 0.3, 0.25, Color3.fromRGB(200, 215, 230), Color3.fromRGB(100, 110, 125), 0.4, 1.5
      
      CC.Enabled, Bloom.Enabled, SunRays.Enabled, Atmo.Enabled = false, false, false, false
   end)
end

local OA, OOA, OB, OCI = Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.Brightness, Lighting.ClockTime

Tabs.Visuals:CreateToggle({
   Name = "Ultra RTX Shaders (Super Bright Sun & Glass Reflection)",
   CurrentValue = false,
   Flag = "RTX",
   Callback = function(v)
      States.RTX = v
      if v then initRTXObjects() end
      pcall(function()
         if CC then CC.Enabled = v end
         if Bloom then Bloom.Enabled = v end
         if SunRays then SunRays.Enabled = v end
         if Atmo then Atmo.Enabled = v end
         Lighting.Ambient = v and Color3.fromRGB(50, 60, 75) or OA
         Lighting.OutdoorAmbient = v and Color3.fromRGB(80, 95, 120) or OOA
         Lighting.Brightness = v and 3.5 or OB
         Lighting.ClockTime = v and 9.5 or OCI
         Lighting.EnvironmentDiffuseScale = v and 1.0 or 0.5
         Lighting.EnvironmentSpecularScale = v and 1.0 or 0.5
      end)
   end
})

Tabs.Visuals:CreateToggle({
   Name = "Dynamic FOV Modifier",
   CurrentValue = false,
   Flag = "FOVT",
   Callback = function(v)
      States.FOVToggle = v
      if not v then Camera.FieldOfView = 70 end
   end
})

Tabs.Visuals:CreateSlider({
   Name = "Field of View Slider",
   Range = {70, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = 70,
   Flag = "FOVS",
   Callback = function(v)
      States.TargetFOV = v
   end
})

-- ==================== 2D ESP TAB ====================
Tabs.ESP2D:CreateSection("Hitbox-Aligned CS2 Precision 2D Overlays")
Tabs.ESP2D:CreateToggle({
   Name = "Master 2D ESP Toggle",
   CurrentValue = false,
   Flag = "ESP2D",
   Callback = function(v)
      States.ESP2D = v
      if not v then clear2D() end
   end
})

Tabs.ESP2D:CreateToggle({
   Name = "Murderer 2D Box & CS2 Health Bar",
   CurrentValue = false,
   Flag = "M2D",
   Callback = function(v)
      States.Murderer2D = v
   end
})

Tabs.ESP2D:CreateToggle({
   Name = "Innocent & Sheriff 2D Box & Health",
   CurrentValue = false,
   Flag = "I2D",
   Callback = function(v)
      States.Innocent2D = v
   end
})

Tabs.ESP2D:CreateToggle({
   Name = "Coin Container 2D Markers",
   CurrentValue = false,
   Flag = "C2D",
   Callback = function(v)
      States.Coin2D = v
   end
})

Tabs.ESP2D:CreateToggle({
   Name = "Rainbow ESP Colors",
   CurrentValue = false,
   Flag = "Rainbow",
   Callback = function(v)
      States.RainbowESP = v
   end
})

Tabs.ESP2D:CreateSlider({
   Name = "Rainbow Animation Speed Slider",
   Range = {1, 15},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 3,
   Flag = "RbSpeed",
   Callback = function(v)
      Config.RainbowSpeed = v
   end
})

-- ==================== MOVEMENT TAB ====================
Tabs.Movement:CreateSection("Character Mechanics & Authentic CS2 Bhop")
Tabs.Movement:CreateToggle({
   Name = "Infinite Jump Mechanics",
   CurrentValue = false,
   Flag = "IJ",
   Callback = function(v)
      States.InfJump = v
   end
})

Tabs.Movement:CreateToggle({
   Name = "Authentic CS2 Auto-Jump & Strafe Glide Bhop",
   CurrentValue = false,
   Flag = "Bhop",
   Callback = function(v)
      States.BunnyHop = v
   end
})

Tabs.Movement:CreateToggle({
   Name = "Speedy Walk State",
   CurrentValue = false,
   Flag = "Spd",
   Callback = function(v)
      States.SpeedBoost = v
   end
})

UserInputService.JumpRequest:Connect(function()
   if States.InfJump and LocalPlayer.Character then
      local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
      if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
   end
end)

-- ==================== FUN FEATURES TAB ====================
Tabs.Fun:CreateSection("Entertainment & Troll Utilities")
Tabs.Fun:CreateToggle({
   Name = "360 SpinBot Animation",
   CurrentValue = false,
   Flag = "Spin",
   Callback = function(v)
      States.SpinBot = v
   end
})

Tabs.Fun:CreateToggle({
   Name = "Fake Lag Simulation",
   CurrentValue = false,
   Flag = "FLag",
   Callback = function(v)
      States.FakeLag = v
   end
})

Tabs.Fun:CreateToggle({
   Name = "Server Noclip Mode",
   CurrentValue = false,
   Flag = "Nclip",
   Callback = function(v)
      States.Noclip = v
   end
})

Tabs.Fun:CreateToggle({
   Name = "Client Invisible State",
   CurrentValue = false,
   Flag = "Invis",
   Callback = function(v)
      States.Invisible = v
      local char = LocalPlayer.Character
      if char then
         for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
               part.Transparency = v and 1 or 0
            end
         end
      end
   end
})

Tabs.Fun:CreateToggle({
   Name = "Rainbow Character Chroma Glow",
   CurrentValue = false,
   Flag = "RChar",
   Callback = function(v)
      States.RainbowCharacter = v
   end
})

Tabs.Fun:CreateToggle({
   Name = "Headless Character Modifier",
   CurrentValue = false,
   Flag = "Hless",
   Callback = function(v)
      States.Headless = v
      local char = LocalPlayer.Character
      if char and char:FindFirstChild("Head") then
         local head = char.Head
         head.Transparency = v and 1 or 0
         if head:FindFirstChild("face") then
            head.face.Transparency = v and 1 or 0
         end
      end
   end
})

Tabs.Fun:CreateToggle({
   Name = "Corrupt Cyberpunk Skybox FX",
   CurrentValue = false,
   Flag = "CSky",
   Callback = function(v)
      States.CorruptSky = v
      if v then
         Lighting.ClockTime = 0
         Lighting.Brightness = 0.2
      else
         Lighting.ClockTime = 14
         Lighting.Brightness = 2
      end
   end
})

Tabs.Fun:CreateToggle({
   Name = "Automated Chat Flex Spammer",
   CurrentValue = false,
   Flag = "Spam",
   Callback = function(v)
      States.ChatSpammer = v
   end
})

-- ==================== MAIN RENDER / PHYSICS LOOP ====================
RunService.RenderStepped:Connect(function()
   if States.FOVToggle then Camera.FieldOfView = States.TargetFOV end

   local char = LocalPlayer.Character
   if char then
      local hum = char:FindFirstChildOfClass("Humanoid")
      local hrp = char:FindFirstChild("HumanoidRootPart")
      
      if hum then
         local baseSpeed = States.UltimateSurvivor and 22 or 16
         hum.WalkSpeed = States.SpeedBoost and 25 or baseSpeed
      end

      -- Accurate CS2 BunnyHop Physics (Auto-Jump while moving + Pure Strafe Acceleration Glide)
      if States.BunnyHop and hrp and hum then
         local moveDirection = hum.MoveDirection
         if moveDirection.Magnitude > 0 then
            if hum.FloorMaterial ~= Enum.Material.Air then
               hum:ChangeState(Enum.HumanoidStateType.Jumping)
            else
               local vel = hrp.AssemblyLinearVelocity
               hrp.AssemblyLinearVelocity = Vector3.new(vel.X * 1.05, vel.Y, vel.Z * 1.05)
            end
         end
      end

      if States.SpinBot and hrp then
         hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(35), 0)
      end

      if States.Noclip then
         for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
         end
      end

      if States.RainbowCharacter and hrp then
         local rColor = getRainbowColor()
         for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.Color = rColor end
         end
      end

      if States.AutoFarm then
         local cont = Workspace:FindFirstChild("CoinContainer") or Workspace:FindFirstChild("Coins")
         if cont and hrp then
            for _, coin in ipairs(cont:GetChildren()) do
               local p = coin:IsA("Model") and coin.PrimaryPart or (coin:IsA("BasePart") and coin)
               if p and (p.Position - hrp.Position).Magnitude < 25 then
                  hrp.CFrame = p.CFrame
                  break
               end
            end
         end
      end

      if States.KillAura and hrp then
         local bp = LocalPlayer:FindFirstChild("Backpack")
         local knife = (bp and bp:FindFirstChild("Knife")) or char:FindFirstChild("Knife")
         if knife then
            for _, p in ipairs(Players:GetPlayers()) do
               if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                  if (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 15 then
                     knife.Parent = char
                     pcall(function() knife:Activate() end)
                  end
               end
            end
         end
      end

      if States.AutoShootSheriff and hrp then
         local bp = LocalPlayer:FindFirstChild("Backpack")
         local gun = (bp and bp:FindFirstChild("Gun")) or char:FindFirstChild("Gun")
         if gun then
            for _, p in ipairs(Players:GetPlayers()) do
               if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                  local _, isM = getPlayerRole(p)
                  if isM and (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude <= Config.AutoShootRange then
                     gun.Parent = char
                     Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Character.HumanoidRootPart.Position)
                     pcall(function() gun:Activate() end)
                  end
               end
            end
         end
      end
   end

   -- CS2 Precision Hitbox-Sized 2D ESP Processing (Adjusted directly to actual player R6/R15 character bounds)
   if States.ESP2D then
      for _, p in ipairs(Players:GetPlayers()) do
         if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
            local pChar = p.Character
            local hrp = pChar.HumanoidRootPart
            local hum = pChar:FindFirstChildOfClass("Humanoid")
            local role, isM = getPlayerRole(p)
            local draw = (States.Murderer2D and isM) or (States.Innocent2D and not isM)
            
            if draw then
               -- Accurate model bounding calculation matching exact player dimensions (head top to foot bottom)
               local cf, size = pChar:GetBoundingBox()
               local topPos = (cf + Vecto
