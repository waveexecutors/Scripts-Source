-- Modern Mobile Dark-Mode Item Spawner Hub
-- Features: Draggable, Minimizable, Closable, Folder Navigation, Search, Loop/Glitch Spawner

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Prevent duplicate UI instances
if PlayerGui:FindFirstChild("ItemSpawnerHub") then
    PlayerGui.ItemSpawnerHub:Destroy()
end

-- State Variables
local CurrentMode = nil -- "Normal" or "Advanced"
local SelectedItem = nil
local IsLoopSpawning = false
local IsGlitchLooping = false

-- Theme Colors
local Theme = {
    Background = Color3.fromRGB(24, 24, 28),
    Secondary = Color3.fromRGB(32, 32, 38),
    Accent = Color3.fromRGB(90, 105, 246),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(160, 160, 170),
    Close = Color3.fromRGB(235, 75, 75),
    Minimize = Color3.fromRGB(240, 180, 50)
}

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ItemSpawnerHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Container Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 420)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -210)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainUICorner = Instance.new("UICorner", MainFrame)
MainUICorner.CornerRadius = UDim.new(0, 12)

-- Make Window Draggable (Mobile & PC Compatible)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Theme.Secondary
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner", TopBar)
TopBarCorner.CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -90, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Item Spawner Hub"
TitleLabel.TextColor3 = Theme.Text
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Minimize & Close Buttons
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -64, 0, 6)
MinimizeBtn.BackgroundColor3 = Theme.Minimize
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -32, 0, 6)
CloseBtn.BackgroundColor3 = Theme.Close
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Dragging Logic
local Dragging, DragInput, DragStart, StartPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)

-- Minimize Functionality
local IsMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Size = IsMinimized and UDim2.new(0, 360, 0, 40) or UDim2.new(0, 360, 0, 420)
    }):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

---------------------------------------------------------
-- SCREEN 1: Mode Selection Menu
---------------------------------------------------------
local ModeSelectFrame = Instance.new("Frame")
ModeSelectFrame.Size = UDim2.new(1, 0, 1, -40)
ModeSelectFrame.Position = UDim2.new(0, 0, 0, 40)
ModeSelectFrame.BackgroundTransparency = 1
ModeSelectFrame.Parent = MainFrame

local ModePrompt = Instance.new("TextLabel")
ModePrompt.Size = UDim2.new(1, -20, 0, 40)
ModePrompt.Position = UDim2.new(0, 10, 0, 40)
ModePrompt.BackgroundTransparency = 1
ModePrompt.Text = "Select Hub Execution Mode"
ModePrompt.TextColor3 = Theme.Text
ModePrompt.TextSize = 18
ModePrompt.Font = Enum.Font.GothamBold
ModePrompt.Parent = ModeSelectFrame

local NormalModeBtn = Instance.new("TextButton")
NormalModeBtn.Size = UDim2.new(0.8, 0, 0, 50)
NormalModeBtn.Position = UDim2.new(0.1, 0, 0, 110)
NormalModeBtn.BackgroundColor3 = Theme.Accent
NormalModeBtn.Text = "Normal Mode\n(Mythical Claim)"
NormalModeBtn.TextColor3 = Theme.Text
NormalModeBtn.Font = Enum.Font.GothamBold
NormalModeBtn.TextSize = 14
NormalModeBtn.Parent = ModeSelectFrame
Instance.new("UICorner", NormalModeBtn).CornerRadius = UDim.new(0, 8)

local AdvancedModeBtn = Instance.new("TextButton")
AdvancedModeBtn.Size = UDim2.new(0.8, 0, 0, 50)
AdvancedModeBtn.Position = UDim2.new(0.1, 0, 0, 180)
AdvancedModeBtn.BackgroundColor3 = Theme.Secondary
AdvancedModeBtn.Text = "Advanced Mode\n(Common / Normal Claim)"
AdvancedModeBtn.TextColor3 = Theme.Text
AdvancedModeBtn.Font = Enum.Font.GothamBold
AdvancedModeBtn.TextSize = 14
AdvancedModeBtn.Parent = ModeSelectFrame
Instance.new("UICorner", AdvancedModeBtn).CornerRadius = UDim.new(0, 8)

---------------------------------------------------------
-- SCREEN 2: Explorer Screen
---------------------------------------------------------
local ExplorerFrame = Instance.new("Frame")
ExplorerFrame.Size = UDim2.new(1, 0, 1, -40)
ExplorerFrame.Position = UDim2.new(0, 0, 0, 40)
ExplorerFrame.BackgroundTransparency = 1
ExplorerFrame.Visible = false
ExplorerFrame.Parent = MainFrame

