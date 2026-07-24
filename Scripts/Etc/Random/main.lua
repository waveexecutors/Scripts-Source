-- ============================================================================
-- CSling Framework v2.0 - Advanced Viewmodel, Knife, & Physics System
-- Place in StarterPlayerScripts or StarterCharacterScripts
-- ============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ----------------------------------------------------------------------------
-- CONFIGURATION & SETTINGS
-- ----------------------------------------------------------------------------
local Settings = {
	BhopEnabled = false,
	AimbotEnabled = false,
	NormalSpeed = 16,
	BhopSpeed = 40,
	AimbotFOV = 220,
	AimbotSmoothness = 0.15,
	FlingForce = 250, -- Power of the fling impulse
	ShootRange = 200,
	FireRate = 0.12,
}

local State = {
	CurrentTool = "WaterGun", -- "WaterGun" or "Knife"
	IsShooting = false,
	LastShot = 0,
	Target = nil,
	Viewmodel = nil,
	GuiMinimized = false,
	EquipProgress = 1, -- 0 to 1 for equip animation
	
	-- Recoil & Camera Shake States
	RecoilOffset = Vector3.new(),
	RecoilRotation = Vector3.new(),
	CamShake = Vector3.new(),
}

-- ----------------------------------------------------------------------------
-- 1. SOUND & AUDIO GENERATION
-- ----------------------------------------------------------------------------
local function CreateSound(id, pitch, volume)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. id
	sound.Pitch = pitch or 1
	sound.Volume = volume or 0.5
	sound.Parent = Camera
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 2)
end

