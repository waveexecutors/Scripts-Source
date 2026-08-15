--[[
    Roblox Delta Exploit - Universal Remote Scanner & Server-Side Execution
    FOR EDUCATIONAL PURPOSES ONLY - Using this violates Roblox ToS
    This script scans ALL instances for ANY RemoteEvent/RemoteFunction
    and attempts to exploit them for server-side code execution
]]

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Create floating GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaExploitGUI"
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 200)
frame.Position = UDim2.new(0.5, -140, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = false
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Title bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
title.Text = "DELTA EXPLOIT v3.0"
title.TextColor3 = Color3.fromRGB(255, 50, 50)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -70, 0, 0)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
minBtn.Text = "_"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = frame

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        frame.Size = UDim2.new(0, 280, 0, 30)
        for _, child in ipairs(frame:GetChildren()) do
            if child ~= title and child ~= closeBtn and child ~= minBtn then
                child.Visible = false
            end
        end
    else
        frame.Size = UDim2.new(0, 280, 0, 200)
        for _, child in ipairs(frame:GetChildren()) do
            if child ~= title and child ~= closeBtn and child ~= minBtn then
                child.Visible = true
            end
        end
    end
end)

-- Jumpscare button
local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(0.85, 0, 0, 45)
jumpBtn.Position = UDim2.new(0.075, 0, 0, 40)
jumpBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
jumpBtn.Text = "🔴 JUMBSCARE EVERYONE"
jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBtn.TextScaled = true
jumpBtn.Font = Enum.Font.GothamBold
jumpBtn.Parent = frame

local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(0, 4)
jumpCorner.Parent = jumpBtn

-- Spam toggle button
local spamBtn = Instance.new("TextButton")
spamBtn.Size = UDim2.new(0.85, 0, 0, 45)
spamBtn.Position = UDim2.new(0.075, 0, 0, 95)
spamBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 200)
spamBtn.Text = "⏸ SPAM ALL REMOTES (OFF)"
spamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spamBtn.TextScaled = true
spamBtn.Font = Enum.Font.GothamBold
spamBtn.Parent = frame

local spamCorner = Instance.new("UICorner")
spamCorner.CornerRadius = UDim.new(0, 4)
spamCorner.Parent = spamBtn

-- Status label
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.85, 0, 0, 25)
status.Position = UDim2.new(0.075, 0, 0, 150)
status.BackgroundTransparency = 1
status.Text = "READY - Found 0 remotes"
status.TextColor3 = Color3.fromRGB(0, 255, 0)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = frame

-- Remote count label
local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(0.85, 0, 0, 20)
countLabel.Position = UDim2.new(0.075, 0, 0, 178)
countLabel.BackgroundTransparency = 1
countLabel.Text = "Scripts: 0 | Remotes: 0"
countLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
countLabel.TextScaled = true
countLabel.Font = Enum.Font.Gotham
countLabel.Parent = frame

-- ========== EXPLOIT FUNCTIONS ==========

-- Recursive scanner for ALL remote events/functions
local function scanAllRemotes(container, list)
    list = list or {}
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            table.insert(list, child)
        end
        if child:GetChildren() then
            scanAllRemotes(child, list)
        end
    end
    return list
end

-- Scan ALL scripts (ServerScript, LocalScript, ModuleScript)
local function scanAllScripts(container, list)
    list = list or {}
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript") then
            table.insert(list, child)
        end
        if child:GetChildren() then
            scanAllScripts(child, list)
        end
    end
    return list
end

