--[[
	Pocket GUI Studio - mobile-friendly Roblox GUI designer

	INSTALL:
	1. Open your own experience in Roblox Studio.
	2. Create a LocalScript inside StarterPlayer > StarterPlayerScripts.
	3. Paste this entire file into that LocalScript and press Play.

	SECURITY MODEL:
	Roblox clients cannot safely compile arbitrary text as Luau. Controls created by
	this designer therefore use named callbacks from ACTIONS. Add game-specific,
	Studio-reviewed callbacks to ACTIONS in the exported script. Validate every
	RemoteEvent on the server; never trust arguments supplied by a client.

	COPYING ON MOBILE:
	The normal Roblox client has no clipboard-writing API. "SELECT CODE" focuses
	the export box so it can be selected/copied with the device's normal controls.
]]

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("PocketGuiStudio")
if old then
	old:Destroy()
end

local THEMES = {
	Midnight = {
		background = Color3.fromRGB(11, 14, 22),
		panel = Color3.fromRGB(19, 24, 36),
		panel2 = Color3.fromRGB(27, 33, 48),
		accent = Color3.fromRGB(109, 94, 252),
		accent2 = Color3.fromRGB(75, 211, 255),
		text = Color3.fromRGB(241, 244, 255),
		muted = Color3.fromRGB(148, 157, 181),
		danger = Color3.fromRGB(244, 86, 108),
		stroke = Color3.fromRGB(49, 58, 79),
	},
	Carbon = {
		background = Color3.fromRGB(13, 13, 14),
		panel = Color3.fromRGB(24, 24, 27),
		panel2 = Color3.fromRGB(36, 36, 40),
		accent = Color3.fromRGB(245, 158, 11),
		accent2 = Color3.fromRGB(250, 204, 21),
		text = Color3.fromRGB(250, 250, 250),
		muted = Color3.fromRGB(161, 161, 170),
		danger = Color3.fromRGB(239, 68, 68),
		stroke = Color3.fromRGB(63, 63, 70),
	},
	Ocean = {
		background = Color3.fromRGB(6, 18, 30),
		panel = Color3.fromRGB(9, 31, 48),
		panel2 = Color3.fromRGB(14, 45, 66),
		accent = Color3.fromRGB(0, 174, 239),
		accent2 = Color3.fromRGB(45, 212, 191),
		text = Color3.fromRGB(236, 254, 255),
		muted = Color3.fromRGB(148, 187, 203),
		danger = Color3.fromRGB(251, 113, 133),
		stroke = Color3.fromRGB(30, 74, 94),
	},
	Crimson = {
		background = Color3.fromRGB(23, 8, 14),
		panel = Color3.fromRGB(39, 13, 23),
		panel2 = Color3.fromRGB(57, 19, 33),
		accent = Color3.fromRGB(225, 29, 72),
		accent2 = Color3.fromRGB(251, 113, 133),
		text = Color3.fromRGB(255, 241, 244),
		muted = Color3.fromRGB(205, 153, 169),
		danger = Color3.fromRGB(248, 113, 113),
		stroke = Color3.fromRGB(92, 35, 54),
	},
}

local themeNames = { "Midnight", "Carbon", "Ocean", "Crimson" }
local themeIndex = 1
local theme = THEMES[themeNames[themeIndex]]

local project = {
	title = "My Mobile GUI",
	width = 270,
	height = 250,
	elements = {},
}

local selectedIndex = nil
local statusLabel
local previewWindow
local previewCanvas
local previewTitle
local selectedLabel
local kindLabel
local labelInput
local xInput
local yInput
local wInput
local hInput
local actionInput
local offActionInput
local exportBox

local screen = Instance.new("ScreenGui")
screen.Name = "PocketGuiStudio"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = false
screen.DisplayOrder = 1000
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Parent = playerGui

local function create(className, properties, parent)
	local object = Instance.new(className)
	for key, value in pairs(properties or {}) do
		object[key] = value
	end
	object.Parent = parent
	return object
end

local function corner(parent, radius)
	return create("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, parent)
end

local function stroke(parent, color, thickness, transparency)
	return create("UIStroke", {
		Color = color or theme.stroke,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
	}, parent)
end

local function tag(object, role)
	object:SetAttribute("ThemeRole", role)
	return object
end

local function setStatus(message, isError)
	if not statusLabel then
		return
	end
	statusLabel.Text = message
	statusLabel.TextColor3 = isError and theme.danger or theme.muted
end

local function clampNumber(text, fallback, minimum, maximum)
	local number = tonumber(text)
	if not number then
		return fallback
	end
	return math.clamp(math.floor(number + 0.5), minimum, maximum)
end

local function makeDraggable(handle, target, onMoved)
	local dragging = false
	local dragInput
	local dragStart
	local startPosition

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = target.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					if onMoved then
						onMoved(target.Position)
					end
				end
			end)
		end
	end)

	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,
				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			)
		end
	end)
end

