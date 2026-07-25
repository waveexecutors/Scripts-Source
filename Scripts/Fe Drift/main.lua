-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- State Variables
local isVehicleActive = false
local currentSpeed = 80 -- Increased default speed for stronger drift
local activeMode = "Car" -- "Car", "Moto", "Scooter"
local showModels = true

local sitTrack = nil
local bodyVelocity = nil
local bodyGyro = nil
local renderConnection = nil
local currentVehicleModel = nil

--------------------------------------------------------------------------------
-- 1. Animation & Stance Handling
--------------------------------------------------------------------------------
local function getSitAnimationId()
	local animateScript = Character:FindFirstChild("Animate")
	if animateScript and animateScript:FindFirstChild("sit") then
		local sitAnim = animateScript.sit:FindFirstChildOfClass("Animation")
		if sitAnim and sitAnim.AnimationId ~= "" then
			return sitAnim.AnimationId
		end
	end
	return "rbxassetid://180436334"
end

local function applyPose()
	if sitTrack then sitTrack:Stop() sitTrack = nil end

	local rootPart = Character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	if activeMode == "Car" then
		-- Classic R6 Sit
		local anim = Instance.new("Animation")
		anim.AnimationId = getSitAnimationId()
		local animator = Humanoid:FindFirstChildOfClass("Animator") or Humanoid
		sitTrack = animator:LoadAnimation(anim)
		sitTrack.Priority = Enum.AnimationPriority.Action4
		sitTrack:Play()

	elseif activeMode == "Moto" then
		-- Motorcycle Lean/Crouch Stance
		local anim = Instance.new("Animation")
		anim.AnimationId = getSitAnimationId()
		local animator = Humanoid:FindFirstChildOfClass("Animator") or Humanoid
		sitTrack = animator:LoadAnimation(anim)
		sitTrack.Priority = Enum.AnimationPriority.Action4
		sitTrack:Play(0.1, 1, 1.3) -- Faster playback for aggressive tilt

	elseif activeMode == "Scooter" then
		-- Electric Scooter Standing Pose (Arms extended forward)
		local torso = Character:FindFirstChild("Torso")
		if torso then
			local shoulderR = torso:FindFirstChild("Right Shoulder")
			local shoulderL = torso:FindFirstChild("Left Shoulder")
			if shoulderR and shoulderL then
				shoulderR.CurrentAngle = math.rad(90)
				shoulderL.CurrentAngle = math.rad(90)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- 2. Procedural 3D Model Generator
--------------------------------------------------------------------------------
local function clearModel()
	if currentVehicleModel then
		currentVehicleModel:Destroy()
		currentVehicleModel = nil
	end
end

