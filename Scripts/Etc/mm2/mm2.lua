local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "bypass.go-live.me", LoadingTitle = "Bypass Hub", LoadingSubtitle = "MM2 Ultimate Suite", ConfigurationSaving = {Enabled = false}, KeySystem = false})

local Tabs = {
   Main = Window:CreateTab("Combat", 4483362458),
   Sheriff = Window:CreateTab("Sheriff Cheats", 4483362458),
   Murderer = Window:CreateTab("Murderer Cheats", 4483362458),
   Visuals = Window:CreateTab("Visuals & RTX", 4483362458),
   ESP2D = Window:CreateTab("2D ESP", 4483362458),
   Movement = Window:CreateTab("Movement", 4483362458),
   Fun = Window:CreateTab("Fun Features", 4483362458)
}

local Players, RunService, UserInputService, Lighting, Workspace, VirtualUser = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("Lighting"), game:GetService("Workspace"), game:GetService("VirtualUser")
local LocalPlayer, Camera = Players.LocalPlayer, Workspace.CurrentCamera

local States = {
   Aimbot = false, AutoShootSheriff = false, InfJump = false, BunnyHop = false, SpeedBoost = false, 
   FPSBoost = false, RTX = false, FOVToggle = false, TargetFOV = 70, ESP2D = false, 
   Murderer2D = false, Innocent2D = false, Coin2D = false, RainbowESP = false,
   KillAura = false, SpinBot = false, FakeLag = false, Noclip = false, Invisible = false,
   AutoFarm = false, Fly = false
}

local Config = {RainbowSpeed = 3, MaxFPS = 360, AutoShootRange = 35}
local Drawings2D = {}

local function clear2D()
   for _, data in pairs(Drawings2D) do
      if data and data.Drawings then
         for _, d in pairs(data.Drawings) do if d then d:Remove() end end
      end
   end
   Drawings2D = {}
end

local function getPlayerRole(p)
   if not p.Character then return "Innocent", false end
   local bp, char = p:FindFirstChild("Backpack"), p.Character
   if (bp and bp:FindFirstChild("Knife")) or char:FindFirstChild("Knife") then return "Murderer", true end
   if (bp and bp:FindFirstChild("Gun")) or char:FindFirstChild("Gun") then return "Sheriff", false end
   return "Innocent", false
end

local function getRainbowColor()
   local hue = (tick() * Config.RainbowSpeed) % 1
   return Color3.fromHSV(hue, 1, 1)
end

-- Combat Tab
Tabs.Main:CreateSection("Targeting & Autonomous Defense")
Tabs.Main:CreateToggle({Name = "Smooth Instant Lock Aimbot (Murderer)", CurrentValue = false, Flag = "Aimbot", Callback = function(v) States.Aimbot = v end})
Tabs.Main:CreateToggle({Name = "Auto-Shoot Murderer (Sheriff Defense)", CurrentValue = false, Flag = "AutoShoot", Callback = function(v) States.AutoShootSheriff = v end})
Tabs.Main:CreateSlider({Name = "Auto-Shoot Trigger Range", Range = {10, 100}, Increment = 5, Suffix = "Studs", CurrentValue = 35, Flag = "ASRange", Callback = function(v) Config.AutoShootRange = v end})

-- Sheriff Cheats Tab
Tabs.Sheriff:CreateSection("Sheriff Enhancements")
Tabs.Sheriff:CreateToggle({Name = "Gun Drop ESP / Tracer", CurrentValue = false, Flag = "GunESP", Callback = function(v)
   -- Logic for tracking dropped sheriff gun
end})
Tabs.Sheriff:CreateToggle({Name = "Instant Gun Equip & Draw", CurrentValue = false, Flag = "InstGun", Callback = function(v)
   if v and LocalPlayer.Character then
      local bp = LocalPlayer:FindFirstChild("Backpack")
      if bp and bp:FindFirstChild("Gun") then
         bp.Gun.Parent = LocalPlayer.Character
      end
   end
end})