local function makeButton(text, parent, size)
	local button = tag(create("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = theme.panel2,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamMedium,
		Text = text,
		TextColor3 = theme.text,
		TextSize = 12,
		Size = size or UDim2.new(1, 0, 0, 34),
	}, parent), "panel2")
	corner(button, 8)
	stroke(button, theme.stroke, 1, 0.25)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.12), { BackgroundColor3 = theme.accent }):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.12), { BackgroundColor3 = theme.panel2 }):Play()
	end)
	return button
end

local function makeLabel(text, parent, size)
	return tag(create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = text,
		TextColor3 = theme.muted,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = size or UDim2.new(1, 0, 0, 20),
	}, parent), "mutedText")
end

local function makeInput(placeholder, parent, size)
	local input = tag(create("TextBox", {
		BackgroundColor3 = theme.background,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		Font = Enum.Font.Code,
		PlaceholderText = placeholder,
		PlaceholderColor3 = theme.muted,
		Text = "",
		TextColor3 = theme.text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = size or UDim2.new(1, 0, 0, 34),
	}, parent), "background")
	create("UIPadding", {
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
	}, input)
	corner(input, 8)
	stroke(input, theme.stroke, 1, 0.2)
	return input
end

local function applyTheme()
	theme = THEMES[themeNames[themeIndex]]
	for _, object in ipairs(screen:GetDescendants()) do
		local role = object:GetAttribute("ThemeRole")
		if role == "background" and object:IsA("GuiObject") then
			object.BackgroundColor3 = theme.background
		elseif role == "panel" and object:IsA("GuiObject") then
			object.BackgroundColor3 = theme.panel
		elseif role == "panel2" and object:IsA("GuiObject") then
			object.BackgroundColor3 = theme.panel2
		elseif role == "accent" and object:IsA("GuiObject") then
			object.BackgroundColor3 = theme.accent
		elseif role == "danger" and object:IsA("GuiObject") then
			object.BackgroundColor3 = theme.danger
		elseif role == "text" and (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then
			object.TextColor3 = theme.text
		elseif role == "mutedText" and (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then
			object.TextColor3 = theme.muted
		elseif role == "stroke" and object:IsA("UIStroke") then
			object.Color = theme.stroke
		end
	end
	if statusLabel then
		statusLabel.TextColor3 = theme.muted
	end
end

-- Editor shell
local editor = tag(create("Frame", {
	Name = "Editor",
	AnchorPoint = Vector2.new(0, 0.5),
	BackgroundColor3 = theme.background,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 10, 0.5, 0),
	Size = UDim2.fromOffset(310, 430),
}, screen), "background")
corner(editor, 13)
tag(stroke(editor, theme.stroke, 1, 0), "stroke")

local viewportScale = create("UIScale", { Scale = 1 }, editor)
local camera = workspace.CurrentCamera
local function updateScale()
	local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
	viewportScale.Scale = math.clamp(math.min((viewport.X - 18) / 310, (viewport.Y - 18) / 430), 0.72, 1)
end
updateScale()
if camera then
	camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

local header = tag(create("Frame", {
	Name = "Header",
	BackgroundColor3 = theme.panel,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 42),
}, editor), "panel")
corner(header, 13)

local headerCover = tag(create("Frame", {
	BackgroundColor3 = theme.panel,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 1, -13),
	Size = UDim2.new(1, 0, 0, 13),
}, header), "panel")

local logo = tag(create("Frame", {
	BackgroundColor3 = theme.accent,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(10, 10),
	Size = UDim2.fromOffset(22, 22),
}, header), "accent")
corner(logo, 7)
tag(create("TextLabel", {
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "P",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = 13,
	Size = UDim2.fromScale(1, 1),
}, logo), "text")

tag(create("TextLabel", {
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "POCKET GUI STUDIO",
	TextColor3 = theme.text,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Left,
	Position = UDim2.fromOffset(40, 0),
	Size = UDim2.new(1, -112, 1, 0),
}, header), "text")

local minimizeEditor = tag(create("TextButton", {
	AutoButtonColor = false,
	BackgroundColor3 = theme.panel2,
	BorderSizePixel = 0,
	Font = Enum.Font.GothamBold,
	Text = "—",
	TextColor3 = theme.text,
	TextSize = 14,
	Position = UDim2.new(1, -66, 0, 8),
	Size = UDim2.fromOffset(26, 26),
}, header), "panel2")
corner(minimizeEditor, 7)

local closeEditor = tag(create("TextButton", {
	AutoButtonColor = false,
	BackgroundColor3 = theme.danger,
	BorderSizePixel = 0,
	Font = Enum.Font.GothamBold,
	Text = "×",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = 16,
	Position = UDim2.new(1, -34, 0, 8),
	Size = UDim2.fromOffset(26, 26),
}, header), "danger")
corner(closeEditor, 7)

makeDraggable(header, editor)

local body = tag(create("Frame", {
	Name = "Body",
	BackgroundColor3 = theme.background,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(0, 42),
	Size = UDim2.new(1, 0, 1, -42),
}, editor), "background")

local minimized = false
minimizeEditor.Activated:Connect(function()
	minimized = not minimized
	body.Visible = not minimized
	minimizeEditor.Text = minimized and "+" or "—"
	TweenService:Create(editor, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
		Size = minimized and UDim2.fromOffset(310, 42) or UDim2.fromOffset(310, 430),
	}):Play()