-- ----------------------------------------------------------------------------
-- 2. PROCEDURAL 3D MODELS (WATER GUN & KNIFE)
-- ----------------------------------------------------------------------------
local function BuildViewmodel()
	local Viewmodel = Instance.new("Model")
	Viewmodel.Name = "CS2_Viewmodel"

	local Root = Instance.new("Part")
	Root.Name = "Root"
	Root.Size = Vector3.new(0.2, 0.2, 0.2)
	Root.Transparency = 1
	Root.CanCollide = false
	Root.Anchored = true
	Root.Parent = Viewmodel
	Viewmodel.PrimaryPart = Root

	-- Left and Right Arms
	local function CreateArm(name, posOffset)
		local Arm = Instance.new("Part")
		Arm.Name = name
		Arm.Size = Vector3.new(0.45, 1.4, 0.45)
		Arm.Color = Color3.fromRGB(230, 190, 165)
		Arm.Material = Enum.Material.SmoothPlastic
		Arm.CanCollide = false
		Arm.Parent = Viewmodel

		-- Glove/Sleeve accent
		local Sleeve = Instance.new("Part")
		Sleeve.Size = Vector3.new(0.48, 0.6, 0.48)
		Sleeve.Color = Color3.fromRGB(30, 35, 45)
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
	GunBody.Size = Vector3.new(0.35, 0.5, 1.4)
	GunBody.Color = Color3.fromRGB(20, 160, 225)
	GunBody.Material = Enum.Material.SmoothPlastic
	GunBody.CanCollide = false
	GunBody.Parent = WaterGunGroup

	local PressureTank = Instance.new("Part")
	PressureTank.Size = Vector3.new(0.5, 0.5, 0.9)
	PressureTank.Color = Color3.fromRGB(0, 230, 255)
	PressureTank.Material = Enum.Material.Glass
	PressureTank.Transparency = 0.25
	PressureTank.CanCollide = false
	PressureTank.Parent = WaterGunGroup

	local Barrel = Instance.new("Part")
	Barrel.Name = "Muzzle"
	Barrel.Size = Vector3.new(0.2, 0.2, 0.4)
	Barrel.Color = Color3.fromRGB(240, 240, 240)
	Barrel.Material = Enum.Material.Metal
	Barrel.CanCollide = false
	Barrel.Parent = WaterGunGroup

	-- Welds for Water Gun
	local wBody = Instance.new("Weld")
	wBody.Part0 = Root
	wBody.Part1 = GunBody
	wBody.C0 = CFrame.new(0.4, -0.4, -1.1) * CFrame.Angles(math.rad(8), math.rad(-6), 0)
	wBody.Parent = Root

	local wTank = Instance.new("Weld")
	wTank.Part0 = GunBody
	wTank.Part1 = PressureTank
	wTank.C0 = CFrame.new(0, 0.35, -0.1)
	wTank.Parent = GunBody

	local wBarrel = Instance.new("Weld")
	wBarrel.Part0 = GunBody
	wBarrel.Part1 = Barrel
	wBarrel.C0 = CFrame.new(0, 0.1, -0.8)
	wBarrel.Parent = GunBody

	local wRArm = Instance.new("Weld")
	wRArm.Part0 = GunBody
	wRArm.Part1 = RightArm
	wRArm.C0 = CFrame.new(0.2, -0.2, 0.4) * CFrame.Angles(math.rad(-25), math.rad(15), math.rad(-10))
	wRArm.Parent = GunBody

	local wLArm = Instance.new("Weld")
	wLArm.Part0 = GunBody
	wLArm.Part1 = LeftArm
	wLArm.C0 = CFrame.new(-0.5, -0.1, -0.2) * CFrame.Angles(math.rad(-40), math.rad(-25), math.rad(30))
	wLArm.Parent = GunBody

	-- --- KNIFE MODEL ---
	local KnifeGroup = Instance.new("Model")
	KnifeGroup.Name = "Knife"
	KnifeGroup.Parent = Viewmodel

	local Blade = Instance.new("Part")
	Blade.Size = Vector3.new(0.1, 0.25, 1.1)
	Blade.Color = Color3.fromRGB(220, 220, 230)
	Blade.Material = Enum.Material.Metal
	Blade.CanCollide = false
	Blade.Parent = KnifeGroup

	local Handle = Instance.new("Part")
	Handle.Size = Vector3.new(0.18, 0.3, 0.5)
	Handle.Color = Color3.fromRGB(25, 25, 30)
	Handle.Material = Enum.Material.SmoothPlastic
	Handle.CanCollide = false
	Handle.Parent = KnifeGroup

	local wHandle = Instance.new("Weld")
	wHandle.Part0 = Root
	wHandle.Part1 = Handle
	wHandle.C0 = CFrame.new(0.4, -0.4, -0.9) * CFrame.Angles(math.rad(70), math.rad(10), math.rad(-20))
	wHandle.Parent = Root

	local wBlade = Instance.new("Weld")
	wBlade.Part0 = Handle
	wBlade.Part1 = Blade
	wBlade.C0 = CFrame.new(0, 0, -0.7)
	wBlade.Parent = Handle

	return Viewmodel
end

-- ----------------------------------------------------------------------------
-- 3. ADVANCED VISUAL EFFECTS & SHOOTING
-- ----------------------------------------------------------------------------
local function PlayRecoil()
	-- Recoil Impulse: Kick backwards, tilt up, tilt roll
	State.RecoilOffset = Vector3.new(0, 0, 0.25)
	State.RecoilRotation = Vector3.new(math.rad(14), math.rad(math.random(-4, 4)), math.rad(math.random(-6, 6)))
	State.CamShake = Vector3.new(math.rad(math.random(-2, 2)), math.rad(math.random(-2, 2)), 0)
end

