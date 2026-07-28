-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Parent ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HydrogenMobileUI"
ScreenGui.ResetOnSpawn = false

-- Safe parent check
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end

-- Function to make elements draggable (Mobile & Desktop support)
local function makeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Toast Notification Function
local function createToast(message)
    local toast = Instance.new("Frame")
    toast.Name = "Toast"
    toast.Size = UDim2.new(0, 220, 0, 40)
    toast.Position = UDim2.new(0.5, -110, 0.85, 0)
    toast.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    toast.BorderSizePixel = 0
    toast.ZIndex = 10
    toast.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toast

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 80)
    stroke.Thickness = 1
    stroke.Parent = toast

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.ZIndex = 11
    label.Parent = toast

    toast.Transparency = 1
    label.TextTransparency = 1

    TweenService:Create(toast, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    task.delay(2, function()
        local tweenOut = TweenService:Create(toast, TweenInfo.new(0.3), {BackgroundTransparency = 1})
        TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            toast:Destroy()
        end)
    end)
end

-- 1. Floating Toggle Icon
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "HydrogenIcon"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.Image = "rbxassetid://10723415903" -- Water drop icon
ToggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Parent = ScreenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = ToggleButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(100, 100, 100)
toggleStroke.Thickness = 2
toggleStroke.Parent = ToggleButton

makeDraggable(ToggleButton)

-- 2. Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 260)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 25)
mainCorner.Parent = MainFrame

makeDraggable(MainFrame)

-- Toggle GUI Visibility
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Top Left Logo (Water Drop)
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 40, 0, 45)
Logo.Position = UDim2.new(0, 25, 0, 15)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://10723415903"
Logo.Parent = MainFrame

-- Title Header
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 0, 25)
Title.Position = UDim2.new(0, 75, 0, 12)
Title.BackgroundTransparency = 1
Title.Text = "Hydrogen Executor"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSans
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Current Tab Label
local CurrentTabLabel = Instance.new("TextLabel")
CurrentTabLabel.Size = UDim2.new(0, 250, 0, 18)
CurrentTabLabel.Position = UDim2.new(0, 75, 0, 37)
CurrentTabLabel.BackgroundTransparency = 1
CurrentTabLabel.Text = "Your Current Tab: Editor"
CurrentTabLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CurrentTabLabel.Font = Enum.Font.SourceSans
CurrentTabLabel.TextSize = 13
CurrentTabLabel.TextXAlignment = Enum.TextXAlignment.Left
CurrentTabLabel.Parent = MainFrame

--- PAGE CONTAINER (For switching between Editor and Settings)
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(0, 300, 0, 140)
PageContainer.Position = UDim2.new(0, 20, 0, 65)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

-- Page 1: Editor
local EditorPage = Instance.new("Frame")
EditorPage.Size = UDim2.new(1, 0, 1, 0)
EditorPage.BackgroundTransparency = 1
EditorPage.Parent = PageContainer

local ScriptBox = Instance.new("TextBox")
ScriptBox.Size = UDim2.new(1, 0, 1, 0)
ScriptBox.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
ScriptBox.Text = ""
ScriptBox.PlaceholderText = "Put Your Script Here.."
ScriptBox.PlaceholderColor3 = Color3.fromRGB(220, 220, 220)
ScriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptBox.Font = Enum.Font.SourceSans
ScriptBox.TextSize = 16
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptBox.ClearTextOnFocus = false
ScriptBox.MultiLine = true
ScriptBox.Parent = EditorPage

local editorCorner = Instance.new("UICorner")
editorCorner.CornerRadius = UDim.new(0, 15)
editorCorner.Parent = ScriptBox

local boxPadding = Instance.new("UIPadding")
boxPadding.PaddingTop = UDim.new(0, 8)
boxPadding.PaddingLeft = UDim.new(0, 10)
boxPadding.PaddingRight = UDim.new(0, 10)
boxPadding.Parent = ScriptBox

-- Page 2: Settings (Configs List)
local SettingsPage = Instance.new("Frame")
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = PageContainer

