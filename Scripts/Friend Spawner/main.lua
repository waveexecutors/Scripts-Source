-- ==========================================================
-- Roblox Interactive Friend Spawner GUI
-- Place this in a LocalScript (e.g., inside StarterPlayerScripts)
-- ==========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- State Variables
local selectedFriendId = nil
local selectedFriendName = nil
local isSpawning = false
local spawnedNPCs = {}
local spawnInterval = 1.5 -- Seconds between spawns

-- ==========================================================
-- 1. GUI CREATION
-- ==========================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FriendSpawnerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Container Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0.5, -160, 0.4, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Title Bar (Header)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -90, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Friend Spawner"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.Garamond
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 14
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -55)
contentFrame.Position = UDim2.new(0, 10, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Selected Friend Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Select a friend below..."
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.SourceSansItalic
statusLabel.Parent = contentFrame

-- Friends Scroll List
local scrollList = Instance.new("ScrollingFrame")
scrollList.Size = UDim2.new(1, 0, 0, 240)
scrollList.Position = UDim2.new(0, 0, 0, 30)
scrollList.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
scrollList.BorderSizePixel = 0
scrollList.ScrollBarThickness = 6
scrollList.Parent = contentFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scrollList

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = scrollList

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 0, 45)
toggleBtn.Position = UDim2.new(0, 0, 1, -45)
toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 120, 210)
toggleBtn.Text = "START SPAWNING"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16
toggleBtn.Parent = contentFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn


-- ==========================================================
-- 2. DRAGGABLE & MINIMIZE LOGIC
-- ==========================================================

local dragging, dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		mainFrame:TweenSize(UDim2.new(0, 320, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		contentFrame.Visible = false
	else
		mainFrame:TweenSize(UDim2.new(0, 320, 0, 420), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		task.wait(0.15)
		contentFrame.Visible = true
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	isSpawning = false
	clearNPCs()
	screenGui:Destroy()
end)


-- ==========================================================
-- 3. LOAD REAL FRIENDS LIST
-- ==========================================================

local function loadFriends()
	task.spawn(function()
		statusLabel.Text = "Fetching real friends..."
		local success, friendPages = pcall(function()
			return Players:GetFriendsAsync(localPlayer.UserId)
		end)

		if not success or not friendPages then
			statusLabel.Text = "Failed to load friends."
			return
		end

		local count = 0
		while true do
			for _, friend in ipairs(friendPages:GetCurrentPage()) do
				count = count + 1
				
				local itemBtn = Instance.new("TextButton")
				itemBtn.Size = UDim2.new(1, -8, 0, 35)
				itemBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
				itemBtn.Text = "   " .. friend.Username .. " (" .. (friend.IsOnline and "Online" or "Offline") .. ")"
				itemBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
				itemBtn.Font = Enum.Font.SourceSans
				itemBtn.TextSize = 14
				itemBtn.TextXAlignment = Enum.TextXAlignment.Left
				itemBtn.Parent = scrollList

				local itemCorner = Instance.new("UICorner")
				itemCorner.CornerRadius = UDim.new(0, 6)
				itemCorner.Parent = itemBtn

				itemBtn.MouseButton1Click:Connect(function()
					selectedFriendId = friend.Id
					selectedFriendName = friend.Username
					statusLabel.Text = "Selected: " .. friend.Username
					statusLabel.TextColor3 = Color3.fromRGB(100, 220, 120)
				end)
			end

			if friendPages.IsFinished then
				break
			end
			friendPages:AdvanceToNextPageAsync()
		end

		scrollList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
		if count == 0 then
			statusLabel.Text = "No friends found."
		else
			statusLabel.Text = "Select a friend to spawn"
			statusLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
		end
	end)
end

loadFriends()


-- ==========================================================
-- 4. SPAWN & WALK AI LOGIC
-- ==========================================================

function clearNPCs()
	for _, npc in ipairs(spawnedNPCs) do
		if npc and npc:Parent() then
			npc:Destroy()
		end
	end
	table.clear(spawnedNPCs)
end

local function spawnFriendNPC()
	if not selectedFriendId then return end
	local character = localPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end

	-- Generate Humanoid Model from Friend UserId
	local npcModel
	local success, err = pcall(function()
		npcModel = Players:CreateHumanoidModelFromUserId(selectedFriendId)
	end)

	if not success or not npcModel then return end

	local root = character.HumanoidRootPart
	local spawnCFrame = root.CFrame * CFrame.new(0, 0, -6) -- Spawn directly in front

	npcModel:SetPrimaryPartCFrame(spawnCFrame)
	npcModel.Name = selectedFriendName
	npcModel.Parent = workspace

	table.insert(spawnedNPCs, npcModel)

	-- Walking AI Loop
	task.spawn(function()
		local npcHumanoid = npcModel:FindFirstChildOfClass("Humanoid")
		local npcRoot = npcModel:FindFirstChild("HumanoidRootPart")

		while isSpawning and npcModel and npcModel:Parent() and npcHumanoid and npcRoot do
			-- Command NPC to continuously walk forward relative to its orientation
			local forwardPoint = npcRoot.Position + (npcRoot.CFrame.LookVector * 30)
			npcHumanoid:MoveTo(forwardPoint)
			task.wait(2)
		end
	end)
end

toggleBtn.MouseButton1Click:Connect(function()
	if not selectedFriendId then
		statusLabel.Text = "Error: Pick a friend first!"
		statusLabel.TextColor3 = Color3.fromRGB(240, 80, 80)
		return
	end

	isSpawning = not isSpawning

	if isSpawning then
		toggleBtn.Text = "STOP & CLEAR SPAWNS"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(210, 50, 50)
		
		task.spawn(function()
			while isSpawning do
				spawnFriendNPC()
				task.wait(spawnInterval)
			end
		end)
	else
		toggleBtn.Text = "START SPAWNING"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 120, 210)
		clearNPCs()
	end
end)
