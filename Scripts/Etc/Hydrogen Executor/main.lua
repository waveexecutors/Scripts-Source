-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Paleta de Cores Suaves (Modo Escuro Agradável aos Olhos)
local Color_Background = Color3.fromRGB(15, 15, 18)
local Color_Element = Color3.fromRGB(24, 24, 28)
local Color_Text_Primary = Color3.fromRGB(240, 240, 245)
local Color_Text_Secondary = Color3.fromRGB(160, 160, 170)
local Color_Stroke = Color3.fromRGB(45, 45, 52)
local Color_Accent_Positive = Color3.fromRGB(40, 140, 75)
local Color_Accent_Negative = Color3.fromRGB(160, 45, 45)
local Color_Accent_Blue = Color3.fromRGB(45, 110, 180)

-- Parent ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HydrogenMobileUI_Ultimate_V3"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end

-- Blur Effect setup
local Blur = Lighting:FindFirstChild("HydrogenBlur")
if not Blur then
    Blur = Instance.new("BlurEffect")
    Blur.Name = "HydrogenBlur"
    Blur.Size = 0
    Blur.Enabled = false
    Blur.Parent = Lighting
end

-- Função para arrastar (Draggable com animação suave)
local function makeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
        TweenService:Create(frame, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = newPos}):Play()
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- System Dynamic Toast Notification
local function createToast(message)
    local toast = Instance.new("Frame")
    toast.Name = "Toast"
    toast.Size = UDim2.new(0, 250, 0, 40)
    toast.Position = UDim2.new(0.5, -125, 0.85, 0)
    toast.BackgroundColor3 = Color_Element
    toast.BorderSizePixel = 0
    toast.ZIndex = 50
    toast.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toast

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color_Stroke
    stroke.Thickness = 1.2
    stroke.Parent = toast

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Color_Text_Primary
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.ZIndex = 51
    label.Parent = toast

    toast.Transparency = 1
    label.TextTransparency = 1

    TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.05}):Play()
    TweenService:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

    task.delay(2.2, function()
        local tweenOut = TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        TweenService:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            toast:Destroy()
        end)
    end)
end

-- === Loading Screen Toast Central ===
local LoadingToast = Instance.new("Frame")
LoadingToast.Name = "LoadingToast"
LoadingToast.Size = UDim2.new(0, 320, 0, 110)
LoadingToast.Position = UDim2.new(0.5, -160, 0.42, 0)
LoadingToast.BackgroundColor3 = Color_Element
LoadingToast.BorderSizePixel = 0
LoadingToast.ZIndex = 100
LoadingToast.Parent = ScreenGui

local ltCorner = Instance.new("UICorner")
ltCorner.CornerRadius = UDim.new(0, 16)
ltCorner.Parent = LoadingToast

local ltStroke = Instance.new("UIStroke")
ltStroke.Color = Color_Stroke
ltStroke.Thickness = 2
ltStroke.Parent = LoadingToast

local ltLabel = Instance.new("TextLabel")
ltLabel.Size = UDim2.new(1, -20, 0, 30)
ltLabel.Position = UDim2.new(0, 10, 0, 15)
ltLabel.BackgroundTransparency = 1
ltLabel.Text = "Hydrogen Executor Loading..."
ltLabel.TextColor3 = Color_Text_Primary
ltLabel.Font = Enum.Font.GothamBold
ltLabel.TextSize = 16
ltLabel.ZIndex = 101
ltLabel.Parent = LoadingToast

local ltLabel2 = Instance.new("TextLabel")
ltLabel2.Size = UDim2.new(1, -20, 0, 20)
ltLabel2.Position = UDim2.new(0, 10, 0, 42)
ltLabel2.BackgroundTransparency = 1
ltLabel2.Text = "Remove competing interfaces (Delta)?"
ltLabel2.TextColor3 = Color_Text_Secondary
ltLabel2.Font = Enum.Font.Gotham
ltLabel2.TextSize = 12
ltLabel2.ZIndex = 101
ltLabel2.Parent = LoadingToast

