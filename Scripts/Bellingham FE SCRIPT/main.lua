-- Bellingham FE Script
-- Made by LocalxError & _4bits_
-- Delta Executor Mobile Optimized (Football Slide + Custom UI Intro)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Executor API Setup
local Request = request or (http and http.request) or (syn and syn.request)
local GetAsset = getcustomasset or getsynasset

if isfolder and not isfolder("BellinghamAssets") then
    makefolder("BellinghamAssets")
end

local activeTracks = {}
local isSliding = false
local speedEnabled = false
local originalSpeed = humanoid.WalkSpeed
local canSlide = true

-- ==========================================
-- GUI CREATION (Main Control Panel)
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BellinghamGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

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

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 30))
})
gradient.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

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

local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 25, 0, 25)
minButton.Position = UDim2.new(1, -55, 0, 2.5)
minButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minButton.BackgroundTransparency = 0.5
minButton.BorderSizePixel = 0
minButton.Text = "─"
minButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minButton.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -28, 0, 2.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BackgroundTransparency = 0.3
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = titleBar

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0, 4)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.VerticalAlignment = Enum.VerticalAlignment.Top
uiList.Parent = contentFrame

local function createButton(text, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 28)
    btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 80)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = contentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 150, 0, 28)
    frame.BackgroundTransparency = 1
    frame.Parent = contentFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 35, 0, 22)
    toggleBtn.Position = UDim2.new(0.75, 0, 0.1, 0)
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

-- ==========================================
-- FOOTBALL SLIDE SYSTEM (Visible to Everyone)
-- ==========================================
local function stopAllAnimations()
    for _, track in pairs(activeTracks) do pcall(function() track:Stop() end) end
    activeTracks = {}
    pcall(function()
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then
            for _, anim in pairs(hum:GetPlayingAnimationTracks()) do anim:Stop() end
        end
    end)
end

local function performFootballSlide()
    if isSliding or not canSlide then return end
    
    local char = player.Character
    if not char then return end
    
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    
    -- Check if player is moving fast enough
    local velocity = root.AssemblyLinearVelocity
    local speed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
    if speed < 10 then return end
    
    stopAllAnimations()
    
    isSliding = true
    canSlide = false
    
    -- Play slide animation (football slide - using existing animations)
    local anim1 = Instance.new("Animation")
    anim1.AnimationId = "rbxassetid://125749145"
    local anim2 = Instance.new("Animation")
    anim2.AnimationId = "rbxassetid://125750702"
    
    local track1 = hum:LoadAnimation(anim1)
    local track2 = hum:LoadAnimation(anim2)
    table.insert(activeTracks, track1)
    table.insert(activeTracks, track2)
    track1:Play()
    track2:Play()
    
    -- Lower hip height for slide effect (visible to everyone)
    local originalHipHeight = hum.HipHeight
    hum.HipHeight = 0.5
    
    -- Create BodyVelocity for slide movement
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(100000, 0, 100000)
    bv.Velocity = root.CFrame.LookVector * 80
    bv.Parent = root
    
    -- Fling detection while sliding
    local connection
    connection = RunService.Stepped:Connect(function()
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Parent and part.Parent:FindFirstChild("Humanoid") and part.Parent ~= char then
                if (root.Position - part.Position).Magnitude < 10 then
                    local otherRoot = part.Parent:FindFirstChild("HumanoidRootPart")
                    if otherRoot then
                        local vel = Instance.new("BodyVelocity")
                        vel.Velocity = (otherRoot.Position - root.Position).Unit * 150
                        vel.MaxForce = Vector3.new(10000, 10000, 10000)
                        vel.Parent = otherRoot
                        game:GetService("Debris"):AddItem(vel, 0.5)
                    end
                end
            end
        end
    end)
    
    -- Keep player on ground
    local antiFly = RunService.RenderStepped:Connect(function()
        if root then
            root.Velocity = Vector3.new(root.Velocity.X, -15, root.Velocity.Z)
        end
    end)
    
    -- Slide duration: 1.5 seconds
    task.wait(1.5)
    
    -- Stop effects
    antiFly:Disconnect()
    connection:Disconnect()
    bv:Destroy()
    
    -- Restore hip height
    hum.HipHeight = originalHipHeight
    
    -- Stop animations
    track1:Stop()
    track2:Stop()
    
    isSliding = false
    
    -- Cooldown
    task.wait(0.5)
    canSlide = true
end

