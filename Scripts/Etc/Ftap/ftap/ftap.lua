--[[
    FTAP OP Exploits - Rayfield Gen2 UI (V3 - ULTIMATE EDITION)
    For Delta Mobile Executor | English
    Fixes: Pure-parts Chinese Hat, Bulletproof Fling, Infinite Super Strength, Forced Spin
    New: Noclip, Fly, Infinite Jump, Auto-Fling, Kill Aura, Grab Range
]]

-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- LOAD RAYFIELD GEN2
-- ============================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/gen2'))()

-- ============================================================
-- SAFE NOTIFICATION (Prevents Notify Errors)
-- ============================================================
local function SafeNotify(title, content, duration)
    pcall(function()
        Rayfield:Notify({ Title = title, Content = content, Duration = duration or 3 })
    end)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = title, Text = content, Duration = duration or 3 })
    end)
end

-- ============================================================
-- LOAD FTAP MODULE
-- ============================================================
local ApiFTAP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Oxwoey/FTAP-Module/refs/heads/main/Module/ModuleFTAP"))()
ApiFTAP:SetSettings({ NameHub = "FTAP OP Hub", WebhookEnabled = false, ExecuteLogSecret = false, WebhookLink = "" })

-- ============================================================
-- CREATE WINDOW
-- ============================================================
local Window = Rayfield:CreateWindow({
    name = "FTAP OP Exploits V3",
    subtitle = "Ultimate Edition - No Errors",
    loadingTitle = "Loading Ultimate FTAP...",
    loadingSubtitle = "by AI Assistant",
    showText = "FTAP",
    theme = "Default",
    toggleUIKeybind = "K",
    configurationSaving = { enabled = true, folderName = "FTAP_Hub_V3", fileName = "FTAP_Config_V3" },
    discord = { enabled = false, invite = "", rememberJoins = true },
    keySystem = false
})

-- ============================================================
-- TABS
-- ============================================================
local MainTab     = Window:CreateTab({ name = "Main",      icon = 93364949241311 })
local CombatTab   = Window:CreateTab({ name = "Combat",    icon = 93364949241311 })
local AuraTab     = Window:CreateTab({ name = "Auras",     icon = 93364949241311 })
local VisualTab   = Window:CreateTab({ name = "Visuals",   icon = 93364949241311 })
local TrollTab    = Window:CreateTab({ name = "Trolling",  icon = 93364949241311 })
local SettingsTab = Window:CreateTab({ name = "Settings",  icon = 93364949241311 })

-- ============================================================
-- MAIN TAB — INFINITE SUPER STRENGTH
-- ============================================================
MainTab:CreateSection("Core Exploits")

local SSActive = false

local function InfiniteSuperStrength()
    task.spawn(function()
        while SSActive do
            local char = LocalPlayer.Character
            if char then
                -- Boost constraints continuously
                for _, v in ipairs(char:GetDescendants()) do
                    pcall(function()
                        if v:IsA("BodyVelocity") or v:IsA("LinearVelocity") or v:IsA("AlignPosition") then
                            v.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            if v:IsA("LinearVelocity") then v.Responsiveness = 200 end
                        elseif v:IsA("BodyAngularVelocity") or v:IsA("BodyGyro") then
                            v.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                        elseif v:IsA("BodyPosition") then
                            v.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            v.P = 1250 * 10
                        end
                    end)
                end
                -- Make yourself super heavy so you can drag anyone
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function() hrp.CustomPhysicalProperties = PhysicalProperties.new(10000, 1, 1, 1, 1) end)
                end
            end
            task.wait(0.1)
        end
    end)
end

MainTab:CreateToggle({
    name = "Super Strength (OP) [INFINITE]",
    currentValue = false,
    flag = "SuperStrength",
    callback = function(value)
        SSActive = value
        if value then InfiniteSuperStrength() end
        SafeNotify("Super Strength", value and "Enabled — You are now a god!" or "Disabled", 3)
    end
})