local ltKillDeltaBtn = Instance.new("TextButton")
ltKillDeltaBtn.Size = UDim2.new(0, 110, 0, 30)
ltKillDeltaBtn.Position = UDim2.new(0.5, -55, 0, 68)
ltKillDeltaBtn.BackgroundColor3 = Color_Accent_Negative
ltKillDeltaBtn.Text = "Remove"
ltKillDeltaBtn.TextColor3 = Color_Text_Primary
ltKillDeltaBtn.Font = Enum.Font.GothamBold
ltKillDeltaBtn.TextSize = 12
ltKillDeltaBtn.ZIndex = 101
ltKillDeltaBtn.Parent = LoadingToast

local ltkbCorner = Instance.new("UICorner")
ltkbCorner.CornerRadius = UDim.new(0, 8)
ltkbCorner.Parent = ltKillDeltaBtn

local finishLoading = function()
    ToggleButton.Visible = true
    MainFrame.Visible = true
    isOpen = true
    Blur.Enabled = true
    Blur.Size = 16
    if LoadingToast then LoadingToast:Destroy() end
end

ltKillDeltaBtn.MouseButton1Click:Connect(function()
    ltKillDeltaBtn.Text = "Removing..."
    pcall(function()
        for _,v in pairs(gethui():GetChildren()) do 
            if v:IsA("ScreenGui") and v ~= ScreenGui and v:FindFirstChild("Executor", true) then 
                v:Destroy() 
            end 
        end
    end)
    task.wait(0.5)
    finishLoading()
end)

task.delay(4, function()
    if LoadingToast and LoadingToast.Parent then
        finishLoading()
    end
end)

-- 1. Ícone Flutuante (Ícone de Gota D'água Bem Mais Poucinho Grande: 64x64)
ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "HydrogenToggle"
ToggleButton.Size = UDim2.new(0, 64, 0, 64) -- Levemente maior que os 56px anteriores
ToggleButton.Position = UDim2.new(0.04, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color_Background
ToggleButton.Visible = false
ToggleButton.Parent = ScreenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = ToggleButton

local toggleImage = Instance.new("ImageLabel")
toggleImage.Size = UDim2.new(0, 30, 0, 30) -- Ícone de gota interno proporcional
toggleImage.Position = UDim2.new(0.5, -15, 0.5, -15)
toggleImage.BackgroundTransparency = 1
toggleImage.Image = "rbxassetid://14384012061"
toggleImage.Parent = ToggleButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color_Stroke
toggleStroke.Thickness = 2
toggleStroke.Parent = ToggleButton

makeDraggable(ToggleButton)

-- 2. Main Frame Executor (Interface um Pouquinho Mais Grande: 520x310)
MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 310)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -155)
MainFrame.BackgroundColor3 = Color_Element
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 20)
mainCorner.Parent = MainFrame

local mainShadow = Instance.new("UIStroke")
mainShadow.Color = Color_Stroke
mainShadow.Thickness = 2
mainShadow.Parent = MainFrame

makeDraggable(MainFrame)

-- Controlador de Abertura/Fechamento Animado
isOpen = true
local function toggleGUI()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        Blur.Enabled = true
        TweenService:Create(Blur, TweenInfo.new(0.35), {Size = 16}):Play()
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 520, 0, 310),
            Position = UDim2.new(0.5, -260, 0.5, -155)
        }):Play()
    else
        TweenService:Create(Blur, TweenInfo.new(0.25), {Size = 0}):Play()
        local scaleTween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        scaleTween:Play()
        scaleTween.Completed:Connect(function()
            if not isOpen then
                MainFrame.Visible = false
                Blur.Enabled = false
            end
        end)
    end
end

ToggleButton.MouseButton1Click:Connect(toggleGUI)

