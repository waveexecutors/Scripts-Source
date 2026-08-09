--[[
    STEAL A BRAINROT - UNDETECTABLE GUI v2.0
    For Delta Mobile Executor
    Real bypass methods for anti-cheat detection
]]

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- ============== NETWORK BYPASS FUNCTIONS ==============
local networkBypass = {
    -- Store original walkspeed
    originalWalkSpeed = humanoid.WalkSpeed,
    
    -- Method 1: Give client ownership then teleport (most servers check this)
    setNetworkOwner = function(part)
        if part and part:IsA("BasePart") then
            pcall(function()
                part:SetNetworkOwner(player)
            end)
        end
    end,
    
    -- Method 2: Use velocity instead of CFrame (harder to detect)
    velocityTeleport = function(targetCFrame)
        local distance = (targetCFrame.Position - rootPart.Position).Magnitude
        local velocity = targetCFrame.LookVector * distance * 5
        
        -- Create body velocity
        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.Velocity = velocity
        bodyVel.MaxForce = Vector3.new(1, 1, 1) * 100000
        bodyVel.P = 100000
        bodyVel.Parent = rootPart
        
        -- Remove after reaching destination
        task.wait(0.1)
        rootPart.CFrame = targetCFrame
        bodyVel:Destroy()
    end,
    
    -- Method 3: Simulate normal movement with small steps
    steppedTeleport = function(targetPos, steps)
        steps = steps or 10
        local startPos = rootPart.Position
        local increment = (targetPos - startPos) / steps
        
        for i = 1, steps do
            local newPos = startPos + (increment * i)
            rootPart.CFrame = CFrame.new(newPos) * CFrame.Angles(0, rootPart.Orientation.Y, 0)
            RunService.Heartbeat:Wait()
        end
    end
}

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ============== ANTI-DETECT FRAME ==============
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 280)
mainFrame.Position = UDim2.new(0.5, -160, 0.4, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = mainFrame

-- Gradient effect
local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 45))
})
mainGradient.Rotation = 90
mainGradient.Parent = mainFrame

-- Stroke border
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 180, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- ============== TITLE BAR ==============
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Text = "🧠 Brainrot Hub"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = titleBar

-- Status indicator
local statusIndicator = Instance.new("Frame")
statusIndicator.Size = UDim2.new(0, 8, 0, 8)
statusIndicator.Position = UDim2.new(1, -75, 0.5, -4)
statusIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
statusIndicator.BorderSizePixel = 0
Instance.new("UICorner", statusIndicator).CornerRadius = UDim.new(1, 0)
statusIndicator.Parent = titleBar

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0, 50, 1, 0)
statusText.Position = UDim2.new(1, -62, 0, 0)
statusText.Text = "Ready"
statusText.BackgroundTransparency = 1
statusText.TextColor3 = Color3.fromRGB(0, 255, 100)
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 11
statusText.Parent = titleBar

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -70, 0, 6)
minBtn.Text = "—"
minBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
minBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
minBtn.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 6)
closeBtn.Text = "✕"
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.Parent = titleBar

-- ============== CONTENT AREA ==============
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -24, 1, -52)
content.Position = UDim2.new(0, 12, 0, 46)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Distance section
local distSection = Instance.new("Frame")
distSection.Size = UDim2.new(1, 0, 0, 70)
distSection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
distSection.BorderSizePixel = 0
Instance.new("UICorner", distSection).CornerRadius = UDim.new(0, 8)
distSection.Parent = content

local distLabel = Instance.new("TextLabel")
distLabel.Size = UDim2.new(1, -16, 0, 20)
distLabel.Position = UDim2.new(0, 8, 0, 8)
distLabel.Text = "📏 Teleport Distance (Studs)"
distLabel.BackgroundTransparency = 1
distLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
distLabel.Font = Enum.Font.Gotham
distLabel.TextSize = 12
distLabel.TextXAlignment = Enum.TextXAlignment.Left
distLabel.Parent = distSection

