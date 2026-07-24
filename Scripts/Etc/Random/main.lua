-- ============================================================================
-- CSling v3.0 - Ultimate FPS Engine (Single LocalScript)
-- Place in StarterPlayerScripts or StarterCharacterScripts
-- ============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ----------------------------------------------------------------------------
-- CONFIGURATION & SETTINGS
-- ----------------------------------------------------------------------------
local Settings = {
	BhopEnabled = true,
	SpeedEnabled = true,
	AimbotEnabled = true,
	CrosshairEnabled = true,
	NormalSpeed = 16,
	BhopSpeed = 42,
	AimbotFOV = 250,
	AimbotSmoothness = 0.15,
	FlingPower = 2200, -- Maximum fling launch force
	ShootRange = 250,
	FireRate = 0.14,
}

local State = {
	CurrentTool = "WaterGun", -- "WaterGun" or "Knife"
	IsShooting = false,
	LastShot = 0,
	Target = nil,
	Viewmodel = nil,
	GuiMinimized = false,
	
	-- Animation Progress Tracks
	EquipProgress = 1,
	ReloadProgress = 1,
	KnifeCombo = 1, -- Alternates between 1 (Slash 1) and 2 (Slash 2)
	
	-- Non-destructive Shake & Recoil Offsets
	RecoilOffset = Vector3.new(),
	RecoilRotation = Vector3.new(),
	ShakeOffset = Vector3.new(),
}

-- ----------------------------------------------------------------------------
-- 1. AUDIO & SOUND GENERATOR
-- ----------------------------------------------------------------------------
local function PlaySound(id, pitch, volume)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. tostring(id)
	sound.Pitch = pitch or 1
	sound.Volume = volume or 0.5
	sound.Parent = Camera
	sound:Play()
	Debris:AddItem(sound, 1.5)
end

