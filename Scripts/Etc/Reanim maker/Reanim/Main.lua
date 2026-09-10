--[[ R6 Reanim Creator - Smooth + Live Edit + +/- buttons ]]
local P,UIS,RS = game:GetService("Players"),game:GetService("UserInputService"),game:GetService("RunService")
local plr = P.LocalPlayer
local gui = Instance.new("ScreenGui",plr:WaitForChild("PlayerGui"))
gui.Name,gui.ResetOnSpawn,gui.IgnoreGuiInset,gui.ZIndexBehavior = "R6ReanimCreator",false,true,Enum.ZIndexBehavior.Sibling

local main = Instance.new("Frame",gui)
main.Size,main.Position,main.BackgroundColor3,main.BorderSizePixel,main.ClipsDescendants = UDim2.new(0,280,0,420),UDim2.new(.5,-140,.5,-210),Color3.fromRGB(22,22,30),0,true
Instance.new("UICorner",main).CornerRadius = UDim.new(0,12)
local s = Instance.new("UIStroke",main) s.Color,s.Thickness = Color3.fromRGB(80,70,160),1.4

local titleBar = Instance.new("Frame",main)
titleBar.Size,titleBar.BackgroundColor3,titleBar.BorderSizePixel = UDim2.new(1,0,0,36),Color3.fromRGB(30,28,48),0
Instance.new("UICorner",titleBar).CornerRadius = UDim.new(0,12)
local fix = Instance.new("Frame",titleBar) fix.Size,fix.Position,fix.BackgroundColor3,fix.BorderSizePixel = UDim2.new(1,0,0,16),UDim2.new(0,0,1,-16),Color3.fromRGB(30,28,48),0

local title = Instance.new("TextLabel",titleBar)
title.Size,title.Position,title.BackgroundTransparency,title.Text,title.Font,title.TextSize,title.TextColor3,title.TextXAlignment =
	UDim2.new(1,-80,1,0),UDim2.new(0,10,0,0),1,"R6 Reanim",Enum.Font.GothamBold,14,Color3.fromRGB(230,225,255),Enum.TextXAlignment.Left

local function btn(par,sz,pos,bg,txt,ts)
	local b = Instance.new("TextButton",par)
	b.Size,b.Position,b.BackgroundColor3,b.Text,b.Font,b.TextSize,b.TextColor3 = sz,pos,bg,txt,Enum.Font.GothamBold,ts or 12,Color3.new(1,1,1)
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,6)
	return b
end

local minBtn = btn(titleBar,UDim2.new(0,28,0,28),UDim2.new(1,-64,.5,-14),Color3.fromRGB(55,50,90),"–",18)
local closeBtn = btn(titleBar,UDim2.new(0,28,0,28),UDim2.new(1,-32,.5,-14),Color3.fromRGB(180,55,70),"×",16)

local content = Instance.new("ScrollingFrame",main)
content.Size,content.Position,content.BackgroundTransparency,content.BorderSizePixel,content.ScrollBarThickness,content.ScrollBarImageColor3,content.CanvasSize =
	UDim2.new(1,0,1,-36),UDim2.new(0,0,0,36),1,0,3,Color3.fromRGB(100,90,180),UDim2.new(0,0,0,620)
local lay = Instance.new("UIListLayout",content) lay.Padding,lay.SortOrder = UDim.new(0,7),Enum.SortOrder.LayoutOrder
local pad = Instance.new("UIPadding",content) pad.PaddingTop,pad.PaddingLeft,pad.PaddingRight,pad.PaddingBottom = UDim.new(0,8),UDim.new(0,8),UDim.new(0,8),UDim.new(0,8)

local function section(t,ord)
	local f = Instance.new("Frame",content)
	f.Size,f.AutomaticSize,f.BackgroundColor3,f.BorderSizePixel,f.LayoutOrder = UDim2.new(1,0,0,0),Enum.AutomaticSize.Y,Color3.fromRGB(32,30,48),0,ord
	Instance.new("UICorner",f).CornerRadius = UDim.new(0,8)
	local l = Instance.new("TextLabel",f)
	l.Size,l.Position,l.BackgroundTransparency,l.Text,l.Font,l.TextSize,l.TextColor3,l.TextXAlignment =
		UDim2.new(1,-12,0,18),UDim2.new(0,8,0,4),1,t,Enum.Font.GothamBold,11,Color3.fromRGB(180,170,255),Enum.TextXAlignment.Left
	return f
end

