-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Parent ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HydrogenMobileUI_Pro"
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

-- Draggable Function
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
    toast.Size = UDim2.new(0, 230, 0, 38)
    toast.Position = UDim2.new(0.5, -115, 0.85, 0)
    toast.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    toast.BorderSizePixel = 0
    toast.ZIndex = 50
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
    label.ZIndex = 51
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

-- 1. Floating Toggle Icon (Menor, Fundo Preto, Ícone 14384012061)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "HydrogenToggle"
ToggleButton.Size = UDim2.new(0, 42, 0, 42) -- Mais compacto
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Preto sólido
ToggleButton.Parent = ScreenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = ToggleButton

local toggleImage = Instance.new("ImageLabel")
toggleImage.Size = UDim2.new(0, 26, 0, 26)
toggleImage.Position = UDim2.new(0.5, -13, 0.5, -13)
toggleImage.BackgroundTransparency = 1
toggleImage.Image = "rbxassetid://14384012061"
toggleImage.Parent = ToggleButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(80, 80, 80)
toggleStroke.Thickness = 1.5
toggleStroke.Parent = ToggleButton

makeDraggable(ToggleButton)

-- 2. Main Frame Executor
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 265)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -132)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 24)
mainCorner.Parent = MainFrame

local mainShadow = Instance.new("UIStroke")
mainShadow.Color = Color3.fromRGB(15, 15, 15)
mainShadow.Thickness = 3
mainShadow.Parent = MainFrame

makeDraggable(MainFrame)

-- Toggle & Blur Animation
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

-- Header Logo & Title
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 38, 0, 38)
Logo.Position = UDim2.new(0, 20, 0, 14)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://14384012061"
Logo.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 0, 25)
Title.Position = UDim2.new(0, 68, 0, 12)
Title.BackgroundTransparency = 1
Title.Text = "Hydrogen Executor"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 19
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local CurrentTabLabel = Instance.new("TextLabel")
CurrentTabLabel.Size = UDim2.new(0, 250, 0, 18)
CurrentTabLabel.Position = UDim2.new(0, 68, 0, 35)
CurrentTabLabel.BackgroundTransparency = 1
CurrentTabLabel.Text = "Your Current Tab: Editor"
CurrentTabLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
CurrentTabLabel.Font = Enum.Font.Gotham
CurrentTabLabel.TextSize = 12
CurrentTabLabel.TextXAlignment = Enum.TextXAlignment.Left
CurrentTabLabel.Parent = MainFrame

--- PAGES CONTAINER
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(0, 310, 0, 145)
PageContainer.Position = UDim2.new(0, 20, 0, 65)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

-- 1. EDITOR PAGE
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

local boxPadding = Instance.new("UIPadding")
boxPadding.PaddingTop = UDim.new(0, 10)
boxPadding.PaddingLeft = UDim.new(0, 10)
boxPadding.PaddingRight = UDim.new(0, 10)
boxPadding.Parent = ScriptBox

-- 2. SCRIPT HUB PAGE (ScriptBlox API Integration)
local ScriptHubPage = Instance.new("Frame")
ScriptHubPage.Size = UDim2.new(1, 0, 1, 0)
ScriptHubPage.BackgroundTransparency = 1
ScriptHubPage.Visible = false
ScriptHubPage.Parent = PageContainer

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, 0, 0, 30)
SearchBox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
SearchBox.PlaceholderText = "Search scripts on ScriptBlox..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 12
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = ScriptHubPage

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 8)
searchCorner.Parent = SearchBox

local HubScroll = Instance.new("ScrollingFrame")
HubScroll.Size = UDim2.new(1, 0, 1, -38)
HubScroll.Position = UDim2.new(0, 0, 0, 38)
HubScroll.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
HubScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
HubScroll.ScrollBarThickness = 4
HubScroll.Parent = ScriptHubPage

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 12)
hubCorner.Parent = HubScroll

local hubLayout = Instance.new("UIListLayout")
hubLayout.Padding = UDim.new(0, 5)
hubLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
hubLayout.Parent = HubScroll

