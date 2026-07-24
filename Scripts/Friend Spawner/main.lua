-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
ScreenGui.Name = "FriendSpawnerGUI"
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 80, 80)
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

-- Topbar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

local TopBarBottom = Instance.new("Frame")
TopBarBottom.Size = UDim2.new(1, 0, 0, 10)
TopBarBottom.Position = UDim2.new(0, 0, 1, -10)
TopBarBottom.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBarBottom.BorderSizePixel = 0
TopBarBottom.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Friend Spawner v2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Controls
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 2)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 2)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = TopBar

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, 0, 1, -35)
ContentArea.Position = UDim2.new(0, 0, 0, 35)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local FriendList = Instance.new("ScrollingFrame")
FriendList.Size = UDim2.new(1, -20, 0, 280)
FriendList.Position = UDim2.new(0, 10, 0, 10)
FriendList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FriendList.BorderSizePixel = 0
FriendList.ScrollBarThickness = 4
FriendList.Parent = ContentArea

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 5)
ListLayout.Parent = FriendList

local ListPadding = Instance.new("UIPadding")
ListPadding.PaddingTop = UDim.new(0, 5)
ListPadding.PaddingBottom = UDim.new(0, 5)
ListPadding.PaddingLeft = UDim.new(0, 5)
ListPadding.PaddingRight = UDim.new(0, 5)
ListPadding.Parent = FriendList

local SelectedDisplay = Instance.new("TextLabel")
SelectedDisplay.Size = UDim2.new(1, -20, 0, 25)
SelectedDisplay.Position = UDim2.new(0, 10, 0, 300)
SelectedDisplay.BackgroundTransparency = 1
SelectedDisplay.Text = "Selected: None"
SelectedDisplay.TextColor3 = Color3.fromRGB(200, 200, 200)
SelectedDisplay.Font = Enum.Font.Gotham
SelectedDisplay.TextSize = 13
SelectedDisplay.Parent = ContentArea

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, -20, 0, 35)
ToggleBtn.Position = UDim2.new(0, 10, 0, 325)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 255)
ToggleBtn.Text = "Start Spawning"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Parent = ContentArea

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

-- Variables
local selectedFriendId = nil
local spawning = false
local minimized = false

-- Draggable Logic
local dragging, dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Minimize & Close Logic
CloseBtn.MouseButton1Click:Connect(function()
    spawning = false
    ScreenGui:Destroy()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 300, 0, 35) or UDim2.new(0, 300, 0, 400)
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize})
    tween:Play()
end)

-- Load Real Friends
local function loadFriends()
    local success, friendPages = pcall(function()
        return Players:GetFriendsAsync(LocalPlayer.UserId)
    end)
    
    if not success then
        SelectedDisplay.Text = "Failed to load friends!"
        return
    end

    local function populateList()
        for _, friend in ipairs(friendPages:GetCurrentPage()) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            btn.Text = friend.Username
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.Parent = FriendList
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                selectedFriendId = friend.Id
                SelectedDisplay.Text = "Selected: " .. friend.Username
                
                for _, child in ipairs(FriendList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                    end
                end
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 255)
            end)
        end
        FriendList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end

    populateList()
    
    while not friendPages.IsFinished do
        friendPages:AdvanceToNextPageAsync()
        populateList()
    end
end

-- Advanced Player AI Movement
local function makeNPCSmart(npc)
    local humanoid = npc:WaitForChild("Humanoid")
    local root = npc:WaitForChild("HumanoidRootPart")

    -- Add default walking animation so movement looks real
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://180436334" -- Standard Roblox walk anim
    local track = humanoid:LoadAnimation(anim)
    track.Priority = Enum.AnimationPriority.Movement
    
    humanoid.Running:Connect(function(speed)
        if speed > 0.1 then
            if not track.IsPlaying then track:Play() end
        else
            if track.IsPlaying then track:Stop() end
        end
    end)

    -- Continuous Wandering/Walking Logic using Pathfinding
    task.spawn(function()
        while npc and npc.Parent and humanoid.Health > 0 do
            -- Choose a point roughly 30 to 50 studs in front of where the NPC is looking
            local randomOffset = Vector3.new(math.random(-15, 15), 0, math.random(30, 50))
            local targetPos = (root.CFrame * CFrame.new(randomOffset)).Position

            local path = PathfindingService:CreatePath({
                AgentRadius = 2,
                AgentHeight = 5,
                AgentCanJump = true
            })

            local success, _ = pcall(function()
                path:ComputeAsync(root.Position, targetPos)
            end)

            if success and path.Status == Enum.PathStatus.Success then
                local waypoints = path:GetWaypoints()
                for _, waypoint in ipairs(waypoints) do
                    if not npc or not npc.Parent or humanoid.Health <= 0 then break end
                    
                    if waypoint.Action == Enum.PathWaypointAction.Jump then
                        humanoid.Jump = true
                    end
                    
                    humanoid:MoveTo(waypoint.Position)
                    -- Wait until point reached or timeout
                    humanoid.MoveToFinished:Wait()
                end
            else
                -- Fallback simple move
                humanoid:MoveTo(targetPos)
                task.wait(2)
            end
            task.wait(0.2)
        end
    end)
end

-- Spawn Loop (Every 0.1s)
ToggleBtn.MouseButton1Click:Connect(function()
    if not selectedFriendId then
        SelectedDisplay.Text = "Please select a friend first!"
        return
    end
    
    spawning = not spawning
    ToggleBtn.Text = spawning and "Stop Spawning" or "Start Spawning"
    ToggleBtn.BackgroundColor3 = spawning and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(60, 60, 255)
    
    if spawning then
        task.spawn(function()
            while spawning do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local success, npc = pcall(function()
                        return Players:CreateHumanoidModelFromUserId(selectedFriendId)
                    end)
                    
                    if success and npc then
                        npc.Parent = workspace
                        
                        -- Spawn slightly in front with small random variance to avoid stacking
                        local spawnOffset = CFrame.new(math.random(-3, 3), 0, -6)
                        local spawnCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * spawnOffset
                        npc:PivotTo(spawnCFrame)
                        
                        -- Apply AI and walking animation
                        makeNPCSmart(npc)
                    end
                end
                task.wait(0.1) -- Fast spawn speed
            end
        end)
    end
    -- Note: When spawning becomes false, the loop simply stops. 
    -- The spawned NPCs are NOT destroyed and will remain in the game walking around.
end)

-- Initialize
task.spawn(loadFriends)
