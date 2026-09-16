-- Roblox Mobile Stalker GUI v6.0
-- Delta Executor compatible (uses Delta's request/http globals)
-- Dynamic game discovery, private info attempts, no hardcoded PlaceIds

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StalkerGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 380)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "STALKER v6.0 DELTA"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
titleLabel.Font = Enum.Font.Code
titleLabel.TextSize = 12
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 25, 0, 22)
minBtn.Position = UDim2.new(1, -55, 0, 4)
minBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
minBtn.Text = "_"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
minBtn.Font = Enum.Font.Code
minBtn.TextSize = 14
minBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 22)
closeBtn.Position = UDim2.new(1, -28, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Font = Enum.Font.Code
closeBtn.TextSize = 14
closeBtn.Parent = titleBar

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -30)
content.Position = UDim2.new(0, 0, 0, 30)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -16, 0, 28)
inputBox.Position = UDim2.new(0, 8, 0, 4)
inputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
inputBox.TextColor3 = Color3.fromRGB(0, 255, 0)
inputBox.PlaceholderText = "Username or UserID..."
inputBox.Font = Enum.Font.Code
inputBox.TextSize = 11
inputBox.Text = ""
inputBox.Parent = content

local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(1, -16, 0, 28)
searchBtn.Position = UDim2.new(0, 8, 0, 36)
searchBtn.BackgroundColor3 = Color3.fromRGB(0, 90, 0)
searchBtn.Text = "FIND + TRACK"
searchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBtn.Font = Enum.Font.Code
searchBtn.TextSize = 12
searchBtn.Parent = content

local outputFrame = Instance.new("ScrollingFrame")
outputFrame.Size = UDim2.new(1, -16, 1, -150)
outputFrame.Position = UDim2.new(0, 8, 0, 70)
outputFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
outputFrame.BorderSizePixel = 0
outputFrame.ScrollBarThickness = 3
outputFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
outputFrame.Parent = content

local outputLabel = Instance.new("TextLabel")
outputLabel.Size = UDim2.new(1, -8, 0, 0)
outputLabel.Position = UDim2.new(0, 4, 0, 0)
outputLabel.BackgroundTransparency = 1
outputLabel.Text = "Awaiting input..."
outputLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
outputLabel.Font = Enum.Font.Code
outputLabel.TextSize = 10
outputLabel.TextWrapped = true
outputLabel.TextXAlignment = Enum.TextXAlignment.Left
outputLabel.TextYAlignment = Enum.TextYAlignment.Top
outputLabel.Parent = outputFrame

local statusBtn = Instance.new("TextButton")
statusBtn.Size = UDim2.new(0.5, -12, 0, 28)
statusBtn.Position = UDim2.new(0, 8, 1, -55)
statusBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 110)
statusBtn.Text = "REFRESH"
statusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
statusBtn.Font = Enum.Font.Code
statusBtn.TextSize = 11
statusBtn.Parent = content

local joinBtn = Instance.new("TextButton")
joinBtn.Size = UDim2.new(0.5, -12, 0, 28)
joinBtn.Position = UDim2.new(0.5, 4, 1, -55)
joinBtn.BackgroundColor3 = Color3.fromRGB(110, 0, 0)
joinBtn.Text = "JOIN"
joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
joinBtn.Font = Enum.Font.Code
joinBtn.TextSize = 11
joinBtn.Parent = content

local emailBtn = Instance.new("TextButton")
emailBtn.Size = UDim2.new(1, -16, 0, 28)
emailBtn.Position = UDim2.new(0, 8, 1, -25)
emailBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
emailBtn.Text = "PRIVATE INFO"
emailBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
emailBtn.Font = Enum.Font.Code
emailBtn.TextSize = 11
emailBtn.Parent = content

local currentTargetId = nil
local currentTargetName = nil
local currentPlaceId = nil
local currentJobId = nil
local minimized = false
local originalSize = mainFrame.Size

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 280, 0, 30)
        minBtn.Text = "+"
    else
        mainFrame.Size = originalSize
        minBtn.Text = "_"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ============================================================
-- DELTA-COMPATIBLE REQUEST WRAPPER
-- Delta provides: request(), http_request(), syn.request(), fluxus.request()
-- Falls back to HttpService if none available.
-- ============================================================

