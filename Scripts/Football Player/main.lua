-- [[ Football Animations Reanim Script ]]
-- Made for Roblox Executors (FE Compatible)
-- Features: Draggable GUI, Toggleable Animations, Wall Speed Boost

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

-- Store original animations
local originalAnims = {}
local isReanimEnabled = false
local currentSpeed = 35
local originalWalkSpeed = humanoid.WalkSpeed

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FootballReanimGUI"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false

-- Main Frame (Draggable)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 200, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Corner rounding
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
titleBar.BackgroundTransparency = 0.3
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚽ Football Reanim"
titleLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -65, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 20
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Content Frame (for scrolling if needed)
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -10, 1, -45)
contentFrame.Position = UDim2.new(0, 5, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 350)
contentFrame.ScrollBarThickness = 4
contentFrame.Parent = mainFrame

-- Toggle Reanim Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 45)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 50)
toggleBtn.Text = "⚡ Enable Football Reanim"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 16
toggleBtn.Font = Enum.Font.GothamSemibold
toggleBtn.Parent = contentFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 25)
statusLabel.Position = UDim2.new(0.05, 0, 0, 50)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Disabled"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = contentFrame

-- Speed Slider Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 25)
speedLabel.Position = UDim2.new(0.05, 0, 0, 80)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Wall Speed: 35"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Center
speedLabel.Parent = contentFrame

-- Speed Slider
local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(0.8, 0, 0, 30)
speedSlider.Position = UDim2.new(0.1, 0, 0, 110)
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
speedSlider.BackgroundTransparency = 0.5
speedSlider.Parent = contentFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 8)
sliderCorner.Parent = speedSlider

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
sliderFill.Parent = speedSlider

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 8)
fillCorner.Parent = sliderFill

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 20, 0, 30)
sliderButton.Position = UDim2.new(0.5, -10, 0, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
sliderButton.Text = ""
sliderButton.Parent = speedSlider

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = sliderButton

-- Action Buttons Frame
local actionFrame = Instance.new("Frame")
actionFrame.Size = UDim2.new(0.9, 0, 0, 150)
actionFrame.Position = UDim2.new(0.05, 0, 0, 150)
actionFrame.BackgroundTransparency = 1
actionFrame.Parent = contentFrame

-- Create action buttons
local actions = {
    {"Slide Tackle", Color3.fromRGB(200, 50, 50)},
    {"Sprint", Color3.fromRGB(50, 150, 50)},
    {"Power Kick", Color3.fromRGB(200, 150, 50)},
    {"Header", Color3.fromRGB(50, 100, 200)},
    {"Goal Celebration", Color3.fromRGB(200, 50, 200)}
}

local actionButtons = {}
for i, action in ipairs(actions) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.45, 0, 0, 35)
    btn.Position = UDim2.new((i-1) % 2 == 0 and 0 or 0.55, 0, math.floor((i-1)/2) * 40, 0)
    btn.BackgroundColor3 = action[2]
    btn.Text = action[1]
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = actionFrame
    
    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.CornerRadius = UDim.new(0, 6)
    btnCorner2.Parent = btn
    
    actionButtons[action[1]] = btn
end

-- Animation Functions
local function playFootballSlide()
    if not isReanimEnabled then return end
    
    local lungeAnim = Instance.new("Animation")
    lungeAnim.AnimationId = "rbxassetid://129967478"
    local fallAnim = Instance.new("Animation")
    fallAnim.AnimationId = "rbxassetid://180436148"
    
    local lungeTrack = animator:LoadAnimation(lungeAnim)
    local fallTrack = animator:LoadAnimation(fallAnim)
    
    lungeTrack.Priority = Enum.AnimationPriority.Action
    fallTrack.Priority = Enum.AnimationPriority.Action2
    
    lungeTrack:Play(0.1, 0.7)
    fallTrack:Play(0.1, 0.5)
    
    -- Stop after 2 seconds
    task.wait(2)
    lungeTrack:Stop()
    fallTrack:Stop()
end

