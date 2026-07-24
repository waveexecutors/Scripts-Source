-- ============================================================================
-- CSling v3.0 - ULTIMATE FPS ENGINE (OPTIMIZED)
-- Place in StarterPlayerScripts or StarterCharacterScripts
-- ============================================================================
local P=game:GetService("Players");local RS=game:GetService("RunService");local UIS=game:GetService("UserInputService");local TS=game:GetService("TweenService");local W=game:GetService("Workspace");local D=game:GetService("Debris")
local LP=P.LocalPlayer;local C=W.CurrentCamera

-- CONFIG
local S={BhopEnabled=true,SpeedEnabled=true,AimbotEnabled=true,CrosshairEnabled=true,NormalSpeed=16,BhopSpeed=42,AimbotFOV=250,AimbotSmoothness=0.15,ShootRange=250,FireRate=0.14,MaxWater=100,WaterPerShot=5,WaterRegenRate=10,FlingPower=3500,FlingType=1}

local St={CurrentTool="WaterGun",IsShooting=false,LastShot=0,Target=nil,Viewmodel=nil,GuiMinimized=false,WaterAmount=100,IsReloading=false,EquipProgress=1,ReloadProgress=1,KnifeCombo=1,RecoilOffset=Vector3.new(),RecoilRotation=Vector3.new(),ShakeOffset=Vector3.new()}

local function PlayS(id,p,v)local s=Instance.new("Sound")s.SoundId="rbxassetid://"..id;s.Pitch=p or 1;s.Volume=v or .5;s.Parent=C;s:Play();D:AddItem(s,1.5)end