local function performCelebration(danceType)
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if not hum then return end
    stopAllAnimations()
    local anims = danceType == 1 and {"182435998", "182393478"} or {"182491037", "45828430"}
    for _, id in pairs(anims) do
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. id
        local track = hum:LoadAnimation(anim)
        table.insert(activeTracks, track)
        track:Play()
        wait(0.1)
    end
end

-- ==========================================
-- CREATE GUI BUTTONS
-- ==========================================
createButton("⚽ Football Slide", performFootballSlide, Color3.fromRGB(200, 150, 50))
createButton("🎉 Dance 1", function() performCelebration(1) end, Color3.fromRGB(50, 150, 200))
createButton("🎉 Dance 2", function() performCelebration(2) end, Color3.fromRGB(200, 50, 150))
createButton("⏹ Stop Animations", stopAllAnimations, Color3.fromRGB(200, 50, 50))

-- Speed Toggle
createToggle("⚡ Speed Boost", false, function(state)
    speedEnabled = state
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            if state then
                hum.WalkSpeed = 80
            else
                hum.WalkSpeed = originalSpeed
            end
        end
    end
end)

-- ==========================================
-- CUSTOM UI MP3 INTRO WITH BLOCK SPEED CONTROL
-- ==========================================
local audioFileName = "intro.mp3"
local audioUrl = "https://github.com/waveexecutors/Scripts-Source/raw/refs/heads/main/Scripts/Bellingham%20FE%20SCRIPT/intro.mp3"
local blockDelay = 0.8

-- Create speed control UI
local speedControlFrame = Instance.new("Frame")
speedControlFrame.Size = UDim2.new(0, 150, 0, 28)
speedControlFrame.BackgroundTransparency = 1
speedControlFrame.Parent = contentFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.5, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Intro Speed:"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 10
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedControlFrame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.4, 0, 1, 0)
speedInput.Position = UDim2.new(0.6, 0, 0, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedInput.BackgroundTransparency = 0.5
speedInput.Text = "0.8"
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.TextSize = 12
speedInput.Font = Enum.Font.GothamMedium
speedInput.PlaceholderText = "0.8"
speedInput.ClearTextOnFocus = false
speedInput.Parent = speedControlFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 4)
speedCorner.Parent = speedInput

speedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = tonumber(speedInput.Text)
        if val and val > 0 and val < 5 then
            blockDelay = val
        else
            speedInput.Text = tostring(blockDelay)
        end
    end
end)

-- Build intro blocks
local function buildIntroBlocks(container)
    for _, child in pairs(container:GetChildren()) do
        if child:IsA("Frame") and child.Name == "IntroBlock" then
            child:Destroy()
        end
    end
    
    local function createBlock()
        local frame = Instance.new("Frame")
        frame.Name = "IntroBlock"
        frame.Size = UDim2.new(1, 0, 0.25, 0)
        frame.Position = UDim2.new(0, 0, -0.25, 0)
        frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        frame.BorderSizePixel = 0
        frame.Parent = container
        return frame
    end
    
    local b1 = createBlock()
    local t1 = Instance.new("TextLabel")
    t1.Size = UDim2.new(1, 0, 1, 0)
    t1.BackgroundTransparency = 1
    t1.Text = "SCRIPT LAND"
    t1.TextScaled = true
    t1.TextColor3 = Color3.fromRGB(0, 0, 0)
    t1.Font = Enum.Font.GothamBlack
    t1.Parent = b1
    
    local b2 = createBlock()
    local t2 = Instance.new("TextLabel")
    t2.Size = UDim2.new(1, 0, 1, 0)
    t2.BackgroundTransparency = 1
    t2.Text = "ST"
    t2.TextScaled = true
    t2.TextColor3 = Color3.fromRGB(0, 0, 0)
    t2.Font = Enum.Font.GothamBlack
    t2.Parent = b2
    
    local b3 = createBlock()
    local img3 = Instance.new("ImageLabel")
    img3.Size = UDim2.new(1, 0, 1, 0)
    img3.BackgroundTransparency = 1
    img3.Image = "rbxassetid://657238199"
    img3.ScaleType = Enum.ScaleType.Stretch
    img3.Parent = b3
    
    local b4 = createBlock()
    local img4 = Instance.new("ImageLabel")
    img4.Size = UDim2.new(1, 0, 1, 0)
    img4.BackgroundTransparency = 1
    img4.Image = "rbxthumb://type=Avatar&id=" .. player.UserId .. "&w=420&h=420"
    img4.ScaleType = Enum.ScaleType.Stretch
    img4.Parent = b4
    
    return {b1, b2, b3, b4}
