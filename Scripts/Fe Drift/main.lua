-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- State Variables
local isVehicleActive = false
local currentSpeed = 110 -- Amplified speed for extreme drifting
local activeMode = "Scooter" -- "Car", "Moto", "Scooter"
local showModels = true

local activeAnimTracks = {}
local bodyVelocity = nil
local bodyGyro = nil
local renderConnection = nil
local currentVehicleModel = nil

--------------------------------------------------------------------------------
-- 1. Official Roblox Animation Blending (Visible to Everyone)
--------------------------------------------------------------------------------
local OFFICIAL_ANIMS = {
	Sit = "rbxassetid://178130996",
	ToolHold = "rbxassetid://182393478",
	NinjaDash = "rbxassetid://45828430",
	Climb = "rbxassetid://180436334",
	Point = "rbxassetid://128853357",
	Wave = "rbxassetid://128777973"
}

local function stopAnimations()
	for _, track in ipairs(activeAnimTracks) do
		if track then track:Stop() end
	end
	activeAnimTracks = {}
end

local function playTrack(animId, speed, priority)
	local animator = Humanoid:FindFirstChildOfClass("Animator") or Humanoid
	local anim = Instance.new("Animation")
	anim.AnimationId = animId
	local track = animator:LoadAnimation(anim)
	track.Priority = priority or Enum.AnimationPriority.Action4
	track:Play(0.1, 1, speed or 1)
	table.insert(activeAnimTracks, track)
	return track
end

local function applyPose()
	stopAnimations()
	if not isVehicleActive then return end

	if activeMode == "Car" then
		-- Mix 2 Animations: Sit + Tool Hold (Arms forward on steering wheel)
		playTrack(OFFICIAL_ANIMS.Sit, 1)
		playTrack(OFFICIAL_ANIMS.ToolHold, 1)

	elseif activeMode == "Moto" then
		-- Mix 2 Animations: Ninja Dash (Aggressive forward lean) + Climb (Hands gripped on handlebars)
		playTrack(OFFICIAL_ANIMS.NinjaDash, 0) -- Freeze at lean frame
		playTrack(OFFICIAL_ANIMS.Climb, 0)

	elseif activeMode == "Scooter" then
		-- Mix 3 Animations: ToolHold + Point + Wave (Upright scooter stance & handlebar positioning)
		playTrack(OFFICIAL_ANIMS.ToolHold, 1)
		playTrack(OFFICIAL_ANIMS.Point, 0)
		playTrack(OFFICIAL_ANIMS.Wave, 0)
	end
end

--------------------------------------------------------------------------------
-- 2. Modern High-Detail 3D Models
--------------------------------------------------------------------------------
local function clearModel()
	if currentVehicleModel then
		currentVehicleModel:Destroy()
		currentVehicleModel = nil
	end
end

local function createPart(size, color, material, parent, cframeOffset, targetPart)
	local p = Instance.new("Part")
	p.Size = size
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.CanCollide = false
	p.Massless = true
	p.Parent = parent

	local w = Instance.new("Weld")
	w.Part0 = targetPart
	w.Part1 = p
	w.C0 = cframeOffset
	w.Parent = p
	return p
end