local function searchScriptBlox(query)
	for _, child in ipairs(HubScroll:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	
	task.spawn(function()
		local success, result = pcall(function()
			local url = "https://scriptblox.com/api/script/search?q=" .. HttpService:UrlEncode(query)
			local response = game:HttpGet(url)
			return HttpService:JSONDecode(response)
		end)
		
		if success and result and result.result and result.result.scripts then
			local scripts = result.result.scripts
			HubScroll.CanvasSize = UDim2.new(0, 0, 0, #scripts * 42)
			
			for _, scr in ipairs(scripts) do
				local item = Instance.new("Frame")
				item.Size = UDim2.new(0.94, 0, 0, 36)
				item.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				item.Parent = HubScroll
				
				local itemCorner = Instance.new("UICorner")
				itemCorner.CornerRadius = UDim.new(0, 6)
				itemCorner.Parent = item
				
				local titleLbl = Instance.new("TextLabel")
				titleLbl.Size = UDim2.new(0.7, 0, 1, 0)
				titleLbl.Position = UDim2.new(0, 8, 0, 0)
				titleLbl.BackgroundTransparency = 1
				titleLbl.Text = scr.title or "Unknown Script"
				titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
				titleLbl.Font = Enum.Font.GothamMedium
				titleLbl.TextSize = 11
				titleLbl.TextXAlignment = Enum.TextXAlignment.Left
				titleLbl.Parent = item
				
				local loadBtn = Instance.new("TextButton")
				loadBtn.Size = UDim2.new(0, 65, 0, 24)
				loadBtn.Position = UDim2.new(1, -70, 0.5, -12)
				loadBtn.BackgroundColor3 = Color3.fromRGB(45, 140, 200)
				loadBtn.Text = "Get Script"
				loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				loadBtn.Font = Enum.Font.GothamBold
				loadBtn.TextSize = 10
				loadBtn.Parent = item
				
				local btnC = Instance.new("UICorner")
				btnC.CornerRadius = UDim.new(0, 4)
				btnC.Parent = loadBtn
				
				loadBtn.MouseButton1Click:Connect(function()
					if scr.script then
						ScriptBox.Text = scr.script
						EditorPage.Visible = true
						ScriptHubPage.Visible = false
						CurrentTabLabel.Text = "Your Current Tab: Editor"
						createToast("Script loaded to Editor!")
					else
						createToast("Failed to fetch raw script.")
					end
				end)
			end
		else
			createToast("No scripts found or API error.")
		end
	end)
end

SearchBox.FocusLost:Connect(function(enterPressed)
	if enterPressed and SearchBox.Text ~= "" then
		searchScriptBlox(SearchBox.Text)
	end
end)

-- 3. SETTINGS PAGE (Configs & Customization)
local SettingsPage = Instance.new("Frame")
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = PageContainer

local ConfigsScroll = Instance.new("ScrollingFrame")
ConfigsScroll.Size = UDim2.new(1, 0, 1, 0)
ConfigsScroll.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
ConfigsScroll.CanvasSize = UDim2.new(0, 0, 0, 280)
ConfigsScroll.ScrollBarThickness = 4
ConfigsScroll.Parent = SettingsPage

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 14)
settingsCorner.Parent = ConfigsScroll

local setListLayout = Instance.new("UIListLayout")
setListLayout.Padding = UDim.new(0, 6)
setListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
setListLayout.Parent = ConfigsScroll

local setScrollPadding = Instance.new("UIPadding")
setScrollPadding.PaddingTop = UDim.new(0, 8)
setScrollPadding.Parent = ConfigsScroll

-- Helper to create setting toggles
local function addConfigToggle(name, defaultState, callback)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(0.92, 0, 0, 32)
	f.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
	f.Parent = ConfigsScroll
	
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = f
	
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(0.65, 0, 1, 0)
	l.Position = UDim2.new(0, 10, 0, 0)
	l.BackgroundTransparency = 1
	l.Text = name
	l.TextColor3 = Color3.fromRGB(255, 255, 255)
	l.Font = Enum.Font.GothamMedium
	l.TextSize = 12
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Parent = f
	
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 55, 0, 22)
	b.Position = UDim2.new(1, -62, 0.5, -11)
	b.BackgroundColor3 = defaultState and Color3.fromRGB(45, 180, 80) or Color3.fromRGB(150, 50, 50)
	b.Text = defaultState and "ON" or "OFF"
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 11
	b.Parent = f
	
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 6)
	bc.Parent = b
	
	local state = defaultState
	b.MouseButton1Click:Connect(function()
		state = not state
		b.Text = state and "ON" or "OFF"
		b.BackgroundColor3 = state and Color3.fromRGB(45, 180, 80) or Color3.fromRGB(150, 50, 50)
		callback(state)
	end)