end)
closeEditor.Activated:Connect(function()
	screen:Destroy()
end)

local tabs = tag(create("Frame", {
	BackgroundColor3 = theme.panel,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(8, 8),
	Size = UDim2.new(1, -16, 0, 36),
}, body), "panel")
corner(tabs, 9)
create("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	Padding = UDim.new(0, 4),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, tabs)
create("UIPadding", {
	PaddingLeft = UDim.new(0, 4),
	PaddingRight = UDim.new(0, 4),
	PaddingTop = UDim.new(0, 4),
	PaddingBottom = UDim.new(0, 4),
}, tabs)

local pages = create("Frame", {
	BackgroundTransparency = 1,
	ClipsDescendants = true,
	Position = UDim2.fromOffset(8, 50),
	Size = UDim2.new(1, -16, 1, -76),
}, body)

local function makePage(name)
	local page = create("ScrollingFrame", {
		Name = name,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(),
		ScrollBarImageColor3 = theme.accent,
		ScrollBarThickness = 3,
		Size = UDim2.fromScale(1, 1),
		Visible = false,
	}, pages)
	create("UIListLayout", {
		Padding = UDim.new(0, 7),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, page)
	create("UIPadding", {
		PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 1),
		PaddingRight = UDim.new(0, 5),
	}, page)
	return page
end

local buildPage = makePage("BUILD")
local elementPage = makePage("ELEMENT")
local exportPage = makePage("EXPORT")
local pageByName = { BUILD = buildPage, ELEMENT = elementPage, EXPORT = exportPage }
local tabButtons = {}

local function showPage(name)
	for pageName, page in pairs(pageByName) do
		page.Visible = pageName == name
	end
	for tabName, button in pairs(tabButtons) do
		button.BackgroundColor3 = tabName == name and theme.accent or theme.panel
		button:SetAttribute("ThemeRole", tabName == name and "accent" or "panel")
	end
end

for order, name in ipairs({ "BUILD", "ELEMENT", "EXPORT" }) do
	local tab = tag(create("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = theme.panel,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamBold,
		LayoutOrder = order,
		Text = name,
		TextColor3 = theme.text,
		TextSize = 10,
		Size = UDim2.new(1 / 3, -4, 1, 0),
	}, tabs), "panel")
	corner(tab, 7)
	tab.Activated:Connect(function()
		showPage(name)
	end)
	tabButtons[name] = tab
end

statusLabel = makeLabel("Ready — drag controls directly in the preview.", body, UDim2.new(1, -16, 0, 18))
statusLabel.Position = UDim2.new(0, 8, 1, -22)
statusLabel.TextSize = 9

-- Preview renderer
local function selectElement(index)
	if #project.elements == 0 then
		selectedIndex = nil
	elseif index then
		selectedIndex = math.clamp(index, 1, #project.elements)
	end

	local data = selectedIndex and project.elements[selectedIndex] or nil
	if data then
		selectedLabel.Text = string.format("SELECTED %d / %d", selectedIndex, #project.elements)
		kindLabel.Text = "TYPE: " .. string.upper(data.kind)
		labelInput.Text = data.text
		xInput.Text = tostring(data.x)
		yInput.Text = tostring(data.y)
		wInput.Text = tostring(data.w)
		hInput.Text = tostring(data.h)
		actionInput.Text = data.action or "None"
		offActionInput.Text = data.offAction or "None"
	else
		selectedLabel.Text = "NO ELEMENT SELECTED"
		kindLabel.Text = "Add a control from the Build tab."
		labelInput.Text = ""
		xInput.Text = ""
		yInput.Text = ""
		wInput.Text = ""
		hInput.Text = ""
		actionInput.Text = ""
		offActionInput.Text = ""
	end
end

local function styleControl(control, data, selected)
	control.BackgroundColor3 = data.kind == "toggle" and theme.panel2 or theme.accent
	control.TextColor3 = theme.text
	local controlStroke = stroke(control, selected and theme.accent2 or theme.stroke, selected and 2 or 1, selected and 0 or 0.35)
	controlStroke.Name = "SelectionStroke"
	corner(control, 8)
end

local function renderPreview()
	if not previewWindow or not previewCanvas then
		return
	end
	previewWindow.Size = UDim2.fromOffset(project.width, project.height)
	previewTitle.Text = project.title

	for _, child in ipairs(previewCanvas:GetChildren()) do
		if child:GetAttribute("GeneratedControl") then
			child:Destroy()
		end
	end

	for index, data in ipairs(project.elements) do
		local control = create("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = data.kind == "toggle" and theme.panel2 or theme.accent,
			BorderSizePixel = 0,
			Font = Enum.Font.GothamMedium,
			Position = UDim2.fromOffset(data.x, data.y),
			Size = UDim2.fromOffset(data.w, data.h),
			Text = data.kind == "toggle"
				and ((data.state and "●  " or "○  ") .. data.text)
				or data.text,
			TextColor3 = theme.text,
			TextSize = 11,
			ZIndex = 12,
		}, previewCanvas)
		control:SetAttribute("GeneratedControl", true)
		styleControl(control, data, index == selectedIndex)

		local startPos
		local moved = false
		control.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch
				or input.UserInputType == Enum.UserInputType.MouseButton1 then
				startPos = input.Position
				moved = false
			end
		end)
		control.InputChanged:Connect(function(input)
			if startPos and (input.UserInputType == Enum.UserInputType.Touch
				or input.UserInputType == Enum.UserInputType.MouseMovement) then
				if (input.Position - startPos).Magnitude > 4 then
					moved = true
				end
			end
		end)
		control.Activated:Connect(function()
			selectedIndex = index
			if data.kind == "toggle" and not moved then
				data.state = not data.state
			end
			selectElement(index)
			renderPreview()
		end)
		makeDraggable(control, control, function(position)
			data.x = math.clamp(position.X.Offset, 0, math.max(0, project.width - data.w))
			data.y = math.clamp(position.Y.Offset, 0, math.max(0, project.height - 42 - data.h))
			control.Position = UDim2.fromOffset(data.x, data.y)
			selectElement(index)
			setStatus("Position updated by dragging.")
		end)
	end