local function playSprint()
    if not isReanimEnabled then return end
    
    local runAnim = Instance.new("Animation")
    runAnim.AnimationId = "rbxassetid://180426354"
    local dashAnim = Instance.new("Animation")
    dashAnim.AnimationId = "rbxassetid://45828430"
    local toolAnim = Instance.new("Animation")
    toolAnim.AnimationId = "rbxassetid://182393478"
    
    local runTrack = animator:LoadAnimation(runAnim)
    local dashTrack = animator:LoadAnimation(dashAnim)
    local toolTrack = animator:LoadAnimation(toolAnim)
    
    runTrack.Priority = Enum.AnimationPriority.Core
    dashTrack.Priority = Enum.AnimationPriority.Action
    toolTrack.Priority = Enum.AnimationPriority.Action2
    
    runTrack:Play(0.1, 0.6)
    dashTrack:Play(0.1, 0.8)
    toolTrack:Play(0.1, 0.4)
    
    -- Stop after 3 seconds
    task.wait(3)
    runTrack:Stop()
    dashTrack:Stop()
    toolTrack:Stop()
end

local function playPowerKick()
    if not isReanimEnabled then return end
    
    local slashAnim = Instance.new("Animation")
    slashAnim.AnimationId = "rbxassetid://129967390"
    local lungeAnim = Instance.new("Animation")
    lungeAnim.AnimationId = "rbxassetid://129967478"
    
    local slashTrack = animator:LoadAnimation(slashAnim)
    local lungeTrack = animator:LoadAnimation(lungeAnim)
    
    slashTrack.Priority = Enum.AnimationPriority.Action
    lungeTrack.Priority = Enum.AnimationPriority.Action2
    
    slashTrack:Play(0.1, 0.9)
    lungeTrack:Play(0.1, 0.6)
    
    task.wait(1.5)
    slashTrack:Stop()
    lungeTrack:Stop()
end

local function playHeader()
    if not isReanimEnabled then return end
    
    local jumpAnim = Instance.new("Animation")
    jumpAnim.AnimationId = "rbxassetid://125750702"
    local swordAnim = Instance.new("Animation")
    swordAnim.AnimationId = "rbxassetid://85723345"
    
    local jumpTrack = animator:LoadAnimation(jumpAnim)
    local swordTrack = animator:LoadAnimation(swordAnim)
    
    jumpTrack.Priority = Enum.AnimationPriority.Core
    swordTrack.Priority = Enum.AnimationPriority.Action
    
    jumpTrack:Play(0.1, 0.8)
    swordTrack:Play(0.1, 0.7)
    
    task.wait(1.5)
    jumpTrack:Stop()
    swordTrack:Stop()
end

local function playCelebration()
    if not isReanimEnabled then return end
    
    local cheerAnim = Instance.new("Animation")
    cheerAnim.AnimationId = "rbxassetid://129423030"
    local waveAnim = Instance.new("Animation")
    waveAnim.AnimationId = "rbxassetid://128777973"
    local danceAnim = Instance.new("Animation")
    danceAnim.AnimationId = "rbxassetid://182435998"
    
    local cheerTrack = animator:LoadAnimation(cheerAnim)
    local waveTrack = animator:LoadAnimation(waveAnim)
    local danceTrack = animator:LoadAnimation(danceAnim)
    
    cheerTrack.Priority = Enum.AnimationPriority.Action
    waveTrack.Priority = Enum.AnimationPriority.Action2
    danceTrack.Priority = Enum.AnimationPriority.Core
    
    cheerTrack:Play(0.1, 0.8)
    waveTrack:Play(0.1, 0.6)
    danceTrack:Play(0.1, 0.5)
    
    task.wait(3)
    cheerTrack:Stop()
    waveTrack:Stop()
    danceTrack:Stop()
end