local function spawnVehicleModel()
	clearModel()
	if not showModels or not isVehicleActive then return end

	local rootPart = Character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	local model = Instance.new("Model")
	model.Name = "ModernVehicleModel"

	if activeMode == "Car" then
		-- Modern Low-Rider Sports Chassis
		createPart(Vector3.new(4.8, 0.8, 6.5), Color3.fromRGB(15, 15, 20), Enum.Material.Metal, model, CFrame.new(0, -1.8, 0), rootPart)
		createPart(Vector3.new(4.4, 0.4, 6.2), Color3.fromRGB(240, 50, 50), Enum.Material.SmoothPlastic, model, CFrame.new(0, -1.4, 0), rootPart)
		-- LED Underglow & Front Lights
		createPart(Vector3.new(4.2, 0.1, 6.0), Color3.fromRGB(0, 255, 200), Enum.Material.Neon, model, CFrame.new(0, -2.1, 0), rootPart)
		createPart(Vector3.new(1.2, 0.4, 0.2), Color3.fromRGB(255, 255, 255), Enum.Material.Neon, model, CFrame.new(-1.5, -1.2, -3.1), rootPart)
		createPart(Vector3.new(1.2, 0.4, 0.2), Color3.fromRGB(255, 255, 255), Enum.Material.Neon, model, CFrame.new(1.5, -1.2, -3.1), rootPart)
		-- Dual Exhausts
		createPart(Vector3.new(0.5, 0.5, 0.6), Color3.fromRGB(80, 80, 90), Enum.Material.DiamondPlate, model, CFrame.new(-1.2, -1.4, 3.2), rootPart)
		createPart(Vector3.new(0.5, 0.5, 0.6), Color3.fromRGB(80, 80, 90), Enum.Material.DiamondPlate, model, CFrame.new(1.2, -1.4, 3.2), rootPart)

	elseif activeMode == "Moto" then
		-- Futuristic Superbike Frame
		local body = createPart(Vector3.new(1.4, 1.8, 5.2), Color3.fromRGB(25, 25, 30), Enum.Material.SmoothPlastic, model, CFrame.new(0, -1.2, 0), rootPart)
		createPart(Vector3.new(1.45, 1.0, 2.8), Color3.fromRGB(0, 150, 255), Enum.Material.SmoothPlastic, model, CFrame.new(0, -1.0, -0.5), rootPart)
		-- Neon Accent Lines
		createPart(Vector3.new(1.5, 0.15, 4.8), Color3.fromRGB(0, 220, 255), Enum.Material.Neon, model, CFrame.new(0, -1.8, 0), rootPart)
		-- Front Twin Headlights
		createPart(Vector3.new(1.0, 0.3, 0.2), Color3.fromRGB(255, 255, 255), Enum.Material.Neon, model, CFrame.new(0, -0.7, -2.6), rootPart)
		-- Handlebars
		createPart(Vector3.new(2.4, 0.2, 0.2), Color3.fromRGB(40, 40, 45), Enum.Material.Metal, model, CFrame.new(0, -0.2, -1.8), rootPart)

	elseif activeMode == "Scooter" then
		-- Ultra Modern E-Scooter (Patinete Elétrico High-End)
		-- Base Deck & Grip Surface
		local deck = createPart(Vector3.new(1.6, 0.35, 4.2), Color3.fromRGB(20, 22, 28), Enum.Material.SmoothPlastic, model, CFrame.new(0, -2.7, 0), rootPart)
		createPart(Vector3.new(1.4, 0.05, 3.8), Color3.fromRGB(40, 40, 45), Enum.Material.DiamondPlate, model, CFrame.new(0, 0.2, 0), deck)
		-- Neon Side LED Strips
		createPart(Vector3.new(0.1, 0.2, 4.0), Color3.fromRGB(0, 255, 170), Enum.Material.Neon, model, CFrame.new(-0.8, 0, 0), deck)
		createPart(Vector3.new(0.1, 0.2, 4.0), Color3.fromRGB(0, 255, 170), Enum.Material.Neon, model, CFrame.new(0.8, 0, 0), deck)
		-- Sleek Aerodynamic Stem
		local stem = createPart(Vector3.new(0.25, 4.2, 0.25), Color3.fromRGB(220, 220, 230), Enum.Material.Metal, model, CFrame.new(0, 2.0, -1.9) * CFrame.Angles(math.rad(-12), 0, 0), deck)
		-- Handlebars & Digital Dash Display
		local bar = createPart(Vector3.new(2.6, 0.2, 0.25), Color3.fromRGB(30, 30, 35), Enum.Material.SmoothPlastic, model, CFrame.new(0, 2.0, 0), stem)
		createPart(Vector3.new(0.6, 0.22, 0.4), Color3.fromRGB(0, 200, 255), Enum.Material.Neon, model, CFrame.new(0, 0.1, 0), bar)
		-- Integrated Bright LED Headlight & Red Rear Brake Light
		createPart(Vector3.new(0.4, 0.3, 0.3), Color3.fromRGB(255, 255, 255), Enum.Material.Neon, model, CFrame.new(0, 1.7, -0.2), stem)
		createPart(Vector3.new(0.5, 0.2, 0.2), Color3.fromRGB(255, 30, 30), Enum.Material.Neon, model, CFrame.new(0, 0.25, 2.0), deck)
	end

	model.Parent = Character
	currentVehicleModel = model