local function doRequest(url, method, body, headers)
    method = method or "GET"
    headers = headers or {}
    headers["Content-Type"] = headers["Content-Type"] or "application/json"
    
    local reqFunc = nil
    if syn and syn.request then reqFunc = syn.request
    elseif http_request then reqFunc = http_request
    elseif request then reqFunc = request
    elseif fluxus and fluxus.request then reqFunc = fluxus.request
    elseif getgenv().request then reqFunc = getgenv().request
    end
    
    if reqFunc then
        local ok, res = pcall(function()
            return reqFunc({
                Url = url,
                Method = method,
                Body = body,
                Headers = headers
            })
        end)
        if ok and res then
            return res.StatusCode == 200, res.Body
        end
    end
    
    -- Fallback to HttpService
    local ok, res = pcall(function()
        if method == "GET" then
            return HttpService:GetAsync(url, true, headers)
        else
            return HttpService:PostAsync(url, body or "", Enum.HttpContentType.ApplicationJson)
        end
    end)
    return ok, res
end

local function parseJSON(str)
    local ok, data = pcall(function()
        return HttpService:JSONDecode(str)
    end)
    return ok and data or nil
end

-- ============================================================
-- DYNAMIC GAME DISCOVERY
-- ============================================================

local function checkSameServer(userId)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.UserId == userId then
            return true, game.PlaceId, game.JobId
        end
    end
    return false, nil, nil
end

local function getPresence(userId)
    local body = HttpService:JSONEncode({userIds = {userId}})
    local ok, res = doRequest("https://presence.roblox.com/v1/presence/users", "POST", body)
    if ok and res then
        local data = parseJSON(res)
        if data and data.userPresences and data.userPresences[1] then
            local p = data.userPresences[1]
            return p.userPresenceType, p.placeId, p.gameId, p.lastOnline, p.universeId
        end
    end
    return nil, nil, nil, nil, nil
end

local function getUniverseFromPlace(placeId)
    local ok, res = doRequest("https://games.roblox.com/v1/games/multiget-place-details?placeIds=" .. tostring(placeId), "GET")
    if ok and res then
        local data = parseJSON(res)
        if data and data[1] then
            return data[1].universeId, data[1].name
        end
    end
    return nil, nil
end

local function findTargetServer(userId, universeId)
    local cursor = ""
    for i = 1, 10 do
        local url = "https://games.roblox.com/v1/games/" .. tostring(universeId) .. "/servers/Public?limit=100&cursor=" .. cursor
        local ok, res = doRequest(url, "GET")
        if not ok then break end
        local data = parseJSON(res)
        if not data then break end
        for _, server in ipairs(data.data or {}) do
            for _, p in ipairs(server.players or {}) do
                if p.id == userId then
                    return server.id
                end
            end
        end
        cursor = data.nextPageCursor or ""
        if cursor == "" then break end
    end
    return nil
end

-- ============================================================
-- PRIVATE INFO (Delta cookie getters)
-- ============================================================

local function getCookie()
    local ok, cookie = pcall(function()
        if getgenv().cookie then return getgenv().cookie end
        if getgenv().Cookie then return getgenv().Cookie end
        if syn and syn.getCookie then return syn.getCookie() end
        if fluxus and fluxus.getCookie then return fluxus.getCookie() end
        if Delta and Delta.getCookie then return Delta.getCookie() end
        if getgenv().Delta and getgenv().Delta.getCookie then return getgenv().Delta.getCookie() end
        return nil
    end)
    return ok and cookie or nil
end

local function authenticatedGet(url)
    local cookie = getCookie()
    if not cookie then return nil end
    local ok, res = doRequest(url, "GET", nil, {["Cookie"] = ".ROBLOSECURITY=" .. cookie})
    if ok and res then
        return parseJSON(res)
    end
    return nil
end

-- ============================================================
-- BUTTON LOGIC
-- ============================================================