local function FireWaterStream(origin, targetPos)
	-- Primary Water Beam
	local Beam = Instance.new("Part")
	Beam.Size = Vector3.new(0.25, 0.25, (origin - targetPos).Magnitude)
	Beam.Color = Color3.fromRGB(0, 200, 255)
	Beam.Material = Enum.Material.Neon
	Beam.Transparency = 0.2
	Beam.Anchored = true
	Beam.CanCollide = false
	Beam.CFrame = CFrame.lookAt(origin, targetPos) * CFrame.new(0, 0, -Beam.Size.Z / 2)
	Beam.Parent = Workspace

	-- Splash Effect at Impact
	local Splash = Instance.new("Part")
	Splash.Shape = Enum.PartType.Ball
	Splash.Size = Vector3.new(1.5, 1.5, 1.5)
	Splash.Color = Color3.fromRGB(150, 230, 255)
	Splash.Material = Enum.Material.Neon
	Splash.Transparency = 0.3
	Splash.Position = targetPos
	Splash.Anchored = true
	Splash.CanCollide = false
	Splash.Parent = Workspace

	TweenService:Create(Beam, TweenInfo.new(0.18), {Transparency = 1, Size = Vector3.new(0, 0, Beam.Size.Z)}):Play()
	TweenService:Create(Splash, TweenInfo.new(0.2), {Size = Vector3.new(4, 4, 4), Transparency = 1}):Play()

	task.delay(0.2, function()
		Beam:Destroy()
		Splash:Destroy()
	end)
end

local function PerformFling(targetHRP, shootOrigin)
	if not targetHRP then return end

	-- High Velocity Physics Launch
	local launchVector = (targetHRP.Position - shootOrigin).Unit * Settings.FlingForce + Vector3.new(0, Settings.FlingForce * 0.6, 0)
	
	-- Apply rotational torque & linear velocity
	targetHRP.AssemblyLinearVelocity = launchVector
	targetHRP.AssemblyAngularVelocity = Vector3.new(
		math.random(-100, 100),
		math.random(150, 300),
		math.random(-100, 100)
	)
end

local function Attack()
	if tick() - State.LastShot < Settings.FireRate then return end
	State.LastShot = tick()

	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("Head") then return end

	if State.CurrentTool == "WaterGun" then
		PlayRecoil()
		CreateSound("240429289", 1.2, 0.6) -- Splash / Shoot Sound

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
					PerformFling(targetHRP, origin)
				end
			end
		end

		FireWaterStream(origin + Vector3.new(0, -0.3, 0), hitPos)

	elseif State.CurrentTool == "Knife" then
		-- Knife Slash Animation / Recoil
		State.RecoilRotation = Vector3.new(math.rad(-20), math.rad(35), math.rad(-15))
		CreateSound("12222200", 1.1, 0.5) -- Slash sound
	end
end

-- ----------------------------------------------------------------------------
-- 4. TOOL SWITCHING & EQUIP ANIMATION
-- ----------------------------------------------------------------------------
local function SwitchTool(newTool)
	if State.CurrentTool == newTool then return end
	State.CurrentTool = newTool
	State.EquipProgress = 0 -- Reset draw animation

	CreateSound("12222152", 1.0, 0.4) -- Equip draw sound

	if State.Viewmodel then
		local wg = State.Viewmodel:FindFirstChild("WaterGun")
		local kn = State.Viewmodel:FindFirstChild("Knife")

		if wg then wg.Parent = (newTool == "WaterGun") and State.Viewmodel or nil end
		if kn then kn.Parent = (newTool == "Knife") and State.Viewmodel or nil end
	end
end