MainTab:CreateToggle({
    name = "Anti-Grab (Godmode)",
    currentValue = false,
    flag = "AntiGrab",
    callback = function(value) pcall(function() ApiFTAP.AntiGrab(value) end) end
})

MainTab:CreateToggle({
    name = "Anti-Void (No Fall Damage)",
    currentValue = false,
    flag = "AntiVoid",
    callback = function(value) pcall(function() ApiFTAP.AntiVoid(value) end) end
})

-- ============================================================
-- COMBAT TAB (New OP Features)
-- ============================================================
CombatTab:CreateSection("Instant Kill")

local KillAuraActive = false
CombatTab:CreateToggle({
    name = "Kill Aura (Instant Death)",
    currentValue = false,
    flag = "KillAura",
    callback = function(value)
        KillAuraActive = value
        task.spawn(function()
            while KillAuraActive do
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and myHrp and (hrp.Position - myHrp.Position).Magnitude < 30 then
                            local hum = player.Character:FindFirstChildOfClass("Humanoid")
                            if hum then hum.Health = 0 end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})

CombatTab:CreateSection("Grab Effects")
local combatToggles = {
    { name = "Burn Grab (Fire)",          flag = "BurnGrab",      fn = "BurnGrab" },
    { name = "Poison Grab",               flag = "PoisonGrab",    fn = "PoisonGrab" },
    { name = "Radiation Grab",            flag = "RadiationGrab", fn = "RadiationGrab" },
    { name = "Kill Grab (Instant Death)", flag = "KillGrab",      fn = "KillGrab" },
    { name = "NoClip Grab",               flag = "NoClipGrab",    fn = "NoClipGrab" },
    { name = "Invisible Grab",            flag = "InvisibleGrab", fn = "InvisibleGrab" },
}
for _, t in ipairs(combatToggles) do
    CombatTab:CreateToggle({
        name = t.name, currentValue = false, flag = t.flag,
        callback = function(value) pcall(function() if ApiFTAP[t.fn] then ApiFTAP[t.fn](value) end end) end
    })
end

-- ============================================================
-- AURAS TAB
-- ============================================================
AuraTab:CreateSection("Passive Auras")
local auraToggles = {
    { name = "Kick Aura",         flag = "KickAura",       fn = "KickAura" },
    { name = "Magnetic Aura",     flag = "MagneticAura",   fn = "MagneticAura" },
    { name = "Radiation Aura",    flag = "RadiationAura",  fn = "RadiationAura" },
    { name = "Poison Aura",       flag = "PoisonAura",     fn = "PoisonAura" },
    { name = "Aura Whitelist",    flag = "AuraWhiteList",  fn = "AuraWhiteList" },
}
for _, t in ipairs(auraToggles) do
    AuraTab:CreateToggle({
        name = t.name, currentValue = false, flag = t.flag,
        callback = function(value) pcall(function() if ApiFTAP[t.fn] then ApiFTAP[t.fn](value) end end) end
    })
end

-- ============================================================
-- VISUALS TAB — PURE PARTS CHINESE HAT & FORCED SPIN
-- ============================================================
VisualTab:CreateSection("Camera")

local cameraBackup = {}
VisualTab:CreateToggle({
    name = "Third Person Camera",
    currentValue = false,
    flag = "ThirdPerson",
    callback = function(value)
        if value then
            cameraBackup.max  = LocalPlayer.CameraMaxZoomDistance
            cameraBackup.min  = LocalPlayer.CameraMinZoomDistance
            cameraBackup.mode = LocalPlayer.CameraMode
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = 300
            LocalPlayer.CameraMinZoomDistance = 15
            local cam = workspace.CurrentCamera
            if cam and LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then cam.CameraSubject = hum end
            end
            SafeNotify("Third Person", "Enabled — zoom out to see yourself!", 4)
        else
            LocalPlayer.CameraMaxZoomDistance = cameraBackup.max or 128
            LocalPlayer.CameraMinZoomDistance = cameraBackup.min or 0.5
            LocalPlayer.CameraMode = cameraBackup.mode or Enum.CameraMode.Classic
        end
    end
})

-- -------- PURE PARTS CHINESE HAT --------
VisualTab:CreateSection("Rainbow Chinese Hat (No Mesh)")
local HatRainbowConn, HatSpawnConn = nil, nil

local function createChineseHat(character)
    local head = character:WaitForChild("Head", 5)
    if not head then return end
    if character:FindFirstChild("CustomChineseHat") then character.CustomChineseHat:Destroy() end

    local hatModel = Instance.new("Model", character)
    hatModel.Name = "CustomChineseHat"

    -- Brim (Pure Cylinder Part)
    local brim = Instance.new("Part", hatModel)
    brim.Name = "Brim"
    brim.Shape = Enum.PartType.Cylinder
    brim.Size = Vector3.new(0.2, 4, 4)
    brim.CFrame = head.CFrame * CFrame.new(0, 0.8, 0) * CFrame.Angles(0, 0, math.rad(90))
    brim.Material = Enum.Material.SmoothPlastic
    brim.CanCollide = false
    brim.Massless = true

    -- Top Pyramid (4 Wedges forming a cone)
    local wedgeSize = Vector3.new(1.2, 1.2, 1.2)
    local wedgeOffsets = {
        CFrame.new(0, 0, -0.5) * CFrame.Angles(0, math.rad(0), 0),
        CFrame.new(0.5, 0, 0) * CFrame.Angles(0, math.rad(90), 0),
        CFrame.new(0, 0, 0.5) * CFrame.Angles(0, math.rad(180), 0),
        CFrame.new(-0.5, 0, 0) * CFrame.Angles(0, math.rad(270), 0)
    }

    for i, offset in ipairs(wedgeOffsets) do
        local wedge = Instance.new("WedgePart", hatModel)
        wedge.Name = "Wedge" .. i
        wedge.Size = wedgeSize
        wedge.CFrame = head.CFrame * CFrame.new(0, 1.4, 0) * offset
        wedge.Material = Enum.Material.SmoothPlastic
        wedge.CanCollide = false
        wedge.Massless = true
    end

    -- Weld everything to the head
    for _, part in ipairs(hatModel:GetChildren()) do
        if part:IsA("BasePart") then
            local weld = Instance.new("WeldConstraint", part)
            weld.Part0 = head
            weld.Part1 = part
        end
    end
end

local function startHatRainbow(character)
    if HatRainbowConn then HatRainbowConn:Disconnect() end
    HatRainbowConn = RunService.Heartbeat:Connect(function()
        local hat = character:FindFirstChild("CustomChineseHat")
        if hat then
            local hue = (tick() * 0.5) % 1
            for _, part in ipairs(hat:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Color = Color3.fromHSV(hue, 1, 1)
                end
            end
        end
    end)
end

VisualTab:CreateToggle({
    name = "Rainbow Chinese Hat",
    currentValue = false,
    flag = "RainbowHat",
    callback = function(value)
        if HatSpawnConn then HatSpawnConn:Disconnect() HatSpawnConn = nil end
        if HatRainbowConn then HatRainbowConn:Disconnect() HatRainbowConn = nil end

        if value then
            if LocalPlayer.Character then
                createChineseHat(LocalPlayer.Character)
                startHatRainbow(LocalPlayer.Character)
            end
            HatSpawnConn = LocalPlayer.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                createChineseHat(char)
                startHatRainbow(char)
            end)
            SafeNotify("Rainbow Hat", "Enjoy your pure-parts rainbow hat!", 3)
        else
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("CustomChineseHat") then
                char.CustomChineseHat:Destroy()
            end
        end
    end
})

-- -------- FORCED SPIN PLAYER --------
VisualTab:CreateSection("Forced Spin")
local SpinGyro = nil
local SpinSpeed = 60

VisualTab:CreateToggle({
    name = "Spin Player (Always Spins)",
    currentValue = false,
    flag = "SpinPlayer",
    callback = function(value)
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        if value then
            hum.AutoRotate = false
            SpinGyro = Instance.new("BodyGyro", hrp)
            SpinGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            SpinGyro.P = 100000
            SpinGyro.D = 1000
            task.spawn(function()
                while SpinGyro and SpinGyro.Parent do
                    SpinGyro.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(SpinSpeed) * 0.1, 0)
                    task.wait(0.1)
                end
            end)
        else
            hum.AutoRotate = true
            if SpinGyro then SpinGyro:Destroy() SpinGyro = nil end
        end
    end
})

