-- Bellingham FE Script
-- Made by LocalxError & _4bits_
-- Delta Executor Mobile Optimized

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Speed variables
local originalSpeed = {
    Pace = humanoid.WalkSpeed,
    Acceleration = humanoid.Acceleration,
    Speed = humanoid.WalkSpeed
}

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BellinghamGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame (Draggable, Minizable, Closable)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 250)
mainFrame.Position = UDim2.new(0.5, -90, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Modern Gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 30))
})
gradient.Parent = mainFrame

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚽ Bellingham FE"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Minimize Button
local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 25, 0, 25)
minButton.Position = UDim2.new(1, -55, 0, 2.5)
minButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minButton.BackgroundTransparency = 0.5
minButton.BorderSizePixel = 0
minButton.Text = "─"
minButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minButton.TextSize = 18
minButton.Font = Enum.Font.GothamBold
minButton.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minButton

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -28, 0, 2.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BackgroundTransparency = 0.3
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Scrollable UI
local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0, 8)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.VerticalAlignment = Enum.VerticalAlignment.Top
uiList.Parent = contentFrame

-- Button Creation Function
local function createButton(text, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 35)
    btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 80)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = contentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Toggle Creation Function
local function createToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 150, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Parent = contentFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 35, 0, 25)
    toggleBtn.Position = UDim2.new(0.75, 0, 0.15, 0)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(80, 80, 80)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleBtn
    
    local state = default
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(80, 80, 80)
        callback(state)
    end)
    
    return toggleBtn
end

-- Minimize Logic
local minimized = false
local originalSize = mainFrame.Size
local originalPos = mainFrame.Position

minButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 180, 0, 35)
        contentFrame.Visible = false
        minButton.Text = "□"
    else
        mainFrame.Size = originalSize
        contentFrame.Visible = true
        minButton.Text = "─"
    end
end)

-- Close Logic
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Drift Function
local function performDrift()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    
    -- Play animations
    local anim1 = Instance.new("Animation")
    anim1.AnimationId = "rbxassetid://125749145"
    local anim2 = Instance.new("Animation")
    anim2.AnimationId = "rbxassetid://125750702"
    
    local track1 = hum:LoadAnimation(anim1)
    local track2 = hum:LoadAnimation(anim2)
    track1:Play()
    track2:Play()
    
    -- Drift effect
    local originalSpeed = hum.WalkSpeed
    hum.WalkSpeed = 100
    
    -- Fling detection
    local connection
    connection = game:GetService("RunService").Stepped:Connect(function()
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Parent and part.Parent:FindFirstChild("Humanoid") and part.Parent ~= char then
                if (root.Position - part.Position).Magnitude < 8 then
                    local otherRoot = part.Parent:FindFirstChild("HumanoidRootPart")
                    if otherRoot then
                        local velocity = Instance.new("BodyVelocity")
                        velocity.Velocity = (otherRoot.Position - root.Position).Unit * 100
                        velocity.MaxForce = Vector3.new(10000, 10000, 10000)
                        velocity.Parent = otherRoot
                        game:GetService("Debris"):AddItem(velocity, 0.5)
                    end
                end
            end
        end
    end)
    
    wait(2)
    track1:Stop()
    track2:Stop()
    hum.WalkSpeed = originalSpeed
    connection:Disconnect()
end

-- Celebration Function
local function performCelebration(danceType)
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    
    local anims = {}
    if danceType == 1 then
        anims = {"182435998", "182393478"}
    else
        anims = {"182491037", "45828430"}
    end
    
    for _, id in pairs(anims) do
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. id
        local track = hum:LoadAnimation(anim)
        track:Play()
        wait(0.1)
    end
end

-- Speed Toggle
local speedEnabled = false

-- Create GUI Buttons
createButton("⚡ Drift", performDrift, Color3.fromRGB(200, 150, 50))
createButton("🎉 Dance 1", function() performCelebration(1) end, Color3.fromRGB(50, 150, 200))
createButton("🎉 Dance 2", function() performCelebration(2) end, Color3.fromRGB(200, 50, 150))
createButton("🔄 Replay Intro", function()
    -- Replay intro logic will be handled by the intro system
    if introVideo then
        introVideo:Destroy()
    end
    playIntro()
end, Color3.fromRGB(100, 200, 50))

-- Speed Toggle
createToggle("⚡ Speed Boost", false, function(state)
    speedEnabled = state
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    if state then
        hum.WalkSpeed = 80
        hum.Acceleration = 81
    else
        hum.WalkSpeed = originalSpeed.Speed
        hum.Acceleration = originalSpeed.Acceleration
    end
end)

-- Intro System
local introVideo = nil

function playIntro()
    -- Download and play intro
    local url = "https://github.com/waveexecutors/Scripts-Source/raw/refs/heads/main/Scripts/Bellingham%20FE%20SCRIPT/lv_0_20260723141904.webm"
    
    -- Create fullscreen video player
    local videoFrame = Instance.new("Frame")
    videoFrame.Size = UDim2.new(1, 0, 1, 0)
    videoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    videoFrame.ZIndex = 999
    videoFrame.Parent = player:WaitForChild("PlayerGui")
    
    -- Create VideoPlayer
    local videoPlayer = Instance.new("VideoPlayer")
    videoPlayer.Size = UDim2.new(1, 0, 1, 0)
    videoPlayer.Parent = videoFrame
    
    -- Attempt to play video
    local success, err = pcall(function()
        videoPlayer:Play(url)
    end)
    
    if not success then
        videoFrame:Destroy()
        return
    end
    
    -- Wait for video to finish or timeout
    task.wait(5) -- Assuming video duration
    
    -- Fade out effect
    local fade = Instance.new("Frame")
    fade.Size = UDim2.new(1, 0, 1, 0)
    fade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    fade.BackgroundTransparency = 1
    fade.ZIndex = 1000
    fade.Parent = videoFrame
    
    for i = 1, 30 do
        fade.BackgroundTransparency = 1 - (i / 30)
        task.wait(0.05)
    end
    
    videoFrame:Destroy()
end

-- Auto play intro on startup
task.wait(1)
playIntro()

-- Character respawn handling
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    if speedEnabled then
        humanoid.WalkSpeed = 80
        humanoid.Acceleration = 81
    end
end)

print("⚽ Bellingham FE Script Loaded!")
print("Made by LocalxError & _4bits_")