-- BUILD VIEWMODEL WITH FIXED HAND POSITIONS
local function BuildVM()
    local VM=Instance.new("Model");VM.Name="CS2_Viewmodel_v3"
    local Root=Instance.new("Part");Root.Name="Root";Root.Size=Vector3.new(.1,.1,.1);Root.Transparency=1;Root.CanCollide=false;Root.Anchored=true;Root.Parent=VM;VM.PrimaryPart=Root
    local function Arm(n,c)c=c or Color3.fromRGB(225,185,155)
        local A=Instance.new("Part");A.Name=n;A.Size=Vector3.new(.42,1.5,.42);A.Color=c;A.Material=Enum.Material.SmoothPlastic;A.CanCollide=false;A.Parent=VM
        local SL=Instance.new("Part");SL.Name="Sleeve";SL.Size=Vector3.new(.46,.7,.46);SL.Color=Color3.fromRGB(25,28,36);SL.Material=Enum.Material.Fabric;SL.CanCollide=false;SL.Parent=VM
        local w=Instance.new("Weld");w.Part0=A;w.Part1=SL;w.C0=CFrame.new(0,.4,0);w.Parent=A;return A
    end
    local RA=Arm("RightArm");local LA=Arm("LeftArm")
    
    -- WATER GUN
    local WG=Instance.new("Model");WG.Name="WaterGun";WG.Parent=VM
    local GB=Instance.new("Part");GB.Name="GunBody";GB.Size=Vector3.new(.35,.55,1.3);GB.Color=Color3.fromRGB(0,150,240);GB.Material=Enum.Material.SmoothPlastic;GB.CanCollide=false;GB.Parent=WG
    local PT=Instance.new("Part");PT.Name="PressureTank";PT.Size=Vector3.new(.45,.45,.95);PT.Color=Color3.fromRGB(0,230,255);PT.Material=Enum.Material.Glass;PT.Transparency=.2;PT.CanCollide=false;PT.Parent=WG
    local PH=Instance.new("Part");PH.Name="PumpHandle";PH.Size=Vector3.new(.38,.25,.4);PH.Color=Color3.fromRGB(255,140,0);PH.Material=Enum.Material.SmoothPlastic;PH.CanCollide=false;PH.Parent=WG
    local MZ=Instance.new("Part");MZ.Name="Muzzle";MZ.Size=Vector3.new(.18,.18,.3);MZ.Color=Color3.fromRGB(220,220,220);MZ.Material=Enum.Material.Metal;MZ.CanCollide=false;MZ.Parent=WG
    local WI=Instance.new("Part");WI.Name="WaterIndicator";WI.Size=Vector3.new(.3,.05,.3);WI.Color=Color3.fromRGB(0,100,255);WI.Material=Enum.Material.Neon;WI.CanCollide=false;WI.Parent=WG
    
    local wG=Instance.new("Weld");wG.Part0=Root;wG.Part1=GB;wG.C0=CFrame.new(.45,-.45,-1.15)*CFrame.Angles(math.rad(10),math.rad(-5),0);wG.Parent=Root
    local wT=Instance.new("Weld");wT.Part0=GB;wT.Part1=PT;wT.C0=CFrame.new(0,.38,-.05);wT.Parent=GB
    local wP=Instance.new("Weld");wP.Part0=GB;wP.Part1=PH;wP.C0=CFrame.new(0,-.22,-.35);wP.Parent=GB
    local wM=Instance.new("Weld");wM.Part0=GB;wM.Part1=MZ;wM.C0=CFrame.new(0,.1,-.75);wM.Parent=GB
    local wWI=Instance.new("Weld");wWI.Part0=PT;wWI.Part1=WI;wWI.C0=CFrame.new(0,-.25,0);wWI.Parent=PT
    
    -- FIXED HAND POSITIONS
    local wRA=Instance.new("Weld");wRA.Part0=Root;wRA.Part1=RA;wRA.C0=CFrame.new(.25,-.35,-.55)*CFrame.Angles(math.rad(-10),math.rad(8),math.rad(-8));wRA.Parent=Root
    local wLA=Instance.new("Weld");wLA.Part0=Root;wLA.Part1=LA;wLA.C0=CFrame.new(-.4,-.3,-.35)*CFrame.Angles(math.rad(-25),math.rad(-12),math.rad(18));wLA.Parent=Root
    
    -- KNIFE
    local KG=Instance.new("Model");KG.Name="Knife";KG.Parent=VM
    local BL=Instance.new("Part");BL.Name="Blade";BL.Size=Vector3.new(.08,.28,1.25);BL.Color=Color3.fromRGB(235,235,245);BL.Material=Enum.Material.Metal;BL.CanCollide=false;BL.Parent=KG
    local KH=Instance.new("Part");KH.Name="KnifeHandle";KH.Size=Vector3.new(.16,.3,.55);KH.Color=Color3.fromRGB(20,20,25);KH.Material=Enum.Material.SmoothPlastic;KH.CanCollide=false;KH.Parent=KG
    
    local wK=Instance.new("Weld");wK.Part0=Root;wK.Part1=KH;wK.C0=CFrame.new(.4,-.4,-.9)*CFrame.Angles(math.rad(75),math.rad(12),math.rad(-22));wK.Parent=Root
    local wB=Instance.new("Weld");wB.Part0=KH;wB.Part1=BL;wB.C0=CFrame.new(0,0,-.78);wB.Parent=KH
    
    local wRAK=Instance.new("Weld");wRAK.Part0=Root;wRAK.Part1=RA;wRAK.C0=CFrame.new(.15,-.35,-.45)*CFrame.Angles(math.rad(-15),math.rad(15),math.rad(-5));wRAK.Parent=Root
    local wLAK=Instance.new("Weld");wLAK.Part0=Root;wLAK.Part1=LA;wLAK.C0=CFrame.new(-.45,-.25,-.25)*CFrame.Angles(math.rad(-30),math.rad(-18),math.rad(22));wLAK.Parent=Root
    return VM
end

