-- Enhanced Multi-Exploit Item Spawner Hub
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("ItemSpawnerHub") then
    PlayerGui.ItemSpawnerHub:Destroy()
end

-- Exploit Detection & Anti-Ban
local function AntiBan()
    -- Prevent common anti-exploit triggers
    local success, err = pcall(function()
        -- Disable error reporting if exists
        if ReplicatedStorage:FindFirstChild("_CodingBloxErrorReport") then
            ReplicatedStorage._CodingBloxErrorReport:Destroy()
        end
    end)
end
AntiBan()

local CurrentMode = nil
local SelectedItem = nil
local CurrentFolder = nil
local IsLoopSpawning = false
local IsGlitchLooping = false
local IsGlobalSpawning = false
local IsAdminSpawning = false
local IsMoneySpawning = false
local IsRebirthSpawning = false

-- Theme
local Theme = {
    Background = Color3.fromRGB(24, 24, 28),
    Secondary = Color3.fromRGB(32, 32, 38),
    Accent = Color3.fromRGB(90, 105, 246),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(160, 160, 170),
    Close = Color3.fromRGB(235, 75, 75),
    Minimize = Color3.fromRGB(240, 180, 50),
    Green = Color3.fromRGB(75, 235, 75),
    Purple = Color3.fromRGB(180, 75, 235)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ItemSpawnerHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 520)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- TopBar (same as before)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Theme.Secondary
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -90, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Mega Exploit Hub"
TitleLabel.TextColor3 = Theme.Text
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Minimize/Close buttons (same as before)
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

-- Dragging (same as before)
local Dragging, DragInput, DragStart, StartPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then Dragging = false end
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

local IsMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Size = IsMinimized and UDim2.new(0, 380, 0, 40) or UDim2.new(0, 380, 0, 520)
    }):Play()
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

---------------------------------------------------------
-- EXPLOIT SELECTION SCREEN
---------------------------------------------------------
local ExploitSelectFrame = Instance.new("Frame")
ExploitSelectFrame.Size = UDim2.new(1, 0, 1, -40)
ExploitSelectFrame.Position = UDim2.new(0, 0, 0, 40)
ExploitSelectFrame.BackgroundTransparency = 1
ExploitSelectFrame.Parent = MainFrame

local ExploitPrompt = Instance.new("TextLabel")
ExploitPrompt.Size = UDim2.new(1, -20, 0, 40)
ExploitPrompt.Position = UDim2.new(0, 10, 0, 20)
ExploitPrompt.BackgroundTransparency = 1
ExploitPrompt.Text = "Select Exploit Method"
ExploitPrompt.TextColor3 = Theme.Text
ExploitPrompt.TextSize = 18
ExploitPrompt.Font = Enum.Font.GothamBold
ExploitPrompt.Parent = ExploitSelectFrame

-- Item Spawn Button
local ItemSpawnBtn = Instance.new("TextButton")
ItemSpawnBtn.Size = UDim2.new(0.9, 0, 0, 45)
ItemSpawnBtn.Position = UDim2.new(0.05, 0, 0, 80)
ItemSpawnBtn.BackgroundColor3 = Theme.Accent
ItemSpawnBtn.Text = "📦 Item Spawner"
ItemSpawnBtn.TextColor3 = Theme.Text
ItemSpawnBtn.Font = Enum.Font.GothamBold
ItemSpawnBtn.TextSize = 14
ItemSpawnBtn.Parent = ExploitSelectFrame
Instance.new("UICorner", ItemSpawnBtn).CornerRadius = UDim.new(0, 8)

-- Admin Exploit Button
local AdminExploitBtn = Instance.new("TextButton")
AdminExploitBtn.Size = UDim2.new(0.9, 0, 0, 45)
AdminExploitBtn.Position = UDim2.new(0.05, 0, 0, 135)
AdminExploitBtn.BackgroundColor3 = Theme.Purple
AdminExploitBtn.Text = "🔑 Admin Exploits"
AdminExploitBtn.TextColor3 = Theme.Text
AdminExploitBtn.Font = Enum.Font.GothamBold
AdminExploitBtn.TextSize = 14
AdminExploitBtn.Parent = ExploitSelectFrame
Instance.new("UICorner", AdminExploitBtn).CornerRadius = UDim.new(0, 8)

-- Money Exploit Button
local MoneyExploitBtn = Instance.new("TextButton")
MoneyExploitBtn.Size = UDim2.new(0.9, 0, 0, 45)
MoneyExploitBtn.Position = UDim2.new(0.05, 0, 0, 190)
MoneyExploitBtn.BackgroundColor3 = Theme.Green
MoneyExploitBtn.Text = "💰 Money Exploits"
MoneyExploitBtn.TextColor3 = Theme.Text
MoneyExploitBtn.Font = Enum.Font.GothamBold
MoneyExploitBtn.TextSize = 14
MoneyExploitBtn.Parent = ExploitSelectFrame
Instance.new("UICorner", MoneyExploitBtn).CornerRadius = UDim.new(0, 8)