end

-- Unlock FPS Implementations
addConfigToggle("Unlock FPS (60 FPS)", false, function(state)
	if state then
		setfpslimit(60)
		createToast("FPS limited to 60")
	else
		setfpslimit(999)
	end
end)

addConfigToggle("Unlock FPS (120 FPS)", false, function(state)
	if state then
		setfpslimit(120)
		createToast("FPS limited to 120")
	else
		setfpslimit(999)
	end
end)

addConfigToggle("Unlock Max FPS (Uncapped)", true, function(state)
	if state then
		setfpslimit(999)
		createToast("Max FPS Unlocked!")
	end
end)

addConfigToggle("Anti-AFK Bypass", true, function(state)
	if state then
		local vu = game:GetService("VirtualUser")
		LocalPlayer.Idled:Connect(function()
			vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			task.wait(1)
			vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
		end)
		createToast("Anti-AFK Activated")
	end
end)

-- Customization Color Picker item
local customFrame = Instance.new("Frame")
customFrame.Size = UDim2.new(0.92, 0, 0, 32)
customFrame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
customFrame.Parent = ConfigsScroll

local cfCorner = Instance.new("UICorner")
cfCorner.CornerRadius = UDim.new(0, 8)
cfCorner.Parent = customFrame

local cfLbl = Instance.new("TextLabel")
cfLbl.Size = UDim2.new(0.5, 0, 1, 0)
cfLbl.Position = UDim2.new(0, 10, 0, 0)
cfLbl.BackgroundTransparency = 1
cfLbl.Text = "Executor Theme"
cfLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
cfLbl.Font = Enum.Font.GothamMedium
cfLbl.TextSize = 12
cfLbl.TextXAlignment = Enum.TextXAlignment.Left
cfLbl.Parent = customFrame

local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(0, 75, 0, 22)
themeBtn.Position = UDim2.new(1, -82, 0.5, -11)
themeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
themeBtn.Text = "Change Color"
themeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
themeBtn.Font = Enum.Font.GothamBold
themeBtn.TextSize = 10
themeBtn.Parent = customFrame

local tbC = Instance.new("UICorner")
tbC.CornerRadius = UDim.new(0, 6)
tbC.Parent = themeBtn

local themes = {Color3.fromRGB(35, 35, 35), Color3.fromRGB(20, 20, 20), Color3.fromRGB(60, 40, 80), Color3.fromRGB(80, 30, 30)}
local currentThemeIdx = 1
themeBtn.MouseButton1Click:Connect(function()
	currentThemeIdx = currentThemeIdx % #themes + 1
	MainFrame.BackgroundColor3 = themes[currentThemeIdx]
	createToast("Theme updated!")
end)

-- 4. ACCOUNT PAGE (Registrar, Salvar e Informações)
local AccountPage = Instance.new("Frame")
AccountPage.Size = UDim2.new(1, 0, 1, 0)
AccountPage.BackgroundTransparency = 1
AccountPage.Visible = false
AccountPage.Parent = PageContainer

