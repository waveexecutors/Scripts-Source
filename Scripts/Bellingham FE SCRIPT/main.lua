-- Bellingham FE Script
-- Made by LocalxError & _4bits_
-- Delta Executor Mobile Optimized (Fixed Drift/Fling & Video)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Speed variables
local originalSpeed = {
    WalkSpeed = humanoid.WalkSpeed
}

-- Animation tracks storage
local activeTracks = {}
local isDrifting = false

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BellinghamGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 340)
mainFrame.Position = UDim2.new(0.5, -90, 0.5, -170)
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

-- Shadow
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

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0, 5)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.VerticalAlignment = Enum.VerticalAlignment.Top
uiList.Parent = contentFrame

-- Button Creation
local function createButton(text, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 30)
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
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0.1
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.2
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Toggle Creation
local function createToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 150, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = contentFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
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

-- Stop All Animations Function
local function stopAllAnimations()
    for _, track in pairs(activeTracks) do
        pcall(function()
            track:Stop()
        end)
    end
    activeTracks = {}
    
    pcall(function()
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then
            for _, anim in pairs(hum:GetPlayingAnimationTracks()) do
                anim:Stop()
            end
        end
    end)
end

-- Drift Function (Smooth with lay down & FE Fling)
local function performDrift()
    if isDrifting then return end
    isDrifting = true
    
    local char = player.Character
    if not char then 
        isDrifting = false
        return 
    end
    
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then 
        isDrifting = false
        return 
    end
    
    -- Stop all animations first
    stopAllAnimations()
    
    -- Play drift animations
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
    
    -- Lay down on floor
    hum.Sit = true
    hum.PlatformStand = true
    
    -- Drift Forward Physics (Mimics a football slide tackle)
    local slideVelocity = Instance.new("BodyVelocity")
    slideVelocity.MaxForce = Vector3.new(100000, 0, 100000)
    slideVelocity.Velocity = root.CFrame.LookVector * 75 -- Adjust this number for slide speed
    slideVelocity.Parent = root
    
    -- Drift duration & FE Fling Logic
    local driftTime = 0
    local connection
    
    -- Fling detection: Applies massive RotVelocity to our root so anyone we touch gets flung
    connection = game:GetService("RunService").Stepped:Connect(function(_, deltaTime)
        driftTime = driftTime + deltaTime
        
        if root then
            root.RotVelocity = Vector3.new(50000, 50000, 50000)
        end
        
        -- After 2 seconds, stop sliding
        if driftTime >= 2 then
            connection:Disconnect()
        end
    end)
    
    -- Wait 2 seconds
    task.wait(2)
    
    -- Cleanup Physics
    if slideVelocity then
        slideVelocity:Destroy()
    end
    
    -- Reset velocities so we don't fly away
    root.RotVelocity = Vector3.new(0, 0, 0)
    root.Velocity = Vector3.new(0, 0, 0)
    
    -- Stand up
    hum.Sit = false
    hum.PlatformStand = false
    
    -- Stop animations after drift
    task.wait(0.3)
    track1:Stop()
    track2:Stop()
    
    isDrifting = false
end

-- Celebration Function
local function performCelebration(danceType)
    local char = player.Character
    if not char then return end
    
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
    -- Stop current animations
    stopAllAnimations()
    
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
        table.insert(activeTracks, track)
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
createButton("⏹ Stop Animations", stopAllAnimations, Color3.fromRGB(200, 50, 50))
createButton("🔄 Replay Intro", function()
    playIntro()
end, Color3.fromRGB(100, 200, 50))

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
                hum.WalkSpeed = originalSpeed.WalkSpeed
            end
        end
    end
end)

-- INTRO SYSTEM - Fixed to use getcustomasset
local introShown = false
local videoFileName = "lv_0_20260723141904.webm"
local videoUrl = "https://github.com/waveexecutors/Scripts-Source/raw/refs/heads/main/Scripts/Bellingham%20FE%20SCRIPT/" .. videoFileName

function downloadVideo()
    local methods = {
        function()
            local http = game:GetService("HttpService")
            return http:GetAsync(videoUrl)
        end,
        function()
            if syn and syn.request then
                local response = syn.request({Url = videoUrl, Method = "GET"})
                if response and response.Body then return response.Body end
            end
            return nil
        end,
        function()
            if request then
                local response = request({Url = videoUrl, Method = "GET"})
                if response and response.Body then return response.Body end
            end
            return nil
        end
    }
    
    for _, method in ipairs(methods) do
        local success, result = pcall(method)
        if success and result then
            return result
        end
    end
    return nil
end

function playIntro()
    -- Create fullscreen video frame
    local videoFrame = Instance.new("Frame")
    videoFrame.Name = "IntroVideoFrame"
    videoFrame.Size = UDim2.new(1, 0, 1, 0)
    videoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    videoFrame.ZIndex = 999
    videoFrame.Parent = player:WaitForChild("PlayerGui")
    
    -- Create VideoFrame
    local video = Instance.new("VideoFrame")
    video.Size = UDim2.new(1, 0, 1, 0)
    video.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    video.Looped = false
    video.Parent = videoFrame
    
    -- Loading text
    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, 0, 0, 50)
    loadingText.Position = UDim2.new(0, 0, 0.5, -25)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "🎬 Loading Intro..."
    loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingText.TextSize = 18
    loadingText.Font = Enum.Font.GothamBold
    loadingText.Parent = videoFrame
    
    -- Try to download video
    local videoData = downloadVideo()
    
    if videoData then
        -- Executor must support getcustomasset or getsynasset to load local video files
        local customAssetFunc = getcustomasset or getsynasset
        
        if writefile and customAssetFunc then
            pcall(function()
                writefile(videoFileName, videoData)
            end)
            
            loadingText.Text = "🎬 Playing Intro..."
            
            -- Apply custom asset
            local success, _ = pcall(function()
                video.Video = customAssetFunc(videoFileName)
            end)
            
            if success then
                loadingText:Destroy()
                
                -- Wait for video to load
                local loadAttempts = 0
                while not video.IsLoaded and loadAttempts < 50 do
                    task.wait(0.1)
                    loadAttempts = loadAttempts + 1
                end
                
                -- Play the video
                if video.IsLoaded then
                    video:Play()
                end
                
                -- Wait for video to finish (adjust wait to max length)
                local waitTime = 0
                while video.IsPlaying and waitTime < 8 do
                    task.wait(0.1)
                    waitTime = waitTime + 0.1
                end
                
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
                
                -- Clean up file
                if delfile then
                    pcall(function() delfile(videoFileName) end)
                end
            else
                loadingText.Text = "❌ Failed to load video format"
                task.wait(2)
                videoFrame:Destroy()
            end
        else
            loadingText.Text = "❌ Executor missing getcustomasset"
            task.wait(2)
            videoFrame:Destroy()
        end
    else
        loadingText.Text = "❌ Failed to download video"
        task.wait(2)
        videoFrame:Destroy()
    end
end

-- Auto play intro on startup
task.wait(0.5)
playIntro()

-- Character respawn handling
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    activeTracks = {}
    isDrifting = false
    
    if speedEnabled then
        humanoid.WalkSpeed = 80
    end
end)

print("⚽ Bellingham FE Script Loaded!")
print("Made by LocalxError & _4bits_")
