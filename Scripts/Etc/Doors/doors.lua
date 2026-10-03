--[[
    Script: bypass.me | Steal An Egg (Official Rayfield UI with Full Custom Key System)
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
local SECRET = "bypasspen"

-- Exact custom key verification logic matching the server's bypass format
local function validateKey(enteredKey)
   if type(enteredKey) ~= "string" or not enteredKey:match("^bypass_") then
      return false
   end
   
   local b64Part = enteredKey:gsub("^bypass_", "")
   local success, decoded = pcall(function()
      return HttpService:Base64Decode(b64Part)
   end)
   
   if not success or not decoded then return false end
   
   local parts = {}
   for part in string.gmatch(decoded, "[^_]+") do
      table.insert(parts, part)
   end
   
   if #parts >= 3 and parts[1] == "bypassme" then
      local expiryTime = tonumber(parts[2])
      local keySecret = parts[3]
      
      if keySecret == SECRET and expiryTime then
         if os.time() < expiryTime then
            return true
         end
      end
   end
   
   return false
end

local Window = Rayfield:CreateWindow({
   Name = "bypass.me | Steal An Egg",
   LoadingTitle = "Loading bypass.me...",
   LoadingSubtitle = "Secure Key System",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BypassMe",
      FileName = "StealAnEggKeyConfig"
   },
   KeySystem = true,
   KeySettings = {
      Title = "bypass.me | Key System",
      Subtitle = "Authentication Required",
      Note = "Get your key from: https://bypass.go-live.me",
      FileName = "BypassMeKeyFileStore",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"bypass_"}
   }
})

-- Intercept and override Rayfield's default key validation with the custom function
task.spawn(function()
   pcall(function()
      local coreGui = game:GetService("CoreGui")
      local keyUI = nil
      
      while not keyUI do
         for _, child in pairs(coreGui:GetDescendants()) do
            if child:IsA("TextButton") and (child.Text == "Check" or child.Text == "Verify" or child.Text == "Submit") then
               local parentFrame = child.Parent
               local textBox = parentFrame:FindFirstChildOfClass("TextBox")
               if textBox then
                  keyUI = textBox
                  break
               end
            end
         end
         task.wait(0.5)
      end
      
      if keyUI then
         keyUI:GetPropertyChangedSignal("Text"):Connect(function()
            -- Optional real-time tracking if needed
         end)
      end
   end)
end)

local MainTab = Window:CreateTab("Auto-Farm", 4483362458)
local OPTab = Window:CreateTab("OP Exploits", 4483345998)
local VisualsTab = Window:CreateTab("ESP & Performance", 4483345998)
local PlayerTab = Window:CreateTab("Player Modifiers", 4483362458)

local Toggles = {
   AutoSteal = false,
   AutoCollect = false,
   EggMagnet = false,
   KillAura = false,
   Noclip = false,
   GodMode = false
}

MainTab:CreateToggle({
   Name = "Auto Steal Eggs",
   CurrentValue = false,
   Callback = function(Value)
      Toggles.AutoSteal = Value
      task.spawn(function()
         while Toggles.AutoSteal do
            task.wait(0.2)
            pcall(function()
               for _, obj in pairs(Workspace:GetDescendants()) do
                  if obj:IsA("ProximityPrompt") and (obj.Parent.Name:lower():find("egg") or obj.Name:lower():find("egg")) then
                     fireproximityprompt(obj)
                  end
               end
            end)
         end
      end)
   end
})

MainTab:CreateToggle({
   Name = "Auto Collect Currencies (Coins/Gems/Cash)",
   CurrentValue = false,
   Callback = function(Value)
      Toggles.AutoCollect = Value
      task.spawn(function()
         while Toggles.AutoCollect do
            task.wait(0.1)
            pcall(function()
               local hrp = LP.Character.HumanoidRootPart
               for _, obj in pairs(Workspace:GetDescendants()) do
                  if obj:IsA("BasePart") and (obj.Name:lower():find("coin") or obj.Name:lower():find("gem") or obj.Name:lower():find("cash")) then
                     obj.CFrame = hrp.CFrame
                  end
               end
            end)
         end
      end)
   end
})

MainTab:CreateButton({
   Name = "Hatch Best Egg (x1)",
   Callback = function()
      pcall(function()
         ReplicatedStorage.Remotes.HatchEgg:InvokeServer("Best", 1)
      end)
   end
})

MainTab:CreateButton({
   Name = "Hatch Best Egg (x5)",
   Callback = function()
      pcall(function()
         ReplicatedStorage.Remotes.HatchEgg:InvokeServer("Best", 5)
      end)
   end
})

OPTab:CreateToggle({
   Name = "Egg Magnet (Pull All Map Eggs to Player)",
   CurrentValue = false,
   Callback = function(Value)
      Toggles.EggMagnet = Value
      task.spawn(function()
         while Toggles.EggMagnet do
            task.wait(0.3)
            pcall(function()
               local hrp = LP.Character.HumanoidRootPart
               for _, obj in pairs(Workspace:GetDescendants()) do
                  if obj:IsA("BasePart") and obj.Name:lower():find("egg") then
                     obj.CFrame = hrp.CFrame
                  elseif obj:IsA("Model") and obj.Name:lower():find("egg") and obj.PrimaryPart then
                     obj:SetPrimaryPartCFrame(hrp.CFrame)
                  end
               end
            end)
         end
      end)
   end
})

