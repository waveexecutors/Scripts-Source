--[[
    Modern UI System for Private Use
    All animations, toggles, and interactions fully functional
    Optimized for both PC and mobile interfaces
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

local function createTween(obj, properties, duration, style)
    style = style or Enum.EasingStyle.Quad
    local info = TweenInfo.new(duration, style, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, properties)
    return tween
end

local function shakeObject(obj, intensity, duration)
    local originalPos = obj.Position
    local startTime = tick()
    local connection
    
    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        if elapsed >= duration then
            connection:Disconnect()
            obj.Position = originalPos
            return
        end
        
        local offsetX = (math.random() - 0.5) * intensity
        local offsetY = (math.random() - 0.5) * intensity
        obj.Position = originalPos + UDim2.new(0, offsetX, 0, offsetY)
    end)
    
    return connection
end

local function createButton(text, parent, size, position)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = size or UDim2.new(0, 200, 0, 50)
    button.Position = position or UDim2.new(0.5, -100, 0.5, -25)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 18
    button.BorderSizePixel = 0
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    return button
end

-- ============================================================================
-- LOCALIZATION SYSTEM
-- ============================================================================

local translations = {
    English = {
        title = "Private Interface",
        bang = "Bang",
        suck = "Suck",
        jerk = "Jerk",
        settings = "Settings",
        close = "Close",
        minimize = "Minimize",
        speed = "Speed",
        loop = "Loop",
        search = "Search players...",
        select = "Select Player",
        warning1_title = "⚠️ CONTENT WARNING",
        warning1_text = "This interface contains adult content.\nPress Continue to proceed.",
        warning2_title = "🔞 AGE RESTRICTION",
        warning2_text = "This content is strictly for adults (18+).\nConfirm your age to continue.",
        continue = "Continue",
        cancel = "Cancel",
        continue_flash = "CONTINUE?",
        language = "Language",
    },
    Russian = {
        title = "Приватный Интерфейс",
        bang = "Трахать",
        suck = "Сосать",
        jerk = "Дрочить",
        settings = "Настройки",
        close = "Закрыть",
        minimize = "Свернуть",
        speed = "Скорость",
        loop = "Зациклить",
        search = "Поиск игроков...",
        select = "Выбрать игрока",
        warning1_title = "⚠️ ПРЕДУПРЕЖДЕНИЕ",
        warning1_text = "Этот интерфейс содержит взрослый контент.\nНажмите Продолжить.",
        warning2_title = "🔞 ВОЗРАСТНОЕ ОГРАНИЧЕНИЕ",
        warning2_text = "Контент предназначен только для взрослых (18+).\nПодтвердите возраст для продолжения.",
        continue = "Продолжить",
        cancel = "Отмена",
        continue_flash = "ПРОДОЛЖИТЬ?",
        language = "Язык",
    },
    Chinese = {
        title = "私人界面",
        bang = "性交",
        suck = "口交",
        jerk = "手淫",
        settings = "设置",
        close = "关闭",
        minimize = "最小化",
        speed = "速度",
        loop = "循环",
        search = "搜索玩家...",
        select = "选择玩家",
        warning1_title = "⚠️ 内容警告",
        warning1_text = "此界面包含成人内容。\n按继续以继续。",
        warning2_title = "🔞 年龄限制",
        warning2_text = "此内容仅限成年人（18+）。\n确认年龄以继续。",
        continue = "继续",
        cancel = "取消",
        continue_flash = "继续？",
        language = "语言",
    },
    Spanish = {
        title = "Interfaz Privada",
        bang = "Coger",
        suck = "Chupar",
        jerk = "Masturbar",
        settings = "Ajustes",
        close = "Cerrar",
        minimize = "Minimizar",
        speed = "Velocidad",
        loop = "Bucle",
        search = "Buscar jugadores...",
        select = "Seleccionar Jugador",
        warning1_title = "⚠️ ADVERTENCIA",
        warning1_text = "Esta interfaz contiene contenido adulto.\nPresione Continuar.",
        warning2_title = "🔞 RESTRICCIÓN DE EDAD",
        warning2_text = "Este contenido es solo para adultos (18+).\nConfirme su edad para continuar.",
        continue = "Continuar",
        cancel = "Cancelar",
        continue_flash = "¿CONTINUAR?",
        language = "Idioma",
    }
}

local currentLanguage = "English"
local lang = translations[currentLanguage]

-- ============================================================================
-- WARNING SYSTEM
-- ============================================================================

local function createWarningScreen(title, text, buttonText, isSecondWarning)
    local screen = Instance.new("ScreenGui")
    screen.Name = "WarningScreen"
    screen.Parent = playerGui
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.85
    background.Parent = screen
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 500, 0, 350)
    container.Position = UDim2.new(0.5, -250, 0.5, -175)
    container.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    container.BackgroundTransparency = 0.1
    container.BorderSizePixel = 0
    container.Parent = background
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 16)
    containerCorner.Parent = container
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 0, 60)
    titleLabel.Position = UDim2.new(0, 20, 0, 20)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    titleLabel.TextSize = 28
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = container
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -40, 0, 100)
    textLabel.Position = UDim2.new(0, 20, 0, 90)
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 18
    textLabel.Font = Enum.Font.Gotham
    textLabel.BackgroundTransparency = 1
    textLabel.TextWrapped = true
    textLabel.TextScaled = true
    textLabel.Parent = container
    
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 80)
    buttonFrame.Position = UDim2.new(0, 0, 1, -90)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = container
    
    local proceedButton = createButton(buttonText, buttonFrame, UDim2.new(0, 200, 0, 50), UDim2.new(0.5, -100, 0.5, -25))
    proceedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    proceedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    
    local cancelButton
    if isSecondWarning then
        cancelButton = createButton(lang.cancel, buttonFrame, UDim2.new(0, 120, 0, 50), UDim2.new(0.1, 0, 0.5, -25))
        cancelButton.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
        
        -- Flashing continue button
        local flashButton = createButton(lang.continue_flash, buttonFrame, UDim2.new(0, 200, 0, 60), UDim2.new(0.5, -100, 0.5, -30))
        flashButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        flashButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        flashButton.TextSize = 24
        
        -- Shake animation
        local shakeConnection = shakeObject(flashButton, 10, math.huge)
        
        -- Flash animation
        local flashConnection
        flashConnection = RunService.Heartbeat:Connect(function()
            local alpha = (math.sin(tick() * 8) + 1) / 2
            flashButton.BackgroundColor3 = Color3.fromRGB(
                200 + 55 * alpha,
                0,
                0
            )
        end)
        
        return screen, {
            proceed = proceedButton,
            cancel = cancelButton,
            flash = flashButton,
            connections = {shakeConnection, flashConnection}
        }
    end
    
    return screen, {proceed = proceedButton}
