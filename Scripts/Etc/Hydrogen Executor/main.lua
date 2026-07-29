-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Definindo a nova paleta de cores (Preto e Cinza Muito Escuro)
local Color_Background = Color3.fromRGB(0, 0, 0)
local Color_Element = Color3.fromRGB(25, 25, 25)
local Color_Text_Primary = Color3.fromRGB(255, 255, 255)
local Color_Text_Secondary = Color3.fromRGB(180, 180, 180)
local Color_Stroke = Color3.fromRGB(60, 60, 60)
local Color_Accent_Positive = Color3.fromRGB(45, 150, 80)
local Color_Accent_Negative = Color3.fromRGB(180, 50, 50)

-- Parent ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HydrogenMobileUI_Ultimate_V2"
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
    toast.BackgroundColor3 = Color_Element
    toast.BorderSizePixel = 0
    toast.ZIndex = 50
    toast.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toast

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color_Stroke
    stroke.Thickness = 1.2
    stroke.Parent = toast

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Color_Text_Primary
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

-- === NOVO: Loading Toast Central com Opção Delta Kill ===
local LoadingToast = Instance.new("Frame")
LoadingToast.Name = "LoadingToast"
LoadingToast.Size = UDim2.new(0, 300, 0, 100)
LoadingToast.Position = UDim2.new(0.5, -150, 0.45, 0)
LoadingToast.BackgroundColor3 = Color_Element
LoadingToast.BorderSizePixel = 0
LoadingToast.ZIndex = 100
LoadingToast.Parent = ScreenGui

local ltCorner = Instance.new("UICorner")
ltCorner.CornerRadius = UDim.new(0, 15)
ltCorner.Parent = LoadingToast

local ltStroke = Instance.new("UIStroke")
ltStroke.Color = Color_Stroke
ltStroke.Thickness = 2
ltStroke.Parent = LoadingToast

local ltLabel = Instance.new("TextLabel")
ltLabel.Size = UDim2.new(1, -20, 0, 30)
ltLabel.Position = UDim2.new(0, 10, 0, 15)
ltLabel.BackgroundTransparency = 1
ltLabel.Text = "Hydrogen Executor is loading..."
ltLabel.TextColor3 = Color_Text_Primary
ltLabel.Font = Enum.Font.GothamBold
ltLabel.TextSize = 16
ltLabel.ZIndex = 101
ltLabel.Parent = LoadingToast

local ltLabel2 = Instance.new("TextLabel")
ltLabel2.Size = UDim2.new(1, -20, 0, 20)
ltLabel2.Position = UDim2.new(0, 10, 0, 40)
ltLabel2.BackgroundTransparency = 1
ltLabel2.Text = "Remove competing interfaces (Delta)?"
ltLabel2.TextColor3 = Color_Text_Secondary
ltLabel2.Font = Enum.Font.Gotham
ltLabel2.TextSize = 11
ltLabel2.ZIndex = 101
ltLabel2.Parent = LoadingToast

local ltKillDeltaBtn = Instance.new("TextButton")
ltKillDeltaBtn.Size = UDim2.new(0, 100, 0, 28)
ltKillDeltaBtn.Position = UDim2.new(0.5, -50, 0, 65)
ltKillDeltaBtn.BackgroundColor3 = Color_Accent_Negative
ltKillDeltaBtn.Text = "Remove"
ltKillDeltaBtn.TextColor3 = Color_Text_Primary
ltKillDeltaBtn.Font = Enum.Font.GothamBold
ltKillDeltaBtn.TextSize = 12
ltKillDeltaBtn.ZIndex = 101
ltKillDeltaBtn.Parent = LoadingToast

local ltkbCorner = Instance.new("UICorner")
ltkbCorner.CornerRadius = UDim.new(0, 6)
ltkbCorner.Parent = ltKillDeltaBtn

-- Carregamento e ação
local killDeltaAction = function()
    ltKillDeltaBtn.Text = "Removing..."
    loadstring("for _,v in gethui():GetChildren() do if v:IsA('ScreenGui') and v:FindFirstChild('Executor',true) then v:Destroy() end end")()
    loadstring("exec kill UI")()
    ltKillDeltaBtn.Text = "Done"
    task.wait(1)
end

