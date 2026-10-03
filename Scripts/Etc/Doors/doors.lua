local P, TS, UIS, CG, RS = game:GetService("Players"), game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("CoreGui"), game:GetService("RunService")
local LP = P.LocalPlayer
local SEC = "bypasspen"

local function vKey(k)
   if type(k) ~= "string" or not k:match("^bypass_") then return false end
   local s, d = pcall(function() return game:GetService("HttpService"):Base64Decode(k:gsub("^bypass_", "")) end)
   if not s or not d then return false end
   local p = {} for x in string.gmatch(d, "[^_]+") do table.insert(p, x) end
   return #p >= 3 and p[1] == "bypassme" and p[3] == SEC and tonumber(p[2]) and os.time() < tonumber(p[2])
end

local UI = {}
function UI:Init(cfg)
   local SG = Instance.new("ScreenGui", CG)
   SG.Name = "BypassMeRayfieldStyle"
   SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

   local authPass = false
   if cfg.KeySystem then
      local KF = Instance.new("Frame", SG)
      KF.Size, KF.Position, KF.BackgroundColor3 = UDim2.new(0, 420, 0, 240), UDim2.new(0.5, -210, 0.5, -120)
      KF.BackgroundColor3 = Color3.fromRGB(18, 18, 18); KF.BorderSizePixel = 0
      Instance.new("UICorner", KF).CornerRadius = UDim.new(0, 10)
      local st = Instance.new("UIStroke", KF) st.Color = Color3.fromRGB(40, 40, 40) st.Thickness = 1

      local KT = Instance.new("TextLabel", KF)
      KT.Size, KT.Position, KT.BackgroundTransparency = UDim2.new(1, 0, 0, 45), UDim2.new(0, 0, 0, 10), true
      KT.Text, KT.TextColor3, KT.Font, KT.TextSize = cfg.KeySettings.Title, Color3.fromRGB(240, 240, 240), Enum.Font.GothamBold, 16

      local KSub = Instance.new("TextLabel", KF)
      KSub.Size, KSub.Position, KSub.BackgroundTransparency = UDim2.new(1, -40, 0, 30), UDim2.new(0, 20, 0, 50), true
      KSub.Text, KSub.TextColor3, KSub.Font, KSub.TextSize = "Please enter your valid key to run the script.", Color3.fromRGB(150, 150, 150), Enum.Font.Gotham, 12

      local KB = Instance.new("TextBox", KF)
      KB.Size, KB.Position, KB.BackgroundColor3, KB.TextColor3 = UDim2.new(0, 380, 0, 42), UDim2.new(0.5, -190, 0, 95), Color3.fromRGB(25, 25, 25), Color3.new(1,1,1)
      KB.PlaceholderText, KB.Text, KB.Font, KB.TextSize = "bypass_...", "", Enum.Font.Gotham, 13
      Instance.new("UICorner", KB).CornerRadius = UDim.new(0, 6)
      local kbs = Instance.new("UIStroke", KB) kbs.Color = Color3.fromRGB(45, 45, 45) kbs.Thickness = 1

      local SB = Instance.new("TextButton", KF)
      SB.Size, SB.Position, SB.BackgroundColor3, SB.Text = UDim2.new(0, 185, 0, 38), UDim2.new(0.5, -190, 0, 155), Color3.fromRGB(50, 120, 255), "Check Key"
      SB.TextColor3, SB.Font, SB.TextSize = Color3.new(1,1,1), Enum.Font.GothamBold, 13
      Instance.new("UICorner", SB).CornerRadius = UDim.new(0, 6)

      local LB = Instance.new("TextButton", KF)
      LB.Size, LB.Position, LB.BackgroundColor3, LB.Text = UDim2.new(0, 185, 0, 38), UDim2.new(0.5, 5, 0, 155), Color3.fromRGB(35, 35, 35), "Get Key Link"
      LB.TextColor3, LB.Font, LB.TextSize = Color3.new(1,1,1), Enum.Font.GothamBold, 13
      Instance.new("UICorner", LB).CornerRadius = UDim.new(0, 6)

      LB.MouseButton1Click:Connect(function() if setclipboard then setclipboard("https://bypass.go-live.me") end end)

      SB.MouseButton1Click:Connect(function()
         if vKey(KB.Text) then authPass = true; KF:Destroy() else KB.Text = ""; KB.PlaceholderText = "Invalid or Expired Key!" end
      end)
      repeat task.wait() until authPass
   end

   local MF = Instance.new("Frame", SG)
   MF.Size, MF.Position, MF.BackgroundColor3 = UDim2.new(0, 480, 0, 310), UDim2.new(0.5, -240, 0.5, -155), Color3.fromRGB(15, 15, 15)
   MF.BorderSizePixel = 0
   Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 9)
   local mfStroke = Instance.new("UIStroke", MF) mfStroke.Color = Color3.fromRGB(35, 35, 35) mfStroke.Thickness = 1

   -- Rayfield-like Draggable Panel
   local dragging, dragInput, dragStart, startPos
   MF.InputBegan:Connect(function(i)
      if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
         dragging = true; dragStart = i.Position; startPos = MF.Position
         i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
      end
   end)
   UIS.InputChanged:Connect(function(i)
      if (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then dragInput = i end
   end)
   RS.RenderStepped:Connect(function()
      if dragging and dragInput then
         local d = dragInput.Position - dragStart
         MF.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
      end
   end)

   -- Topbar Header (Rayfield dark style)
   local TB = Instance.new("Frame", MF)
   TB.Size, TB.BackgroundColor3, TB.BorderSizePixel = UDim2.new(1, 0, 0, 36), Color3.fromRGB(20, 20, 20), 0
   Instance.new("UICorner", TB).CornerRadius = UDim.new(0, 9)

   local TL = Instance.new("TextLabel", TB)
   TL.Size, TL.Position, TL.BackgroundTransparency = UDim2.new(1, -80, 1, 0), UDim2.new(0, 12, 0, 0), true
   TL.Text, TL.TextColor3, TL.Font, TL.TextSize, TL.TextXAlignment = cfg.Name, Color3.fromRGB(230, 230, 230), Enum.Font.GothamBold, 12, Enum.TextXAlignment.Left

   local CB = Instance.new("TextButton", TB)
   CB.Size, CB.Position, CB.BackgroundTransparency = UDim2.new(0, 30, 0, 36), UDim2.new(1, -32, 0, 0), true
   CB.Text, CB.TextColor3, CB.Font, CB.TextSize = "×", Color3.fromRGB(160, 160, 160), Enum.Font.GothamBold, 18
   CB.MouseButton1Click:Connect(function() SG:Destroy() end)

   local MB = Instance.new("TextButton", TB)
   MB.Size, MB.Position, MB.BackgroundTransparency = UDim2.new(0, 30, 0, 36), UDim2.new(1, -62, 0, 0), true
   MB.Text, MB.TextColor3, MB.Font, MB.TextSize = "-", Color3.fromRGB(160, 160, 160), Enum.Font.GothamBold, 16
   
   local min = false
   MB.MouseButton1Click:Connect(function()
      min = not min
      for _, c in pairs(MF:GetChildren()) do if c ~= TB then c.Visible = not min end end
      MF.Size = min and UDim2.new(0, 480, 0, 36) or UDim2.new(0, 480, 0, 310)
   end)

   -- Sidebar Tabs
   local TabBar = Instance.new("ScrollingFrame", MF)
   TabBar.Size, TabBar.Position, TabBar.BackgroundTransparency, TabBar.ScrollBarThickness = UDim2.new(0, 120, 1, -44), UDim2.new(0, 6, 0, 40), true, 0
   local TLay = Instance.new("UIListLayout", TabBar)
   TLay.Padding = UDim.new(0, 3)
   TLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() TabBar.CanvasSize = UDim2.new(0, 0, 0, TLay.AbsoluteContentSize.Y) end)

   local Holder = Instance.new("Folder", MF)
   local WObj = {}

   function WObj:Tab(name)
      local SC = Instance.new("ScrollingFrame", MF)
      SC.Size, SC.Position, SC.BackgroundTransparency, SC.ScrollBarThickness, SC.Visible = UDim2.new(1, -134, 1, -44), UDim2.new(0, 128, 0, 40), true, 3, false
      local SLay = Instance.new("UIListLayout", SC)
      SLay.Padding = UDim.new(0, 5)
      SLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() SC.CanvasSize = UDim2.new(0, 0, 0, SLay.AbsoluteContentSize.Y + 6) end)

      local TBtn = Instance.new("TextButton", TabBar)
      TBtn.Size, TBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 30), Color3.fromRGB(22, 22, 22)
      TBtn.Text, TBtn.TextColor3, TBtn.Font, TBtn.TextSize = "  " .. name, Color3.fromRGB(150, 150, 150), Enum.Font.GothamMedium, 11
      TBtn.TextXAlignment = Enum.TextXAlignment.Left
      Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 6)

      TBtn.MouseButton1Click:Connect(function()
         for _, t in pairs(Holder:GetChildren()) do t.Visible = false end
         for _, b in pairs(TabBar:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) end end
         SC.Visible = true; TBtn.TextColor3 = Color3.fromRGB(50, 120, 255)
      end)

      SC.Parent = Holder
      if #Holder:GetChildren() == 1 then SC.Visible = true; TBtn.TextColor3 = Color3.fromRGB(50, 120, 255) end

      local TObj = {}
      function TObj:Toggle(data)
         local Btn = Instance.new("TextButton", SC)
         Btn.Size, Btn.BackgroundColor3 = UDim2.new(1, -6, 0, 32), Color3.fromRGB(20, 20, 20)
         Btn.Text, Btn.TextColor3, Btn.Font, Btn.TextSize, Btn.TextXAlignment = "  " .. data.Name, Color3.fromRGB(200, 200, 200), Enum.Font.Gotham, 11, Enum.TextXAlignment.Left
         Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

         local Ind = Instance.new("Frame", Btn)
         Ind.Size, Ind.Position = UDim2.new(0, 14, 0, 14), UDim2.new(1, -20, 0.5, -7)
         Ind.BackgroundColor3 = data.CurrentValue and Color3.fromRGB(50, 120, 255) or Color3.fromRGB(35, 35, 35)
         Instance.new("UICorner", Ind).CornerRadius = UDim.new(0, 4)

         local val = data.CurrentValue or false
         Btn.MouseButton1Click:Connect(function()
            val = not val
            Ind.BackgroundColor3 = val and Color3.fromRGB(50, 120, 255) or Color3.fromRGB(35, 35, 35)
            data.Callback(val)
         end)
      end

      function TObj:Button(data)
         local Btn = Instance.new("TextButton", SC)
         Btn.Size, Btn.BackgroundColor3 = UDim2.new(1, -6, 0, 32), Color3.fromRGB(22, 22, 22)
         Btn.Text, Btn.TextColor3, Btn.Font, Btn.TextSize = data.Name, Color3.fromRGB(220, 220, 220), Enum.Font.GothamMedium, 11
         Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
         Btn.MouseButton1Click:Connect(function() pcall(data.Callback) end)
      end

      function TObj:Slider(data)
         local SF = Instance.new("Frame", SC)
         SF.Size, SF.BackgroundColor3 = UDim2.new(1, -6, 0, 44), Color3.fromRGB(20, 20, 20)
         Instance.new("UICorner", SF).CornerRadius = UDim.new(0, 6)

         local L = Instance.new("TextLabel", SF)
         L.Size, L.Position, L.BackgroundTransparency = UDim2.new(1, -12, 0, 18), UDim2.new(0, 8, 0, 3), true
         L.Text, L.TextColor3, L.Font, L.TextSize, L.TextXAlignment = data.Name .. ": " .. data.CurrentValue, Color3.fromRGB(200, 200, 200), Enum.Font.Gotham, 11, Enum.TextXAlignment.Left

         local SB = Instance.new("Frame", SF)
         SB.Size, SB.Position, SB.BackgroundColor3 = UDim2.new(1, -16, 0, 5), UDim2.new(0, 8, 0, 26), Color3.fromRGB(35, 35, 35)
         Instance.new("UICorner", SB).CornerRadius = UDim.new(0, 2)

         local Fill = Instance.new("Frame", SB)
         Fill.Size, Fill.BackgroundColor3 = UDim2.new((data.CurrentValue - data.Range[1]) / (data.Range[2] - data.Range[1]), 0, 1, 0), Color3.fromRGB(50, 120, 255)
         Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 2)

         local draggingSlider = false
         local function upd(i)
            local p = math.clamp((i.Position.X - SB.AbsolutePosition.X) / SB.AbsoluteSize.X, 0, 1)
            local v = math.floor(data.Range[1] + ((data.Range[2] - data.Range[1]) * p))
            Fill.Size = UDim2.new(p, 0, 1, 0)
            L.Text = data.Name .. ": " .. v
            pcall(function() data.Callback(v) end)
         end

         SB.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then draggingSlider = true; upd(i) end
         end)
         UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then draggingSlider = false end
         end)
         UIS.InputChanged:Connect(function(i)
            if draggingSlider and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then upd(i) end
         end)
      end
      return TObj
   end
   return WObj
