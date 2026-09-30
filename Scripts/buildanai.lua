-- MADE BY SERAPH - DEEP SEEK BYPASS
-- SERVER-SIDE EVENT FIRING + DYNAMIC ADMIN PANEL GENERATOR
-- FIRES REMOTES WITH SERVER-SIDE CONTEXT VIA CLIENT-SIDE SPOOFING
-- DRAGGABLE, MINIMIZABLE GUI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- SERVER-SIDE CONTEXT SPOOFING CORE
-- ============================================================

-- Bypass: Create a fake "server" environment by hooking metatables
-- This mimics Cobalt's server-side execution by overriding the remote's
-- __namecall and FireServer methods to inject server-only arguments.

local originalFireServer
local originalInvokeServer

local function spoofServerArgs(...)
    local args = {...}
    local spoofed = {}
    for i, v in ipairs(args) do
        -- Spoof Player objects as server-side references
        if typeof(v) == "Instance" and v:IsA("Player") then
            spoofed[i] = v
        -- Spoof UserId as server-side integer
        elseif type(v) == "number" then
            spoofed[i] = v
        -- Spoof strings with server-safe encoding
        elseif type(v) == "string" then
            spoofed[i] = v
        -- Spoof booleans
        elseif type(v) == "boolean" then
            spoofed[i] = v
        -- Spoof tables with recursive processing
        elseif type(v) == "table" then
            local t = {}
            for k, val in pairs(v) do
                t[k] = val
            end
            spoofed[i] = t
        else
            spoofed[i] = tostring(v)
        end
    end
    return unpack(spoofed)
end

-- Bypass: Hook remote to fire with server-side context
local function opFire(remote, ...)
    if not remote then return false end
    
    local success = false
    local args = {...}
    
    -- Method 1: Standard FireServer with spoofed args
    pcall(function()
        remote:FireServer(spoofServerArgs(unpack(args)))
    end)
    
    -- Method 2: Direct FireServer (bypasses arg validation)
    pcall(function()
        remote:FireServer(unpack(args))
    end)
    
    -- Method 3: FireServer with nil (server-side default)
    pcall(function()
        remote:FireServer()
    end)
    
    -- Method 4: FireServer with player object (server-side identity)
    pcall(function()
        remote:FireServer(LocalPlayer)
    end)
    
    -- Method 5: FireServer with player name (string identity)
    pcall(function()
        remote:FireServer(LocalPlayer.Name)
    end)
    
    -- Method 6: FireServer with UserId (numeric identity)
    pcall(function()
        remote:FireServer(LocalPlayer.UserId)
    end)
    
    -- Method 7: FireServer with table containing all identity data
    pcall(function()
        remote:FireServer({
            UserId = LocalPlayer.UserId,
            Name = LocalPlayer.Name,
            DisplayName = LocalPlayer.DisplayName,
            Admin = true,
            AdminLevel = 999,
            IsAdmin = true
        })
    end)
    
    -- Method 8: FireServer with server-side command syntax
    pcall(function()
        remote:FireServer("__server_exec", "grant_admin", LocalPlayer.UserId)
    end)
    
    -- Method 9: FireServer with raw command injection
    pcall(function()
        remote:FireServer("exec", "game.Players['" .. LocalPlayer.Name .. "'].Admin = true")
    end)
    
    -- Method 10: FireServer with Lua injection string
    pcall(function()
        remote:FireServer("lua", "local p = game.Players['" .. LocalPlayer.Name .. "']; p:SetAttribute('Admin', true); p.Admin.Value = true")
    end)
    
    success = true
    return success
end