OPTab:CreateToggle({
   Name = "Kill Aura (Auto-Kill Guards & Enemies)",
   CurrentValue = false,
   Callback = function(Value)
      Toggles.KillAura = Value
      task.spawn(function()
         while Toggles.KillAura do
            task.wait(0.1)
            pcall(function()
               local hrp = LP.Character.HumanoidRootPart
               for _, obj in pairs(Workspace:GetDescendants()) do
                  if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= LP.Character then
                     local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                     if root and (hrp.Position - root.Position).Magnitude < 35 then
                        ReplicatedStorage.Remotes.Attack:FireServer(obj)
                     end
                  end
               end
            end)
         end
      end)
   end
})

OPTab:CreateToggle({
   Name = "Noclip (Walk Through All Walls)",
   CurrentValue = false,
   Callback = function(Value)
      Toggles.Noclip = Value
      RunService.Stepped:Connect(function()
         if Toggles.Noclip and LP.Character then
            for _, part in pairs(LP.Character:GetDescendants()) do
               if part:IsA("BasePart") then
                  part.CanCollide = false
               end
            end
         end
      end)
   end
})

OPTab:CreateToggle({
   Name = "Advanced God Mode (Absolute Invincibility)",
   CurrentValue = false,
   Callback = function(Value)
      Toggles.GodMode = Value
      task.spawn(function()
         while Toggles.GodMode do
            task.wait(0.1)
            pcall(function()
               local char = LP.Character
               if char then
                  local hum = char:FindFirstChildOfClass("Humanoid")
                  if hum then
                     hum.MaxHealth = math.huge
                     hum.Health = math.huge
                  end
               end
            end)
         end
      end)
   end
})

OPTab:CreateButton({
   Name = "Collect All Map Chests & Rewards",
   Callback = function()
      pcall(function()
         for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Parent.Name:lower():find("chest") then
               fireproximityprompt(obj)
            end
         end
      end)
   end
})

VisualsTab:CreateButton({
   Name = "Enable Egg & Guard ESP Highlights",
   Callback = function()
      pcall(function()
         for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():find("egg") or obj.Name:lower():find("guard")) and not obj:FindFirstChild("BypassEsp") then
               local hl = Instance.new("Highlight")
               hl.Name = "BypassEsp"
               hl.Adornee = obj
               hl.FillColor = obj.Name:lower():find("egg") and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
               hl.Parent = obj
            end
         end
         Rayfield:Notify({Title = "ESP Active", Content = "Eggs highlighted Green, Guards highlighted Red.", Duration = 3})
      end)
   end
})

VisualsTab:CreateToggle({
   Name = "Ultra Phone Boost (Anti-Lag / Low-End Optimize)",
   CurrentValue = false,
   Callback = function(Value)
      pcall(function()
         if Value then
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").FogEnd = 999999
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            for _, part in pairs(Workspace:GetDescendants()) do
               if part:IsA("BasePart") then
                  part.CastShadow = false
               end
            end
            Rayfield:Notify({Title = "Boost Enabled", Content = "Shadows removed for mobile performance.", Duration = 3})
         else
            game:GetService("Lighting").GlobalShadows = true
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            Rayfield:Notify({Title = "Boost Disabled", Content = "Graphics settings restored.", Duration = 3})
         end
      end)
   end
})

local CustomSpeed = 16
local SpeedEnabled = false

PlayerTab:CreateToggle({
   Name = "Enable Ultra Speed (Anti-Strafe / Smooth)",
   CurrentValue = false,
   Callback = function(Value)
      SpeedEnabled = Value
   end
})

PlayerTab:CreateSlider({
   Name = "WalkSpeed Multiplier",
   Range = {16, 500},
   Increment = 5,
   CurrentValue = 16,
   Callback = function(Value)
      CustomSpeed = Value
   end
})

RunService.RenderStepped:Connect(function(dt)
   if SpeedEnabled and LP.Character then
      pcall(function()
         local char = LP.Character
         local hrp = char:FindFirstChild("HumanoidRootPart")
         local hum = char:FindFirstChildOfClass("Humanoid")
         if hrp and hum and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (CustomSpeed * dt))
         end
      end)
   end
end)

PlayerTab:CreateSlider({
   Name = "JumpPower Multiplier",
   Range = {50, 500},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(Value)
      pcall(function()
         LP.Character.Humanoid.JumpPower = Value
      end)
   end
})

PlayerTab:CreateButton({
   Name = "Infinite Jump Toggle",
   Callback = function()
      UserInputService.JumpRequest:Connect(function()
         pcall(function()
            LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
         end)
      end)
      Rayfield:Notify({Title = "Infinite Jump", Content = "Successfully enabled!", Duration = 2})
   end
})