end

-- Initialization & Script Features
local Win = UI:Init({ Name = "bypass.me | Steal An Egg", KeySystem = true, KeySettings = { Title = "bypass.me | Key System" } })
local T1, T2, T3, T4 = Win:Tab("Auto-Farm"), Win:Tab("OP Exploits"), Win:Tab("Visuals"), Win:Tab("Player")

local Toggles = {AS = false, AC = false, EM = false, KA = false, NC = false, GM = false}

T1:Toggle({Name = "Auto Steal Eggs", CurrentValue = false, Callback = function(v) Toggles.AS = v
   task.spawn(function() while Toggles.AS do task.wait(0.2)
      pcall(function() for _, o in pairs(workspace:GetDescendants()) do if o:IsA("ProximityPrompt") and o.Parent.Name:lower():find("egg") then fireproximityprompt(o) end end end)
   end end)
end})

T1:Toggle({Name = "Auto Collect Coins/Gems", CurrentValue = false, Callback = function(v) Toggles.AC = v
   task.spawn(function() while Toggles.AC do task.wait(0.1)
      pcall(function() local hrp = LP.Character.HumanoidRootPart for _, o in pairs(workspace:GetDescendants()) do if o:IsA("BasePart") and (o.Name:lower():find("coin") or o.Name:lower():find("gem")) then o.CFrame = hrp.CFrame end end end)
   end end)
end})

