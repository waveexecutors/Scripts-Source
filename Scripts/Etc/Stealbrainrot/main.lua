--[[
    BRAINROT ULTRA-STEALTH – Delta Executor (Mobile)
    UNDETECTABILITY LAYERS:
    1. Multi-step CFrame (50 tiny steps)
    2. Randomized step timing (makes pattern harder to detect)
    3. Velocity spoofing (fake momentum before/after)
    4. Noclip during dash (walls become irrelevant)
    5. Anti-rubberband: fake position updates
    6. Humanoid state spoofing (Walking/Jumping to hide teleport)
    7. Randomized step distances (not always equal)
    8. Noise injection: add tiny random offsets
    9. Network jitter simulation
    10. Position interpolation spoof
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ===== FAKE POSITION SPOOFING =====
-- Hook the Position property to return fake values when checked
local positionMetatable = getrawmetatable(RootPart)
local oldIndex = positionMetatable.__index
local oldNewIndex = positionMetatable.__newindex
local fakePosition = nil

positionMetatable.__index = function(self, key)
    if key == "Position" and fakePosition then
        return fakePosition
    end
    return oldIndex(self, key)
end

positionMetatable.__newindex = function(self, key, value)
    if key == "Position" then
        -- Let it update normally but also store fake
        oldNewIndex(self, key, value)
        if not fakePosition then
            fakePosition = value
        end
        return
    end
    oldNewIndex(self, key, value)
end

-- ===== NETWORK JITTER SIMULATOR =====
local function jitter()
    return (math.random() - 0.5) * 0.02
end

-- ===== MAIN TELEPORT FUNCTION =====
local function ultraStealthTeleport(dist)
    if not Character or not RootPart then return end
    if dist <= 0 then dist = 10 end
    
    -- Prevent multiple teleports at once
    if RootPart:GetAttribute("Teleporting") then return end
    RootPart:SetAttribute("Teleporting", true)
    
    -- ===== LAYER 1: Save original state =====
    local startCF = RootPart.CFrame
    local look = startCF.LookVector
    
    -- ===== LAYER 2: Noclip =====
    local parts = Character:GetDescendants()
    local collides = {}
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") then
            collides[part] = part.CanCollide
            part.CanCollide = false
        end
    end
    
    -- ===== LAYER 3: Spoof humanoid state =====
    local oldState = Humanoid:GetState()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
    Humanoid.PlatformStand = true
    
    -- ===== LAYER 4: Randomize step parameters =====
    local steps = math.random(40, 60)  -- Random steps between 40-60
    local baseDelay = 0.006
    local totalSteps = steps
    
    -- ===== LAYER 5: Execute micro-teleports =====
    for i = 1, steps do
        -- Randomize each step's distance (adds noise)
        local progress = i / steps
        local stepProgress = progress + (math.random() - 0.5) * 0.03  -- Add noise
        stepProgress = math.clamp(stepProgress, 0, 1)
        
        -- Calculate position with slight randomness
        local stepDist = dist * stepProgress
        local newPos = startCF.Position + look * stepDist
        
        -- Add tiny random offsets to look natural
        local noise = Vector3.new(
            (math.random() - 0.5) * 0.05,
            (math.random() - 0.5) * 0.02,
            (math.random() - 0.5) * 0.05
        )
        newPos = newPos + noise
        
        -- ===== LAYER 6: Fake Position update =====
        fakePosition = newPos
        
        -- ===== LAYER 7: Teleport with rotation =====
        local newCF = CFrame.new(newPos) * (startCF - startCF.Position)
        RootPart.CFrame = newCF
        
        -- ===== LAYER 8: Velocity reset with randomness =====
        RootPart.Velocity = Vector3.new(
            (math.random() - 0.5) * 0.1,
            (math.random() - 0.5) * 0.05,
            (math.random() - 0.5) * 0.1
        )
        RootPart.RotVelocity = Vector3.new(0, 0, 0)
        
        -- ===== LAYER 9: Random delay (prevents pattern detection) =====
        local delay = baseDelay + jitter() + (math.random() - 0.5) * 0.002
        task.wait(delay)
        
        -- ===== LAYER 10: Spoof walking state mid-teleport =====
        if i % 5 == 0 then
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Walking, true)
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Walking, false)
        end
    end
    
    -- ===== FINAL: Exact positioning =====
    local finalPos = startCF.Position + look * dist
    fakePosition = finalPos
    local finalCF = CFrame.new(finalPos) * (startCF - startCF.Position)
    RootPart.CFrame = finalCF
    
    -- ===== LAYER 11: Fake momentum after teleport =====
    RootPart.Velocity = look * 5 + Vector3.new(
        (math.random() - 0.5) * 0.5,
        0,
        (math.random() - 0.5) * 0.5
    )
    RootPart.RotVelocity = Vector3.new(
        (math.random() - 0.5) * 0.1,
        (math.random() - 0.5) * 0.1,
        (math.random() - 0.5) * 0.1
    )
    
    -- ===== Restore everything =====
    task.wait(0.02)
    
    -- Restore humanoid
    Humanoid.PlatformStand = false
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Walking, true)
    
    -- Restore collisions
    for part, state in pairs(collides) do
        if part:IsA("BasePart") and part.Parent then
            part.CanCollide = state
        end
    end
    
    -- ===== LAYER 12: Delayed fake position cleanup =====
    task.wait(0.1)
    fakePosition = nil
    
    RootPart:SetAttribute("Teleporting", false)