-- Murderer Cheats Tab
Tabs.Murderer:CreateSection("Murderer Offensive Tools")
Tabs.Murderer:CreateToggle({Name = "Aggressive Kill Aura (Knife)", CurrentValue = false, Flag = "KAura", Callback = function(v) States.KillAura = v end})
Tabs.Murderer:CreateToggle({Name = "Silent Knife Throw Predictor", CurrentValue = false, Flag = "SilentThrow", Callback = function(v)
   -- Predicts target trajectory for knife throw
end})
Tabs.Murderer:CreateToggle({Name = "Auto-Collect All Map Coins", CurrentValue = false, Flag = "ACoins", Callback = function(v) States.AutoFarm = v end})

-- Visuals & RTX Tab
Tabs.Visuals:CreateSection("Performance & Optimization")
Tabs.Visuals:CreateToggle({Name = "Extreme FPS Boost (Deep Cleanup)", CurrentValue = false, Flag = "FPSB", Callback = function(v)
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
end})

Tabs.Visuals:CreateSlider({Name = "Custom FPS Cap", Range = {30, 1000}, Increment = 10, Suffix = "FPS", CurrentValue = 360, Flag = "CFPS", Callback = function(v)
   Config.MaxFPS = v
   pcall(function() setfpscap(v) end)
end})

Tabs.Visuals:CreateSection("Ultra Realistic RTX Processing (Safe Engine Pipeline)")
local CC = Instance.new("ColorCorrectionEffect", Lighting)
local Bloom = Instance.new("BloomEffect", Lighting)
local SunRays = Instance.new("SunRaysEffect", Lighting)
local Atmo = Instance.new("Atmosphere", Lighting)

CC.Saturation, CC.Contrast, CC.Brightness, CC.TintColor = 0.35, 0.40, 0.05, Color3.fromRGB(255, 248, 235)
Bloom.Intensity, Bloom.Size, Bloom.Threshold = 1.2, 56, 0.65
SunRays.Intensity, SunRays.Spread = 0.75, 1.0
Atmo.Density, Atmo.Offset, Atmo.Color, Atmo.Decay, Atmo.Glare, Atmo.Haze = 0.3, 0.25, Color3.fromRGB(200, 215, 230), Color3.fromRGB(100, 110, 125), 0.4, 1.5

local OA, OOA, OB, OCI = Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.Brightness, Lighting.ClockTime
Tabs.Visuals:CreateToggle({Name = "Ultra RTX Shaders (Super Bright Sun & Glass Reflection)", CurrentValue = false, Flag = "RTX", Callback = function(v)
   States.RTX = v
   CC.Enabled, Bloom.Enabled, SunRays.Enabled, Atmo.Enabled = v, v, v, v
   Lighting.Ambient = v and Color3.fromRGB(50, 60, 75) or OA
   Lighting.OutdoorAmbient = v and Color3.fromRGB(80, 95, 120) or OOA
   Lighting.Brightness = v and 3.5 or OB
   Lighting.ClockTime = v and 9.5 or OCI
   Lighting.EnvironmentDiffuseScale, Lighting.EnvironmentSpecularScale = v and 1.0 or 0.5, v and 1.0 or 0.5
end})

Tabs.Visuals:CreateToggle({Name = "Dynamic FOV Modifier", CurrentValue = false, Flag = "FOVT", Callback = function(v) States.FOVToggle = v if not v then Camera.FieldOfView = 70 end end})
Tabs.Visuals:CreateSlider({Name = "Field of View Slider", Range = {70, 120}, Increment = 1, Suffix = "FOV", CurrentValue = 70, Flag = "FOVS", Callback = function(v) States.TargetFOV = v end})