-- ----------------------------------------------------------------------------
-- 2. PROCEDURAL 3D MODELS (WATER GUN & KNIFE & ARMS)
-- ----------------------------------------------------------------------------
local function BuildDetailedViewmodel()
	local Viewmodel = Instance.new("Model")
	Viewmodel.Name = "CS2_Viewmodel_v3"

	local Root = Instance.new("Part")
	Root.Name = "Root"
	Root.Size = Vector3.new(0.1, 0.1, 0.1)
	Root.Transparency = 1
	Root.CanCollide = false
	Root.Anchored = true
	Root.Parent = Viewmodel
	Viewmodel.PrimaryPart = Root

	-- Arms Creation
	local function CreateArm(name)
		local Arm = Instance.new("Part")
		Arm.Name = name
		Arm.Size = Vector3.new(0.42, 1.5, 0.42)
		Arm.Color = Color3.fromRGB(225, 185, 155)
		Arm.Material = Enum.Material.SmoothPlastic
		Arm.CanCollide = false
		Arm.Parent = Viewmodel

		-- Glove/Sleeve
		local Sleeve = Instance.new("Part")
		Sleeve.Name = "Sleeve"
		Sleeve.Size = Vector3.new(0.46, 0.7, 0.46)
		Sleeve.Color = Color3.fromRGB(25, 28, 36)
		Sleeve.Material = Enum.Material.Fabric
		Sleeve.CanCollide = false
		Sleeve.Parent = Viewmodel

		local wSleeve = Instance.new("Weld")
		wSleeve.Part0 = Arm
		wSleeve.Part1 = Sleeve
		wSleeve.C0 = CFrame.new(0, 0.4, 0)
		wSleeve.Parent = Arm

		return Arm
	end

	local RightArm = CreateArm("RightArm")
	local LeftArm = CreateArm("LeftArm")

	-- --- WATER GUN MODEL ---
	local WaterGunGroup = Instance.new("Model")
	WaterGunGroup.Name = "WaterGun"
	WaterGunGroup.Parent = Viewmodel

	local GunBody = Instance.new("Part")
	GunBody.Name = "GunBody"
	GunBody.Size = Vector3.new(0.35, 0.55, 1.3)
	GunBody.Color = Color3.fromRGB(0, 150, 240)
	GunBody.Material = Enum.Material.SmoothPlastic
	GunBody.CanCollide = false
	GunBody.Parent = WaterGunGroup

	local PressureTank = Instance.new("Part")
	PressureTank.Name = "PressureTank"
	PressureTank.Size = Vector3.new(0.45, 0.45, 0.95)
	PressureTank.Color = Color3.fromRGB(0, 230, 255)
	PressureTank.Material = Enum.Material.Glass
	PressureTank.Transparency = 0.2
	PressureTank.CanCollide = false
	PressureTank.Parent = WaterGunGroup

	local PumpHandle = Instance.new("Part")
	PumpHandle.Name = "PumpHandle"
	PumpHandle.Size = Vector3.new(0.38, 0.25, 0.4)
	PumpHandle.Color = Color3.fromRGB(255, 140, 0)
	PumpHandle.Material = Enum.Material.SmoothPlastic
	PumpHandle.CanCollide = false
	PumpHandle.Parent = WaterGunGroup

	local Muzzle = Instance.new("Part")
	Muzzle.Name = "Muzzle"
	Muzzle.Size = Vector3.new(0.18, 0.18, 0.3)
	Muzzle.Color = Color3.fromRGB(220, 220, 220)
	Muzzle.Material = Enum.Material.Metal
	Muzzle.CanCollide = false
	Muzzle.Parent = WaterGunGroup

	-- Gun Welds
	local wGun = Instance.new("Weld")
	wGun.Name = "GunWeld"
	wGun.Part0 = Root
	wGun.Part1 = GunBody
	wGun.C0 = CFrame.new(0.45, -0.45, -1.15) * CFrame.Angles(math.rad(10), math.rad(-5), 0)
	wGun.Parent = Root

	local wTank = Instance.new("Weld")
	wTank.Part0 = GunBody
	wTank.Part1 = PressureTank
	wTank.C0 = CFrame.new(0, 0.38, -0.05)
	wTank.Parent = GunBody

	local wPump = Instance.new("Weld")
	wPump.Name = "PumpWeld"
	wPump.Part0 = GunBody
	wPump.Part1 = PumpHandle
	wPump.C0 = CFrame.new(0, -0.22, -0.35)
	wPump.Parent = GunBody

	local wMuzzle = Instance.new("Weld")
	wMuzzle.Part0 = GunBody
	wMuzzle.Part1 = Muzzle
	wMuzzle.C0 = CFrame.new(0, 0.1, -0.75)
	wMuzzle.Parent = GunBody

	local wRArmGun = Instance.new("Weld")
	wRArmGun.Name = "RArmGunWeld"
	wRArmGun.Part0 = GunBody
	wRArmGun.Part1 = RightArm
	wRArmGun.C0 = CFrame.new(0.2, -0.2, 0.45) * CFrame.Angles(math.rad(-30), math.rad(12), math.rad(-10))
	wRArmGun.Parent = GunBody

	local wLArmGun = Instance.new("Weld")
	wLArmGun.Name = "LArmGunWeld"
	wLArmGun.Part0 = GunBody
	wLArmGun.Part1 = LeftArm
	wLArmGun.C0 = CFrame.new(-0.48, -0.15, -0.25) * CFrame.Angles(math.rad(-42), math.rad(-22), math.rad(28))
	wLArmGun.Parent = GunBody

	-- --- KNIFE MODEL ---
	local KnifeGroup = Instance.new("Model")
	KnifeGroup.Name = "Knife"
	KnifeGroup.Parent = Viewmodel

	local Blade = Instance.new("Part")
	Blade.Name = "Blade"
	Blade.Size = Vector3.new(0.08, 0.28, 1.25)
	Blade.Color = Color3.fromRGB(235, 235, 245)
	Blade.Material = Enum.Material.Metal
	Blade.CanCollide = false
	Blade.Parent = KnifeGroup

	local Handle = Instance.new("Part")
	Handle.Name = "KnifeHandle"
	Handle.Size = Vector3.new(0.16, 0.3, 0.55)
	Handle.Color = Color3.fromRGB(20, 20, 25)
	Handle.Material = Enum.Material.SmoothPlastic
	Handle.CanCollide = false
	Handle.Parent = KnifeGroup

	-- Knife Welds
	local wKnife = Instance.new("Weld")
	wKnife.Name = "KnifeWeld"
	wKnife.Part0 = Root
	wKnife.Part1 = Handle
	wKnife.C0 = CFrame.new(0.42, -0.42, -0.95) * CFrame.Angles(math.rad(75), math.rad(12), math.rad(-22))
	wKnife.Parent = Root

	local wBlade = Instance.new("Weld")
	wBlade.Part0 = Handle
	wBlade.Part1 = Blade
	wBlade.C0 = CFrame.new(0, 0, -0.78)
	wBlade.Parent = Handle

	return Viewmodel