-- Rebirth Exploit Button
local RebirthExploitBtn = Instance.new("TextButton")
RebirthExploitBtn.Size = UDim2.new(0.9, 0, 0, 45)
RebirthExploitBtn.Position = UDim2.new(0.05, 0, 0, 245)
RebirthExploitBtn.BackgroundColor3 = Theme.Accent
RebirthExploitBtn.Text = "🔄 Rebirth Exploits"
RebirthExploitBtn.TextColor3 = Theme.Text
RebirthExploitBtn.Font = Enum.Font.GothamBold
RebirthExploitBtn.TextSize = 14
RebirthExploitBtn.Parent = ExploitSelectFrame
Instance.new("UICorner", RebirthExploitBtn).CornerRadius = UDim.new(0, 8)

-- Global Exploit Button
local GlobalExploitBtn = Instance.new("TextButton")
GlobalExploitBtn.Size = UDim2.new(0.9, 0, 0, 45)
GlobalExploitBtn.Position = UDim2.new(0.05, 0, 0, 300)
GlobalExploitBtn.BackgroundColor3 = Color3.fromRGB(235, 75, 180)
GlobalExploitBtn.Text = "🌐 Global Exploits"
GlobalExploitBtn.TextColor3 = Theme.Text
GlobalExploitBtn.Font = Enum.Font.GothamBold
GlobalExploitBtn.TextSize = 14
GlobalExploitBtn.Parent = ExploitSelectFrame
Instance.new("UICorner", GlobalExploitBtn).CornerRadius = UDim.new(0, 8)

---------------------------------------------------------
-- ITEM SPAWNER SCREEN (Original)
---------------------------------------------------------
local ItemSpawnerFrame = Instance.new("Frame")
ItemSpawnerFrame.Size = UDim2.new(1, 0, 1, -40)
ItemSpawnerFrame.Position = UDim2.new(0, 0, 0, 40)
ItemSpawnerFrame.BackgroundTransparency = 1
ItemSpawnerFrame.Visible = false
ItemSpawnerFrame.Parent = MainFrame

local ItemBackBtn = Instance.new("TextButton")
ItemBackBtn.Size = UDim2.new(0, 70, 0, 30)
ItemBackBtn.Position = UDim2.new(0, 10, 0, 10)
ItemBackBtn.BackgroundColor3 = Theme.Secondary
ItemBackBtn.Text = "< Back"
ItemBackBtn.TextColor3 = Theme.Text
ItemBackBtn.Font = Enum.Font.Gotham
ItemBackBtn.TextSize = 12
ItemBackBtn.Parent = ItemSpawnerFrame
Instance.new("UICorner", ItemBackBtn).CornerRadius = UDim.new(0, 6)

local ItemExplorerFrame = Instance.new("Frame")
ItemExplorerFrame.Size = UDim2.new(1, 0, 1, -50)
ItemExplorerFrame.Position = UDim2.new(0, 0, 0, 50)
ItemExplorerFrame.BackgroundTransparency = 1
ItemExplorerFrame.Parent = ItemSpawnerFrame

local ItemNavHeader = Instance.new("Frame")
ItemNavHeader.Size = UDim2.new(1, -20, 0, 30)
ItemNavHeader.Position = UDim2.new(0, 10, 0, 0)
ItemNavHeader.BackgroundTransparency = 1
ItemNavHeader.Parent = ItemExplorerFrame

local ItemFolderBackBtn = Instance.new("TextButton")
ItemFolderBackBtn.Size = UDim2.new(0, 60, 1, 0)
ItemFolderBackBtn.BackgroundColor3 = Theme.Secondary
ItemFolderBackBtn.Text = "< Back"
ItemFolderBackBtn.TextColor3 = Theme.Text
ItemFolderBackBtn.Font = Enum.Font.Gotham
ItemFolderBackBtn.TextSize = 12
ItemFolderBackBtn.Parent = ItemNavHeader
Instance.new("UICorner", ItemFolderBackBtn).CornerRadius = UDim.new(0, 6)

local ItemFolderPathLabel = Instance.new("TextLabel")
ItemFolderPathLabel.Size = UDim2.new(1, -70, 1, 0)
ItemFolderPathLabel.Position = UDim2.new(0, 70, 0, 0)
ItemFolderPathLabel.BackgroundTransparency = 1
ItemFolderPathLabel.Text = "Items/"
ItemFolderPathLabel.TextColor3 = Theme.TextDark
ItemFolderPathLabel.TextSize = 13
ItemFolderPathLabel.Font = Enum.Font.Gotham
ItemFolderPathLabel.TextXAlignment = Enum.TextXAlignment.Left
ItemFolderPathLabel.Parent = ItemNavHeader

local ItemScroll = Instance.new("ScrollingFrame")
ItemScroll.Size = UDim2.new(1, -20, 1, -40)
ItemScroll.Position = UDim2.new(0, 10, 0, 35)
ItemScroll.BackgroundTransparency = 1
ItemScroll.BorderSizePixel = 0
ItemScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ItemScroll.ScrollBarThickness = 6
ItemScroll.Parent = ItemExplorerFrame