-- TOOL VISIBILITY
local function UpdVis()
    if not St.Viewmodel then return end
    local showGun=St.CurrentTool=="WaterGun"
    local function SetT(model,t)for _,p in ipairs(model:GetDescendants())do if p:IsA("BasePart")then p.Transparency=(p.Name=="PressureTank"or p.Name=="WaterIndicator")and(showGun and.2 or 1)or(showGun and 0 or 1)end end end
    local g=St.Viewmodel:FindFirstChild("WaterGun");local k=St.Viewmodel:FindFirstChild("Knife")
    if g then SetT(g,showGun and 0 or 1)end
    if k then SetT(k,showGun and 1 or 0)end
    if showGun and g then
        local ind=g:FindFirstChild("WaterIndicator")
        if ind then
            local wp=St.WaterAmount/S.MaxWater
            ind.Size=Vector3.new(.3*wp,.05,.3)
            ind.Color=Color3.fromRGB(255*(1-wp),100*wp,50)
        end
    end
end

local function SwitchTool(t)
    if St.CurrentTool==t then return end
    St.CurrentTool=t;St.EquipProgress=0;PlayS("12222152",1.05,.5);UpdVis()
end

-- ENHANCED FLING - NOW WORKS!
local function ApplyFling(targetHRP,origin)
    if not targetHRP then return end
    local power=S.FlingPower
    local dir=(targetHRP.Position-origin).Unit
    local vel=Vector3.new()
    
    if S.FlingType==1 then -- Launch
        vel=dir*power+Vector3.new(0,power*.8,0)
    elseif S.FlingType==2 then -- Spin
        local rd=Vector3.new(math.random(-100,100),math.random(50,150),math.random(-100,100)).Unit
        vel=(dir*.3+rd*.7)*power
    elseif S.FlingType==3 then -- Explosive
        vel=Vector3.new(0,power*1.5,0)+Vector3.new(math.random(-power*.5,power*.5),math.random(power*.2,power*.8),math.random(-power*.5,power*.5))
    else -- Vertical
        vel=Vector3.new(0,power*2.5,0)+dir*power*.3
    end
    
    -- Force apply multiple times with increasing power
    task.spawn(function()
        for i=1,12 do
            if targetHRP and targetHRP.Parent then
                targetHRP.AssemblyLinearVelocity=vel*(1+i*.08)
                targetHRP.AssemblyAngularVelocity=Vector3.new(math.random(-2000,2000),math.random(3000,5000),math.random(-2000,2000))
                targetHRP.Velocity=vel*(1+i*.08) -- Extra velocity application
            end
            task.wait()
        end
    end)
end

-- WATER SYSTEM
local function CanShoot()
    if St.CurrentTool~="WaterGun"then return true end
    if St.IsReloading then return false end
    if St.WaterAmount<=0 then Reload();return false end
    return true
end

function Reload()
    if St.IsReloading or St.WaterAmount>=S.MaxWater then return end
    St.IsReloading=true;St.ReloadProgress=0;PlayS("240429289",1.4,.5)
    task.spawn(function()
        task.wait(.3) -- ULTRA FAST RELOAD
        St.WaterAmount=S.MaxWater;St.IsReloading=false;St.ReloadProgress=1;UpdVis()
        local gui=LP.PlayerGui:FindFirstChild("CSlingUI_v3")
        if gui then local wl=gui:FindFirstChild("WaterLabel")if wl then wl.Text="💧 "..math.floor(St.WaterAmount).."%"end end
    end)
end

local function TriggerBlast(origin,target)
    local B=Instance.new("Part");B.Size=Vector3.new(.3,.3,(origin-target).Magnitude);B.Color=Color3.fromRGB(0,210,255);B.Material=Enum.Material.Neon;B.Transparency=.15;B.Anchored=true;B.CanCollide=false;B.CFrame=CFrame.lookAt(origin,target)*CFrame.new(0,0,-B.Size.Z/2);B.Parent=W
    local Sp=Instance.new("Part");Sp.Shape=Enum.PartType.Ball;Sp.Size=Vector3.new(1.8,1.8,1.8);Sp.Color=Color3.fromRGB(160,240,255);Sp.Material=Enum.Material.Neon;Sp.Transparency=.2;Sp.Position=target;Sp.Anchored=true;Sp.CanCollide=false;Sp.Parent=W
    TS:Create(B,TweenInfo.new(.18),{Transparency=1,Size=Vector3.new(0,0,B.Size.Z)}):Play()
    TS:Create(Sp,TweenInfo.new(.22),{Size=Vector3.new(5,5,5),Transparency=1}):Play()
    D:AddItem(B,.2);D:AddItem(Sp,.25)