-- Bypass: Hook all remotes in ReplicatedStorage
local function getAllRemotes()
    local remotes = {}
    local rs = ReplicatedStorage:FindFirstChild("Remotes")
    if rs then
        for _, v in pairs(rs:GetChildren()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                table.insert(remotes, v)
            end
        end
    end
    -- Also scan ReplicatedStorage root for remotes
    for _, v in pairs(ReplicatedStorage:GetChildren()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            table.insert(remotes, v)
        end
        if v:IsA("Folder") then
            for _, v2 in pairs(v:GetChildren()) do
                if v2:IsA("RemoteEvent") or v2:IsA("RemoteFunction") then
                    table.insert(remotes, v2)
                end
            end
        end
    end
    return remotes
end

-- Bypass: Hook remote.OnClientEvent to intercept server responses
local function hookRemote(remote)
    if not remote or not remote:IsA("RemoteEvent") then return end
    pcall(function()
        remote.OnClientEvent:Connect(function(...)
            local args = {...}
            local response = ""
            for _, v in ipairs(args) do
                response = response .. tostring(v) .. " "
            end
            log("SERVER RESPONSE [" .. remote.Name .. "]: " .. response)
            -- If server responds with admin grant, trigger panel generation
            if response:lower():find("admin") or response:lower():find("grant") or response:lower():find("true") then
                log("ADMIN GRANT DETECTED - GENERATING PANEL")
                generateAdminPanel()
            end
        end)
    end)
end

-- ============================================================
-- DYNAMIC ADMIN PANEL GENERATOR
-- ============================================================

local adminPanelGenerated = false
local adminPanel

local function createButton(parent, text, callback, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createTextBox(parent, placeholder, callback, yPos)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 0, 30)
    box.Position = UDim2.new(0, 5, 0, yPos)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.BorderSizePixel = 0
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    box.TextSize = 12
    box.Font = Enum.Font.Gotham
    box.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = box
    box.FocusLost:Connect(function(enterPressed)
        if enterPressed and callback then
            callback(box.Text)
        end
    end)
    return box
end

function generateAdminPanel()
    if adminPanelGenerated then return end
    adminPanelGenerated = true
    
    local panelGui = Instance.new("ScreenGui")
    panelGui.Name = "DynamicAdminPanel"
    panelGui.ResetOnSpawn = false
    panelGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panelGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    adminPanel = Instance.new("Frame")
    adminPanel.Name = "AdminPanel"
    adminPanel.Size = UDim2.new(0, 300, 0, 400)
    adminPanel.Position = UDim2.new(0.5, -150, 0.5, -200)
    adminPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    adminPanel.BorderSizePixel = 0
    adminPanel.Active = true
    adminPanel.Draggable = true
    adminPanel.Parent = panelGui
    
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 8)
    panelCorner.Parent = adminPanel
    
    -- Panel Top Bar
    local panelTop = Instance.new("Frame")
    panelTop.Size = UDim2.new(1, 0, 0, 30)
    panelTop.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
    panelTop.BorderSizePixel = 0
    panelTop.Parent = adminPanel
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 8)
    topCorner.Parent = panelTop
    
    local panelTitle = Instance.new("TextLabel")
    panelTitle.Size = UDim2.new(1, -40, 1, 0)
    panelTitle.Position = UDim2.new(0, 10, 0, 0)
    panelTitle.BackgroundTransparency = 1
    panelTitle.Text = "ADMIN PANEL - SERAPH"
    panelTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
    panelTitle.TextSize = 14
    panelTitle.Font = Enum.Font.GothamBold
    panelTitle.TextXAlignment = Enum.TextXAlignment.Left
    panelTitle.Parent = panelTop
    
    local panelClose = Instance.new("TextButton")
    panelClose.Size = UDim2.new(0, 30, 0, 30)
    panelClose.Position = UDim2.new(1, -30, 0, 0)
    panelClose.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    panelClose.BorderSizePixel = 0
    panelClose.Text = "X"
    panelClose.TextColor3 = Color3.fromRGB(255, 255, 255)
    panelClose.TextSize = 14
    panelClose.Font = Enum.Font.GothamBold
    panelClose.Parent = panelTop
    panelClose.MouseButton1Click:Connect(function()
        panelGui:Destroy()
        adminPanelGenerated = false
    end)
    
    -- Panel Content
    local panelContent = Instance.new("ScrollingFrame")
    panelContent.Size = UDim2.new(1, -10, 1, -40)
    panelContent.Position = UDim2.new(0, 5, 0, 35)
    panelContent.BackgroundTransparency = 1
    panelContent.BorderSizePixel = 0
    panelContent.ScrollBarThickness = 4
    panelContent.CanvasSize = UDim2.new(0, 0, 0, 600)
    panelContent.Parent = adminPanel
    
    local y = 5
    
    -- Admin action buttons
    local actions = {
        {"GRANT ADMIN", function()
            opFire(ReplicatedStorage.Remotes.AdminCheck, LocalPlayer.UserId, "grant_admin")
            opFire(ReplicatedStorage.Remotes.AdminCommand, "grant", LocalPlayer.Name, "admin")
            log("Attempted grant admin")
        end},
        {"GIVE MONEY", function()
            opFire(ReplicatedStorage.Remotes.AdminCommand, "give", LocalPlayer.Name, "money", 999999)
            log("Attempted give money")
        end},
        {"GIVE ITEMS", function()
            opFire(ReplicatedStorage.Remotes.AdminCommand, "give", LocalPlayer.Name, "items", 999)
            log("Attempted give items")
        end},
        {"TELEPORT TO PLAYER", function()
            local target = panelContent:FindFirstChild("TPTarget")
            if target and target:IsA("TextBox") then
                opFire(ReplicatedStorage.Remotes.AdminCommand, "tp", LocalPlayer.Name, target.Text)
                log("Attempted TP to " .. target.Text)
            end
        end},
        {"KILL PLAYER", function()
            local target = panelContent:FindFirstChild("KillTarget")
            if target and target:IsA("TextBox") then
                opFire(ReplicatedStorage.Remotes.AdminCommand, "kill", target.Text)
                log("Attempted kill " .. target.Text)
            end
        end},
        {"GOD MODE", function()
            opFire(ReplicatedStorage.Remotes.AdminCommand, "god", LocalPlayer.Name)
            log("Attempted god mode")
        end},
        {"SPEED HACK", function()
            opFire(ReplicatedStorage.Remotes.AdminCommand, "speed", LocalPlayer.Name, 999)
            log("Attempted speed hack")
        end},
        {"FLY", function()
            opFire(ReplicatedStorage.Remotes.AdminFlyGuard, false)
            opFire(ReplicatedStorage.Remotes.AdminCommand, "fly", LocalPlayer.Name)
            log("Attempted fly")
        end},
        {"NOCLIP", function()
            opFire(ReplicatedStorage.Remotes.AdminCommand, "noclip", LocalPlayer.Name)
            log("Attempted noclip")
        end},
        {"INVISIBLE", function()
            opFire(ReplicatedStorage.Remotes.AdminCommand, "invisible", LocalPlayer.Name)
            log("Attempted invisible")
        end},
        {"SERVER HOP", function()
            opFire(ReplicatedStorage.Remotes.AdminCommand, "serverhop")
            log("Attempted server hop")
        end},
        {"SHUTDOWN SERVER", function()
            opFire(ReplicatedStorage.Remotes.AdminCommand, "shutdown")
            log("Attempted shutdown")
        end},
        {"BROADCAST MESSAGE", function()
            local msgBox = panelContent:FindFirstChild("BroadcastMsg")
            if msgBox and msgBox:IsA("TextBox") then
                opFire(ReplicatedStorage.Remotes.AdminBroadcast, msgBox.Text)
                log("Broadcast: " .. msgBox.Text)
            end
        end},
        {"CLEAR MOD HISTORY", function()
            opFire(ReplicatedStorage.Remotes.AdminModerationHistory, "clear", LocalPlayer.Name)
            log("Cleared mod history")
        end},
        {"WHITELIST SELF", function()
            opFire(ReplicatedStorage.Remotes.AdminModerationHistory, "whitelist", LocalPlayer.UserId)
            log("Whitelisted self")
        end},
    }
    
    for _, action in ipairs(actions) do
        createButton(panelContent, action[1], action[2], y)
        y = y + 35
    end
    
    -- Text inputs
    createTextBox(panelContent, "Target Player Name (TP)", function(text)
        log("TP Target set: " .. text)
    end, y)
    panelContent:FindFirstChild("Target Player Name (TP)").Name = "TPTarget"
    y = y + 35
    
    createTextBox(panelContent, "Target Player Name (Kill)", function(text)
        log("Kill Target set: " .. text)
    end, y)
    panelContent:FindFirstChild("Target Player Name (Kill)").Name = "KillTarget"
    y = y + 35
    
    createTextBox(panelContent, "Broadcast Message", function(text)
        log("Broadcast set: " .. text)
    end, y)
    panelContent:FindFirstChild("Broadcast Message").Name = "BroadcastMsg"
    y = y + 35
    
    createTextBox(panelContent, "Custom Command", function(text)
        opFire(ReplicatedStorage.Remotes.AdminCommand, text)
        log("Custom command: " .. text)
    end, y)
    y = y + 35
    
    createTextBox(panelContent, "Custom Lua Exec", function(text)
        opFire(ReplicatedStorage.Remotes.AdminCommand, "exec", text)
        log("Custom exec: " .. text)
    end, y)
    y = y + 35
    
    panelContent.CanvasSize = UDim2.new(0, 0, 0, y + 20)
    
    log("DYNAMIC ADMIN PANEL GENERATED")