searchBtn.MouseButton1Click:Connect(function()
    local input = inputBox.Text
    if input == "" then
        outputLabel.Text = "ERROR: Enter username or ID."
        return
    end
    
    outputLabel.Text = "Resolving user..."
    outputFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local userId, username
    if tonumber(input) then
        userId = tonumber(input)
        local ok, name = pcall(function()
            return Players:GetNameFromUserIdAsync(userId)
        end)
        username = ok and name or "Unknown"
    else
        local ok, id = pcall(function()
            return Players:GetUserIdFromNameAsync(input)
        end)
        if ok then
            userId = id
            username = input
        end
    end
    
    if not userId then
        outputLabel.Text = "ERROR: User not found."
        return
    end
    
    currentTargetId = userId
    currentTargetName = username
    
    outputLabel.Text = "UserID: " .. tostring(userId) .. "\nName: " .. tostring(username) .. "\n"
    
    local same, placeId, jobId = checkSameServer(userId)
    if same then
        currentPlaceId = placeId
        currentJobId = jobId
        outputLabel.Text = outputLabel.Text .. "\n[SAME SERVER]\nPlaceID: " .. tostring(placeId) .. "\nJobID: " .. tostring(jobId) .. "\n"
        outputLabel.Size = UDim2.new(1, -8, 0, outputLabel.TextBounds.Y + 20)
        outputFrame.CanvasSize = UDim2.new(0, 0, 0, outputLabel.TextBounds.Y + 30)
        return
    end
    
    outputLabel.Text = outputLabel.Text .. "\nFetching presence...\n"
    local presType, presPlaceId, presGameId, lastOnline, universeId = getPresence(userId)
    
    if presType == 2 and presPlaceId then
        currentPlaceId = presPlaceId
        local uid, gname = getUniverseFromPlace(presPlaceId)
        if uid then universeId = uid end
        outputLabel.Text = outputLabel.Text .. "Status: In Game\n"
        outputLabel.Text = outputLabel.Text .. "PlaceID: " .. tostring(presPlaceId) .. "\n"
        outputLabel.Text = outputLabel.Text .. "Game: " .. tostring(gname or "Unknown") .. "\n"
        outputLabel.Text = outputLabel.Text .. "UniverseID: " .. tostring(universeId or "N/A") .. "\n"
        
        if universeId then
            outputLabel.Text = outputLabel.Text .. "\nSearching servers...\n"
            local serverId = findTargetServer(userId, universeId)
            if serverId then
                currentJobId = serverId
                outputLabel.Text = outputLabel.Text .. "ServerID: " .. tostring(serverId) .. "\n"
            else
                outputLabel.Text = outputLabel.Text .. "Server: Hidden/Private\n"
            end
        end
    elseif presType == 1 then
        outputLabel.Text = outputLabel.Text .. "Status: Online (Website)\n"
    elseif presType == 3 then
        outputLabel.Text = outputLabel.Text .. "Status: In Studio\n"
    else
        outputLabel.Text = outputLabel.Text .. "Status: Offline\n"
        outputLabel.Text = outputLabel.Text .. "Last Online: " .. tostring(lastOnline or "N/A") .. "\n"
    end
    
    outputLabel.Size = UDim2.new(1, -8, 0, outputLabel.TextBounds.Y + 20)
    outputFrame.CanvasSize = UDim2.new(0, 0, 0, outputLabel.TextBounds.Y + 30)
end)

statusBtn.MouseButton1Click:Connect(function()
    if not currentTargetId then
        outputLabel.Text = "ERROR: Track a user first."
        return
    end
    
    outputLabel.Text = outputLabel.Text .. "\n=== REFRESH ===\n"
    
    local same, placeId, jobId = checkSameServer(currentTargetId)
    if same then
        outputLabel.Text = outputLabel.Text .. "[SAME SERVER]\n"
        return
    end
    
    local presType, presPlaceId, presGameId, lastOnline, universeId = getPresence(currentTargetId)
    
    if presType == 2 and presPlaceId then
        currentPlaceId = presPlaceId
        local uid, gname = getUniverseFromPlace(presPlaceId)
        if uid then universeId = uid end
        outputLabel.Text = outputLabel.Text .. "In Game: " .. tostring(gname or "Unknown") .. "\n"
        outputLabel.Text = outputLabel.Text .. "PlaceID: " .. tostring(presPlaceId) .. "\n"
        if universeId then
            local serverId = findTargetServer(currentTargetId, universeId)
            if serverId then
                currentJobId = serverId
                outputLabel.Text = outputLabel.Text .. "ServerID: " .. tostring(serverId) .. "\n"
            end
        end
    else
        outputLabel.Text = outputLabel.Text .. "Not in game.\n"
    end
    
    outputLabel.Size = UDim2.new(1, -8, 0, outputLabel.TextBounds.Y + 20)
    outputFrame.CanvasSize = UDim2.new(0, 0, 0, outputLabel.TextBounds.Y + 30)
end)