-- Header Logo Mantida & Título
Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 38, 0, 38)
Logo.Position = UDim2.new(0, 18, 0, 14)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://14384012061" -- MANTIDO ÍCONE PRINCIPAL
Logo.Parent = MainFrame

Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 220, 0, 24)
Title.Position = UDim2.new(0, 64, 0, 12)
Title.BackgroundTransparency = 1
Title.Text = "Hydrogen Executor"
Title.TextColor3 = Color_Text_Primary
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

CurrentTabLabel = Instance.new("TextLabel")
CurrentTabLabel.Size = UDim2.new(0, 220, 0, 16)
CurrentTabLabel.Position = UDim2.new(0, 64, 0, 34)
CurrentTabLabel.BackgroundTransparency = 1
CurrentTabLabel.Text = "Tab: Editor"
CurrentTabLabel.TextColor3 = Color_Text_Secondary
CurrentTabLabel.Font = Enum.Font.Gotham
CurrentTabLabel.TextSize = 12
CurrentTabLabel.TextXAlignment = Enum.TextXAlignment.Left
CurrentTabLabel.Parent = MainFrame

-- === TEXTO DE PESSOAS ATIVAS USANDO O SCRIPT AGORA ===
local ActiveUsersLabel = Instance.new("TextLabel")
ActiveUsersLabel.Size = UDim2.new(0, 200, 0, 20)
ActiveUsersLabel.Position = UDim2.new(1, -270, 0, 14)
ActiveUsersLabel.BackgroundTransparency = 1
ActiveUsersLabel.Text = "🟢 Pessoas ativas: ..."
ActiveUsersLabel.TextColor3 = Color3.fromRGB(100, 220, 130)
ActiveUsersLabel.Font = Enum.Font.GothamMedium
ActiveUsersLabel.TextSize = 11
ActiveUsersLabel.TextXAlignment = Enum.TextXAlignment.Right
ActiveUsersLabel.Parent = MainFrame

-- Simulação/Busca dinâmica do número de pessoas ativas
task.spawn(function()
    local baseCount = math.random(410, 580)
    while true do
        local fluctuation = math.random(-5, 7)
        baseCount = math.clamp(baseCount + fluctuation, 350, 950)
        ActiveUsersLabel.Text = "🟢 Pessoas ativas: " .. baseCount
        task.wait(6)
    end
end)

--- CONTAINER DAS PÁGINAS (Aumentado)
PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(0, 360, 0, 175)
PageContainer.Position = UDim2.new(0, 18, 0, 62)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

-- 1. EDITOR PAGE
EditorPage = Instance.new("Frame")
EditorPage.Size = UDim2.new(1, 0, 1, 0)
EditorPage.BackgroundTransparency = 1
EditorPage.Parent = PageContainer

ScriptBox = Instance.new("TextBox")
ScriptBox.Size = UDim2.new(1, 0, 1, 0)
ScriptBox.BackgroundColor3 = Color_Background
ScriptBox.Text = ""
ScriptBox.PlaceholderText = "-- Cole seu script aqui..."
ScriptBox.PlaceholderColor3 = Color_Text_Secondary
ScriptBox.TextColor3 = Color_Text_Primary
ScriptBox.Font = Enum.Font.Code
ScriptBox.TextSize = 13
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptBox.ClearTextOnFocus = false
ScriptBox.MultiLine = true
ScriptBox.Parent = EditorPage

local editorCorner = Instance.new("UICorner")
editorCorner.CornerRadius = UDim.new(0, 12)
editorCorner.Parent = ScriptBox

local boxPadding = Instance.new("UIPadding")
boxPadding.PaddingTop = UDim.new(0, 10)
boxPadding.PaddingLeft = UDim.new(0, 10)
boxPadding.PaddingRight = UDim.new(0, 10)
boxPadding.Parent = ScriptBox

-- 2. SCRIPT HUB PAGE (Múltiplas APIs Escolhiveis)
ScriptHubPage = Instance.new("Frame")
ScriptHubPage.Size = UDim2.new(1, 0, 1, 0)
ScriptHubPage.BackgroundTransparency = 1
ScriptHubPage.Visible = false
ScriptHubPage.Parent = PageContainer

