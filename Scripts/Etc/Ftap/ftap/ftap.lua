--[[
    FTAP OP Exploits - Rayfield Gen2 UI
    For Delta Mobile Executor
    English Interface
]]

-- ============================================================
-- 1. LOAD RAYFIELD GEN2 UI
-- ============================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/gen2'))()

-- Mobile-friendly window setup
local Window = Rayfield:CreateWindow({
    name = "FTAP OP Exploits",
    subtitle = "Powered by Rayfield Gen2",
    loadingTitle = "Loading FTAP...",
    loadingSubtitle = "by AI Assistant",
    showText = "Rayfield",
    theme = "Default",
    toggleUIKeybind = "K", -- Press K to hide/show the UI
    configurationSaving = {
        enabled = true,
        folderName = "FTAP_Hub",
        fileName = "FTAP_Config"
    },
    discord = {
        enabled = false,
        invite = "",
        rememberJoins = true
    },
    keySystem = false
})

-- ============================================================
-- 2. LOAD THE OFFICIAL FTAP MODULE
-- ============================================================
local ApiFTAP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Oxwoey/FTAP-Module/refs/heads/main/Module/ModuleFTAP"))()

-- Configure the module (optional webhook logging)
ApiFTAP:SetSettings({
    NameHub = "FTAP OP Hub",
    WebhookEnabled = false, -- Set to true and add a URL if you want logs
    ExecuteLogSecret = false,
    WebhookLink = "YOUR_WEBHOOK_URL_HERE"
})

-- ============================================================
-- 3. CREATE TABS
-- ============================================================
local MainTab = Window:CreateTab({ name = "Main", icon = 93364949241311 })
local CombatTab = Window:CreateTab({ name = "Combat", icon = 93364949241311 })
local AuraTab = Window:CreateTab({ name = "Auras", icon = 93364949241311 })
local TrollTab = Window:CreateTab({ name = "Trolling", icon = 93364949241311 })
local SettingsTab = Window:CreateTab({ name = "Settings", icon = 93364949241311 })

-- ============================================================
-- 4. MAIN TAB - CORE EXPLOITS
-- ============================================================
MainTab:CreateSection("Core Exploits")

MainTab:CreateToggle({
    name = "Super Strength (OP Grab)",
    currentValue = false,
    flag = "SuperStrength",
    callback = function(value)
        ApiFTAP.SuperStrength(value)
        Rayfield:Notify({
            title = "Super Strength",
            content = value and "Enabled - Grab power is now massive!" or "Disabled",
            duration = 3
        })
    end
})

MainTab:CreateSlider({
    name = "Strength Multiplier",
    range = {100, 1000},
    increment = 50,
    suffix = "x",
    currentValue = 150,
    flag = "StrengthValue",
    callback = function(value)
        ApiFTAP.ValueStrength(value)
    end
})

MainTab:CreateToggle({
    name = "Anti-Grab (Godmode)",
    currentValue = false,
    flag = "AntiGrab",
    callback = function(value)
        ApiFTAP.AntiGrab(value)
    end
})

MainTab:CreateToggle({
    name = "Anti-Explosion",
    currentValue = false,
    flag = "AntiExploin",
    callback = function(value)
        ApiFTAP.AntiExploin(value)
    end
})

MainTab:CreateToggle({
    name = "Anti-Void (No Fall Damage)",
    currentValue = false,
    flag = "AntiVoid",
    callback = function(value)
        ApiFTAP.AntiVoid(value)
    end
})

-- ============================================================
-- 5. COMBAT TAB - GRAB EFFECTS
-- ============================================================
CombatTab:CreateSection("Grab Effects")

CombatTab:CreateToggle({
    name = "Burn Grab (Fire)",
    currentValue = false,
    flag = "BurnGrab",
    callback = function(value)
        ApiFTAP.BurnGrab(value)
    end
})

CombatTab:CreateToggle({
    name = "Poison Grab",
    currentValue = false,
    flag = "PoisonGrab",
    callback = function(value)
        ApiFTAP.PoisonGrab(value)
    end
})

CombatTab:CreateToggle({
    name = "Radiation Grab",
    currentValue = false,
    flag = "RadiationGrab",
    callback = function(value)
        ApiFTAP.RadiationGrab(value)
    end
})

CombatTab:CreateToggle({
    name = "Kill Grab (Instant Death)",
    currentValue = false,
    flag = "KillGrab",
    callback = function(value)
        ApiFTAP.KillGrab(value)
        if value then
            Rayfield:Notify({
                title = "Kill Grab",
                content = "Anyone you grab will be instantly killed!",
                duration = 5
            })
        end
    end
})

