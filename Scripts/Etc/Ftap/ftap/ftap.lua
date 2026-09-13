--[[
    FTAP OP Exploits - Rayfield Gen2 UI (FIXED + ENHANCED)
    For Delta Mobile Executor | English
    Fixes: Notify errors, Broken Hat Mesh, Super Strength, FLING ALL
]]

-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- LOAD RAYFIELD GEN2
-- ============================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/gen2'))()

-- ============================================================
-- SAFE NOTIFICATION FUNCTION (Fixes "attempt to call missing method 'Notify'")
-- ============================================================
local function SafeNotify(title, content, duration)
    -- Try Rayfield notify first
    pcall(function()
        Rayfield:Notify({
            Title = title,
            Content = content,
            Duration = duration or 3
        })
    end)
    -- Fallback to Roblox default notification
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = content,
            Duration = duration or 3
        })
    end)
end

-- ============================================================
-- LOAD FTAP MODULE
-- ============================================================
local ApiFTAP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Oxwoey/FTAP-Module/refs/heads/main/Module/ModuleFTAP"))()

ApiFTAP:SetSettings({
    NameHub = "FTAP OP Hub",
    WebhookEnabled = false,
    ExecuteLogSecret = false,
    WebhookLink = "YOUR_WEBHOOK_URL_HERE"
})

-- ============================================================
-- CREATE WINDOW
-- ============================================================
local Window = Rayfield:CreateWindow({
    name = "FTAP OP Exploits",
    subtitle = "Fixed & Enhanced Edition",
    loadingTitle = "Loading FTAP...",
    loadingSubtitle = "by AI Assistant",
    showText = "FTAP",
    theme = "Default",
    toggleUIKeybind = "K",
    configurationSaving = {
        enabled = true,
        folderName = "FTAP_Hub",
        fileName = "FTAP_Config"
    },
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
-- MAIN TAB — FIXED SUPER STRENGTH
-- ============================================================
MainTab:CreateSection("Core Exploits")

local SSConn = nil

local function boostConstraint(inst)
    if inst:IsA("BodyVelocity") then
        inst.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        inst.P = 1250 * 5
    elseif inst:IsA("LinearVelocity") then
        inst.MaxForce = math.huge
        inst.Responsiveness = 200
    elseif inst:IsA("AlignPosition") then
        inst.MaxForce = math.huge
        inst.Responsiveness = 200
    elseif inst:IsA("BodyAngularVelocity") then
        inst.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    elseif inst:IsA("BodyForce") then
        inst.Force = inst.Force * 10
    elseif inst:IsA("BodyThrust") then
        inst.Force = inst.Force * 10
    elseif inst:IsA("BodyPosition") then
        inst.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        inst.P = 1250 * 5
    elseif inst:IsA("BodyGyro") then
        inst.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    elseif inst:IsA("RopeConstraint") then
        inst.Visible = false
    end
end

local function ToggleSuperStrength(enabled)
    if SSConn then SSConn:Disconnect() SSConn = nil end
    if not enabled then return end

    for _, v in ipairs(workspace:GetDescendants()) do
        pcall(boostConstraint, v)
    end

    SSConn = workspace.DescendantAdded:Connect(function(inst)
        pcall(boostConstraint, inst)
    end)
end

MainTab:CreateToggle({
    name = "Super Strength (OP) [FIXED]",
    currentValue = false,
    flag = "SuperStrength",
    callback = function(value)
        ToggleSuperStrength(value)
        pcall(function() ApiFTAP.SuperStrength(value) end)
        SafeNotify("Super Strength", value and "Enabled — Grab power is now massive!" or "Disabled", 3)
    end
})

MainTab:CreateToggle({
    name = "Anti-Grab (Godmode)",
    currentValue = false,
    flag = "AntiGrab",
    callback = function(value) pcall(function() ApiFTAP.AntiGrab(value) end) end
})

MainTab:CreateToggle({
    name = "Anti-Explosion",
    currentValue = false,
    flag = "AntiExploin",
    callback = function(value) pcall(function() ApiFTAP.AntiExploin(value) end) end
})

MainTab:CreateToggle({
    name = "Anti-Void (No Fall Damage)",
    currentValue = false,
    flag = "AntiVoid",
    callback = function(value) pcall(function() ApiFTAP.AntiVoid(value) end) end
})

-- ============================================================
-- COMBAT TAB
-- ============================================================
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
        name = t.name,
        currentValue = false,
        flag = t.flag,
        callback = function(value)
            pcall(function()
                if ApiFTAP[t.fn] then ApiFTAP[t.fn](value) end
            end)
        end
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
        name = t.name,
        currentValue = false,
        flag = t.flag,
        callback = function(value)
            pcall(function()
                if ApiFTAP[t.fn] then ApiFTAP[t.fn](value) end
            end)
        end
    })