end

local function Attack()
    if tick()-St.LastShot<S.FireRate then return end
    if St.CurrentTool=="WaterGun"and not CanShoot()then return end
    St.LastShot=tick()
    local char=LP.Character
    if not char or not char:FindFirstChild("Head")then return end
    
    if St.CurrentTool=="WaterGun"then
        St.WaterAmount=math.max(0,St.WaterAmount-S.WaterPerShot);UpdVis()
        St.RecoilOffset=Vector3.new(0,0,.3)
        St.RecoilRotation=Vector3.new(math.rad(18),math.rad(math.random(-5,5)),math.rad(math.random(-8,8)))
        St.ShakeOffset=Vector3.new(math.rad(math.random(-3,3)),math.rad(math.random(-3,3)),0)
        PlayS("240429289",1.1,.6)
        
        local params=RaycastParams.new()
        params.FilterDescendantsInstances={char,St.Viewmodel}
        params.FilterType=Enum.RaycastFilterType.Exclude
        local origin=C.CFrame.Position
        local dir=C.CFrame.LookVector*S.ShootRange
        if S.AimbotEnabled and St.Target and St.Target:FindFirstChild("Head")then
            dir=(St.Target.Head.Position-origin).Unit*S.ShootRange
        end
        local result=W:Raycast(origin,dir,params)
        local hitPos=origin+dir
        if result then
            hitPos=result.Position
            local model=result.Instance:FindFirstAncestorOfClass("Model")
            if model and model:FindFirstChild("Humanoid")and model~=char then
                local hrp=model:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Apply fling with multiple methods for reliability
                    ApplyFling(hrp,origin)
                    -- Backup fling method
                    task.spawn(function()
                        for i=1,5 do
                            if hrp and hrp.Parent then
                                hrp.AssemblyLinearVelocity=hrp.AssemblyLinearVelocity+Vector3.new(0,S.FlingPower*.5,0)
                            end
                            task.wait(.05)
                        end
                    end)
                end
            end
        end
        TriggerBlast(origin+Vector3.new(0,-.3,0),hitPos)
        if St.WaterAmount<=0 then Reload()end
    else -- KNIFE
        if St.KnifeCombo==1 then
            St.RecoilRotation=Vector3.new(math.rad(-22),math.rad(40),math.rad(-20));St.KnifeCombo=2
        else
            St.RecoilRotation=Vector3.new(math.rad(30),math.rad(-35),math.rad(25));St.KnifeCombo=1
        end
        St.RecoilOffset=Vector3.new(-.1,0,.2);PlayS("12222200",1.15,.6)
    end
end

-- AIMBOT
local function GetTarget()
    local closest=nil;local dist=S.AimbotFOV
    for _,p in ipairs(P:GetPlayers())do
        if p~=LP and p.Character and p.Character:FindFirstChild("Head")then
            local h=p.Character.Head
            local sp,on=C:WorldToViewportPoint(h.Position)
            if on then
                local d=(Vector2.new(sp.X,sp.Y)-Vector2.new(C.ViewportSize.X/2,C.ViewportSize.Y/2)).Magnitude
                if d<dist then dist=d;closest=p.Character end
            end
        end
    end
    return closest
end