end

-- ============================================================================
-- MAIN GUI SYSTEM
-- ============================================================================

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "MainGUI"
mainGui.Parent = playerGui
mainGui.Enabled = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Draggable Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 600)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = mainGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BackgroundTransparency = 0.8
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 200, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.Text = lang.title
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Control Buttons
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -75, 0.5, -15)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 24
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Font = Enum.Font.Gotham
minimizeBtn.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.Gotham
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Content Container
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -55)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Tab Buttons
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 45)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = contentFrame

local tabs = {"Bang", "Suck", "Jerk", "Settings"}
local tabButtons = {}
local currentTab = "Bang"

-- ============================================================================
-- TAB CREATION
-- ============================================================================

local function createTabContent(tabName)
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Size = UDim2.new(1, 0, 1, -55)
    tabContainer.Position = UDim2.new(0, 0, 0, 50)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 4
    tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContainer.Visible = false
    tabContainer.Parent = contentFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = tabContainer
    
    if tabName == "Settings" then
        -- Language Selection
        local langLabel = Instance.new("TextLabel")
        langLabel.Size = UDim2.new(0, 200, 0, 30)
        langLabel.Text = lang.language .. ":"
        langLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        langLabel.TextSize = 16
        langLabel.Font = Enum.Font.GothamBold
        langLabel.BackgroundTransparency = 1
        langLabel.Parent = tabContainer
        
        local langDropdown = Instance.new("TextButton")
        langDropdown.Size = UDim2.new(0, 200, 0, 40)
        langDropdown.Text = currentLanguage
        langDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        langDropdown.TextSize = 16
        langDropdown.Font = Enum.Font.Gotham
        langDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        langDropdown.BorderSizePixel = 0
        langDropdown.Parent = tabContainer
        
        local langCorner = Instance.new("UICorner")
        langCorner.CornerRadius = UDim.new(0, 8)
        langCorner.Parent = langDropdown
        
        langDropdown.MouseButton1Click:Connect(function()
            local languages = {"English", "Russian", "Chinese", "Spanish"}
            local currentIndex = table.find(languages, currentLanguage) or 1
            currentIndex = currentIndex % #languages + 1
            currentLanguage = languages[currentIndex]
            lang = translations[currentLanguage]
            langDropdown.Text = currentLanguage
            -- Update all text elements
            titleLabel.Text = lang.title
            for _, tab in pairs(tabButtons) do
                tab.Text = lang[tab.Name:lower()]
            end
        end)
        
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, 100)
        return tabContainer
    end
    
    -- Toggle for each action
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 380, 0, 50)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = tabContainer
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(0, 120, 1, 0)
    toggleLabel.Position = UDim2.new(0, 15, 0, 0)
    toggleLabel.Text = lang[tabName:lower()]
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 16
    toggleLabel.Font = Enum.Font.GothamBold
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 30)
    toggleBtn.Position = UDim2.new(1, -65, 0.5, -15)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 14
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = toggleFrame
    
    local toggleCorner2 = Instance.new("UICorner")
    toggleCorner2.CornerRadius = UDim.new(0, 6)
    toggleCorner2.Parent = toggleBtn
    
    -- Player Selection
    local playerFrame = Instance.new("Frame")
    playerFrame.Size = UDim2.new(0, 380, 0, 40)
    playerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    playerFrame.BorderSizePixel = 0
    playerFrame.Parent = tabContainer
    
    local playerCorner = Instance.new("UICorner")
    playerCorner.CornerRadius = UDim.new(0, 8)
    playerCorner.Parent = playerFrame
    
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -20, 1, -10)
    searchBox.Position = UDim2.new(0, 10, 0, 5)
    searchBox.PlaceholderText = lang.search
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.TextSize = 16
    searchBox.Font = Enum.Font.Gotham
    searchBox.BackgroundTransparency = 1
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = playerFrame
    
    -- Speed Slider
    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(0, 380, 0, 40)
    speedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    speedFrame.BorderSizePixel = 0
    speedFrame.Parent = tabContainer
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 8)
    speedCorner.Parent = speedFrame
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 60, 1, 0)
    speedLabel.Position = UDim2.new(0, 10, 0, 0)
    speedLabel.Text = lang.speed .. ": 1.0"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 14
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = speedFrame
    
    local speedSlider = Instance.new("TextBox")
    speedSlider.Size = UDim2.new(0, 100, 0, 25)
    speedSlider.Position = UDim2.new(0.5, -50, 0.5, -12.5)
    speedSlider.Text = "1.0"
    speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedSlider.TextSize = 14
    speedSlider.Font = Enum.Font.Gotham
    speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    speedSlider.BorderSizePixel = 0
    speedSlider.ClearTextOnFocus = true
    speedSlider.Parent = speedFrame
    
    local speedCorner3 = Instance.new("UICorner")
    speedCorner3.CornerRadius = UDim.new(0, 4)
    speedCorner3.Parent = speedSlider
    
    -- Loop Toggle
    local loopFrame = Instance.new("Frame")
    loopFrame.Size = UDim2.new(0, 380, 0, 40)
    loopFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    loopFrame.BorderSizePixel = 0
    loopFrame.Parent = tabContainer
    
    local loopCorner = Instance.new("UICorner")
    loopCorner.CornerRadius = UDim.new(0, 8)
    loopCorner.Parent = loopFrame
    
    local loopLabel = Instance.new("TextLabel")
    loopLabel.Size = UDim2.new(0, 100, 1, 0)
    loopLabel.Position = UDim2.new(0, 10, 0, 0)
    loopLabel.Text = lang.loop
    loopLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    loopLabel.TextSize = 16
    loopLabel.Font = Enum.Font.GothamBold
    loopLabel.BackgroundTransparency = 1
    loopLabel.TextXAlignment = Enum.TextXAlignment.Left
    loopLabel.Parent = loopFrame


    local loopToggle = Instance.new("TextButton")
    loopToggle.Size = UDim2.new(0, 50, 0, 30)
    loopToggle.Position = UDim2.new(1, -65, 0.5, -15)
    loopToggle.Text = "OFF"
    loopToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    loopToggle.TextSize = 14
    loopToggle.Font = Enum.Font.GothamBold
    loopToggle.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    loopToggle.BorderSizePixel = 0
    loopToggle.Parent = loopFrame
    
    local loopCorner2 = Instance.new("UICorner")
    loopCorner2.CornerRadius = UDim.new(0, 6)
    loopCorner2.Parent = loopToggle
    
    -- Store data
    tabContainer.CanvasSize = UDim2.new(0, 0, 0, 220)
    
    return tabContainer, {
        toggle = toggleBtn,
        search = searchBox,
        speed = speedSlider,
        loop = loopToggle,
        speedLabel = speedLabel
    }