end

-- ============================================================
-- VISUALS TAB
-- ============================================================
VisualTab:CreateSection("Camera")

-- -------- THIRD PERSON CAMERA --------
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

-- -------- RAINBOW CHINESE HAT --------
VisualTab:CreateSection("Rainbow Chinese Hat")

local CurrentHat, HatHighlight = nil, nil
local HatRainbowConn, HatSpawnConn = nil, nil

local function createChineseHat(character)
    local head = character:WaitForChild("Head", 5)
    if not head then return end

    if CurrentHat and CurrentHat.Parent then CurrentHat:Destroy() end

    local hat = Instance.new("Part")
    hat.Name = "RainbowChineseHat"
    hat.Size = Vector3.new(2.5, 1, 2.5)
    hat.Material = Enum.Material.SmoothPlastic
    hat.CanCollide = false
    hat.CanTouch = false
    hat.CanQuery = false
    hat.Massless = true
    hat.Color = Color3.fromRGB(255, 0, 0)
    hat.CFrame = head.CFrame * CFrame.new(0, 0.9, 0)
    hat.Parent = character

    -- FIXED: Replaced broken mesh ID with a safe Roblox cone mesh
    local mesh = Instance.new("SpecialMesh", hat)
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://1088394331" -- Safe Roblox cone mesh
    mesh.Scale = Vector3.new(1, 0.6, 1)

    local hl = Instance.new("Highlight", hat)
    hl.FillColor = Color3.fromRGB(255, 0, 0)
    hl.FillTransparency = 0.2
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.OutlineTransparency = 0.3
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local weld = Instance.new("Weld", hat)
    weld.Part0 = head
    weld.Part1 = hat
    weld.C0 = CFrame.new(0, 0.9, 0)

    CurrentHat, HatHighlight = hat, hl
end

local function startHatRainbow()
    if HatRainbowConn then HatRainbowConn:Disconnect() end
    HatRainbowConn = RunService.Heartbeat:Connect(function()
        if CurrentHat and CurrentHat.Parent and HatHighlight then
            local hue = (tick() * 0.5) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            HatHighlight.FillColor = color
            HatHighlight.OutlineColor = Color3.fromHSV((hue + 0.5) % 1, 1, 1)
            CurrentHat.Color = color
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
                startHatRainbow()
            end

            HatSpawnConn = LocalPlayer.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                createChineseHat(char)
                startHatRainbow()
            end)

            SafeNotify("Rainbow Hat", "Enjoy your rainbow Chinese hat!", 3)
        else
            if CurrentHat then CurrentHat:Destroy() CurrentHat = nil end
            HatHighlight = nil
        end
    end
})

-- -------- SPIN PLAYER --------
VisualTab:CreateSection("Spin")

local SpinConn = nil
local SpinSpeed = 30
local SpinAxis = "Y"

VisualTab:CreateToggle({
    name = "Spin Player",
    currentValue = false,
    flag = "SpinPlayer",
    callback = function(value)
        if SpinConn then SpinConn:Disconnect() SpinConn = nil end
        if not value then return end

        SpinConn = RunService.Heartbeat:Connect(function(dt)
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local rot
            if SpinAxis == "Y" then
                rot = CFrame.Angles(0, math.rad(SpinSpeed) * dt, 0)
            elseif SpinAxis == "X" then
                rot = CFrame.Angles(math.rad(SpinSpeed) * dt, 0, 0)
            else
                rot = CFrame.Angles(0, 0, math.rad(SpinSpeed) * dt)
            end

            hrp.CFrame = hrp.CFrame * rot
        end)
    end
})

VisualTab:CreateSlider({
    name = "Spin Speed",
    range = {5, 300},
    increment = 5,
    suffix = " deg/s",
    currentValue = 30,
    flag = "SpinSpeed",
    callback = function(value) SpinSpeed = value end
})

VisualTab:CreateDropdown({
    name = "Spin Axis",
    options = { "Y (Horizontal)", "X (Forward Roll)", "Z (Side Roll)" },
    currentOption = "Y (Horizontal)",
    flag = "SpinAxis",
    callback = function(option)
        if option == "Y (Horizontal)" then SpinAxis = "Y"
        elseif option == "X (Forward Roll)" then SpinAxis = "X"
        else SpinAxis = "Z" end
    end
})