local finishLoading = function()
    -- Mostra o ícone e frame principal
    ToggleButton.Visible = true
    MainFrame.Visible = true
    isOpen = true
    Blur.Enabled = true
    Blur.Size = 18
    LoadingToast:Destroy()
end

ltKillDeltaBtn.MouseButton1Click:Connect(function()
    killDeltaAction()
    finishLoading()
end)

-- Temporizador para carregamento automático
local autoLoadingTimer = task.delay(5, finishLoading)

-- 1. Floating Toggle Icon (Mais largo/maior, Fundo Preto, Ícone 14384012061)
ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "HydrogenToggle"
ToggleButton.Size = UDim2.new(0, 56, 0, 56) -- Maior para mobile
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color_Background
ToggleButton.Visible = false -- Começa invisível até o carregamento
ToggleButton.Parent = ScreenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = ToggleButton

local toggleImage = Instance.new("ImageLabel")
toggleImage.Size = UDim2.new(0, 24, 0, 24) -- Ícone interno menor
toggleImage.Position = UDim2.new(0.5, -12, 0.5, -12)
toggleImage.BackgroundTransparency = 1
toggleImage.Image = "rbxassetid://14384012061"
toggleImage.Parent = ToggleButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color_Stroke
toggleStroke.Thickness = 2
toggleStroke.Parent = ToggleButton

makeDraggable(ToggleButton)

-- 2. Main Frame Executor
MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 275)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -137)
MainFrame.BackgroundColor3 = Color_Element
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false -- Começa invisível
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
isOpen = true -- Definido como true para inicializar com animação
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
            Size = UDim2.new(0, 460, 0, 275),
            Position = UDim2.new(0.5, -230, 0.5, -137)
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
Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 38, 0, 38)
Logo.Position = UDim2.new(0, 20, 0, 14)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://14384012061"
Logo.Parent = MainFrame

Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 0, 25)
Title.Position = UDim2.new(0, 68, 0, 12)
Title.BackgroundTransparency = 1
Title.Text = "Hydrogen Executor"
Title.TextColor3 = Color_Text_Primary
Title.Font = Enum.Font.GothamBold
Title.TextSize = 19
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

CurrentTabLabel = Instance.new("TextLabel")
CurrentTabLabel.Size = UDim2.new(0, 250, 0, 18)
CurrentTabLabel.Position = UDim2.new(0, 68, 0, 35)
CurrentTabLabel.BackgroundTransparency = 1
CurrentTabLabel.Text = "Your Current Tab: Editor"
CurrentTabLabel.TextColor3 = Color_Text_Secondary
CurrentTabLabel.Font = Enum.Font.Gotham
CurrentTabLabel.TextSize = 12
CurrentTabLabel.TextXAlignment = Enum.TextXAlignment.Left
CurrentTabLabel.Parent = MainFrame

--- PAGES CONTAINER
PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(0, 310, 0, 145)
PageContainer.Position = UDim2.new(0, 20, 0, 65)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

-- 1. EDITOR PAGE
EditorPage = Instance.new("Frame")
EditorPage.Size = UDim2.new(1, 0, 1, 0)
EditorPage.BackgroundTransparency = 1
EditorPage.Parent = PageContainer

ScriptBox = Instance.new("TextBox")
ScriptBox.Size = UDim2.new(1, 0, 1, 0)
ScriptBox.BackgroundColor3 = Color_Background -- Usando o fundo preto
ScriptBox.Text = ""
ScriptBox.PlaceholderText = "Put Your Script Here.."
ScriptBox.PlaceholderColor3 = Color_Text_Secondary
ScriptBox.TextColor3 = Color_Text_Primary
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

-- 2. SCRIPT HUB PAGE
ScriptHubPage = Instance.new("Frame")
ScriptHubPage.Size = UDim2.new(1, 0, 1, 0)
ScriptHubPage.BackgroundTransparency = 1
ScriptHubPage.Visible = false
ScriptHubPage.Parent = PageContainer

SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, 0, 0, 30)
SearchBox.BackgroundColor3 = Color_Background
SearchBox.PlaceholderText = "Search scripts on ScriptBlox..."
SearchBox.PlaceholderColor3 = Color_Text_Secondary
SearchBox.Text = ""
SearchBox.TextColor3 = Color_Text_Primary
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 12
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = ScriptHubPage

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 8)
searchCorner.Parent = SearchBox