-- Seletor de API (Dropdown / Botão Alternador)
local selectedApi = "ScriptBlox"
local apiOptions = {"ScriptBlox", "RiiFT / Hub API", "RbxScripts", "GitHub Repos"}

local ApiSelectBtn = Instance.new("TextButton")
ApiSelectBtn.Size = UDim2.new(0, 110, 0, 28)
ApiSelectBtn.Position = UDim2.new(0, 0, 0, 0)
ApiSelectBtn.BackgroundColor3 = Color_Background
ApiSelectBtn.Text = "API: ScriptBlox"
ApiSelectBtn.TextColor3 = Color_Text_Primary
ApiSelectBtn.Font = Enum.Font.GothamMedium
ApiSelectBtn.TextSize = 11
ApiSelectBtn.Parent = ScriptHubPage

local apiCorner = Instance.new("UICorner")
apiCorner.CornerRadius = UDim.new(0, 8)
apiCorner.Parent = ApiSelectBtn

local apiIndex = 1
ApiSelectBtn.MouseButton1Click:Connect(function()
    apiIndex = (apiIndex % #apiOptions) + 1
    selectedApi = apiOptions[apiIndex]
    ApiSelectBtn.Text = "API: " .. selectedApi
    createToast("API alterada para: " .. selectedApi)
end)

SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -118, 0, 28)
SearchBox.Position = UDim2.new(0, 118, 0, 0)
SearchBox.BackgroundColor3 = Color_Background
SearchBox.PlaceholderText = "Buscar scripts na API selecionada..."
SearchBox.PlaceholderColor3 = Color_Text_Secondary
SearchBox.Text = ""
SearchBox.TextColor3 = Color_Text_Primary
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 12
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = ScriptHubPage

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 8)
searchCorner.Parent = SearchBox

HubScroll = Instance.new("ScrollingFrame")
HubScroll.Size = UDim2.new(1, 0, 1, -36)
HubScroll.Position = UDim2.new(0, 0, 0, 36)
HubScroll.BackgroundColor3 = Color_Background
HubScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
HubScroll.ScrollBarThickness = 4
HubScroll.Parent = ScriptHubPage

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 10)
hubCorner.Parent = HubScroll

local hubLayout = Instance.new("UIListLayout")
hubLayout.Padding = UDim.new(0, 5)
hubLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
hubLayout.Parent = HubScroll

