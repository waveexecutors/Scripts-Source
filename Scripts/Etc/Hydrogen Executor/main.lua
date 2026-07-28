-- Hydrogen Executor GUI Script - MOBILE OPTIMIZED
-- EXACT replica of the image with draggable icon at top middle

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Get screen size
local screenSizeX = workspace.CurrentCamera.ViewportSize.X
local screenSizeY = workspace.CurrentCamera.ViewportSize.Y

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HydrogenGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Create Main Frame (Draggable Icon) - AT TOP MIDDLE
local IconFrame = Instance.new("Frame")
IconFrame.Name = "IconFrame"
IconFrame.Size = UDim2.new(0, 70, 0, 70)
IconFrame.Position = UDim2.new(0.5, -35, 0.02, 0) -- Top middle
IconFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
IconFrame.BorderSizePixel = 3
IconFrame.BorderColor3 = Color3.fromRGB(0, 180, 255)
IconFrame.ClipsDescendants = true
IconFrame.Parent = ScreenGui

-- Icon Corner (rounded)
local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 15)
IconCorner.Parent = IconFrame

-- Icon Label - "H" in hydrogen style
local IconLabel = Instance.new("TextLabel")
IconLabel.Size = UDim2.new(1, 0, 1, 0)
IconLabel.BackgroundTransparency = 1
IconLabel.Text = "H"
IconLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
IconLabel.TextSize = 35
IconLabel.Font = Enum.Font.GothamBold
IconLabel.TextScaled = true
IconLabel.Parent = IconFrame

-- Small glow effect under icon
local IconGlow = Instance.new("Frame")
IconGlow.Size = UDim2.new(0, 80, 0, 80)
IconGlow.Position = UDim2.new(0.5, -40, 0.5, -40)
IconGlow.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
IconGlow.BackgroundTransparency = 0.9
IconGlow.BorderSizePixel = 0
IconGlow.Parent = IconFrame

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(1, 0)
GlowCorner.Parent = IconGlow

-- Create Main GUI (Executor) - EXACT MATCH TO IMAGE
local MainGUI = Instance.new("Frame")
MainGUI.Name = "MainGUI"
MainGUI.Size = UDim2.new(0, math.min(500, screenSizeX - 20), 0, math.min(450, screenSizeY - 40))
MainGUI.Position = UDim2.new(0.5, -MainGUI.Size.X.Offset/2, 0.5, -MainGUI.Size.Y.Offset/2)
MainGUI.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
MainGUI.BorderSizePixel = 2
MainGUI.BorderColor3 = Color3.fromRGB(0, 180, 255)
MainGUI.Visible = false
MainGUI.Active = true
MainGUI.Parent = ScreenGui

-- Main Corner
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainGUI

-- Title Bar - Hydrogen Blue
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
TitleBar.BackgroundTransparency = 0.15
TitleBar.Parent = MainGUI

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Title Text
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.04, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Hydrogen Executor"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Current Tab Label - EXACT MATCH
local TabLabel = Instance.new("TextLabel")
TabLabel.Size = UDim2.new(0.45, 0, 1, 0)
TabLabel.Position = UDim2.new(0.45, 0, 0, 0)
TabLabel.BackgroundTransparency = 1
TabLabel.Text = "Your Current Tab: Editor"
TabLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
TabLabel.TextSize = 13
TabLabel.Font = Enum.Font.Gotham
TabLabel.TextXAlignment = Enum.TextXAlignment.Center
TabLabel.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -38, 0, 4)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Script Editor Box - EXACT MATCH
local ScriptBox = Instance.new("TextBox")
ScriptBox.Size = UDim2.new(0.94, 0, 0.44, 0)
ScriptBox.Position = UDim2.new(0.03, 0, 0.11, 0)
ScriptBox.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
ScriptBox.TextColor3 = Color3.fromRGB(200, 200, 210)
ScriptBox.TextSize = 14
ScriptBox.Font = Enum.Font.Code
ScriptBox.Text = "Put Your Script Here..."
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptBox.ClearTextOnFocus = false
ScriptBox.MultiLine = true
ScriptBox.Parent = MainGUI

local ScriptCorner = Instance.new("UICorner")
ScriptCorner.CornerRadius = UDim.new(0, 6)
ScriptCorner.Parent = ScriptBox

-- Tab Buttons Frame
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(0.94, 0, 0.08, 0)
TabsFrame.Position = UDim2.new(0.03, 0, 0.58, 0)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Parent = MainGUI