end

local function addElement(kind)
	local number = #project.elements + 1
	local labels = {
		button = "New Button",
		toggle = "New Toggle",
		minimize = "—",
		close = "×",
	}
	local widths = { button = 126, toggle = 126, minimize = 34, close = 34 }
	local data = {
		kind = kind,
		text = labels[kind] or "Control",
		x = 12 + ((number - 1) % 2) * 136,
		y = 12 + math.floor((number - 1) / 2) * 44,
		w = widths[kind] or 126,
		h = 34,
		action = kind == "minimize" and "Minimize" or (kind == "close" and "Close" or "Notify"),
		offAction = "None",
		state = false,
	}
	data.x = math.clamp(data.x, 0, math.max(0, project.width - data.w))
	data.y = math.clamp(data.y, 0, math.max(0, project.height - 42 - data.h))
	table.insert(project.elements, data)
	selectedIndex = #project.elements
	selectElement(selectedIndex)
	renderPreview()
	showPage("ELEMENT")
	setStatus("Added " .. kind .. ". Drag it in the preview.")
end

-- Preview window is separate so the editor stays compact.
previewWindow = tag(create("Frame", {
	Name = "LivePreview",
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = theme.background,
	BorderSizePixel = 0,
	Position = UDim2.new(0.68, 0, 0.5, 0),
	Size = UDim2.fromOffset(project.width, project.height),
	ZIndex = 10,
}, screen), "background")
corner(previewWindow, 12)
tag(stroke(previewWindow, theme.stroke, 1, 0), "stroke")

local previewHeader = tag(create("Frame", {
	BackgroundColor3 = theme.panel,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 42),
	ZIndex = 11,
}, previewWindow), "panel")
corner(previewHeader, 12)
tag(create("Frame", {
	BackgroundColor3 = theme.panel,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 1, -12),
	Size = UDim2.new(1, 0, 0, 12),
	ZIndex = 11,
}, previewHeader), "panel")

previewTitle = tag(create("TextLabel", {
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = project.title,
	TextColor3 = theme.text,
	TextSize = 12,
	TextTruncate = Enum.TextTruncate.AtEnd,
	TextXAlignment = Enum.TextXAlignment.Left,
	Position = UDim2.fromOffset(13, 0),
	Size = UDim2.new(1, -26, 1, 0),
	ZIndex = 12,
}, previewHeader), "text")

previewCanvas = tag(create("Frame", {
	Name = "Canvas",
	BackgroundColor3 = theme.background,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Position = UDim2.fromOffset(0, 42),
	Size = UDim2.new(1, 0, 1, -42),
	ZIndex = 11,
}, previewWindow), "background")
makeDraggable(previewHeader, previewWindow)

-- Build page
makeLabel("PROJECT", buildPage)
local titleInput = makeInput("GUI title", buildPage)
titleInput.Text = project.title

local sizeRow = create("Frame", {
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 0, 34),
}, buildPage)
local widthInput = makeInput("Width", sizeRow, UDim2.new(0.28, -3, 1, 0))
widthInput.Text = tostring(project.width)
local heightInput = makeInput("Height", sizeRow, UDim2.new(0.28, -3, 1, 0))
heightInput.Position = UDim2.new(0.28, 3, 0, 0)
heightInput.Text = tostring(project.height)
local applyProject = makeButton("APPLY SIZE", sizeRow, UDim2.new(0.44, -6, 1, 0))
applyProject.Position = UDim2.new(0.56, 6, 0, 0)

local styleButton = makeButton("STYLE: MIDNIGHT", buildPage)
styleButton.Activated:Connect(function()
	themeIndex = themeIndex % #themeNames + 1
	styleButton.Text = "STYLE: " .. string.upper(themeNames[themeIndex])
	applyTheme()
	renderPreview()
	setStatus("Style changed to " .. themeNames[themeIndex] .. ".")
end)