end

--------------------------------------------------------------------------------
-- 3. GUI Construction
--------------------------------------------------------------------------------
local parentTarget = LocalPlayer:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltraDriftV3"
screenGui.ResetOnSpawn = false
screenGui.Parent = parentTarget

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 270)
mainFrame.Position = UDim2.new(0.5, -130, 0.35, -135)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Title Bar (Drag Zone)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ Drift Hub Pro R6"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

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

-- Content Area
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -48)
content.Position = UDim2.new(0, 10, 0, 43)
content.BackgroundTransparency = 1
content.Parent = mainFrame

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

local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(1, 0, 0, 38)
modeBtn.Position = UDim2.new(0, 0, 0, 46)
modeBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 45)
modeBtn.Text = "Mode: 🛴 Patinete Elétrico"
modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
modeBtn.Font = Enum.Font.Gotham
modeBtn.TextSize = 13
modeBtn.Parent = content
Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 8)

local modelToggleBtn = Instance.new("TextButton")
modelToggleBtn.Size = UDim2.new(1, 0, 0, 38)
modelToggleBtn.Position = UDim2.new(0, 0, 0, 92)
modelToggleBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 45)
modelToggleBtn.Text = "3D Models: VISIBLE"
modelToggleBtn.TextColor3 = Color3.fromRGB(0, 220, 150)
modelToggleBtn.Font = Enum.Font.Gotham
modelToggleBtn.TextSize = 13
modelToggleBtn.Parent = content
Instance.new("UICorner", modelToggleBtn).CornerRadius = UDim.new(0, 8)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, 0, 0, 38)
speedBox.Position = UDim2.new(0, 0, 0, 138)
speedBox.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
speedBox.Text = "110"
speedBox.PlaceholderText = "Set Drift Speed"
speedBox.TextColor3 = Color3.fromRGB(0, 220, 255)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.Parent = content
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 48, 0, 48)
openBtn.Position = UDim2.new(0.02, 0, 0.5, -24)
openBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
openBtn.Text = "🛴"
openBtn.TextSize = 22
openBtn.Visible = false
openBtn.Parent = screenGui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

--------------------------------------------------------------------------------
-- 4. Mobile + PC Dragging
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
-- 5. Strong Lateral Drift Mechanics
--------------------------------------------------------------------------------
local function stopDrift()
	isVehicleActive = false
	toggleBtn.Text = "Engine: OFF"
	toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	toggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)

	if renderConnection then renderConnection:Disconnect() renderConnection = nil end
	stopAnimations()
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

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e6, 0, 1e6)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = rootPart

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(0, 1e6, 0)
	bodyGyro.CFrame = rootPart.CFrame
	bodyGyro.P = 6000
	bodyGyro.Parent = rootPart

	local currentVel = Vector3.zero

	renderConnection = RunService.RenderStepped:Connect(function(dt)
		if not Character or not rootPart or not Humanoid then return end

		local moveDir = Humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			-- Fast Steering Alignment
			bodyGyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + moveDir)

			-- Strong Lateral Drift Physics (Lower friction lerp multiplier = deeper slide)
			local targetVel = moveDir * currentSpeed
			currentVel = currentVel:Lerp(targetVel, dt * 1.15) 
		else
			-- Long Coasting Slide
			currentVel = currentVel:Lerp(Vector3.zero, dt * 0.8)
		end

		bodyVelocity.Velocity = currentVel
	end)
end

--------------------------------------------------------------------------------
-- 6. Events
--------------------------------------------------------------------------------
toggleBtn.MouseButton1Click:Connect(function()
	if isVehicleActive then stopDrift() else startDrift() end
end)

modeBtn.MouseButton1Click:Connect(function()
	if activeMode == "Scooter" then
		activeMode = "Car"
		modeBtn.Text = "Mode: 🚗 Car"
		openBtn.Text = "🚗"
	elseif activeMode == "Car" then
		activeMode = "Moto"
		modeBtn.Text = "Mode: 🏍️ Motorcycle"
		openBtn.Text = "🏍️"
	else
		activeMode = "Scooter"
		modeBtn.Text = "Mode: 🛴 Patinete Elétrico"
		openBtn.Text = "🛴"
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
