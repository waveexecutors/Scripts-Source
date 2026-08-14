-- Mobile Rayfield Player Tools
-- Use only in a Roblox experience you own or are authorized to test.

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Rayfield Gen2 is designed to work well on both phones and computers.
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local Window = Rayfield:CreateWindow({
    name = "Mobile Player Tools",
    subtitle = "Rayfield Gen2",
    theme = "amethyst",
    showName = "Player Tools",
    configuration = {
        autoSave = false,
        autoLoad = false,
        fileName = "MobilePlayerTools"
    }
})

local PlayerTab = Window:CreateTab({
    name = "Players",
    icon = "users"
})

local SelfTab = Window:CreateTab({
    name = "Self",
    icon = "user"
})

local VisualTab = Window:CreateTab({
    name = "Visuals",
    icon = "eye"
})

local SettingsTab = Window:CreateTab({
    name = "Settings",
    icon = "settings"
})

local connections = {}
local playerByLabel = {}
local selectedPlayer = nil
local selectedLabel = nil
local playerDropdown = nil
local viewingPlayer = nil
local infiniteJumpEnabled = false
local desiredWalkSpeed = 16
local desiredJumpPower = 50

local originalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

local NO_PLAYERS = "No other players"

local function notify(title, content)
    Window:Notify({
        title = title,
        content = content,
        duration = 4
    })
end

local function getCharacter(player)
    return player and player.Character or nil
end

local function getHumanoid(player)
    local character = getCharacter(player)
    return character and character:FindFirstChildOfClass("Humanoid") or nil
end

local function getRoot(player)
    local character = getCharacter(player)
    return character and character:FindFirstChild("HumanoidRootPart") or nil
end

local function getPlayerLabel(player)
    if player.DisplayName == player.Name then
        return "@" .. player.Name
    end

    return string.format("%s (@%s)", player.DisplayName, player.Name)
end

local function buildPlayerList()
    local options = {}
    playerByLabel = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local label = getPlayerLabel(player)
            playerByLabel[label] = player
            table.insert(options, label)
        end
    end

    table.sort(options, function(a, b)
        return string.lower(a) < string.lower(b)
    end)

    if #options == 0 then
        table.insert(options, NO_PLAYERS)
    end

    return options
end

local function stopViewing(showMessage)
    viewingPlayer = nil
    Camera = workspace.CurrentCamera
    Camera.CameraType = Enum.CameraType.Custom

    local humanoid = getHumanoid(LocalPlayer)
    if humanoid then
        Camera.CameraSubject = humanoid
    end

    if showMessage then
        notify("Camera restored", "You are viewing your own character again.")
    end
end