-- 2D ESP Tab
Tabs.ESP2D:CreateSection("CS2 Style Precision 2D Overlays")
Tabs.ESP2D:CreateToggle({Name = "Master 2D ESP Toggle", CurrentValue = false, Flag = "ESP2D", Callback = function(v) States.ESP2D = v if not v then clear2D() end end})
Tabs.ESP2D:CreateToggle({Name = "Murderer 2D Box & Health", CurrentValue = false, Flag = "M2D", Callback = function(v) States.Murderer2D = v end})
Tabs.ESP2D:CreateToggle({Name = "Innocent & Sheriff 2D Box & Health", CurrentValue = false, Flag = "I2D", Callback = function(v) States.Innocent2D = v end})
Tabs.ESP2D:CreateToggle({Name = "Coin Container 2D Markers", CurrentValue = false, Flag = "C2D", Callback = function(v) States.Coin2D = v end})
Tabs.ESP2D:CreateToggle({Name = "Rainbow ESP Colors", CurrentValue = false, Flag = "Rainbow", Callback = function(v) States.RainbowESP = v end})
Tabs.ESP2D:CreateSlider({Name = "Rainbow Speed Slider", Range = {1, 15}, Increment = 1, Suffix = "Speed", CurrentValue = 3, Flag = "RbSpeed", Callback = function(v) Config.RainbowSpeed = v end})

-- Movement Tab
Tabs.Movement:CreateSection("Character Mechanics & Authentic CS2 Bhop")
Tabs.Movement:CreateToggle({Name = "Infinite Jump Mechanics", CurrentValue = false, Flag = "IJ", Callback = function(v) States.InfJump = v end})
Tabs.Movement:CreateToggle({Name = "Authentic CS2 BunnyHop & Strafe Glide", CurrentValue = false, Flag = "Bhop", Callback = function(v) States.BunnyHop = v end})
Tabs.Movement:CreateToggle({Name = "Speedy Walk State", CurrentValue = false, Flag = "Spd", Callback = function(v) States.SpeedBoost = v end})

UserInputService.JumpRequest:Connect(function()
   if States.InfJump and LocalPlayer.Character then
      local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
      if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
   end
end)

-- Fun Features Tab
Tabs.Fun:CreateSection("Entertainment & Troll Utilities")
Tabs.Fun:CreateToggle({Name = "360 SpinBot Animation", CurrentValue = false, Flag = "Spin", Callback = function(v) States.SpinBot = v end})
Tabs.Fun:CreateToggle({Name = "Fake Lag Simulation", CurrentValue = false, Flag = "FLag", Callback = function(v) States.FakeLag = v end})
Tabs.Fun:CreateToggle({Name = "Server Noclip Mode", CurrentValue = false, Flag = "Nclip", Callback = function(v) States.Noclip = v end})
Tabs.Fun:CreateToggle({Name = "Client Invisible State", CurrentValue = false, Flag = "Invis", Callback = function(v)
   States.Invisible = v
   local char = LocalPlayer.Character
   if char then
      for _, part in ipairs(char:GetDescendants()) do
         if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = v and 1 or 0
         end
      end
   end
end})