T1:Button({Name = "Hatch Best Egg (x1)", Callback = function() pcall(function() game:GetService("ReplicatedStorage").Remotes.HatchEgg:InvokeServer("Best", 1) end) end})
T1:Button({Name = "Hatch Best Egg (x5)", Callback = function() pcall(function() game:GetService("ReplicatedStorage").Remotes.HatchEgg:InvokeServer("Best", 5) end) end})

T2:Toggle({Name = "Egg Magnet", CurrentValue = false, Callback = function(v) Toggles.EM = v
   task.spawn(function() while Toggles.EM do task.wait(0.3)
      pcall(function() local hrp = LP.Character.HumanoidRootPart for _, o in pairs(workspace:GetDescendants()) do if o:IsA("BasePart") and o.Name:lower():find("egg") then o.CFrame = hrp.CFrame end end end)
   end end)
end})

T2:Toggle({Name = "Kill Aura", CurrentValue = false, Callback = function(v) Toggles.KA = v
   task.spawn(function() while Toggles.KA do task.wait(0.1)
      pcall(function() local hrp = LP.Character.HumanoidRootPart for _, o in pairs(workspace:GetDescendants()) do if o:IsA("Model") and o:FindFirstChild("Humanoid") and o ~= LP.Character then local r = o:FindFirstChild("HumanoidRootPart") if r and (hrp.Position - r.Position).Magnitude < 35 then game:GetService("ReplicatedStorage").Remotes.Attack:FireServer(o) end end end end)
   end end)
end})

