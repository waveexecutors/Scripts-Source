-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

-- Parent ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HydrogenMobileUI_V2"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end

-- Blur Effect setup
local Blur = Lighting:FindFirstChild("HydrogenBlur")
if not Blur then
    Blur = Instance.new("BlurEffect")
    Blur.Name = "HydrogenBlur"
    Blur.Size = 0
    Blur.Enabled = false
    Blur.Parent = Lighting
end

-- Draggable Function (Mobile & Touch support)
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

-- Toast Notification System
local function createToast(message)
    local toast = Instance.new("Frame")
    toast.Name = "Toast"
    toast.Size = UDim2.new(0, 220, 0, 38)
    toast.Position = UDim2.new(0.5, -110, 0.85, 0)
    toast.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    toast.BorderSizePixel = 0
    toast.ZIndex = 20
    toast.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toast

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 80)
    stroke.Thickness = 1.2
    stroke.Parent = toast

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.ZIndex = 21
    label.Parent = toast

    toast.Transparency = 1
    label.TextTransparency = 1

    TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

    task.delay(2, function()
        local tweenOut = TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        TweenService:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            toast:Destroy()
        end)
    end)
end

-- 1. Floating Toggle Icon (Black Background + Custom Icon 14384012061)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "HydrogenToggle"
ToggleButton.Size = UDim2.new(0, 52, 0, 52)
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Fundo Preto
ToggleButton.Image = "rbxassetid://14384012061" -- Seu novo ícone
ToggleButton.Parent = ScreenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = ToggleButton

-- Shadow/Glow Stroke para o ícone flutuante
local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(80, 80, 80)
toggleStroke.Thickness = 2
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
toggleStroke.Parent = ToggleButton

makeDraggable(ToggleButton)

-- 2. Main Frame Executor
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 265)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -132)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 24)
mainCorner.Parent = MainFrame

-- Modern Outer Shadow
local mainShadow = Instance.new("UIStroke")
mainShadow.Color = Color3.fromRGB(15, 15, 15)
mainShadow.Thickness = 3
mainShadow.Parent = MainFrame

makeDraggable(MainFrame)

-- Modern Animate Toggle System + Blur
local isOpen = true
Blur.Enabled = true
Blur.Size = 18

local function toggleGUI()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        Blur.Enabled = true
        TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 18}):Play()
        
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 460, 0, 265),
            Position = UDim2.new(0.5, -230, 0.5, -132)
        }):Play()
    else
        TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
        local scaleTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        scaleTween:Play()
        scaleTween.Completed:Connect(function()
            if not isOpen then
                MainFrame.Visible = false
                Blur.Enabled = false
            end
        end)
    end
end

ToggleButton.MouseButton1Click:Connect(toggleGUI)

-- Top Left Logo (14384012061)
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 42, 0, 42)
Logo.Position = UDim2.new(0, 22, 0, 14)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://14384012061"
Logo.Parent = MainFrame

-- Title Header
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 0, 25)
Title.Position = UDim2.new(0, 75, 0, 12)
Title.BackgroundTransparency = 1
Title.Text = "Hydrogen Executor"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Current Tab Label
local CurrentTabLabel = Instance.new("TextLabel")
CurrentTabLabel.Size = UDim2.new(0, 250, 0, 18)
CurrentTabLabel.Position = UDim2.new(0, 75, 0, 36)
CurrentTabLabel.BackgroundTransparency = 1
CurrentTabLabel.Text = "Your Current Tab: Editor"
CurrentTabLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
CurrentTabLabel.Font = Enum.Font.Gotham
CurrentTabLabel.TextSize = 12
CurrentTabLabel.TextXAlignment = Enum.TextXAlignment.Left
CurrentTabLabel.Parent = MainFrame

--- PAGE CONTAINER
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(0, 310, 0, 145)
PageContainer.Position = UDim2.new(0, 20, 0, 65)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

-- 1. Editor Page
local EditorPage = Instance.new("Frame")
EditorPage.Size = UDim2.new(1, 0, 1, 0)
EditorPage.BackgroundTransparency = 1
EditorPage.Parent = PageContainer

local ScriptBox = Instance.new("TextBox")
ScriptBox.Size = UDim2.new(1, 0, 1, 0)
ScriptBox.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
ScriptBox.Text = ""
ScriptBox.PlaceholderText = "Put Your Script Here.."
ScriptBox.PlaceholderColor3 = Color3.fromRGB(220, 220, 220)
ScriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptBox.Font = Enum.Font.Code
ScriptBox.TextSize = 14
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptBox.ClearTextOnFocus = false
ScriptBox.MultiLine = true
ScriptBox.Parent = EditorPage

local editorCorner = Instance.new("UICorner")
editorCorner.CornerRadius = UDim.new(0, 14)
editorCorner.Parent = ScriptBox

local editorStroke = Instance.new("UIStroke")
editorStroke.Color = Color3.fromRGB(60, 60, 60)
editorStroke.Thickness = 1
editorStroke.Parent = ScriptBox

