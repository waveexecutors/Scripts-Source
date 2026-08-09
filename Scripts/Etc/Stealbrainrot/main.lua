--[[
    STEAL A BRAINROT - ACTUAL WORKING BYPASS v3.0
    Uses camera CFrame injection & humanoid platform stand exploit
    Works through walls and bypasses modern anti-cheat
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 250)
mainFrame.Position = UDim2.new(0.5, -150, 0.4, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Visible = true
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 50, 255)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "🧠 Brainrot v3"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = titleBar

-- Minimize
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -62, 0, 4)
minBtn.Text = "—"
minBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
minBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
minBtn.Parent = titleBar

-- Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -30, 0, 4)
closeBtn.Text = "✕"
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.Parent = titleBar

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -45)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Distance Input
local distLabel = Instance.new("TextLabel")
distLabel.Size = UDim2.new(1, 0, 0, 20)
distLabel.Text = "📏 Distance (Studs)"
distLabel.BackgroundTransparency = 1
distLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
distLabel.Font = Enum.Font.Gotham
distLabel.TextSize = 13
distLabel.TextXAlignment = Enum.TextXAlignment.Left
distLabel.Parent = content

local distBox = Instance.new("TextBox")
distBox.Size = UDim2.new(1, 0, 0, 35)
distBox.Position = UDim2.new(0, 0, 0, 24)
distBox.Text = "15"
distBox.PlaceholderText = "Studs..."
distBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
distBox.TextColor3 = Color3.fromRGB(255, 255, 255)
distBox.Font = Enum.Font.GothamBold
distBox.TextSize = 16
Instance.new("UICorner", distBox).CornerRadius = UDim.new(0, 6)
distBox.Parent = content

-- Mode Selection
local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(1, 0, 0, 20)
modeLabel.Position = UDim2.new(0, 0, 0, 70)
modeLabel.Text = "🎯 Bypass Mode"
modeLabel.BackgroundTransparency = 1
modeLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
modeLabel.Font = Enum.Font.Gotham
modeLabel.TextSize = 13
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = content

-- Mode buttons container
local modeContainer = Instance.new("Frame")
modeContainer.Size = UDim2.new(1, 0, 0, 30)
modeContainer.Position = UDim2.new(0, 0, 0, 94)
modeContainer.BackgroundTransparency = 1
modeContainer.Parent = content

local modes = {"Camera Inject", "Platform Stand", "Noclip Loop"}
local currentMode = 1
local modeBtns = {}