HubScroll = Instance.new("ScrollingFrame")
HubScroll.Size = UDim2.new(1, 0, 1, -38)
HubScroll.Position = UDim2.new(0, 0, 0, 38)
HubScroll.BackgroundColor3 = Color_Background
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
				item.BackgroundColor3 = Color_Element
				item.Parent = HubScroll
				
				local itemCorner = Instance.new("UICorner")
				itemCorner.CornerRadius = UDim.new(0, 6)
				itemCorner.Parent = item
				
				local titleLbl = Instance.new("TextLabel")
				titleLbl.Size = UDim2.new(0.7, 0, 1, 0)
				titleLbl.Position = UDim2.new(0, 8, 0, 0)
				titleLbl.BackgroundTransparency = 1
				titleLbl.Text = scr.title or "Unknown Script"
				titleLbl.TextColor3 = Color_Text_Primary
				titleLbl.Font = Enum.Font.GothamMedium
				titleLbl.TextSize = 11
				titleLbl.TextXAlignment = Enum.TextXAlignment.Left
				titleLbl.Parent = item
				
				local loadBtn = Instance.new("TextButton")
				loadBtn.Size = UDim2.new(0, 65, 0, 24)
				loadBtn.Position = UDim2.new(1, -70, 0.5, -12)
				loadBtn.BackgroundColor3 = Color3.fromRGB(45, 140, 200)
				loadBtn.Text = "Get Script"
				loadBtn.TextColor3 = Color_Text_Primary
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

-- 3. SAVES SCRIPTS PAGE
SavesPage = Instance.new("Frame")
SavesPage.Size = UDim2.new(1, 0, 1, 0)
SavesPage.BackgroundTransparency = 1
SavesPage.Visible = false
SavesPage.Parent = PageContainer

SaveNameBox = Instance.new("TextBox")
SaveNameBox.Size = UDim2.new(0.7, 0, 0, 30)
SaveNameBox.BackgroundColor3 = Color_Background
SaveNameBox.PlaceholderText = "Script Name..."
SaveNameBox.PlaceholderColor3 = Color_Text_Secondary
SaveNameBox.Text = ""
SaveNameBox.TextColor3 = Color_Text_Primary
SaveNameBox.Font = Enum.Font.Gotham
SaveNameBox.TextSize = 12
SaveNameBox.ClearTextOnFocus = false
SaveNameBox.Parent = SavesPage

local snbCorner = Instance.new("UICorner")
snbCorner.CornerRadius = UDim.new(0, 8)
snbCorner.Parent = SaveNameBox

SaveCurrentBtn = Instance.new("TextButton")
SaveCurrentBtn.Size = UDim2.new(0.26, 0, 0, 30)
SaveCurrentBtn.Position = UDim2.new(0.74, 0, 0, 0)
SaveCurrentBtn.BackgroundColor3 = Color_Accent_Positive
SaveCurrentBtn.Text = "Save"
SaveCurrentBtn.TextColor3 = Color_Text_Primary
SaveCurrentBtn.Font = Enum.Font.GothamBold
SaveCurrentBtn.TextSize = 11
SaveCurrentBtn.Parent = SavesPage

local scbCorner = Instance.new("UICorner")
scbCorner.CornerRadius = UDim.new(0, 8)
scbCorner.Parent = SaveCurrentBtn

SavesScroll = Instance.new("ScrollingFrame")
SavesScroll.Size = UDim2.new(1, 0, 1, -38)
SavesScroll.Position = UDim2.new(0, 0, 0, 38)
SavesScroll.BackgroundColor3 = Color_Background
SavesScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
SavesScroll.ScrollBarThickness = 4
SavesScroll.Parent = SavesPage

local savesCorner = Instance.new("UICorner")
savesCorner.CornerRadius = UDim.new(0, 12)
savesCorner.Parent = SavesScroll

local savesListLayout = Instance.new("UIListLayout")
savesListLayout.Padding = UDim.new(0, 5)
savesListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
savesListLayout.Parent = SavesScroll

savedScriptsTable = {}

