--[[
    ROBLOX DELTA EXPLOIT - PURE REMOTE SCANNER
    ONLY USES ACTUAL REMOTE EVENTS FOUND IN THE GAME
    NO CUSTOM STRINGS - PURE ARGUMENT SPAMMING
]]

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaPure"
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

-- MINIMAL GUI
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.8, -100, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
title.Text = "☠ DELTA PURE"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -25, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextScaled = true
close.Parent = frame
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local min = Instance.new("TextButton")
min.Size = UDim2.new(0, 25, 0, 25)
min.Position = UDim2.new(1, -50, 0, 0)
min.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
min.Text = "-"
min.TextColor3 = Color3.fromRGB(255, 255, 255)
min.TextScaled = true
min.Parent = frame

local minimized = false
min.MouseButton1Click:Connect(function()
    minimized = not minimized
    frame.Size = minimized and UDim2.new(0, 200, 0, 25) or UDim2.new(0, 200, 0, 120)
    for _, c in ipairs(frame:GetChildren()) do
        if c ~= title and c ~= close and c ~= min then
            c.Visible = not minimized
        end
    end
end)

local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(0.9, 0, 0, 35)
jumpBtn.Position = UDim2.new(0.05, 0, 0, 30)
jumpBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
jumpBtn.Text = "👻 SCARE ALL"
jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBtn.TextScaled = true
jumpBtn.Font = Enum.Font.GothamBold
jumpBtn.Parent = frame

local spamBtn = Instance.new("TextButton")
spamBtn.Size = UDim2.new(0.9, 0, 0, 35)
spamBtn.Position = UDim2.new(0.05, 0, 0, 70)
spamBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 180)
spamBtn.Text = "🔁 SPAM OFF"
spamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spamBtn.TextScaled = true
spamBtn.Font = Enum.Font.GothamBold
spamBtn.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 15)
status.Position = UDim2.new(0.05, 0, 0, 108)
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextColor3 = Color3.fromRGB(0, 255, 0)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = frame

-- ========== PURE SCANNER ==========

local function scanAllRemotes(obj, list)
    list = list or {}
    for _, child in ipairs(obj:GetChildren()) do
        if child:IsA("RemoteEvent") then
            table.insert(list, child)
        elseif child:IsA("RemoteFunction") then
            table.insert(list, child)
        end
        if #child:GetChildren() > 0 then
            scanAllRemotes(child, list)
        end
    end
    return list
end

local cachedRemotes = {}
local lastScan = 0