end

local currentIntroGui = nil
local isIntroPlaying = false

-- ==========================================
-- PLAY INTRO FUNCTION
-- ==========================================
function playIntro()
    if currentIntroGui then
        pcall(function()
            currentIntroGui:Destroy()
        end)
        currentIntroGui = nil
        isIntroPlaying = false
    end
    
    if isIntroPlaying then return end
    isIntroPlaying = true
    
    task.spawn(function()
        local audioData
        if Request then
            local success, res = pcall(function()
                return Request({Method = "GET", Url = audioUrl})
            end)
            if success and res and res.Body then
                audioData = res.Body
            end
        end
        
        local sound = Instance.new("Sound")
        sound.Volume = 2
        sound.Parent = CoreGui
        
        if audioData and writefile and GetAsset then
            pcall(function() writefile("BellinghamAssets/" .. audioFileName, audioData) end)
            sound.SoundId = GetAsset("BellinghamAssets/" .. audioFileName)
        end
        
        local introGui = Instance.new("ScreenGui")
        introGui.Name = "BellinghamCustomIntro"
        introGui.DisplayOrder = 99999
        introGui.IgnoreGuiInset = true
        introGui.Parent = CoreGui
        
        currentIntroGui = introGui
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Parent = introGui
        
        local blocks = buildIntroBlocks(container)
        local b1, b2, b3, b4 = blocks[1], blocks[2], blocks[3], blocks[4]
        
        task.wait(0.5)
        sound:Play()
        
        local slideTweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        -- Block 1: Fixed 1 second delay
        task.wait(1)
        TweenService:Create(b1, slideTweenInfo, {Position = UDim2.new(0, 0, 0, 0)}):Play()
        
        -- Block 2, 3, 4: User controlled delay
        task.wait(blockDelay)
        TweenService:Create(b2, slideTweenInfo, {Position = UDim2.new(0, 0, 0.25, 0)}):Play()
        
        task.wait(blockDelay)
        TweenService:Create(b3, slideTweenInfo, {Position = UDim2.new(0, 0, 0.50, 0)}):Play()
        
        task.wait(blockDelay)
        TweenService:Create(b4, slideTweenInfo, {Position = UDim2.new(0, 0, 0.75, 0)}):Play()
        
        task.wait(1)
        
        local fadeFrame = Instance.new("Frame")
        fadeFrame.Size = UDim2.new(1, 0, 1, 0)
        fadeFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fadeFrame.BackgroundTransparency = 1
        fadeFrame.ZIndex = 10
        fadeFrame.Parent = container
        
        local fadeOutTween = TweenService:Create(fadeFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0})
        fadeOutTween:Play()
        fadeOutTween.Completed:Wait()
        
        sound:Stop()
        sound:Destroy()
        introGui:Destroy()
        currentIntroGui = nil
        isIntroPlaying = false
    end)
end

-- ==========================================
-- CREATE REPLAY INTRO BUTTON (AFTER FUNCTION)
-- ==========================================
createButton("🔄 Replay Intro", function()
    playIntro()
end, Color3.fromRGB(100, 200, 50))

-- ==========================================
-- AUTO PLAY INTRO
-- ==========================================
task.wait(0.5)
playIntro()

-- ==========================================
-- KEYBIND FOR SLIDE (Press C to slide)
-- ==========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.C then
        performFootballSlide()
    end
end)

-- ==========================================
-- TOP BAR UI CONTROLS
-- ==========================================
minButton.MouseButton1Click:Connect(function()
    local minimized = mainFrame.Size.Y.Offset == 30
    if minimized then
        mainFrame.Size = UDim2.new(0, 180, 0, 280)
        contentFrame.Visible = true
        minButton.Text = "─"
    else
        mainFrame.Size = UDim2.new(0, 180, 0, 30)
        contentFrame.Visible = false
        minButton.Text = "□"
    end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ==========================================
-- CHARACTER RESPAWN HANDLING
-- ==========================================
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    activeTracks = {}
    isSliding = false
    canSlide = true
    
    if speedEnabled then
        humanoid.WalkSpeed = 80
    end
end)

print("⚽ Bellingham FE Loaded! (Football Slide + Custom UI Intro)")
print("💡 Press C to perform a football slide!")
print("💡 First block appears in 1 second (fixed)")
print("💡 Other blocks use the speed you set (default 0.8s)")