local ItemScroll = Instance.new("ScrollingFrame")
ItemScroll.Size = UDim2.new(1, -20, 1, -20)
ItemScroll.Position = UDim2.new(0, 10, 0, 10)
ItemScroll.BackgroundTransparency = 1
ItemScroll.BorderSizePixel = 0
ItemScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ItemScroll.ScrollBarThickness = 6
ItemScroll.Parent = ExplorerFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ItemScroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ItemScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

---------------------------------------------------------
-- SCREEN 3: Function Action Menu
---------------------------------------------------------
local ActionFrame = Instance.new("Frame")
ActionFrame.Size = UDim2.new(1, 0, 1, -40)
ActionFrame.Position = UDim2.new(0, 0, 0, 40)
ActionFrame.BackgroundTransparency = 1
ActionFrame.Visible = false
ActionFrame.Parent = MainFrame

local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0, 70, 0, 30)
BackBtn.Position = UDim2.new(0, 10, 0, 10)
BackBtn.BackgroundColor3 = Theme.Secondary
BackBtn.Text = "< Back"
BackBtn.TextColor3 = Theme.Text
BackBtn.Font = Enum.Font.Gotham
BackBtn.TextSize = 12
BackBtn.Parent = ActionFrame
Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0, 6)

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, -20, 0, 30)
TargetLabel.Position = UDim2.new(0, 10, 0, 50)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Selected: None"
TargetLabel.TextColor3 = Theme.Accent
TargetLabel.TextSize = 14
TargetLabel.Font = Enum.Font.GothamBold
TargetLabel.Parent = ActionFrame

-- Action Buttons
local SpawnOnceBtn = Instance.new("TextButton")
SpawnOnceBtn.Size = UDim2.new(0.9, 0, 0, 40)
SpawnOnceBtn.Position = UDim2.new(0.05, 0, 0, 95)
SpawnOnceBtn.BackgroundColor3 = Theme.Secondary
SpawnOnceBtn.Text = "Spawn Once"
SpawnOnceBtn.TextColor3 = Theme.Text
SpawnOnceBtn.Font = Enum.Font.Gotham
SpawnOnceBtn.TextSize = 14
SpawnOnceBtn.Parent = ActionFrame
Instance.new("UICorner", SpawnOnceBtn).CornerRadius = UDim.new(0, 6)

local LoopToggleBtn = Instance.new("TextButton")
LoopToggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
LoopToggleBtn.Position = UDim2.new(0.05, 0, 0, 145)
LoopToggleBtn.BackgroundColor3 = Theme.Secondary
LoopToggleBtn.Text = "Loop Spawn: OFF"
LoopToggleBtn.TextColor3 = Theme.Text
LoopToggleBtn.Font = Enum.Font.Gotham
LoopToggleBtn.TextSize = 14
LoopToggleBtn.Parent = ActionFrame
Instance.new("UICorner", LoopToggleBtn).CornerRadius = UDim.new(0, 6)

local GlitchOnceBtn = Instance.new("TextButton")
GlitchOnceBtn.Size = UDim2.new(0.9, 0, 0, 40)
GlitchOnceBtn.Position = UDim2.new(0.05, 0, 0, 195)
GlitchOnceBtn.BackgroundColor3 = Theme.Secondary
GlitchOnceBtn.Text = "Spawn 1x (Glitch Name)"
GlitchOnceBtn.TextColor3 = Theme.Text
GlitchOnceBtn.Font = Enum.Font.Gotham
GlitchOnceBtn.TextSize = 14
GlitchOnceBtn.Parent = ActionFrame
Instance.new("UICorner", GlitchOnceBtn).CornerRadius = UDim.new(0, 6)

local GlitchLoopBtn = Instance.new("TextButton")
GlitchLoopBtn.Size = UDim2.new(0.9, 0, 0, 40)
GlitchLoopBtn.Position = UDim2.new(0.05, 0, 0, 245)
GlitchLoopBtn.BackgroundColor3 = Theme.Secondary
GlitchLoopBtn.Text = "Glitch Loop Spawn: OFF"
GlitchLoopBtn.TextColor3 = Theme.Text
GlitchLoopBtn.Font = Enum.Font.Gotham
GlitchLoopBtn.TextSize = 14
GlitchLoopBtn.Parent = ActionFrame
Instance.new("UICorner", GlitchLoopBtn).CornerRadius = UDim.new(0, 6)

---------------------------------------------------------
-- Helper Functions & Logic
---------------------------------------------------------