local function refreshSavesList()
	for _, child in ipairs(SavesScroll:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	
	local count = 0
	for _ in pairs(savedScriptsTable) do count = count + 1 end
	SavesScroll.CanvasSize = UDim2.new(0, 0, 0, count * 38)
	
	for name, code in pairs(savedScriptsTable) do
		local item = Instance.new("Frame")
		item.Size = UDim2.new(0.94, 0, 0, 34)
		item.BackgroundColor3 = Color_Element
		item.Parent = SavesScroll
		
		local itemCorner = Instance.new("UICorner")
		itemCorner.CornerRadius = UDim.new(0, 6)
		itemCorner.Parent = item
		
		local titleLbl = Instance.new("TextLabel")
		titleLbl.Size = UDim2.new(0.55, 0, 1, 0)
		titleLbl.Position = UDim2.new(0, 8, 0, 0)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = name
		titleLbl.TextColor3 = Color_Text_Primary
		titleLbl.Font = Enum.Font.GothamMedium
		titleLbl.TextSize = 11
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		titleLbl.Parent = item
		
		local loadBtn = Instance.new("TextButton")
		loadBtn.Size = UDim2.new(0, 50, 0, 22)
		loadBtn.Position = UDim2.new(1, -108, 0.5, -11)
		loadBtn.BackgroundColor3 = Color3.fromRGB(45, 140, 200)
		loadBtn.Text = "Load"
		loadBtn.TextColor3 = Color_Text_Primary
		loadBtn.Font = Enum.Font.GothamBold
		loadBtn.TextSize = 10
		loadBtn.Parent = item
		
		local lbC = Instance.new("UICorner")
		lbC.CornerRadius = UDim.new(0, 4)
		lbC.Parent = loadBtn
		
		loadBtn.MouseButton1Click:Connect(function()
			ScriptBox.Text = code
			EditorPage.Visible = true
			SavesPage.Visible = false
			CurrentTabLabel.Text = "Your Current Tab: Editor"
			createToast("Loaded '" .. name .. "' to editor!")
		end)
		
		local delBtn = Instance.new("TextButton")
		delBtn.Size = UDim2.new(0, 50, 0, 22)
		delBtn.Position = UDim2.new(1, -54, 0.5, -11)
		delBtn.BackgroundColor3 = Color_Accent_Negative
		delBtn.Text = "Del"
		delBtn.TextColor3 = Color_Text_Primary
		delBtn.Font = Enum.Font.GothamBold
		delBtn.TextSize = 10
		delBtn.Parent = item
		
		local dbC = Instance.new("UICorner")
		dbC.CornerRadius = UDim.new(0, 4)
		dbC.Parent = delBtn
		
		delBtn.MouseButton1Click:Connect(function()
			savedScriptsTable[name] = nil
			pcall(function()
				if writefile then
					writefile("HydrogenSavedScripts.json", HttpService:JSONEncode(savedScriptsTable))
				end
			end)
			refreshSavesList()
			createToast("Deleted script '" .. name .. "'")
		end)
	end
end

-- Load saved scripts from file if exists
pcall(function()
	if readfile and isfile and isfile("HydrogenSavedScripts.json") then
		local content = readfile("HydrogenSavedScripts.json")
		savedScriptsTable = HttpService:JSONDecode(content)
		refreshSavesList()
	end
end)

SaveCurrentBtn.MouseButton1Click:Connect(function()
	local sName = SaveNameBox.Text
	if sName ~= "" and ScriptBox.Text ~= "" then
		savedScriptsTable[sName] = ScriptBox.Text
		pcall(function()
			if writefile then
				writefile("HydrogenSavedScripts.json", HttpService:JSONEncode(savedScriptsTable))
			end
		end)
		SaveNameBox.Text = ""
		refreshSavesList()
		createToast("Script saved successfully!")
	else
		createToast("Enter a name and write a script!")
	end
end)

-- 4. SETTINGS PAGE (Configs & Customization)
SettingsPage = Instance.new("Frame")
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = PageContainer

ConfigsScroll = Instance.new("ScrollingFrame")
ConfigsScroll.Size = UDim2.new(1, 0, 1, 0)
ConfigsScroll.BackgroundColor3 = Color_Background
ConfigsScroll.CanvasSize = UDim2.new(0, 0, 0, 310)
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

-- === NOVO: Funções de Layout Retro/Antigo Baseado na Imagem ===
local isRetroTheme = false
SidebarButtons = {} -- Tabela para armazenar containers de navegação

local function setOldLayout(enabled)
    isRetroTheme = enabled
    if enabled then
        createToast("Old Layout Activated")
        -- Ajuste de Frame Principal para Topo
        MainFrame.Size = UDim2.new(0, 420, 0, 200)
        MainFrame.Position = UDim2.new(0.5, -210, 0.1, 0)
        -- Esconde textos e logos modernos
        Logo.Visible = false
        Title.Visible = false
        CurrentTabLabel.Visible = false
        -- Reposiciona Editor/Páginas
        PageContainer.Size = UDim2.new(0, 290, 0, 110)
        PageContainer.Position = UDim2.new(0.5, -145, 0.35, 0)
        ScriptBox.Size = UDim2.new(1, 0, 1, 0)
        
        -- Oculta os botões ActionExecute/Clear Modernos
        ExecuteBtn.Visible = false
        ClearBtn.Visible = false
        
        -- Oculta os labels da sidebar
        for _, navObj in ipairs(SidebarButtons) do
            navObj.Label.Visible = false
        end
    else
        createToast("Modern Layout Restored")
        -- Restaura Frame Principal Moderno
        MainFrame.Size = UDim2.new(0, 460, 0, 275)
        MainFrame.Position = UDim2.new(0.5, -230, 0.5, -137)
        -- Restaura textos e logos modernos
        Logo.Visible = true
        Title.Visible = true
        CurrentTabLabel.Visible = true
        -- Restaura Reposiciona Editor/Páginas
        PageContainer.Size = UDim2.new(0, 310, 0, 145)
        PageContainer.Position = UDim2.new(0, 20, 0, 65)
        ScriptBox.Size = UDim2.new(1, 0, 1, 0)
        
        -- Restaura os botões ActionExecute/Clear Modernos
        ExecuteBtn.Visible = true
        ClearBtn.Visible = true
        
        -- Restaura os labels da sidebar
        for _, navObj in ipairs(SidebarButtons) do
            navObj.Label.Visible = true
        end
    end
end

local function addConfigToggle(name, defaultState, callback)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(0.92, 0, 0, 32)
	f.BackgroundColor3 = Color_Element
	f.Parent = ConfigsScroll
	
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = f
	
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(0.65, 0, 1, 0)
	l.Position = UDim2.new(0, 10, 0, 0)
	l.BackgroundTransparency = 1
	l.Text = name
	l.TextColor3 = Color_Text_Primary
	l.Font = Enum.Font.GothamMedium
	l.TextSize = 12
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Parent = f
	
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 55, 0, 22)
	b.Position = UDim2.new(1, -62, 0.5, -11)
	b.BackgroundColor3 = defaultState and Color_Accent_Positive or Color_Accent_Negative
	b.Text = defaultState and "ON" or "OFF"
	b.TextColor3 = Color_Text_Primary
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
		b.BackgroundColor3 = state and Color_Accent_Positive or Color_Accent_Negative
		callback(state)
	end)