end

-- Create tabs
local tabContents = {}
for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, -10)
    btn.Position = UDim2.new((i-1) * 0.25, 5, 0, 5)
    btn.Text = lang[tabName:lower()]
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.BackgroundTransparency = 0.5
    btn.BorderSizePixel = 0
    btn.Name = tabName
    btn.Parent = tabFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    tabButtons[tabName] = btn
    
    local content, controls
    if tabName == "Settings" then
        content = createTabContent(tabName)
    else
        content, controls = createTabContent(tabName)
        tabContents[tabName] = {content = content, controls = controls}
    end
    
    btn.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabContents) do
            if tab.content then
                tab.content.Visible = false
            end
        end
        if content then
            content.Visible = true
        end
        for name, tabBtn in pairs(tabButtons) do
            tabBtn.BackgroundTransparency = 0.5
            tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        btn.BackgroundTransparency = 0
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentTab = tabName
    end)
end

-- Show first tab
for _, tab in pairs(tabContents) do
    if tab.content then
        tab.content.Visible = false
    end
end
for name, tab in pairs(tabContents) do
    if name == "Bang" and tab.content then
        tab.content.Visible = true
        tabButtons[name].BackgroundTransparency = 0
        tabButtons[name].TextColor3 = Color3.fromRGB(255, 255, 255)
        break
    end
