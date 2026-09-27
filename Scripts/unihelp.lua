local P,CG,TS,UIS=game:GetService("Players"),game:GetService("CoreGui"),game:GetService("TweenService"),game:GetService("UserInputService")
local LP=P.LocalPlayer
pcall(function()if CG:FindFirstChild("DeltaMobileGUI")then CG.DeltaMobileGUI:Destroy()end end)
local A,B,B2,B3,T,TD,G,R,W=Color3.fromRGB(88,101,242),Color3.fromRGB(22,23,28),Color3.fromRGB(30,31,38),Color3.fromRGB(38,40,48),Color3.fromRGB(255,255,255),Color3.fromRGB(160,165,180),Color3.fromRGB(59,200,120),Color3.fromRGB(237,66,69),Color3.fromRGB(250,166,26)
local function n(c,p)local i=Instance.new(c)for k,v in pairs(p)do if k~="Parent"then i[k]=v end end if p.Parent then i.Parent=p.Parent end return i end
local function sh(p,t)return n("ImageLabel",{BackgroundTransparency=1,Image="rbxassetid://6014261993",ImageColor3=Color3.new(),ImageTransparency=t or .5,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(49,49,450,450),Size=UDim2.new(1,40,1,40),Position=UDim2.new(0,-20,0,-20),ZIndex=p.ZIndex-1,Parent=p})end
local function tw(o,t,p,s,d)local x=TS:Create(o,TweenInfo.new(t or .3,s or Enum.EasingStyle.Quart,d or Enum.EasingDirection.Out),p)x:Play()return x end
local function drag(f,h)h=h or f local on,di,ds,sp h.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then on=true ds=i.Position sp=f.Position i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then on=false end end)end end)h.InputChanged:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end)UIS.InputChanged:Connect(function(i)if i==di and on then local d=i.Position-ds f.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)end end)end
local SG=n("ScreenGui",{Name="DeltaMobileGUI",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,IgnoreGuiInset=true})
pcall(function()SG.Parent=CG end)if not SG.Parent then SG.Parent=LP:WaitForChild("PlayerGui")end
local M=n("Frame",{Size=UDim2.new(0,340,0,480),Position=UDim2.new(.5,-170,.5,-240),BackgroundColor3=B,BorderSizePixel=0,Active=true,Parent=SG})
n("UICorner",{CornerRadius=UDim.new(0,14),Parent=M})n("UIStroke",{Color=Color3.fromRGB(60,62,75),Thickness=1,Transparency=.3,Parent=M})sh(M,.4)
local bar=n("Frame",{Size=UDim2.new(1,0,0,48),BackgroundColor3=B2,BorderSizePixel=0,Parent=M})
n("UICorner",{CornerRadius=UDim.new(0,14),Parent=bar})n("Frame",{Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,1,-14),BackgroundColor3=B2,BorderSizePixel=0,Parent=bar})
n("TextLabel",{Size=UDim2.new(0,180,0,20),Position=UDim2.new(0,46,0,14),BackgroundTransparency=1,Text="Δ Delta Suite",TextColor3=T,Font=Enum.Font.GothamBold,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,Parent=bar})
local bc=n("Frame",{Size=UDim2.new(0,96,0,28),Position=UDim2.new(1,-104,.5,-14),BackgroundTransparency=1,Parent=bar})
local function wb(c,x,s)local b=n("TextButton",{Size=UDim2.new(0,28,0,28),Position=UDim2.new(0,x,0,0),BackgroundColor3=c,Text=s,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=14,AutoButtonColor=false,Parent=bc})n("UICorner",{CornerRadius=UDim.new(0,8),Parent=b})return b end
local MinBtn,ClsBtn=wb(W,0,"−"),wb(R,34,"✕")
local tabs=n("Frame",{Size=UDim2.new(1,-24,0,34),Position=UDim2.new(0,12,0,58),BackgroundColor3=B2,BorderSizePixel=0,Parent=M})
n("UICorner",{CornerRadius=UDim.new(0,10),Parent=tabs})
local cont=n("Frame",{Size=UDim2.new(1,-24,1,-110),Position=UDim2.new(0,12,0,100),BackgroundTransparency=1,Parent=M})
local function mkTab(txt,pos)local b=n("TextButton",{Size=UDim2.new(.333,-3,1,-6),Position=UDim2.new(pos,0,0,3),BackgroundColor3=B2,Text="",AutoButtonColor=false,Parent=tabs})n("UICorner",{CornerRadius=UDim.new(0,8),Parent=b})n("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=txt,TextColor3=TD,Font=Enum.Font.GothamMedium,TextSize=12,Parent=b})return b end
local tabExp,tabTp,tabSc=mkTab("Explorer",0),mkTab("Teleport",.333),mkTab("Scripts",.666)
local function mkPage(v)return n("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=A,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=v,Parent=cont})end
local pExp,pTp,pSc=mkPage(true),mkPage(false),mkPage(false)
local pgs,btnL={pExp,pTp,pSc},{tabExp,tabTp,tabSc}
local function sw(i)for k,p in ipairs(pgs)do p.Visible=k==i end for k,b in ipairs(btnL)do local l=b:FindFirstChildOfClass("TextLabel")if k==i then tw(b,.2,{BackgroundColor3=A})tw(l,.2,{TextColor3=Color3.new(1,1,1)})else tw(b,.2,{BackgroundColor3=B2})tw(l,.2,{TextColor3=TD})end end end
tabExp.MouseButton1Click:Connect(function()sw(1)end)tabTp.MouseButton1Click:Connect(function()sw(2)end)tabSc.MouseButton1Click:Connect(function()sw(3)end)
-- EXPLORER
local sF=n("Frame",{Size=UDim2.new(1,0,0,34),Position=UDim2.new(0,0,0,4),BackgroundColor3=B2,BorderSizePixel=0,Parent=pExp})
n("UICorner",{CornerRadius=UDim.new(0,8),Parent=sF})n("UIStroke",{Color=Color3.fromRGB(60,62,75),Thickness=1,Transparency=.5,Parent=sF})
n("TextBox",{Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text="",PlaceholderText="🔍 Search...",PlaceholderColor3=TD,TextColor3=T,Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Parent=sF})
local function mBtn(txt,x,c)local b=n("TextButton",{Size=UDim2.new(0,80,0,30),Position=UDim2.new(1,x,0,44),BackgroundColor3=c,Text=txt,TextColor3=T,Font=Enum.Font.GothamMedium,TextSize=12,AutoButtonColor=false,Parent=pExp})n("UICorner",{CornerRadius=UDim.new(0,8),Parent=b})return b end
local refBtn,selfBtn=mBtn("↻ Refresh",-80,A),mBtn("◉ Self",-168,B3)
local treeC=n("Frame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,0,80),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,Parent=pExp})
local selInfo=n("Frame",{Size=UDim2.new(1,0,0,40),Position=UDim2.new(0,0,1,-44),BackgroundColor3=B2,BorderSizePixel=0,Parent=pExp})
n("UICorner",{CornerRadius=UDim.new(0,8),Parent=selInfo})n("UIStroke",{Color=A,Thickness=1,Transparency=.5,Parent=selInfo})
local selLbl=n("TextLabel",{Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,8,0,0),BackgroundTransparency=1,Text="No selection",TextColor3=TD,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Parent=selInfo})
local sel,exp,rowMap=nil,{},{}
local function ico(i)local c=i.ClassName if c=="Folder"then return"📁"elseif c:find("Script")then return"📜"elseif c=="Part"or c=="MeshPart"or c=="UnionOperation"then return"🧱"elseif c=="Model"then return"📦"elseif c:find("Gui")then return"🖼️"elseif c=="Humanoid"then return"🧍"elseif c=="Player"then return"👤"elseif c=="Camera"then return"📷"elseif c:find("Light")then return"💡"elseif c:find("Sound")then return"🔊"elseif c=="Animation"then return"🎬"elseif c:find("Value")then return"🔢"elseif c=="Tool"then return"🔧"else return"⚙️"end end
local function mkRow(inst,dp,pf)
local r=n("Frame",{Size=UDim2.new(1,0,0,26),BackgroundColor3=B2,BackgroundTransparency=1,BorderSizePixel=0,Parent=pf})
local ck=n("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",Parent=r})
local ch=inst:GetChildren()local hc=#ch>0
local ar=n("TextButton",{Size=UDim2.new(0,18,0,18),Position=UDim2.new(0,dp*14+2,.5,-9),BackgroundTransparency=1,Text=hc and(exp[inst]and"▼"or"▶")or" ",TextColor3=TD,Font=Enum.Font.Gotham,TextSize=10,Parent=r})
n("TextLabel",{Size=UDim2.new(0,18,0,18),Position=UDim2.new(0,dp*14+22,.5,-9),BackgroundTransparency=1,Text=ico(inst),TextColor3=T,Font=Enum.Font.Gotham,TextSize=12,Parent=r})
local nm=n("TextLabel",{Size=UDim2.new(1,-(dp*14+90),1,0),Position=UDim2.new(0,dp*14+42,0,0),BackgroundTransparency=1,Text=inst.Name,TextColor3=T,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Parent=r})
local cl=n("TextLabel",{Size=UDim2.new(0,80,1,0),Position=UDim2.new(1,-82,0,0),BackgroundTransparency=1,Text=inst.ClassName,TextColor3=TD,Font=Enum.Font.Gotham,TextSize=9,TextXAlignment=Enum.TextXAlignment.Right,TextTruncate=Enum.TextTruncate.AtEnd,Parent=r})
local cc=n("Frame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,1,0),BackgroundTransparency=1,Visible=exp[inst]or false,AutomaticSize=Enum.AutomaticSize.Y,Parent=r})
local function pop()for _,c in ipairs(cc:GetChildren())do c:Destroy()end for _,c in ipairs(ch)do mkRow(c,dp+1,cc)end end
if exp[inst]then pop()end
ar.MouseButton1Click:Connect(function()if not hc then return end exp[inst]=not exp[inst]ar.Text=exp[inst]and"▼"or"▶"cc.Visible=exp[inst]if exp[inst]and #cc:GetChildren()==0 then pop()end end)
ck.MouseButton1Click:Connect(function()if sel then local o=rowMap[sel]if o then tw(o,.15,{BackgroundTransparency=1})end end sel=inst rowMap[inst]=r tw(r,.15,{BackgroundTransparency=0,BackgroundColor3=A})tw(nm,.15,{TextColor3=Color3.new(1,1,1)})tw(cl,.15,{TextColor3=Color3.fromRGB(220,225,255)})selLbl.Text="✓ "..inst.Name.." ("..inst.ClassName..")"selLbl.TextColor3=T end)
inst:GetPropertyChangedSignal("Name"):Connect(function()nm.Text=inst.Name end)
return r end
local function refresh(root)root=root or game for _,c in ipairs(treeC:GetChildren())do c:Destroy()end exp={}rowMap={}mkRow(root,0,treeC)end
refresh()
refBtn.MouseButton1Click:Connect(function()refresh()tw(refBtn,.1,{BackgroundColor3=G})task.wait(.15)tw(refBtn,.1,{BackgroundColor3=A})end)
selfBtn.MouseButton1Click:Connect(function()refresh(LP)tw(selfBtn,.1,{BackgroundColor3=G})task.wait(.15)tw(selfBtn,.1,{BackgroundColor3=B3})end)
-- TELEPORT
local function sec(t,y,p)n("TextLabel",{Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,4,0,y),BackgroundTransparency=1,Text=t,TextColor3=A,Font=Enum.Font.GothamBold,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=p})end
sec("CFRAME TELEPORT",4,pTp)
local cfB=n("Frame",{Size=UDim2.new(1,0,0,90),Position=UDim2.new(0,0,0,26),BackgroundColor3=B2,BorderSizePixel=0,Parent=pTp})
n("UICorner",{CornerRadius=UDim.new(0,10),Parent=cfB})n("UIStroke",{Color=Color3.fromRGB(60,62,75),Thickness=1,Transparency=.5,Parent=cfB})
local cfIn=n("TextBox",{Size=UDim2.new(1,-20,1,-20),Position=UDim2.new(0,10,0,10),BackgroundTransparency=1,Text="666.720703, 29.0016327, -145.90947, -0.906296611, 0, 0.422642082, 0, 1, 0, -0.422642082, 0, -0.906296611",TextColor3=T,Font=Enum.Font.Code,TextSize=10,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,ClearTextOnFocus=false,MultiLine=true,Parent=cfB})
local tpB=n("TextButton",{Size=UDim2.new(1,0,0,36),Position=UDim2.new(0,0,0,124),BackgroundColor3=A,Text="⚡ Teleport to CFrame",TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=13,AutoButtonColor=false,Parent=pTp})
n("UICorner",{CornerRadius=UDim.new(0,10),Parent=tpB})sh(tpB,.7)
local function parse(s)local t={}for x in s:gmatch("[-]?%d+%.?%d*")do t[#t+1]=tonumber(x)end if #t>=3 then local p=Vector3.new(t[1],t[2],t[3])if #t>=12 then return CFrame.new(p,p+Vector3.new(t[4],t[5],t[6]))end return CFrame.new(p)end return nil end
tpB.MouseButton1Click:Connect(function()local cf=parse(cfIn.Text)local ch=LP.Character if cf and ch and ch:FindFirstChild("HumanoidRootPart")then ch.HumanoidRootPart.CFrame=cf tw(tpB,.1,{BackgroundColor3=G})tpB.Text="✓ Teleported!"task.wait(.5)tw(tpB,.15,{BackgroundColor3=A})tpB.Text="⚡ Teleport to CFrame"else tw(tpB,.1,{BackgroundColor3=R})tpB.Text="✕ Invalid CFrame"task.wait(.8)tw(tpB,.15,{BackgroundColor3=A})tpB.Text="⚡ Teleport to CFrame"end end)
sec("TELEPORT TO SELECTED PART",174,pTp)
local spF=n("Frame",{Size=UDim2.new(1,0,0,40),Position=UDim2.new(0,0,0,196),BackgroundColor3=B2,BorderSizePixel=0,Parent=pTp})
n("UICorner",{CornerRadius=UDim.new(0,10),Parent=spF})n("UIStroke",{Color=Color3.fromRGB(60,62,75),Thickness=1,Transparency=.5,Parent=spF})
local spN=n("TextLabel",{Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text="No part selected in Explorer",TextColor3=TD,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Parent=spF})
local tpP=n("TextButton",{Size=UDim2.new(1,0,0,36),Position=UDim2.new(0,0,0,246),BackgroundColor3=B2,Text="🎯 Teleport to Selected Part",TextColor3=T,Font=Enum.Font.GothamBold,TextSize=13,AutoButtonColor=false,Parent=pTp})
n("UICorner",{CornerRadius=UDim.new(0,10),Parent=tpP})n("UIStroke",{Color=A,Thickness=1,Transparency=.3,Parent=tpP})
tpP.MouseButton1Click:Connect(function()local i=sel if not i then tw(tpP,.1,{BackgroundColor3=R})tpP.Text="✕ No part selected"task.wait(.8)tw(tpP,.15,{BackgroundColor3=B2})tpP.Text="🎯 Teleport to Selected Part"return end
local tg if i:IsA("BasePart")then tg=i elseif i:IsA("Model")then tg=i:FindFirstChildWhichIsA("BasePart")or i.PrimaryPart elseif i:IsA("Humanoid")then tg=i.Parent:FindFirstChild("HumanoidRootPart")end
if tg then local ch=LP.Character if ch and ch:FindFirstChild("HumanoidRootPart")then ch.HumanoidRootPart.CFrame=tg.CFrame+Vector3.new(0,3,0)tw(tpP,.1,{BackgroundColor3=G})tpP.Text="✓ Teleported to "..i.Name task.wait(1)tw(tpP,.15,{BackgroundColor3=B2})tpP.Text="🎯 Teleport to Selected Part"end
else tw(tpP,.1,{BackgroundColor3=R})tpP.Text="✕ Not teleportable"task.wait(.8)tw(tpP,.15,{BackgroundColor3=B2})tpP.Text="🎯 Teleport to Selected Part"end end)
task.spawn(function()while task.wait(.3)do if sel then spN.Text="Selected: "..sel.Name.." ("..sel.ClassName..")"spN.TextColor3=T else spN.Text="No part selected in Explorer"spN.TextColor3=TD end end end)
-- SCRIPTS
sec("QUICK EXECUTE",4,pSc)
local qs={
{"Infinite Yield","Admin commands suite","loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()",A},
{"Dex Explorer","Advanced instance explorer","loadstring(game:HttpGet('https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua'))()",Color3.fromRGB(155,89,182)},
{"Simple Spy","Remote event logger","loadstring(game:HttpGet('https://raw.githubusercontent.com/07test/scripts/main/SimpleSpy.lua'))()",Color3.fromRGB(46,204,113)},
{"UniHelp","Universal helper script","loadstring(game:HttpGet('https://raw.githubusercontent.com/waveexecutors/Scripts-Source/main/Scripts/unihelp.lua'))()",Color3.fromRGB(120,90,255)},
{"Rejoin","Rejoin current server","game:GetService('TeleportService'):Teleport(game.PlaceId,game.Players.LocalPlayer)",Color3.fromRGB(241,196,15)},
{"Fullbright","See in the dark","game:GetService('Lighting').Brightness=3 game:GetService('Lighting').ClockTime=12 game:GetService('Lighting').FogEnd=100000",Color3.fromRGB(52,152,219)},
}
for i,d in ipairs(qs)do
local c=n("TextButton",{Size=UDim2.new(1,0,0,56),Position=UDim2.new(0,0,0,26+(i-1)*62),BackgroundColor3=B2,Text="",AutoButtonColor=false,Parent=pSc})
n("UICorner",{CornerRadius=UDim.new(0,10),Parent=c})n("UIStroke",{Color=Color3.fromRGB(60,62,75),Thickness=1,Transparency=.5,Parent=c})
n("Frame",{Size=UDim2.new(0,4,1,-16),Position=UDim2.new(0,8,0,8),BackgroundColor3=d[4],BorderSizePixel=0,Parent=c}).Parent=c
n("TextLabel",{Size=UDim2.new(1,-70,0,18),Position=UDim2.new(0,20,0,8),BackgroundTransparency=1,Text=d[1],TextColor3=T,Font=Enum.Font.GothamBold,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=c})
n("TextLabel",{Size=UDim2.new(1,-70,0,14),Position=UDim2.new(0,20,0,28),BackgroundTransparency=1,Text=d[2],TextColor3=TD,Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=c})
local e=n("TextButton",{Size=UDim2.new(0,44,0,28),Position=UDim2.new(1,-52,.5,-14),BackgroundColor3=d[4],Text="▶",TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=14,AutoButtonColor=false,Parent=c})
n("UICorner",{CornerRadius=UDim.new(0,8),Parent=e})
e.MouseButton1Click:Connect(function()tw(e,.1,{BackgroundColor3=G,Text="✓"})local ok=pcall(function()loadstring(d[3])()end)if not ok then tw(e,.1,{BackgroundColor3=R,Text="✕"})end task.wait(.8)tw(e,.15,{BackgroundColor3=d[4],Text="▶"})end)
end
sec("CUSTOM SCRIPT",26+#qs*62+10,pSc)
local cB=n("Frame",{Size=UDim2.new(1,0,0,100),Position=UDim2.new(0,0,0,26+#qs*62+36),BackgroundColor3=B2,BorderSizePixel=0,Parent=pSc})
n("UICorner",{CornerRadius=UDim.new(0,10),Parent=cB})n("UIStroke",{Color=Color3.fromRGB(60,62,75),Thickness=1,Transparency=.5,Parent=cB})
local cIn=n("TextBox",{Size=UDim2.new(1,-20,1,-20),Position=UDim2.new(0,10,0,10),BackgroundTransparency=1,Text="",PlaceholderText="-- Lua here...",PlaceholderColor3=TD,TextColor3=T,Font=Enum.Font.Code,TextSize=11,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,ClearTextOnFocus=false,MultiLine=true,Parent=cB})
local ec=n("TextButton",{Size=UDim2.new(1,0,0,36),Position=UDim2.new(0,0,0,26+#qs*62+142),BackgroundColor3=A,Text="▶ Execute",TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=13,AutoButtonColor=false,Parent=pSc})
n("UICorner",{CornerRadius=UDim.new(0,10),Parent=ec})sh(ec,.7)
ec.MouseButton1Click:Connect(function()if cIn.Text==""then return end local ok=pcall(function()loadstring(cIn.Text)()end)tw(ec,.1,{BackgroundColor3=ok and G or R,Text=ok and"✓ Executed!"or"✕ Error"})task.wait(1)tw(ec,.15,{BackgroundColor3=A,Text="▶ Execute"})end)
-- MIN/CLOSE/DRAG
local min=false local fi
ClsBtn.MouseButton1Click:Connect(function()tw(M,.25,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(.5,0,.5,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In)task.wait(.25)SG:Destroy()end)
MinBtn.MouseButton1Click:Connect(function()if min then return end min=true
tw(M,.3,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0,M.AbsolutePosition.X+170,0,M.AbsolutePosition.Y+240),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In)task.wait(.15)
fi=n("TextButton",{Size=UDim2.new(0,50,0,50),Position=UDim2.new(0,20,.5,-25),BackgroundColor3=A,Text="Δ",TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=22,AutoButtonColor=false,Parent=SG})
n("UICorner",{CornerRadius=UDim.new(0,25),Parent=fi})sh(fi,.5)
task.spawn(function()while fi and fi.Parent do tw(fi,1,{Size=UDim2.new(0,54,0,54),Position=UDim2.new(0,18,.5,-27)},Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)task.wait(1)tw(fi,1,{Size=UDim2.new(0,50,0,50),Position=UDim2.new(0,20,.5,-25)},Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)task.wait(1)end end)
drag(fi)
fi.MouseButton1Click:Connect(function()if not min then return end min=false tw(fi,.2,{Size=UDim2.new(0,0,0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In)task.wait(.15)if fi then fi:Destroy()end M.Visible=true M.BackgroundTransparency=1 tw(M,.3,{Size=UDim2.new(0,340,0,480),Position=UDim2.new(.5,-170,.5,-240),BackgroundTransparency=0},Enum.EasingStyle.Back,Enum.EasingDirection.Out)end)end)
drag(M,bar)
M.Size=UDim2.new(0,0,0,0)M.Position=UDim2.new(.5,0,.5,0)task.wait(.05)
tw(M,.4,{Size=UDim2.new(0,340,0,480),Position=UDim2.new(.5,-170,.5,-240)},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
if workspace.CurrentCamera.ViewportSize.X<400 then M.Size=UDim2.new(0,320,0,440)M.Position=UDim2.new(.5,-160,.5,-220)end
print("[Delta Suite] Loaded!")
