-- MADE BY SERAPH - DEEP SEEK BYPASS
-- SHORT KICK-PROOF ADMIN EXPLOIT + AUTO PANEL

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

-- BLOCK KICK
local origKick = LP.Kick
LP.Kick = function(self, msg) warn("KICK BLOCKED: "..tostring(msg)) end

-- GUI
local sg = Instance.new("ScreenGui", PG)
sg.Name = "SeraphBypass"
sg.ResetOnSpawn = false

local mf = Instance.new("Frame", sg)
mf.Size = UDim2.new(0,260,0,300)
mf.Position = UDim2.new(0.5,-130,0.5,-150)
mf.BackgroundColor3 = Color3.fromRGB(15,15,15)
mf.Active = true
mf.Draggable = true
Instance.new("UICorner", mf).CornerRadius = UDim.new(0,8)

local tb = Instance.new("Frame", mf)
tb.Size = UDim2.new(1,0,0,30)
tb.BackgroundColor3 = Color3.fromRGB(35,35,35)
tb.BorderSizePixel = 0
Instance.new("UICorner", tb).CornerRadius = UDim.new(0,8)

local t = Instance.new("TextLabel", tb)
t.Size = UDim2.new(1,-60,1,0)
t.Position = UDim2.new(0,10,0,0)
t.BackgroundTransparency = 1
t.Text = "BYPASS - SERAPH"
t.TextColor3 = Color3.fromRGB(0,255,100)
t.TextSize = 13
t.Font = Enum.Font.GothamBold
t.TextXAlignment = Enum.TextXAlignment.Left

local mb = Instance.new("TextButton", tb)
mb.Size = UDim2.new(0,30,0,30)
mb.Position = UDim2.new(1,-60,0,0)
mb.BackgroundColor3 = Color3.fromRGB(60,60,60)
mb.Text = "-"
mb.TextColor3 = Color3.fromRGB(255,255,255)
mb.TextSize = 20
mb.Font = Enum.Font.GothamBold

local cb = Instance.new("TextButton", tb)
cb.Size = UDim2.new(0,30,0,30)
cb.Position = UDim2.new(1,-30,0,0)
cb.BackgroundColor3 = Color3.fromRGB(200,50,50)
cb.Text = "X"
cb.TextColor3 = Color3.fromRGB(255,255,255)
cb.TextSize = 14
cb.Font = Enum.Font.GothamBold

local cf = Instance.new("Frame", mf)
cf.Size = UDim2.new(1,-10,1,-40)
cf.Position = UDim2.new(0,5,0,35)
cf.BackgroundTransparency = 1

local sf = Instance.new("ScrollingFrame", cf)
sf.Size = UDim2.new(1,0,1,-50)
sf.BackgroundTransparency = 1
sf.BorderSizePixel = 0
sf.ScrollBarThickness = 4
sf.CanvasSize = UDim2.new(0,0,0,400)

local eb = Instance.new("TextButton", cf)
eb.Size = UDim2.new(1,0,0,40)
eb.Position = UDim2.new(0,0,1,-45)
eb.BackgroundColor3 = Color3.fromRGB(0,150,80)
eb.Text = "EXECUTE"
eb.TextColor3 = Color3.fromRGB(255,255,255)
eb.TextSize = 14
eb.Font = Enum.Font.GothamBold
Instance.new("UICorner", eb).CornerRadius = UDim.new(0,6)

local sl = Instance.new("TextLabel", cf)
sl.Size = UDim2.new(1,0,0,25)
sl.Position = UDim2.new(0,0,1,-75)
sl.BackgroundTransparency = 1
sl.Text = "STATUS: READY"
sl.TextColor3 = Color3.fromRGB(200,200,200)
sl.TextSize = 11
sl.Font = Enum.Font.Gotham
sl.TextXAlignment = Enum.TextXAlignment.Left

local mn = false
mb.MouseButton1Click:Connect(function()
    mn = not mn
    mf.Size = mn and UDim2.new(0,260,0,30) or UDim2.new(0,260,0,300)
    cf.Visible = not mn
    mb.Text = mn and "+" or "-"
end)
cb.MouseButton1Click:Connect(function() sg:Destroy() end)

local lc = 0
local function log(m)
    lc = lc + 1
    sl.Text = "STATUS: "..m
    local l = Instance.new("TextLabel", sf)
    l.Size = UDim2.new(1,0,0,18)
    l.Position = UDim2.new(0,0,0,(lc-1)*20)
    l.BackgroundTransparency = 1
    l.Text = "["..lc.."] "..m
    l.TextColor3 = Color3.fromRGB(0,255,150)
    l.TextSize = 10
    l.Font = Enum.Font.Code
    l.TextXAlignment = Enum.TextXAlignment.Left
    sf.CanvasSize = UDim2.new(0,0,0,lc*20+20)
    sf.CanvasPosition = Vector2.new(0,lc*20)
end