CombatTab:CreateToggle({
    name = "NoClip Grab (Phase Through Walls)",
    currentValue = false,
    flag = "NoClipGrab",
    callback = function(value)
        ApiFTAP.NoClipGrab(value)
    end
})

CombatTab:CreateToggle({
    name = "Invisible Grab",
    currentValue = false,
    flag = "InvisibleGrab",
    callback = function(value)
        ApiFTAP.InvisibleGrab(value)
    end
})

-- ============================================================
-- 6. AURAS TAB - PASSIVE DAMAGE
-- ============================================================
AuraTab:CreateSection("Passive Auras")

AuraTab:CreateToggle({
    name = "Kick Aura (Auto-Kick Nearby)",
    currentValue = false,
    flag = "KickAura",
    callback = function(value)
        ApiFTAP.KickAura(value)
    end
})

AuraTab:CreateToggle({
    name = "Magnetic Aura (Pull Players)",
    currentValue = false,
    flag = "MagneticAura",
    callback = function(value)
        ApiFTAP.MagneticAura(value)
    end
})

AuraTab:CreateToggle({
    name = "Radiation Aura",
    currentValue = false,
    flag = "RadiationAura",
    callback = function(value)
        ApiFTAP.RadiationAura(value)
    end
})

AuraTab:CreateToggle({
    name = "Poison Aura",
    currentValue = false,
    flag = "PoisonAura",
    callback = function(value)
        ApiFTAP.PoisonAura(value)
    end
})

AuraTab:CreateToggle({
    name = "Aura Whitelist (Ignore Friends)",
    currentValue = false,
    flag = "AuraWhiteList",
    callback = function(value)
        ApiFTAP.AuraWhiteList(value)
    end
})

-- ============================================================
-- 7. TROLLING TAB - CHAOS FEATURES
-- ============================================================
TrollTab:CreateSection("Server Chaos")

TrollTab:CreateButton({
    name = "FLING ALL PLAYERS (OP)",
    callback = function()
        -- Custom fling-all function that works independently of the module
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Apply massive velocity to fling them
                    hrp.AssemblyLinearVelocity = Vector3.new(
                        math.random(-5000, 5000),
                        math.random(5000, 15000),
                        math.random(-5000, 5000)
                    )
                end
            end
        end
        
        Rayfield:Notify({
            title = "FLING ALL",
            content = "Every player in the server has been flung!",
            duration = 5
        })
    end
})

TrollTab:CreateToggle({
    name = "Anti-Blobman",
    currentValue = false,
    flag = "AntiBlobman",
    callback = function(value)
        ApiFTAP.AntiBlobman(value)
    end
})

TrollTab:CreateToggle({
    name = "RGB Line (Visual Effect)",
    currentValue = false,
    flag = "RbgLine",
    callback = function(value)
        ApiFTAP.RbgLine(value)
    end
})

TrollTab:CreateButton({
    name = "Destroy Server",
    callback = function()
        ApiFTAP.DestroyServer(true)
        Rayfield:Notify({
            title = "Server Destroyed",
            content = "The server is now being destroyed...",
            duration = 5
        })
    end
})

TrollTab:CreateToggle({
    name = "Destroy Server Whitelist (Ignore Friends)",
    currentValue = false,
    flag = "DestroyServerWhite",
    callback = function(value)
        ApiFTAP.DestroyServerWhite(value)
    end
})

-- ============================================================
-- 8. SETTINGS TAB
-- ============================================================
SettingsTab:CreateSection("Blacklist & Settings")

SettingsTab:CreateToggle({
    name = "Enable Blacklist",
    currentValue = false,
    flag = "BlacklistToggle",
    callback = function(value)
        ApiFTAP:Blacklist({
            BlacklistToggle = value,
            Url = "https://pastebin.com/raw/JYvCaxAV", -- Replace with your list
            KickText = "You are blacklisted from this hub."
        })
    end
})

SettingsTab:CreateButton({
    name = "Reload Script",
    callback = function()
        -- Simple reload by re-executing the entire script
        loadstring(game:HttpGet("YOUR_SCRIPT_URL_HERE"))()
    end
})

SettingsTab:CreateButton({
    name = "Unload / Destroy UI",
    callback = function()
        -- Disable all features before destroying
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
        
        Rayfield:Destroy()
        Rayfield:Notify({
            title = "Unloaded",
            content = "All features disabled and UI destroyed.",
            duration = 5
        })
    end
})

-- ============================================================
-- 9. INITIAL NOTIFICATION
-- ============================================================
Rayfield:Notify({
    title = "FTAP OP Exploits Loaded!",
    content = "Press 'K' to toggle the UI. Use with caution!",
    duration = 8
})