end

-- === NOVO: Toggles de Layout e Delta ===
addConfigToggle("Compensate Old Layout (Retro)", false, function(state)
    setOldLayout(state)
end)

addConfigToggle("Disable Competing UIs (Delta)", true, function(state)
    if state then
        createToast("Delta UI suppression activated.")
    end
end)

addConfigToggle("Unlock Max FPS (Uncapped)", true, function(state)
	if state then setfpslimit(999) createToast("Max FPS Unlocked!") end
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

-- 5. ACCOUNT PAGE (Com Bloqueio de Nomes Proibidos)
AccountPage = Instance.new("Frame")
AccountPage.Size = UDim2.new(1, 0, 1, 0)
AccountPage.BackgroundTransparency = 1
AccountPage.Visible = false
AccountPage.Parent = PageContainer

AccountScroll = Instance.new("ScrollingFrame")
AccountScroll.Size = UDim2.new(1, 0, 1, 0)
AccountScroll.BackgroundColor3 = Color_Background
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

local robloxInfo = Instance.new("TextLabel")
robloxInfo.Size = UDim2.new(0.92, 0, 0, 55)
robloxInfo.BackgroundColor3 = Color_Element
robloxInfo.Text = " User: " .. LocalPlayer.Name .. "\n ID: " .. LocalPlayer.UserId .. "\n Executor: Hydrogen Mobile Pro"
robloxInfo.TextColor3 = Color_Text_Primary
robloxInfo.Font = Enum.Font.Gotham
robloxInfo.TextSize = 11
robloxInfo.TextXAlignment = Enum.TextXAlignment.Left
robloxInfo.TextYAlignment = Enum.TextYAlignment.Center
robloxInfo.Parent = AccountScroll

local riCorner = Instance.new("UICorner")
riCorner.CornerRadius = UDim.new(0, 8)
riCorner.Parent = robloxInfo

local userBox = Instance.new("TextBox")
userBox.Size = UDim2.new(0.92, 0, 0, 32)
userBox.BackgroundColor3 = Color_Element
userBox.PlaceholderText = "Username or Custom Key..."
userBox.PlaceholderColor3 = Color_Text_Secondary
userBox.Text = ""
userBox.TextColor3 = Color_Text_Primary
userBox.Font = Enum.Font.Gotham
userBox.TextSize = 12
userBox.Parent = AccountScroll

local ubCorner = Instance.new("UICorner")
ubCorner.CornerRadius = UDim.new(0, 8)
ubCorner.Parent = userBox

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.92, 0, 0, 32)
saveBtn.BackgroundColor3 = Color_Accent_Positive
saveBtn.Text = "Register / Save Login"
saveBtn.TextColor3 = Color_Text_Primary
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 12
saveBtn.Parent = AccountScroll

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 8)
sbCorner.Parent = saveBtn