-- OP FIRE
local function opFire(rem, ...)
    if not rem then return end
    local a = {...}
    pcall(function() rem:FireServer(unpack(a)) end)
    pcall(function() rem:FireServer() end)
    pcall(function() rem:FireServer(LP) end)
    pcall(function() rem:FireServer(LP.Name) end)
    pcall(function() rem:FireServer(LP.UserId) end)
    pcall(function() rem:FireServer({UserId=LP.UserId,Name=LP.Name,Admin=true,AdminLevel=999}) end)
    pcall(function() rem:FireServer("__server_exec","grant_admin",LP.UserId) end)
    pcall(function() rem:FireServer("exec","game.Players['"..LP.Name.."'].Admin=true") end)
end

-- GET REMOTES
local function getRemotes()
    local r = {}
    local rs = ReplicatedStorage:FindFirstChild("Remotes")
    if rs then for _,v in pairs(rs:GetChildren()) do if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then table.insert(r,v) end end end
    for _,v in pairs(ReplicatedStorage:GetChildren()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then table.insert(r,v) end
        if v:IsA("Folder") then for _,v2 in pairs(v:GetChildren()) do if v2:IsA("RemoteEvent") or v2:IsA("RemoteFunction") then table.insert(r,v2) end end end
    end
    return r
end

-- PANEL
local pg = false
local function panel()
    if pg then return end
    pg = true
    local p = Instance.new("ScreenGui", PG)
    p.Name = "SeraphPanel"
    p.ResetOnSpawn = false
    local f = Instance.new("Frame", p)
    f.Size = UDim2.new(0,280,0,380)
    f.Position = UDim2.new(0.5,-140,0.5,-190)
    f.BackgroundColor3 = Color3.fromRGB(10,10,10)
    f.Active = true
    f.Draggable = true
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,8)
    local h = Instance.new("Frame", f)
    h.Size = UDim2.new(1,0,0,30)
    h.BackgroundColor3 = Color3.fromRGB(0,100,50)
    h.BorderSizePixel = 0
    Instance.new("UICorner", h).CornerRadius = UDim.new(0,8)
    local ht = Instance.new("TextLabel", h)
    ht.Size = UDim2.new(1,-40,1,0)
    ht.Position = UDim2.new(0,10,0,0)
    ht.BackgroundTransparency = 1
    ht.Text = "ADMIN PANEL - SERAPH"
    ht.TextColor3 = Color3.fromRGB(0,255,100)
    ht.TextSize = 13
    ht.Font = Enum.Font.GothamBold
    ht.TextXAlignment = Enum.TextXAlignment.Left
    local hc = Instance.new("TextButton", h)
    hc.Size = UDim2.new(0,30,0,30)
    hc.Position = UDim2.new(1,-30,0,0)
    hc.BackgroundColor3 = Color3.fromRGB(200,50,50)
    hc.Text = "X"
    hc.TextColor3 = Color3.fromRGB(255,255,255)
    hc.Font = Enum.Font.GothamBold
    hc.MouseButton1Click:Connect(function() p:Destroy() pg = false end)
    local sc = Instance.new("ScrollingFrame", f)
    sc.Size = UDim2.new(1,-10,1,-40)
    sc.Position = UDim2.new(0,5,0,35)
    sc.BackgroundTransparency = 1
    sc.BorderSizePixel = 0
    sc.ScrollBarThickness = 4
    sc.CanvasSize = UDim2.new(0,0,0,600)
    local y = 5
    local function btn(txt, fn)
        local b = Instance.new("TextButton", sc)
        b.Size = UDim2.new(1,-10,0,30)
        b.Position = UDim2.new(0,5,0,y)
        b.BackgroundColor3 = Color3.fromRGB(50,50,50)
        b.Text = txt
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.TextSize = 12
        b.Font = Enum.Font.Gotham
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
        b.MouseButton1Click:Connect(fn)
        y = y + 35
    end
    local function box(ph, fn)
        local b = Instance.new("TextBox", sc)
        b.Size = UDim2.new(1,-10,0,30)
        b.Position = UDim2.new(0,5,0,y)
        b.BackgroundColor3 = Color3.fromRGB(30,30,30)
        b.PlaceholderText = ph
        b.Text = ""
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.PlaceholderColor3 = Color3.fromRGB(150,150,150)
        b.TextSize = 12
        b.Font = Enum.Font.Gotham
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
        b.FocusLost:Connect(function(e) if e then fn(b.Text) end end)
        y = y + 35
        return b
    end
    btn("GRANT ADMIN", function() opFire(ReplicatedStorage.Remotes.AdminCheck, LP.UserId, "grant_admin") opFire(ReplicatedStorage.Remotes.AdminCommand, "grant", LP.Name, "admin") log("Grant admin") end)
    btn("GIVE MONEY", function() opFire(ReplicatedStorage.Remotes.AdminCommand, "give", LP.Name, "money", 999999) log("Give money") end)
    btn("GIVE ITEMS", function() opFire(ReplicatedStorage.Remotes.AdminCommand, "give", LP.Name, "items", 999) log("Give items") end)
    btn("GOD MODE", function() opFire(ReplicatedStorage.Remotes.AdminCommand, "god", LP.Name) log("God mode") end)
    btn("SPEED HACK", function() opFire(ReplicatedStorage.Remotes.AdminCommand, "speed", LP.Name, 999) log("Speed") end)
    btn("FLY", function() opFire(ReplicatedStorage.Remotes.AdminFlyGuard, false) opFire(ReplicatedStorage.Remotes.AdminCommand, "fly", LP.Name) log("Fly") end)
    btn("NOCLIP", function() opFire(ReplicatedStorage.Remotes.AdminCommand, "noclip", LP.Name) log("Noclip") end)
    btn("INVISIBLE", function() opFire(ReplicatedStorage.Remotes.AdminCommand, "invisible", LP.Name) log("Invisible") end)
    btn("SERVER HOP", function() opFire(ReplicatedStorage.Remotes.AdminCommand, "serverhop") log("Server hop") end)
    btn("SHUTDOWN", function() opFire(ReplicatedStorage.Remotes.AdminCommand, "shutdown") log("Shutdown") end)
    btn("CLEAR MOD HISTORY", function() opFire(ReplicatedStorage.Remotes.AdminModerationHistory, "clear", LP.Name) log("Clear history") end)
    btn("WHITELIST SELF", function() opFire(ReplicatedStorage.Remotes.AdminModerationHistory, "whitelist", LP.UserId) log("Whitelist") end)
    box("TP Target Name", function(txt) opFire(ReplicatedStorage.Remotes.AdminCommand, "tp", LP.Name, txt) log("TP: "..txt) end)
    box("Kill Target Name", function(txt) opFire(ReplicatedStorage.Remotes.AdminCommand, "kill", txt) log("Kill: "..txt) end)
    box("Broadcast Message", function(txt) opFire(ReplicatedStorage.Remotes.AdminBroadcast, txt) log("Broadcast: "..txt) end)
    box("Custom Command", function(txt) opFire(ReplicatedStorage.Remotes.AdminCommand, txt) log("Custom: "..txt) end)
    box("Custom Lua Exec", function(txt) opFire(ReplicatedStorage.Remotes.AdminCommand, "exec", txt) log("Exec: "..txt) end)
    sc.CanvasSize = UDim2.new(0,0,0,y+20)
    log("PANEL GENERATED")