local ItemUIListLayout = Instance.new("UIListLayout")
ItemUIListLayout.Parent = ItemScroll
ItemUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ItemUIListLayout.Padding = UDim.new(0, 6)

ItemUIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ItemScroll.CanvasSize = UDim2.new(0, 0, 0, ItemUIListLayout.AbsoluteContentSize.Y + 10)
end)

---------------------------------------------------------
-- ACTION SCREEN FOR ITEMS
---------------------------------------------------------
local ItemActionFrame = Instance.new("Frame")
ItemActionFrame.Size = UDim2.new(1, 0, 1, -50)
ItemActionFrame.Position = UDim2.new(0, 0, 0, 50)
ItemActionFrame.BackgroundTransparency = 1
ItemActionFrame.Visible = false
ItemActionFrame.Parent = ItemSpawnerFrame

local ItemActionBackBtn = Instance.new("TextButton")
ItemActionBackBtn.Size = UDim2.new(0, 70, 0, 30)
ItemActionBackBtn.Position = UDim2.new(0, 10, 0, 10)
ItemActionBackBtn.BackgroundColor3 = Theme.Secondary
ItemActionBackBtn.Text = "< Back"
ItemActionBackBtn.TextColor3 = Theme.Text
ItemActionBackBtn.Font = Enum.Font.Gotham
ItemActionBackBtn.TextSize = 12
ItemActionBackBtn.Parent = ItemActionFrame
Instance.new("UICorner", ItemActionBackBtn).CornerRadius = UDim.new(0, 6)

local ItemTargetLabel = Instance.new("TextLabel")
ItemTargetLabel.Size = UDim2.new(1, -20, 0, 30)
ItemTargetLabel.Position = UDim2.new(0, 10, 0, 50)
ItemTargetLabel.BackgroundTransparency = 1
ItemTargetLabel.Text = "Selected: None"
ItemTargetLabel.TextColor3 = Theme.Accent
ItemTargetLabel.TextSize = 14
ItemTargetLabel.Font = Enum.Font.GothamBold
ItemTargetLabel.Parent = ItemActionFrame

local ItemGlobalToggle = Instance.new("TextButton")
ItemGlobalToggle.Size = UDim2.new(0.9, 0, 0, 30)
ItemGlobalToggle.Position = UDim2.new(0.05, 0, 0, 88)
ItemGlobalToggle.BackgroundColor3 = Theme.Secondary
ItemGlobalToggle.Text = "Give To Everyone: OFF"
ItemGlobalToggle.TextColor3 = Theme.Text
ItemGlobalToggle.Font = Enum.Font.Gotham
ItemGlobalToggle.TextSize = 12
ItemGlobalToggle.Parent = ItemActionFrame
Instance.new("UICorner", ItemGlobalToggle).CornerRadius = UDim.new(0, 6)

local ItemSpawnOnceBtn = Instance.new("TextButton")
ItemSpawnOnceBtn.Size = UDim2.new(0.9, 0, 0, 35)
ItemSpawnOnceBtn.Position = UDim2.new(0.05, 0, 0, 128)
ItemSpawnOnceBtn.BackgroundColor3 = Theme.Secondary
ItemSpawnOnceBtn.Text = "Spawn Once"
ItemSpawnOnceBtn.TextColor3 = Theme.Text
ItemSpawnOnceBtn.Font = Enum.Font.Gotham
ItemSpawnOnceBtn.TextSize = 14
ItemSpawnOnceBtn.Parent = ItemActionFrame
Instance.new("UICorner", ItemSpawnOnceBtn).CornerRadius = UDim.new(0, 6)

local ItemLoopToggle = Instance.new("TextButton")
ItemLoopToggle.Size = UDim2.new(0.9, 0, 0, 35)
ItemLoopToggle.Position = UDim2.new(0.05, 0, 0, 173)
ItemLoopToggle.BackgroundColor3 = Theme.Secondary
ItemLoopToggle.Text = "Loop Spawn: OFF"
ItemLoopToggle.TextColor3 = Theme.Text
ItemLoopToggle.Font = Enum.Font.Gotham
ItemLoopToggle.TextSize = 14
ItemLoopToggle.Parent = ItemActionFrame
Instance.new("UICorner", ItemLoopToggle).CornerRadius = UDim.new(0, 6)

local ItemGlitchOnceBtn = Instance.new("TextButton")
ItemGlitchOnceBtn.Size = UDim2.new(0.9, 0, 0, 35)
ItemGlitchOnceBtn.Position = UDim2.new(0.05, 0, 0, 218)
ItemGlitchOnceBtn.BackgroundColor3 = Theme.Secondary
ItemGlitchOnceBtn.Text = "Spawn 1x (Glitch Name)"
ItemGlitchOnceBtn.TextColor3 = Theme.Text
ItemGlitchOnceBtn.Font = Enum.Font.Gotham
ItemGlitchOnceBtn.TextSize = 14
ItemGlitchOnceBtn.Parent = ItemActionFrame
Instance.new("UICorner", ItemGlitchOnceBtn).CornerRadius = UDim.new(0, 6)