-- Execute jumpscare on ALL players via any remote
local function executeJumpscareOnAll()
    local remotes = scanAllRemotes(game)
    local successCount = 0
    
    for _, remote in ipairs(remotes) do
        if remote:IsA("RemoteEvent") then
            -- Try ALL possible argument patterns to trigger jumpscare
            local patterns = {
                {"jumpscare"},
                {"playSound", "137944174609015"},
                {"showImage", "1243374081"},
                {"scream"},
                {"scare"},
                {"trigger", "all"},
                {"effect", "jumpscare"},
                {"event", "scare"},
                {"play", "scream"},
                {"display", "image", "1243374081"},
                {"sound", "137944174609015"},
                {"global", "jumpscare"},
                {"all", "scream"},
                {"broadcast", "scare"},
                {"send", "jumpscare"},
                {"fire", "all", "jumpscare"},
                {player.Name, "jumpscare"},
                {"admin", "jumpscare"},
                {"cmd", "scare", "all"},
                {"execute", "jumpscare"},
                {"run", "scream"},
                {"call", "scare", "all"}
            }
            
            for _, args in ipairs(patterns) do
                pcall(function()
                    remote:FireServer(unpack(args))
                    successCount = successCount + 1
                end)
            end
            
            -- Also try with no args
            pcall(function()
                remote:FireServer()
                successCount = successCount + 1
            end)
            
        elseif remote:IsA("RemoteFunction") then
            pcall(function()
                remote:InvokeServer("jumpscare", "all")
                remote:InvokeServer("playSound", "137944174609015")
                remote:InvokeServer("showImage", "1243374081")
                remote:InvokeServer("scare", "all")
                remote:InvokeServer()
            end)
        end
    end
    
    return successCount
end

-- Server-side code injection attempts
local function attemptServerInjection()
    local scripts = scanAllScripts(game)
    local injected = false
    
    -- Method 1: Try to find ModuleScripts that use require() and inject code
    for _, script in ipairs(scripts) do
        if script:IsA("ModuleScript") then
            pcall(function()
                local module = require(script)
                if type(module) == "table" then
                    -- Try to call any function with malicious payload
                    for funcName, func in pairs(module) do
                        if type(func) == "function" then
                            pcall(func, "loadstring('game:GetService(\"Players\"):FindFirstChild(\""..player.Name.."\").Character.Humanoid.Health = 0')()")
                            pcall(func, "game:GetService('Players'):FindFirstChild('"..player.Name.."').Character.Humanoid.Health = 0")
                        end
                    end
                end
            end)
        end
        
        -- Method 2: Try to modify script source if possible (debug library)
        pcall(function()
            if script:IsA("Script") and script:GetFullName():lower():find("server") then
                -- Some games use loadstring on remote events
                local remotes = scanAllRemotes(game)
                for _, remote in ipairs(remotes) do
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer("loadstring", "game.Players."..player.Name..".Character.Humanoid.Health = 0")
                        remote:FireServer("exec", "game.Players."..player.Name..".Character.Humanoid.Health = 0")
                        remote:FireServer("run", "game:GetService('Players')."..player.Name..".Character.Humanoid.Health = 0")
                    end
                end
            end
        end)
    end
    
    -- Method 3: Look for common admin/command remotes
    local commonNames = {
        "RemoteEvent", "Admin", "Command", "Execute", "Run", "Server",
        "Global", "Broadcast", "Send", "Fire", "Trigger", "Call",
        "Invoke", "Network", "Sync", "Replicate", "Dispatch"
    }
    
    for _, name in ipairs(commonNames) do
        local remote = game:FindFirstChild(name, true)
        if remote and remote:IsA("RemoteEvent") then
            pcall(function()
                remote:FireServer("loadstring('game.Players."..player.Name..".Character.Humanoid.Health = 0')")
                remote:FireServer("exec", "game.Players."..player.Name..".Character.Humanoid.Health = 0")
                remote:FireServer("run", "game:GetService('Players')."..player.Name..".Character.Humanoid.Health = 0")
            end)
        end
    end
    
    return injected
end