end

-- ----------------------------------------------------------------------------
-- 3. TOOL VISIBILITY & SWITCHING FIX (NON-DESTRUCTIVE)
-- ----------------------------------------------------------------------------
local function UpdateToolVisibility()
	if not State.Viewmodel then return end

	local showGun = (State.CurrentTool == "WaterGun")
	
	local function SetModelTransparency(model, transparency)
		for _, part in ipairs(model:GetDescendants()) do
			if part:IsA("BasePart") then
				if part.Name == "PressureTank" then
					part.Transparency = showGun and 0.2 or 1
				else
					part.Transparency = transparency
				end
			end
		end
	end

	local gunModel = State.Viewmodel:FindFirstChild("WaterGun")
	local knifeModel = State.Viewmodel:FindFirstChild("Knife")

	if gunModel then SetModelTransparency(gunModel, showGun and 0 or 1) end
	if knifeModel then SetModelTransparency(knifeModel, showGun and 1 or 0) end
end

local function SwitchTool(newTool)
	if State.CurrentTool == newTool then return end
	State.CurrentTool = newTool
	State.EquipProgress = 0 -- Reset CS2 Equip animation

	PlaySound("12222152", 1.05, 0.5) -- Equip Sound
	UpdateToolVisibility()
end

-- ----------------------------------------------------------------------------
-- 4. ULTRA FLING PHYSICS MECHANIC (MULTI-FRAME INJECTION)
-- ----------------------------------------------------------------------------
local function ApplyUltraFling(targetHRP, shootOrigin)
	if not targetHRP then return end

	-- Launch calculation: Strong upward push + forward direction
	local launchDirection = (targetHRP.Position - shootOrigin).Unit * Settings.FlingPower
	local verticalVector = Vector3.new(0, Settings.FlingPower * 0.75, 0)
	local combinedVelocity = launchDirection + verticalVector

	-- Continuous force injection across 5 animation frames to overcome physics dampening
	task.spawn(function()
		for i = 1, 5 do
			if targetHRP and targetHRP.Parent then
				targetHRP.AssemblyLinearVelocity = combinedVelocity
				targetHRP.AssemblyAngularVelocity = Vector3.new(
					math.random(-1500, 1500),
					math.random(2000, 4000),
					math.random(-1500, 1500)
				)
			end
			RunService.Stepped:Wait()
		end
	end)
end

-- ----------------------------------------------------------------------------
-- 5. ADVANCED SHOOTING, COMBOS & ANIMATIONS
-- ----------------------------------------------------------------------------
local function TriggerWaterBlastEffect(origin, targetPos)
	local Beam = Instance.new("Part")
	Beam.Size = Vector3.new(0.3, 0.3, (origin - targetPos).Magnitude)
	Beam.Color = Color3.fromRGB(0, 210, 255)
	Beam.Material = Enum.Material.Neon
	Beam.Transparency = 0.15
	Beam.Anchored = true
	Beam.CanCollide = false
	Beam.CFrame = CFrame.lookAt(origin, targetPos) * CFrame.new(0, 0, -Beam.Size.Z / 2)
	Beam.Parent = Workspace

	local Splash = Instance.new("Part")
	Splash.Shape = Enum.PartType.Ball
	Splash.Size = Vector3.new(1.8, 1.8, 1.8)
	Splash.Color = Color3.fromRGB(160, 240, 255)
	Splash.Material = Enum.Material.Neon
	Splash.Transparency = 0.2
	Splash.Position = targetPos
	Splash.Anchored = true
	Splash.CanCollide = false
	Splash.Parent = Workspace

	TweenService:Create(Beam, TweenInfo.new(0.18), {Transparency = 1, Size = Vector3.new(0, 0, Beam.Size.Z)}):Play()
	TweenService:Create(Splash, TweenInfo.new(0.22), {Size = Vector3.new(5, 5, 5), Transparency = 1}):Play()

	Debris:AddItem(Beam, 0.2)
	Debris:AddItem(Splash, 0.25)
end

local function TriggerWaterGunReload()
	if State.ReloadProgress < 1 then return end
	State.ReloadProgress = 0
	PlaySound("240429289", 1.4, 0.5) -- Pump sound
end

