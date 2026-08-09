--[[
    BRAINROT UTILITY – for Delta Executor (Mobile)
    Features:
    - Modern draggable GUI (touch & mouse)
    - Minimize / Close buttons
    - Teleport forward with adjustable distance
    - Autoclick toggle (uses mouse1click or VirtualInputManager)
    - Attempts to stay undetected by using smooth movement (tween) for teleport
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- === GUI CREATION ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 360)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Rounded corners
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

-- Minimize Button
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

-- Close Button
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

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -32)
Content.Position = UDim2.new(0, 0, 0, 32)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- === TELEPORT SECTION ===
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

local DistanceBox = Instance.new("TextBox")
DistanceBox.Size = UDim2.new(0.6, 0, 0, 30)
DistanceBox.Position = UDim2.new(0.2, 0, 0, 38)
DistanceBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
DistanceBox.TextColor3 = Color3.new(1, 1, 1)
DistanceBox.Text = "100"
DistanceBox.TextSize = 14
DistanceBox.Font = Enum.Font.Gotham
DistanceBox.ClearTextOnFocus = false
DistanceBox.TextXAlignment = Enum.TextXAlignment.Center
DistanceBox.Parent = Content
local DistCorner = Instance.new("UICorner")
DistCorner.CornerRadius = UDim.new(0, 4)
DistCorner.Parent = DistanceBox

local TeleBtn = Instance.new("TextButton")
TeleBtn.Size = UDim2.new(0, 140, 0, 36)
TeleBtn.Position = UDim2.new(0.5, -70, 0, 82)
TeleBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 60)
TeleBtn.Text = "🚀 Teleport Forward"
TeleBtn.TextColor3 = Color3.new(1, 1, 1)
TeleBtn.TextSize = 14
TeleBtn.Font = Enum.Font.GothamBold
TeleBtn.Parent = Content
local TeleCorner = Instance.new("UICorner")
TeleCorner.CornerRadius = UDim.new(0, 6)
TeleCorner.Parent = TeleBtn

-- === AUTOCLICK SECTION ===
local AutoLabel = Instance.new("TextLabel")
AutoLabel.Size = UDim2.new(1, 0, 0, 22)
AutoLabel.Position = UDim2.new(0, 0, 0, 135)
AutoLabel.BackgroundTransparency = 1
AutoLabel.Text = "Autoclick"
AutoLabel.TextColor3 = Color3.new(1, 1, 1)
AutoLabel.TextSize = 14
AutoLabel.Font = Enum.Font.Gotham
AutoLabel.TextXAlignment = Enum.TextXAlignment.Center
AutoLabel.Parent = Content

local AutoToggle = Instance.new("TextButton")
AutoToggle.Size = UDim2.new(0, 140, 0, 36)
AutoToggle.Position = UDim2.new(0.5, -70, 0, 162)
AutoToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
AutoToggle.Text = "Toggle ON"
AutoToggle.TextColor3 = Color3.new(1, 1, 1)
AutoToggle.TextSize = 14
AutoToggle.Font = Enum.Font.GothamBold
AutoToggle.Parent = Content
local AutoCorner = Instance.new("UICorner")
AutoCorner.CornerRadius = UDim.new(0, 6)
AutoCorner.Parent = AutoToggle

-- === DRAGGING (Touch & Mouse) ===
local isDragging = false
local dragOffset = Vector2.new()

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        local pos = input.Position
        local framePos = MainFrame.Position
        dragOffset = Vector2.new(pos.X - framePos.X.Offset, pos.Y - framePos.Y.Offset)
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local pos = input.Position
        MainFrame.Position = UDim2.new(0, pos.X - dragOffset.X, 0, pos.Y - dragOffset.Y)
    end
end)

-- === MINIMIZE ===
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 260, 0, 32)
        Content.Visible = false
        MinBtn.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 260, 0, 360)
        Content.Visible = true
        MinBtn.Text = "—"
    end
end)

-- === CLOSE ===
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- === TELEPORT (Smooth Tween to avoid detection) ===
TeleBtn.MouseButton1Click:Connect(function()
    local dist = tonumber(DistanceBox.Text) or 100
    if not Character or not RootPart then return end

    local look = RootPart.CFrame.LookVector
    local targetPos = RootPart.Position + look * dist
    local targetCF = CFrame.new(targetPos, targetPos + look)

    -- Tween the RootPart to make it look like a smooth dash
    local tweenInfo = TweenInfo.new(
        0.15,                      -- duration
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(RootPart, tweenInfo, {CFrame = targetCF})
    tween:Play()
    tween.Completed:Wait()
end)

-- === AUTOCLICK ===
local autoclicking = false
local clickConnection = nil

-- Try to use mouse1click (common in executors), fallback to VirtualInputManager
local function doClick()
    -- Attempt mouse1click (Delta supports it)
    local success, err = pcall(function()
        mouse1click()
    end)
    if not success then
        -- Fallback using VirtualInputManager if available
        pcall(function()
            local VIM = game:GetService("VirtualInputManager")
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            wait(0.01)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end)
    end
end

AutoToggle.MouseButton1Click:Connect(function()
    autoclicking = not autoclicking
    if autoclicking then
        AutoToggle.Text = "Toggle OFF"
        AutoToggle.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        -- Start clicking loop
        clickConnection = RunService.Heartbeat:Connect(function()
            doClick()
        end)
    else
        AutoToggle.Text = "Toggle ON"
        AutoToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        if clickConnection then
            clickConnection:Disconnect()
            clickConnection = nil
        end
    end
end)

-- === CHARACTER RESET HANDLER ===
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

-- === SAFETY: stop autoclick when GUI closes ===
ScreenGui.AncestryChanged:Connect(function()
    if not ScreenGui.Parent then
        if clickConnection then clickConnection:Disconnect() end
    end
end)

print("🧠 Brainrot Utility loaded successfully!")