-- Helper to produce randomized glitch text strings
local function GenerateGlitchName(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+"
    local result = ""
    for i = 1, length or math.random(6, 14) do
        local randIndex = math.random(1, #chars)
        result = result .. string.sub(chars, randIndex, randIndex)
    end
    return result
end

-- Fire Remote Event Logic
local function ExecuteSpawn(itemName)
    local Event = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("ClaimHatchedItem")
    if not Event then
        warn("ClaimHatchedItem RemoteEvent missing in ReplicatedStorage.Events!")
        return
    end

    if CurrentMode == "Normal" then
        Event:FireServer(itemName, "Mythical")
    elseif CurrentMode == "Advanced" then
        Event:FireServer(itemName, "Common", "Normal")
    end
end

-- Open Action Panel for Selected Object
local function OpenActionPanel(object)
    SelectedItem = object
    TargetLabel.Text = "Target: " .. object.Name
    ExplorerFrame.Visible = false
    ActionFrame.Visible = true
end

-- Find Items Folder in ReplicatedStorage
local function LocateItemsFolder()
    for _, child in ipairs(ReplicatedStorage:GetChildren()) do
        if child.Name:lower():find("item") or child.Name:lower():find("ite") then
            return child
        end
    end
    return nil
end

-- Populate Explorer UI
local function PopulateFolder(parentInstance)
    for _, child in ipairs(ItemScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for _, child in ipairs(parentInstance:GetChildren()) do
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 36)
        Btn.BackgroundColor3 = Theme.Secondary
        Btn.TextColor3 = Theme.Text
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 13
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.Parent = ItemScroll
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

        -- Add padding visually
        local Padding = Instance.new("UIPadding", Btn)
        Padding.PaddingLeft = UDim.new(0, 12)

        if child:IsA("Folder") or child:IsA("Model") and #child:GetChildren() > 0 then
            Btn.Text = "📁 " .. child.Name
            Btn.MouseButton1Click:Connect(function()
                PopulateFolder(child)
            end)
        else
            Btn.Text = "📄 " .. child.Name
            Btn.MouseButton1Click:Connect(function()
                OpenActionPanel(child)
            end)
        end
    end
end

-- Launch Hub Function
local function LaunchHub(mode)
    CurrentMode = mode
    TitleLabel.Text = "Spawner Hub [" .. mode .. " Mode]"
    ModeSelectFrame.Visible = false
    ExplorerFrame.Visible = true

    local ItemsFolder = LocateItemsFolder()
    if ItemsFolder then
        PopulateFolder(ItemsFolder)
    else
        local ErrorMsg = Instance.new("TextLabel")
        ErrorMsg.Size = UDim2.new(1, 0, 0, 40)
        ErrorMsg.BackgroundTransparency = 1
        ErrorMsg.Text = "No 'Items' folder located in ReplicatedStorage."
        ErrorMsg.TextColor3 = Theme.Close
        ErrorMsg.Font = Enum.Font.Gotham
        ErrorMsg.Parent = ItemScroll
    end
end

---------------------------------------------------------
-- Event Connections
---------------------------------------------------------

NormalModeBtn.MouseButton1Click:Connect(function() LaunchHub("Normal") end)
AdvancedModeBtn.MouseButton1Click:Connect(function() LaunchHub("Advanced") end)

BackBtn.MouseButton1Click:Connect(function()
    ActionFrame.Visible = false
    ExplorerFrame.Visible = true
    IsLoopSpawning = false
    IsGlitchLooping = false
    LoopToggleBtn.Text = "Loop Spawn: OFF"
    LoopToggleBtn.BackgroundColor3 = Theme.Secondary
    GlitchLoopBtn.Text = "Glitch Loop Spawn: OFF"
    GlitchLoopBtn.BackgroundColor3 = Theme.Secondary
end)

-- Action Execution Listeners
SpawnOnceBtn.MouseButton1Click:Connect(function()
    if SelectedItem then
        ExecuteSpawn(SelectedItem.Name)
    end
end)

LoopToggleBtn.MouseButton1Click:Connect(function()
    IsLoopSpawning = not IsLoopSpawning
    LoopToggleBtn.Text = "Loop Spawn: " .. (IsLoopSpawning and "ON" or "OFF")
    LoopToggleBtn.BackgroundColor3 = IsLoopSpawning and Theme.Accent or Theme.Secondary

    task.spawn(function()
        while IsLoopSpawning and SelectedItem do
            ExecuteSpawn(SelectedItem.Name)
            task.wait(0.1)
        end
    end)
end)

GlitchOnceBtn.MouseButton1Click:Connect(function()
    ExecuteSpawn(GenerateGlitchName())
end)

GlitchLoopBtn.MouseButton1Click:Connect(function()
    IsGlitchLooping = not IsGlitchLooping
    GlitchLoopBtn.Text = "Glitch Loop Spawn: " .. (IsGlitchLooping and "ON" or "OFF")
    GlitchLoopBtn.BackgroundColor3 = IsGlitchLooping and Theme.Accent or Theme.Secondary

    task.spawn(function()
        while IsGlitchLooping do
            ExecuteSpawn(GenerateGlitchName())
            task.wait(0.1)
        end
    end)
end)