-- Tab Buttons - EXACT MATCH TO IMAGE
local tabs = {"Editor", "Script Hub", "Settings", "Account"}
local tabButtons = {}

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.24, -4, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.25, 2, 0, 0)
    btn.BackgroundColor3 = (tab == "Editor") and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(35, 35, 50)
    btn.Text = tab
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabsFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    tabButtons[tab] = btn
    
    btn.MouseButton1Click:Connect(function()
        if tab == "Editor" then
            for _, b in pairs(tabButtons) do
                b.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
            TabLabel.Text = "Your Current Tab: Editor"
            ScriptBox.Visible = true
            SettingsFrame.Visible = false
        elseif tab == "Script Hub" then
            showToast("Script Hub - In Progress")
        elseif tab == "Settings" then
            for _, b in pairs(tabButtons) do
                b.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
            TabLabel.Text = "Your Current Tab: Settings"
            ScriptBox.Visible = false
            SettingsFrame.Visible = true
        elseif tab == "Account" then
            showToast("Account System - In Progress")
        end
    end)
end

-- Execute and Clear Buttons Frame
local ButtonFrame = Instance.new("Frame")
ButtonFrame.Size = UDim2.new(0.46, 0, 0.08, 0)
ButtonFrame.Position = UDim2.new(0.03, 0, 0.68, 0)
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Parent = MainGUI

-- Execute Button - Green
local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(0.47, -4, 1, 0)
ExecuteBtn.Position = UDim2.new(0, 0, 0, 0)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
ExecuteBtn.Text = "Execute"
ExecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteBtn.TextSize = 16
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.Parent = ButtonFrame

local ExecCorner = Instance.new("UICorner")
ExecCorner.CornerRadius = UDim.new(0, 5)
ExecCorner.Parent = ExecuteBtn

-- Clear Button - Red
local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0.47, -4, 1, 0)
ClearBtn.Position = UDim2.new(0.53, 0, 0, 0)
ClearBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
ClearBtn.Text = "Clear"
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.TextSize = 16
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.Parent = ButtonFrame

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 5)
ClearCorner.Parent = ClearBtn

-- Settings Frame (hidden by default)
local SettingsFrame = Instance.new("Frame")
SettingsFrame.Size = UDim2.new(0.94, 0, 0.5, 0)
SettingsFrame.Position = UDim2.new(0.03, 0, 0.11, 0)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
SettingsFrame.Visible = false
SettingsFrame.Parent = MainGUI

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 6)
SettingsCorner.Parent = SettingsFrame

-- Settings Scrolling Frame
local SettingsScroller = Instance.new("ScrollingFrame")
SettingsScroller.Size = UDim2.new(1, -10, 1, -10)
SettingsScroller.Position = UDim2.new(0.005, 0, 0.005, 0)
SettingsScroller.BackgroundTransparency = 1
SettingsScroller.CanvasSize = UDim2.new(0, 0, 0, 350)
SettingsScroller.ScrollBarThickness = 6
SettingsScroller.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
SettingsScroller.Parent = SettingsFrame

-- Settings Options List
local settingsOptions = {
    "Execution Mode: Normal",
    "Auto-Execute on Inject",
    "Save Script History",
    "Show Line Numbers",
    "Theme: Dark",
    "Font Size: 14",
    "Auto-Complete",
    "Syntax Highlighting"
}

local settingsToggles = {}

for i, option in ipairs(settingsOptions) do
    local optFrame = Instance.new("Frame")
    optFrame.Size = UDim2.new(1, -10, 0, 36)
    optFrame.Position = UDim2.new(0, 5, 0, (i-1) * 40)
    optFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    optFrame.Parent = SettingsScroller
    
    local optCorner = Instance.new("UICorner")
    optCorner.CornerRadius = UDim.new(0, 5)
    optCorner.Parent = optFrame
    
    local optLabel = Instance.new("TextLabel")
    optLabel.Size = UDim2.new(0.8, 0, 1, 0)
    optLabel.Position = UDim2.new(0.04, 0, 0, 0)
    optLabel.BackgroundTransparency = 1
    optLabel.Text = option
    optLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    optLabel.TextSize = 13
    optLabel.Font = Enum.Font.Gotham
    optLabel.TextXAlignment = Enum.TextXAlignment.Left
    optLabel.Parent = optFrame
    
    -- Toggle button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 28, 0, 28)
    toggleBtn.Position = UDim2.new(0.92, 0, 0.5, -14)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    toggleBtn.Text = "✓"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 16
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = optFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleBtn
    
    local toggled = true
    if i % 2 == 0 then
        toggled = false
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        toggleBtn.Text = ""
    end
    
    settingsToggles[option] = {toggleBtn, toggled}
    
    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        settingsToggles[option][2] = toggled
        if toggled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
            toggleBtn.Text = "✓"
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            toggleBtn.Text = ""
        end
        showToast(option .. " - " .. (toggled and "Enabled" or "Disabled"))
    end)
    
    optFrame.MouseButton1Click:Connect(function()
        toggleBtn.MouseButton1Click:Fire()
    end)