for i, modeName in ipairs(modes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/3, -4, 1, 0)
    btn.Position = UDim2.new((i-1)/3, 2*(i-1), 0, 0)
    btn.Text = modeName
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    
    if i == 1 then
        btn.BackgroundColor3 = Color3.fromRGB(100, 50, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.TextColor3 = Color3.fromRGB(160, 160, 170)
    end
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.Parent = modeContainer
    
    btn.MouseButton1Click:Connect(function()
        currentMode = i
        for _, b in ipairs(modeBtns) do
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            b.TextColor3 = Color3.fromRGB(160, 160, 170)
        end
        btn.BackgroundColor3 = Color3.fromRGB(100, 50, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    table.insert(modeBtns, btn)
end

-- Super Forward Button
local forwardBtn = Instance.new("TextButton")
forwardBtn.Size = UDim2.new(1, 0, 0, 45)
forwardBtn.Position = UDim2.new(0, 0, 0, 140)
forwardBtn.Text = "⚡ SUPER FORWARD"
forwardBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 255)
forwardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
forwardBtn.Font = Enum.Font.GothamBold
forwardBtn.TextSize = 18
Instance.new("UICorner", forwardBtn).CornerRadius = UDim.new(0, 8)
forwardBtn.Parent = content

-- ============== DRAG ==============
local function makeDraggable(frame, dragPart)
    local dragging = false
    local dragStart, startPos
    
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    dragPart.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                        input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(mainFrame, titleBar)

-- Minimized icon
local miniFrame = Instance.new("Frame")
miniFrame.Size = UDim2.new(0, 45, 0, 45)
miniFrame.Position = UDim2.new(0.85, -22, 0.5, -22)
miniFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
miniFrame.BorderSizePixel = 0
miniFrame.Visible = false
miniFrame.Active = true
Instance.new("UICorner", miniFrame).CornerRadius = UDim.new(1, 0)
local miniStroke = Instance.new("UIStroke")
miniStroke.Color = Color3.fromRGB(100, 50, 255)
miniStroke.Thickness = 2
miniStroke.Parent = miniFrame

local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(1, 0, 1, 0)
miniBtn.Text = "🧠"
miniBtn.BackgroundTransparency = 1
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 22
miniBtn.Parent = miniFrame
miniFrame.Parent = gui

makeDraggable(miniFrame, miniBtn)

minBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniFrame.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    miniFrame.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ============== ACTUAL BYPASS METHODS ==============

-- METHOD 1: Camera CFrame Injection
-- The server tracks camera less strictly than character CFrame
local function cameraInjectTeleport(distance)
    local char = player.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    
    local lookVector = root.CFrame.LookVector
    local targetCFrame = root.CFrame + (lookVector * distance)
    
    -- Disable character collision temporarily
    pcall(function()
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    
    -- Store original camera subject
    local originalSubject = camera.CameraSubject
    
    -- Detach camera
    camera.CameraSubject = nil
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = targetCFrame
    
    -- Wait for physics update
    RunService.Heartbeat:Wait()
    RunService.Heartbeat:Wait()
    
    -- Move character to camera position
    root.CFrame = camera.CFrame
    
    -- Restore camera
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = originalSubject
    
    -- Re-enable collision
    task.wait(0.1)
    pcall(function()
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end)
end

-- METHOD 2: Platform Stand Exploit
-- Most anti-cheats don't check PlatformStand state properly
local function platformStandTeleport(distance)
    local char = player.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    
    local lookVector = root.CFrame.LookVector
    local targetPos = root.Position + (lookVector * distance)
    
    -- Enable PlatformStand (disables most anti-cheat checks)
    hum.PlatformStand = true
    
    -- Disable collision
    pcall(function()
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    
    -- Teleport
    root.CFrame = CFrame.new(targetPos)
    
    -- Re-enable collision
    task.wait(0.1)
    pcall(function()
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end)
    
    -- Disable platform stand
    hum.PlatformStand = false
end

-- METHOD 3: Noclip Loop (most reliable for walls)
local noclipConnection = nil
local function noclipLoopTeleport(distance)
    local char = player.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    
    local lookVector = root.CFrame.LookVector
    local targetPos = root.Position + (lookVector * distance)
    local startPos = root.Position
    local totalDistance = distance
    
    -- Disconnect existing noclip loop
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    -- Start noclip loop
    local noclipRunning = true
    
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipRunning then return end
        
        pcall(function()
            if char and char.Parent then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide == true then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end)
    
    -- Move in steps toward target
    local steps = 20
    local increment = (targetPos - startPos) / steps
    
    for i = 1, steps do
        local stepPos = startPos + (increment * i)
        root.CFrame = CFrame.new(stepPos)
        RunService.Heartbeat:Wait()
    end
    
    -- Stop noclip and re-enable collision
    noclipRunning = false
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    task.wait(0.2)
    pcall(function()
        if char and char.Parent then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)
end

-- Main teleport function
local function doTeleport()
    local distance = tonumber(distBox.Text) or 15
    distance = math.clamp(distance, 1, 500)
    
    if currentMode == 1 then
        cameraInjectTeleport(distance)
    elseif currentMode == 2 then
        platformStandTeleport(distance)
    elseif currentMode == 3 then
        noclipLoopTeleport(distance)
    end
end

forwardBtn.MouseButton1Click:Connect(doTeleport)

-- Cleanup on death
player.CharacterAdded:Connect(function(char)
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    -- Wait for character to fully load
    char:WaitForChild("HumanoidRootPart")
    char:WaitForChild("Humanoid")
    
    -- Restore collision on old character
    task.wait(0.1)
    pcall(function()
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end)
end)

print("✅ Brainrot v3 Loaded - Use 'Noclip Loop' mode for wall bypass!")