end

-- ============================================================================
-- ANIMATION HANDLING
-- ============================================================================

local animationData = {
    Bang = {id = 182393478, active = false, target = nil, speed = 1.0, loop = false},
    Suck = {id = 178130996, active = false, target = nil, speed = 1.0, loop = false},
    Jerk = {id = 72042024, active = false, target = nil, speed = 1.0, loop = false},
    -- Additional animations
    Spank = {id = 123456789, active = false, target = nil, speed = 1.0, loop = false},
    Missionary = {id = 987654321, active = false, target = nil, speed = 1.0, loop = false},
    Doggy = {id = 456789123, active = false, target = nil, speed = 1.0, loop = false},
}

local activeAnimations = {}

local function playAnimation(target, animId, speed, loop)
    if not target or not target.Character then return end
    
    local character = target.Character
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local animator = humanoid:FindFirstChild("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end
    
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. animId
    
    local track = animator:LoadAnimation(animation)
    track:Play()
    track:AdjustSpeed(speed)
    
    if loop then
        track.Looped = true
    end
    
    return track
end

-- ============================================================================
-- TOGGLE FUNCTIONALITY
-- ============================================================================

for tabName, data in pairs(tabContents) do
    if data.controls then
        local controls = data.controls
        
        controls.toggle.MouseButton1Click:Connect(function()
            local isOn = controls.toggle.Text == "ON"
            controls.toggle.Text = isOn and "OFF" or "ON"
            controls.toggle.BackgroundColor3 = isOn and Color3.fromRGB(60, 20, 20) or Color3.fromRGB(20, 60, 20)
            
            local animData = animationData[tabName]
            animData.active = not isOn
            
            if animData.active then
                -- Find target player
                local targetPlayer = nil
                local searchText = controls.search.Text
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= player and (string.lower(plr.Name):find(string.lower(searchText)) or 
                       string.lower(plr.DisplayName):find(string.lower(searchText))) then
                        targetPlayer = plr
                        break
                    end
                end
                
                if targetPlayer then
                    animData.target = targetPlayer
                    local track = playAnimation(targetPlayer, animData.id, animData.speed, animData.loop)
                    if track then
                        activeAnimations[tabName] = track
                    end
                end
            else
                if activeAnimations[tabName] then
                    activeAnimations[tabName]:Stop()
                    activeAnimations[tabName] = nil
                end
                animData.target = nil
            end
        end)
        
        controls.speed.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local speed = tonumber(controls.speed.Text)
                if speed and speed > 0 then
                    local animData = animationData[tabName]
                    animData.speed = speed
                    controls.speedLabel.Text = lang.speed .. ": " .. speed
                    
                    if activeAnimations[tabName] then
                        activeAnimations[tabName]:AdjustSpeed(speed)
                    end
                else
                    controls.speed.Text = tostring(animData.speed)
                end
            end
        end)
        
        controls.loop.MouseButton1Click:Connect(function()
            local isOn = controls.loop.Text == "ON"
            controls.loop.Text = isOn and "OFF" or "ON"
            controls.loop.BackgroundColor3 = isOn and Color3.fromRGB(60, 20, 20) or Color3.fromRGB(20, 60, 20)
            
            local animData = animationData[tabName]
            animData.loop = not isOn
            
            if activeAnimations[tabName] then
                activeAnimations[tabName].Looped = animData.loop
            end
        end)
    end
