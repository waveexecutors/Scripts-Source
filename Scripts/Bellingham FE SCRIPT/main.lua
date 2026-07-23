-- Bellingham FE Script
-- Made by LocalxError & _4bits_
-- Delta Executor Mobile Optimized (Safe Slide + Accurate WebM Intro & Audio)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")

-- Executor API Setup
local Request = request or (http and http.request) or (syn and syn.request)
local GetAsset = getcustomasset or getsynasset

if isfolder and not isfolder("BellinghamAssets") then
    makefolder("BellinghamAssets")
end

-- Speed variables
local originalSpeed = {WalkSpeed = humanoid.WalkSpeed}
local activeTracks = {}
local isDrifting = false

-- ==========================================
-- GUI CREATION
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BellinghamGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 310)
mainFrame.Position = UDim2.new(0.5, -90, 0.5, -155)
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
uiList.Padding = UDim.new(0, 5)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.VerticalAlignment = Enum.VerticalAlignment.Top
uiList.Parent = contentFrame

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
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ==========================================
-- SAFE DRIFT & FLING SYSTEM
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

local function performDrift()
    if isDrifting then return end
    isDrifting = true
    
    local char = player.Character
    if not char then isDrifting = false return end
    
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then isDrifting = false return end
    
    stopAllAnimations()
    
    local anim1 = Instance.new("Animation") anim1.AnimationId = "rbxassetid://125749145"
    local anim2 = Instance.new("Animation") anim2.AnimationId = "rbxassetid://125750702"
    local track1 = hum:LoadAnimation(anim1)
    local track2 = hum:LoadAnimation(anim2)
    table.insert(activeTracks, track1) table.insert(activeTracks, track2)
    track1:Play() track2:Play()
    
    hum.Sit = true
    
    local slideVelocity = Instance.new("BodyVelocity")
    slideVelocity.MaxForce = Vector3.new(100000, 0, 100000) 
    slideVelocity.Velocity = root.CFrame.LookVector * 70
    slideVelocity.Parent = root
    
    local spinFling = Instance.new("BodyAngularVelocity")
    spinFling.MaxTorque = Vector3.new(0, 100000, 0)
    spinFling.AngularVelocity = Vector3.new(0, 120, 0) 
    spinFling.Parent = root
    
    local antiFly = RunService.RenderStepped:Connect(function()
        if root then
            root.Velocity = Vector3.new(root.Velocity.X, -15, root.Velocity.Z)
        end
    end)
    
    task.wait(1.5)
    
    antiFly:Disconnect()
    if slideVelocity then slideVelocity:Destroy() end
    if spinFling then spinFling:Destroy() end
    
    root.RotVelocity = Vector3.new(0, 0, 0)
    root.Velocity = Vector3.new(0, 0, 0)
    
    hum.Sit = false
    task.wait(0.3)
    track1:Stop() track2:Stop()
    
    isDrifting = false
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

createButton("⚡ Safe Slide + Fling", performDrift, Color3.fromRGB(200, 150, 50))
createButton("🎉 Dance 1", function() performCelebration(1) end, Color3.fromRGB(50, 150, 200))
createButton("🎉 Dance 2", function() performCelebration(2) end, Color3.fromRGB(200, 50, 150))
createButton("⏹ Stop Animations", stopAllAnimations, Color3.fromRGB(200, 50, 50))

-- ==========================================
-- ACCURATE WEBM INTRO & AUDIO PLAYER
-- ==========================================
local videoFileName = "lv_0_20260723141904.webm"
local videoUrl = "https://github.com/waveexecutors/Scripts-Source/raw/refs/heads/main/Scripts/Bellingham%20FE%20SCRIPT/" .. videoFileName

local function playIntro()
    local introFrame = Instance.new("Frame")
    introFrame.Name = "BellinghamIntro"
    introFrame.Size = UDim2.new(1, 0, 1, 0)
    introFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    introFrame.ZIndex = 9999
    introFrame.Parent = player:WaitForChild("PlayerGui")
    
    local video = Instance.new("VideoFrame")
    video.Size = UDim2.new(1, 0, 1, 0)
    video.BackgroundTransparency = 1
    video.Looped = false
    video.Parent = introFrame
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 50)
    statusLabel.Position = UDim2.new(0, 0, 0.5, -25)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "⚽ Loading Bellingham Intro..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextSize = 16
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Parent = introFrame

    task.spawn(function()
        local videoData
        if Request then
            local success, res = pcall(function()
                return Request({Method = "GET", Url = videoUrl})
            end)
            if success and res and res.Body then
                videoData = res.Body
            end
        end
        
        if videoData and writefile and GetAsset then
            pcall(function() writefile("BellinghamAssets/" .. videoFileName, videoData) end)
            local assetPath = GetAsset("BellinghamAssets/" .. videoFileName)
            
            video.Video = assetPath
            statusLabel:Destroy()
            
            local loadedAttempts = 0
            while not video.IsLoaded and loadedAttempts < 40 do
                task.wait(0.1)
                loadedAttempts = loadedAttempts + 1
            end
            
            if video.IsLoaded then
                video:Play()
                
                -- Accurate duration matching edit audio sync
                local timer = 0
                while video.Playing and timer < 7.5 do
                    task.wait(0.1)
                    timer = timer + 0.1
                end
            end
        else
            statusLabel.Text = "❌ Intro Load Failed"
            task.wait(1.5)
        end
        
        -- Fade Out Transition
        local fade = Instance.new("Frame")
        fade.Size = UDim2.new(1, 0, 1, 0)
        fade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        fade.BackgroundTransparency = 1
        fade.ZIndex = 10000
        fade.Parent = introFrame
        
        for i = 1, 20 do
            fade.BackgroundTransparency = 1 - (i / 20)
            task.wait(0.03)
        end
        
        introFrame:Destroy()
    end)
end

createButton("🔄 Replay Intro", playIntro, Color3.fromRGB(100, 200, 50))

-- Auto play intro on startup
task.spawn(playIntro)

-- Top Bar UI Controls
minButton.MouseButton1Click:Connect(function()
    local minimized = mainFrame.Size.Y.Offset == 30
    if minimized then
        mainFrame.Size = UDim2.new(0, 180, 0, 310)
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

print("⚽ Bellingham FE Ultimate Edition Loaded!")