local ItemGlitchLoopBtn = Instance.new("TextButton")
ItemGlitchLoopBtn.Size = UDim2.new(0.9, 0, 0, 35)
ItemGlitchLoopBtn.Position = UDim2.new(0.05, 0, 0, 263)
ItemGlitchLoopBtn.BackgroundColor3 = Theme.Secondary
ItemGlitchLoopBtn.Text = "Glitch Loop Spawn: OFF"
ItemGlitchLoopBtn.TextColor3 = Theme.Text
ItemGlitchLoopBtn.Font = Enum.Font.Gotham
ItemGlitchLoopBtn.TextSize = 14
ItemGlitchLoopBtn.Parent = ItemActionFrame
Instance.new("UICorner", ItemGlitchLoopBtn).CornerRadius = UDim.new(0, 6)

---------------------------------------------------------
-- ADMIN EXPLOITS SCREEN
---------------------------------------------------------
local AdminFrame = Instance.new("Frame")
AdminFrame.Size = UDim2.new(1, 0, 1, -40)
AdminFrame.Position = UDim2.new(0, 0, 0, 40)
AdminFrame.BackgroundTransparency = 1
AdminFrame.Visible = false
AdminFrame.Parent = MainFrame

local AdminBackBtn = Instance.new("TextButton")
AdminBackBtn.Size = UDim2.new(0, 70, 0, 30)
AdminBackBtn.Position = UDim2.new(0, 10, 0, 10)
AdminBackBtn.BackgroundColor3 = Theme.Secondary
AdminBackBtn.Text = "< Back"
AdminBackBtn.TextColor3 = Theme.Text
AdminBackBtn.Font = Enum.Font.Gotham
AdminBackBtn.TextSize = 12
AdminBackBtn.Parent = AdminFrame
Instance.new("UICorner", AdminBackBtn).CornerRadius = UDim.new(0, 6)

local AdminScroll = Instance.new("ScrollingFrame")
AdminScroll.Size = UDim2.new(1, -20, 1, -50)
AdminScroll.Position = UDim2.new(0, 10, 0, 50)
AdminScroll.BackgroundTransparency = 1
AdminScroll.BorderSizePixel = 0
AdminScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
AdminScroll.ScrollBarThickness = 6
AdminScroll.Parent = AdminFrame

local AdminUIList = Instance.new("UIListLayout")
AdminUIList.Parent = AdminScroll
AdminUIList.SortOrder = Enum.SortOrder.LayoutOrder
AdminUIList.Padding = UDim.new(0, 6)

AdminUIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    AdminScroll.CanvasSize = UDim2.new(0, 0, 0, AdminUIList.AbsoluteContentSize.Y + 10)
end)

local function CreateAdminButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Theme.Secondary
    Btn.Text = text
    Btn.TextColor3 = Theme.Text
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.Parent = AdminScroll
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

---------------------------------------------------------
-- MONEY EXPLOITS SCREEN
---------------------------------------------------------
local MoneyFrame = Instance.new("Frame")
MoneyFrame.Size = UDim2.new(1, 0, 1, -40)
MoneyFrame.Position = UDim2.new(0, 0, 0, 40)
MoneyFrame.BackgroundTransparency = 1
MoneyFrame.Visible = false
MoneyFrame.Parent = MainFrame

local MoneyBackBtn = Instance.new("TextButton")
MoneyBackBtn.Size = UDim2.new(0, 70, 0, 30)
MoneyBackBtn.Position = UDim2.new(0, 10, 0, 10)
MoneyBackBtn.BackgroundColor3 = Theme.Secondary
MoneyBackBtn.Text = "< Back"
MoneyBackBtn.TextColor3 = Theme.Text
MoneyBackBtn.Font = Enum.Font.Gotham
MoneyBackBtn.TextSize = 12
MoneyBackBtn.Parent = MoneyFrame
Instance.new("UICorner", MoneyBackBtn).CornerRadius = UDim.new(0, 6)

local MoneyScroll = Instance.new("ScrollingFrame")
MoneyScroll.Size = UDim2.new(1, -20, 1, -50)
MoneyScroll.Position = UDim2.new(0, 10, 0, 50)
MoneyScroll.BackgroundTransparency = 1
MoneyScroll.BorderSizePixel = 0
MoneyScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
MoneyScroll.ScrollBarThickness = 6
MoneyScroll.Parent = MoneyFrame

local MoneyUIList = Instance.new("UIListLayout")
MoneyUIList.Parent = MoneyScroll
MoneyUIList.SortOrder = Enum.SortOrder.LayoutOrder
MoneyUIList.Padding = UDim.new(0, 6)

MoneyUIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    MoneyScroll.CanvasSize = UDim2.new(0, 0, 0, MoneyUIList.AbsoluteContentSize.Y + 10)
end)

local function CreateMoneyButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Theme.Secondary
    Btn.Text = text
    Btn.TextColor3 = Theme.Text
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.Parent = MoneyScroll
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

---------------------------------------------------------
-- REBIRTH EXPLOITS SCREEN
---------------------------------------------------------
local RebirthFrame = Instance.new("Frame")
RebirthFrame.Size = UDim2.new(1, 0, 1, -40)
RebirthFrame.Position = UDim2.new(0, 0, 0, 40)
RebirthFrame.BackgroundTransparency = 1
RebirthFrame.Visible = false
RebirthFrame.Parent = MainFrame