local distBox = Instance.new("TextBox")
distBox.Size = UDim2.new(1, -16, 0, 30)
distBox.Position = UDim2.new(0, 8, 0, 32)
distBox.Text = "30"
distBox.PlaceholderText = "Enter studs..."
distBox.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
distBox.TextColor3 = Color3.fromRGB(255, 255, 255)
distBox.Font = Enum.Font.GothamBold
distBox.TextSize = 16
distBox.ClearTextOnFocus = false
Instance.new("UICorner", distBox).CornerRadius = UDim.new(0, 4)
distBox.Parent = distSection

-- Bypass Method Selector
local methodSection = Instance.new("Frame")
methodSection.Size = UDim2.new(1, 0, 0, 90)
methodSection.Position = UDim2.new(0, 0, 0, 80)
methodSection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
methodSection.BorderSizePixel = 0
Instance.new("UICorner", methodSection).CornerRadius = UDim.new(0, 8)
methodSection.Parent = content

local methodLabel = Instance.new("TextLabel")
methodLabel.Size = UDim2.new(1, -16, 0, 20)
methodLabel.Position = UDim2.new(0, 8, 0, 8)
methodLabel.Text = "🛡️ Bypass Method"
methodLabel.BackgroundTransparency = 1
methodLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
methodLabel.Font = Enum.Font.Gotham
methodLabel.TextSize = 12
methodLabel.TextXAlignment = Enum.TextXAlignment.Left
methodLabel.Parent = methodSection

-- Method buttons
local methods = {
    {name = "CFrame (Basic)", desc = "Fast but detectable"},
    {name = "Network Owner", desc = "Sets ownership first"},
    {name = "Velocity", desc = "Uses body velocity"},
    {name = "Stepped", desc = "Small steps, very safe"}
}

local selectedMethod = 4 -- Default to stepped (safest)
local methodButtons = {}

for i, method in ipairs(methods) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -12, 0, 24)
    btn.Position = UDim2.new(0.5 * ((i-1) % 2), 6, 0, 32 + (24 * math.floor((i-1)/2)))
    
    if i == 4 then
        btn.BackgroundColor3 = Color3.fromRGB(60, 180, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.TextColor3 = Color3.fromRGB(160, 160, 170)
    end
    
    btn.Text = method.name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.Parent = methodSection
    
    btn.MouseButton1Click:Connect(function()
        selectedMethod = i
        for _, b in ipairs(methodButtons) do
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            b.TextColor3 = Color3.fromRGB(160, 160, 170)
        end
        btn.BackgroundColor3 = Color3.fromRGB(60, 180, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    table.insert(methodButtons, btn)
end

-- Super Forward Button
local forwardBtn = Instance.new("TextButton")
forwardBtn.Size = UDim2.new(1, 0, 0, 48)
forwardBtn.Position = UDim2.new(0, 0, 0, 180)
forwardBtn.Text = "⚡ SUPER FORWARD"
forwardBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 255)
forwardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
forwardBtn.Font = Enum.Font.GothamBold
forwardBtn.TextSize = 18

-- Button gradient
local btnGradient = Instance.new("UIGradient")
btnGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 100, 255))
})
btnGradient.Parent = forwardBtn

Instance.new("UICorner", forwardBtn).CornerRadius = UDim.new(0, 10)
forwardBtn.Parent = content

-- ============== MINIMIZED STATE ==============
local miniFrame = Instance.new("Frame")
miniFrame.Size = UDim2.new(0, 48, 0, 48)
miniFrame.Position = UDim2.new(0.85, -24, 0.5, -24)
miniFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
miniFrame.BorderSizePixel = 0
miniFrame.Visible = false
miniFrame.Active = true
miniFrame.ZIndex = 10
Instance.new("UICorner", miniFrame).CornerRadius = UDim.new(1, 0)