-- ----------------------------------------------------------------------------
-- 5. GUI & MOBILE CONTROLS
-- ----------------------------------------------------------------------------
local function CreateUI()
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "CSlingUI_v2"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	-- Dynamic Crosshair
	local Crosshair = Instance.new("Frame")
	Crosshair.Size = UDim2.new(0, 4, 0, 4)
	Crosshair.Position = UDim2.new(0.5, -2, 0.5, -2)
	Crosshair.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
	Crosshair.BorderSizePixel = 0
	Crosshair.Parent = ScreenGui

	-- Control Panel Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 220, 0, 230)
	MainFrame.Position = UDim2.new(0.04, 0, 0.25, 0)
	MainFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 32)
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = MainFrame

	-- Title Bar
	local TitleBar = Instance.new("Frame")
	TitleBar.Size = UDim2.new(1, 0, 0, 32)
	TitleBar.BackgroundColor3 = Color3.fromRGB(30, 36, 48)
	TitleBar.Parent = MainFrame

	local TitleCorner = Instance.new("UICorner")
	TitleCorner.CornerRadius = UDim.new(0, 8)
	TitleCorner.Parent = TitleBar

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(0.7, 0, 1, 0)
	Title.Position = UDim2.new(0, 10, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = "CSling v2.0"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 13
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TitleBar

	-- Weapon Switch Button
	local SwitchBtn = Instance.new("TextButton")
	SwitchBtn.Size = UDim2.new(0.9, 0, 0, 32)
	SwitchBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
	SwitchBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 220)
	SwitchBtn.Text = "Weapon: Water Gun"
	SwitchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	SwitchBtn.Font = Enum.Font.GothamBold
	SwitchBtn.TextSize = 12
	SwitchBtn.Parent = MainFrame

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

	-- Mobile Shoot Button
	if UserInputService.TouchEnabled then
		local MobileBtn = Instance.new("TextButton")
		MobileBtn.Size = UDim2.new(0, 75, 0, 75)
		MobileBtn.Position = UDim2.new(0.8, -38, 0.65, -38)
		MobileBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
		MobileBtn.Text = "ATTACK"
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
-- 6. MAIN RENDER & ANIMATION LOOP
-- ----------------------------------------------------------------------------
CreateUI()
State.Viewmodel = BuildViewmodel()
State.Viewmodel.Parent = Camera

-- Input Listeners
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		State.IsShooting = true
	elseif input.KeyCode == Enum.KeyCode.One then
		SwitchTool("WaterGun")
	elseif input.KeyCode == Enum.KeyCode.Two then
		SwitchTool("Knife")
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

	-- Bhop Movement Speed
	if Settings.BhopEnabled then
		hum.WalkSpeed = Settings.BhopSpeed
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) and hum.FloorMaterial ~= Enum.Material.Air then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	else
		hum.WalkSpeed = Settings.NormalSpeed
	end

	-- Attack Logic
	if State.IsShooting then
		Attack()
	end

	-- Recovery Interpolation for Recoil & Shake
	State.RecoilOffset = State.RecoilOffset:Lerp(Vector3.new(), dt * 12)
	State.RecoilRotation = State.RecoilRotation:Lerp(Vector3.new(), dt * 10)
	State.CamShake = State.CamShake:Lerp(Vector3.new(), dt * 14)
	State.EquipProgress = math.clamp(State.EquipProgress + dt * 4, 0, 1)

	-- Apply Camera Shake
	Camera.CFrame = Camera.CFrame * CFrame.Angles(State.CamShake.X, State.CamShake.Y, State.CamShake.Z)

	-- Procedural Viewmodel Animation
	if State.Viewmodel and State.Viewmodel.PrimaryPart then
		local time = tick() * 7
		local speed = hum.RootPart and hum.RootPart.AssemblyLinearVelocity.Magnitude or 0
		
		-- Walking Bobbing & Sway
		local bobX = math.cos(time) * 0.04 * math.clamp(speed / 16, 0, 1)
		local bobY = math.abs(math.sin(time)) * 0.04 * math.clamp(speed / 16, 0, 1)

		-- CS2 Draw Animation Arc
		local equipAngle = math.rad((1 - State.EquipProgress) * -60)
		local equipYOffset = (1 - State.EquipProgress) * -1.2

		-- Position hands forward & rotated up in frame
		local baseCFrame = CFrame.new(0.55 + bobX, -0.45 + bobY + equipYOffset, -1.25) 
			* CFrame.Angles(math.rad(14) + equipAngle, math.rad(-4), 0)

		-- Apply Recoil Transformation
		local recoilCFrame = CFrame.new(State.RecoilOffset) 
			* CFrame.Angles(State.RecoilRotation.X, State.RecoilRotation.Y, State.RecoilRotation.Z)

		State.Viewmodel:SetPrimaryPartCFrame(Camera.CFrame * baseCFrame * recoilCFrame)
	end
end)