local ConfigsScroll = Instance.new("ScrollingFrame")
ConfigsScroll.Size = UDim2.new(1, 0, 1, 0)
ConfigsScroll.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
ConfigsScroll.CanvasSize = UDim2.new(0, 0, 0, 200)
ConfigsScroll.ScrollBarThickness = 4
ConfigsScroll.Parent = SettingsPage

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 15)
settingsCorner.Parent = ConfigsScroll

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = ConfigsScroll

local scrollPadding = Instance.new("UIPadding")
scrollPadding.PaddingTop = UDim.new(0, 8)
scrollPadding.Parent = ConfigsScroll

-- Sample Config Items inside Settings
local configs = {"Default Config", "Legit Config", "Rage Config", "Auto Farm Preset"}
for _, configName in ipairs(configs) do
    local configBtn = Instance.new("TextButton")
    configBtn.Size = UDim2.new(0.9, 0, 0, 28)
    configBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    configBtn.Text = configName
    configBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    configBtn.Font = Enum.Font.SourceSans
    configBtn.TextSize = 14
    configBtn.Parent = ConfigsScroll

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = configBtn

    configBtn.MouseButton1Click:Connect(function()
        createToast("Loaded: " .. configName)
    end)
end

-- Bottom Action Buttons (Execute / Clear)
local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(0, 65, 0, 28)
ExecuteBtn.Position = UDim2.new(0, 20, 0, 215)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
ExecuteBtn.Text = "Execute"
ExecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteBtn.Font = Enum.Font.SourceSans
ExecuteBtn.TextSize = 15
ExecuteBtn.Parent = MainFrame

local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0, 5)
execCorner.Parent = ExecuteBtn

ExecuteBtn.MouseButton1Click:Connect(function()
    if ScriptBox.Text ~= "" then
        local success, err = pcall(function()
            loadstring(ScriptBox.Text)()
        end)
        if not success then
            createToast("Error executing script!")
            warn("Execute Error:", err)
        else
            createToast("Script Executed!")
        end
    else
        createToast("Script Box is empty!")
    end
end)

local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0, 65, 0, 28)
ClearBtn.Position = UDim2.new(0, 92, 0, 215)
ClearBtn.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
ClearBtn.Text = "Clear"
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.Font = Enum.Font.SourceSans
ClearBtn.TextSize = 15
ClearBtn.Parent = MainFrame

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 5)
clearCorner.Parent = ClearBtn

ClearBtn.MouseButton1Click:Connect(function()
    ScriptBox.Text = ""
    createToast("Editor Cleared!")
end)

--- RIGHT SIDEBAR NAVIGATION BUTTONS
local navButtons = {
    {Name = "Editor", Icon = "rbxassetid://6031075931"},
    {Name = "Script Hub", Icon = "rbxassetid://6031154871"},
    {Name = "Settings", Icon = "rbxassetid://6031280882"},
    {Name = "Account", Icon = "rbxassetid://10723415903"}
}

local startY = 10
local spacing = 60

for _, nav in ipairs(navButtons) do
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 50, 0, 55)
    container.Position = UDim2.new(1, -70, 0, startY)
    container.BackgroundTransparency = 1
    container.Parent = MainFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 20, 0, 12)
    label.Position = UDim2.new(0, -10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = nav.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 11
    label.Parent = container

    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 40, 0, 40)
    btn.Position = UDim2.new(0.5, -20, 0, 14)
    btn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    btn.Image = nav.Icon
    btn.Parent = container

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if nav.Name == "Editor" then
            EditorPage.Visible = true
            SettingsPage.Visible = false
            CurrentTabLabel.Text = "Your Current Tab: Editor"
        elseif nav.Name == "Settings" then
            EditorPage.Visible = false
            SettingsPage.Visible = true
            CurrentTabLabel.Text = "Your Current Tab: Settings"
        else
            createToast(nav.Name .. " is in progress...")
        end
    end)

    startY = startY + spacing
end