makeLabel("ADD CONTROLS", buildPage)
local addRow1 = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34) }, buildPage)
local addButton = makeButton("+ BUTTON", addRow1, UDim2.new(0.5, -3, 1, 0))
local addToggle = makeButton("+ TOGGLE", addRow1, UDim2.new(0.5, -3, 1, 0))
addToggle.Position = UDim2.new(0.5, 3, 0, 0)

local addRow2 = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34) }, buildPage)
local addMinimize = makeButton("+ MINIMIZE", addRow2, UDim2.new(0.5, -3, 1, 0))
local addClose = makeButton("+ CLOSE", addRow2, UDim2.new(0.5, -3, 1, 0))
addClose.Position = UDim2.new(0.5, 3, 0, 0)

local runFromBuild = makeButton("▶ RUN GUI", buildPage)
runFromBuild.BackgroundColor3 = theme.accent
runFromBuild:SetAttribute("ThemeRole", "accent")

local clearButton = makeButton("CLEAR ALL CONTROLS", buildPage)
clearButton.TextColor3 = theme.danger

applyProject.Activated:Connect(function()
	project.title = titleInput.Text ~= "" and titleInput.Text or "My Mobile GUI"
	project.width = clampNumber(widthInput.Text, project.width, 180, 600)
	project.height = clampNumber(heightInput.Text, project.height, 120, 600)
	widthInput.Text = tostring(project.width)
	heightInput.Text = tostring(project.height)
	for _, data in ipairs(project.elements) do
		data.w = math.min(data.w, project.width)
		data.h = math.min(data.h, math.max(24, project.height - 42))
		data.x = math.clamp(data.x, 0, math.max(0, project.width - data.w))
		data.y = math.clamp(data.y, 0, math.max(0, project.height - 42 - data.h))
	end
	renderPreview()
	setStatus("Project title and size applied.")
end)

titleInput.FocusLost:Connect(function()
	project.title = titleInput.Text ~= "" and titleInput.Text or project.title
	renderPreview()
end)

addButton.Activated:Connect(function() addElement("button") end)
addToggle.Activated:Connect(function() addElement("toggle") end)
addMinimize.Activated:Connect(function() addElement("minimize") end)
addClose.Activated:Connect(function() addElement("close") end)
clearButton.Activated:Connect(function()
	table.clear(project.elements)
	selectedIndex = nil
	selectElement(nil)
	renderPreview()
	setStatus("All preview controls cleared.")
end)

-- Element page
selectedLabel = makeLabel("NO ELEMENT SELECTED", elementPage)
selectedLabel.Font = Enum.Font.GothamBold
selectedLabel.TextColor3 = theme.text
selectedLabel:SetAttribute("ThemeRole", "text")
kindLabel = makeLabel("Add a control from the Build tab.", elementPage)
labelInput = makeInput("Button text", elementPage)

local posRow = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34) }, elementPage)
xInput = makeInput("X", posRow, UDim2.new(0.25, -4, 1, 0))
yInput = makeInput("Y", posRow, UDim2.new(0.25, -4, 1, 0))
yInput.Position = UDim2.new(0.25, 2, 0, 0)
wInput = makeInput("W", posRow, UDim2.new(0.25, -4, 1, 0))
wInput.Position = UDim2.new(0.5, 4, 0, 0)
hInput = makeInput("H", posRow, UDim2.new(0.25, -4, 1, 0))
hInput.Position = UDim2.new(0.75, 6, 0, 0)

makeLabel("ACTION NAME (Notify, Counter, ColorPulse, None)", elementPage)
actionInput = makeInput("Action when pressed / toggle ON", elementPage)
offActionInput = makeInput("Action when toggle turns OFF", elementPage)

local applyElement = makeButton("APPLY ELEMENT", elementPage)
applyElement.BackgroundColor3 = theme.accent
applyElement:SetAttribute("ThemeRole", "accent")

local navRow = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34) }, elementPage)
local previousButton = makeButton("‹ PREV", navRow, UDim2.new(1 / 3, -4, 1, 0))
local duplicateButton = makeButton("DUPLICATE", navRow, UDim2.new(1 / 3, -4, 1, 0))
duplicateButton.Position = UDim2.new(1 / 3, 2, 0, 0)
local nextButton = makeButton("NEXT ›", navRow, UDim2.new(1 / 3, -4, 1, 0))
nextButton.Position = UDim2.new(2 / 3, 4, 0, 0)

local deleteButton = makeButton("DELETE SELECTED", elementPage)
deleteButton.TextColor3 = theme.danger

applyElement.Activated:Connect(function()
	local data = selectedIndex and project.elements[selectedIndex]
	if not data then
		setStatus("Select a preview element first.", true)
		return
	end
	data.text = labelInput.Text ~= "" and labelInput.Text or data.text
	data.w = clampNumber(wInput.Text, data.w, 24, project.width)
	data.h = clampNumber(hInput.Text, data.h, 24, math.max(24, project.height - 42))
	data.x = clampNumber(xInput.Text, data.x, 0, math.max(0, project.width - data.w))
	data.y = clampNumber(yInput.Text, data.y, 0, math.max(0, project.height - 42 - data.h))
	data.action = actionInput.Text ~= "" and actionInput.Text or "None"
	data.offAction = offActionInput.Text ~= "" and offActionInput.Text or "None"
	selectElement(selectedIndex)
	renderPreview()
	setStatus("Element settings applied.")
end)