local function PerformAttack()
	if tick() - State.LastShot < Settings.FireRate then return end
	State.LastShot = tick()

	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("Head") then return end

	if State.CurrentTool == "WaterGun" then
		-- Gun Animation 1: Shooting Recoil & Muzzle Kick
		State.RecoilOffset = Vector3.new(0, 0, 0.3)
		State.RecoilRotation = Vector3.new(math.rad(18), math.rad(math.random(-5, 5)), math.rad(math.random(-8, 8)))
		
		-- Camera Impulse Shake (Non-destructive)
		State.ShakeOffset = Vector3.new(math.rad(math.random(-3, 3)), math.rad(math.random(-3, 3)), 0)

		PlaySound("240429289", 1.1, 0.6)

		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {char, State.Viewmodel}
		rayParams.FilterType = Enum.RaycastFilterType.Exclude

		local origin = Camera.CFrame.Position
		local direction = Camera.CFrame.LookVector * Settings.ShootRange

		if Settings.AimbotEnabled and State.Target and State.Target:FindFirstChild("Head") then
			direction = (State.Target.Head.Position - origin).Unit * Settings.ShootRange
		end

		local result = Workspace:Raycast(origin, direction, rayParams)
		local hitPos = origin + direction

		if result then
			hitPos = result.Position
			local hitModel = result.Instance:FindFirstAncestorOfClass("Model")
			if hitModel and hitModel:FindFirstChild("Humanoid") and hitModel ~= char then
				local targetHRP = hitModel:FindFirstChild("HumanoidRootPart")
				if targetHRP then
					ApplyUltraFling(targetHRP, origin)
				end
			end
		end

		TriggerWaterBlastEffect(origin + Vector3.new(0, -0.3, 0), hitPos)

	elseif State.CurrentTool == "Knife" then
		-- Knife Animations 1 & 2: Combo Slash System
		if State.KnifeCombo == 1 then
			-- Slash 1: Diagonal Right to Left Cut
			State.RecoilRotation = Vector3.new(math.rad(-22), math.rad(40), math.rad(-20))
			State.KnifeCombo = 2
		else
			-- Slash 2: Upward Thrust / Heavy Stab
			State.RecoilRotation = Vector3.new(math.rad(30), math.rad(-35), math.rad(25))
			State.KnifeCombo = 1
		end
		
		State.RecoilOffset = Vector3.new(-0.1, 0, 0.2)
		PlaySound("12222200", 1.15, 0.6)
	end
end