end

-- Toast Notification System
local ToastFrame = Instance.new("Frame")
ToastFrame.Size = UDim2.new(0, 280, 0, 40)
ToastFrame.Position = UDim2.new(0.5, -140, 1, -60)
ToastFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
ToastFrame.BackgroundTransparency = 1
ToastFrame.Parent = ScreenGui

local ToastCorner = Instance.new("UICorner")
ToastCorner.CornerRadius = UDim.new(0, 8)
ToastCorner.Parent = ToastFrame

local ToastLabel = Instance.new("TextLabel")
ToastLabel.Size = UDim2.new(1, 0, 1, 0)
ToastLabel.BackgroundTransparency = 1
ToastLabel.Text = ""
ToastLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToastLabel.TextSize = 14
ToastLabel.Font = Enum.Font.Gotham
ToastLabel.Parent = ToastFrame

local toastActive = false

function showToast(message)
    if toastActive then return end
    toastActive = true
    
    ToastLabel.Text = message
    ToastFrame.BackgroundTransparency = 0
    
    local tween1 = TweenService:Create(ToastFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -140, 0.9, -20)
    })
    tween1:Play()
    
    task.wait(2)
    
    local tween2 = TweenService:Create(ToastFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -140, 1, -60)
    })
    tween2:Play()
    tween2.Completed:Connect(function()
        ToastFrame.BackgroundTransparency = 1
        toastActive = false
    end)
end

-- Button Functions
ExecuteBtn.MouseButton1Click:Connect(function()
    local scriptText = ScriptBox.Text
    if scriptText == "" or scriptText == "Put Your Script Here..." then
        showToast("Please enter a script to execute!")
        return
    end
    
    local success, err = pcall(function()
        loadstring(scriptText)()
    end)
    
    if success then
        showToast("✓ Script executed successfully!")
    else
        showToast("✗ Error: " .. tostring(err))
    end
end)

ClearBtn.MouseButton1Click:Connect(function()
    ScriptBox.Text = ""
    showToast("Cleared!")
end)

CloseButton.MouseButton1Click:Connect(function()
    MainGUI.Visible = false
end)

-- DRAGGABLE ICON - MOBILE FRIENDLY
local dragging = false
local dragStartPos = nil
local dragStartMouse = nil
local lastTouchPos = nil

IconFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStartPos = IconFrame.Position
        dragStartMouse = input.Position
        lastTouchPos = input.Position
    end
end)

IconFrame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartMouse
        local newPos = UDim2.new(
            dragStartPos.X.Scale,
            dragStartPos.X.Offset + delta.X,
            dragStartPos.Y.Scale,
            dragStartPos.Y.Offset + delta.Y
        )
        -- Clamp position to screen
        newPos = UDim2.new(
            math.clamp(newPos.X.Scale, 0, 1 - (IconFrame.Size.X.Scale + 0.01)),
            math.clamp(newPos.X.Offset, 0, screenSizeX - IconFrame.Size.X.Offset - 10),
            math.clamp(newPos.Y.Scale, 0, 1 - (IconFrame.Size.Y.Scale + 0.01)),
            math.clamp(newPos.Y.Offset, 0, screenSizeY - IconFrame.Size.Y.Offset - 10)
        )
        IconFrame.Position = newPos
        lastTouchPos = input.Position
    end
end)

IconFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStartMouse
            -- If not dragged (just clicked), toggle GUI
            if delta.Magnitude < 10 then
                MainGUI.Visible = not MainGUI.Visible
                if MainGUI.Visible then
                    for _, b in pairs(tabButtons) do
                        b.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                    end
                    tabButtons["Editor"].BackgroundColor3 = Color3.fromRGB(0, 180, 255)
                    TabLabel.Text = "Your Current Tab: Editor"
                    ScriptBox.Visible = true
                    SettingsFrame.Visible = false
                end
            end
        end
        dragging = false
    end
end)

-- Keyboard shortcut
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainGUI.Visible = not MainGUI.Visible
        if MainGUI.Visible then
            for _, b in pairs(tabButtons) do
                b.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            end
            tabButtons["Editor"].BackgroundColor3 = Color3.fromRGB(0, 180, 255)
            TabLabel.Text = "Your Current Tab: Editor"
            ScriptBox.Visible = true
            SettingsFrame.Visible = false
        end
    end
end)

print("Hydrogen Executor Loaded! (Mobile Optimized)")
showToast("Hydrogen Executor Loaded!")
