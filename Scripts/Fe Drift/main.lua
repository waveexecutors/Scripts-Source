-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- State Variables
local isDrifting = false
local currentSpeed = 50
local sitTrack = nil
local bodyVelocity = nil
local bodyGyro = nil
local renderConnection = nil

--------------------------------------------------------------------------------
-- 1. Animation Retriever
--------------------------------------------------------------------------------
local function getSitAnimationId()
	local animateScript = Character:FindFirstChild("Animate")
	if animateScript and animateScript:FindFirstChild("sit") then
		local sitAnim = animateScript.sit:FindFirstChildOfClass("Animation")
		if sitAnim and sitAnim.AnimationId ~= "" then
			return sitAnim.AnimationId
		end
	end
	-- Default R6 Sit Animation Fallback
	return "rbxassetid://180436334"
end

--------------------------------------------------------------------------------
-- 2. GUI Creation (Mobile & PC Friendly)
--------------------------------------------------------------------------------
local parentTarget = LocalPlayer:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CarDriftGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = parentTarget

-- Main Container Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 180)
mainFrame.Position = UDim2.new(0.5, -120, 0.4, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Title Bar (Drag Handle)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🚗 Car Drift R6"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -60, 0, 3.5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -31, 0, 3.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Content Container
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -35)
content.Position = UDim2.new(0, 0, 0, 35)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Drift Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
toggleBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
toggleBtn.Text = "Drift Mode: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
toggleBtn.TextSize = 14
toggleBtn.Font = Enum.Font.GothamSemibold
toggleBtn.Parent = content

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

-- Speed Input Box
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.9, 0, 0, 40)
speedBox.Position = UDim2.new(0.05, 0, 0.5, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
speedBox.Text = "50"
speedBox.PlaceholderText = "Enter Speed (e.g. 50)"
speedBox.TextColor3 = Color3.fromRGB(0, 220, 255)
speedBox.TextSize = 14
speedBox.Font = Enum.Font.Gotham
speedBox.Parent = content

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedBox

-- Restore/Open Button (when minimized)
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 45, 0, 45)
openBtn.Position = UDim2.new(0.02, 0, 0.5, -22)
openBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
openBtn.Text = "🚗"
openBtn.TextSize = 22
openBtn.Visible = false
openBtn.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openBtn

--------------------------------------------------------------------------------
-- 3. Universal Dragging Support (Touch + Mouse)
--------------------------------------------------------------------------------
local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

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
		updateDrag(input)
	end
end)

--------------------------------------------------------------------------------
-- 4. Drift Mechanics Logic
--------------------------------------------------------------------------------
local function stopDrift()
	isDrifting = false
	toggleBtn.Text = "Drift Mode: OFF"
	toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	toggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)

	if renderConnection then renderConnection:Disconnect() renderConnection = nil end
	if sitTrack then sitTrack:Stop() sitTrack = nil end
	if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
	if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end

	if Humanoid then
		Humanoid.PlatformStand = false
		Humanoid.WalkSpeed = 16
	end
end

local function startDrift()
	isDrifting = true
	toggleBtn.Text = "Drift Mode: ON"
	toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
	toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

	-- Load Sit Animation
	local animId = getSitAnimationId()
	local anim = Instance.new("Animation")
	anim.AnimationId = animId
	
	local animator = Humanoid:FindFirstChildOfClass("Animator") or Humanoid
	sitTrack = animator:LoadAnimation(anim)
	sitTrack.Priority = Enum.AnimationPriority.Action4
	sitTrack:Play()

	local rootPart = Character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	-- Drifting Velocity Controls
	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e5, 0, 1e5)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = rootPart

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(0, 1e5, 0)
	bodyGyro.CFrame = rootPart.CFrame
	bodyGyro.P = 3000
	bodyGyro.Parent = rootPart

	local currentVel = Vector3.zero

	renderConnection = RunService.RenderStepped:Connect(function(dt)
		if not Character or not rootPart or not Humanoid then return end
		
		local moveDir = Humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			-- Steering rotation update
			bodyGyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + moveDir)
			
			-- Inertia calculation (smooth drift slide)
			local targetVel = moveDir * currentSpeed
			currentVel = currentVel:Lerp(targetVel, dt * 3.5) -- Lower factor = higher drift slide
		else
			currentVel = currentVel:Lerp(Vector3.zero, dt * 2)
		end
		
		bodyVelocity.Velocity = currentVel
	end)
end

--------------------------------------------------------------------------------
-- 5. GUI Interactivity
--------------------------------------------------------------------------------
toggleBtn.MouseButton1Click:Connect(function()
	if isDrifting then
		stopDrift()
	else
		startDrift()
	end
end)

speedBox.FocusLost:Connect(function()
	local num = tonumber(speedBox.Text)
	if num then
		currentSpeed = math.clamp(num, 1, 500)
		speedBox.Text = tostring(currentSpeed)
	else
		speedBox.Text = tostring(currentSpeed)
	end
end)

minimizeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	openBtn.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
	stopDrift()
	screenGui:Destroy()
end)

-- Reset state on character respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
	Character = newChar
	Humanoid = Character:WaitForChild("Humanoid")
	stopDrift()
end)