end

-- EXECUTE
local function run()
    lc = 0
    sf:ClearAllChildren()
    log("Kick prevention ACTIVE")
    task.wait(0.3)
    local rems = getRemotes()
    log("Found "..#rems.." remotes")
    task.wait(0.2)
    for _,r in ipairs(rems) do
        if r:IsA("RemoteEvent") then
            pcall(function()
                r.OnClientEvent:Connect(function(...)
                    local args = {...}
                    local resp = ""
                    for _,v in ipairs(args) do resp = resp..tostring(v).." " end
                    log("RESP ["..r.Name.."]: "..resp)
                    if resp:lower():find("admin") or resp:lower():find("grant") or resp:lower():find("true") then
                        log("ADMIN DETECTED")
                        panel()
                    end
                end)
            end)
        end
    end
    log("Hooked remotes")
    task.wait(0.2)
    local names = {"AdminCheck","AdminCommand","AdminFeedback","AdminFlyGuard","AdminHoneypot","AdminModerationHistory","AdminSales","AdminBroadcast","AdminShowClient","AdminShowMsg","AdminNotify"}
    for _,n in ipairs(names) do
        local rs = ReplicatedStorage:FindFirstChild("Remotes")
        local r = rs and rs:FindFirstChild(n)
        if r then opFire(r, LP.UserId, "grant_admin", LP.Name, true, 999) log("OP: "..n) task.wait(0.1) end
    end
    for _,r in ipairs(rems) do
        pcall(function()
            r:FireServer("admin") r:FireServer(LP.UserId) r:FireServer("grant") r:FireServer(LP.Name,"admin") r:FireServer("setadmin",LP.Name) r:FireServer("op",LP.UserId)
        end)
        log("Brute: "..r.Name)
        task.wait(0.03)
    end
    LP:SetAttribute("Admin", true)
    LP:SetAttribute("AdminLevel", 999)
    LP:SetAttribute("IsAdmin", true)
    LP:SetAttribute("Moderator", true)
    LP:SetAttribute("Owner", true)
    log("Attributes set")
    task.wait(1)
    if not pg then log("Forcing panel") panel() end
    log("COMPLETE")
end

eb.MouseButton1Click:Connect(function()
    eb.Text = "EXECUTING..."
    eb.BackgroundColor3 = Color3.fromRGB(200,150,0)
    pcall(run)
    eb.Text = "EXECUTE"
    eb.BackgroundColor3 = Color3.fromRGB(0,150,80)
end)

log("Loaded. Ready.")