-- Função para busca em Múltiplas APIs
local function fetchScriptsFromApi(query)
    for _, child in ipairs(HubScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    task.spawn(function()
        local scriptsList = {}
        local success, err = pcall(function()
            if selectedApi == "ScriptBlox" then
                local url = "https://scriptblox.com/api/script/search?q=" .. HttpService:UrlEncode(query)
                local res = game:HttpGet(url)
                local json = HttpService:JSONDecode(res)
                if json and json.result and json.result.scripts then
                    for _, s in ipairs(json.result.scripts) do
                        table.insert(scriptsList, {title = s.title, script = s.script})
                    end
                end
            elseif selectedApi == "RiiFT / Hub API" or selectedApi == "RbxScripts" then
                local url = "https://raw.githubusercontent.com/site-scripts-api/index/main/scripts.json"
                local res = game:HttpGet(url)
                local json = HttpService:JSONDecode(res)
                for _, s in ipairs(json) do
                    if string.find(string.lower(s.title or ""), string.lower(query)) then
                        table.insert(scriptsList, {title = s.title, script = s.code})
                    end
                end
            else -- GitHub Repos API
                local url = "https://api.github.com/search/code?q=" .. HttpService:UrlEncode(query .. "+extension:lua")
                local res = game:HttpGet(url)
                local json = HttpService:JSONDecode(res)
                if json and json.items then
                    for _, item in ipairs(json.items) do
                        table.insert(scriptsList, {title = item.name, script = 'loadstring(game:HttpGet("' .. item.html_url .. '"))()'})
                    end
                end
            end
        end)
        
        if success and #scriptsList > 0 then
            HubScroll.CanvasSize = UDim2.new(0, 0, 0, #scriptsList * 42)
            for _, scr in ipairs(scriptsList) do
                local item = Instance.new("Frame")
                item.Size = UDim2.new(0.95, 0, 0, 36)
                item.BackgroundColor3 = Color_Element
                item.Parent = HubScroll
                
                local itemCorner = Instance.new("UICorner")
                itemCorner.CornerRadius = UDim.new(0, 6)
                itemCorner.Parent = item
                
                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(0.7, 0, 1, 0)
                titleLbl.Position = UDim2.new(0, 8, 0, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Text = scr.title or "Script Sem Nome"
                titleLbl.TextColor3 = Color_Text_Primary
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 11
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = item
                
                local loadBtn = Instance.new("TextButton")
                loadBtn.Size = UDim2.new(0, 70, 0, 24)
                loadBtn.Position = UDim2.new(1, -75, 0.5, -12)
                loadBtn.BackgroundColor3 = Color_Accent_Blue
                loadBtn.Text = "Carregar"
                loadBtn.TextColor3 = Color_Text_Primary
                loadBtn.Font = Enum.Font.GothamBold
                loadBtn.TextSize = 10
                loadBtn.Parent = item
                
                local btnC = Instance.new("UICorner")
                btnC.CornerRadius = UDim.new(0, 4)
                btnC.Parent = loadBtn
                
                loadBtn.MouseButton1Click:Connect(function()
                    if scr.script then
                        ScriptBox.Text = scr.script
                        EditorPage.Visible = true
                        ScriptHubPage.Visible = false
                        CurrentTabLabel.Text = "Tab: Editor"
                        createToast("Script carregado no Editor!")
                    end
                end)
            end
        else
            createToast("Nenhum resultado na API " .. selectedApi)
        end
    end)
end

SearchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and SearchBox.Text ~= "" then
        fetchScriptsFromApi(SearchBox.Text)
    end
end)

-- 3. SAVES SCRIPTS PAGE
SavesPage = Instance.new("Frame")
SavesPage.Size = UDim2.new(1, 0, 1, 0)
SavesPage.BackgroundTransparency = 1
SavesPage.Visible = false
SavesPage.Parent = PageContainer

SaveNameBox = Instance.new("TextBox")
SaveNameBox.Size = UDim2.new(0.7, 0, 0, 28)
SaveNameBox.BackgroundColor3 = Color_Background
SaveNameBox.PlaceholderText = "Nome do script..."
SaveNameBox.PlaceholderColor3 = Color_Text_Secondary
SaveNameBox.Text = ""
SaveNameBox.TextColor3 = Color_Text_Primary
SaveNameBox.Font = Enum.Font.Gotham
SaveNameBox.TextSize = 12
SaveNameBox.ClearTextOnFocus = false
SaveNameBox.Parent = SavesPage

local snbCorner = Instance.new("UICorner")
snbCorner.CornerRadius = UDim.new(0, 8)
snbCorner.Parent = SaveNameBox

SaveCurrentBtn = Instance.new("TextButton")
SaveCurrentBtn.Size = UDim2.new(0.26, 0, 0, 28)
SaveCurrentBtn.Position = UDim2.new(0.74, 0, 0, 0)
SaveCurrentBtn.BackgroundColor3 = Color_Accent_Positive
SaveCurrentBtn.Text = "Salvar"
SaveCurrentBtn.TextColor3 = Color_Text_Primary
SaveCurrentBtn.Font = Enum.Font.GothamBold
SaveCurrentBtn.TextSize = 11
SaveCurrentBtn.Parent = SavesPage

local scbCorner = Instance.new("UICorner")
scbCorner.CornerRadius = UDim.new(0, 8)
scbCorner.Parent = SaveCurrentBtn

SavesScroll = Instance.new("ScrollingFrame")
SavesScroll.Size = UDim2.new(1, 0, 1, -36)
SavesScroll.Position = UDim2.new(0, 0, 0, 36)
SavesScroll.BackgroundColor3 = Color_Background
SavesScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
SavesScroll.ScrollBarThickness = 4
SavesScroll.Parent = SavesPage

local savesCorner = Instance.new("UICorner")
savesCorner.CornerRadius = UDim.new(0, 10)
savesCorner.Parent = SavesScroll

local savesListLayout = Instance.new("UIListLayout")
savesListLayout.Padding = UDim.new(0, 5)
savesListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
savesListLayout.Parent = SavesScroll

savedScriptsTable = {}

local function refreshSavesList()
    for _, child in ipairs(SavesScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local count = 0
    for _ in pairs(savedScriptsTable) do count = count + 1 end
    SavesScroll.CanvasSize = UDim2.new(0, 0, 0, count * 38)
    
    for name, code in pairs(savedScriptsTable) do
        local item = Instance.new("Frame")
        item.Size = UDim2.new(0.95, 0, 0, 34)
        item.BackgroundColor3 = Color_Element
        item.Parent = SavesScroll
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 6)
        itemCorner.Parent = item
        
        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(0.55, 0, 1, 0)
        titleLbl.Position = UDim2.new(0, 8, 0, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = name
        titleLbl.TextColor3 = Color_Text_Primary
        titleLbl.Font = Enum.Font.GothamMedium
        titleLbl.TextSize = 11
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Parent = item
        
        local loadBtn = Instance.new("TextButton")
        loadBtn.Size = UDim2.new(0, 50, 0, 22)
        loadBtn.Position = UDim2.new(1, -108, 0.5, -11)
        loadBtn.BackgroundColor3 = Color_Accent_Blue
        loadBtn.Text = "Usar"
        loadBtn.TextColor3 = Color_Text_Primary
        loadBtn.Font = Enum.Font.GothamBold
        loadBtn.TextSize = 10
        loadBtn.Parent = item
        
        local lbC = Instance.new("UICorner")
        lbC.CornerRadius = UDim.new(0, 4)
        lbC.Parent = loadBtn
        
        loadBtn.MouseButton1Click:Connect(function()
            ScriptBox.Text = code
            EditorPage.Visible = true
            SavesPage.Visible = false
            CurrentTabLabel.Text = "Tab: Editor"
            createToast("Carregado '" .. name .. "'!")
        end)
        
        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 50, 0, 22)
        delBtn.Position = UDim2.new(1, -54, 0.5, -11)
        delBtn.BackgroundColor3 = Color_Accent_Negative
        delBtn.Text = "Del"
        delBtn.TextColor3 = Color_Text_Primary
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 10
        delBtn.Parent = item
        
        local dbC = Instance.new("UICorner")
        dbC.CornerRadius = UDim.new(0, 4)
        dbC.Parent = delBtn
        
        delBtn.MouseButton1Click:Connect(function()
            savedScriptsTable[name] = nil
            pcall(function()
                if writefile then writefile("HydrogenSavedScripts.json", HttpService:JSONEncode(savedScriptsTable)) end
            end)
            refreshSavesList()
            createToast("Deletado '" .. name .. "'")
        end)
    end
end

SaveCurrentBtn.MouseButton1Click:Connect(function()
    local sName = SaveNameBox.Text
    if sName ~= "" and ScriptBox.Text ~= "" then
        savedScriptsTable[sName] = ScriptBox.Text
        pcall(function()
            if writefile then writefile("HydrogenSavedScripts.json", HttpService:JSONEncode(savedScriptsTable)) end
        end)
        SaveNameBox.Text = ""
        refreshSavesList()
        createToast("Script salvo!")
    end
end)

-- 4. SETTINGS PAGE (Com Unlock FPS Real Funcional)
SettingsPage = Instance.new("Frame")
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = PageContainer

ConfigsScroll = Instance.new("ScrollingFrame")
ConfigsScroll.Size = UDim2.new(1, 0, 1, 0)
ConfigsScroll.BackgroundColor3 = Color_Background
ConfigsScroll.CanvasSize = UDim2.new(0, 0, 0, 280)
ConfigsScroll.ScrollBarThickness = 4
ConfigsScroll.Parent = SettingsPage

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 12)
settingsCorner.Parent = ConfigsScroll

local setListLayout = Instance.new("UIListLayout")
setListLayout.Padding = UDim.new(0, 6)
setListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
setListLayout.Parent = ConfigsScroll

local setScrollPadding = Instance.new("UIPadding")
setScrollPadding.PaddingTop = UDim.new(0, 8)
setScrollPadding.Parent = ConfigsScroll

local function addConfigToggle(name, defaultState, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0.94, 0, 0, 32)
    f.BackgroundColor3 = Color_Element
    f.Parent = ConfigsScroll
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = f
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.65, 0, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = Color_Text_Primary
    l.Font = Enum.Font.GothamMedium
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 55, 0, 22)
    b.Position = UDim2.new(1, -62, 0.5, -11)
    b.BackgroundColor3 = defaultState and Color_Accent_Positive or Color_Accent_Negative
    b.Text = defaultState and "ON" or "OFF"
    b.TextColor3 = Color_Text_Primary
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.Parent = f
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = b
    
    local state = defaultState
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = state and "ON" or "OFF"
        b.BackgroundColor3 = state and Color_Accent_Positive or Color_Accent_Negative
        callback(state)
    end)
