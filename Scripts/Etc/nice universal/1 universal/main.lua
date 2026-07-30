-- Modern Universal Hub (Rayfield UI)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Universal Hub | Modern Edition",
   LoadingTitle = "Loading System...",
   LoadingSubtitle = "By Assistant",
   ConfigurationSaving = {
      Enabled = false,
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = true,
   KeySettings = {
      Title = "Key Verification",
      Subtitle = "Enter system key",
      Note = "Key is 300",
      FileName = "HubKey",
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = {"300"}
   }
})

-- Service References
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Global Variables
local SpeedValue = 16
local SpeedEnabled = false
local NoclipEnabled = false
local FOVValue = 70
local FOVEnabled = false
local ESPEnabled = false
local FullbrightEnabled = false
local SelectedPlayerToTP = nil
local LoopTPPlayer = nil
local LoopTPEnabled = false

-- Storage for ESP Highlights
local ESPHighlights = {}

----------------------------------------------------------------
-- TABS
----------------------------------------------------------------
local MainTab = Window:CreateTab("Main", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local PlayerTab = Window:CreateTab("Players", 4483362458)
local GamesTab = Window:CreateTab("Game Utilities", 4483362458)

----------------------------------------------------------------
-- MAIN TAB (Movement & Core Utilities)
----------------------------------------------------------------
MainTab:CreateSection("Movement Controls")

MainTab:CreateToggle({
   Name = "Force Speed",
   CurrentValue = false,
   Callback = function(Value)
      SpeedEnabled = Value
   end,
})

MainTab:CreateSlider({
   Name = "Speed Value",
   Range = {16, 250},
   Increment = 1,
   Suffix = " Studs/s",
   CurrentValue = 16,
   Callback = function(Value)
      SpeedValue = Value
   end,
})

MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value)
      NoclipEnabled = Value
   end,
})

MainTab:CreateSection("Camera & Performance")

MainTab:CreateToggle({
   Name = "Custom FOV",
   CurrentValue = false,
   Callback = function(Value)
      FOVEnabled = Value
      if not Value and workspace.CurrentCamera then
         workspace.CurrentCamera.FieldOfView = 70
      end
   end,
})

MainTab:CreateSlider({
   Name = "FOV Angle",
   Range = {30, 120},
   Increment = 1,
   Suffix = "°",
   CurrentValue = 70,
   Callback = function(Value)
      FOVValue = Value
   end,
})

MainTab:CreateToggle({
   Name = "Unlock 120 FPS Cap",
   CurrentValue = false,
   Callback = function(Value)
      if setfpscap then
         setfpscap(Value and 120 or 60)
      else
         Rayfield:Notify({Title = "Error", Content = "Your executor does not support setfpscap!"})
      end
   end,
})

----------------------------------------------------------------
-- VISUALS TAB (ESP & Lighting)
----------------------------------------------------------------
VisualsTab:CreateSection("ESP & Illumination")

VisualsTab:CreateToggle({
   Name = "Team-Color Player ESP",
   CurrentValue = false,
   Callback = function(Value)
      ESPEnabled = Value
      if not Value then
         for _, highlight in pairs(ESPHighlights) do
            highlight:Destroy()
         end
         table.clear(ESPHighlights)
      end
   end,
})

VisualsTab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Callback = function(Value)
      FullbrightEnabled = Value
      if not Value then
         Lighting.Ambient = Color3.fromRGB(127, 127, 127)
         Lighting.Brightness = 1
      end
   end,
})

----------------------------------------------------------------
-- PLAYERS TAB (Teleportation & Loops)
----------------------------------------------------------------
PlayerTab:CreateSection("Target Selection")

-- Function to generate player list string array
local function GetPlayerOptions()
   local options = {}
   for _, player in pairs(Players:GetPlayers()) do
      if player ~= LocalPlayer then
         table.insert(options, player.DisplayName .. " (@" .. player.Name .. ")")
      end
   end
   return options
end

local PlayerDropdown = PlayerTab:CreateDropdown({
   Name = "Select Target Player",
   Options = GetPlayerOptions(),
   CurrentOption = "",
   Callback = function(Option)
      local username = string.match(Option[1] or "", "@(%w+)")
      if username then
         SelectedPlayerToTP = Players:FindFirstChild(username)
      end
   end,
})