-- CREATE UI (SHORTER)
local function CreateUI()
    local PG=LP:WaitForChild("PlayerGui")
    local SG=Instance.new("ScreenGui");SG.Name="CSlingUI_v3";SG.ResetOnSpawn=false;SG.Parent=PG
    
    -- Crosshair
    local CH=Instance.new("Frame");CH.Name="Crosshair";CH.Size=UDim2.new(0,4,0,4);CH.Position=UDim2.new(.5,-2,.5,-2);CH.BackgroundColor3=Color3.fromRGB(0,255,180);CH.BorderSizePixel=0;CH.Visible=S.CrosshairEnabled;CH.Parent=SG
    local function AddL(p,s)local l=Instance.new("Frame");l.BackgroundColor3=Color3.fromRGB(0,255,180);l.BorderSizePixel=0;l.Position=p;l.Size=s;l.Parent=CH end
    AddL(UDim2.new(0,-10,0,1),UDim2.new(0,8,0,2));AddL(UDim2.new(0,6,0,1),UDim2.new(0,8,0,2));AddL(UDim2.new(0,1,0,-10),UDim2.new(0,2,0,8));AddL(UDim2.new(0,1,0,6),UDim2.new(0,2,0,8))
    
    -- Main Frame
    local MF=Instance.new("Frame");MF.Name="MainFrame";MF.Size=UDim2.new(0,280,0,380);MF.Position=UDim2.new(.04,0,.15,0);MF.BackgroundColor3=Color3.fromRGB(20,24,32);MF.BorderSizePixel=0;MF.Parent=SG
    local Cnr=Instance.new("UICorner");Cnr.CornerRadius=UDim.new(0,8);Cnr.Parent=MF
    
    local TB=Instance.new("Frame");TB.Name="TitleBar";TB.Size=UDim2.new(1,0,0,34);TB.BackgroundColor3=Color3.fromRGB(30,36,48);TB.Parent=MF
    local TC=Instance.new("UICorner");TC.CornerRadius=UDim.new(0,8);TC.Parent=TB
    local Title=Instance.new("TextLabel");Title.Size=UDim2.new(.6,0,1,0);Title.Position=UDim2.new(0,10,0,0);Title.BackgroundTransparency=1;Title.Text="CSling v3.0";Title.TextColor3=Color3.fromRGB(255,255,255);Title.Font=Enum.Font.GothamBold;Title.TextSize=13;Title.TextXAlignment=Enum.TextXAlignment.Left;Title.Parent=TB
    
    local WL=Instance.new("TextLabel");WL.Name="WaterLabel";WL.Size=UDim2.new(0,80,1,0);WL.Position=UDim2.new(.3,0,0,0);WL.BackgroundTransparency=1;WL.Text="💧 100%";WL.TextColor3=Color3.fromRGB(100,200,255);WL.Font=Enum.Font.GothamSemibold;WL.TextSize=12;WL.TextXAlignment=Enum.TextXAlignment.Left;WL.Parent=TB
    
    local Min=Instance.new("TextButton");Min.Size=UDim2.new(0,24,0,24);Min.Position=UDim2.new(1,-56,0,5);Min.BackgroundColor3=Color3.fromRGB(50,55,70);Min.Text="-";Min.TextColor3=Color3.fromRGB(255,255,255);Min.Font=Enum.Font.GothamBold;Min.Parent=TB
    local Close=Instance.new("TextButton");Close.Size=UDim2.new(0,24,0,24);Close.Position=UDim2.new(1,-28,0,5);Close.BackgroundColor3=Color3.fromRGB(210,50,50);Close.Text="X";Close.TextColor3=Color3.fromRGB(255,255,255);Close.Font=Enum.Font.GothamBold;Close.Parent=TB
    
    local Content=Instance.new("Frame");Content.Name="Content";Content.Size=UDim2.new(1,-16,1,-44);Content.Position=UDim2.new(0,8,0,38);Content.BackgroundTransparency=1;Content.Parent=MF
    local List=Instance.new("UIListLayout");List.Padding=UDim.new(0,4);List.SortOrder=Enum.SortOrder.LayoutOrder;List.Parent=Content
    
    -- Weapon Switch
    local SW=Instance.new("TextButton");SW.Size=UDim2.new(1,0,0,32);SW.BackgroundColor3=Color3.fromRGB(0,150,220);SW.Text="Weapon: Water Gun";SW.TextColor3=Color3.fromRGB(255,255,255);SW.Font=Enum.Font.GothamBold;SW.TextSize=12;SW.LayoutOrder=1;SW.Parent=Content
    local BC=Instance.new("UICorner");BC.CornerRadius=UDim.new(0,6);BC.Parent=SW
    SW.MouseButton1Click:Connect(function()
        if St.CurrentTool=="WaterGun"then SwitchTool("Knife");SW.Text="Weapon: CS2 Knife";SW.BackgroundColor3=Color3.fromRGB(220,100,30)
        else SwitchTool("WaterGun");SW.Text="Weapon: Water Gun";SW.BackgroundColor3=Color3.fromRGB(0,150,220)end
    end)
    
    -- Fling Type
    local FB=Instance.new("TextButton");FB.Size=UDim2.new(1,0,0,30);FB.Font=Enum.Font.GothamSemibold;FB.TextSize=12;FB.LayoutOrder=1.5;FB.Parent=Content
    local fNames={"🚀 Launch","🌀 Spin","💥 Explosive","⬆️ Vertical"}
    local function UpdFB()FB.Text="Fling: "..fNames[S.FlingType];FB.BackgroundColor3=Color3.fromRGB(200,80,50)end;UpdFB()
    local FC=Instance.new("UICorner");FC.CornerRadius=UDim.new(0,6);FC.Parent=FB
    FB.MouseButton1Click:Connect(function()S.FlingType=S.FlingType%4+1;UpdFB()end)
    
    -- Toggle Helper
    local function Tog(name,def,order,cb)
        local btn=Instance.new("TextButton");btn.Size=UDim2.new(1,0,0,28);btn.Font=Enum.Font.GothamSemibold;btn.TextSize=11;btn.LayoutOrder=order;btn.Parent=Content
        local bc=Instance.new("UICorner");bc.CornerRadius=UDim.new(0,6);bc.Parent=btn
        local state=def
        local function Upd()if state then btn.BackgroundColor3=Color3.fromRGB(0,170,120);btn.Text=name..": ON";btn.TextColor3=Color3.fromRGB(255,255,255)else btn.BackgroundColor3=Color3.fromRGB(45,50,65);btn.Text=name..": OFF";btn.TextColor3=Color3.fromRGB(180,180,180)end end
        btn.MouseButton1Click:Connect(function()state=not state;Upd();cb(state)end);Upd()
    end
    Tog("Bhop Hop",S.BhopEnabled,2,function(v)S.BhopEnabled=v end)
    Tog("Speed Boost",S.SpeedEnabled,3,function(v)S.SpeedEnabled=v end)
    Tog("Aim Assist",S.AimbotEnabled,4,function(v)S.AimbotEnabled=v end)
    Tog("Crosshair",S.CrosshairEnabled,5,function(v)S.CrosshairEnabled=v;CH.Visible=v end)
    
    -- Dragging
    local drag,dragS,startP
    TB.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true;dragS=i.Position;startP=MF.Position end end)
    UIS.InputChanged:Connect(function(i)if drag and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local d=i.Position-dragS;MF.Position=UDim2.new(startP.X.Scale,startP.X.Offset+d.X,startP.Y.Scale,startP.Y.Offset+d.Y)end end)
    UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end)
    
    Min.MouseButton1Click:Connect(function()St.GuiMinimized=not St.GuiMinimized;Content.Visible=not St.GuiMinimized;MF.Size=St.GuiMinimized and UDim2.new(0,280,0,34)or UDim2.new(0,280,0,380)end)
    Close.MouseButton1Click:Connect(function()SG:Destroy()end)
    
    if UIS.TouchEnabled then
        local MB=Instance.new("TextButton");MB.Size=UDim2.new(0,75,0,75);MB.Position=UDim2.new(.8,-38,.65,-38);MB.BackgroundColor3=Color3.fromRGB(0,180,255);MB.Text="SHOOT";MB.TextColor3=Color3.fromRGB(255,255,255);MB.Font=Enum.Font.GothamBold;MB.Parent=SG
        local MC=Instance.new("UICorner");MC.CornerRadius=UDim.new(1,0);MC.Parent=MB
        MB.MouseButton1Down:Connect(function()St.IsShooting=true end);MB.MouseButton1Up:Connect(function()St.IsShooting=false end)
    end
    return WL