previousButton.Activated:Connect(function()
	if #project.elements > 0 then
		selectElement((selectedIndex or 2) - 1 < 1 and #project.elements or (selectedIndex or 2) - 1)
		renderPreview()
	end
end)
nextButton.Activated:Connect(function()
	if #project.elements > 0 then
		selectElement((selectedIndex or 0) % #project.elements + 1)
		renderPreview()
	end
end)
duplicateButton.Activated:Connect(function()
	local data = selectedIndex and project.elements[selectedIndex]
	if data then
		local copy = table.clone(data)
		copy.x = math.clamp(copy.x + 10, 0, math.max(0, project.width - copy.w))
		copy.y = math.clamp(copy.y + 10, 0, math.max(0, project.height - 42 - copy.h))
		table.insert(project.elements, copy)
		selectedIndex = #project.elements
		selectElement(selectedIndex)
		renderPreview()
		setStatus("Element duplicated.")
	end
end)
deleteButton.Activated:Connect(function()
	if selectedIndex and project.elements[selectedIndex] then
		table.remove(project.elements, selectedIndex)
		selectedIndex = #project.elements > 0 and math.min(selectedIndex, #project.elements) or nil
		selectElement(selectedIndex)
		renderPreview()
		setStatus("Selected element deleted.")
	end
end)

-- Safe actions used by the live Run GUI copy.
local runtimeCounter = 0
local function notify(text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = project.title,
			Text = text,
			Duration = 2,
		})
	end)
end

local function executeSafeAction(actionName, control, runtimeRoot, runtimeBody)
	local normalized = string.lower((actionName or "None"):gsub("%s+", ""))
	if normalized == "" or normalized == "none" then
		return
	elseif normalized == "notify" then
		notify("Pressed " .. control.Text)
	elseif normalized == "counter" then
		runtimeCounter += 1
		control.Text = "Count: " .. runtimeCounter
	elseif normalized == "colorpulse" then
		local original = control.BackgroundColor3
		TweenService:Create(control, TweenInfo.new(0.16), { BackgroundColor3 = theme.accent2 }):Play()
		task.delay(0.2, function()
			if control.Parent then
				TweenService:Create(control, TweenInfo.new(0.2), { BackgroundColor3 = original }):Play()
			end
		end)
	elseif normalized == "minimize" then
		if runtimeBody then
			runtimeBody.Visible = not runtimeBody.Visible
			runtimeRoot.Size = runtimeBody.Visible
				and UDim2.fromOffset(project.width, project.height)
				or UDim2.fromOffset(project.width, 42)
			local runtimeHeader = runtimeRoot:FindFirstChild("Header")
			local restoreButton = runtimeHeader and runtimeHeader:FindFirstChild("RestoreButton")
			if restoreButton and restoreButton:IsA("GuiObject") then
				restoreButton.Visible = not runtimeBody.Visible
			end
		end
	elseif normalized == "close" then
		local runtimeScreen = runtimeRoot:FindFirstAncestorOfClass("ScreenGui")
		if runtimeScreen then
			runtimeScreen:Destroy()
		end
	else
		notify("Unknown action: " .. tostring(actionName))
	end
end

local function runGui()
	local previous = playerGui:FindFirstChild("PocketGuiRuntime")
	if previous then
		previous:Destroy()
	end

	local runtimeScreen = create("ScreenGui", {
		Name = "PocketGuiRuntime",
		ResetOnSpawn = false,
		DisplayOrder = 900,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, playerGui)
	local runtimeRoot = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.background,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(project.width, project.height),
	}, runtimeScreen)
	corner(runtimeRoot, 12)
	stroke(runtimeRoot, theme.stroke, 1, 0)
	local runtimeHeader = create("Frame", {
		Name = "Header",
		BackgroundColor3 = theme.panel,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 42),
	}, runtimeRoot)
	corner(runtimeHeader, 12)
	create("Frame", {
		BackgroundColor3 = theme.panel,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, -12),
		Size = UDim2.new(1, 0, 0, 12),
	}, runtimeHeader)
	create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = project.title,
		TextColor3 = theme.text,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.fromOffset(13, 0),
		Size = UDim2.new(1, -26, 1, 0),
	}, runtimeHeader)
	local runtimeRestore = create("TextButton", {
		Name = "RestoreButton",
		AutoButtonColor = false,
		BackgroundColor3 = theme.accent,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamBold,
		Text = "+",
		TextColor3 = theme.text,
		TextSize = 14,
		Position = UDim2.new(1, -34, 0, 8),
		Size = UDim2.fromOffset(26, 26),
		Visible = false,
		ZIndex = 3,
	}, runtimeHeader)
	corner(runtimeRestore, 7)
	local runtimeBody = create("Frame", {
		BackgroundColor3 = theme.background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(0, 42),
		Size = UDim2.new(1, 0, 1, -42),
	}, runtimeRoot)
	makeDraggable(runtimeHeader, runtimeRoot)
	runtimeRestore.Activated:Connect(function()
		runtimeBody.Visible = true
		runtimeRoot.Size = UDim2.fromOffset(project.width, project.height)
		runtimeRestore.Visible = false
	end)

	for _, original in ipairs(project.elements) do
		local data = table.clone(original)
		local control = create("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = data.kind == "toggle" and theme.panel2 or theme.accent,
			BorderSizePixel = 0,
			Font = Enum.Font.GothamMedium,
			Position = UDim2.fromOffset(data.x, data.y),
			Size = UDim2.fromOffset(data.w, data.h),
			Text = data.kind == "toggle" and "○  " .. data.text or data.text,
			TextColor3 = theme.text,
			TextSize = 11,
		}, runtimeBody)
		corner(control, 8)
		stroke(control, theme.stroke, 1, 0.35)
		local state = false
		control.Activated:Connect(function()
			if data.kind == "toggle" then
				state = not state
				control.Text = (state and "●  " or "○  ") .. data.text
				executeSafeAction(state and data.action or data.offAction, control, runtimeRoot, runtimeBody)
			else
				executeSafeAction(data.action, control, runtimeRoot, runtimeBody)
			end
		end)
	end

	setStatus("Runtime GUI created. Press its controls to test actions.")