local AccountScroll = Instance.new("ScrollingFrame")
AccountScroll.Size = UDim2.new(1, 0, 1, 0)
AccountScroll.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
AccountScroll.CanvasSize = UDim2.new(0, 0, 0, 220)
AccountScroll.ScrollBarThickness = 4
AccountScroll.Parent = AccountPage

local accCorner = Instance.new("UICorner")
accCorner.CornerRadius = UDim.new(0, 14)
accCorner.Parent = AccountScroll

local accListLayout = Instance.new("UIListLayout")
accListLayout.Padding = UDim.new(0, 8)
accListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
accListLayout.Parent = AccountScroll

local accScrollPadding = Instance.new("UIPadding")
accScrollPadding.PaddingTop = UDim.new(0, 10)
accScrollPadding.Parent = AccountScroll

-- Info Card Roblox
local robloxInfo = Instance.new("TextLabel")
robloxInfo.Size = UDim2.new(0.92, 0, 0, 55)
robloxInfo.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
robloxInfo.Text = " User: " .. LocalPlayer.Name .. "\n ID: " .. LocalPlayer.UserId .. "\n Executor: Hydrogen Mobile Pro"
robloxInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
robloxInfo.Font = Enum.Font.Gotham
robloxInfo.TextSize = 11
robloxInfo.TextXAlignment = Enum.TextXAlignment.Left
robloxInfo.TextYAlignment = Enum.TextYAlignment.Center
robloxInfo.Parent = AccountScroll

local riCorner = Instance.new("UICorner")
riCorner.CornerRadius = UDim.new(0, 8)
riCorner.Parent = robloxInfo

-- Save/Register inputs
local userBox = Instance.new("TextBox")
userBox.Size = UDim2.new(0.92, 0, 0, 32)
userBox.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
userBox.PlaceholderText = "Username or Custom Key..."
userBox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
userBox.Text = ""
userBox.TextColor3 = Color3.fromRGB(255, 255, 255)
userBox.Font = Enum.Font.Gotham
userBox.TextSize = 12
userBox.Parent = AccountScroll

local ubCorner = Instance.new("UICorner")
ubCorner.CornerRadius = UDim.new(0, 8)
ubCorner.Parent = userBox

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.92, 0, 0, 32)
saveBtn.BackgroundColor3 = Color3.fromRGB(45, 150, 80)
saveBtn.Text = "Register / Save Login"
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 12
saveBtn.Parent = AccountScroll

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 8)
sbCorner.Parent = saveBtn

saveBtn.MouseButton1Click:Connect(function()
	if userBox.Text ~= "" then
		if writefile then
			pcall(function()
				writefile("HydrogenAccountData.txt", userBox.Text)
			end)
		end
		createToast("Account info registered & saved!")
	else
		createToast("Please enter a username or key.")
	end
end)

-- Auto load saved account data if exists
if readfile then
	pcall(function()
		if isfile and isfile("HydrogenAccountData.txt") then
			local saved = readfile("HydrogenAccountData.txt")
			userBox.Text = saved
		end
	end)
end

-- Bottom Action Buttons (Execute / Clear)
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

--- SIDEBAR NAVIGATION BUTTONS
local navButtons = {
	{Name = "Editor", Icon = "rbxassetid://6031075931", Page = EditorPage},
	{Name = "Script Hub", Icon = "rbxassetid://6031154871", Page = ScriptHubPage},
	{Name = "Settings", Icon = "rbxassetid://6031280882", Page = SettingsPage},
	{Name = "Account", Icon = "rbxassetid://14384012061", Page = AccountPage}
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

	local navStroke = Instance.new("UIStroke")
	navStroke.Color = Color3.fromRGB(20, 20, 20)
	navStroke.Thickness = 1.5
	navStroke.Parent = btn

	btn.MouseButton1Click:Connect(function()
		EditorPage.Visible = false
		ScriptHubPage.Visible = false
		SettingsPage.Visible = false
		AccountPage.Visible = false
		
		nav.Page.Visible = true
		CurrentTabLabel.Text = "Your Current Tab: " .. nav.Name
	end)

	startY = startY + spacing
end