local RebirthBackBtn = Instance.new("TextButton")
RebirthBackBtn.Size = UDim2.new(0, 70, 0, 30)
RebirthBackBtn.Position = UDim2.new(0, 10, 0, 10)
RebirthBackBtn.BackgroundColor3 = Theme.Secondary
RebirthBackBtn.Text = "< Back"
RebirthBackBtn.TextColor3 = Theme.Text
RebirthBackBtn.Font = Enum.Font.Gotham
RebirthBackBtn.TextSize = 12
RebirthBackBtn.Parent = RebirthFrame
Instance.new("UICorner", RebirthBackBtn).CornerRadius = UDim.new(0, 6)

local RebirthScroll = Instance.new("ScrollingFrame")
RebirthScroll.Size = UDim2.new(1, -20, 1, -50)
RebirthScroll.Position = UDim2.new(0, 10, 0, 50)
RebirthScroll.BackgroundTransparency = 1
RebirthScroll.BorderSizePixel = 0
RebirthScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
RebirthScroll.ScrollBarThickness = 6
RebirthScroll.Parent = RebirthFrame

local RebirthUIList = Instance.new("UIListLayout")
RebirthUIList.Parent = RebirthScroll
RebirthUIList.SortOrder = Enum.SortOrder.LayoutOrder
RebirthUIList.Padding = UDim.new(0, 6)

RebirthUIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    RebirthScroll.CanvasSize = UDim2.new(0, 0, 0, RebirthUIList.AbsoluteContentSize.Y + 10)
end)

local function CreateRebirthButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Theme.Secondary
    Btn.Text = text
    Btn.TextColor3 = Theme.Text
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.Parent = RebirthScroll
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

---------------------------------------------------------
-- GLOBAL EXPLOITS SCREEN
---------------------------------------------------------
local GlobalFrame = Instance.new("Frame")
GlobalFrame.Size = UDim2.new(1, 0, 1, -40)
GlobalFrame.Position = UDim2.new(0, 0, 0, 40)
GlobalFrame.BackgroundTransparency = 1
GlobalFrame.Visible = false
GlobalFrame.Parent = MainFrame

local GlobalBackBtn = Instance.new("TextButton")
GlobalBackBtn.Size = UDim2.new(0, 70, 0, 30)
GlobalBackBtn.Position = UDim2.new(0, 10, 0, 10)
GlobalBackBtn.BackgroundColor3 = Theme.Secondary
GlobalBackBtn.Text = "< Back"
GlobalBackBtn.TextColor3 = Theme.Text
GlobalBackBtn.Font = Enum.Font.Gotham
GlobalBackBtn.TextSize = 12
GlobalBackBtn.Parent = GlobalFrame
Instance.new("UICorner", GlobalBackBtn).CornerRadius = UDim.new(0, 6)

local GlobalScroll = Instance.new("ScrollingFrame")
GlobalScroll.Size = UDim2.new(1, -20, 1, -50)
GlobalScroll.Position = UDim2.new(0, 10, 0, 50)
GlobalScroll.BackgroundTransparency = 1
GlobalScroll.BorderSizePixel = 0
GlobalScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
GlobalScroll.ScrollBarThickness = 6
GlobalScroll.Parent = GlobalFrame

local GlobalUIList = Instance.new("UIListLayout")
GlobalUIList.Parent = GlobalScroll
GlobalUIList.SortOrder = Enum.SortOrder.LayoutOrder
GlobalUIList.Padding = UDim.new(0, 6)

GlobalUIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    GlobalScroll.CanvasSize = UDim2.new(0, 0, 0, GlobalUIList.AbsoluteContentSize.Y + 10)
end)

local function CreateGlobalButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Theme.Secondary
    Btn.Text = text
    Btn.TextColor3 = Theme.Text
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.Parent = GlobalScroll
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

---------------------------------------------------------
-- EXPLOIT LOGIC
---------------------------------------------------------

-- Helper function to find remote events
local function FindRemoteEvent(name)
    local Events = ReplicatedStorage:FindFirstChild("Events")
    if Events then
        local event = Events:FindFirstChild(name)
        if event then return event end
    end
    
    -- Check AdminEventRemotes
    local AdminRemotes = ReplicatedStorage:FindFirstChild("AdminEventRemotes")
    if AdminRemotes then
        local event = AdminRemotes:FindFirstChild(name)
        if event then return event end
    end
    
    -- Check all of ReplicatedStorage
    return ReplicatedStorage:FindFirstChild(name)
end

-- ITEM SPAWNER LOGIC
local SelectedSpawnItem = nil
local IsItemLoopSpawning = false
local IsItemGlitchLooping = false
local IsItemGlobalSpawning = false