end

runFromBuild.Activated:Connect(runGui)

-- Exporter
local function quote(value)
	return string.format("%q", tostring(value))
end

local function colorLiteral(color)
	return string.format(
		"Color3.fromRGB(%d, %d, %d)",
		math.floor(color.R * 255 + 0.5),
		math.floor(color.G * 255 + 0.5),
		math.floor(color.B * 255 + 0.5)
	)
end

local function generateCode()
	local elementLines = {}
	for _, data in ipairs(project.elements) do
		table.insert(elementLines, string.format(
			"\t{kind=%s,text=%s,x=%d,y=%d,w=%d,h=%d,action=%s,offAction=%s},",
			quote(data.kind), quote(data.text), data.x, data.y, data.w, data.h,
			quote(data.action or "None"), quote(data.offAction or "None")
		))
	end

	local template = [=[-- Generated by Pocket GUI Studio
-- Put this LocalScript in StarterPlayerScripts in an experience you own.

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local CONFIG = {
	title = __TITLE__,
	width = __WIDTH__,
	height = __HEIGHT__,
	background = __BACKGROUND__,
	panel = __PANEL__,
	panel2 = __PANEL2__,
	accent = __ACCENT__,
	accent2 = __ACCENT2__,
	text = __TEXT__,
	stroke = __STROKE__,
}

local ELEMENTS = {
__ELEMENTS__
}

local function notify(message)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = CONFIG.title,
			Text = message,
			Duration = 2,
		})
	end)
end

-- Safe named callbacks. Add your own Studio-reviewed functions here.
-- Keep authority on the server and validate all RemoteEvent arguments there.
local ACTIONS = {}
local counter = 0

ACTIONS.None = function() end
ACTIONS.Notify = function(control)
	notify("Pressed " .. control.Text)
end
ACTIONS.Counter = function(control)
	counter += 1
	control.Text = "Count: " .. counter
end
ACTIONS.ColorPulse = function(control)
	local original = control.BackgroundColor3
	TweenService:Create(control, TweenInfo.new(0.16), {BackgroundColor3 = CONFIG.accent2}):Play()
	task.delay(0.2, function()
		if control.Parent then
			TweenService:Create(control, TweenInfo.new(0.2), {BackgroundColor3 = original}):Play()
		end
	end)
end

-- Example for code you own and review:
-- ACTIONS.OpenShop = function(control, guiRoot, content)
--     content.Visible = true
-- end

local function make(className, properties, parent)
	local object = Instance.new(className)
	for key, value in pairs(properties) do object[key] = value end
	object.Parent = parent
	return object
end

local function round(parent, radius)
	make("UICorner", {CornerRadius = UDim.new(0, radius)}, parent)
end

local function outline(parent, color, transparency)
	make("UIStroke", {Color = color, Thickness = 1, Transparency = transparency or 0}, parent)
end

local function draggable(handle, target)
	local dragging, dragInput, dragStart, startPosition
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = target.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(
				startPosition.X.Scale, startPosition.X.Offset + delta.X,
				startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
			)
		end
	end)
end

local old = playerGui:FindFirstChild("GeneratedPocketGui")
if old then old:Destroy() end

local screen = make("ScreenGui", {
	Name = "GeneratedPocketGui",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)
local root = make("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = CONFIG.background,
	BorderSizePixel = 0,
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(CONFIG.width, CONFIG.height),
}, screen)
round(root, 12)
outline(root, CONFIG.stroke)

