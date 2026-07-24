-- ============================================================================
-- CSling Framework - Complete FPS LocalScript
-- Place in StarterPlayerScripts or StarterCharacterScripts
-- ============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ----------------------------------------------------------------------------
-- CONFIGURATION & TOGGLES
-- ----------------------------------------------------------------------------
local Settings = {
	BhopEnabled = false,
	AimbotEnabled = false,
	NormalSpeed = 16,
	BhopSpeed = 40,
	AimbotFOV = 200, -- Pixels from center
	AimbotSmoothness = 0.2, -- 0 = instant, 1 = slow
	WaterForce = 120, -- Fling/Knockback force
	ShootRange = 150,
	FireRate = 0.15
}

local State = {
	IsShooting = false,
	LastShot = 0,
	Target = nil,
	Viewmodel = nil,
	GuiMinimized = false
}

-- ----------------------------------------------------------------------------
-- 1. CROSSHAIR & GUI CREATION
-- ----------------------------------------------------------------------------
local function CreateUI()
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
	
	-- Main ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "CSlingUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	-- Center Crosshair
	local CrosshairFrame = Instance.new("Frame")
	CrosshairFrame.Name = "Crosshair"
	CrosshairFrame.Size = UDim2.new(0, 4, 0, 4)
	CrosshairFrame.Position = UDim2.new(0.5, -2, 0.5, -2)
	CrosshairFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
	CrosshairFrame.BorderSizePixel = 0
	CrosshairFrame.Parent = ScreenGui

	local function AddCrosshairLine(pos, size)
		local line = Instance.new("Frame")
		line.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
		line.BorderSizePixel = 0
		line.Position = pos
		line.Size = size
		line.Parent = CrosshairFrame
	end
	AddCrosshairLine(UDim2.new(0, -10, 0, 1), UDim2.new(0, 8, 0, 2)) -- Left
	AddCrosshairLine(UDim2.new(0, 6, 0, 1), UDim2.new(0, 8, 0, 2))  -- Right
	AddCrosshairLine(UDim2.new(0, 1, 0, -10), UDim2.new(0, 2, 0, 8)) -- Top
	AddCrosshairLine(UDim2.new(0, 1, 0, 6), UDim2.new(0, 2, 0, 8))  -- Bottom

	-- Main Window Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 220, 0, 190)
	MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
	MainFrame.BackgroundColor3 = Color3.fromRGB(25, 28, 36)
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = false
	MainFrame.Parent = ScreenGui

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 8)
	UICorner.Parent = MainFrame

	-- Title Bar (Draggable handle)
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Size = UDim2.new(1, 0, 0, 32)
	TitleBar.BackgroundColor3 = Color3.fromRGB(35, 40, 52)
	TitleBar.BorderSizePixel = 0
	TitleBar.Parent = MainFrame

	local TitleCorner = Instance.new("UICorner")
	TitleCorner.CornerRadius = UDim.new(0, 8)
	TitleCorner.Parent = TitleBar

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
	TitleLabel.Position = UDim2.new(0, 10, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = "CSling Control"
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 14
	TitleLabel.Parent = TitleBar

	-- Minimize & Close Buttons
	local MinBtn = Instance.new("TextButton")
	MinBtn.Size = UDim2.new(0, 24, 0, 24)
	MinBtn.Position = UDim2.new(1, -54, 0, 4)
	MinBtn.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
	MinBtn.Text = "-"
	MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinBtn.Font = Enum.Font.GothamBold
	MinBtn.Parent = TitleBar

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0, 24, 0, 24)
	CloseBtn.Position = UDim2.new(1, -28, 0, 4)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	CloseBtn.Text = "X"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.Parent = TitleBar

	-- Content Container
	local Content = Instance.new("Frame")
	Content.Name = "Content"
	Content.Size = UDim2.new(1, -16, 1, -40)
	Content.Position = UDim2.new(0, 8, 0, 36)
	Content.BackgroundTransparency = 1
	Content.Parent = MainFrame

	-- Function to create stylized Toggle Buttons
	local function CreateToggle(name, position, defaultState, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 32)
		btn.Position = position
		btn.Font = Enum.Font.GothamSemibold
		btn.TextSize = 12
		btn.Parent = Content

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = btn

		local state = defaultState
		local function UpdateVisual()
			if state then
				btn.BackgroundColor3 = Color3.fromRGB(0, 170, 120)
				btn.Text = name .. ": ON"
				btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			else
				btn.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
				btn.Text = name .. ": OFF"
				btn.TextColor3 = Color3.fromRGB(180, 180, 180)
			end
		end

		btn.MouseButton1Click:Connect(function()
			state = not state
			UpdateVisual()
			callback(state)
		end)
		UpdateVisual()
	end

	CreateToggle("Bhop & Speed", UDim2.new(0, 0, 0, 0), Settings.BhopEnabled, function(val)
		Settings.BhopEnabled = val
	end)

	CreateToggle("Aim Assist", UDim2.new(0, 0, 0, 38), Settings.AimbotEnabled, function(val)
		Settings.AimbotEnabled = val
	end)

	-- Mobile Shoot Action Button
	if UserInputService.TouchEnabled then
		local MobileShootBtn = Instance.new("TextButton")
		MobileShootBtn.Name = "MobileShoot"
		MobileShootBtn.Size = UDim2.new(0, 70, 0, 70)
		MobileShootBtn.Position = UDim2.new(0.8, -35, 0.6, -35)
		MobileShootBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
		MobileShootBtn.BackgroundTransparency = 0.3
		MobileShootBtn.Text = "WATER"
		MobileShootBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		MobileShootBtn.Font = Enum.Font.GothamBold
		MobileShootBtn.Parent = ScreenGui

		local MobileCorner = Instance.new("UICorner")
		MobileCorner.CornerRadius = UDim.new(1, 0)
		MobileCorner.Parent = MobileShootBtn

		MobileShootBtn.MouseButton1Down:Connect(function() State.IsShooting = true end)
		MobileShootBtn.MouseButton1Up:Connect(function() State.IsShooting = false end)
	end

	-- Make Window Draggable
	local dragging, dragInput, dragStart, startPos
	TitleBar.InputBegan:Connect(function(input)
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

	TitleBar.InputChanged:Connect(function(input)
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

	-- Window Minimize / Close Handlers
	MinBtn.MouseButton1Click:Connect(function()
		State.GuiMinimized = not State.GuiMinimized
		Content.Visible = not State.GuiMinimized
		MainFrame.Size = State.GuiMinimized and UDim2.new(0, 220, 0, 32) or UDim2.new(0, 220, 0, 190)
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)
end

-- ----------------------------------------------------------------------------
-- 2. PROCEDURAL WATER GUN & ARM VIEWMODEL
-- ----------------------------------------------------------------------------
local function BuildWaterGunModel()
	local Model = Instance.new("Model")
	Model.Name = "CS2_WaterGun_Viewmodel"

	-- Root / Anchor Part
	local Root = Instance.new("Part")
	Root.Name = "Root"
	Root.Size = Vector3.new(0.2, 0.2, 0.2)
	Root.Transparency = 1
	Root.CanCollide = false
	Root.Anchored = true
	Root.Parent = Model
	Model.PrimaryPart = Root

	-- Gun Body Parts
	local Body = Instance.new("Part")
	Body.Size = Vector3.new(0.3, 0.4, 1.2)
	Body.Color = Color3.fromRGB(255, 170, 0) -- Bright Neon Plastic
	Body.Material = Enum.Material.SmoothPlastic
	Body.CanCollide = false
	Body.Parent = Model

	local Tank = Instance.new("Part")
	Tank.Size = Vector3.new(0.4, 0.4, 0.8)
	Tank.Color = Color3.fromRGB(0, 170, 255) -- Transparent Water Tank
	Tank.Material = Enum.Material.Glass
	Tank.Transparency = 0.2
	Tank.CanCollide = false
	Tank.Parent = Model

	local Muzzle = Instance.new("Part")
	Muzzle.Name = "Muzzle"
	Muzzle.Size = Vector3.new(0.15, 0.15, 0.2)
	Muzzle.Color = Color3.fromRGB(200, 200, 200)
	Muzzle.CanCollide = false
	Muzzle.Parent = Model

	-- Welds
	local w1 = Instance.new("Weld")
	w1.Part0 = Root
	w1.Part1 = Body
	w1.C0 = CFrame.new(0, 0, 0)
	w1.Parent = Root

	local w2 = Instance.new("Weld")
	w2.Part0 = Body
	w2.Part1 = Tank
	w2.C0 = CFrame.new(0, 0.2, -0.1)
	w2.Parent = Body

	local w3 = Instance.new("Weld")
	w3.Part0 = Body
	w3.Part1 = Muzzle
	w3.C0 = CFrame.new(0, 0.1, -0.65)
	w3.Parent = Body

	-- Create Right Arm / Hand Clone
	local Arm = Instance.new("Part")
	Arm.Name = "RightArm"
	Arm.Size = Vector3.new(0.4, 1.2, 0.4)
	Arm.Color = Color3.fromRGB(220, 180, 150)
	Arm.Material = Enum.Material.SmoothPlastic
	Arm.CanCollide = false
	Arm.Parent = Model

	local wArm = Instance.new("Weld")
	wArm.Part0 = Body
	wArm.Part1 = Arm
	wArm.C0 = CFrame.new(0.3, -0.3, 0.2) * CFrame.Angles(math.rad(-20), math.rad(10), math.rad(-10))
	wArm.Parent = Body

	return Model
end

-- ----------------------------------------------------------------------------
-- 3. SHOOTING & FLING PHYSICS MECHANIC
-- ----------------------------------------------------------------------------
local function CreateWaterParticle(origin, targetPos)
	local BeamPart = Instance.new("Part")
	BeamPart.Size = Vector3.new(0.1, 0.1, (origin - targetPos).Magnitude)
	BeamPart.Color = Color3.fromRGB(0, 180, 255)
	BeamPart.Material = Enum.Material.Neon
	BeamPart.Transparency = 0.3
	BeamPart.Anchored = true
	BeamPart.CanCollide = false
	BeamPart.CFrame = CFrame.lookAt(origin, targetPos) * CFrame.new(0, 0, -BeamPart.Size.Z/2)
	BeamPart.Parent = Workspace

	TweenService:Create(BeamPart, TweenInfo.new(0.2), {Transparency = 1, Size = Vector3.new(0, 0, BeamPart.Size.Z)}):Play()
	task.delay(0.2, function() BeamPart:Destroy() end)
end

local function ShootWater()
	if tick() - State.LastShot < Settings.FireRate then return end
	State.LastShot = tick()

	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("Head") then return end

	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {char, State.Viewmodel}
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	local origin = Camera.CFrame.Position
	local direction = Camera.CFrame.LookVector * Settings.ShootRange
	
	-- If Aim Assist has locked a target, fire towards them
	if Settings.AimbotEnabled and State.Target and State.Target:FindFirstChild("Head") then
		direction = (State.Target.Head.Position - origin).Unit * Settings.ShootRange
	end

	local result = Workspace:Raycast(origin, direction, raycastParams)
	local hitPos = origin + direction

	if result then
		hitPos = result.Position
		local hitChar = result.Instance:FindFirstAncestorOfClass("Model")
		if hitChar and hitChar:FindFirstChild("Humanoid") and hitChar ~= char then
			local targetHRP = hitChar:FindFirstChild("HumanoidRootPart")
			if targetHRP then
				-- Fling Physics Mechanic
				local flingDirection = (targetHRP.Position - origin).Unit + Vector3.new(0, 0.8, 0)
				targetHRP.AssemblyLinearVelocity = flingDirection * Settings.WaterForce
			end
		end
	end

	CreateWaterParticle(origin + Vector3.new(0, -0.3, 0), hitPos)
end

-- ----------------------------------------------------------------------------
-- 4. AIMBOT / AIM ASSIST LOCKING
-- ----------------------------------------------------------------------------
local function GetClosestTargetInFOV()
	local closestPlayer = nil
	local shortestDistance = Settings.AimbotFOV

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)

			if onScreen then
				local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
				local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

				if distance < shortestDistance then
					shortestDistance = distance
					closestPlayer = player.Character
				end
			end
		end
	end
	return closestPlayer
end

-- ----------------------------------------------------------------------------
-- 5. BHOP & MAIN RENDER LOOP
-- ----------------------------------------------------------------------------
CreateUI()
State.Viewmodel = BuildWaterGunModel()
State.Viewmodel.Parent = Camera

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		State.IsShooting = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		State.IsShooting = false
	end
end)