end

-- === UNLOCK FPS REAL E FUNCIONAL ===
local function applyUnlockFPS(state)
    if state then
        if setfpscap then setfpscap(999)
        elseif set_fps_cap then set_fps_cap(999)
        elseif setfpslimit then setfpslimit(999)
        end
        createToast("FPS Destravado (Sem Limite)")
    else
        if setfpscap then setfpscap(60)
        elseif set_fps_cap then set_fps_cap(60)
        elseif setfpslimit then setfpslimit(60)
        end
        createToast("FPS Limitado em 60")
    end
end

addConfigToggle("Unlock FPS Real", true, function(state)
    applyUnlockFPS(state)
end)
applyUnlockFPS(true) -- Ativa o Unlock FPS nativamente no carregamento

addConfigToggle("Anti-AFK Bypass", true, function(state)
    if state then
        local vu = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
        createToast("Anti-AFK Ativado")
    end
end)

-- 5. ACCOUNT PAGE
AccountPage = Instance.new("Frame")
AccountPage.Size = UDim2.new(1, 0, 1, 0)
AccountPage.BackgroundTransparency = 1
AccountPage.Visible = false
AccountPage.Parent = PageContainer

AccountScroll = Instance.new("ScrollingFrame")
AccountScroll.Size = UDim2.new(1, 0, 1, 0)
AccountScroll.BackgroundColor3 = Color_Background
AccountScroll.CanvasSize = UDim2.new(0, 0, 0, 200)
AccountScroll.ScrollBarThickness = 4
AccountScroll.Parent = AccountPage