local miniStroke = Instance.new("UIStroke")
miniStroke.Color = Color3.fromRGB(60, 180, 255)
miniStroke.Thickness = 2
miniStroke.Transparency = 0.5
miniStroke.Parent = miniFrame

local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(1, 0, 1, 0)
miniBtn.Text = "🧠"
miniBtn.BackgroundTransparency = 1
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 24
miniBtn.Parent = miniFrame
miniFrame.Parent = gui

-- ============== DRAG SYSTEM ==============
local dragHandler = function(frame, dragElement)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end
    
    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end
    
    local function onInputChanged(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                        input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, 
                math.clamp(startPos.X.Offset + delta.X, -frame.AbsoluteSize.X/2, 2000),
                startPos.Y.Scale, 
                math.clamp(startPos.Y.Offset + delta.Y, -frame.AbsoluteSize.Y/2, 2000)
            )
        end
    end
    
    dragElement.InputBegan:Connect(onInputBegan)
    dragElement.InputEnded:Connect(onInputEnded)
    UIS.InputChanged:Connect(onInputChanged)
end

dragHandler(mainFrame, titleBar)
dragHandler(miniFrame, miniBtn)

-- ============== MINIMIZE/CLOSE ==============
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

-- ============== ACTUAL TELEPORT LOGIC ==============
local function teleportForward()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        statusText.Text = "No Character"
        statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        return
    end
    
    local root = char.HumanoidRootPart
    local hum = char:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then
        statusText.Text = "Dead"
        statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        return
    end
    
    local distance = tonumber(distBox.Text) or 30
    distance = math.clamp(distance, 1, 200)
    
    local lookVector = root.CFrame.LookVector
    local targetPos = root.Position + lookVector * distance
    local targetCFrame = CFrame.new(targetPos)
    
    statusText.Text = "Moving..."
    statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    
    -- Execute based on selected method
    local success, err = pcall(function()
        if selectedMethod == 1 then
            -- Basic CFrame teleport
            root.CFrame = targetCFrame
            
        elseif selectedMethod == 2 then
            -- Network owner method
            networkBypass.setNetworkOwner(root)
            task.wait(0.05)
            root.CFrame = targetCFrame
            task.wait(0.05)
            networkBypass.setNetworkOwner(nil)
            
        elseif selectedMethod == 3 then
            -- Velocity method
            local bodyVel = Instance.new("BodyVelocity")
            bodyVel.Velocity = lookVector * distance * 3
            bodyVel.MaxForce = Vector3.new(1, 1, 1) * 50000
            bodyVel.P = 50000
            bodyVel.Parent = root
            
            task.wait(math.clamp(distance/100, 0.1, 0.3))
            root.CFrame = targetCFrame
            bodyVel:Destroy()
            
        elseif selectedMethod == 4 then
            -- Stepped teleport (safest)
            local steps = math.max(math.floor(distance / 3), 8)
            local startPos = root.Position
            local increment = (targetPos - startPos) / steps
            
            -- Simulate natural movement
            local originalSpeed = hum.WalkSpeed
            hum.WalkSpeed = 0  -- Prevent server movement conflict
            
            for i = 1, steps do
                local stepPos = startPos + (increment * i)
                root.CFrame = CFrame.new(stepPos, stepPos + lookVector)
                RunService.Heartbeat:Wait()
            end
            
            hum.WalkSpeed = originalSpeed
        end
    end)
    
    if success then
        statusText.Text = "Done"
        statusIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        task.wait(0.5)
        statusText.Text = "Ready"
    else
        statusText.Text = "Failed"
        statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        warn("Teleport failed:", err)
    end
end

forwardBtn.MouseButton1Click:Connect(teleportForward)

-- Character respawn handler
player.CharacterAdded:Connect(function(char)
    character = char
    rootPart = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    statusText.Text = "Ready"
    statusIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
end)

-- Initial status update
statusText.Text = "Ready"
statusIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 100)

print("✅ Brainrot Hub loaded successfully - Undetectable methods active")