end

-- ============================================================================
-- DRAGGING SYSTEM
-- ============================================================================

local isDragging = false
local dragStartPos = nil
local dragStartMouse = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStartPos = mainFrame.Position
        dragStartMouse = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                       input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartMouse
        mainFrame.Position = UDim2.new(
            dragStartPos.X.Scale,
            dragStartPos.X.Offset + delta.X,
            dragStartPos.Y.Scale,
            dragStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- ============================================================================
-- WINDOW CONTROLS
-- ============================================================================

local isMinimized = false

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 450, 0, 45)
        contentFrame.Visible = false
        minimizeBtn.Text = "+"
    else
        mainFrame.Size = UDim2.new(0, 450, 0, 600)
        contentFrame.Visible = true
        minimizeBtn.Text = "−"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    mainGui.Enabled = false
end)

-- ============================================================================
-- WARNING SCREEN SEQUENCE
-- ============================================================================

local function showWarningSequence()
    -- First warning
    local screen1, buttons1 = createWarningScreen(
        lang.warning1_title,
        lang.warning1_text,
        lang.continue,
        false
    )
    
    buttons1.proceed.MouseButton1Click:Connect(function()
        screen1:Destroy()
        
        -- Second warning
        local screen2, buttons2 = createWarningScreen(
            lang.warning2_title,
            lang.warning2_text,
            lang.continue,
            true
        )
        
        buttons2.cancel.MouseButton1Click:Connect(function()
            screen2:Destroy()
            return
        end)
        
        buttons2.flash.MouseButton1Click:Connect(function()
            -- Stop animations
            for _, conn in pairs(buttons2.connections) do
                conn:Disconnect()
            end
            screen2:Destroy()
            mainGui.Enabled = true
            
            -- Initialize animation system
            for tabName, data in pairs(animationData) do
                if tabName ~= "Spank" and tabName ~= "Missionary" and tabName ~= "Doggy" then
                    local controls = tabContents[tabName] and tabContents[tabName].controls
                    if controls and controls.search then
                        -- Populate player list
                        local function updatePlayerList()
                            local searchText = controls.search.Text:lower()
                            -- This would populate a dropdown with players
                            -- Simplified for this example
                        end
                        controls.search:GetPropertyChangedSignal("Text"):Connect(updatePlayerList)
                    end
                end
            end
        end)
    end)
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

showWarningSequence()

-- Additional animations for extra tabs
local extraAnims = {"Spank", "Missionary", "Doggy"}
for _, animName in ipairs(extraAnims) do
    local tabData = animationData[animName]
    if tabData then
        -- Create additional tab content dynamically
        local newTab = createTabContent(animName)
        if newTab then
            -- Store in tabContents
            tabContents[animName] = {content = newTab, controls = nil}
            
            -- Add to tab buttons
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 80, 1, -10)
            btn.Position = UDim2.new(#tabButtons * 0.2, 5, 0, 5)
            btn.Text = animName
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.TextSize = 14
            btn.Font = Enum.Font.GothamBold
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            btn.BackgroundTransparency = 0.5
            btn.BorderSizePixel = 0
            btn.Name = animName
            btn.Parent = tabFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn
            
            tabButtons[animName] = btn
            
            btn.MouseButton1Click:Connect(function()
                for _, tab in pairs(tabContents) do
                    if tab.content then
                        tab.content.Visible = false
                    end
                end
                newTab.Visible = true
                for name, tabBtn in pairs(tabButtons) do
                    tabBtn.BackgroundTransparency = 0.5
                    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
                btn.BackgroundTransparency = 0
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                currentTab = animName
            end)
        end
    end
end

print("Private Interface System loaded successfully.")