end

-- MAIN
local WaterLabel=CreateUI()
St.Viewmodel=BuildVM();St.Viewmodel.Parent=C;UpdVis()


-- Water regen (FAST)
task.spawn(function()while task.wait(.3)do if St.CurrentTool=="WaterGun"and not St.IsReloading then St.WaterAmount=math.min(S.MaxWater,St.WaterAmount+S.WaterRegenRate*.3)if WaterLabel then WaterLabel.Text="💧 "..math.floor(St.WaterAmount).."%"end;UpdVis()end end end)

-- Input
UIS.InputBegan:Connect(function(i,g)if g then return end
    if i.UserInputType==Enum.UserInputType.MouseButton1 then St.IsShooting=true
    elseif i.KeyCode==Enum.KeyCode.One then SwitchTool("WaterGun")
    elseif i.KeyCode==Enum.KeyCode.Two then SwitchTool("Knife")
    elseif i.KeyCode==Enum.KeyCode.R and St.CurrentTool=="WaterGun"then Reload()end
end)
UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then St.IsShooting=false end end)

-- MAIN LOOP
RS.RenderStepped:Connect(function(dt)
    local char=LP.Character
    if not char or not char:FindFirstChild("Humanoid")then return end
    local hum=char.Humanoid
    
    if S.SpeedEnabled then hum.WalkSpeed=S.BhopEnabled and S.BhopSpeed or S.NormalSpeed else hum.WalkSpeed=S.NormalSpeed end
    if S.BhopEnabled and UIS:IsKeyDown(Enum.KeyCode.Space)and hum.FloorMaterial~=Enum.Material.Air then hum:ChangeState(Enum.HumanoidStateType.Jumping)end
    
    if St.IsShooting then Attack()end
    
    if S.AimbotEnabled then
        St.Target=GetTarget()
        if St.Target and St.Target:FindFirstChild("Head")then
            local tCF=CFrame.lookAt(C.CFrame.Position,St.Target.Head.Position)
            C.CFrame=C.CFrame:Lerp(tCF,1-S.AimbotSmoothness)
        end
    end
    
    St.RecoilOffset=St.RecoilOffset:Lerp(Vector3.new(),dt*14)
    St.RecoilRotation=St.RecoilRotation:Lerp(Vector3.new(),dt*12)
    St.ShakeOffset=St.ShakeOffset:Lerp(Vector3.new(),dt*16)
    St.EquipProgress=math.clamp(St.EquipProgress+dt*4,0,1)
    if not St.IsReloading then St.ReloadProgress=math.clamp(St.ReloadProgress+dt*3,0,1)end
    
    C.CFrame=C.CFrame*CFrame.Angles(St.ShakeOffset.X,St.ShakeOffset.Y,St.ShakeOffset.Z)
    
    if St.Viewmodel and St.Viewmodel.PrimaryPart then
        local t=tick()*7
        local sp=hum.RootPart and hum.RootPart.AssemblyLinearVelocity.Magnitude or 0
        local bx=math.cos(t)*.045*math.clamp(sp/16,.1,1)
        local by=math.abs(math.sin(t))*.045*math.clamp(sp/16,.1,1)
        local ea=math.rad((1-St.EquipProgress)*-65)
        local ey=(1-St.EquipProgress)*-1.3
        local po=Vector3.new()
        if St.CurrentTool=="WaterGun"and St.ReloadProgress<1 then
            local pt=math.sin(St.ReloadProgress*math.pi)
            po=Vector3.new(0,-.1*pt,.3*pt)
        end
        local bc=CFrame.new(.55+bx,-.45+by+ey,-1.2)*CFrame.Angles(math.rad(14)+ea,math.rad(-4),0)
        local rc=CFrame.new(St.RecoilOffset+po)*CFrame.Angles(St.RecoilRotation.X,St.RecoilRotation.Y,St.RecoilRotation.Z)
        St.Viewmodel:SetPrimaryPartCFrame(C.CFrame*bc*rc)
    end
end)