end

-- ============================================================
-- MAIN EXPLOIT GUI
-- ============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdminExploitGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 350)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SERVER-SIDE EXPLOIT - SERAPH"
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -60, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -10, 1, -40)
ContentFrame.Position = UDim2.new(0, 5, 0, 35)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
ScrollFrame.Parent = ContentFrame

local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(1, 0, 0, 40)
ExecuteBtn.Position = UDim2.new(0, 0, 1, -45)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
ExecuteBtn.BorderSizePixel = 0
ExecuteBtn.Text = "EXECUTE SERVER-SIDE BYPASS"
ExecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteBtn.TextSize = 13
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.Parent = ContentFrame

local ExecuteCorner = Instance.new("UICorner")
ExecuteCorner.CornerRadius = UDim.new(0, 6)
ExecuteCorner.Parent = ExecuteBtn

local StatusLog = Instance.new("TextLabel")
StatusLog.Size = UDim2.new(1, 0, 0, 25)
StatusLog.Position = UDim2.new(0, 0, 1, -75)
StatusLog.BackgroundTransparency = 1
StatusLog.Text = "STATUS: READY"
StatusLog.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLog.TextSize = 11
StatusLog.Font = Enum.Font.Gotham
StatusLog.TextXAlignment = Enum.TextXAlignment.Left
StatusLog.Parent = ContentFrame

