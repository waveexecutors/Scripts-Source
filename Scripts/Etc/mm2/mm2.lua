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

local Plrs, RS, UIS, Lighting, WS = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("Lighting"), game:GetService("Workspace")
local LP, Cam = Plrs.LocalPlayer, WS.CurrentCamera

local States = {Aimbot = false, AutoShootSheriff = false, InfJump = false, BunnyHop = false, SpeedBoost = false, FPSBoost = false, RTX = false, FOVToggle = false, TargetFOV = 70, ESP2D = false, Murderer2D = false, Innocent2D = false, Coin2D = false, RainbowESP = false, KillAura = false, SpinBot = false, FakeLag = false, Noclip = false, Invisible = false, AutoFarm = false}
local Config = {RainbowSpeed = 3, MaxFPS = 360, AutoShootRange = 35}
local Drawings2D = {}

local function clear2D() for _, d in pairs(Drawings2D) do if d and d.Drawings then for _, v in pairs(d.Drawings) do if v then v:Remove() end end end Drawings2D = {} end
local function getRole(p)
   if not p.Character then return "Innocent", false end
   local bp, char = p:FindFirstChild("Backpack"), p.Character
   if (bp and bp:FindFirstChild("Knife")) or char:FindFirstChild("Knife") then return "Murderer", true end
   if (bp and bp:FindFirstChild("Gun")) or char:FindFirstChild("Gun") then return "Sheriff", false end
   return "Innocent", false
end
local function getRainbow() return Color3.fromHSV((tick() * Config.RainbowSpeed) % 1, 1, 1) end

Tabs.Main:CreateSection("Targeting & Autonomous Defense")
Tabs.Main:CreateToggle({Name = "Smooth Instant Lock Aimbot (Murderer)", CurrentValue = false, Flag = "Aimbot", Callback = function(v) States.Aimbot = v end})
Tabs.Main:CreateToggle({Name = "Auto-Shoot Murderer (Sheriff Defense)", CurrentValue = false, Flag = "AutoShoot", Callback = function(v) States.AutoShootSheriff = v end})
Tabs.Main:CreateSlider({Name = "Auto-Shoot Trigger Range", Range = {10, 100}, Increment = 5, Suffix = "Studs", CurrentValue = 35, Flag = "ASRange", Callback = function(v) Config.AutoShootRange = v end})

Tabs.Sheriff:CreateSection("Sheriff Enhancements")
Tabs.Sheriff:CreateToggle({Name = "Gun Drop ESP / Tracer", CurrentValue = false, Flag = "GunESP", Callback = function(v) end})
Tabs.Sheriff:CreateToggle({Name = "Instant Gun Equip & Draw", CurrentValue = false, Flag = "InstGun", Callback = function(v) if v and LP.Character then local bp = LP:FindFirstChild("Backpack") if bp and bp:FindFirstChild("Gun") then bp.Gun.Parent = LP.Character end end end})

Tabs.Murderer:CreateSection("Murderer Offensive Tools")
Tabs.Murderer:CreateToggle({Name = "Aggressive Kill Aura (Knife)", CurrentValue = false, Flag = "KAura", Callback = function(v) States.KillAura = v end})
Tabs.Murderer:CreateToggle({Name = "Silent Knife Throw Predictor", CurrentValue = false, Flag = "SilentThrow", Callback = function(v) end})
Tabs.Murderer:CreateToggle({Name = "Auto-Collect All Map Coins", CurrentValue = false, Flag = "ACoins", Callback = function(v) States.AutoFarm = v end})

Tabs.Visuals:CreateSection("Performance & Optimization")
Tabs.Visuals:CreateToggle({Name = "Extreme FPS Boost (Deep Cleanup)", CurrentValue = false, Flag = "FPSB", Callback = function(v)
   States.FPSBoost = v
   settings().Rendering.QualityLevel = v and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
   Lighting.GlobalShadows = not v
   Lighting.Technology = v and Enum.Technology.Compatibility or Enum.Technology.ShadowMap
   for _, o in ipairs(WS:GetDescendants()) do
      if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Fire") or o:IsA("Smoke") or o:IsA("Sparkles") then o.Enabled = not v
      elseif v and (o:IsA("BasePart") or o:IsA("MeshPart")) then o.Material = Enum.Material.SmoothPlastic end
   end
end})
Tabs.Visuals:CreateSlider({Name = "Custom FPS Cap", Range = {30, 1000}, Increment = 10, Suffix = "FPS", CurrentValue = 360, Flag = "CFPS", Callback = function(v) Config.MaxFPS = v pcall(function() setfpscap(v) end) end})

Tabs.Visuals:CreateSection("Ultra Realistic RTX Processing (Safe Engine Pipeline)")
local CC, Bloom, SunRays, Atmo = Instance.new("ColorCorrectionEffect", Lighting), Instance.new("BloomEffect", Lighting), Instance.new("SunRaysEffect", Lighting), Instance.new("Atmosphere", Lighting)
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
Tabs.Visuals:CreateToggle({Name = "Dynamic FOV Modifier", CurrentValue = false, Flag = "FOVT", Callback = function(v) States.FOVToggle = v if not v then Cam.FieldOfView = 70 end end})
Tabs.Visuals:CreateSlider({Name = "Field of View Slider", Range = {70, 120}, Increment = 1, Suffix = "FOV", CurrentValue = 70, Flag = "FOVS", Callback = function(v) States.TargetFOV = v end})

