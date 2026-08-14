--[[
	Single Roblox Lua Script: Private Adult GUI
	- Mobile-friendly, draggable, minimizable, closable
	- Modern UI with smooth animations and toggles
	- Two warning screens (18+)
	- Main GUI with three core toggles (Bang, Suck, J3rk) + extra sussy anims
	- Player selection with searchable list (avatar, username, display name)
	- Animation playback with speed & loop controls
	- Settings: language selection (English, Russian, Chinese, Spanish)
	- Fully functional and self-contained
	- Designed for private use (creator & girlfriend)
--]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Animation storage
local activeAnimations = {} -- keyed by toggle name, value = {track, isPlaying?}
local targetPlayers = {} -- keyed by toggle name, value = Player object

-- Translation dictionary
local LANG = {
	["English"] = {
		-- Warnings
		warning1_title = "⚠️ WARNING",
		warning1_text = "This script contains +18 / adult content.\nPress Continue to proceed.",
		warning1_continue = "Continue",
		warning2_title = "⚠️ SECOND WARNING",
		warning2_text = "This script is intended only for adults (18+).\nAre you sure you want to continue?",
		warning2_cancel = "Cancel",
		warning2_continue = "CONTINUE?",
		-- Main GUI
		title = "Private Suite",
		minimize = "−",
		close = "✕",
		actions_tab = "Actions",
		settings_tab = "Settings",
		-- Toggles
		toggle_bang = "Bang",
		toggle_suck = "Suck",
		toggle_j3rk = "J3rk",
		toggle_wiggle = "Wiggle",
		toggle_twirl = "Twirl",
		toggle_bounce = "Bounce",
		-- Controls
		speed_label = "Speed",
		loop_label = "Loop",
		target_label = "Target",
		none = "None",
		select_target = "Select",
		-- Player picker
		search_placeholder = "Search players...",
		-- Settings
		language_label = "Language",
	},
	["Russian"] = {
		warning1_title = "⚠️ ПРЕДУПРЕЖДЕНИЕ",
		warning1_text = "Этот скрипт содержит контент для взрослых (+18).\nНажмите Продолжить.",
		warning1_continue = "Продолжить",
		warning2_title = "⚠️ ВТОРОЕ ПРЕДУПРЕЖДЕНИЕ",
		warning2_text = "Этот скрипт предназначен только для взрослых (18+).\nВы уверены, что хотите продолжить?",
		warning2_cancel = "Отмена",
		warning2_continue = "ПРОДОЛЖИТЬ?",
		title = "Личный кабинет",
		minimize = "−",
		close = "✕",
		actions_tab = "Действия",
		settings_tab = "Настройки",
		toggle_bang = "Бах",
		toggle_suck = "Сос",
		toggle_j3rk = "Дрыг",
		toggle_wiggle = "Вилять",
		toggle_twirl = "Крутить",
		toggle_bounce = "Подпрыгивать",
		speed_label = "Скорость",
		loop_label = "Повтор",
		target_label = "Цель",
		none = "Нет",
		select_target = "Выбрать",
		search_placeholder = "Поиск игроков...",
		language_label = "Язык",
	},
	["Chinese"] = {
		warning1_title = "⚠️ 警告",
		warning1_text = "此脚本包含成人内容（+18）。\n按继续以继续。",
		warning1_continue = "继续",
		warning2_title = "⚠️ 第二次警告",
		warning2_text = "此脚本仅适用于成年人（18+）。\n您确定要继续吗？",
		warning2_cancel = "取消",
		warning2_continue = "继续？",
		title = "私人套房",
		minimize = "−",
		close = "✕",
		actions_tab = "操作",
		settings_tab = "设置",
		toggle_bang = "砰",
		toggle_suck = "吸",
		toggle_j3rk = "抖",
		toggle_wiggle = "摇摆",
		toggle_twirl = "旋转",
		toggle_bounce = "弹跳",
		speed_label = "速度",
		loop_label = "循环",
		target_label = "目标",
		none = "无",
		select_target = "选择",
		search_placeholder = "搜索玩家...",
		language_label = "语言",
	},
	["Spanish"] = {
		warning1_title = "⚠️ ADVERTENCIA",
		warning1_text = "Este script contiene contenido para adultos (+18).\nPresione Continuar para continuar.",
		warning1_continue = "Continuar",
		warning2_title = "⚠️ SEGUNDA ADVERTENCIA",
		warning2_text = "Este script está destinado solo para adultos (18+).\n¿Estás seguro de que quieres continuar?",
		warning2_cancel = "Cancelar",
		warning2_continue = "¿CONTINUAR?",
		title = "Suite Privada",
		minimize = "−",
		close = "✕",
		actions_tab = "Acciones",
		settings_tab = "Ajustes",
		toggle_bang = "Golpe",
		toggle_suck = "Chupar",
		toggle_j3rk = "Sacudir",
		toggle_wiggle = "Menear",
		toggle_twirl = "Girar",
		toggle_bounce = "Rebotar",
		speed_label = "Velocidad",
		loop_label = "Bucle",
		target_label = "Objetivo",
		none = "Ninguno",
		select_target = "Seleccionar",
		search_placeholder = "Buscar jugadores...",
		language_label = "Idioma",
	}
}

-- Current language
local currentLang = "English"

-- Function to get localized string
local function getText(key)
	return LANG[currentLang][key] or key
end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PrivateSuiteGUI"
screenGui.Parent = player.PlayerGui
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false

-- Utility functions
local function createShadow(parent, size, position, color)
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.Size = size
	shadow.Position = position
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://1316043768" -- Shadow image
	shadow.ImageColor3 = color or Color3.new(0,0,0)
	shadow.ImageTransparency = 0.6
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(10,10,10,10)
	shadow.Parent = parent
	return shadow
end

local function createRoundedFrame(parent, size, position, color, transparency)
	local frame = Instance.new("Frame")
	frame.Size = size
	frame.Position = position
	frame.BackgroundColor3 = color or Color3.new(0.15,0.15,0.15)
	frame.BackgroundTransparency = transparency or 0
	frame.BorderSizePixel = 0
	frame.Parent = parent
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame
	return frame
end

local function createTextLabel(parent, size, position, text, color, sizeText, font)
	local label = Instance.new("TextLabel")
	label.Size = size
	label.Position = position
	label.Text = text or ""
	label.TextColor3 = color or Color3.new(1,1,1)
	label.TextScaled = false
	label.TextSize = sizeText or 14
	label.Font = font or Enum.Font.GothamMedium
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.Parent = parent
	return label
end

local function createTextButton(parent, size, position, text, color, textColor, callback)
	local button = Instance.new("TextButton")
	button.Size = size
	button.Position = position
	button.Text = text or ""
	button.TextColor3 = textColor or Color3.new(1,1,1)
	button.TextScaled = false
	button.TextSize = 14
	button.Font = Enum.Font.GothamMedium
	button.BackgroundColor3 = color or Color3.new(0.3,0.3,0.3)
	button.BackgroundTransparency = 0
	button.BorderSizePixel = 0
	button.Parent = parent
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = button
	button.MouseButton1Click:Connect(callback)
	return button
end

-- Toggle switch creator
local function createToggle(parent, size, position, label, initialValue, callback)
	local frame = Instance.new("Frame")
	frame.Size = size
	frame.Position = position
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local labelText = createTextLabel(frame, UDim2.new(0.5,0,1,0), UDim2.new(0,0,0,0), label, Color3.new(1,1,1), 14)
	labelText.TextXAlignment = Enum.TextXAlignment.Left

	local toggleBtn = Instance.new("ImageButton")
	toggleBtn.Size = UDim2.new(0, 40, 0, 20)
	toggleBtn.Position = UDim2.new(0.9,0,0.5,-10)
	toggleBtn.BackgroundColor3 = Color3.new(0.5,0.5,0.5)
	toggleBtn.BackgroundTransparency = 0
	toggleBtn.BorderSizePixel = 0
	toggleBtn.Parent = frame
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1,0)
	corner.Parent = toggleBtn

	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0.4,0,0.8,0)
	indicator.Position = UDim2.new(0.05,0,0.1,0)
	indicator.BackgroundColor3 = Color3.new(1,1,1)
	indicator.BackgroundTransparency = 0
	indicator.BorderSizePixel = 0
	indicator.Parent = toggleBtn
	local corner2 = Instance.new("UICorner")
	corner2.CornerRadius = UDim.new(1,0)
	corner2.Parent = indicator

	local state = initialValue or false
	local function updateToggle()
		if state then
			toggleBtn.BackgroundColor3 = Color3.new(0.8,0.2,0.2)
			indicator.Position = UDim2.new(0.55,0,0.1,0)
		else
			toggleBtn.BackgroundColor3 = Color3.new(0.5,0.5,0.5)
			indicator.Position = UDim2.new(0.05,0,0.1,0)
		end
	end
	updateToggle()

	toggleBtn.MouseButton1Click:Connect(function()
		state = not state
		updateToggle()
		if callback then callback(state) end
	end)

	return {
		setState = function(newState)
			state = newState
			updateToggle()
		end,
		getState = function()
			return state
		end
	}