local boxPadding = Instance.new("UIPadding")
boxPadding.PaddingTop = UDim.new(0, 10)
boxPadding.PaddingLeft = UDim.new(0, 10)
boxPadding.PaddingRight = UDim.new(0, 10)
boxPadding.Parent = ScriptBox

-- 2. Settings Page (Executor Configs)
local SettingsPage = Instance.new("Frame")
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = PageContainer

local ConfigsScroll = Instance.new("ScrollingFrame")
ConfigsScroll.Size = UDim2.new(1, 0, 1, 0)
ConfigsScroll.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
ConfigsScroll.CanvasSize = UDim2.new(0, 0, 0, 230)
ConfigsScroll.ScrollBarThickness = 4
ConfigsScroll.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)
ConfigsScroll.Parent = SettingsPage

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 14)
settingsCorner.Parent = ConfigsScroll

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = ConfigsScroll

local scrollPadding = Instance.new("UIPadding")
scrollPadding.PaddingTop = UDim.new(0, 8)
scrollPadding.Parent = ConfigsScroll

-- Executor Settings List
local executorConfigs = {
    {Name = "Auto Execute", State = false},
    {Name = "Internal UI Overlay", State = true},
    {Name = "Anti-AFK Disconnect", State = true},
    {Name = "Unlock FPS (60+)", State = false},
    {Name = "Save Editor Text", State = true}
}

for _, cfg in ipairs(executorConfigs) do
    local configFrame = Instance.new("Frame")
    configFrame.Size = UDim2.new(0.92, 0, 0, 32)
    configFrame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    configFrame.Parent = ConfigsScroll

    local cfgCorner = Instance.new("UICorner")
    cfgCorner.CornerRadius = UDim.new(0, 8)
    cfgCorner.Parent = configFrame

    local cfgLabel = Instance.new("TextLabel")
    cfgLabel.Size = UDim2.new(0.65, 0, 1, 0)
    cfgLabel.Position = UDim2.new(0, 10, 0, 0)
    cfgLabel.BackgroundTransparency = 1
    cfgLabel.Text = cfg.Name
    cfgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    cfgLabel.Font = Enum.Font.GothamMedium
    cfgLabel.TextSize = 12
    cfgLabel.TextXAlignment = Enum.TextXAlignment.Left
    cfgLabel.Parent = configFrame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 55, 0, 22)
    toggleBtn.Position = UDim2.new(1, -62, 0.5, -11)
    toggleBtn.BackgroundColor3 = cfg.State and Color3.fromRGB(45, 180, 80) or Color3.fromRGB(150, 50, 50)
    toggleBtn.Text = cfg.State and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.Parent = configFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn

    toggleBtn.MouseButton1Click:Connect(function()
        cfg.State = not cfg.State
        toggleBtn.Text = cfg.State and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = cfg.State and Color3.fromRGB(45, 180, 80) or Color3.fromRGB(150, 50, 50)
        createToast(cfg.Name .. " set to " .. (cfg.State and "ON" or "OFF"))
    end)
end

-- Bottom Action Buttons
local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(0, 70, 0, 28)
ExecuteBtn.Position = UDim2.new(0, 20, 0, 220)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
ExecuteBtn.Text = "Execute"
ExecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.TextSize = 13
ExecuteBtn.Parent = MainFrame

local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0, 6)
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
ClearBtn.Size = UDim2.new(0, 70, 0, 28)
ClearBtn.Position = UDim2.new(0, 98, 0, 220)
ClearBtn.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
ClearBtn.Text = "Clear"
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextSize = 13
ClearBtn.Parent = MainFrame

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = ClearBtn

ClearBtn.MouseButton1Click:Connect(function()
    ScriptBox.Text = ""
    createToast("Editor Cleared!")
end)

--- RIGHT SIDEBAR NAVIGATION BUTTONS WITH SHADOWS
local navButtons = {
    {Name = "Editor", Icon = "rbxassetid://6031075931"},
    {Name = "Script Hub", Icon = "rbxassetid://6031154871"},
    {Name = "Settings", Icon = "rbxassetid://6031280882"},
    {Name = "Account", Icon = "rbxassetid://14384012061"}
}

local startY = 10
local spacing = 60

for _, nav in ipairs(navButtons) do
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 50, 0, 55)
    container.Position = UDim2.new(1, -68, 0, startY)
    container.BackgroundTransparency = 1
    container.Parent = MainFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 20, 0, 12)
    label.Position = UDim2.new(0, -10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = nav.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 10
    label.Parent = container

    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 40, 0, 40)
    btn.Position = UDim2.new(0.5, -20, 0, 14)
    btn.BackgroundColor3 = Color3.fromRGB(130, 130, 130)
    btn.Image = nav.Icon
    btn.Parent = container

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = btn

    -- Modern Shadow/Stroke for Icons
    local navStroke = Instance.new("UIStroke")
    navStroke.Color = Color3.fromRGB(20, 20, 20)
    navStroke.Thickness = 1.5
    navStroke.Parent = btn

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