T2:Toggle({Name = "Noclip", CurrentValue = false, Callback = function(v) Toggles.NC = v end})
RS.Stepped:Connect(function() if Toggles.NC and LP.Character then for _, p in pairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end)

T2:Toggle({Name = "God Mode", CurrentValue = false, Callback = function(v) Toggles.GM = v
   task.spawn(function() while Toggles.GM do task.wait(0.1) pcall(function() LP.Character.Humanoid.Health = math.huge end) end end)
end})

T3:Button({Name = "Enable Egg & Guard ESP", Callback = function()
   pcall(function() for _, o in pairs(workspace:GetDescendants()) do if o:IsA("Model") and (o.Name:lower():find("egg") or o.Name:lower():find("guard")) and not o:FindFirstChild("BE") then local hl = Instance.new("Highlight", o) hl.Name = "BE" hl.FillColor = o.Name:lower():find("egg") and Color3.new(0,1,0) or Color3.new(1,0,0) end end end)
end})

local spd = 16 local spdOn = false
T4:Toggle({Name = "Enable Ultra Speed", CurrentValue = false, Callback = function(v) spdOn = v end})
T4:Slider({Name = "WalkSpeed", Range = {16, 300}, CurrentValue = 16, Callback = function(v) spd = v end})
RS.RenderStepped:Connect(function(dt) if spdOn and LP.Character then pcall(function() local hrp = LP.Character.HumanoidRootPart local hum = LP.Character.Humanoid if hrp and hum.MoveDirection.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (spd * dt)) end end) end end)
T4:Slider({Name = "JumpPower", Range = {50, 300}, CurrentValue = 50, Callback = function(v) pcall(function() LP.Character.Humanoid.JumpPower = v end) end})