end

-- === GUI CREATION ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 200)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Position = UDim2.new(0, 8, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🧠 Brainrot"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.Parent = TitleBar

-- Minimize
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 1, 0)
MinBtn.Position = UDim2.new(1, -60, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.AutoButtonColor = false
MinBtn.Parent = TitleBar
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

-- Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TitleBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -32)
Content.Position = UDim2.new(0, 0, 0, 32)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Teleport label
local TeleLabel = Instance.new("TextLabel")
TeleLabel.Size = UDim2.new(1, 0, 0, 22)
TeleLabel.Position = UDim2.new(0, 0, 0, 12)
TeleLabel.BackgroundTransparency = 1
TeleLabel.Text = "Teleport Distance"
TeleLabel.TextColor3 = Color3.new(1, 1, 1)
TeleLabel.TextSize = 14
TeleLabel.Font = Enum.Font.Gotham
TeleLabel.TextXAlignment = Enum.TextXAlignment.Center
TeleLabel.Parent = Content

-- Distance input
local DistanceBox = Instance.new("TextBox")
DistanceBox.Size = UDim2.new(0.6, 0, 0, 30)
DistanceBox.Position = UDim2.new(0.2, 0, 0, 38)
DistanceBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
DistanceBox.TextColor3 = Color3.new(1, 1, 1)
DistanceBox.Text = "500"
DistanceBox.TextSize = 14
DistanceBox.Font = Enum.Font.Gotham
DistanceBox.ClearTextOnFocus = false
DistanceBox.TextXAlignment = Enum.TextXAlignment.Center
DistanceBox.Parent = Content
local DistCorner = Instance.new("UICorner")
DistCorner.CornerRadius = UDim.new(0, 4)
DistCorner.Parent = DistanceBox

-- Teleport button
local TeleBtn = Instance.new("TextButton")
TeleBtn.Size = UDim2.new(0, 140, 0, 36)
TeleBtn.Position = UDim2.new(0.5, -70, 0, 82)
TeleBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 60)
TeleBtn.Text = "🚀 Stealth Teleport"
TeleBtn.TextColor3 = Color3.new(1, 1, 1)
TeleBtn.TextSize = 14
TeleBtn.Font = Enum.Font.GothamBold
TeleBtn.Parent = Content
local TeleCorner = Instance.new("UICorner")
TeleCorner.CornerRadius = UDim.new(0, 6)
TeleCorner.Parent = TeleBtn

-- === FIXED DRAGGING ===
local dragData = {
    dragging = false,
    startPos = Vector2.new(),
    startMouse = Vector2.new(),
    frame = MainFrame
}

local function updateDrag(input)
    if not dragData.dragging then return end
    local delta = input.Position - dragData.startMouse
    local newPos = UDim2.new(0, dragData.startPos.X + delta.X, 0, dragData.startPos.Y + delta.Y)
    dragData.frame.Position = newPos
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragData.dragging = true
        dragData.startMouse = input.Position
        local absPos = MainFrame.AbsolutePosition
        dragData.startPos = Vector2.new(absPos.X, absPos.Y)
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragData.dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

UserInputService.TouchMoved:Connect(function(touch, processed)
    if processed then return end
    if dragData.dragging then
        updateDrag(touch)
    end
end)

-- === MINIMIZE / CLOSE ===
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 260, 0, 32)
        Content.Visible = false
        MinBtn.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 260, 0, 200)
        Content.Visible = true
        MinBtn.Text = "—"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- === CONNECT TELEPORT BUTTON ===
TeleBtn.MouseButton1Click:Connect(function()
    local dist = tonumber(DistanceBox.Text) or 500
    ultraStealthTeleport(dist)
end)

-- === CHARACTER RESET ===
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

-- === NETWORK SPOOF (extra layer) ===
-- Hook any remote events that might detect teleport
for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        local oldFire = obj.FireServer
        if oldFire then
            obj.FireServer = function(self, ...)
                -- Delay or block suspicious teleport checks
                if tostring(self.Name):lower():match("teleport") or 
                   tostring(self.Name):lower():match("move") or
                   tostring(self.Name):lower():match("position") then
                    return
                end
                return oldFire(self, ...)
            end
        end
    end
end

print("🧠 Brainrot ULTRA-STEALTH loaded!")
print("✅ 12-layer bypass active")
print("✅ Noclip enabled during teleport")
print("✅ Position spoofing active")
print("✅ Network jitter simulation active")
