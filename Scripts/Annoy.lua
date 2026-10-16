-- OrionLib Troll Script v2.0
-- Teleports your character to where the target player is looking (third person camera raycast)

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Qanuir/orion-ui/refs/heads/main/source.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local state = {
    visionBlock = false,
    headFollow = false,
    espEnabled = false,
    espRainbow = false,
    espFov = 70,
    fpsCap = 60,
    annoyEnabled = false,
    annoyMode = "Head",
    annoySpeed = 5,
    targetPlayer = nil,
    teleportEnabled = false,
    teleportDistance = 3,
    teleportBehind = true,
}

local Window = OrionLib:MakeWindow({
    Name = "Troll Suite",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "TrollConfig",
    IntroEnabled = true,
    IntroText = "Troll Suite v2.0",
    IntroIcon = "rbxassetid://4483345998",
    Icon = "rbxassetid://4483345998",
})

-- ═══════════════════════════════════════════
-- TAB: Vision Troll
-- ═══════════════════════════════════════════

local VisionTab = Window:MakeTab({
    Name = "Vision Troll",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

VisionTab:AddSection({ Name = "Block Vision" })

VisionTab:AddToggle({
    Name = "Block Their Vision",
    Default = false,
    Flag = "visionBlock",
    Save = false,
    Callback = function(Value)
        state.visionBlock = Value
    end
})

VisionTab:AddToggle({
    Name = "Head Follow Camera",
    Default = false,
    Flag = "headFollow",
    Save = false,
    Callback = function(Value)
        state.headFollow = Value
    end
})

local targetList = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        table.insert(targetList, p.Name)
    end
end

VisionTab:AddDropdown({
    Name = "Target Player",
    Default = "None",
    Options = targetList,
    Flag = "visionTarget",
    Save = false,
    Callback = function(Value)
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name == Value then
                state.targetPlayer = p
                break
            end
        end
    end
})

-- ═══════════════════════════════════════════
-- TAB: Teleport Troll
-- ═══════════════════════════════════════════

local TPTab = Window:MakeTab({
    Name = "Teleport Troll",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TPTab:AddSection({ Name = "Teleport To Target's View" })

TPTab:AddToggle({
    Name = "Enable Teleport",
    Default = false,
    Flag = "teleportEnabled",
    Save = false,
    Callback = function(Value)
        state.teleportEnabled = Value
    end
})

TPTab:AddDropdown({
    Name = "Teleport Target",
    Default = "None",
    Options = targetList,
    Flag = "tpTarget",
    Save = false,
    Callback = function(Value)
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name == Value then
                state.tpTarget = p
                break
            end
        end
    end
})

TPTab:AddSlider({
    Name = "Distance From Look Point",
    Min = 1,
    Max = 20,
    Default = 3,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "studs",
    Flag = "tpDistance",
    Save = false,
    Callback = function(Value)
        state.teleportDistance = Value
    end
})

TPTab:AddToggle({
    Name = "Behind Target (not in face)",
    Default = true,
    Flag = "tpBehind",
    Save = false,
    Callback = function(Value)
        state.teleportBehind = Value
    end
})

TPTab:AddToggle({
    Name = "Snap Every Frame",
    Default = true,
    Flag = "tpSnap",
    Save = false,
    Callback = function(Value)
        state.tpSnap = Value
    end
})

-- ═══════════════════════════════════════════
-- TAB: ESP
-- ═══════════════════════════════════════════

local ESPTab = Window:MakeTab({
    Name = "ESP",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

ESPTab:AddSection({ Name = "2D ESP (CS2 Style)" })

ESPTab:AddToggle({
    Name = "Enable 2D ESP",
    Default = false,
    Flag = "espEnabled",
    Save = false,
    Callback = function(Value)
        state.espEnabled = Value
        if Value then startESP() else stopESP() end
    end
})

ESPTab:AddToggle({
    Name = "Rainbow ESP (Animated)",
    Default = false,
    Flag = "espRainbow",
    Save = false,
    Callback = function(Value)
        state.espRainbow = Value
    end
})

ESPTab:AddSlider({
    Name = "ESP FOV",
    Min = 30,
    Max = 120,
    Default = 70,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "°",
    Flag = "espFov",
    Save = false,
    Callback = function(Value)
        state.espFov = Value
        if Camera then Camera.FieldOfView = Value end
    end
})

-- ═══════════════════════════════════════════
-- TAB: Annoy
-- ═══════════════════════════════════════════

local AnnoyTab = Window:MakeTab({
    Name = "Annoy",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

AnnoyTab:AddSection({ Name = "Character Annoyance" })

AnnoyTab:AddToggle({
    Name = "Enable Annoy Mode",
    Default = false,
    Flag = "annoyEnabled",
    Save = false,
    Callback = function(Value)
        state.annoyEnabled = Value
    end
})

AnnoyTab:AddDropdown({
    Name = "Annoy Type",
    Default = "Head",
    Options = {"Head", "Torso", "Whole Body"},
    Flag = "annoyMode",
    Save = false,
    Callback = function(Value)
        state.annoyMode = Value
    end
})

AnnoyTab:AddSlider({
    Name = "Speed",
    Min = 1,
    Max = 20,
    Default = 5,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "x",
    Flag = "annoySpeed",
    Save = false,
    Callback = function(Value)
        state.annoySpeed = Value
    end
})

-- ═══════════════════════════════════════════
-- TAB: Mobile
-- ═══════════════════════════════════════════

local MobileTab = Window:MakeTab({
    Name = "Mobile",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MobileTab:AddSection({ Name = "Performance" })

MobileTab:AddSlider({
    Name = "FPS Cap",
    Min = 30,
    Max = 240,
    Default = 60,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "FPS",
    Flag = "fpsCap",
    Save = false,
    Callback = function(Value)
        state.fpsCap = Value
        pcall(function() setfpscap(Value) end)
    end
})

-- ═══════════════════════════════════════════
-- CORE: TELEPORT TO TARGET'S LOOK POINT
-- ═══════════════════════════════════════════

--[
    How it works:
    - Target's camera is CLIENT-SIDE. We can't read it directly.
    - Instead we use their HumanoidRootPart CFrame + their head look direction.
    - Their head LookVector approximates where they're aiming in third person.
    - We raycast forward from their head to find the look point.
    - We teleport our HumanoidRootPart to that point + offset.
    - Head is used instead of camera because head replicates. Camera does not.
    
    Third-person camera note:
    In third person, the player's camera sits behind their character. The head
    LookVector points where the camera is aiming horizontally/vertically. So the
    head look direction IS the camera aim direction (minus shoulder offset).
--]

local tpConn
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.IgnoreWater = true

local function getTargetLookPoint(targetPlayer, maxDistance)
    -- returns Vector3 of where the target's head is looking, or nil
    if not targetPlayer then return nil end
    local char = targetPlayer.Character
    if not char then return nil end
    local head = char:FindFirstChild("Head")
    if not head then return nil end
    
    -- Filter out both characters so raycast doesn't hit bodies
    local filter = {LocalPlayer.Character, char}
    raycastParams.FilterDescendantsInstances = filter
    
    local origin = head.Position
    local direction = head.CFrame.LookVector * (maxDistance or 500)
    local result = workspace:Raycast(origin, direction, raycastParams)
    
    if result then
        return result.Position, result.Normal
    end
    return origin + direction, Vector3.new(0, 1, 0)
end

local function getBehindOffset(targetPlayer, distance)
    -- returns a CFrame positioned behind the target along their look direction
    if not targetPlayer then return nil end
    local char = targetPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local look = hrp.CFrame.LookVector
    -- behind = opposite of look direction
    local behindPos = hrp.Position - look * distance
    return CFrame.new(behindPos, hrp.Position) -- face toward target
end

local function teleportToLookPoint()
    if not state.teleportEnabled or not state.tpTarget then return end
    
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myChar:FindFirstChildOfClass("Humanoid")
    if not myHrp or not myHumanoid then return end
    
    local targetChar = state.tpTarget.Character
    if not targetChar then return end
    local targetHead = targetChar:FindFirstChild("Head")
    if not targetHead then return end
    
    local lookPoint, normal = getTargetLookPoint(state.tpTarget, 500)
    if not lookPoint then return end
    
    local dist = state.teleportDistance
    
    local newCFrame
    if state.teleportBehind then
        -- Place us behind the target, but at the height of the look point
        local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
        if targetHrp then
            local look = targetHrp.CFrame.LookVector
            local flatLook = Vector3.new(look.X, 0, look.Z).Unit
            local behindPos = targetHrp.Position - flatLook * dist
            behindPos = Vector3.new(behindPos.X, lookPoint.Y + 3, behindPos.Z)
            newCFrame = CFrame.new(behindPos, Vector3.new(targetHrp.Position.X, behindPos.Y, targetHrp.Position.Z))
        end
    else
        -- Place us AT the look point, slightly offset
        local offsetPos = lookPoint + normal * dist
        newCFrame = CFrame.new(offsetPos, lookPoint)
    end
    
    if newCFrame then
        -- Claim ownership first so replication works
        pcall(function()
            myHrp:SetNetworkOwner(LocalPlayer)
        end)
        myHrp.CFrame = newCFrame
        myHrp.Velocity = Vector3.zero
        myHrp.RotVelocity = Vector3.zero
    end
end

-- ═══════════════════════════════════════════
-- CORE: VISION BLOCK
-- ═══════════════════════════════════════════

local visionConn

local function startVisionBlock()
    if visionConn then visionConn:Disconnect() end
    visionConn = RunService.RenderStepped:Connect(function()
        if not state.visionBlock or not state.targetPlayer then return end
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("Head") then return end
        local targetChar = state.targetPlayer.Character
        if not targetChar or not targetChar:FindFirstChild("Head") then return end
        
        local head = char.Head
        local targetHead = targetChar.Head
        
        pcall(function() head:SetNetworkOwner(LocalPlayer) end)
        
        -- Position head 2 studs in front of the target's head, in their look direction
        local look = targetHead.CFrame.LookVector
        head.CFrame = CFrame.new(targetHead.Position + look * 2, targetHead.Position + look * 4)
    end)
end

-- ═══════════════════════════════════════════
-- CORE: HEAD FOLLOW
-- ═══════════════════════════════════════════

local headFollowConn

local function startHeadFollow()
    if headFollowConn then headFollowConn:Disconnect() end
    headFollowConn = RunService.RenderStepped:Connect(function()
        if not state.headFollow or not state.targetPlayer then return end
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("Head") then return end
        local targetChar = state.targetPlayer.Character
        if not targetChar or not targetChar:FindFirstChild("Head") then return end
        
        local head = char.Head
        local targetHead = targetChar.Head
        pcall(function() head:SetNetworkOwner(LocalPlayer) end)
        
        head.CFrame = CFrame.new(targetHead.Position + targetHead.CFrame.LookVector * 2)
    end)
end

-- ═══════════════════════════════════════════
-- CORE: ESP
-- ═══════════════════════════════════════════

local espObjects = {}

local function createESP(player)
    if player == LocalPlayer then return end
    if espObjects[player] then return end
    
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 1
    box.Color = Color3.fromRGB(255, 255, 255)
    
    local nameTag = Drawing.new("Text")
    nameTag.Size = 14
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Color = Color3.fromRGB(255, 255, 255)
    
    local healthBar = Drawing.new("Square")
    healthBar.Thickness = 1
    healthBar.Filled = true
    healthBar.Color = Color3.fromRGB(0, 255, 0)
    
    local healthBg = Drawing.new("Square")
    healthBg.Thickness = 1
    healthBg.Filled = true
    healthBg.Color = Color3.fromRGB(0, 0, 0)
    
    espObjects[player] = {
        box = box, nameTag = nameTag,
        healthBar = healthBar, healthBg = healthBg,
        conn = nil
    }
    
    local obj = espObjects[player]
    obj.conn = RunService.RenderStepped:Connect(function()
        if not state.espEnabled then
            obj.box.Visible = false
            obj.nameTag.Visible = false
            obj.healthBar.Visible = false
            obj.healthBg.Visible = false
            return
        end
        local char = player.Character
        if not char then
            obj.box.Visible = false
            obj.nameTag.Visible = false
            obj.healthBar.Visible = false
            obj.healthBg.Visible = false
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local head = char:FindFirstChild("Head")
        if not hrp or not humanoid or humanoid.Health <= 0 or not head then
            obj.box.Visible = false
            obj.nameTag.Visible = false
            obj.healthBar.Visible = false
            obj.healthBg.Visible = false
            return
        end
        local rootPos, rootOnScreen = Camera:WorldToViewportPoint(hrp.Position)
        local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
        if not (rootOnScreen and headOnScreen) then
            obj.box.Visible = false
            obj.nameTag.Visible = false
            obj.healthBar.Visible = false
            obj.healthBg.Visible = false
            return
        end
        local height = math.abs(headPos.Y - rootPos.Y)
        local width = height * 0.6
        local topLeft = Vector2.new(rootPos.X - width/2, headPos.Y)
        
        obj.box.Size = Vector2.new(width, height)
        obj.box.Position = topLeft
        obj.box.Visible = true
        
        if state.espRainbow then
            local hue = (tick() * 0.5) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            obj.box.Color = color
            obj.nameTag.Color = color
        else
            obj.box.Color = Color3.fromRGB(255, 255, 255)
            obj.nameTag.Color = Color3.fromRGB(255, 255, 255)
        end
        
        obj.nameTag.Text = player.Name
        obj.nameTag.Position = Vector2.new(rootPos.X, headPos.Y - 18)
        obj.nameTag.Visible = true
        
        local healthPct = humanoid.Health / humanoid.MaxHealth
        local barWidth = 4
        local barHeight = height * healthPct
        
        obj.healthBg.Size = Vector2.new(barWidth, height)
        obj.healthBg.Position = Vector2.new(topLeft.X - 8, topLeft.Y)
        obj.healthBg.Visible = true
        
        obj.healthBar.Size = Vector2.new(barWidth, barHeight)
        obj.healthBar.Position = Vector2.new(topLeft.X - 8, topLeft.Y + (height - barHeight))
        obj.healthBar.Color = Color3.fromRGB(0, 255, 0)
        obj.healthBar.Visible = true
    end)
end

local function removeESP(player)
    if espObjects[player] then
        if espObjects[player].conn then espObjects[player].conn:Disconnect() end
        espObjects[player].box:Remove()
        espObjects[player].nameTag:Remove()
        espObjects[player].healthBar:Remove()
        espObjects[player].healthBg:Remove()
        espObjects[player] = nil
    end
end

local espStarted = false
local function startESP()
    if espStarted then return end
    espStarted = true
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then createESP(p) end
    end
    Players.PlayerAdded:Connect(function(p)
        if state.espEnabled then createESP(p) end
    end)
    Players.PlayerRemoving:Connect(function(p) removeESP(p) end)
end

local function stopESP()
    for player, _ in pairs(espObjects) do removeESP(player) end
    espStarted = false
end

-- ═══════════════════════════════════════════
-- CORE: ANNOY
-- ═══════════════════════════════════════════

local annoyConn

local function startAnnoy()
    if annoyConn then annoyConn:Disconnect() end
    annoyConn = RunService.Heartbeat:Connect(function()
        if not state.annoyEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        
        local speed = state.annoySpeed
        local t = tick() * speed
        local offset = Vector3.new(
            math.sin(t) * 5,
            math.cos(t) * 5,
            math.sin(t * 1.3) * 5
        )
        
        local parts = {}
        if state.annoyMode == "Head" then
            local h = char:FindFirstChild("Head")
            if h then table.insert(parts, h) end
        elseif state.annoyMode == "Torso" then
            local t1 = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            if t1 then table.insert(parts, t1) end
        else
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then table.insert(parts, part) end
            end
        end
        
        for _, part in ipairs(parts) do
            pcall(function() part:SetNetworkOwner(LocalPlayer) end)
            part.CFrame = part.CFrame + offset
        end
    end)
end

-- ═══════════════════════════════════════════
-- MAIN LOOPS
-- ═══════════════════════════════════════════

-- Teleport loop
tpConn = RunService.Heartbeat:Connect(function()
    if state.teleportEnabled and state.tpSnap ~= false then
        pcall(teleportToLookPoint)
    end
end)

-- One-shot teleport button
TPTab:AddButton({
    Name = "Teleport Now",
    Callback = function()
        teleportToLookPoint()
    end
})

-- Vision block loop
startVisionBlock()
startHeadFollow()
startAnnoy()

-- Update target dropdowns when players join
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        -- dropdown refresh not natively supported in OrionLib; user re-selects
    end
end)

-- Handle respawn (reclaim ownership)
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function() part:SetNetworkOwner(LocalPlayer) end)
        end
    end
end)

OrionLib:Init()