local forbiddenNames = {"hydrogen", "localerror", "admin", "owner", "system", "root", "mod", "moderator", "developer"}

saveBtn.MouseButton1Click:Connect(function()
	local inputName = string.lower(userBox.Text)
	if inputName ~= "" then
		local isForbidden = false
		for _, forbidden in ipairs(forbiddenNames) do
			if string.find(inputName, forbidden) then
				isForbidden = true
				break
			end
		end
		
		if isForbidden then
			createToast("Error: Name contains reserved words!")
		else
			if writefile then
				pcall(function()
					writefile("HydrogenAccountData.txt", userBox.Text)
				end)
			end
			createToast("Account registered successfully!")
		end
	else
		createToast("Please enter a valid name.")
	end
end)

if readfile then
	pcall(function()
		if isfile and isfile("HydrogenAccountData.txt") then
			local saved = readfile("HydrogenAccountData.txt")
			userBox.Text = saved
		end
	end)
end

-- Bottom Action Buttons (Execute / Clear)
ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(0, 70, 0, 28)
ExecuteBtn.Position = UDim2.new(0, 20, 0, 230)
ExecuteBtn.BackgroundColor3 = Color_Accent_Positive
ExecuteBtn.Text = "Execute"
ExecuteBtn.TextColor3 = Color_Text_Primary
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

ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0, 70, 0, 28)
ClearBtn.Position = UDim2.new(0, 98, 0, 230)
ClearBtn.BackgroundColor3 = Color_Accent_Negative
ClearBtn.Text = "Clear"
ClearBtn.TextColor3 = Color_Text_Primary
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
	{Name = "Saves", Icon = "rbxassetid://6023426915", Page = SavesPage},
	{Name = "Settings", Icon = "rbxassetid://6031280882", Page = SettingsPage},
	{Name = "Account", Icon = "rbxassetid://14384012061", Page = AccountPage}
}

local startY = 5
local spacing = 52

for _, nav in ipairs(navButtons) do
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0, 50, 0, 48)
	container.Position = UDim2.new(1, -68, 0, startY)
	container.BackgroundTransparency = 1
	container.Parent = MainFrame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 20, 0, 10)
	label.Position = UDim2.new(0, -10, 0, -2)
	label.BackgroundTransparency = 1
	label.Text = nav.Name
	label.TextColor3 = Color_Text_Primary
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 9
	label.Parent = container

	local btn = Instance.new("ImageButton")
	btn.Size = UDim2.new(0, 36, 0, 36)
	btn.Position = UDim2.new(0.5, -18, 0, 10)
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

    -- === NOVO: Adiciona a tabela para controle de layout ===
    table.insert(SidebarButtons, {Container = container, Label = label, Button = btn})

	btn.MouseButton1Click:Connect(function()
		EditorPage.Visible = false
		ScriptHubPage.Visible = false
		SavesPage.Visible = false
		SettingsPage.Visible = false
		AccountPage.Visible = false
		
		nav.Page.Visible = true
		CurrentTabLabel.Text = "Your Current Tab: " .. nav.Name
	end)

	startY = startY + spacing
end