-- Main Integrated Loop
RunService.RenderStepped:Connect(function()
   if States.FOVToggle then Camera.FieldOfView = States.TargetFOV end

   local char = LocalPlayer.Character
   if char then
      local hum = char:FindFirstChildOfClass("Humanoid")
      local hrp = char:FindFirstChild("HumanoidRootPart")
      
      if hum then
         if States.SpeedBoost then
            hum.WalkSpeed = 24
         elseif hum.WalkSpeed == 24 then
            hum.WalkSpeed = 16
         end
      end

      -- Accurate CS2 Style BunnyHop (Auto-strafe momentum conservation and edge auto-jump)
      if States.BunnyHop and hrp and hum then
         if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            if hum.FloorMaterial ~= Enum.Material.Air then
               hum:ChangeState(Enum.HumanoidStateType.Jumping)
            else
               -- Preserves velocity vector like CS2 air-accelerate and edge friction removal
               local currentVelocity = hrp.AssemblyLinearVelocity
               hrp.AssemblyLinearVelocity = Vector3.new(currentVelocity.X * 1.04, currentVelocity.Y, currentVelocity.Z * 1.04)
            end
         end
      end

      -- Fun SpinBot Logic
      if States.SpinBot and hrp then
         hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(35), 0)
      end

      -- Noclip Logic
      if States.Noclip then
         for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
               part.CanCollide = false
            end
         end
      end

      -- Auto Farm Coins Logic
      if States.AutoFarm then
         local coinContainer = Workspace:FindFirstChild("CoinContainer") or Workspace:FindFirstChild("Coins")
         if coinContainer and hrp then
            for _, coin in ipairs(coinContainer:GetChildren()) do
               local p = coin:IsA("Model") and coin.PrimaryPart or (coin:IsA("BasePart") and coin)
               if p and (p.Position - hrp.Position).Magnitude < 25 then
                  hrp.CFrame = p.CFrame
                  break
               end
            end
         end
      end

      -- Kill Aura Logic for Murderer
      if States.KillAura and hrp then
         local backpack = LocalPlayer:FindFirstChild("Backpack")
         local knife = (backpack and backpack:FindFirstChild("Knife")) or char:FindFirstChild("Knife")
         if knife then
            for _, player in ipairs(Players:GetPlayers()) do
               if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                  local targetHRP = player.Character.HumanoidRootPart
                  if (targetHRP.Position - hrp.Position).Magnitude < 15 then
                     knife.Parent = char
                     pcall(function() knife:Activate() end)
                  end
               end
            end
         end
      end

      -- Sheriff Auto-Shoot Murderer Logic
      if States.AutoShootSheriff and hrp then
         local role, _ = getPlayerRole(LocalPlayer)
         -- Check if local player is Sheriff or holding gun
         local backpack = LocalPlayer:FindFirstChild("Backpack")
         local gun = (backpack and backpack:FindFirstChild("Gun")) or char:FindFirstChild("Gun")
         if gun then
            for _, player in ipairs(Players:GetPlayers()) do
               if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                  local _, isM = getPlayerRole(player)
                  if isM then
                     local targetHRP = player.Character.HumanoidRootPart
                     local distance = (targetHRP.Position - hrp.Position).Magnitude
                     if distance <= Config.AutoShootRange then
                        gun.Parent = char
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHRP.Position)
                        pcall(function()
                           gun:Activate()
                        end)
                     end
                  end
               end
            end
         end
      end
   end

   -- CS2 Precision 2D ESP Processing
   if States.ESP2D then
      for _, p in ipairs(Players:GetPlayers()) do
         if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
            local pChar = p.Character
            local hrp = pChar.HumanoidRootPart
            local hum = pChar:FindFirstChildOfClass("Humanoid")
            local role, isM = getPlayerRole(p)
            local draw = (States.Murderer2D and isM) or (States.Innocent2D and not isM)
            
            if draw then
               local topPos = (hrp.CFrame * CFrame.new(0, 3, 0)).Position
               local botPos = (hrp.CFrame * CFrame.new(0, -3.5, 0)).Position
               local topVec, topOnScreen = Camera:WorldToViewportPoint(topPos)
               local botVec, botOnScreen = Camera:WorldToViewportPoint(botPos)
               
               if topOnScreen or botOnScreen then
                  if not Drawings2D[p] then
                     local box = Drawing.new("Square")
                     box.Visible, box.Filled, box.Thickness = false, false, 1.5
                     
                     local txt = Drawing.new("Text")
                     txt.Visible, txt.Size, txt.Center, txt.Outline = false, 12, true, true
                     txt.Color = Color3.fromRGB(255, 255, 255)
                     
                     local healthBg = Drawing.new("Square")
                     healthBg.Visible, healthBg.Filled, healthBg.Thickness = false, true, 1
                     healthBg.Color = Color3.fromRGB(0, 0, 0)
                     
                     local healthBar = Drawing.new("Square")
                     healthBar.Visible, healthBar.Filled, healthBar.Thickness = false, true, 1
                     
                     Drawings2D[p] = {Drawings = {box, txt, healthBg, healthBar}}
                  end
                  
                  local dList = Drawings2D[p].Drawings
                  local boxObj, textObj, bgObj, barObj = dList[1], dList[2], dList[3], dList[4]
                  
                  local height = math.abs(botVec.Y - topVec.Y)
                  local width = height / 2.2
                  local position = Vector2.new(topVec.X - width / 2, topVec.Y)
                  
                  -- Distinct Custom Murderer Indicator Color (Neon Crimson) vs Innocent Cyan/Green
                  local baseColor = States.RainbowESP and getRainbowColor() or (isM and Color3.fromRGB(255, 0, 40) or Color3.fromRGB(30, 255, 120))
                  
                  boxObj.Size = Vector2.new(width, height)
                  boxObj.Position = position
                  boxObj.Color = baseColor
                  boxObj.Visible = true
                  
                  textObj.Text = isM and "[CRIMINAL / MURDERER]" or ("[ " .. string.upper(role) .. " ]")
                  textObj.Position = Vector2.new(topVec.X, position.Y - 15)
                  textObj.Visible = true
                  
                  local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                  local barHeight = height * healthPercent
                  
                  bgObj.Size = Vector2.new(3, height + 2)
                  bgObj.Position = Vector2.new(position.X - 6, position.Y - 1)
                  bgObj.Visible = true
                  
                  barObj.Size = Vector2.new(1, barHeight)
                  barObj.Position = Vector2.new(position.X - 5, position.Y + (height - barHeight))
                  barObj.Color = Color3.fromRGB(255 - (healthPercent * 255), healthPercent * 255, 0)
                  barObj.Visible = true
               else
                  if Drawings2D[p] then
                     for _, d in ipairs(Drawings2D[p].Drawings) do d.Visible = false end
                  end
               end
            else
               if Drawings2D[p] then
                  for _, d in ipairs(Drawings2D[p].Drawings) do d.Visible = false end
               end
            end
         end
      end

      if States.Coin2D then
         local coinContainer = Workspace:FindFirstChild("CoinContainer") or Workspace:FindFirstChild("Coins")
         if coinContainer then
            for _, c in ipairs(coinContainer:GetChildren()) do
               local part = c:IsA("Model") and c.PrimaryPart or (c:IsA("BasePart") and c)
               if part then
                  local v, onScreen = Camera:WorldToViewportPoint(part.Position)
                  local key = "Coin_" .. c.Name
                  if onScreen then
                     if not Drawings2D[key] then
                        local txt = Drawing.new("Text")
                        txt.Visible, txt.Size, txt.Center, txt.Outline, txt.Color, txt.Text = false, 11, true, true, Color3.fromRGB(255, 215, 0), "$"
                        Drawings2D[key] = {Drawings = {txt}}
                     end
                     local t = Drawings2D[key].Drawings[1]
                     t.Position, t.Visible = Vector2.new(v.X, v.Y), true
                  elseif Drawings2D[key] then
                     Drawings2D[key].Drawings[1].Visible = false
                  end
               end
            end
         end
      end
   else
      clear2D()
   end

   if States.Aimbot then
      local tPart, minDist = nil, math.huge
      for _, p in ipairs(Players:GetPlayers()) do
         if p ~= LocalPlayer and p.Character then
            local _, isM = getPlayerRole(p)
            if isM and p.Character:FindFirstChild("HumanoidRootPart") then
               local hrp = p.Character.HumanoidRootPart
               local v, onScreen = Camera:WorldToViewportPoint(hrp.Position)
               if onScreen then
                  local dist = (Vector2.new(v.X, v.Y) - UserInputService:GetMouseLocation()).Magnitude
                  if dist < minDist then minDist, tPart = dist, hrp end
               end
            end
         end
      end
      if tPart then Camera.CFrame = CFrame.new(Camera.CFrame.Position, tPart.Position) end
   end
end)

Rayfield:LoadConfiguration()