local function getRemotes()
    if tick() - lastScan > 5 then
        cachedRemotes = scanAllRemotes(game)
        lastScan = tick()
        status.Text = "Found "..#cachedRemotes.." remotes"
        print("[Delta] Found "..#cachedRemotes.." RemoteEvents/Functions")
    end
    return cachedRemotes
end

-- ========== PURE EXECUTION - NO CUSTOM NAMES ==========

-- ONLY sends: nothing, numbers, player name, and common generic words
-- NO custom phrases like "radius", "area", "zone", "map", "world", "game"
local function executeOnRemote(remote)
    local success = false
    
    if remote:IsA("RemoteEvent") then
        -- Send with NO arguments
        pcall(function()
            remote:FireServer()
            success = true
        end)
        
        -- Send with player name
        pcall(function()
            remote:FireServer(player.Name)
            success = true
        end)
        
        -- Send with numbers (asset IDs)
        pcall(function()
            remote:FireServer(137944174609015)
            success = true
        end)
        pcall(function()
            remote:FireServer(1243374081)
            success = true
        end)
        
        -- Send with both numbers
        pcall(function()
            remote:FireServer(137944174609015, 1243374081)
            success = true
        end)
        
        -- Send with player name and a number
        pcall(function()
            remote:FireServer(player.Name, 137944174609015)
            success = true
        end)
        pcall(function()
            remote:FireServer(player.Name, 1243374081)
            success = true
        end)
        
        -- Send with "all" and numbers
        pcall(function()
            remote:FireServer("all", 137944174609015)
            success = true
        end)
        pcall(function()
            remote:FireServer("all", 1243374081)
            success = true
        end)
        
        -- Send with just "all"
        pcall(function()
            remote:FireServer("all")
            success = true
        end)
        
    elseif remote:IsA("RemoteFunction") then
        pcall(function()
            remote:InvokeServer()
            success = true
        end)
        pcall(function()
            remote:InvokeServer(player.Name)
            success = true
        end)
        pcall(function()
            remote:InvokeServer(137944174609015)
            success = true
        end)
        pcall(function()
            remote:InvokeServer(1243374081)
            success = true
        end)
        pcall(function()
            remote:InvokeServer(137944174609015, 1243374081)
            success = true
        end)
        pcall(function()
            remote:InvokeServer(player.Name, 137944174609015)
            success = true
        end)
        pcall(function()
            remote:InvokeServer("all")
            success = true
        end)
        pcall(function()
            remote:InvokeServer("all", 137944174609015)
            success = true
        end)
    end
    
    return success
end

local function executeJumpscareOnAllRemotes()
    local remotes = getRemotes()
    local successCount = 0
    
    for _, remote in ipairs(remotes) do
        if executeOnRemote(remote) then
            successCount = successCount + 1
        end
    end
    
    return successCount
end

-- ========== PURE SPAM - NO CUSTOM NAMES ==========

local function spamRemote(remote)
    if remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        pcall(function() remote:FireServer(player.Name) end)
        pcall(function() remote:FireServer(137944174609015) end)
        pcall(function() remote:FireServer(1243374081) end)
        pcall(function() remote:FireServer(137944174609015, 1243374081) end)
        pcall(function() remote:FireServer(player.Name, 137944174609015) end)
        pcall(function() remote:FireServer("all") end)
        pcall(function() remote:FireServer("all", 137944174609015) end)
    elseif remote:IsA("RemoteFunction") then
        pcall(function() remote:InvokeServer() end)
        pcall(function() remote:InvokeServer(player.Name) end)
        pcall(function() remote:InvokeServer(137944174609015) end)
        pcall(function() remote:InvokeServer(1243374081) end)
        pcall(function() remote:InvokeServer(137944174609015, 1243374081) end)
        pcall(function() remote:InvokeServer("all") end)
    end
end

-- ========== LOCAL JUMBSCARE ==========

local function playLocalJumpscare()
    local black = Instance.new("Frame")
    black.Size = UDim2.new(1, 0, 1, 0)
    black.Position = UDim2.new(0, 0, 0, 0)
    black.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    black.BackgroundTransparency = 0.3
    black.ZIndex = 999
    black.Parent = player.PlayerGui
    
    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, 0, 1, 0)
    img.Position = UDim2.new(0, 0, 0, 0)
    img.Image = "rbxassetid://1243374081"
    img.BackgroundTransparency = 1
    img.ZIndex = 1000
    img.Parent = player.PlayerGui
    
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://137944174609015"
    sound.Volume = 10
    sound.PlayOnRemove = true
    sound.Parent = workspace
    sound:Play()
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        for i = 1, 8 do
            root.CFrame = root.CFrame + Vector3.new(math.random(-4, 4), math.random(-3, 3), math.random(-4, 4))
            task.wait(0.02)
        end
    end
    
    task.wait(2.5)
    img:Destroy()
    black:Destroy()
    sound:Destroy()
end

-- ========== BUTTONS ==========

local spamming = false
local spamCoroutine = nil

jumpBtn.MouseButton1Click:Connect(function()
    jumpBtn.Text = "⚠ SCANNING..."
    jumpBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    status.Text = "Executing..."
    
    playLocalJumpscare()
    
    local count = executeJumpscareOnAllRemotes()
    
    jumpBtn.Text = "✅ DONE ("..count.." hits)"
    jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    status.Text = "Sent to "..count.." remotes"
    
    task.wait(2)
    jumpBtn.Text = "👻 SCARE ALL"
    jumpBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
    status.Text = "Ready - "..#getRemotes().." remotes"
end)

spamBtn.MouseButton1Click:Connect(function()
    spamming = not spamming
    
    if spamming then
        spamBtn.Text = "🔁 SPAM ON"
        spamBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        status.Text = "Spamming all remotes..."
        
        spamCoroutine = coroutine.create(function()
            while spamming do
                local remotes = getRemotes()
                for _, remote in ipairs(remotes) do
                    spamRemote(remote)
                end
                task.wait(0.15)
            end
        end)
        coroutine.resume(spamCoroutine)
    else
        spamBtn.Text = "🔁 SPAM OFF"
        spamBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 180)
        status.Text = "Spam stopped"
        task.wait(1)
        status.Text = "Ready - "..#getRemotes().." remotes"
    end
end)

-- ========== INITIAL SCAN ==========

status.Text = "Scanning game..."
task.wait(0.5)

local remotes = getRemotes()
print("[Delta] Total RemoteEvents/Functions: "..#remotes)
for i, r in ipairs(remotes) do
    print("[Delta] "..i..". "..r:GetFullName().." ("..r.ClassName..")")
end