local function GenerateGlitchName(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+"
    local result = ""
    for _ = 1, length or math.random(6, 14) do
        local randIndex = math.random(1, #chars)
        result = result .. string.sub(chars, randIndex, randIndex)
    end
    return result
end

local function ExecuteSpawnForPlayer(player, itemName)
    local Event = FindRemoteEvent("ClaimHatchedItem")
    if not Event then return false end
    
    -- Try different methods
    local success = false
    
    -- Method 1: Try with player argument
    local success1 = pcall(function()
        Event:FireServer(itemName, "Mythical", player)
    end)
    if success1 then success = true end
    
    -- Method 2: Try different format
    if not success then
        local success2 = pcall(function()
            Event:FireServer(itemName, "Mythical", "Normal", player)
        end)
        if success2 then success = true end
    end
    
    -- Method 3: Try with just the player
    if not success then
        local success3 = pcall(function()
            Event:FireServer(player, itemName)
        end)
        if success3 then success = true end
    end
    
    return success
end

local function ExecuteSpawn(itemName, giveToEveryone)
    local Event = FindRemoteEvent("ClaimHatchedItem")
    if not Event then return false end

    if giveToEveryone then
        local playerList = Players:GetPlayers()
        for _, player in ipairs(playerList) do
            if player and player:IsA("Player") and player.Parent then
                ExecuteSpawnForPlayer(player, itemName)
            end
        end
        return true
    else
        local success = pcall(function()
            Event:FireServer(itemName, "Mythical")
        end)
        return success
    end
end

local function PopulateItems(folderInstance)
    local currentFolder = folderInstance
    ItemFolderPathLabel.Text = folderInstance:GetFullName():gsub("ReplicatedStorage%.", "")

    for _, child in ipairs(ItemScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for _, child in ipairs(folderInstance:GetChildren()) do
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 36)
        Btn.BackgroundColor3 = Theme.Secondary
        Btn.TextColor3 = Theme.Text
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 13
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.Parent = ItemScroll
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

        local Padding = Instance.new("UIPadding", Btn)
        Padding.PaddingLeft = UDim.new(0, 12)

        if child:IsA("Folder") then
            Btn.Text = "📁  " .. child.Name
            Btn.MouseButton1Click:Connect(function()
                PopulateItems(child)
            end)
        else
            Btn.Text = "📦  " .. child.Name
            Btn.MouseButton1Click:Connect(function()
                SelectedSpawnItem = child
                ItemTargetLabel.Text = "Selected: " .. child.Name
                ItemActionFrame.Visible = true
                ItemExplorerFrame.Visible = false
            end)
        end
    end
end

local function LaunchItemSpawner()
    ExploitSelectFrame.Visible = false
    ItemSpawnerFrame.Visible = true
    
    local ItemsFolder = ReplicatedStorage:FindFirstChild("Items")
    if ItemsFolder then
        PopulateItems(ItemsFolder)
    end
end

-- ADMIN EXPLOITS
local function SetupAdminExploits()
    -- Kick all players
    CreateAdminButton("👢 Kick All Players", function()
        local KickRemote = FindRemoteEvent("AdminKickPlayerRemote")
        if KickRemote then
            for _, player in ipairs(Players:GetPlayers()) do
                pcall(function()
                    KickRemote:FireServer(player)
                end)
            end
        end
    end)
    
    -- Give admin to self
    CreateAdminButton("🔑 Give Admin", function()
        local GiveEvent = FindRemoteEvent("AdminGiveToolEvent")
        if GiveEvent then
            pcall(function()
                GiveEvent:FireServer(LocalPlayer)
            end)
        end
    end)
    
    -- Broadcast message
    CreateAdminButton("📢 Broadcast Message", function()
        local Broadcast = FindRemoteEvent("BroadcastRequest")
        if Broadcast then
            local message = "Server owned by " .. LocalPlayer.Name .. "!"
            pcall(function()
                Broadcast:FireServer(message)
            end)
        end
        
        -- Try alternative
        local SendAnnounce = FindRemoteEvent("SendAnnouncement")
        if SendAnnounce then
            pcall(function()
                SendAnnounce:FireServer("Server owned by " .. LocalPlayer.Name)
            end)
        end
    end)
    
    -- Show admin notify
    CreateAdminButton("🔔 Show Admin Notify", function()
        local Notify = FindRemoteEvent("ShowAdminNotify")
        if Notify then
            pcall(function()
                Notify:FireServer(LocalPlayer)
            end)
        end
    end)
    
    -- Set kick remote
    CreateAdminButton("⚡ Set Kick Remote", function()
        local SetKick = FindRemoteEvent("SetKickRemote")
        if SetKick then
            pcall(function()
                SetKick:FireServer(LocalPlayer)
            end)
        end
    end)
    
    -- Update settings
    CreateAdminButton("⚙️ Update Settings", function()
        local UpdateSettings = FindRemoteEvent("UpdateSettings")
        if UpdateSettings then
            pcall(function()
                UpdateSettings:FireServer()
            end)
        end
    end)
    
    -- Trigger cosmic VFX
    CreateAdminButton("✨ Trigger Cosmic VFX", function()
        local VFX = FindRemoteEvent("TriggerCosmicVFX")
        if VFX then
            pcall(function()
                VFX:FireServer()
            end)
        end
    end)
    
    -- Update events
    CreateAdminButton("🔄 Update Events", function()
        local UpdateEvents = FindRemoteEvent("UpdateEvents")
        if UpdateEvents then
            pcall(function()
                UpdateEvents:FireServer()
            end)
        end
    end)
    
    -- Update event GUI
    CreateAdminButton("🎮 Update Event GUI", function()
        local UpdateGUI = FindRemoteEvent("UpdateEventGUI")
        if UpdateGUI then
            pcall(function()
                UpdateGUI:FireServer()
            end)
        end
    end)
end

-- MONEY EXPLOITS
local function SetupMoneyExploits()
    -- Give money to self
    CreateMoneyButton("💰 Give $1M", function()
        local Event = FindRemoteEvent("ClaimHatchedItem")
        if Event then
            pcall(function()
                Event:FireServer("MoneyBag", "Mythical")
            end)
        end
    end)
    
    -- Trade exploit
    CreateMoneyButton("🔄 Trade Exploit", function()
        local TradeEvent = FindRemoteEvent("Trade")
        if TradeEvent then
            pcall(function()
                TradeEvent:FireServer(LocalPlayer, 1000000)
            end)
        end
    end)
    
    -- Invite exploit
    CreateMoneyButton("📨 Invite Exploit", function()
        local InviteEvent = FindRemoteEvent("Invite")
        if InviteEvent then
            pcall(function()
                InviteEvent:FireServer(LocalPlayer)
            end)
        end
    end)
    
    -- Shop exploit
    CreateMoneyButton("🏪 Shop Exploit", function()
        local ShopEvent = FindRemoteEvent("Shop")
        if ShopEvent then
            pcall(function()
                ShopEvent:FireServer("BuyAll")
            end)
        end
    end)
    
    -- Money glitch
    CreateMoneyButton("💎 Money Glitch (Loop)", function()
        IsMoneySpawning = not IsMoneySpawning
        task.spawn(function()
            while IsMoneySpawning do
                local Event = FindRemoteEvent("ClaimHatchedItem")
                if Event then
                    pcall(function()
                        Event:FireServer("MoneyBag", "Mythical")
                    end)
                end
                task.wait(0.05)
            end
        end)
    end)
    
    -- Give everyone money
    CreateMoneyButton("🌐 Give Everyone $1M", function()
        local Event = FindRemoteEvent("ClaimHatchedItem")
        if Event then
            for _, player in ipairs(Players:GetPlayers()) do
                pcall(function()
                    Event:FireServer(player, "MoneyBag", "Mythical")
                end)
            end
        end
    end)
end

-- REBIRTH EXPLOITS
local function SetupRebirthExploits()
    -- Auto rebirth
    CreateRebirthButton("🔄 Auto Rebirth (Loop)", function()
        IsRebirthSpawning = not IsRebirthSpawning
        task.spawn(function()
            while IsRebirthSpawning do
                local RebirthEvent = FindRemoteEvent("Rebirth")
                if RebirthEvent then
                    pcall(function()
                        RebirthEvent:FireServer()
                    end)
                end
                task.wait(0.1)
            end
        end)
    end)
    
    -- Rebirth boost
    CreateRebirthButton("⚡ Rebirth Boost", function()
        local RebirthEvent = FindRemoteEvent("Rebirth")
        if RebirthEvent then
            for i = 1, 100 do
                pcall(function()
                    RebirthEvent:FireServer()
                end)
                task.wait()
            end
        end
    end)
    
    -- Update rebirth UI
    CreateRebirthButton("🔄 Update Rebirth UI", function()
        local UpdateEvent = FindRemoteEvent("UpdateEvents")
        if UpdateEvent then
            pcall(function()
                UpdateEvent:FireServer("Rebirth")
            end)
        end
    end)
end

-- GLOBAL EXPLOITS
local function SetupGlobalExploits()
    -- Global announcement
    CreateGlobalButton("📢 Global Announcement", function()
        local GlobalAnnounce = FindRemoteEvent("GlobalAnnouncementEvent")
        if GlobalAnnounce then
            pcall(function()
                GlobalAnnounce:FireServer("This server is being exploited by " .. LocalPlayer.Name)
            end)
        end
        
        -- Alternative
        local ClientAnnounce = FindRemoteEvent("ClientGlobalAnnouncementEvent")
        if ClientAnnounce then
            pcall(function()
                ClientAnnounce:FireServer("This server is being exploited by " .. LocalPlayer.Name)
            end)
        end
    end)
    
    -- Notify everyone
    CreateGlobalButton("🔔 Notify Everyone", function()
        local Notify = FindRemoteEvent("Notify")
        if Notify then
            pcall(function()
                Notify:FireServer("Exploit activated by " .. LocalPlayer.Name)
            end)
        end
    end)
    
    -- Trigger admin panel
    CreateGlobalButton("📋 Trigger Admin Panel", function()
        local AdminPanel = FindRemoteEvent("AdminGuiTrigger")
        if AdminPanel then
            pcall(function()
                AdminPanel:FireServer()
            end)
        end
    end)
    
    -- Global event fade
    CreateGlobalButton("🎭 Event Fade", function()
        local EventFade = FindRemoteEvent("EventFade")
        if EventFade then
            pcall(function()
                EventFade:FireServer()
            end)
        end
    end)
    
    -- Update global settings
    CreateGlobalButton("⚙️ Update Global Settings", function()
        local UpdateSettings = FindRemoteEvent("UpdateSettings")
        if UpdateSettings then
            pcall(function()
                UpdateSettings:FireServer(true) -- Global
            end)
        end
    end)
    
    -- Cosmic event trigger
    CreateGlobalButton("🌌 Trigger Cosmic Event", function()
        local Cosmic = FindRemoteEvent("TriggerCosmicVFX")
        if Cosmic then
            pcall(function()
                Cosmic:FireServer("Global")
            end)
        end
    end)
end

---------------------------------------------------------
-- BUTTON NAVIGATION
---------------------------------------------------------

-- Main menu buttons
ItemSpawnBtn.MouseButton1Click:Connect(LaunchItemSpawner)

AdminExploitBtn.MouseButton1Click:Connect(function()
    ExploitSelectFrame.Visible = false
    AdminFrame.Visible = true
    SetupAdminExploits()
end)

MoneyExploitBtn.MouseButton1Click:Connect(function()
    ExploitSelectFrame.Visible = false
    MoneyFrame.Visible = true
    SetupMoneyExploits()
end)

RebirthExploitBtn.MouseButton1Click:Connect(function()
    ExploitSelectFrame.Visible = false
    RebirthFrame.Visible = true
    SetupRebirthExploits()
end)

GlobalExploitBtn.MouseButton1Click:Connect(function()
    ExploitSelectFrame.Visible = false
    GlobalFrame.Visible = true
    SetupGlobalExploits()
end)

-- Back buttons
local function GoBackToMain()
    ItemSpawnerFrame.Visible = false
    AdminFrame.Visible = false
    MoneyFrame.Visible = false
    RebirthFrame.Visible = false
    GlobalFrame.Visible = false
    ExploitSelectFrame.Visible = true
end

ItemBackBtn.MouseButton1Click:Connect(GoBackToMain)
AdminBackBtn.MouseButton1Click:Connect(GoBackToMain)
MoneyBackBtn.MouseButton1Click:Connect(GoBackToMain)
RebirthBackBtn.MouseButton1Click:Connect(GoBackToMain)
GlobalBackBtn.MouseButton1Click:Connect(GoBackToMain)

ItemFolderBackBtn.MouseButton1Click:Connect(function()
    -- Go back in folder hierarchy
    local currentFolder = ReplicatedStorage:FindFirstChild("Items")
    if currentFolder then
        PopulateItems(currentFolder)
    end
end)

ItemActionBackBtn.MouseButton1Click:Connect(function()
    ItemActionFrame.Visible = false
    ItemExplorerFrame.Visible = true
end)

-- ITEM ACTION BUTTONS
ItemGlobalToggle.MouseButton1Click:Connect(function()
    IsItemGlobalSpawning = not IsItemGlobalSpawning
    ItemGlobalToggle.Text = "Give To Everyone: " .. (IsItemGlobalSpawning and "ON" or "OFF")
    ItemGlobalToggle.BackgroundColor3 = IsItemGlobalSpawning and Theme.Accent or Theme.Secondary
end)

ItemSpawnOnceBtn.MouseButton1Click:Connect(function()
    if SelectedSpawnItem then 
        ExecuteSpawn(SelectedSpawnItem.Name, IsItemGlobalSpawning) 
    end
end)

ItemLoopToggle.MouseButton1Click:Connect(function()
    IsItemLoopSpawning = not IsItemLoopSpawning
    ItemLoopToggle.Text = "Loop Spawn: " .. (IsItemLoopSpawning and "ON" or "OFF")
    ItemLoopToggle.BackgroundColor3 = IsItemLoopSpawning and Theme.Accent or Theme.Secondary

    task.spawn(function()
        while IsItemLoopSpawning and SelectedSpawnItem do
            ExecuteSpawn(SelectedSpawnItem.Name, IsItemGlobalSpawning)
            task.wait(0.1)
        end
    end)
end)

ItemGlitchOnceBtn.MouseButton1Click:Connect(function()
    ExecuteSpawn(GenerateGlitchName(), IsItemGlobalSpawning)
end)

ItemGlitchLoopBtn.MouseButton1Click:Connect(function()
    IsItemGlitchLooping = not IsItemGlitchLooping
    ItemGlitchLoopBtn.Text = "Glitch Loop Spawn: " .. (IsItemGlitchLooping and "ON" or "OFF")
    ItemGlitchLoopBtn.BackgroundColor3 = IsItemGlitchLooping and Theme.Accent or Theme.Secondary

    task.spawn(function()
        while IsItemGlitchLooping do
            ExecuteSpawn(GenerateGlitchName(), IsItemGlobalSpawning)
            task.wait(0.1)
        end
    end)
end)

print("Exploit Hub Loaded Successfully")
print("Anti-Ban Protection Active")
print("Use with caution - This is for educational purposes only")