local function spawnVehicleModel()
	clearModel()
	if not showModels or not isVehicleActive then return end

	local rootPart = Character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	local model = Instance.new("Model")
	model.Name = "VehicleModel"

	if activeMode == "Car" then
		-- Kart / Car Chassis
		local body = Instance.new("Part")
		body.Size = Vector3.new(4.5, 1, 6)
		body.Color = Color3.fromRGB(30, 30, 35)
		body.Material = Enum.Material.SmoothPlastic
		body.CanCollide = false
		body.Parent = model

		local weld = Instance.new("Weld")
		weld.Part0 = rootPart
		weld.Part1 = body
		weld.C0 = CFrame.new(0, -1.8, 0)
		weld.Parent = body

	elseif activeMode == "Moto" then
		-- Sport Bike Frame
		local frame = Instance.new("Part")
		frame.Size = Vector3.new(1.2, 2, 5)
		frame.Color = Color3.fromRGB(220, 40, 40)
		frame.Material = Enum.Material.SmoothPlastic
		frame.CanCollide = false
		frame.Parent = model

		local weld = Instance.new("Weld")
		weld.Part0 = rootPart
		weld.Part1 = frame
		weld.C0 = CFrame.new(0, -1.2, 0)
		weld.Parent = frame

	elseif activeMode == "Scooter" then
		-- High-Detail Electric Scooter (Patinete Elétrico)
		-- Deck
		local deck = Instance.new("Part")
		deck.Size = Vector3.new(1.4, 0.3, 4)
		deck.Color = Color3.fromRGB(20, 20, 22)
		deck.Material = Enum.Material.DiamondPlate
		deck.CanCollide = false
		deck.Parent = model

		local deckWeld = Instance.new("Weld")
		deckWeld.Part0 = rootPart
		deckWeld.Part1 = deck
		deckWeld.C0 = CFrame.new(0, -2.7, 0)
		deckWeld.Parent = deck

		-- Steering Stem
		local stem = Instance.new("Part")
		stem.Size = Vector3.new(0.2, 3.8, 0.2)
		stem.Color = Color3.fromRGB(0, 200, 255)
		stem.Material = Enum.Material.Neon
		stem.CanCollide = false
		stem.Parent = model

		local stemWeld = Instance.new("Weld")
		stemWeld.Part0 = deck
		stemWeld.Part1 = stem
		stemWeld.C0 = CFrame.new(0, 1.8, -1.8) * CFrame.Angles(math.rad(-10), 0, 0)
		stemWeld.Parent = stem

		-- Handlebars
		local bar = Instance.new("Part")
		bar.Size = Vector3.new(2.2, 0.2, 0.2)
		bar.Color = Color3.fromRGB(40, 40, 45)
		bar.Material = Enum.Material.SmoothPlastic
		bar.CanCollide = false
		bar.Parent = model

		local barWeld = Instance.new("Weld")
		barWeld.Part0 = stem
		barWeld.Part1 = bar
		barWeld.C0 = CFrame.new(0, 1.8, 0)
		barWeld.Parent = bar

		-- Headlight
		local light = Instance.new("Part")
		light.Size = Vector3.new(0.4, 0.3, 0.3)
		light.Color = Color3.fromRGB(255, 255, 255)
		light.Material = Enum.Material.Neon
		light.CanCollide = false
		light.Parent = model

		local lightWeld = Instance.new("Weld")
		lightWeld.Part0 = stem
		lightWeld.Part1 = light
		lightWeld.C0 = CFrame.new(0, 1.5, -0.2)
		lightWeld.Parent = light
	end

	model.Parent = Character
	currentVehicleModel = model
end

--------------------------------------------------------------------------------
-- 3. GUI Construction
--------------------------------------------------------------------------------
local parentTarget = LocalPlayer:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DriftVehicleGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = parentTarget

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 260, 0, 270)
mainFrame.Position = UDim2.new(0.5, -130, 0.35, -135)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ Ultra Drift Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Controls (Minimize/Close)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -60, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -31, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Content Frame
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -48)
content.Position = UDim2.new(0, 10, 0, 43)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Toggle Drift Engine
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 0, 38)
toggleBtn.Position = UDim2.new(0, 0, 0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
toggleBtn.Text = "Engine: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
toggleBtn.Font = Enum.Font.GothamSemibold
toggleBtn.TextSize = 14
toggleBtn.Parent = content
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

-- Mode Selector (Car / Moto / Scooter)
local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(1, 0, 0, 38)
modeBtn.Position = UDim2.new(0, 0, 0, 46)
modeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
modeBtn.Text = "Mode: 🚗 Car"
modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
modeBtn.Font = Enum.Font.Gotham
modeBtn.TextSize = 13
modeBtn.Parent = content
Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 8)

-- 3D Model Toggle
local modelToggleBtn = Instance.new("TextButton")
modelToggleBtn.Size = UDim2.new(1, 0, 0, 38)
modelToggleBtn.Position = UDim2.new(0, 0, 0, 92)
modelToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
modelToggleBtn.Text = "3D Models: VISIBLE"
modelToggleBtn.TextColor3 = Color3.fromRGB(0, 220, 150)
modelToggleBtn.Font = Enum.Font.Gotham
modelToggleBtn.TextSize = 13
modelToggleBtn.Parent = content
Instance.new("UICorner", modelToggleBtn).CornerRadius = UDim.new(0, 8)