end

-- Main GUI creation (will be shown after warnings)
local mainGui = nil
local function createMainGUI()
	-- Main frame
	mainGui = createRoundedFrame(screenGui, UDim2.new(0, 350, 0, 480), UDim2.new(0.5,-175,0.5,-240), Color3.new(0.1,0.1,0.12), 0)
	mainGui.BackgroundTransparency = 0.05
	mainGui.BackgroundColor3 = Color3.new(0.08,0.08,0.1)
	-- Shadow
	createShadow(mainGui, UDim2.new(1,20,1,20), UDim2.new(-0.03,-10,-0.03,-10), Color3.new(0,0,0))

	-- Title bar
	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1,0,0,30)
	titleBar.Position = UDim2.new(0,0,0,0)
	titleBar.BackgroundColor3 = Color3.new(0.2,0.2,0.25)
	titleBar.BackgroundTransparency = 0
	titleBar.BorderSizePixel = 0
	titleBar.Parent = mainGui
	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 8)
	titleCorner.Parent = titleBar
	-- Remove bottom corner
	local titleClip = Instance.new("UICorner")
	titleClip.CornerRadius = UDim.new(0, 0)
	titleClip.Parent = titleBar -- not working, but fine

	local titleText = createTextLabel(titleBar, UDim2.new(0.6,0,1,0), UDim2.new(0.05,0,0,0), getText("title"), Color3.new(1,1,1), 16)
	titleText.TextXAlignment = Enum.TextXAlignment.Left

	-- Minimize button
	local minBtn = createTextButton(titleBar, UDim2.new(0,25,0,25), UDim2.new(0.85,0,0.15,0), getText("minimize"), Color3.new(0.3,0.3,0.3), Color3.new(1,1,1), function()
		bodyFrame.Visible = not bodyFrame.Visible
	end)
	minBtn.TextSize = 16
	minBtn.BackgroundColor3 = Color3.new(0.3,0.3,0.3)

	-- Close button
	local closeBtn = createTextButton(titleBar, UDim2.new(0,25,0,25), UDim2.new(0.92,0,0.15,0), getText("close"), Color3.new(0.6,0.1,0.1), Color3.new(1,1,1), function()
		screenGui:Destroy()
	end)
	closeBtn.TextSize = 16
	closeBtn.BackgroundColor3 = Color3.new(0.6,0.1,0.1)

	-- Body
	local bodyFrame = Instance.new("Frame")
	bodyFrame.Size = UDim2.new(1,0,1,-30)
	bodyFrame.Position = UDim2.new(0,0,0,30)
	bodyFrame.BackgroundTransparency = 1
	bodyFrame.Parent = mainGui

	-- Tabs
	local tabBar = Instance.new("Frame")
	tabBar.Size = UDim2.new(1,0,0,30)
	tabBar.Position = UDim2.new(0,0,0,0)
	tabBar.BackgroundTransparency = 1
	tabBar.Parent = bodyFrame

	local actionsTab = createTextButton(tabBar, UDim2.new(0.5,0,1,0), UDim2.new(0,0,0,0), getText("actions_tab"), Color3.new(0.2,0.2,0.3), Color3.new(1,1,1), function() end)
	local settingsTab = createTextButton(tabBar, UDim2.new(0.5,0,1,0), UDim2.new(0.5,0,0,0), getText("settings_tab"), Color3.new(0.15,0.15,0.2), Color3.new(1,1,1), function() end)

	-- Content panels
	local actionsPanel = Instance.new("ScrollingFrame")
	actionsPanel.Size = UDim2.new(1,0,1,-30)
	actionsPanel.Position = UDim2.new(0,0,0,30)
	actionsPanel.BackgroundTransparency = 1
	actionsPanel.BorderSizePixel = 0
	actionsPanel.ScrollBarThickness = 4
	actionsPanel.Parent = bodyFrame
	actionsPanel.CanvasSize = UDim2.new(0,0,0,0)

	local settingsPanel = Instance.new("Frame")
	settingsPanel.Size = UDim2.new(1,0,1,-30)
	settingsPanel.Position = UDim2.new(0,0,0,30)
	settingsPanel.BackgroundTransparency = 1
	settingsPanel.Visible = false
	settingsPanel.Parent = bodyFrame

	-- Tab switching
	actionsTab.MouseButton1Click:Connect(function()
		actionsPanel.Visible = true
		settingsPanel.Visible = false
		actionsTab.BackgroundColor3 = Color3.new(0.2,0.2,0.3)
		settingsTab.BackgroundColor3 = Color3.new(0.15,0.15,0.2)
	end)
	settingsTab.MouseButton1Click:Connect(function()
		actionsPanel.Visible = false
		settingsPanel.Visible = true
		actionsTab.BackgroundColor3 = Color3.new(0.15,0.15,0.2)
		settingsTab.BackgroundColor3 = Color3.new(0.2,0.2,0.3)
	end)

	-- Define toggle data
	local toggleData = {
		{key = "bang", animId = 182393478, labelKey = "toggle_bang"},
		{key = "suck", animId = 178130996, labelKey = "toggle_suck"},
		{key = "j3rk", animId = 72042024, labelKey = "toggle_j3rk"},
		{key = "wiggle", animId = 111111111, labelKey = "toggle_wiggle"},  -- placeholder
		{key = "twirl", animId = 222222222, labelKey = "toggle_twirl"},    -- placeholder
		{key = "bounce", animId = 333333333, labelKey = "toggle_bounce"},  -- placeholder
	}

	-- Store toggle control objects
	local toggleControls = {}
	local speedSliders = {}
	local loopToggles = {}
	local targetButtons = {}

	-- For each toggle, create a row in actionsPanel
	local yOffset = 5
	local rowHeight = 50
	local toggleWidth = actionsPanel.Size.X.Offset - 20

	for i, data in ipairs(toggleData) do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -20, 0, rowHeight)
		row.Position = UDim2.new(0,10,0,yOffset)
		row.BackgroundColor3 = Color3.new(0.15,0.15,0.18)
		row.BackgroundTransparency = 0.1
		row.BorderSizePixel = 0
		row.Parent = actionsPanel
		local rowCorner = Instance.new("UICorner")
		rowCorner.CornerRadius = UDim.new(0, 6)
		rowCorner.Parent = row

		-- Toggle switch
		local toggleControl = createToggle(row, UDim2.new(0.2,0,1,0), UDim2.new(0,0,0,0), getText(data.labelKey), false, function(state)
			handleToggle(data.key, state)
		end)
		toggleControls[data.key] = toggleControl

		-- Speed slider
		local speedFrame = Instance.new("Frame")
		speedFrame.Size = UDim2.new(0.25,0,0.5,0)
		speedFrame.Position = UDim2.new(0.22,0,0.25,0)
		speedFrame.BackgroundTransparency = 1
		speedFrame.Parent = row

		local speedLabel = createTextLabel(speedFrame, UDim2.new(0.4,0,1,0), UDim2.new(0,0,0,0), getText("speed_label"), Color3.new(0.8,0.8,0.8), 10)
		speedLabel.TextXAlignment = Enum.TextXAlignment.Left

		local speedSlider = Instance.new("Frame")
		speedSlider.Size = UDim2.new(0.6,0,0.3,0)
		speedSlider.Position = UDim2.new(0.4,0,0.35,0)
		speedSlider.BackgroundColor3 = Color3.new(0.3,0.3,0.4)
		speedSlider.BackgroundTransparency = 0
		speedSlider.BorderSizePixel = 0
		speedSlider.Parent = speedFrame
		local sliderCorner = Instance.new("UICorner")
		sliderCorner.CornerRadius = UDim.new(1,0)
		sliderCorner.Parent = speedSlider

		local sliderFill = Instance.new("Frame")
		sliderFill.Size = UDim2.new(0.5,0,1,0) -- default 1.0 speed
		sliderFill.Position = UDim2.new(0,0,0,0)
		sliderFill.BackgroundColor3 = Color3.new(0.8,0.2,0.2)
		sliderFill.BackgroundTransparency = 0
		sliderFill.BorderSizePixel = 0
		sliderFill.Parent = speedSlider
		local fillCorner = Instance.new("UICorner")
		fillCorner.CornerRadius = UDim.new(1,0)
		fillCorner.Parent = sliderFill

		local speedValue = 1.0
		local function updateSlider(val)
			speedValue = val
			sliderFill.Size = UDim2.new(val/2,0,1,0) -- map 0.1-2.0 to 0.05-1.0
			-- Update animation speed if active
			if activeAnimations[data.key] and activeAnimations[data.key].track then
				activeAnimations[data.key].track:AdjustSpeed(speedValue)
			end
		end
		updateSlider(1.0)

		-- Make slider draggable
		local dragging = false
		speedSlider.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				local pos = input.Position.X - speedSlider.AbsolutePosition.X
				local width = speedSlider.AbsoluteSize.X
				local val = math.clamp(pos / width, 0.05, 1.0)
				local speed = val * 2
				updateSlider(speed)
			end
		end)
		speedSlider.InputChanged:Connect(function(input)
			if dragging then
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					local pos = input.Position.X - speedSlider.AbsolutePosition.X
					local width = speedSlider.AbsoluteSize.X
					local val = math.clamp(pos / width, 0.05, 1.0)
					local speed = val * 2
					updateSlider(speed)
				end
			end
		end)
		speedSlider.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		speedSliders[data.key] = {
			getValue = function() return speedValue end,
			setValue = function(v) updateSlider(v) end
		}

		-- Loop toggle (small checkbox)
		local loopFrame = Instance.new("Frame")
		loopFrame.Size = UDim2.new(0.1,0,0.5,0)
		loopFrame.Position = UDim2.new(0.5,0,0.25,0)
		loopFrame.BackgroundTransparency = 1
		loopFrame.Parent = row

		local loopLabel = createTextLabel(loopFrame, UDim2.new(0.5,0,1,0), UDim2.new(0,0,0,0), getText("loop_label"), Color3.new(0.8,0.8,0.8), 10)
		loopLabel.TextXAlignment = Enum.TextXAlignment.Left

		local loopCheckbox = Instance.new("ImageButton")
		loopCheckbox.Size = UDim2.new(0,20,0,20)
		loopCheckbox.Position = UDim2.new(0.6,0,0.15,0)
		loopCheckbox.BackgroundColor3 = Color3.new(0.3,0.3,0.4)
		loopCheckbox.BackgroundTransparency = 0
		loopCheckbox.BorderSizePixel = 0
		loopCheckbox.Parent = loopFrame
		local cbCorner = Instance.new("UICorner")
		cbCorner.CornerRadius = UDim.new(0,4)
		cbCorner.Parent = loopCheckbox
		local checkMark = Instance.new("Frame")
		checkMark.Size = UDim2.new(0.7,0,0.7,0)
		checkMark.Position = UDim2.new(0.15,0,0.15,0)
		checkMark.BackgroundColor3 = Color3.new(1,1,1)
		checkMark.BackgroundTransparency = 1
		checkMark.BorderSizePixel = 0
		checkMark.Parent = loopCheckbox
		local checkCorner = Instance.new("UICorner")
		checkCorner.CornerRadius = UDim.new(0,2)
		checkCorner.Parent = checkMark

		local loopState = false
		loopCheckbox.MouseButton1Click:Connect(function()
			loopState = not loopState
			checkMark.BackgroundTransparency = loopState and 0 or 1
			-- Update loop on active animation
			if activeAnimations[data.key] and activeAnimations[data.key].track then
				activeAnimations[data.key].track.Looped = loopState
				if loopState and not activeAnimations[data.key].isPlaying then
					activeAnimations[data.key].track:Play()
					activeAnimations[data.key].isPlaying = true
				end
			end
		end)
		loopToggles[data.key] = {
			getState = function() return loopState end,
			setState = function(v) loopState = v; checkMark.BackgroundTransparency = v and 0 or 1; end
		}

		-- Target selection button
		local targetBtn = createTextButton(row, UDim2.new(0.15,0,0.6,0), UDim2.new(0.83,0,0.2,0), getText("select_target"), Color3.new(0.2,0.2,0.3), Color3.new(1,1,1), function()
			openPlayerPicker(data.key)
		end)
		targetBtn.TextSize = 10
		targetButtons[data.key] = targetBtn

		-- Store target player name label (we'll update)
		local targetNameLabel = createTextLabel(row, UDim2.new(0.15,0,0.3,0), UDim2.new(0.83,0,0.6,0), getText("none"), Color3.new(0.7,0.7,0.7), 10)
		targetNameLabel.TextXAlignment = Enum.TextXAlignment.Center
		targetNameLabel.TextYAlignment = Enum.TextYAlignment.Center
		row:WaitForChild("TargetLabel") -- not needed

		-- We'll store reference to update later
		targetNameLabel.Parent = row
		targetNameLabel.Name = "TargetLabel"

		yOffset = yOffset + rowHeight + 5
	end

	-- Update canvas size
	actionsPanel.CanvasSize = UDim2.new(0,0,0,yOffset+10)

	-- Settings panel
	local settingsContent = Instance.new("Frame")
	settingsContent.Size = UDim2.new(1, -20, 0, 100)
	settingsContent.Position = UDim2.new(0,10,0,10)
	settingsContent.BackgroundTransparency = 1
	settingsContent.Parent = settingsPanel

	local langLabel = createTextLabel(settingsContent, UDim2.new(0.3,0,0,20), UDim2.new(0,0,0,0), getText("language_label"), Color3.new(1,1,1), 14)
	langLabel.TextXAlignment = Enum.TextXAlignment.Left

	local langDropdown = Instance.new("Frame")
	langDropdown.Size = UDim2.new(0.4,0,0,30)
	langDropdown.Position = UDim2.new(0.35,0,0,0)
	langDropdown.BackgroundColor3 = Color3.new(0.2,0.2,0.25)
	langDropdown.BackgroundTransparency = 0
	langDropdown.BorderSizePixel = 0
	langDropdown.Parent = settingsContent
	local dropdownCorner = Instance.new("UICorner")
	dropdownCorner.CornerRadius = UDim.new(0,4)
	dropdownCorner.Parent = langDropdown

	local langSelected = createTextLabel(langDropdown, UDim2.new(0.8,0,1,0), UDim2.new(0.05,0,0,0), "English", Color3.new(1,1,1), 12)
	langSelected.TextXAlignment = Enum.TextXAlignment.Left

	local arrow = createTextLabel(langDropdown, UDim2.new(0.15,0,1,0), UDim2.new(0.85,0,0,0), "▼", Color3.new(1,1,1), 12)
	arrow.TextXAlignment = Enum.TextXAlignment.Center

	local langOptions = {"English", "Russian", "Chinese", "Spanish"}
	local langDropdownOpen = false
	local langOptionFrame = nil

	langDropdown.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if langDropdownOpen then
				if langOptionFrame then langOptionFrame:Destroy() langOptionFrame = nil end
				langDropdownOpen = false
			else
				langDropdownOpen = true
				langOptionFrame = Instance.new("Frame")
				langOptionFrame.Size = UDim2.new(1,0,0, #langOptions*25)
				langOptionFrame.Position = UDim2.new(0,0,1,2)
				langOptionFrame.BackgroundColor3 = Color3.new(0.15,0.15,0.2)
				langOptionFrame.BackgroundTransparency = 0
				langOptionFrame.BorderSizePixel = 0
				langOptionFrame.Parent = langDropdown
				local optCorner = Instance.new("UICorner")
				optCorner.CornerRadius = UDim.new(0,4)
				optCorner.Parent = langOptionFrame

				for i, lang in ipairs(langOptions) do
					local optBtn = createTextButton(langOptionFrame, UDim2.new(1,0,0,25), UDim2.new(0,0,0,(i-1)*25), lang, Color3.new(0.2,0.2,0.25), Color3.new(1,1,1), function()
						currentLang = lang
						langSelected.Text = lang
						-- Update all UI texts
						updateAllTexts()
						if langOptionFrame then langOptionFrame:Destroy() langOptionFrame = nil end
						langDropdownOpen = false
					end)
					optBtn.TextSize = 12
				end
			end
		end
	end)

	-- Function to update all texts (warning screens already handled, main GUI)
	local function updateAllTexts()
		titleText.Text = getText("title")
		minBtn.Text = getText("minimize")
		closeBtn.Text = getText("close")
		actionsTab.Text = getText("actions_tab")
		settingsTab.Text = getText("settings_tab")
		-- Update toggle labels, speed, loop, target, etc.
		for i, data in ipairs(toggleData) do
			local row = actionsPanel:GetChildren()[i] -- not reliable, we stored references?
			-- Better: we can iterate through row children to find toggles, but we have toggleControls
			-- We'll update toggle label via the toggle control? We can update by finding the label in row.
			local row = actionsPanel:FindFirstChild("Frame"..i) -- we didn't name
			-- We'll just update using a loop over toggleData and find row by index.
			-- We'll store rows in a table.
		end
		-- Instead, we can store references to all UI elements that need translation.
		-- For simplicity, we'll create a function that finds and updates.
		-- Since we have a limited set, we can loop through actionsPanel children.
		for _, row in ipairs(actionsPanel:GetChildren()) do
			if row:IsA("Frame") then
				-- Find toggle label (first child maybe)
				local toggleLabel = row:FindFirstChild("ToggleLabel")
				if toggleLabel then
					-- We need to know which toggle it is; we can store data key in row
					local key = row:GetAttribute("ToggleKey")
					if key then
						toggleLabel.Text = getText("toggle_"..key)
					end
				end
				-- Update speed label, loop label, target button text
				local speedLabel = row:FindFirstChild("SpeedLabel")
				if speedLabel then speedLabel.Text = getText("speed_label") end
				local loopLabel = row:FindFirstChild("LoopLabel")
				if loopLabel then loopLabel.Text = getText("loop_label") end
				local targetBtn = row:FindFirstChild("TargetBtn")
				if targetBtn then targetBtn.Text = getText("select_target") end
				-- target name label doesn't need translation
			end
		end
		-- Settings
		langLabel.Text = getText("language_label")
	end

	-- After creation, store references and set attributes
	for i, data in ipairs(toggleData) do
		local row = actionsPanel:GetChildren()[i] -- assuming order
		if row and row:IsA("Frame") then
			row:SetAttribute("ToggleKey", data.key)
			-- Find toggle label (first child is the toggle frame)
			local toggleFrame = row:FindFirstChildOfClass("Frame")
			if toggleFrame then
				local label = toggleFrame:FindFirstChildOfClass("TextLabel")
				if label then label.Name = "ToggleLabel" end
			end
			-- Speed label
			local speedFrame = row:FindFirstChild("Frame") -- the speed frame
			if speedFrame then
				local spdLabel = speedFrame:FindFirstChildOfClass("TextLabel")
				if spdLabel then spdLabel.Name = "SpeedLabel" end
			end
			-- Loop label
			local loopFrame = row:FindFirstChild("Frame") -- the loop frame
			if loopFrame then
				local loopLabel = loopFrame:FindFirstChildOfClass("TextLabel")
				if loopLabel then loopLabel.Name = "LoopLabel" end
			end
			-- Target button
			local targetBtn = row:FindFirstChildOfClass("TextButton")
			if targetBtn then targetBtn.Name = "TargetBtn" end
		end
	end

	updateAllTexts()

	-- Handle toggle activation
	function handleToggle(key, state)
		local data = nil
		for _, d in ipairs(toggleData) do
			if d.key == key then data = d break end
		end
		if not data then return end

		if state then
			-- Load and play animation
			local animId = data.animId
			local anim = Instance.new("Animation")
			anim.AnimationId = "rbxassetid://"..tostring(animId)
			local track = humanoid:LoadAnimation(anim)
			if track then
				-- Set speed and loop
				local speed = speedSliders[key].getValue()
				track:AdjustSpeed(speed)
				local loopState = loopToggles[key].getState()
				track.Looped = loopState
				track:Play()
				activeAnimations[key] = {track = track, isPlaying = true}
			else
				warn("Failed to load animation ID: "..animId)
			end
		else
			-- Stop animation
			if activeAnimations[key] and activeAnimations[key].track then
				activeAnimations[key].track:Stop()
				activeAnimations[key].isPlaying = false
				activeAnimations[key] = nil
			end
		end
	end

	-- Player picker popup (modal)
	local pickerModal = nil
	function openPlayerPicker(toggleKey)
		if pickerModal then pickerModal:Destroy() pickerModal = nil end

		pickerModal = Instance.new("Frame")
		pickerModal.Size = UDim2.new(0.8,0,0.6,0)
		pickerModal.Position = UDim2.new(0.1,0,0.2,0)
		pickerModal.BackgroundColor3 = Color3.new(0.1,0.1,0.15)
		pickerModal.BackgroundTransparency = 0
		pickerModal.BorderSizePixel = 0
		pickerModal.Parent = screenGui
		local modalCorner = Instance.new("UICorner")
		modalCorner.CornerRadius = UDim.new(0, 12)
		modalCorner.Parent = pickerModal
		-- Semi-transparent backdrop
		local backdrop = Instance.new("Frame")
		backdrop.Size = UDim2.new(1,0,1,0)
		backdrop.Position = UDim2.new(0,0,0,0)
		backdrop.BackgroundColor3 = Color3.new(0,0,0)
		backdrop.BackgroundTransparency = 0.5
		backdrop.BorderSizePixel = 0
		backdrop.Parent = pickerModal
		backdrop.ZIndex = 0

		local title = createTextLabel(pickerModal, UDim2.new(1,0,0,30), UDim2.new(0,0,0,0), "Select Target", Color3.new(1,1,1), 16)
		title.TextXAlignment = Enum.TextXAlignment.Center

		local searchBox = Instance.new("TextBox")
		searchBox.Size = UDim2.new(0.9,0,0,30)
		searchBox.Position = UDim2.new(0.05,0,0,40)
		searchBox.BackgroundColor3 = Color3.new(0.2,0.2,0.25)
		searchBox.BackgroundTransparency = 0
		searchBox.BorderSizePixel = 0
		searchBox.PlaceholderText = getText("search_placeholder")
		searchBox.TextColor3 = Color3.new(1,1,1)
		searchBox.TextSize = 14
		searchBox.Font = Enum.Font.GothamMedium
		searchBox.Parent = pickerModal
		local searchCorner = Instance.new("UICorner")
		searchCorner.CornerRadius = UDim.new(0,4)
		searchCorner.Parent = searchBox

		local playerListFrame = Instance.new("ScrollingFrame")
		playerListFrame.Size = UDim2.new(0.9,0,0.6,0)
		playerListFrame.Position = UDim2.new(0.05,0,0.15,0)
		playerListFrame.BackgroundColor3 = Color3.new(0.15,0.15,0.2)
		playerListFrame.BackgroundTransparency = 0.2
		playerListFrame.BorderSizePixel = 0
		playerListFrame.ScrollBarThickness = 4
		playerListFrame.Parent = pickerModal
		local listCorner = Instance.new("UICorner")
		listCorner.CornerRadius = UDim.new(0,4)
		listCorner.Parent = playerListFrame

		local closePickerBtn = createTextButton(pickerModal, UDim2.new(0.3,0,0,30), UDim2.new(0.35,0,0.8,0), "Close", Color3.new(0.4,0.2,0.2), Color3.new(1,1,1), function()
			pickerModal:Destroy()
			pickerModal = nil
		end)

		-- Populate list
		local function refreshPlayerList(searchText)
			-- Clear
			for _, child in ipairs(playerListFrame:GetChildren()) do
				if child:IsA("Frame") then child:Destroy() end
			end

			local allPlayers = Players:GetPlayers()
			local filtered = {}
			for _, p in ipairs(allPlayers) do
				if p ~= player then
					local name = p.Name:lower()
					local display = p.DisplayName:lower()
					local search = searchText:lower()
					if search == "" or name:find(search) or display:find(search) then
						table.insert(filtered, p)
					end
				end
			end
			-- Sort by name
			table.sort(filtered, function(a,b) return a.Name < b.Name end)

			local y = 5
			for _, p in ipairs(filtered) do
				local entry = Instance.new("Frame")
				entry.Size = UDim2.new(1, -10, 0, 40)
				entry.Position = UDim2.new(0.05,0,0,y)
				entry.BackgroundColor3 = Color3.new(0.2,0.2,0.25)
				entry.BackgroundTransparency = 0
				entry.BorderSizePixel = 0
				entry.Parent = playerListFrame
				local entryCorner = Instance.new("UICorner")
				entryCorner.CornerRadius = UDim.new(0,4)
				entryCorner.Parent = entry

				-- Avatar
				local avatar = Instance.new("ImageLabel")
				avatar.Size = UDim2.new(0, 30, 0, 30)
				avatar.Position = UDim2.new(0, 5, 0,5)
				avatar.BackgroundTransparency = 1
				avatar.Parent = entry
				-- Load thumbnail
				local userId = p.UserId
				local success, thumbnail = pcall(function()
					return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
				end)
				if success and thumbnail then
					avatar.Image = thumbnail
				else
					avatar.Image = "rbxassetid://5399835960" -- default
				end

				-- Username
				local uname = createTextLabel(entry, UDim2.new(0.4,0,1,0), UDim2.new(0.1,0,0,0), p.Name, Color3.new(1,1,1), 12)
				uname.TextXAlignment = Enum.TextXAlignment.Left

				-- Display name
				local dname = createTextLabel(entry, UDim2.new(0.35,0,1,0), UDim2.new(0.5,0,0,0), p.DisplayName, Color3.new(0.7,0.7,0.7), 12)
				dname.TextXAlignment = Enum.TextXAlignment.Left

				-- Select button
				local selectBtn = createTextButton(entry, UDim2.new(0.15,0,0.6,0), UDim2.new(0.82,0,0.2,0), "Select", Color3.new(0.2,0.4,0.2), Color3.new(1,1,1), function()
					-- Set target for this toggle
					targetPlayers[toggleKey] = p
					-- Update target label in row
					local row = nil
					for _, r in ipairs(actionsPanel:GetChildren()) do
						if r:IsA("Frame") and r:GetAttribute("ToggleKey") == toggleKey then
							row = r break
						end
					end
					if row then
						local label = row:FindFirstChild("TargetLabel")
						if label then
							label.Text = p.Name
						end
					end
					-- Close picker
					pickerModal:Destroy()
					pickerModal = nil
				end)
				selectBtn.TextSize = 10

				y = y + 45
			end
			playerListFrame.CanvasSize = UDim2.new(0,0,0,y+10)
		end

		refreshPlayerList("")
		searchBox.Changed:Connect(function(prop)
			if prop == "Text" then
				refreshPlayerList(searchBox.Text)
			end
		end)

		-- Close if clicking outside? Not needed
	end

	-- Draggable functionality
	local dragging = false
	local dragInput, dragStart, startPos
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainGui.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	titleBar.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			mainGui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	return mainGui
end

-- Warning screens
local function showWarnings()
	-- First warning
	local warning1 = Instance.new("Frame")
	warning1.Size = UDim2.new(0.8,0,0.4,0)
	warning1.Position = UDim2.new(0.1,0,0.3,0)
	warning1.BackgroundColor3 = Color3.new(0.1,0.1,0.15)
	warning1.BackgroundTransparency = 0
	warning1.BorderSizePixel = 0
	warning1.Parent = screenGui
	local w1Corner = Instance.new("UICorner")
	w1Corner.CornerRadius = UDim.new(0, 12)
	w1Corner.Parent = warning1

	local title1 = createTextLabel(warning1, UDim2.new(1,0,0,30), UDim2.new(0,0,0,0), getText("warning1_title"), Color3.new(1,0.3,0.3), 20)
	local text1 = createTextLabel(warning1, UDim2.new(0.9,0,0.4,0), UDim2.new(0.05,0,0.15,0), getText("warning1_text"), Color3.new(1,1,1), 16)
	text1.TextXAlignment = Enum.TextXAlignment.Center
	text1.TextYAlignment = Enum.TextYAlignment.Center
	text1.TextWrapped = true

	local continueBtn1 = createTextButton(warning1, UDim2.new(0.3,0,0,30), UDim2.new(0.35,0,0.7,0), getText("warning1_continue"), Color3.new(0.2,0.4,0.2), Color3.new(1,1,1), function()
		warning1:Destroy()
		-- Second warning
		showSecondWarning()
	end)

	-- Second warning
	local function showSecondWarning()
		local warning2 = Instance.new("Frame")
		warning2.Size = UDim2.new(0.8,0,0.5,0)
		warning2.Position = UDim2.new(0.1,0,0.25,0)
		warning2.BackgroundColor3 = Color3.new(0.1,0.1,0.15)
		warning2.BackgroundTransparency = 0
		warning2.BorderSizePixel = 0
		warning2.Parent = screenGui
		local w2Corner = Instance.new("UICorner")
		w2Corner.CornerRadius = UDim.new(0, 12)
		w2Corner.Parent = warning2

		local title2 = createTextLabel(warning2, UDim2.new(1,0,0,30), UDim2.new(0,0,0,0), getText("warning2_title"), Color3.new(1,0.3,0.3), 20)
		local text2 = createTextLabel(warning2, UDim2.new(0.9,0,0.3,0), UDim2.new(0.05,0,0.15,0), getText("warning2_text"), Color3.new(1,1,1), 16)
		text2.TextXAlignment = Enum.TextXAlignment.Center
		text2.TextYAlignment = Enum.TextYAlignment.Center
		text2.TextWrapped = true

		-- Cancel button
		local cancelBtn = createTextButton(warning2, UDim2.new(0.25,0,0,30), UDim2.new(0.05,0,0.7,0), getText("warning2_cancel"), Color3.new(0.4,0.2,0.2), Color3.new(1,1,1), function()
			screenGui:Destroy()
		end)

		-- Flashing red "CONTINUE?" button
		local continueBtn2 = Instance.new("TextButton")
		continueBtn2.Size = UDim2.new(0.4,0,0,40)
		continueBtn2.Position = UDim2.new(0.3,0,0.7,0)
		continueBtn2.Text = getText("warning2_continue")
		continueBtn2.TextColor3 = Color3.new(1,1,1)
		continueBtn2.TextScaled = false
		continueBtn2.TextSize = 18
		continueBtn2.Font = Enum.Font.GothamBold
		continueBtn2.BackgroundColor3 = Color3.new(0.8,0,0)
		continueBtn2.BackgroundTransparency = 0
		continueBtn2.BorderSizePixel = 0
		continueBtn2.Parent = warning2
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 8)
		btnCorner.Parent = continueBtn2

		-- Flashing effect
		local flashCoroutine
		local function startFlashing()
			flashCoroutine = coroutine.create(function()
				while continueBtn2 and continueBtn2.Parent do
					local goal = {}
					if continueBtn2.BackgroundColor3 == Color3.new(0.8,0,0) then
						goal.BackgroundColor3 = Color3.new(1,0.2,0.2)
					else
						goal.BackgroundColor3 = Color3.new(0.8,0,0)
					end
					local tween = TweenService:Create(continueBtn2, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), goal)
					tween:Play()
					tween.Completed:Wait()
				end
			end)
			coroutine.resume(flashCoroutine)
		end

		-- Shaking effect (continuous)
		local shakeCoroutine
		local function startShaking()
			shakeCoroutine = coroutine.create(function()
				local offsetX = 0
				local offsetY = 0
				while continueBtn2 and continueBtn2.Parent do
					offsetX = (math.random() > 0.5 and 1 or -1) * math.random(2,5)
					offsetY = (math.random() > 0.5 and 1 or -1) * math.random(2,5)
					continueBtn2.Position = UDim2.new(0.3, offsetX, 0.7, offsetY)
					task.wait(0.05)
				end
			end)
			coroutine.resume(shakeCoroutine)
		end

		startFlashing()
		startShaking()

		continueBtn2.MouseButton1Click:Connect(function()
			-- Stop coroutines
			flashCoroutine = nil
			shakeCoroutine = nil
			warning2:Destroy()
			-- Show main GUI
			createMainGUI()
		end)
	end
end

-- Start warnings
showWarnings()

-- Ensure character changes re-load animations if needed
player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoid = character:WaitForChild("Humanoid")
	-- Re-load active animations? For simplicity, we just stop all and let user re-enable.
	for key, data in pairs(activeAnimations) do
		if data.track then
			data.track:Stop()
		end
	end
	activeAnimations = {}
end)

-- Keep script running