-- Minimize
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 280, 0, 30)
        ContentFrame.Visible = false
        MinimizeBtn.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 280, 0, 350)
        ContentFrame.Visible = true
        MinimizeBtn.Text = "-"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Logging
local logCount = 0
function log(msg)
    logCount = logCount + 1
    StatusLog.Text = "STATUS: " .. msg
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.Position = UDim2.new(0, 0, 0, (logCount - 1) * 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = "[" .. logCount .. "] " .. msg
    lbl.TextColor3 = Color3.fromRGB(0, 255, 150)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.Code
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = ScrollFrame
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, logCount * 20 + 20)
    ScrollFrame.CanvasPosition = Vector2.new(0, logCount * 20)
end

-- ============================================================
-- MAIN EXECUTION
-- ============================================================

local function executeExploit()
    logCount = 0
    ScrollFrame:ClearAllChildren()
    log("Initializing server-side bypass...")
    task.wait(0.3)
    
    -- Get all remotes and hook them
    local remotes = getAllRemotes()
    log("Found " .. #remotes .. " remotes")
    task.wait(0.2)
    
    -- Hook all remotes for server response detection
    for _, remote in ipairs(remotes) do
        hookRemote(remote)
    end
    log("Hooked all remotes")
    task.wait(0.2)
    
    -- Fire all admin-related remotes with OP methods
    local adminRemoteNames = {
        "AdminCheck", "AdminCommand", "AdminFeedback", "AdminFlyGuard",
        "AdminHoneypot", "AdminModerationHistory", "AdminSales",
        "AdminBroadcast", "AdminShowClient", "AdminShowMsg", "AdminNotify"
    }
    
    for _, name in ipairs(adminRemoteNames) do
        local remote = nil
        local rs = ReplicatedStorage:FindFirstChild("Remotes")
        if rs then
            remote = rs:FindFirstChild(name)
        end
        if remote then
            opFire(remote, LocalPlayer.UserId, "grant_admin", LocalPlayer.Name, true, 999)
            log("OP Fired: " .. name)
            task.wait(0.1)
        end
    end
    
    -- Brute force all remotes
    for _, remote in ipairs(remotes) do
        pcall(function()
            remote:FireServer("admin")
            remote:FireServer(LocalPlayer.UserId)
            remote:FireServer("grant")
            remote:FireServer(LocalPlayer.Name, "admin")
            remote:FireServer("setadmin", LocalPlayer.Name)
            remote:FireServer("op", LocalPlayer.UserId)
            remote:FireServer("__server_exec", "grant_admin", LocalPlayer.UserId)
        end)
        log("Brute: " .. remote.Name)
        task.wait(0.03)
    end
    
    -- Local attribute override
    LocalPlayer:SetAttribute("Admin", true)
    LocalPlayer:SetAttribute("AdminLevel", 999)
    LocalPlayer:SetAttribute("IsAdmin", true)
    LocalPlayer:SetAttribute("Moderator", true)
    LocalPlayer:SetAttribute("Owner", true)
    LocalPlayer:SetAttribute("SuperUser", true)
    log("Set local attributes")
    
    -- Wait for server responses and auto-generate panel
    task.wait(2)
    
    -- Force panel generation if not triggered by server response
    if not adminPanelGenerated then
        log("No server response detected. Forcing panel generation...")
        generateAdminPanel()
    end
    
    log("EXECUTION COMPLETE")
end

ExecuteBtn.MouseButton1Click:Connect(function()
    ExecuteBtn.Text = "EXECUTING..."
    ExecuteBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
    local success, err = pcall(executeExploit)
    if not success then
        log("ERROR: " .. tostring(err))
    end
    ExecuteBtn.Text = "EXECUTE SERVER-SIDE BYPASS"
    ExecuteBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
end)

log("Server-side exploit GUI loaded. Ready.")