-- Speed Box
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, 0, 0, 38)
speedBox.Position = UDim2.new(0, 0, 0, 138)
speedBox.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
speedBox.Text = "80"
speedBox.PlaceholderText = "Set Drift Speed"
speedBox.TextColor3 = Color3.fromRGB(0, 220, 255)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.Parent = content
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

-- Restore Button (Minimized)
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 48, 0, 48)
openBtn.Position = UDim2.new(0.02, 0, 0.5, -24)
openBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
openBtn.Text = "⚡"
openBtn.TextSize = 22
openBtn.Visible = false
openBtn.Parent = screenGui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

--------------------------------------------------------------------------------
-- 4. Universal Drag Logic
--------------------------------------------------------------------------------
local dragging, dragStart, startPos, dragInput

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
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

--------------------------------------------------------------------------------
-- 5. Strong Drift Engine Logic
--------------------------------------------------------------------------------
local function stopDrift()
	isVehicleActive = false
	toggleBtn.Text = "Engine: OFF"
	toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	toggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)

	if renderConnection then renderConnection:Disconnect() renderConnection = nil end
	if sitTrack then sitTrack:Stop() sitTrack = nil end
	if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
	if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end

	clearModel()

	if Humanoid then
		Humanoid.PlatformStand = false
		Humanoid.WalkSpeed = 16
	end
end

local function startDrift()
	isVehicleActive = true
	toggleBtn.Text = "Engine: ON"
	toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
	toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

	applyPose()
	spawnVehicleModel()

	local rootPart = Character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	-- High-Power Physics
	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e6, 0, 1e6)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = rootPart

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(0, 1e6, 0)
	bodyGyro.CFrame = rootPart.CFrame
	bodyGyro.P = 5000
	bodyGyro.Parent = rootPart

	local currentVel = Vector3.zero

	renderConnection = RunService.RenderStepped:Connect(function(dt)
		if not Character or not rootPart or not Humanoid then return end

		local moveDir = Humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			-- Rotation Alignment
			bodyGyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + moveDir)

			-- Strong Drift Inertia (Lerp factor 1.8 for extended sliding)
			local targetVel = moveDir * currentSpeed
			currentVel = currentVel:Lerp(targetVel, dt * 1.8)
		else
			-- Extended coasting friction
			currentVel = currentVel:Lerp(Vector3.zero, dt * 1.2)
		end

		bodyVelocity.Velocity = currentVel
	end)
end

--------------------------------------------------------------------------------
-- 6. GUI Button Events
--------------------------------------------------------------------------------
toggleBtn.MouseButton1Click:Connect(function()
	if isVehicleActive then stopDrift() else startDrift() end
end)

modeBtn.MouseButton1Click:Connect(function()
	if activeMode == "Car" then
		activeMode = "Moto"
		modeBtn.Text = "Mode: 🏍️ Motorcycle"
	elseif activeMode == "Moto" then
		activeMode = "Scooter"
		modeBtn.Text = "Mode: 🛴 Patinete Elétrico"
	else
		activeMode = "Car"
		modeBtn.Text = "Mode: 🚗 Car"
	end

	if isVehicleActive then
		applyPose()
		spawnVehicleModel()
	end
end)

modelToggleBtn.MouseButton1Click:Connect(function()
	showModels = not showModels
	if showModels then
		modelToggleBtn.Text = "3D Models: VISIBLE"
		modelToggleBtn.TextColor3 = Color3.fromRGB(0, 220, 150)
		if isVehicleActive then spawnVehicleModel() end
	else
		modelToggleBtn.Text = "3D Models: HIDDEN"
		modelToggleBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
		clearModel()
	end
end)

speedBox.FocusLost:Connect(function()
	local num = tonumber(speedBox.Text)
	if num then
		currentSpeed = math.clamp(num, 1, 1000)
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

LocalPlayer.CharacterAdded:Connect(function(newChar)
	Character = newChar
	Humanoid = Character:WaitForChild("Humanoid")
	stopDrift()
end)
                                    