local accCorner = Instance.new("UICorner")
accCorner.CornerRadius = UDim.new(0, 12)
accCorner.Parent = AccountScroll

local accListLayout = Instance.new("UIListLayout")
accListLayout.Padding = UDim.new(0, 8)
accListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
accListLayout.Parent = AccountScroll

local accScrollPadding = Instance.new("UIPadding")
accScrollPadding.PaddingTop = UDim.new(0, 10)
accScrollPadding.Parent = AccountScroll

local robloxInfo = Instance.new("TextLabel")
robloxInfo.Size = UDim2.new(0.94, 0, 0, 55)
robloxInfo.BackgroundColor3 = Color_Element
robloxInfo.Text = " Usuário: " .. LocalPlayer.Name .. "\n ID: " .. LocalPlayer.UserId .. "\n Status: Premium Verified"
robloxInfo.TextColor3 = Color_Text_Primary
robloxInfo.Font = Enum.Font.Gotham
robloxInfo.TextSize = 11
robloxInfo.TextXAlignment = Enum.TextXAlignment.Left
robloxInfo.Parent = AccountScroll

local riCorner = Instance.new("UICorner")
riCorner.CornerRadius = UDim.new(0, 8)
riCorner.Parent = robloxInfo

-- Botões Inferiores de Ação (Executar / Limpar)
ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(0, 85, 0, 30)
ExecuteBtn.Position = UDim2.new(0, 18, 0, 255)
ExecuteBtn.BackgroundColor3 = Color_Accent_Positive
ExecuteBtn.Text = "Executar"
ExecuteBtn.TextColor3 = Color_Text_Primary
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.TextSize = 13
ExecuteBtn.Parent = MainFrame