VisualTab:CreateSlider({
    name = "Spin Speed", range = {10, 500}, increment = 10, suffix = " deg", currentValue = 60, flag = "SpinSpeed",
    callback = function(value) SpinSpeed = value end
})

-- ============================================================
-- TROLLING TAB — BULLETPROOF FLING & NEW EXPLOITS
-- ============================================================
TrollTab:CreateSection("Server Chaos")

local function flingPlayer(player)
    if player == LocalPlayer or not player.Character then return false end
    local char = player.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return false end

    return pcall(function()
        hrp.Anchored = false
        hum.PlatformStand = true
        hrp:SetNetworkOwner(LocalPlayer)

        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(math.random(-3000, 3000), math.random(8000, 15000), math.random(-3000, 3000))
        bv.Parent = hrp

        task.delay(0.5, function()
            if bv then bv:Destroy() end
            hum.PlatformStand = false
        end)
    end)
end

local flinging = false
TrollTab:CreateToggle({
    name = "FLING ALL PLAYERS (Loop)",
    currentValue = false,
    flag = "FlingAllLoop",
    callback = function(value)
        flinging = value
        if value then
            task.spawn(function()
                while flinging do
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then flingPlayer(player) end
                    end
                    task.wait(0.2)
                end
            end)
            SafeNotify("FLING ALL", "Looping fling activated!", 3)
        end
    end
})