Tabs.ESP2D:CreateSection("CS2 Style Precision 2D Overlays")
Tabs.ESP2D:CreateToggle({Name = "Master 2D ESP Toggle", CurrentValue = false, Flag = "ESP2D", Callback = function(v) States.ESP2D = v if not v then clear2D() end end})
Tabs.ESP2D:CreateToggle({Name = "Murderer 2D Box & Health", CurrentValue = false, Flag = "M2D", Callback = function(v) States.Murderer2D = v end})
Tabs.ESP2D:CreateToggle({Name = "Innocent & Sheriff 2D Box & Health", CurrentValue = false, Flag = "I2D", Callback = function(v) States.Innocent2D = v end})
Tabs.ESP2D:CreateToggle({Name = "Coin Container 2D Markers", CurrentValue = false, Flag = "C2D", Callback = function(v) States.Coin2D = v end})
Tabs.ESP2D:CreateToggle({Name = "Rainbow ESP Colors", CurrentValue = false, Flag = "Rainbow", Callback = function(v) States.RainbowESP = v end})
Tabs.ESP2D:CreateSlider({Name = "Rainbow Speed Slider", Range = {1, 15}, Increment = 1, Suffix = "Speed", CurrentValue = 3, Flag = "RbSpeed", Callback = function(v) Config.RainbowSpeed = v end})

Tabs.Movement:CreateSection("Character Mechanics & Authentic CS2 Bhop")
Tabs.Movement:CreateToggle({Name = "Infinite Jump Mechanics", CurrentValue = false, Flag = "IJ", Callback = function(v) States.InfJump = v end})
Tabs.Movement:CreateToggle({Name = "Authentic CS2 BunnyHop & Strafe Glide", CurrentValue = false, Flag = "Bhop", Callback = function(v) States.BunnyHop = v end})
Tabs.Movement:CreateToggle({Name = "Speedy Walk State", CurrentValue = false, Flag = "Spd", Callback = function(v) States.SpeedBoost = v end})
UIS.JumpRequest:Connect(function() if States.InfJump and LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end)

Tabs.Fun:CreateSection("Entertainment & Troll Utilities")
Tabs.Fun:CreateToggle({Name = "360 SpinBot Animation", CurrentValue = false, Flag = "Spin", Callback = function(v) States.SpinBot = v end})
Tabs.Fun:CreateToggle({Name = "Fake Lag Simulation", CurrentValue = false, Flag = "FLag", Callback = function(v) States.FakeLag = v end})
Tabs.Fun:CreateToggle({Name = "Server Noclip Mode", CurrentValue = false, Flag = "Nclip", Callback = function(v) States.Noclip = v end})
Tabs.Fun:CreateToggle({Name = "Client Invisible State", CurrentValue = false, Flag = "Invis", Callback = function(v)
   States.Invisible = v
   if LP.Character then for _, part in ipairs(LP.Character:GetDescendants()) do if part:IsA("BasePart") or part:IsA("Decal") then part.Transparency = v and 1 or 0 end end end
end})

