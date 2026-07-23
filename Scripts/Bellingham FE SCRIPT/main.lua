-- Bellingham FE Script
-- Made by LocalxError & _4bits_
-- Delta Executor Mobile Optimized

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Speed variables (using correct Humanoid properties)
local originalSpeed = {
    WalkSpeed = humanoid.WalkSpeed,
    JumpPower = humanoid.JumpPower
}

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BellinghamGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Frame (Draggable, Minizable, Closable)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 280)
mainFrame.Position = UDim2.new(0.5, -90, 0.5, -140)
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

-- Shadow effect
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 4, 1, 4)
shadow.Position = UDim2.new(0, -2, 0, -2)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.5
shadow.BorderSizePixel = 0
shadow.ZIndex = -1
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 14)
shadowCorner.Parent = shadow

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
uiList.Padding = UDim.new(0, 6)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.VerticalAlignment = Enum.VerticalAlignment.Top
uiList.Parent = contentFrame

-- Button Creation Function
local function createButton(text, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 32)
    btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 80)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = contentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0.1
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.2
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Toggle Creation Function
local function createToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 150, 0, 32)
    frame.BackgroundTransparency = 1
    frame.Parent = contentFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 35, 0, 22)
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
    
    -- Drift effect (increase speed)
    local oldSpeed = hum.WalkSpeed
    hum.WalkSpeed = 100
    
    -- Fling detection
    local connection
    connection = game:GetService("RunService").Stepped:Connect(function()
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Parent and part.Parent:FindFirstChild("Humanoid") and part.Parent ~= char then
                if (root.Position - part.Position).Magnitude < 8 then
                    local otherRoot = part.Parent:FindFirstChild("HumanoidRootPart")
                    if otherRoot then
                        local vel = Instance.new("BodyVelocity")
                        vel.Velocity = (otherRoot.Position - root.Position).Unit * 120
                        vel.MaxForce = Vector3.new(10000, 10000, 10000)
                        vel.Parent = otherRoot
                        game:GetService("Debris"):AddItem(vel, 0.5)
                    end
                end
            end
        end
    end)
    
    wait(2)
    track1:Stop()
    track2:Stop()
    hum.WalkSpeed = oldSpeed
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
        wait(0.15)
    end
end

-- Speed Toggle
local speedEnabled = false

-- Create GUI Buttons
createButton("⚡ Drift", performDrift, Color3.fromRGB(200, 150, 50))
createButton("🎉 Dance 1", function() performCelebration(1) end, Color3.fromRGB(50, 150, 200))
createButton("🎉 Dance 2", function() performCelebration(2) end, Color3.fromRGB(200, 50, 150))
createButton("🔄 Replay Intro", function()
    playIntro()
end, Color3.fromRGB(100, 200, 50))

-- Speed Toggle
createToggle("⚡ Speed Boost", false, function(state)
    speedEnabled = state
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    if state then
        hum.WalkSpeed = 80
    else
        hum.WalkSpeed = originalSpeed.WalkSpeed
    end
end)

-- Intro System
local introShown = false

function playIntro()
    if introShown then
        -- If already shown, just replay
        local videoFrame = player.PlayerGui:FindFirstChild("IntroVideoFrame")
        if videoFrame then videoFrame:Destroy() end
    end
    
    local videoFrame = Instance.new("Frame")
    videoFrame.Name = "IntroVideoFrame"
    videoFrame.Size = UDim2.new(1, 0, 1, 0)
    videoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    videoFrame.ZIndex = 999
    videoFrame.Parent = player:WaitForChild("PlayerGui")
    
    -- Create a loading text
    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, 0, 0, 50)
    loadingText.Position = UDim2.new(0, 0, 0.5, -25)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "🎬 Loading Intro..."
    loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingText.TextSize = 20
    loadingText.Font = Enum.Font.GothamBold
    loadingText.Parent = videoFrame
    
    -- Try to play the video using different methods for Delta
    local success = pcall(function()
        -- Attempt 1: VideoPlayer
        local videoPlayer = Instance.new("VideoPlayer")
        videoPlayer.Size = UDim2.new(1, 0, 1, 0)
        videoPlayer.Parent = videoFrame
        
        local url = "https://github.com/waveexecutors/Scripts-Source/raw/refs/heads/main/Scripts/Bellingham%20FE%20SCRIPT/lv_0_20260723141904.webm"
        videoPlayer:Play(url)
        loadingText:Destroy()
        
        -- Wait for video to finish
        task.wait(6)
        
        -- Fade out
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
        introShown = true
    end)
    
    if not success then
        -- Fallback: Show a simple intro animation
        loadingText.Text = "🎬 Intro Playing..."
        
        -- Simple color animation as fallback
        for i = 1, 20 do
            videoFrame.BackgroundColor3 = Color3.fromRGB(math.random(0, 50), math.random(0, 50), math.random(100, 150))
            task.wait(0.1)
        end
        
        -- Fade out
        for i = 1, 30 do
            videoFrame.BackgroundTransparency = i / 30
            task.wait(0.05)
        end
        
        videoFrame:Destroy()
        introShown = true
    end
end

-- Auto play intro on startup (with slight delay)
task.wait(0.5)
playIntro()

-- Character respawn handling
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    if speedEnabled then
        humanoid.WalkSpeed = 80
    end
end)

print("⚽ Bellingham FE Script Loaded!")
print("Made by LocalxError & _4bits_")
