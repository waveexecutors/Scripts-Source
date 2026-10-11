
-- sussy gui

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local gui = Instance.new("ScreenGui")
gui.Name = "sussy_gui"
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "sussy gui"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = titleBar

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 1, 0)
minimizeButton.Position = UDim2.new(1, -60, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 14
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.Parent = titleBar

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local jerkOffToggle = Instance.new("TextButton")
jerkOffToggle.Name = "JerkOffToggle"
jerkOffToggle.Size = UDim2.new(1, 0, 0, 30)
jerkOffToggle.Position = UDim2.new(0, 0, 0, 0)
jerkOffToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jerkOffToggle.Text = "Jerk Off"
jerkOffToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
jerkOffToggle.TextSize = 14
jerkOffToggle.Font = Enum.Font.SourceSansBold
jerkOffToggle.Parent = contentFrame

local jerkOffSpeedSlider = Instance.new("TextBox")
jerkOffSpeedSlider.Name = "JerkOffSpeedSlider"
jerkOffSpeedSlider.Size = UDim2.new(1, 0, 0, 30)
jerkOffSpeedSlider.Position = UDim2.new(0, 0, 0, 30)
jerkOffSpeedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jerkOffSpeedSlider.Text = "Speed: 1"
jerkOffSpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
jerkOffSpeedSlider.TextSize = 14
jerkOffSpeedSlider.Font = Enum.Font.SourceSansBold
jerkOffSpeedSlider.Parent = contentFrame

local thirdPersonToggle = Instance.new("TextButton")
thirdPersonToggle.Name = "ThirdPersonToggle"
thirdPersonToggle.Size = UDim2.new(1, 0, 0, 30)
thirdPersonToggle.Position = UDim2.new(0, 0, 0, 60)
thirdPersonToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
thirdPersonToggle.Text = "Third Person"
thirdPersonToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
thirdPersonToggle.TextSize = 14
thirdPersonToggle.Font = Enum.Font.SourceSansBold
thirdPersonToggle.Parent = contentFrame

local suckFaceToggle = Instance.new("TextButton")
suckFaceToggle.Name = "SuckFaceToggle"
suckFaceToggle.Size = UDim2.new(1, 0, 0, 30)
suckFaceToggle.Position = UDim2.new(0, 0, 0, 90)
suckFaceToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
suckFaceToggle.Text = "Suck Face"
suckFaceToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
suckFaceToggle.TextSize = 14
suckFaceToggle.Font = Enum.Font.SourceSansBold
suckFaceToggle.Parent = contentFrame

local suckFaceSpeedSlider = Instance.new("TextBox")
suckFaceSpeedSlider.Name = "SuckFaceSpeedSlider"
suckFaceSpeedSlider.Size = UDim2.new(1, 0, 0, 30)
suckFaceSpeedSlider.Position = UDim2.new(0, 0, 0, 120)
suckFaceSpeedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
suckFaceSpeedSlider.Text = "Speed: 1"
suckFaceSpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
suckFaceSpeedSlider.TextSize = 14
suckFaceSpeedSlider.Font = Enum.Font.SourceSansBold
suckFaceSpeedSlider.Parent = contentFrame

local playerList = Instance.new("ScrollingFrame")
playerList.Name = "PlayerList"
playerList.Size = UDim2.new(1, 0, 0, 100)
playerList.Position = UDim2.new(0, 0, 0, 150)
playerList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
playerList.ScrollBarThickness = 5
playerList.Parent = contentFrame

local bangToggle = Instance.new("TextButton")
bangToggle.Name = "BangToggle"
bangToggle.Size = UDim2.new(1, 0, 0, 30)
bangToggle.Position = UDim2.new(0, 0, 0, 250)
bangToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
bangToggle.Text = "Bang"
bangToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
bangToggle.TextSize = 14
bangToggle.Font = Enum.Font.SourceSansBold
bangToggle.Parent = contentFrame

local warningFrame = Instance.new("Frame")
warningFrame.Name = "WarningFrame"
warningFrame.Size = UDim2.new(1, 0, 1, 0)
warningFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
warningFrame.BorderSizePixel = 0
warningFrame.Visible = false
warningFrame.Parent = gui

local warningLabel = Instance.new("TextLabel")
warningLabel.Name = "WarningLabel"
warningLabel.Size = UDim2.new(1, 0, 1, 0)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "This script contains explicit content. Are you 18+?"
warningLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
warningLabel.TextSize = 14
warningLabel.Font = Enum.Font.SourceSansBold
warningLabel.Parent = warningFrame

local ageVerificationButton = Instance.new("TextButton")
ageVerificationButton.Name = "AgeVerificationButton"
ageVerificationButton.Size = UDim2.new(0, 100, 0, 30)
ageVerificationButton.Position = UDim2.new(0.5, -50, 0.5, -15)
ageVerificationButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
ageVerificationButton.Text = "Yes"
ageVerificationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ageVerificationButton.TextSize = 14
ageVerificationButton.Font = Enum.Font.SourceSansBold
ageVerificationButton.Parent = warningFrame

local isDragging = false
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        startPos = input.Position - mainFrame.Position:ToVector2()
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        mainFrame.Position = UDim2.new(0, input.Position.X - startPos.X, 0, input.Position.Y - startPos.Y)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

jerkOffToggle.MouseButton1Click:Connect(function()
    if jerkOffToggle.Text == "Jerk Off" then
        jerkOffToggle.Text = "Stop Jerking Off"
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://168268306"
        local animTrack = humanoid:LoadAnimation(anim)
        animTrack:Play()
        animTrack:AdjustSpeed(tonumber(jerkOffSpeedSlider.Text:match("%d+")) or 1)
        animTrack.Looped = true
    else
        jerkOffToggle.Text = "Jerk Off"
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation.AnimationId == "rbxassetid://168268306" then
                track:Stop()
            end
        end
    end
end)

thirdPersonToggle.MouseButton1Click:Connect(function()
    if thirdPersonToggle.Text == "Third Person" then
        thirdPersonToggle.Text = "First Person"
        player.CameraMode = Enum.CameraMode.Classic
    else
        thirdPersonToggle.Text = "Third Person"
        player.CameraMode = Enum.CameraMode.LockFirstPerson
    end
end)

suckFaceToggle.MouseButton1Click:Connect(function()
    if suckFaceToggle.Text == "Suck Face" then
        suckFaceToggle.Text = "Stop Sucking Face"
        local targetPlayer = playerList:FindFirstChildOfClass("TextButton") and playerList:FindFirstChildOfClass("TextButton").Text
        if targetPlayer then
            local targetCharacter = Players:FindFirstChild(targetPlayer) and Players:FindFirstChild(targetPlayer).Character
            if targetCharacter then
                local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
                if targetHumanoid then
                    while suckFaceToggle.Text == "Stop Sucking Face" do
                        humanoid:MoveTo(targetHumanoid.RootPart.Position + (targetHumanoid.RootPart.CFrame.LookVector * 2))
                        task.wait(tonumber(suckFaceSpeedSlider.Text:match("%d+")) or 1)
                        humanoid:MoveTo(targetHumanoid.RootPart.Position - (targetHumanoid.RootPart.CFrame.LookVector * 2))
                        task.wait(tonumber(suckFaceSpeedSlider.Text:match("%d+")) or 1)
                    end
                end
            end
        end
    else
        suckFaceToggle.Text = "Suck Face"
    end
end)

bangToggle.MouseButton1Click:Connect(function()
    if bangToggle.Text == "Bang" then
        bangToggle.Text = "Stop Banging"
        local targetPlayer = playerList:FindFirstChildOfClass("TextButton") and playerList:FindFirstChildOfClass("TextButton").Text
        if targetPlayer then
            local targetCharacter = Players:FindFirstChild(targetPlayer) and Players:FindFirstChild(targetPlayer).Character
            if targetCharacter then
                local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
                if targetHumanoid then
                    while bangToggle.Text == "Stop Banging" do
                        humanoid:MoveTo(targetHumanoid.RootPart.Position)
                        task.wait(1)
                    end
                end
            end
        end
    else
        bangToggle.Text = "Bang"
    end
end)

ageVerificationButton.MouseButton1Click:Connect(function()
    warningFrame.Visible = false
    mainFrame.Visible = true
end)

warningFrame.Visible = true
mainFrame.Visible = false

for _, player in pairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        local playerButton = Instance.new("TextButton")
        playerButton.Name = player.Name
        playerButton.Size = UDim2.new(1, 0, 0, 30)
        playerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        playerButton.Text = player.Name
        playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        playerButton.TextSize = 14
        playerButton.Font = Enum.Font.SourceSansBold
        playerButton.Parent = playerList
        playerButton.Image = player.Character and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("HumanoidDescription") and player.Character:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("HumanoidDescription").Face.Image
    end
end