-- Apply animations based on state
local function applyReanim()
    if isReanimEnabled then
        -- Store original walking speed
        originalWalkSpeed = humanoid.WalkSpeed
        -- Set new speed
        humanoid.WalkSpeed = currentSpeed
        
        -- Apply continuous animations
        local runAnim = Instance.new("Animation")
        runAnim.AnimationId = "rbxassetid://180426354"
        local runTrack = animator:LoadAnimation(runAnim)
        runTrack.Priority = Enum.AnimationPriority.Core
        runTrack:Play(0.1, 0.7)
        originalAnims.runTrack = runTrack
        
        local dashAnim = Instance.new("Animation")
        dashAnim.AnimationId = "rbxassetid://45828430"
        local dashTrack = animator:LoadAnimation(dashAnim)
        dashTrack.Priority = Enum.AnimationPriority.Action
        dashTrack:Play(0.1, 0.5)
        originalAnims.dashTrack = dashTrack
    else
        -- Restore original animations
        for _, track in pairs(originalAnims) do
            if track and track.Stop then
                track:Stop()
            end
        end
        originalAnims = {}
        
        -- Restore original speed
        humanoid.WalkSpeed = originalWalkSpeed
    end
end

-- Toggle function
local function toggleReanim()
    isReanimEnabled = not isReanimEnabled
    applyReanim()
    
    if isReanimEnabled then
        toggleBtn.Text = "⚡ Disable Football Reanim"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "Status: Enabled ⚽"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        toggleBtn.Text = "⚡ Enable Football Reanim"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 50)
        statusLabel.Text = "Status: Disabled"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

-- Update speed label and slider
local function updateSpeed(value)
    currentSpeed = math.floor(16 + (value * 24)) -- Range 16-40
    speedLabel.Text = "Wall Speed: " .. currentSpeed
    sliderFill.Size = UDim2.new(value, 0, 1, 0)
    sliderButton.Position = UDim2.new(value, -10, 0, 0)
    
    if isReanimEnabled then
        humanoid.WalkSpeed = currentSpeed
    end
end

-- Slider dragging
local dragging = false
local function setupSlider()
    speedSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local pos = input.Position.X - speedSlider.AbsolutePosition.X
            local value = math.clamp(pos / speedSlider.AbsoluteSize.X, 0, 1)
            updateSpeed(value)
        end
    end)
    
    speedSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local pos = input.Position.X - speedSlider.AbsolutePosition.X
            local value = math.clamp(pos / speedSlider.AbsoluteSize.X, 0, 1)
            updateSpeed(value)
        end
    end)
end

-- Button connections
toggleBtn.MouseButton1Click:Connect(toggleReanim)

for action, btn in pairs(actionButtons) do
    btn.MouseButton1Click:Connect(function()
        if action == "Slide Tackle" then
            playFootballSlide()
        elseif action == "Sprint" then
            playSprint()
        elseif action == "Power Kick" then
            playPowerKick()
        elseif action == "Header" then
            playHeader()
        elseif action == "Goal Celebration" then
            playCelebration()
        end
    end)
end

-- Minimize/Close buttons
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 300, 0, 40)
        contentFrame.Visible = false
        minimizeBtn.Text = "+"
    else
        mainFrame.Size = UDim2.new(0, 300, 0, 400)
        contentFrame.Visible = true
        minimizeBtn.Text = "−"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Initialize slider
setupSlider()

-- Reset on character respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    animator = humanoid:WaitForChild("Animator")
    originalWalkSpeed = humanoid.WalkSpeed
    
    if isReanimEnabled then
        applyReanim()
    end
end)

-- Mobile friendly adjustments
local function makeMobileFriendly()
    mainFrame.Size = UDim2.new(0, math.min(300, screenGui.AbsoluteSize.X - 20), 0, 400)
    mainFrame.Position = UDim2.new(0.5, -mainFrame.Size.X.Offset/2, 0.5, -200)
    
    for _, btn in pairs(actionButtons) do
        btn.TextSize = 14
        btn.Size = UDim2.new(0.43, 0, 0, 40)
    end
end

-- Check if on mobile
if game:GetService("UserInputService").TouchEnabled then
    makeMobileFriendly()
end

screenGui.ChildAdded:Connect(function(child)
    if child:IsA("Frame") and child.Name == "MainFrame" then
        -- Adjust for mobile when resizing
        if game:GetService("UserInputService").TouchEnabled then
            makeMobileFriendly()
        end
    end
end)

print("⚽ Football Reanim Script Loaded!")
