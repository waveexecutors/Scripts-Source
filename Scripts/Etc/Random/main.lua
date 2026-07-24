--[[
    ╔════════════════════════════════════════════════════════════════════════════╗
    ║                    WARNING: ADULT CONTENT (18+)                          ║
    ║  This script contains mature themes and is for private use only.         ║
    ║  By proceeding, you confirm you are 18+ and accept all responsibility.   ║
    ╚════════════════════════════════════════════════════════════════════════════╝
--]]

-- ══════════════════════════════════════════════════════════════════════════════
-- WARNING SYSTEM (3-stage)
-- ══════════════════════════════════════════════════════════════════════════════

local warningStage = 0
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ModernGUI"
gui.Parent = player.PlayerGui
gui.Enabled = false

local function createWarning(step)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 500, 0, 300)
    frame.Position = UDim2.new(0.5, -250, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    frame.Active = true
    frame.Draggable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚠ WARNING ⚠"
    title.TextColor3 = Color3.fromRGB(255, 50, 50)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, -40, 0, 100)
    message.Position = UDim2.new(0, 20, 0, 50)
    message.BackgroundTransparency = 1
    message.TextColor3 = Color3.fromRGB(255, 255, 255)
    message.TextWrapped = true
    message.TextScaled = true
    message.Font = Enum.Font.GothamMedium
    message.Parent = frame
    
    if step == 1 then
        message.Text = "This script contains adult content (18+).\nProceed only if you are of legal age."
    elseif step == 2 then
        message.Text = "FINAL WARNING!\nThis script includes explicit adult animations.\nYou must be 18+ to continue."
    elseif step == 3 then
        message.Text = "LAST CHANCE!\nAre you absolutely sure you want to continue?\nThis content is not suitable for minors."
        message.TextColor3 = Color3.fromRGB(255, 200, 0)
    end
    
    local continueBtn = Instance.new("TextButton")
    continueBtn.Size = UDim2.new(0, 150, 0, 50)
    continueBtn.Position = UDim2.new(0.5, -170, 1, -70)
    continueBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    continueBtn.Text = "CONTINUE →"
    continueBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    continueBtn.TextScaled = true
    continueBtn.Font = Enum.Font.GothamBold
    continueBtn.Parent = frame
    
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 8)
    corner2.Parent = continueBtn
    
    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Size = UDim2.new(0, 150, 0, 50)
    cancelBtn.Position = UDim2.new(0.5, 20, 1, -70)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    cancelBtn.Text = "CANCEL"
    cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelBtn.TextScaled = true
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.Parent = frame
    cancelBtn.Visible = (step == 3)
    
    local corner3 = Instance.new("UICorner")
    corner3.CornerRadius = UDim.new(0, 8)
    corner3.Parent = cancelBtn
    
    if step == 3 then
        continueBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        continueBtn.Text = "CONTINUE?!"
        
        spawn(function()
            while frame.Parent do
                continueBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                wait(0.2)
                continueBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
                wait(0.2)
                continueBtn.Position = UDim2.new(0.5, -170 + math.random(-5, 5), 1, -70 + math.random(-5, 5))
                wait(0.05)
                continueBtn.Position = UDim2.new(0.5, -170, 1, -70)
            end
        end)
    end
    
    cancelBtn.MouseButton1Click:Connect(function()
        frame:Destroy()
        gui:Destroy()
    end)
    
    continueBtn.MouseButton1Click:Connect(function()
        frame:Destroy()
        if step == 1 then
            createWarning(2)
        elseif step == 2 then
            createWarning(3)
        elseif step == 3 then
            createMainGUI()
        end
    end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- MAIN GUI
-- ══════════════════════════════════════════════════════════════════════════════

local currentLanguage = "English"
local translations = {
    English = {
        title = "Adult Animations",
        bang = "Bang",
        suck = "Suck",
        jerk = "Jerk",
        loop = "Loop",
        speed = "Speed",
        settings = "⚙ Settings",
        close = "✕",
        minimize = "─",
        players = "Players",
        search = "Search player...",
        select = "Select Target",
        language = "Language",
        animation = "Animation Settings",
    },
    Russian = {
        title = "Взрослые анимации",
        bang = "Трах",
        suck = "Сос",
        jerk = "Дроч",
        loop = "Повтор",
        speed = "Скорость",
        settings = "⚙ Настройки",
        close = "✕",
        minimize = "─",
        players = "Игроки",
        search = "Поиск игрока...",
        select = "Выбрать цель",
        language = "Язык",
        animation = "Настройки анимации",
    },
    Chinese = {
        title = "成人动画",
        bang = "撞击",
        suck = "口交",
        jerk = "手淫",
        loop = "循环",
        speed = "速度",
        settings = "⚙ 设置",
        close = "✕",
        minimize = "─",
        players = "玩家",
        search = "搜索玩家...",
        select = "选择目标",
        language = "语言",
        animation = "动画设置",
    },
    Spanish = {
        title = "Animaciones Adultas",
        bang = "Golpe",
        suck = "Chupar",
        jerk = "Masturbar",
        loop = "Bucle",
        speed = "Velocidad",
        settings = "⚙ Ajustes",
        close = "✕",
        minimize = "─",
        players = "Jugadores",
        search = "Buscar jugador...",
        select = "Seleccionar objetivo",
        language = "Idioma",
        animation = "Ajustes de animación",
    }
}

local function getText(key)
    return translations[currentLanguage][key] or translations.English[key] or key
end

local activeAnimations = {}
local currentTarget = nil
local animSpeed = 1
local loopEnabled = true

local function createMainGUI()
    gui.Enabled = true
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = gui
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 16)
    titleCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = getText("title")
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextScaled = true
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Minimize Button
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 40, 1, 0)
    minBtn.Position = UDim2.new(1, -80, 0, 0)
    minBtn.BackgroundTransparency = 1
    minBtn.Text = getText("minimize")
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.TextScaled = true
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Parent = titleBar
    
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            mainFrame.Size = UDim2.new(0, 400, 0, 40)
            contentFrame.Visible = false
            minBtn.Text = "□"
        else
            mainFrame.Size = UDim2.new(0, 400, 0, 600)
            contentFrame.Visible = true
            minBtn.Text = getText("minimize")
        end
    end)
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 1, 0)
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = getText("close")
    closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -40)
    contentFrame.Position = UDim2.new(0, 0, 0, 40)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Scroll Frame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 120)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = contentFrame
    
    local scrollList = Instance.new("UIListLayout")
    scrollList.Padding = UDim.new(0, 10)
    scrollList.SortOrder = Enum.SortOrder.LayoutOrder
    scrollList.Parent = scrollFrame
    
    -- ══════════════════════════════════════════════════════════════════════════════
    -- FUNCTION TOGGLES
    -- ══════════════════════════════════════════════════════════════════════════════
    
    local function createToggle(name, animId, isSelf)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -20, 0, 80)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = scrollFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 10)
        toggleCorner.Parent = toggleFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 100, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = getText(name:lower())
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 80, 0, 40)
        toggleBtn.Position = UDim2.new(1, -90, 0.5, -20)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        toggleBtn.Text = "OFF"
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.TextScaled = true
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.Parent = toggleFrame
        
        local toggleCorner2 = Instance.new("UICorner")
        toggleCorner2.CornerRadius = UDim.new(0, 8)
        toggleCorner2.Parent = toggleBtn
        
        local active = false
        local animationTrack = nil
        local animator = nil
        
        toggleBtn.MouseButton1Click:Connect(function()
            active = not active
            toggleBtn.Text = active and "ON" or "OFF"
            toggleBtn.BackgroundColor3 = active and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 50, 70)
            
            if active then
                if not currentTarget then
                    -- Show player selection
                    showPlayerSelector(function(selected)
                        currentTarget = selected
                        startAnimation(name, animId, isSelf)
                    end)
                    active = false
                    toggleBtn.Text = "OFF"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                    return
                end
                startAnimation(name, animId, isSelf)
            else
                stopAnimation(name)
            end
        end)
        
        local function startAnimation(name, animId, isSelf)
            if activeAnimations[name] then
                activeAnimations[name]:Stop()
                activeAnimations[name] = nil
            end
            
            local targetChar = isSelf and player.Character or (currentTarget and currentTarget.Character)
            if not targetChar then return end
            
            local humanoid = targetChar:FindFirstChild("Humanoid")
            if not humanoid then return end
            
            animator = humanoid:FindFirstChild("Animator")
            if not animator then
                animator = Instance.new("Animator")
                animator.Parent = humanoid
            end
            
            local anim = Instance.new("Animation")
            if isSelf then
                anim.AnimationId = animId
            else
                anim.AnimationId = "rbxassetid://" .. tostring(animId)
            end
            
            animationTrack = animator:LoadAnimation(anim)
            animationTrack:Play()
            animationTrack:AdjustSpeed(animSpeed)
            
            if loopEnabled then
                animationTrack.Looped = true
            end
            
            activeAnimations[name] = animationTrack
        end
        
        local function stopAnimation(name)
            if activeAnimations[name] then
                activeAnimations[name]:Stop()
                activeAnimations[name] = nil
            end
        end
        
        return toggleFrame
    end
    
    -- ══════════════════════════════════════════════════════════════════════════════
    -- PLAYER SELECTOR
    -- ══════════════════════════════════════════════════════════════════════════════
    
    local function showPlayerSelector(callback)
        local selector = Instance.new("Frame")
        selector.Size = UDim2.new(0, 300, 0, 400)
        selector.Position = UDim2.new(0.5, -150, 0.5, -200)
        selector.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        selector.BorderSizePixel = 0
        selector.Parent = gui
        
        local selectorCorner = Instance.new("UICorner")
        selectorCorner.CornerRadius = UDim.new(0, 12)
        selectorCorner.Parent = selector
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.BackgroundTransparency = 1
        title.Text = getText("select")
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextScaled = true
        title.Font = Enum.Font.GothamBold
        title.Parent = selector
        
        local searchBox = Instance.new("TextBox")
        searchBox.Size = UDim2.new(1, -20, 0, 30)
        searchBox.Position = UDim2.new(0, 10, 0, 45)
        searchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        searchBox.PlaceholderText = getText("search")
        searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 180)
        searchBox.TextScaled = true
        searchBox.Font = Enum.Font.GothamMedium
        searchBox.Parent = selector
        
        local searchCorner = Instance.new("UICorner")
        searchCorner.CornerRadius = UDim.new(0, 8)
        searchCorner.Parent = searchBox
        
        local playerList = Instance.new("ScrollingFrame")
        playerList.Size = UDim2.new(1, -20, 0, 280)
        playerList.Position = UDim2.new(0, 10, 0, 85)
        playerList.BackgroundTransparency = 1
        playerList.ScrollBarThickness = 6
        playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
        playerList.Parent = selector
        
        local playerListLayout = Instance.new("UIListLayout")
        playerListLayout.Padding = UDim.new(0, 5)
        playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        playerListLayout.Parent = playerList
        
        local function updatePlayerList(filter)
            for _, child in pairs(playerList:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            local players = game.Players:GetPlayers()
            local ySize = 0
            
            for _, plr in pairs(players) do
                if plr ~= player then
                    local name = plr.Name:lower()
                    local displayName = plr.DisplayName:lower()
                    local filterLower = filter and filter:lower() or ""
                    
                    if filter == "" or name:find(filterLower) or displayName:find(filterLower) then
                        local btn = Instance.new("TextButton")
                        btn.Size = UDim2.new(1, 0, 0, 50)
                        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                        btn.Text = plr.DisplayName .. " (" .. plr.Name .. ")"
                        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        btn.TextScaled = true
                        btn.Font = Enum.Font.GothamMedium
                        btn.Parent = playerList
                        
                        local btnCorner = Instance.new("UICorner")
                        btnCorner.CornerRadius = UDim.new(0, 8)
                        btnCorner.Parent = btn
                        
                        -- Avatar thumbnail
                        local avatar = Instance.new("ImageLabel")
                        avatar.Size = UDim2.new(0, 40, 0, 40)
                        avatar.Position = UDim2.new(0, 5, 0.5, -20)
                        avatar.BackgroundTransparency = 1
                        avatar.Image = game.Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                        avatar.Parent = btn
                        
                        btn.MouseButton1Click:Connect(function()
                            callback(plr)
                            selector:Destroy()
                        end)
                        
                        ySize = ySize + 55
                    end
                end
            end
            
            playerList.CanvasSize = UDim2.new(0, 0, 0, ySize)
        end
        
        updatePlayerList("")
        
        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            updatePlayerList(searchBox.Text)
        end)
        
        local closeSelector = Instance.new("TextButton")
        closeSelector.Size = UDim2.new(0, 60, 0, 30)
        closeSelector.Position = UDim2.new(1, -70, 0, 5)
        closeSelector.BackgroundTransparency = 1
        closeSelector.Text = "✕"
        closeSelector.TextColor3 = Color3.fromRGB(255, 50, 50)
        closeSelector.TextScaled = true
        closeSelector.Font = Enum.Font.GothamBold
        closeSelector.Parent = selector
        
        closeSelector.MouseButton1Click:Connect(function()
            selector:Destroy()
        end)
    end
    
    -- ══════════════════════════════════════════════════════════════════════════════
    --
    local function createSettings()
        local settingsFrame = Instance.new("Frame")
        settingsFrame.Size = UDim2.new(0, 350, 0, 250)
        settingsFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
        settingsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        settingsFrame.BorderSizePixel = 0
        settingsFrame.Parent = gui
        
        local settingsCorner = Instance.new("UICorner")
        settingsCorner.CornerRadius = UDim.new(0, 12)
        settingsCorner.Parent = settingsFrame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.BackgroundTransparency = 1
        title.Text = getText("settings")
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextScaled = true
        title.Font = Enum.Font.GothamBold
        title.Parent = settingsFrame
        
        -- Language selector
        local langLabel = Instance.new("TextLabel")
        langLabel.Size = UDim2.new(0, 100, 0, 30)
        langLabel.Position = UDim2.new(0, 20, 0, 50)
        langLabel.BackgroundTransparency = 1
        langLabel.Text = getText("language") .. ":"
        langLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
        langLabel.TextScaled = true
        langLabel.Font = Enum.Font.GothamMedium
        langLabel.Parent = settingsFrame
        
        local langDropdown = Instance.new("TextButton")
        langDropdown.Size = UDim2.new(0, 150, 0, 30)
        langDropdown.Position = UDim2.new(0, 130, 0, 50)
        langDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        langDropdown.Text = currentLanguage
        langDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        langDropdown.TextScaled = true
        langDropdown.Font = Enum.Font.GothamMedium
        langDropdown.Parent = settingsFrame
        
        local langCorner = Instance.new("UICorner")
        langCorner.CornerRadius = UDim.new(0, 8)
        langCorner.Parent = langDropdown
        
        local langOptions = {"English", "Russian", "Chinese", "Spanish"}
        local langIndex = 1
        
        langDropdown.MouseButton1Click:Connect(function()
            langIndex = langIndex % #langOptions + 1
            currentLanguage = langOptions[langIndex]
            langDropdown.Text = currentLanguage
            -- Update all text
            titleText.Text = getText("title")
            minBtn.Text = getText("minimize")
            closeBtn.Text = getText("close")
            -- Update toggle labels
            for _, child in pairs(scrollFrame:GetChildren()) do
                if child:IsA("Frame") then
                    local label = child:FindFirstChild("TextLabel")
                    if label then
                        local name = label.Text:gsub("^%u", string.lower)
                        if name == "bang" or name == "suck" or name == "jerk" then
                            label.Text = getText(name)
                        end
                    end
                end
            end
        end)
        
        -- Speed slider
        local speedLabel = Instance.new("TextLabel")
        speedLabel.Size = UDim2.new(0, 100, 0, 30)
        speedLabel.Position = UDim2.new(0, 20, 0, 95)
        speedLabel.BackgroundTransparency = 1
        speedLabel.Text = getText("speed") .. ":"
        speedLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
        speedLabel.TextScaled = true
        speedLabel.Font = Enum.Font.GothamMedium
        speedLabel.Parent = settingsFrame
        
        local speedSlider = Instance.new("TextBox")
        speedSlider.Size = UDim2.new(0, 150, 0, 30)
        speedSlider.Position = UDim2.new(0, 130, 0, 95)
        speedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        speedSlider.Text = tostring(animSpeed)
        speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedSlider.TextScaled = true
        speedSlider.Font = Enum.Font.GothamMedium
        speedSlider.Parent = settingsFrame
        
        local speedCorner = Instance.new("UICorner")
        speedCorner.CornerRadius = UDim.new(0, 8)
        speedCorner.Parent = speedSlider
        
        speedSlider.FocusLost:Connect(function()
            local num = tonumber(speedSlider.Text)
            if num and num > 0 and num <= 10 then
                animSpeed = num
                -- Update all active animations
                for name, track in pairs(activeAnimations) do
                    track:AdjustSpeed(animSpeed)
                end
            else
                speedSlider.Text = tostring(animSpeed)
            end
        end)
        
        -- Loop toggle
        local loopLabel = Instance.new("TextLabel")
        loopLabel.Size = UDim2.new(0, 100, 0, 30)
        loopLabel.Position = UDim2.new(0, 20, 0, 140)
        loopLabel.BackgroundTransparency = 1
        loopLabel.Text = getText("loop") .. ":"
        loopLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
        loopLabel.TextScaled = true
        loopLabel.Font = Enum.Font.GothamMedium
        loopLabel.Parent = settingsFrame
        
        local loopBtn = Instance.new("TextButton")
        loopBtn.Size = UDim2.new(0, 80, 0, 30)
        loopBtn.Position = UDim2.new(0, 130, 0, 140)
        loopBtn.BackgroundColor3 = loopEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 50, 70)
        loopBtn.Text = loopEnabled and "ON" or "OFF"
        loopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        loopBtn.TextScaled = true
        loopBtn.Font = Enum.Font.GothamBold
        loopBtn.Parent = settingsFrame
        
        local loopCorner = Instance.new("UICorner")
        loopCorner.CornerRadius = UDim.new(0, 8)
        loopCorner.Parent = loopBtn
        
        loopBtn.MouseButton1Click:Connect(function()
            loopEnabled = not loopEnabled
            loopBtn.Text = loopEnabled and "ON" or "OFF"
            loopBtn.BackgroundColor3 = loopEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 50, 70)
            -- Update all active animations
            for name, track in pairs(activeAnimations) do
                track.Looped = loopEnabled
                if not loopEnabled then
                    track:Stop()
                    wait(0.1)
                    track:Play()
                end
            end
        end)
        
        local closeSettings = Instance.new("TextButton")
        closeSettings.Size = UDim2.new(0, 60, 0, 30)
        closeSettings.Position = UDim2.new(1, -70, 0, 5)
        closeSettings.BackgroundTransparency = 1
        closeSettings.Text = "✕"
        closeSettings.TextColor3 = Color3.fromRGB(255, 50, 50)
        closeSettings.TextScaled = true
        closeSettings.Font = Enum.Font.GothamBold
        closeSettings.Parent = settingsFrame
        
        closeSettings.MouseButton1Click:Connect(function()
            settingsFrame:Destroy()
        end)
    end
    
    -- ══════════════════════════════════════════════════════════════════════════════
    -- CREATE TOGGLES
    -- ══════════════════════════════════════════════════════════════════════════════
    
    createToggle("Bang", 182393478, false)
    createToggle("Suck", 178130996, false)
    createToggle("Jerk", "rbxassetid://72042024", true)
    
    -- Settings Button
    local settingsBtn = Instance.new("TextButton")
    settingsBtn.Size = UDim2.new(1, -20, 0, 40)
    settingsBtn.Position = UDim2.new(0, 10, 1, -50)
    settingsBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    settingsBtn.Text = getText("settings")
    settingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsBtn.TextScaled = true
    settingsBtn.Font = Enum.Font.GothamBold
    settingsBtn.Parent = scrollFrame
    
    local settingsCorner2 = Instance.new("UICorner")
    settingsCorner2.CornerRadius = UDim.new(0, 8)
    settingsCorner2.Parent = settingsBtn
    
    settingsBtn.MouseButton1Click:Connect(function()
        createSettings()
    end)
    
    -- Update canvas size
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #scrollFrame:GetChildren() * 90 + 60)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- START WARNING SYSTEM
-- ══════════════════════════════════════════════════════════════════════════════

createWarning(1)