local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0, 6)
execCorner.Parent = ExecuteBtn

ExecuteBtn.MouseButton1Click:Connect(function()
    if ScriptBox.Text ~= "" then
        local success, err = pcall(function()
            loadstring(ScriptBox.Text)()
        end)
        if not success then
            createToast("Erro ao executar script!")
            warn("Execute Error:", err)
        else
            createToast("Script Executado com Sucesso!")
        end
    else
        createToast("O Editor está vazio!")
    end
end)

ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0, 85, 0, 30)
ClearBtn.Position = UDim2.new(0, 110, 0, 255)
ClearBtn.BackgroundColor3 = Color_Accent_Negative
ClearBtn.Text = "Limpar"
ClearBtn.TextColor3 = Color_Text_Primary
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextSize = 13
ClearBtn.Parent = MainFrame

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = ClearBtn

ClearBtn.MouseButton1Click:Connect(function()
    ScriptBox.Text = ""
    createToast("Editor Limpo!")
end)

--- NAVEGAÇÃO LATERAL (Sidebar Buttons)
local navButtons = {
    {Name = "Editor", Icon = "rbxassetid://6031075931", Page = EditorPage},
    {Name = "Script Hub", Icon = "rbxassetid://6031154871", Page = ScriptHubPage},
    {Name = "Saves", Icon = "rbxassetid://6023426915", Page = SavesPage},
    {Name = "Settings", Icon = "rbxassetid://6031280882", Page = SettingsPage},
    {Name = "Account", Icon = "rbxassetid://14384012061", Page = AccountPage}
}

SidebarButtons = {}
local startY = 10
local spacing = 56

for _, nav in ipairs(navButtons) do
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 55, 0, 50)
    container.Position = UDim2.new(1, -72, 0, startY)
    container.BackgroundTransparency = 1
    container.Parent = MainFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 20, 0, 10)
    label.Position = UDim2.new(0, -10, 0, -2)
    label.BackgroundTransparency = 1
    label.Text = nav.Name
    label.TextColor3 = Color_Text_Primary
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 9
    label.Parent = container

    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 38, 0, 38)
    btn.Position = UDim2.new(0.5, -19, 0, 10)
    btn.BackgroundColor3 = Color_Element
    btn.Image = nav.Icon
    btn.Parent = container

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = btn

    local navStroke = Instance.new("UIStroke")
    navStroke.Color = Color_Stroke
    navStroke.Thickness = 1.5
    navStroke.Parent = btn

    table.insert(SidebarButtons, {Container = container, Label = label, Button = btn})

    btn.MouseButton1Click:Connect(function()
        EditorPage.Visible = false
        ScriptHubPage.Visible = false
        SavesPage.Visible = false
        SettingsPage.Visible = false
        AccountPage.Visible = false
        
        nav.Page.Visible = true
        CurrentTabLabel.Text = "Tab: " .. nav.Name
    end)

    startY = startY + spacing
end