RS.RenderStepped:Connect(function()
   if States.FOVToggle then Cam.FieldOfView = States.TargetFOV end

   local char = LP.Character
   if char then
      local hum = char:FindFirstChildOfClass("Humanoid")
      local hrp = char:FindFirstChild("HumanoidRootPart")
      
      if hum then hum.WalkSpeed = States.SpeedBoost and 24 or (hum.WalkSpeed == 24 and 16 or hum.WalkSpeed) end

      if States.BunnyHop and hrp and hum and UIS:IsKeyDown(Enum.KeyCode.Space) then
         if hum.FloorMaterial ~= Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
         else
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X * 1.04, hrp.AssemblyLinearVelocity.Y, hrp.AssemblyLinearVelocity.Z * 1.04)
         end
      end

      if States.SpinBot and hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(35), 0) end

      if States.Noclip then for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end

      if States.AutoFarm then
         local cont = WS:FindFirstChild("CoinContainer") or WS:FindFirstChild("Coins")
         if cont and hrp then
            for _, coin in ipairs(cont:GetChildren()) do
               local p = coin:IsA("Model") and coin.PrimaryPart or (coin:IsA("BasePart") and coin)
               if p and (p.Position - hrp.Position).Magnitude < 25 then hrp.CFrame = p.CFrame break end
            end
         end
      end

      if States.KillAura and hrp then
         local bp = LP:FindFirstChild("Backpack")
         local knife = (bp and bp:FindFirstChild("Knife")) or char:FindFirstChild("Knife")
         if knife then
            for _, p in ipairs(Plrs:GetPlayers()) do
               if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                  if (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 15 then
                     knife.Parent = char
                     pcall(function() knife:Activate() end)
                  end
               end
            end
         end
      end

      if States.AutoShootSheriff and hrp then
         local bp = LP:FindFirstChild("Backpack")
         local gun = (bp and bp:FindFirstChild("Gun")) or char:FindFirstChild("Gun")
         if gun then
            for _, p in ipairs(Plrs:GetPlayers()) do
               if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                  local _, isM = getRole(p)
                  if isM and (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude <= Config.AutoShootRange then
                     gun.Parent = char
                     Cam.CFrame = CFrame.new(Cam.CFrame.Position, p.Character.HumanoidRootPart.Position)
                     pcall(function() gun:Activate() end)
                  end
               end
            end
         end
      end
   end

   if States.ESP2D then
      for _, p in ipairs(Plrs:GetPlayers()) do
         if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
            local pChar = p.Character
            local hrp = pChar.HumanoidRootPart
            local hum = pChar:FindFirstChildOfClass("Humanoid")
            local role, isM = getRole(p)
            
            if (States.Murderer2D and isM) or (States.Innocent2D and not isM) then
               local topVec, topOnScreen = Cam:WorldToViewportPoint((hrp.CFrame * CFrame.new(0, 3, 0)).Position)
               local botVec, botOnScreen = Cam:WorldToViewportPoint((hrp.CFrame * CFrame.new(0, -3.5, 0)).Position)
               
               if topOnScreen or botOnScreen then
                  if not Drawings2D[p] then
                     local box, txt, bg, bar = Drawing.new("Square"), Drawing.new("Text"), Drawing.new("Square"), Drawing.new("Square")
                     box.Visible, box.Filled, box.Thickness = false, false, 1.5
                     txt.Visible, txt.Size, txt.Center, txt.Outline, txt.Color = false, 12, true, true, Color3.fromRGB(255, 255, 255)
                     bg.Visible, bg.Filled, bg.Thickness, bg.Color = false, true, 1, Color3.fromRGB(0, 0, 0)
                     bar.Visible, bar.Filled, bar.Thickness = false, true, 1
                     Drawings2D[p] = {Drawings = {box, txt, bg, bar}}
                  end
                  
                  local d = Drawings2D[p].Drawings
                  local height = math.abs(botVec.Y - topVec.Y)
                  local width = height / 2.2
                  local pos = Vector2.new(topVec.X - width / 2, topVec.Y)
                  local col = States.RainbowESP and getRainbow() or (isM and Color3.fromRGB(255, 0, 40) or Color3.fromRGB(30, 255, 120))
                  
                  d[1].Size, d[1].Position, d[1].Color, d[1].Visible = Vector2.new(width, height), pos, col, true
                  d[2].Text, d[2].Position, d[2].Visible = isM and "[CRIMINAL / MURDERER]" or ("[ " .. string.upper(role) .. " ]"), Vector2.new(topVec.X, pos.Y - 15), true
                  
                  local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                  local barH = height * hp
                  d[3].Size, d[3].Position, d[3].Visible = Vector2.new(3, height + 2), Vector2.new(pos.X - 6, pos.Y - 1), true
                  d[4].Size, d[4].Position, d[4].Color, d[4].Visible = Vector2.new(1, barH), Vector2.new(pos.X - 5, pos.Y + (height - barH)), Color3.fromRGB(255 - (hp * 255), hp * 255, 0), true
               elseif Drawings2D[p] then
                  for _, v in ipairs(Drawings2D[p].Drawings) do v.Visible = false end
               end
            else
               if Drawings2D[p] then for _, v in ipairs(Drawings2D[p].Drawings) do v.Visible = false end end
            end
         end
      end

      if States.Coin2D then
         local cont = WS:FindFirstChild("CoinContainer") or WS:FindFirstChild("Coins")
         if cont then
            for _, c in ipairs(cont:GetChildren()) do
               local part = c:IsA("Model") and c.PrimaryPart or (c:IsA("BasePart") and c)
               if part then
                  local v, onScreen = Cam:WorldToViewportPoint(part.Position)
                  local key = "Coin_" .. c.Name
                  if onScreen then
                     if not Drawings2D[key] then
                        local txt = Drawing.new("Text")
                        txt.Visible, txt.Size, txt.Center, txt.Outline, txt.Color, txt.Text = false, 11, true, true, Color3.fromRGB(255, 215, 0), "$"
                        Drawings2D[key] = {Drawings = {txt}}
                     end
                     Drawings2D[key].Drawings[1].Position, Drawings2D[key].Drawings[1].Visible = Vector2.new(v.X, v.Y), true
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
      for _, p in ipairs(Plrs:GetPlayers()) do
         if p ~= LP and p.Character then
            local _, isM = getRole(p)
            if isM and p.Character:FindFirstChild("HumanoidRootPart") then
               local hrp = p.Character.HumanoidRootPart
               local v, onScreen = Cam:WorldToViewportPoint(hrp.Position)
               if onScreen then
                  local dist = (Vector2.new(v.X, v.Y) - UIS:GetMouseLocation()).Magnitude
                  if dist < minDist then minDist, tPart = dist, hrp end
               end
            end
         end
      end
      if tPart then Cam.CFrame = CFrame.new(Cam.CFrame.Position, tPart.Position) end
   end
end)

Rayfield:LoadConfiguration()
  