local function refreshPlayerList(showMessage)
    local options = buildPlayerList()

    if selectedPlayer and selectedPlayer.Parent == Players then
        selectedLabel = getPlayerLabel(selectedPlayer)
    else
        selectedPlayer = nil
        selectedLabel = nil
    end

    if playerDropdown then
        playerDropdown:Refresh(options)

        if selectedLabel and playerByLabel[selectedLabel] then
            playerDropdown:Set(selectedLabel, true)
        end
    end

    if showMessage then
        notify("Player list refreshed", string.format("Found %d other player(s).", #Players:GetPlayers() - 1))
    end
end

PlayerTab:CreateSection({
    name = "Choose a player"
})

playerDropdown = PlayerTab:CreateDropdown({
    name = "Player list",
    description = "Choose who Teleport and View should use.",
    options = buildPlayerList(),
    placeholder = "Select a player",
    multiSelect = false,
    forgetState = true,
    callback = function(value)
        if value == NO_PLAYERS then
            selectedPlayer = nil
            selectedLabel = nil
            return
        end

        selectedPlayer = playerByLabel[value]
        selectedLabel = selectedPlayer and value or nil

        if selectedPlayer then
            notify("Player selected", getPlayerLabel(selectedPlayer))
        end
    end
})

PlayerTab:CreateButton({
    name = "Refresh player list",
    description = "Updates the list immediately.",
    callback = function()
        refreshPlayerList(true)
    end
})

PlayerTab:CreateSection({
    name = "Selected-player actions"
})

PlayerTab:CreateButton({
    name = "Teleport to selected player",
    description = "Teleports a few studs behind the chosen player.",
    callback = function()
        if not selectedPlayer or selectedPlayer.Parent ~= Players then
            notify("No player selected", "Choose a player from the list first.")
            return
        end

        local localCharacter = getCharacter(LocalPlayer)
        local targetRoot = getRoot(selectedPlayer)

        if not localCharacter or not targetRoot then
            notify("Teleport failed", "That character is not loaded right now.")
            return
        end

        local destination = targetRoot.CFrame * CFrame.new(0, 0, 4)
        localCharacter:PivotTo(destination)
        notify("Teleported", "Moved to " .. getPlayerLabel(selectedPlayer) .. ".")
    end
})

PlayerTab:CreateButton({
    name = "View selected player",
    description = "Makes the camera spectate the chosen player.",
    callback = function()
        if not selectedPlayer or selectedPlayer.Parent ~= Players then
            notify("No player selected", "Choose a player from the list first.")
            return
        end

        local humanoid = getHumanoid(selectedPlayer)
        if not humanoid then
            notify("View failed", "That character is not loaded right now.")
            return
        end

        Camera = workspace.CurrentCamera
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = humanoid
        viewingPlayer = selectedPlayer
        notify("Now viewing", getPlayerLabel(selectedPlayer))
    end
})

PlayerTab:CreateButton({
    name = "Stop viewing",
    description = "Returns the camera to your own character.",
    callback = function()
        stopViewing(true)
    end
})

PlayerTab:CreateButton({
    name = "Copy selected username",
    description = "Copies the exact @username when supported.",
    callback = function()
        if not selectedPlayer or selectedPlayer.Parent ~= Players then
            notify("No player selected", "Choose a player from the list first.")
            return
        end

        if type(setclipboard) == "function" then
            setclipboard(selectedPlayer.Name)
            notify("Username copied", "@" .. selectedPlayer.Name)
        else
            notify("Clipboard unavailable", "This environment does not support setclipboard().")
        end
    end
})

SelfTab:CreateSection({
    name = "Character"
})

SelfTab:CreateButton({
    name = "Respawn and keep position",
    description = "Resets your character, then returns it to the same location.",
    callback = function()
        local oldCharacter = getCharacter(LocalPlayer)
        local oldRoot = getRoot(LocalPlayer)

        if not oldCharacter or not oldRoot then
            notify("Respawn failed", "Your character is not loaded.")
            return
        end

        local savedPivot = oldCharacter:GetPivot()

        task.spawn(function()
            oldCharacter:BreakJoints()

            local newCharacter = LocalPlayer.Character
            if not newCharacter or newCharacter == oldCharacter then
                newCharacter = LocalPlayer.CharacterAdded:Wait()
            end

            local newRoot = newCharacter:WaitForChild("HumanoidRootPart", 10)
            if not newRoot then
                notify("Respawn failed", "The new character did not load in time.")
                return
            end

            task.wait(0.25)
            newCharacter:PivotTo(savedPivot)
            stopViewing(false)
            notify("Respawned", "Returned to your saved location.")
        end)
    end
})

SelfTab:CreateButton({
    name = "Normal respawn",
    description = "Resets without returning to the old location.",
    callback = function()
        local character = getCharacter(LocalPlayer)
        if character then
            character:BreakJoints()
        else
            notify("Respawn failed", "Your character is not loaded.")
        end
    end
})

SelfTab:CreateButton({
    name = "Reset camera",
    description = "Fixes the camera if it is stuck on another character.",
    callback = function()
        stopViewing(true)
    end
})

SelfTab:CreateSection({
    name = "Movement"
})

SelfTab:CreateSlider({
    name = "Walk speed",
    description = "Default Roblox speed is 16.",
    range = { 16, 100 },
    increment = 1,
    value = 16,
    flag = "WalkSpeed",
    callback = function(value)
        desiredWalkSpeed = value
        local humanoid = getHumanoid(LocalPlayer)
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

SelfTab:CreateSlider({
    name = "Jump power",
    description = "Default Roblox jump power is 50.",
    range = { 50, 150 },
    increment = 5,
    value = 50,
    flag = "JumpPower",
    callback = function(value)
        desiredJumpPower = value
        local humanoid = getHumanoid(LocalPlayer)
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = value
        end
    end
})

SelfTab:CreateToggle({
    name = "Infinite jump",
    description = "Allows another jump while you are in the air.",
    value = false,
    flag = "InfiniteJump",
    callback = function(value)
        infiniteJumpEnabled = value
    end
})

VisualTab:CreateSection({
    name = "Lighting"
})

VisualTab:CreateToggle({
    name = "Fullbright",
    description = "Brightens dark areas locally and can be turned off safely.",
    value = false,
    flag = "Fullbright",
    callback = function(value)
        if value then
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(178, 178, 178)
            Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
        else
            for property, originalValue in pairs(originalLighting) do
                Lighting[property] = originalValue
            end
        end
    end
})

SettingsTab:CreateSection({
    name = "Session"
})

SettingsTab:CreateButton({
    name = "Rejoin this server",
    description = "Reconnects to the same Roblox server.",
    callback = function()
        notify("Rejoining", "Connecting to the same server...")
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

SettingsTab:CreateButton({
    name = "Unload UI",
    description = "Restores the camera and lighting, then closes the script.",
    callback = function()
        stopViewing(false)

        for property, originalValue in pairs(originalLighting) do
            Lighting[property] = originalValue
        end

        for _, connection in ipairs(connections) do
            connection:Disconnect()
        end

        Window:Unload()
    end
})

table.insert(connections, Players.PlayerAdded:Connect(function()
    task.defer(refreshPlayerList, false)
end))

table.insert(connections, Players.PlayerRemoving:Connect(function(player)
    if player == viewingPlayer then
        stopViewing(false)
        notify("View ended", "That player left the server.")
    end

    if player == selectedPlayer then
        selectedPlayer = nil
        selectedLabel = nil
    end

    task.defer(refreshPlayerList, false)
end))

table.insert(connections, LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if not humanoid then
        return
    end

    humanoid.WalkSpeed = desiredWalkSpeed
    humanoid.UseJumpPower = true
    humanoid.JumpPower = desiredJumpPower

    if not viewingPlayer then
        Camera = workspace.CurrentCamera
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = humanoid
    end
end))

table.insert(connections, UserInputService.JumpRequest:Connect(function()
    if not infiniteJumpEnabled then
        return
    end

    local humanoid = getHumanoid(LocalPlayer)
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))

notify("Mobile Player Tools loaded", "Choose a player in the Players tab.")