joinBtn.MouseButton1Click:Connect(function()
    if not currentTargetId then
        outputLabel.Text = "ERROR: Track a user first."
        return
    end
    
    local same, placeId, jobId = checkSameServer(currentTargetId)
    if same then
        outputLabel.Text = outputLabel.Text .. "\nAlready in same server.\n"
        return
    end
    
    if currentPlaceId and currentJobId then
        outputLabel.Text = outputLabel.Text .. "\nJoining stored server...\n"
        TeleportService:TeleportToPlaceInstance(currentPlaceId, currentJobId, player)
        return
    end
    
    local presType, presPlaceId, presGameId, lastOnline, universeId = getPresence(currentTargetId)
    if presType == 2 and presPlaceId then
        local uid = getUniverseFromPlace(presPlaceId)
        if uid then universeId = uid end
        if universeId then
            local serverId = findTargetServer(currentTargetId, universeId)
            if serverId then
                outputLabel.Text = outputLabel.Text .. "\nJoining...\n"
                TeleportService:TeleportToPlaceInstance(presPlaceId, serverId, player)
                return
            end
        end
    end
    
    outputLabel.Text = outputLabel.Text .. "\nJOIN FAILED: No public server found.\n"
end)

emailBtn.MouseButton1Click:Connect(function()
    if not currentTargetId then
        outputLabel.Text = "ERROR: Track a user first."
        return
    end
    
    outputLabel.Text = outputLabel.Text .. "\n=== PRIVATE INFO ===\n"
    
    local cookie = getCookie()
    if cookie then
        outputLabel.Text = outputLabel.Text .. "Cookie: FOUND\n"
        local email = authenticatedGet("https://accountsettings.roblox.com/v1/email")
        local phone = authenticatedGet("https://accountinformation.roblox.com/v1/phone")
        local birth = authenticatedGet("https://accountinformation.roblox.com/v1/birthdate")
        local gender = authenticatedGet("https://accountinformation.roblox.com/v1/gender")
        local auth = authenticatedGet("https://users.roblox.com/v1/users/authenticated")
        local promo = authenticatedGet("https://accountinformation.roblox.com/v1/promotion-channels")
        
        if email then outputLabel.Text = outputLabel.Text .. "Email: " .. HttpService:JSONEncode(email) .. "\n" end
        if phone then outputLabel.Text = outputLabel.Text .. "Phone: " .. HttpService:JSONEncode(phone) .. "\n" end
        if birth then outputLabel.Text = outputLabel.Text .. "Birthdate: " .. HttpService:JSONEncode(birth) .. "\n" end
        if gender then outputLabel.Text = outputLabel.Text .. "Gender: " .. HttpService:JSONEncode(gender) .. "\n" end
        if auth then outputLabel.Text = outputLabel.Text .. "Auth: " .. HttpService:JSONEncode(auth) .. "\n" end
        if promo then outputLabel.Text = outputLabel.Text .. "Promo: " .. HttpService:JSONEncode(promo) .. "\n" end
    else
        outputLabel.Text = outputLabel.Text .. "Cookie: NOT FOUND\n"
        outputLabel.Text = outputLabel.Text .. "Delta does not expose cookie by default.\n"
        outputLabel.Text = outputLabel.Text .. "Set getgenv().cookie manually to use private APIs.\n"
    end
    
    outputLabel.Size = UDim2.new(1, -8, 0, outputLabel.TextBounds.Y + 20)
    outputFrame.CanvasSize = UDim2.new(0, 0, 0, outputLabel.TextBounds.Y + 30)
end)