-- ============================================================
-- TROLLING TAB — FIXED FLING ALL
-- ============================================================
TrollTab:CreateSection("Server Chaos")

local flinging = false
local flingConn = nil

local function flingPlayer(player)
    if player == LocalPlayer or not player.Character then return false end
    local char = player.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return false end

    local ok = pcall(function()
        hrp:SetNetworkOwner(LocalPlayer)

        local dir = Vector3.new(
            math.random(-1, 1),
            math.random(1, 3),
            math.random(-1, 1)
        ).Unit

        hrp.AssemblyLinearVelocity = dir * 8000
        hrp:ApplyImpulse(dir * (hrp.AssemblyMass * 5000))

        local oldBV = hrp:FindFirstChild("FlingBV")
        if oldBV then oldBV:Destroy() end

        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlingBV"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = dir * 8000
        bv.Parent = hrp

        task.delay(0.15, function()
            if bv and bv.Parent then bv:Destroy() end
        end)
    end)

    return ok
end

TrollTab:CreateToggle({
    name = "FLING ALL PLAYERS (Loop)",
    currentValue = false,
    flag = "FlingAllLoop",
    callback = function(value)
        flinging = value
        if flingConn then flingConn:Disconnect() flingConn = nil end
        if not value then return end

        flingConn = task.spawn(function()
            while flinging do
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        flingPlayer(player)
                    end
                end
                task.wait(0.15)
            end
        end)

        SafeNotify("FLING ALL", value and "Looping fling enabled!" or "Stopped.", 3)
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

TrollTab:CreateToggle({
    name = "Anti-Blobman",
    currentValue = false,
    flag = "AntiBlobman",
    callback = function(value) pcall(function() ApiFTAP.AntiBlobman(value) end) end
})

TrollTab:CreateToggle({
    name = "RGB Line",
    currentValue = false,
    flag = "RbgLine",
    callback = function(value) pcall(function() ApiFTAP.RbgLine(value) end) end
})

TrollTab:CreateButton({
    name = "Destroy Server",
    callback = function()
        pcall(function() ApiFTAP.DestroyServer(true) end)
        SafeNotify("Server Destroyed", "Chaos unleashed.", 5)
    end
})

TrollTab:CreateToggle({
    name = "Destroy Server Whitelist",
    currentValue = false,
    flag = "DestroyServerWhite",
    callback = function(value) pcall(function() ApiFTAP.DestroyServerWhite(value) end) end
})

-- ============================================================
-- SETTINGS TAB
-- ============================================================
SettingsTab:CreateSection("Settings")

SettingsTab:CreateToggle({
    name = "Enable Blacklist",
    currentValue = false,
    flag = "BlacklistToggle",
    callback = function(value)
        pcall(function()
            ApiFTAP:Blacklist({
                BlacklistToggle = value,
                Url = "https://pastebin.com/raw/JYvCaxAV",
                KickText = "You are blacklisted."
            })
        end)
    end
})

SettingsTab:CreateButton({
    name = "Unload / Destroy UI",
    callback = function()
        flinging = false
        if flingConn then flingConn:Disconnect() end
        if SSConn then SSConn:Disconnect() end
        if HatRainbowConn then HatRainbowConn:Disconnect() end
        if HatSpawnConn then HatSpawnConn:Disconnect() end
        if SpinConn then SpinConn:Disconnect() end
        if CurrentHat then CurrentHat:Destroy() end

        pcall(function()
            ApiFTAP.SuperStrength(false)
            ApiFTAP.AntiGrab(false)
            ApiFTAP.AntiExploin(false)
            ApiFTAP.AntiVoid(false)
            ApiFTAP.BurnGrab(false)
            ApiFTAP.PoisonGrab(false)
            ApiFTAP.RadiationGrab(false)
            ApiFTAP.KillGrab(false)
            ApiFTAP.NoClipGrab(false)
            ApiFTAP.InvisibleGrab(false)
            ApiFTAP.KickAura(false)
            ApiFTAP.MagneticAura(false)
            ApiFTAP.RadiationAura(false)
            ApiFTAP.PoisonAura(false)
            ApiFTAP.AntiBlobman(false)
            ApiFTAP.RbgLine(false)
        end)

        Rayfield:Destroy()
        SafeNotify("Unloaded", "All features disabled.", 4)
    end
})

-- ============================================================
-- STARTUP NOTIFICATION
-- ============================================================
SafeNotify("FTAP OP Exploits Loaded!", "Press 'K' to toggle the UI. Errors fixed!", 8)