RunService.RenderStepped:Connect(function(dt)
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("Humanoid") then return end
	local hum = char.Humanoid

	-- BHOP & Speed Logic
	if Settings.BhopEnabled then
		hum.WalkSpeed = Settings.BhopSpeed
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			if hum.FloorMaterial ~= Enum.Material.Air then
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	else
		hum.WalkSpeed = Settings.NormalSpeed
	end

	-- Shooting Execution
	if State.IsShooting then
		ShootWater()
	end

	-- Aim Assist Tracking
	if Settings.AimbotEnabled then
		State.Target = GetClosestTargetInFOV()
		if State.Target and State.Target:FindFirstChild("Head") then
			local targetCF = CFrame.lookAt(Camera.CFrame.Position, State.Target.Head.Position)
			Camera.CFrame = Camera.CFrame:Lerp(targetCF, 1 - Settings.AimbotSmoothness)
		end
	end

	-- CS2 Hand Viewmodel Positioning & Procedural Sway/Bobbing
	if State.Viewmodel and State.Viewmodel.PrimaryPart then
		local time = tick() * 6
		local moveVel = hum.RootPart and hum.RootPart.AssemblyLinearVelocity.Magnitude or 0
		
		-- Procedural Sway and Bobbing calculations
		local bobX = math.cos(time) * 0.03 * math.clamp(moveVel / 16, 0, 1)
		local bobY = math.abs(math.sin(time)) * 0.03 * math.clamp(moveVel / 16, 0, 1)

		-- Hand Offset: Rotated up & forward relative to camera viewport
		local offsetCFrame = CFrame.new(0.6 + bobX, -0.5 + bobY, -1.2) 
			* CFrame.Angles(math.rad(12), math.rad(-5), math.rad(0)) -- Rotated up a bit

		State.Viewmodel:SetPrimaryPartCFrame(Camera.CFrame * offsetCFrame)
	end
end)