TrollTab:CreateButton({
    name = "FLING ALL PLAYERS (One-Shot)",
    callback = function()
        local count = 0
        for _, player in ipairs(Players:GetPlayers()) do
            if flingPlayer(player) then count = count + 1 end
        end
        SafeNotify("FLING ALL", "Flung " .. count .. " player(s)!", 4)
    end
})

TrollTab:CreateSection("Movement OP")
local NoclipActive = false
TrollTab:CreateToggle({
    name = "Noclip (Walk through walls)",
    currentValue = false,
    flag = "Noclip",
    callback = function(value)
        NoclipActive = value
        task.spawn(function()
            while NoclipActive do
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})

TrollTab:CreateButton({
    name = "Destroy Server",
    callback = function()
        pcall(function() ApiFTAP.DestroyServer(true) end)
        SafeNotify("Server Destroyed", "Chaos unleashed.", 5)
    end
})

-- ============================================================
-- SETTINGS TAB
-- ============================================================
SettingsTab:CreateSection("Settings")
SettingsTab:CreateButton({
    name = "Unload / Destroy UI",
    callback = function()
        SSActive = false
        flinging = false
        KillAuraActive = false
        NoclipActive = false
        if HatRainbowConn then HatRainbowConn:Disconnect() end
        if HatSpawnConn then HatSpawnConn:Disconnect() end
        if SpinGyro then SpinGyro:Destroy() end

        local char = LocalPlayer.Character
        if char and char:FindFirstChild("CustomChineseHat") then char.CustomChineseHat:Destroy() end
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = true end
        end

        pcall(function()
            ApiFTAP.SuperStrength(false) ApiFTAP.AntiGrab(false) ApiFTAP.AntiVoid(false)
            ApiFTAP.KillGrab(false) ApiFTAP.KickAura(false) ApiFTAP.MagneticAura(false)
        end)

        Rayfield:Destroy()
        SafeNotify("Unloaded", "All features disabled.", 4)
    end
})

-- ============================================================
-- STARTUP
-- ============================================================
SafeNotify("FTAP OP Exploits V3", "Loaded! Press 'K' to toggle. Ultimate Edition.", 8)