-- ----------------------------------------------------------------------------
-- 6. AIMBOT LOCKING MECHANIC
-- ----------------------------------------------------------------------------
local function GetClosestTargetInFOV()
	local closestPlayer = nil
	local shortestDistance = Settings.AimbotFOV

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)

			if onScreen then
				local centerPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
				local distance = (Vector2.new(screenPos.X, screenPos.Y) - centerPos).Magnitude

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
-- 7. FULL & FIXED USER INTERACTION GUI
-- ----------------------------------------------------------------------------
local function CreateUI()
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "CSlingUI_v3"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	-- Crosshair
	local Crosshair = Instance.new("Frame")
	Crosshair.Name = "Crosshair"
	Crosshair.Size = UDim2.new(0, 4, 0, 4)
	Crosshair.Position = UDim2.new(0.5, -2, 0.5, -2)
	Crosshair.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
	Crosshair.BorderSizePixel = 0
	Crosshair.Visible = Settings.CrosshairEnabled
	Crosshair.Parent = ScreenGui

	local function AddLine(pos, size)
		local line = Instance.new("Frame")
		line.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
		line.BorderSizePixel = 0
		line.Position = pos
		line.Size = size
		line.Parent = Crosshair
	end
	AddLine(UDim2.new(0, -10, 0, 1), UDim2.new(0, 8, 0, 2))
	AddLine(UDim2.new(0, 6, 0, 1), UDim2.new(0, 8, 0, 2))
	AddLine(UDim2.new(0, 1, 0, -10), UDim2.new(0, 2, 0, 8))
	AddLine(UDim2.new(0, 1, 0, 6), UDim2.new(0, 2, 0, 8))

	-- Main Window Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 230, 0, 275)
	MainFrame.Position = UDim2.new(0.04, 0, 0.2, 0)
	MainFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 32)
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = MainFrame

	-- Title Bar
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Size = UDim2.new(1, 0, 0, 34)
	TitleBar.BackgroundColor3 = Color3.fromRGB(30, 36, 48)
	TitleBar.Parent = MainFrame

	local TitleCorner = Instance.new("UICorner")
	TitleCorner.CornerRadius = UDim.new(0, 8)
	TitleCorner.Parent = TitleBar

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(0.6, 0, 1, 0)
	Title.Position = UDim2.new(0, 10, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = "CSling v3.0"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 13
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TitleBar

	-- Minimize & Close Buttons
	local MinBtn = Instance.new("TextButton")
	MinBtn.Size = UDim2.new(0, 24, 0, 24)
	MinBtn.Position = UDim2.new(1, -56, 0, 5)
	MinBtn.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
	MinBtn.Text = "-"
	MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinBtn.Font = Enum.Font.GothamBold
	MinBtn.Parent = TitleBar

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0, 24, 0, 24)
	CloseBtn.Position = UDim2.new(1, -28, 0, 5)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(210, 50, 50)
	CloseBtn.Text = "X"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.Parent = TitleBar

	-- Container for controls
	local Content = Instance.new("Frame")
	Content.Name = "Content"
	Content.Size = UDim2.new(1, -16, 1, -44)
	Content.Position = UDim2.new(0, 8, 0, 38)
	Content.BackgroundTransparency = 1
	Content.Parent = MainFrame

	local UIList = Instance.new("UIListLayout")
	UIList.Padding = UDim.new(0, 6)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	UIList.Parent = Content

	-- Weapon Switcher Button
	local SwitchBtn = Instance.new("TextButton")
	SwitchBtn.Size = UDim2.new(1, 0, 0, 32)
	SwitchBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 220)
	SwitchBtn.Text = "Weapon: Water Gun"
	SwitchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	SwitchBtn.Font = Enum.Font.GothamBold
	SwitchBtn.TextSize = 12
	SwitchBtn.LayoutOrder = 1
	SwitchBtn.Parent = Content

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(0, 6)
	BtnCorner.Parent = SwitchBtn

	SwitchBtn.MouseButton1Click:Connect(function()
		if State.CurrentTool == "WaterGun" then
			SwitchTool("Knife")
			SwitchBtn.Text = "Weapon: CS2 Knife"
			SwitchBtn.BackgroundColor3 = Color3.fromRGB(220, 100, 30)
		else
			SwitchTool("WaterGun")
			SwitchBtn.Text = "Weapon: Water Gun"
			SwitchBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 220)
		end
	end)

	-- Function to create functional Toggles
	local function CreateToggle(name, defaultState, order, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 30)
		btn.Font = Enum.Font.GothamSemibold
		btn.TextSize = 12
		btn.LayoutOrder = order
		btn.Parent = Content

		local bCorner = Instance.new("UICorner")
		bCorner.CornerRadius = UDim.new(0, 6)
		bCorner.Parent = btn

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

	-- Restored All Toggles
	CreateToggle("Bhop Hop", Settings.BhopEnabled, 2, function(v) Settings.BhopEnabled = v end)
	CreateToggle("Speed Boost", Settings.SpeedEnabled, 3, function(v) Settings.SpeedEnabled = v end)
	CreateToggle("Aim Assist", Settings.AimbotEnabled, 4, function(v) Settings.AimbotEnabled = v end)
	CreateToggle("Crosshair", Settings.CrosshairEnabled, 5, function(v) 
		Settings.CrosshairEnabled = v 
		Crosshair.Visible = v
	end)

	-- Window Dragging Logic
	local dragging, dragStart, startPos
	TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	MinBtn.MouseButton1Click:Connect(function()
		State.GuiMinimized = not State.GuiMinimized
		Content.Visible = not State.GuiMinimized
		MainFrame.Size = State.GuiMinimized and UDim2.new(0, 230, 0, 34) or UDim2.new(0, 230, 0, 275)
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	-- Mobile Control Action Button
	if UserInputService.TouchEnabled then
		local MobileBtn = Instance.new("TextButton")
		MobileBtn.Size = UDim2.new(0, 75, 0, 75)
		MobileBtn.Position = UDim2.new(0.8, -38, 0.65, -38)
		MobileBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
		MobileBtn.Text = "SHOOT"
		MobileBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		MobileBtn.Font = Enum.Font.GothamBold
		MobileBtn.Parent = ScreenGui

		local MobileCorner = Instance.new("UICorner")
		MobileCorner.CornerRadius = UDim.new(1, 0)
		MobileCorner.Parent = MobileBtn

		MobileBtn.MouseButton1Down:Connect(function() State.IsShooting = true end)
		MobileBtn.MouseButton1Up:Connect(function() State.IsShooting = false end)
	end
end

-- ----------------------------------------------------------------------------
-- 8. MAIN ENGINE & ANIMATION LOOP
-- ----------------------------------------------------------------------------
CreateUI()
State.Viewmodel = BuildDetailedViewmodel()
State.Viewmodel.Parent = Camera
UpdateToolVisibility()

-- Keyboard & Mouse Input Handlers
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		State.IsShooting = true
	elseif input.KeyCode == Enum.KeyCode.One then
		SwitchTool("WaterGun")
	elseif input.KeyCode == Enum.KeyCode.Two then
		SwitchTool("Knife")
	elseif input.KeyCode == Enum.KeyCode.R then
		if State.CurrentTool == "WaterGun" then
			TriggerWaterGunReload()
		end
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

	-- Bhop & Speed Control
	if Settings.SpeedEnabled then
		hum.WalkSpeed = Settings.BhopEnabled and Settings.BhopSpeed or Settings.NormalSpeed
	else
		hum.WalkSpeed = Settings.NormalSpeed
	end

	if Settings.BhopEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
		if hum.FloorMaterial ~= Enum.Material.Air then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end

	-- Attack Execution
	if State.IsShooting then
		PerformAttack()
	end

	-- Aim Assist Alignment
	if Settings.AimbotEnabled then
		State.Target = GetClosestTargetInFOV()
		if State.Target and State.Target:FindFirstChild("Head") then
			local targetCF = CFrame.lookAt(Camera.CFrame.Position, State.Target.Head.Position)
			Camera.CFrame = Camera.CFrame:Lerp(targetCF, 1 - Settings.AimbotSmoothness)
		end
	end

	-- Animation Interpolation Recovery
	State.RecoilOffset = State.RecoilOffset:Lerp(Vector3.new(), dt * 14)
	State.RecoilRotation = State.RecoilRotation:Lerp(Vector3.new(), dt * 12)
	State.ShakeOffset = State.ShakeOffset:Lerp(Vector3.new(), dt * 16)
	
	State.EquipProgress = math.clamp(State.EquipProgress + dt * 4, 0, 1)
	State.ReloadProgress = math.clamp(State.ReloadProgress + dt * 3, 0, 1)

	-- Apply Non-Destructive Camera Shake (Zero Permanent Drift)
	Camera.CFrame = Camera.CFrame * CFrame.Angles(State.ShakeOffset.X, State.ShakeOffset.Y, State.ShakeOffset.Z)

	-- Viewmodel Procedural Animation Calculations
	if State.Viewmodel and State.Viewmodel.PrimaryPart then
		local time = tick() * 7
		local speed = hum.RootPart and hum.RootPart.AssemblyLinearVelocity.Magnitude or 0

		-- Animation 1 & 2: Idle Micro-Sway & Dynamic Walking Bobbing
		local bobX = math.cos(time) * 0.045 * math.clamp(speed / 16, 0.1, 1)
		local bobY = math.abs(math.sin(time)) * 0.045 * math.clamp(speed / 16, 0.1, 1)

		-- Animation 3: CS2 Equip Arc Motion
		local equipAngle = math.rad((1 - State.EquipProgress) * -65)
		local equipYOffset = (1 - State.EquipProgress) * -1.3

		-- Animation 4 (Gun): Reload Water Pump Translation
		local pumpOffset = Vector3.new()
		if State.CurrentTool == "WaterGun" and State.ReloadProgress < 1 then
			local pTime = math.sin(State.ReloadProgress * math.pi)
			pumpOffset = Vector3.new(0, -0.1 * pTime, 0.3 * pTime)
		end

		-- Base Offset: Hands shifted forward and angled upwards to remain clearly visible
		local baseCFrame = CFrame.new(0.55 + bobX, -0.45 + bobY + equipYOffset, -1.2) 
			* CFrame.Angles(math.rad(14) + equipAngle, math.rad(-4), 0)

		-- Recoil Transformation Layer
		local recoilCFrame = CFrame.new(State.RecoilOffset + pumpOffset) 
			* CFrame.Angles(State.RecoilRotation.X, State.RecoilRotation.Y, State.RecoilRotation.Z)

		State.Viewmodel:SetPrimaryPartCFrame(Camera.CFrame * baseCFrame * recoilCFrame)
	end
end)