PlayerTab:CreateButton({
   Name = "Teleport to Selected Player",
   Callback = function()
      if SelectedPlayerToTP and SelectedPlayerToTP.Character and SelectedPlayerToTP.Character:FindFirstChild("HumanoidRootPart") then
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayerToTP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
         end
      else
         Rayfield:Notify({Title = "Teleport Failed", Content = "Target player or character not found."})
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "Loop Teleport To Target",
   CurrentValue = false,
   Callback = function(Value)
      LoopTPEnabled = Value
      if Value then
         LoopTPPlayer = SelectedPlayerToTP
      else
         LoopTPPlayer = nil
      end
   end,
})

-- Refresh Dropdown automatically when players join/leave
Players.PlayerAdded:Connect(function()
   PlayerDropdown:Refresh(GetPlayerOptions())
end)
Players.PlayerRemoving:Connect(function()
   PlayerDropdown:Refresh(GetPlayerOptions())
end)

----------------------------------------------------------------
-- GAME UTILITIES TAB (Piggy, Banana Eats, Survive the Killer)
----------------------------------------------------------------
GamesTab:CreateSection("Special Game Utilities")

GamesTab:CreateButton({
   Name = "Highlight Killer / Monster (All 3 Games)",
   Callback = function()
      local count = 0
      for _, v in pairs(workspace:GetDescendants()) do
         -- Search for common killer names or traits
         if v:IsA("Model") and (v.Name:lower():find("piggy") or v.Name:lower():find("banana") or v.Name:lower():find("killer")) then
            if not v:FindFirstChild("KillerHighlight") then
               local hl = Instance.new("Highlight")
               hl.Name = "KillerHighlight"
               hl.FillColor = Color3.fromRGB(255, 0, 0)
               hl.OutlineColor = Color3.fromRGB(255, 255, 255)
               hl.Parent = v
               count = count + 1
            end
         end
      end
      Rayfield:Notify({Title = "Game Utility", Content = "Highlighted " .. tostring(count) .. " monsters/killers."})
   end,
})

GamesTab:CreateButton({
   Name = "Highlight Keys / Items / Escape Doors",
   Callback = function()
      local count = 0
      for _, v in pairs(workspace:GetDescendants()) do
         if v:IsA("BasePart") or v:IsA("Model") then
            local lowerName = v.Name:lower()
            if lowerName:find("key") or lowerName:find("door") or lowerName:find("code") or lowerName:find("banana") or lowerName:find("exit") then
               if not v:FindFirstChild("ItemHighlight") then
                  local hl = Instance.new("Highlight")
                  hl.Name = "ItemHighlight"
                  hl.FillColor = Color3.fromRGB(0, 255, 127)
                  hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                  hl.Parent = v
                  count = count + 1
               end
            end
         end
      end
      Rayfield:Notify({Title = "Game Utility", Content = "Highlighted " .. tostring(count) .. " key items."})
   end,
})

----------------------------------------------------------------
-- MAIN EXECUTION LOOPS
----------------------------------------------------------------
RunService.Stepped:Connect(function()
   -- Speed Force
   if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
   end

   -- Noclip Logic
   if NoclipEnabled and LocalPlayer.Character then
      for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
         if part:IsA("BasePart") then
            part.CanCollide = false
         end
      end
   end

   -- Loop Teleport Logic
   if LoopTPEnabled and LoopTPPlayer and LoopTPPlayer.Character and LoopTPPlayer.Character:FindFirstChild("HumanoidRootPart") then
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = LoopTPPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
      end
   end
end)

RunService.RenderStepped:Connect(function()
   -- Custom FOV
   if FOVEnabled and workspace.CurrentCamera then
      workspace.CurrentCamera.FieldOfView = FOVValue
   end

   -- Fullbright Logic
   if FullbrightEnabled then
      Lighting.Ambient = Color3.fromRGB(255, 255, 255)
      Lighting.Brightness = 2
   end

   -- ESP Logic
   if ESPEnabled then
      for _, player in pairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and player.Character then
            local highlight = ESPHighlights[player]
            if not highlight or not highlight.Parent then
               highlight = Instance.new("Highlight")
               highlight.Name = "PlayerESP"
               highlight.Parent = player.Character
               ESPHighlights[player] = highlight
            end

            -- Match team color if available
            if player.Team then
               highlight.FillColor = player.TeamColor.Color
            else
               highlight.FillColor = Color3.fromRGB(0, 170, 255)
            end
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
         end
      end
   end
end)