-- Jumpscare effect on local client
local function playLocalJumpscare()
    -- Fullscreen black overlay
    local black = Instance.new("Frame")
    black.Size = UDim2.new(1, 0, 1, 0)
    black.Position = UDim2.new(0, 0, 0, 0)
    black.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    black.BackgroundTransparency = 0.2
    black.ZIndex = 999
    black.Parent = player.PlayerGui
    
    -- Jumpscare image
    local image = Instance.new("ImageLabel")
    image.Size = UDim2.new(1, 0, 1, 0)
    image.Position = UDim2.new(0, 0, 0, 0)
    image.Image = "rbxassetid://1243374081"
    image.BackgroundTransparency = 1
    image.ZIndex = 1000
    image.Parent = player.PlayerGui
    
    -- LOUD scream sound
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://137944174609015"
    sound.Volume = 10
    sound.PlayOnRemove = true
    sound.Parent = workspace
    sound:Play()
    
    -- Vibrate/shake effect (optional)
    local originalPos = player.Character and player.Character.HumanoidRootPart and player.Character.HumanoidRootPart.Position
    if player.Character and player.Character.HumanoidRootPart then
        for i = 1, 10 do
            player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(
                math.random(-2, 2),
                math.random(-1, 1),
                math.random(-2, 2)
            )
            task.wait(0.05)
        end
    end
    
    -- Remove after 2.5 seconds
    task.wait(2.5)
    image:Destroy()
    black:Destroy()
    sound:Destroy()
end

-- ========== BUTTON FUNCTIONS ==========

local isSpamming = false
local spamCoroutine = nil

jumpBtn.MouseButton1Click:Connect(function()
    status.Text = "EXECUTING JUMBSCARE..."
    status.TextColor3 = Color3.fromRGB(255, 200, 0)
    
    -- Play locally
    playLocalJumpscare()
    
    -- Send to all via remotes
    local sent = executeJumpscareOnAll()
    
    -- Try server injection
    attemptServerInjection()
    
    status.Text = "JUMBSCARE SENT ("..sent.." remotes)"
    status.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    task.wait(3)
    status.Text = "READY"
end)

spamBtn.MouseButton1Click:Connect(function()
    isSpamming = not isSpamming
    
    if isSpamming then
        spamBtn.Text = "▶ SPAM ALL REMOTES (ON)"
        spamBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        status.Text = "SPAMMING REMOTES..."
        status.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        spamCoroutine = coroutine.create(function()
            local counter = 0
            while isSpamming do
                local remotes = scanAllRemotes(game)
                for _, remote in ipairs(remotes) do
                    if remote:IsA("RemoteEvent") then
                        pcall(function()
                            remote:FireServer("jumpscare", "all")
                            remote:FireServer("scream", "137944174609015")
                            remote:FireServer("image", "1243374081")
                            remote:FireServer("scare", "all")
                            remote:FireServer("global", "jumpscare")
                            remote:FireServer()
                            remote:FireServer(player.Name, "jumpscare")
                        end)
                    elseif remote:IsA("RemoteFunction") then
                        pcall(function()
                            remote:InvokeServer("jumpscare", "all")
                            remote:InvokeServer("scream", "137944174609015")
                            remote:InvokeServer()
                        end)
                    end
                end
                
                -- Try injection every 2 cycles
                counter = counter + 1
                if counter % 2 == 0 then
                    attemptServerInjection()
                end
                
                task.wait(0.3)
            end
        end)
        coroutine.resume(spamCoroutine)
        
    else
        spamBtn.Text = "⏸ SPAM ALL REMOTES (OFF)"
        spamBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 200)
        status.Text = "SPAM STOPPED"
        status.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        task.wait(2)
        status.Text = "READY"
    end
end)

-- ========== INITIAL SCAN ==========

status.Text = "SCANNING GAME..."
task.wait(0.5)

local allRemotes = scanAllRemotes(game)
local allScripts = scanAllScripts(game)

countLabel.Text = "Scripts: "..#allScripts.." | Remotes: "..#allRemotes
status.Text = "READY - Found "..#allRemotes.." remotes"
status.TextColor3 = Color3.fromRGB(0, 255, 0)

-- Log for debugging
print("[Delta Exploit] Loaded successfully")
print("[Delta Exploit] Found "..#allRemotes.." RemoteEvents/Functions")
print("[Delta Exploit] Found "..#allScripts.." Scripts")