-- Data
local curAnim,curPart,curKF,previewing,prevConn,origC0 = "Idle","Head",1,false,nil,{}
local anims = {Idle={speed=1,keyframes={{}}},Walk={speed=1.4,keyframes={{}}}}
local PART_MOTOR = {Head="Neck",Torso="RootJoint",["Left Arm"]="Left Shoulder",["Right Arm"]="Right Shoulder",["Left Leg"]="Left Hip",["Right Leg"]="Right Hip"}
local PARTS = {"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}

-- Anim type
local aSec = section("ANIMATION",1)
local aFr = Instance.new("Frame",aSec) aFr.Size,aFr.Position,aFr.BackgroundTransparency = UDim2.new(1,-16,0,28),UDim2.new(0,8,0,24),1
local idleBtn = btn(aFr,UDim2.new(.48,0,1,0),UDim2.new(0,0,0,0),Color3.fromRGB(90,70,200),"Idle",12)
local walkBtn = btn(aFr,UDim2.new(.48,0,1,0),UDim2.new(.52,0,0,0),Color3.fromRGB(45,42,70),"Walk",12)

-- Parts
local pSec = section("BODY PART",2)
local pFr = Instance.new("Frame",pSec) pFr.Size,pFr.Position,pFr.BackgroundTransparency = UDim2.new(1,-16,0,58),UDim2.new(0,8,0,24),1
local partBtns = {}
for i,n in ipairs(PARTS) do
	local b = btn(pFr,UDim2.new(.31,0,0,24),UDim2.new(((i-1)%3)*.345,0,math.floor((i-1)/3)*.52,0),Color3.fromRGB(45,42,70),n,10)
	partBtns[n] = b
end

-- XYZ with +/- 
local xSec = section("MOTOR6D C0",3)
local function makeAxis(parent,y,label)
	local r = Instance.new("Frame",parent)
	r.Size,r.Position,r.BackgroundTransparency = UDim2.new(1,-16,0,26),UDim2.new(0,8,0,y),1

	local l = Instance.new("TextLabel",r)
	l.Size,l.BackgroundTransparency,l.Text,l.Font,l.TextSize,l.TextColor3,l.TextXAlignment =
		UDim2.new(0,28,1,0),1,label,Enum.Font.GothamBold,11,Color3.fromRGB(200,195,230),Enum.TextXAlignment.Left

	local boxes = {}
	for i,ax in ipairs({"X","Y","Z"}) do
		local baseX = 30 + (i-1)*78

		local minus = btn(r,UDim2.new(0,18,0,20),UDim2.new(0,baseX,0.5,-10),Color3.fromRGB(60,50,90),"-",14)
		local tb = Instance.new("TextBox",r)
		tb.Size,tb.Position,tb.BackgroundColor3,tb.Text,tb.Font,tb.TextSize,tb.TextColor3,tb.ClearTextOnFocus =
			UDim2.new(0,38,0,20),UDim2.new(0,baseX+20,.5,-10),Color3.fromRGB(40,38,60),"0",Enum.Font.Gotham,12,Color3.new(1,1,1),false
		Instance.new("UICorner",tb).CornerRadius = UDim.new(0,4)
		local plus = btn(r,UDim2.new(0,18,0,20),UDim2.new(0,baseX+60,0.5,-10),Color3.fromRGB(60,50,90),"+",14)

		local function change(delta)
			local v = tonumber(tb.Text) or 0
			v = math.floor((v + delta)*10 + 0.5)/10
			tb.Text = string.format("%.1f",v)
			saveBoxes() -- live update
		end
		minus.MouseButton1Click:Connect(function() change(-0.1) end)
		plus.MouseButton1Click:Connect(function() change(0.1) end)
		tb.FocusLost:Connect(function() saveBoxes() end)
		tb:GetPropertyChangedSignal("Text"):Connect(function()
			if previewing then saveBoxes() end -- live while preview
		end)

		boxes[ax] = tb
	end
	return boxes
end
local posB = makeAxis(xSec,22,"Pos")
local rotB = makeAxis(xSec,52,"Rot")

-- Controls
local cSec = section("CONTROLS",4)
local sLab = Instance.new("TextLabel",cSec)
sLab.Size,sLab.Position,sLab.BackgroundTransparency,sLab.Text,sLab.Font,sLab.TextSize,sLab.TextColor3 =
	UDim2.new(0,40,0,24),UDim2.new(0,8,0,22),1,"Speed",Enum.Font.Gotham,11,Color3.fromRGB(200,195,230)
local speedBox = Instance.new("TextBox",cSec)
speedBox.Size,speedBox.Position,speedBox.BackgroundColor3,speedBox.Text,speedBox.Font,speedBox.TextSize,speedBox.TextColor3 =
	UDim2.new(0,48,0,24),UDim2.new(0,48,0,22),Color3.fromRGB(40,38,60),"1",Enum.Font.Gotham,12,Color3.new(1,1,1)
Instance.new("UICorner",speedBox).CornerRadius = UDim.new(0,5)
local kfLab = Instance.new("TextLabel",cSec)
kfLab.Size,kfLab.Position,kfLab.BackgroundTransparency,kfLab.Text,kfLab.Font,kfLab.TextSize,kfLab.TextColor3 =
	UDim2.new(0,90,0,24),UDim2.new(0,105,0,22),1,"KF: 1/1",Enum.Font.Gotham,11,Color3.fromRGB(200,195,230)

local bRow = Instance.new("Frame",cSec) bRow.Size,bRow.Position,bRow.BackgroundTransparency = UDim2.new(1,-16,0,26),UDim2.new(0,8,0,50),1
local function sBtn(t,x) return btn(bRow,UDim2.new(0,55,1,0),UDim2.new(0,x,0,0),Color3.fromRGB(55,50,95),t,11) end
local prevKF,nextKF,addKF,delKF = sBtn("<",0),sBtn(">",60),sBtn("+",120),sBtn("Del",180)

-- Actions
local act = section("ACTIONS",5)
local prevBtn = btn(act,UDim2.new(1,-16,0,28),UDim2.new(0,8,0,22),Color3.fromRGB(40,120,90),"▶ Preview (OFF)",12)
local saveBtn = btn(act,UDim2.new(1,-16,0,28),UDim2.new(0,8,0,54),Color3.fromRGB(70,90,180),"💾 Save",12)
local genBtn = btn(act,UDim2.new(1,-16,0,28),UDim2.new(0,8,0,86),Color3.fromRGB(140,70,180),"⚡ Generate Script",12)

-- Output
local oSec = section("GENERATED SCRIPT",6)
local outBox = Instance.new("TextBox",oSec)
outBox.Size,outBox.Position,outBox.BackgroundColor3,outBox.Text,outBox.Font,outBox.TextSize,outBox.TextColor3,outBox.TextXAlignment,outBox.TextYAlignment,outBox.ClearTextOnFocus,outBox.MultiLine,outBox.TextWrapped =
	UDim2.new(1,-16,0,110),UDim2.new(0,8,0,22),Color3.fromRGB(18,17,28),"-- Click Generate",Enum.Font.Code,10,Color3.fromRGB(180,255,180),Enum.TextXAlignment.Left,Enum.TextYAlignment.Top,false,true,true
Instance.new("UICorner",outBox).CornerRadius = UDim.new(0,6)
local hint = Instance.new("TextLabel",oSec)
hint.Size,hint.Position,hint.BackgroundTransparency,hint.Text,hint.Font,hint.TextSize,hint.TextColor3 =
	UDim2.new(1,-16,0,16),UDim2.new(0,8,0,136),1,"Select all → Ctrl+C",Enum.Font.Gotham,10,Color3.fromRGB(140,135,180)

-- Helpers
local function getChar() return plr.Character end
local function getMotor(c,n)
	local m = PART_MOTOR[n]
	if m=="RootJoint" then local h=c:FindFirstChild("HumanoidRootPart") return h and h:FindFirstChild("RootJoint") end
	local t=c:FindFirstChild("Torso") return t and t:FindFirstChild(m)
end
local function killAnimate(c)
	local a = c:FindFirstChild("Animate")
	if a then a:Destroy() end
	local h = c:FindFirstChildOfClass("Humanoid")
	if h then for _,v in ipairs(h:GetPlayingAnimationTracks()) do v:Stop(0) end end
end
local function storeOrig(c)
	origC0 = {}
	for _,n in ipairs(PARTS) do local m=getMotor(c,n) if m then origC0[n]=m.C0 end end
end
local function updKF() kfLab.Text = "KF: "..curKF.."/"..#anims[curAnim].keyframes end

function saveBoxes() -- made global so +/- can call it
	local kf = anims[curAnim].keyframes[curKF]
	if not kf then return end
	kf[curPart] = {
		pos = Vector3.new(tonumber(posB.X.Text) or 0, tonumber(posB.Y.Text) or 0, tonumber(posB.Z.Text) or 0),
		rot = Vector3.new(tonumber(rotB.X.Text) or 0, tonumber(rotB.Y.Text) or 0, tonumber(rotB.Z.Text) or 0)
	}
end

local function loadBoxes()
	local kf = anims[curAnim].keyframes[curKF]
	if not kf then return end
	local d = kf[curPart] or {pos=Vector3.zero,rot=Vector3.zero}
	posB.X.Text,posB.Y.Text,posB.Z.Text = string.format("%.1f",d.pos.X),string.format("%.1f",d.pos.Y),string.format("%.1f",d.pos.Z)
	rotB.X.Text,rotB.Y.Text,rotB.Z.Text = string.format("%.1f",d.rot.X),string.format("%.1f",d.rot.Y),string.format("%.1f",d.rot.Z)
end

local function refParts() for n,b in pairs(partBtns) do b.BackgroundColor3 = n==curPart and Color3.fromRGB(90,70,200) or Color3.fromRGB(45,42,70) end end
local function setAnim(a)
	saveBoxes() curAnim,curKF = a,1
	idleBtn.BackgroundColor3 = a=="Idle" and Color3.fromRGB(90,70,200) or Color3.fromRGB(45,42,70)
	walkBtn.BackgroundColor3 = a=="Walk" and Color3.fromRGB(90,70,200) or Color3.fromRGB(45,42,70)
	speedBox.Text = tostring(anims[a].speed) updKF() loadBoxes()
end

-- Smooth Preview
local function stopPrev()
	previewing = false
	prevBtn.Text,prevBtn.BackgroundColor3 = "▶ Preview (OFF)",Color3.fromRGB(40,120,90)
	if prevConn then prevConn:Disconnect() prevConn = nil end
	local c = getChar()
	if c then for n,c0 in pairs(origC0) do local m=getMotor(c,n) if m then m.C0 = c0 end end end
end

local function startPrev()
	local c = getChar()
	if not c then return end
	killAnimate(c)
	storeOrig(c)
	previewing = true
	prevBtn.Text,prevBtn.BackgroundColor3 = "⏹ Preview (ON)",Color3.fromRGB(180,70,60)

	local t = 0
	prevConn = RS.Heartbeat:Connect(function(dt)
		if not previewing or not c.Parent then return end
		local data = anims[curAnim]
		local kfs = data.keyframes
		if #kfs < 1 then return end

		local spd = tonumber(speedBox.Text) or 1
		t = t + dt * spd

		local count = #kfs
		local raw = t % count
		local idx = math.floor(raw) + 1
		local nextIdx = idx % count + 1
		local alpha = raw - math.floor(raw) -- 0 → 1 smooth

		for _,n in ipairs(PARTS) do
			local m = getMotor(c,n)
			if m and origC0[n] then
				local dA = kfs[idx][n] or {pos=Vector3.zero,rot=Vector3.zero}
				local dB = kfs[nextIdx][n] or {pos=Vector3.zero,rot=Vector3.zero}

				local cfA = CFrame.new(dA.pos) * CFrame.Angles(math.rad(dA.rot.X),math.rad(dA.rot.Y),math.rad(dA.rot.Z))
				local cfB = CFrame.new(dB.pos) * CFrame.Angles(math.rad(dB.rot.X),math.rad(dB.rot.Y),math.rad(dB.rot.Z))

				m.C0 = origC0[n] * cfA:Lerp(cfB, alpha)
			end
		end
	end)
end

local function genScript()
	saveBoxes()
	anims[curAnim].speed = tonumber(speedBox.Text) or 1

	local function ser(kf)
		local t = {}
		for p,d in pairs(kf) do
			table.insert(t, string.format('["%s"]={pos=Vector3.new(%.2f,%.2f,%.2f),rot=Vector3.new(%.2f,%.2f,%.2f)}',p,d.pos.X,d.pos.Y,d.pos.Z,d.rot.X,d.rot.Y,d.rot.Z))
		end
		return "{"..table.concat(t,",").."}"
	end
	local iK,wK = {},{}
	for _,k in ipairs(anims.Idle.keyframes) do table.insert(iK,ser(k)) end
	for _,k in ipairs(anims.Walk.keyframes) do table.insert(wK,ser(k)) end

	outBox.Text = [[-- R6 Smooth Reanim (Motor6D) | No Animate
local P,RS=game:GetService("Players"),game:GetService("RunService")
local plr=P.LocalPlayer
local PART_MOTOR={Head="Neck",Torso="RootJoint",["Left Arm"]="Left Shoulder",["Right Arm"]="Right Shoulder",["Left Leg"]="Left Hip",["Right Leg"]="Right Hip"}
local anims={Idle={speed=]]..anims.Idle.speed..[[,keyframes={]]..table.concat(iK,",")..[[}},Walk={speed=]]..anims.Walk.speed..[[,keyframes={]]..table.concat(wK,",")..[[}}}
local function getMotor(c,n) local m=PART_MOTOR[n] if m=="RootJoint" then local h=c:FindFirstChild("HumanoidRootPart") return h and h:FindFirstChild("RootJoint") end local t=c:FindFirstChild("Torso") return t and t:FindFirstChild(m) end
local function setup(c)
	local h=c:WaitForChild("Humanoid",5) if not h then return end
	local a=c:FindFirstChild("Animate") if a then a:Destroy() end
	for _,v in ipairs(h:GetPlayingAnimationTracks()) do v:Stop(0) end
	local orig={} for n in pairs(PART_MOTOR) do local m=getMotor(c,n) if m then orig[n]=m.C0 end end
	local t=0
	RS.Heartbeat:Connect(function(dt)
		if not c.Parent or h.Health<=0 then return end
		local cur = h.MoveDirection.Magnitude>0.1 and "Walk" or "Idle"
		local data,kfs = anims[cur],anims[cur].keyframes
		if #kfs==0 then return end
		t = t + dt * data.speed
		local count = #kfs
		local raw = t % count
		local idx = math.floor(raw)+1
		local nextIdx = idx % count + 1
		local alpha = raw - math.floor(raw)
		for n,base in pairs(orig) do
			local m=getMotor(c,n)
			if m then
				local dA = kfs[idx][n] or {pos=Vector3.zero,rot=Vector3.zero}
				local dB = kfs[nextIdx][n] or {pos=Vector3.zero,rot=Vector3.zero}
				local cfA = CFrame.new(dA.pos)*CFrame.Angles(math.rad(dA.rot.X),math.rad(dA.rot.Y),math.rad(dA.rot.Z))
				local cfB = CFrame.new(dB.pos)*CFrame.Angles(math.rad(dB.rot.X),math.rad(dB.rot.Y),math.rad(dB.rot.Z))
				m.C0 = base * cfA:Lerp(cfB, alpha)
			end
		end
	end)
end
if plr.Character then setup(plr.Character) end
plr.CharacterAdded:Connect(setup)]]
end

-- Auto kill Animate
local function onChar(c)
	task.wait(0.25)
	killAnimate(c)
end
if plr.Character then onChar(plr.Character) end
plr.CharacterAdded:Connect(onChar)

-- Connections
idleBtn.MouseButton1Click:Connect(function() setAnim("Idle") end)
walkBtn.MouseButton1Click:Connect(function() setAnim("Walk") end)
for n,b in pairs(partBtns) do
	b.MouseButton1Click:Connect(function()
		saveBoxes()
		curPart = n
		refParts()
		loadBoxes()
	end)
end
prevKF.MouseButton1Click:Connect(function() saveBoxes() curKF=math.max(1,curKF-1) updKF() loadBoxes() end)
nextKF.MouseButton1Click:Connect(function() saveBoxes() curKF=math.min(#anims[curAnim].keyframes,curKF+1) updKF() loadBoxes() end)
addKF.MouseButton1Click:Connect(function() saveBoxes() table.insert(anims[curAnim].keyframes,{}) curKF=#anims[curAnim].keyframes updKF() loadBoxes() end)
delKF.MouseButton1Click:Connect(function()
	local k=anims[curAnim].keyframes
	if #k<=1 then return end
	table.remove(k,curKF)
	curKF=math.min(curKF,#k)
	updKF() loadBoxes()
end)
prevBtn.MouseButton1Click:Connect(function() if previewing then stopPrev() else startPrev() end end)
saveBtn.MouseButton1Click:Connect(function()
	saveBoxes()
	anims[curAnim].speed = tonumber(speedBox.Text) or 1
	saveBtn.Text = "✓ Saved"
	task.delay(0.9,function() saveBtn.Text="💾 Save" end)
end)
genBtn.MouseButton1Click:Connect(genScript)

-- Drag
local drag,dStart,sPos = false
titleBar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		drag,dStart,sPos = true,i.Position,main.Position
	end
end)
titleBar.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
end)
UIS.InputChanged:Connect(function(i)
	if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local d=i.Position-dStart
		main.Position = UDim2.new(sPos.X.Scale,sPos.X.Offset+d.X,sPos.Y.Scale,sPos.Y.Offset+d.Y)
	end
end)

-- Min / Close
local mini=false
minBtn.MouseButton1Click:Connect(function()
	mini = not mini
	content.Visible = not mini
	main.Size = mini and UDim2.new(0,280,0,36) or UDim2.new(0,280,0,420)
	minBtn.Text = mini and "+" or "–"
end)
closeBtn.MouseButton1Click:Connect(function() stopPrev() gui:Destroy() end)

-- Init
refParts() setAnim("Idle") loadBoxes()