local header = make("Frame", {
	Name = "Header",
	BackgroundColor3 = CONFIG.panel,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 42),
}, root)
round(header, 12)
make("Frame", {
	BackgroundColor3 = CONFIG.panel,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 1, -12),
	Size = UDim2.new(1, 0, 0, 12),
}, header)
make("TextLabel", {
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = CONFIG.title,
	TextColor3 = CONFIG.text,
	TextSize = 12,
	TextTruncate = Enum.TextTruncate.AtEnd,
	TextXAlignment = Enum.TextXAlignment.Left,
	Position = UDim2.fromOffset(13, 0),
	Size = UDim2.new(1, -26, 1, 0),
}, header)
local restoreButton = make("TextButton", {
	Name = "RestoreButton",
	AutoButtonColor = false,
	BackgroundColor3 = CONFIG.accent,
	BorderSizePixel = 0,
	Font = Enum.Font.GothamBold,
	Text = "+",
	TextColor3 = CONFIG.text,
	TextSize = 14,
	Position = UDim2.new(1, -34, 0, 8),
	Size = UDim2.fromOffset(26, 26),
	Visible = false,
}, header)
round(restoreButton, 7)

local content = make("Frame", {
	BackgroundColor3 = CONFIG.background,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Position = UDim2.fromOffset(0, 42),
	Size = UDim2.new(1, 0, 1, -42),
}, root)
draggable(header, root)

ACTIONS.Minimize = function()
	content.Visible = not content.Visible
	root.Size = content.Visible
		and UDim2.fromOffset(CONFIG.width, CONFIG.height)
		or UDim2.fromOffset(CONFIG.width, 42)
	restoreButton.Visible = not content.Visible
end
ACTIONS.Close = function()
	screen:Destroy()
end

restoreButton.Activated:Connect(function()
	content.Visible = true
	root.Size = UDim2.fromOffset(CONFIG.width, CONFIG.height)
	restoreButton.Visible = false
end)

local function runAction(name, control)
	local callback = ACTIONS[name]
	if not callback then
		local wanted = string.lower(tostring(name or ""))
		for actionName, candidate in pairs(ACTIONS) do
			if string.lower(actionName) == wanted then
				callback = candidate
				break
			end
		end
	end
	if callback then
		local ok, problem = pcall(callback, control, root, content)
		if not ok then warn("GUI action failed:", problem) end
	else
		warn("No callback named " .. tostring(name) .. " in ACTIONS")
	end
end

for _, data in ipairs(ELEMENTS) do
	local isToggle = data.kind == "toggle"
	local state = false
	local control = make("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = isToggle and CONFIG.panel2 or CONFIG.accent,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamMedium,
		Position = UDim2.fromOffset(data.x, data.y),
		Size = UDim2.fromOffset(data.w, data.h),
		Text = isToggle and "○  " .. data.text or data.text,
		TextColor3 = CONFIG.text,
		TextSize = 11,
	}, content)
	round(control, 8)
	outline(control, CONFIG.stroke, 0.35)
	control.Activated:Connect(function()
		if isToggle then
			state = not state
			control.Text = (state and "●  " or "○  ") .. data.text
			runAction(state and data.action or data.offAction, control)
		else
			runAction(data.action, control)
		end
	end)
end
]=]

	local replacements = {
		["__TITLE__"] = quote(project.title),
		["__WIDTH__"] = tostring(project.width),
		["__HEIGHT__"] = tostring(project.height),
		["__BACKGROUND__"] = colorLiteral(theme.background),
		["__PANEL__"] = colorLiteral(theme.panel),
		["__PANEL2__"] = colorLiteral(theme.panel2),
		["__ACCENT__"] = colorLiteral(theme.accent),
		["__ACCENT2__"] = colorLiteral(theme.accent2),
		["__TEXT__"] = colorLiteral(theme.text),
		["__STROKE__"] = colorLiteral(theme.stroke),
		["__ELEMENTS__"] = table.concat(elementLines, "\n"),
	}
	for marker, value in pairs(replacements) do
		template = template:gsub(marker, function() return value end)
	end
	return template
end

makeLabel("GENERATED LOCALSCRIPT", exportPage)
exportBox = makeInput("Press GENERATE CODE", exportPage, UDim2.new(1, 0, 0, 205))
exportBox.MultiLine = true
exportBox.TextEditable = true
exportBox.TextSize = 10
exportBox.TextWrapped = false
exportBox.TextXAlignment = Enum.TextXAlignment.Left
exportBox.TextYAlignment = Enum.TextYAlignment.Top
exportBox.ClearTextOnFocus = false

local generateButton = makeButton("GENERATE CODE", exportPage)
generateButton.BackgroundColor3 = theme.accent
generateButton:SetAttribute("ThemeRole", "accent")
local selectCodeButton = makeButton("SELECT CODE / MANUAL COPY", exportPage)
local runFromExport = makeButton("▶ RUN GUI", exportPage)

generateButton.Activated:Connect(function()
	exportBox.Text = generateCode()
	exportBox.CursorPosition = 1
	setStatus("Standalone LocalScript generated.")
end)
selectCodeButton.Activated:Connect(function()
	if exportBox.Text == "" then
		exportBox.Text = generateCode()
	end
	exportBox:CaptureFocus()
	exportBox.CursorPosition = #exportBox.Text + 1
	exportBox.SelectionStart = 1
	setStatus("Code selected. Use your device's Copy command.")
end)
runFromExport.Activated:Connect(runGui)

showPage("BUILD")
selectElement(nil)
addElement("button")
showPage("BUILD")
renderPreview()
setStatus("Ready — customize the sample button or add more controls.")
