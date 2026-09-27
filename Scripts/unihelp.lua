--[[
    DELTA MOBILE GUI - Advanced Testing Suite
    Features: Dex Explorer, Infinite Yield, CFrame Teleport, Part Selector
    Author: Assistant
    Usage: Paste into Delta executor
--]]

-- ============ SERVICES ============
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ============ CLEANUP ============
pcall(function()
    if CoreGui:FindFirstChild("DeltaMobileGUI") then
        CoreGui.DeltaMobileGUI:Destroy()
    end
end)

-- ============ CONFIG ============
local CONFIG = {
    Accent = Color3.fromRGB(88, 101, 242),
    AccentDark = Color3.fromRGB(66, 79, 200),
    BG = Color3.fromRGB(22, 23, 28),
    BGSecondary = Color3.fromRGB(30, 31, 38),
    BG Tertiary = Color3.fromRGB(38, 40, 48),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(160, 165, 180),
    Success = Color3.fromRGB(59, 200, 120),
    Danger = Color3.fromRGB(237, 66, 69),
    Warning = Color3.fromRGB(250, 166, 26),
    Shadow = Color3.fromRGB(0, 0, 0),
}

-- ============ UTILS ============
local function create(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    if props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function addShadow(parent, transparency)
    local shadow = create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = CONFIG.Shadow,
        ImageTransparency = transparency or 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        ZIndex = parent.ZIndex - 1,
        Parent = parent
    })
    return shadow
end

local function tween(obj, time, props, style, dir)
    local ti = TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, ti, props)
    t:Play()
    return t
end

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
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
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ============ SCREEN GUI ============
local ScreenGui = create("ScreenGui", {
    Name = "DeltaMobileGUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
})

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ============ MAIN WINDOW ============
local Main = create("Frame", {
    Name = "Main",
    Size = UDim2.new(0, 340, 0, 480),
    Position = UDim2.new(0.5, -170, 0.5, -240),
    BackgroundColor3 = CONFIG.BG,
    BorderSizePixel = 0,
    ClipsDescendants = false,
    Active = true,
    Parent = ScreenGui,
})

create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = Main})
create("UIStroke", {Color = Color3.fromRGB(60, 62, 75), Thickness = 1, Transparency = 0.3, Parent = Main})
addShadow(Main, 0.4)

-- Background gradient
local grad = create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 30, 38)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 21, 26)),
    }),
    Rotation = 90,
    Parent = Main
})

-- ============ TOP BAR ============
local TopBar = create("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = CONFIG.BGSecondary,
    BorderSizePixel = 0,
    Parent = Main,
})
create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = TopBar})

-- Fix bottom corners
create("Frame", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = CONFIG.BGSecondary,
    BorderSizePixel = 0,
    Parent = TopBar,
})

-- Logo
local Logo = create("Frame", {
    Size = UDim2.new(0, 26, 0, 26),
    Position = UDim2.new(0, 12, 0.5, -13),
    BackgroundColor3 = CONFIG.Accent,
    BorderSizePixel = 0,
    Parent = TopBar,
})
create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Logo})
create("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "Δ",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    Parent = Logo,
})

-- Title
create("TextLabel", {
    Name = "Title",
    Size = UDim2.new(0, 180, 0, 20),
    Position = UDim2.new(0, 46, 0, 8),
    BackgroundTransparency = 1,
    Text = "Delta Suite",
    TextColor3 = CONFIG.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopBar,
})

create("TextLabel", {
    Size = UDim2.new(0, 180, 0, 14),
    Position = UDim2.new(0, 46, 0, 26),
    BackgroundTransparency = 1,
    Text = "Mobile Testing Toolkit",
    TextColor3 = CONFIG.TextDim,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopBar,
})

-- Window buttons
local BtnContainer = create("Frame", {
    Size = UDim2.new(0, 96, 0, 28),
    Position = UDim2.new(1, -104, 0.5, -14),
    BackgroundTransparency = 1,
    Parent = TopBar,
})

local function makeWindowBtn(name, color, xPos, symbol)
    local btn = create("TextButton", {
        Name = name,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, xPos, 0, 0),
        BackgroundColor3 = color,
        Text = symbol,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        AutoButtonColor = false,
        Parent = BtnContainer,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = btn})
    
    btn.MouseEnter:Connect(function()
        tween(btn, 0.15, {BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.2)})
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.15, {BackgroundColor3 = color})
    end)
    btn.MouseButton1Down:Connect(function()
        tween(btn, 0.1, {Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(0, xPos+1.5, 0, 1.5)})
    end)
    btn.MouseButton1Up:Connect(function()
        tween(btn, 0.1, {Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, xPos, 0, 0)})
    end)
    
    return btn
end

local MinBtn = makeWindowBtn("Min", CONFIG.Warning, 0, "−")
local CloseBtn = makeWindowBtn("Close", CONFIG.Danger, 34, "✕")

-- ============ TAB BAR ============
local TabBar = create("Frame", {
    Name = "TabBar",
    Size = UDim2.new(1, -24, 0, 34),
    Position = UDim2.new(0, 12, 0, 58),
    BackgroundColor3 = CONFIG.BGSecondary,
    BorderSizePixel = 0,
    Parent = Main,
})
create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = TabBar})

local Tabs = {}
local TabButtons = {}
local Container = create("Frame", {
    Name = "Container",
    Size = UDim2.new(1, -24, 1, -110),
    Position = UDim2.new(0, 12, 0, 100),
    BackgroundTransparency = 1,
    Parent = Main,
})

local function createTab(name, icon)
    local btn = create("TextButton", {
        Name = name .. "Tab",
        Size = UDim2.new(1/#({"Explorer","Teleport","Scripts"}), -4, 1, -6),
        Position = UDim2.new((#{})/3, 0, 0, 3),
        BackgroundColor3 = CONFIG.BGSecondary,
        Text = "",
        AutoButtonColor = false,
        Parent = TabBar,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = btn})
    create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = CONFIG.TextDim,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        Parent = btn,
    })
    
    local page = create("ScrollingFrame", {
        Name = name .. "Page",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = CONFIG.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = Container,
    })
    
    return btn, page
end

-- ============ EXPLORER TAB ============
local ExplorerBtn = create("TextButton", {
    Size = UDim2.new(0.333, -3, 1, -6),
    Position = UDim2.new(0, 2, 0, 3),
    BackgroundColor3 = CONFIG.Accent,
    Text = "",
    AutoButtonColor = false,
    Parent = TabBar,
})
create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ExplorerBtn})
create("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "Explorer",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    Parent = ExplorerBtn,
})

local TeleportBtn = create("TextButton", {
    Size = UDim2.new(0.333, -3, 1, -6),
    Position = UDim2.new(0.333, 0, 0, 3),
    BackgroundColor3 = CONFIG.BGSecondary,
    Text = "",
    AutoButtonColor = false,
    Parent = TabBar,
})
create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TeleportBtn})
create("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "Teleport",
    TextColor3 = CONFIG.TextDim,
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    Parent = TeleportBtn,
})

local ScriptsBtn = create("TextButton", {
    Size = UDim2.new(0.333, -3, 1, -6),
    Position = UDim2.new(0.666, 0, 0, 3),
    BackgroundColor3 = CONFIG.BGSecondary,
    Text = "",
    AutoButtonColor = false,
    Parent = TabBar,
})
create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ScriptsBtn})
create("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "Scripts",
    TextColor3 = CONFIG.TextDim,
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    Parent = ScriptsBtn,
})

-- Explorer Page
local ExplorerPage = create("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = CONFIG.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = Container,
})

-- Teleport Page
local TeleportPage = create("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = CONFIG.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Visible = false,
    Parent = Container,
})

-- Scripts Page
local ScriptsPage = create("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = CONFIG.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Visible = false,
    Parent = Container,
})

local Pages = {ExplorerPage, TeleportPage, ScriptsPage}
local TabBtns = {ExplorerBtn, TeleportBtn, ScriptsBtn}

local currentTab = 1

local function switchTab(idx)
    for i, page in ipairs(Pages) do
        page.Visible = (i == idx)
    end
    for i, btn in ipairs(TabBtns) do
        local lbl = btn:FindFirstChildOfClass("TextLabel")
        if i == idx then
            tween(btn, 0.2, {BackgroundColor3 = CONFIG.Accent})
            tween(lbl, 0.2, {TextColor3 = Color3.new(1,1,1)})
        else
            tween(btn, 0.2, {BackgroundColor3 = CONFIG.BGSecondary})
            tween(lbl, 0.2, {TextColor3 = CONFIG.TextDim})
        end
    end
    currentTab = idx
end

ExplorerBtn.MouseButton1Click:Connect(function() switchTab(1) end)
TeleportBtn.MouseButton1Click:Connect(function() switchTab(2) end)
ScriptsBtn.MouseButton1Click:Connect(function() switchTab(3) end)

-- ============ EXPLORER TAB CONTENT ============
local function makeSearchBox(parent, placeholder, yPos)
    local box = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        Position = UDim2.new(0, 0, 0, yPos),
        BackgroundColor3 = CONFIG.BGSecondary,
        BorderSizePixel = 0,
        Parent = parent,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})
    create("UIStroke", {Color = Color3.fromRGB(60, 62, 75), Thickness = 1, Transparency = 0.5, Parent = box})
    
    local txt = create("TextBox", {
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = placeholder,
        PlaceholderColor3 = CONFIG.TextDim,
        TextColor3 = CONFIG.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = box,
    })
    return txt, box
end

local searchBox, searchFrame = makeSearchBox(ExplorerPage, "🔍 Search instances...", 4)

-- Refresh button
local RefreshBtn = create("TextButton", {
    Size = UDim2.new(0, 80, 0, 30),
    Position = UDim2.new(1, -80, 0, 44),
    BackgroundColor3 = CONFIG.Accent,
    Text = "↻ Refresh",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    AutoButtonColor = false,
    Parent = ExplorerPage,
})
create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = RefreshBtn})

-- Refresh LocalPlayer button
local SelfBtn = create("TextButton", {
    Size = UDim2.new(0, 80, 0, 30),
    Position = UDim2.new(1, -168, 0, 44),
    BackgroundColor3 = CONFIG.BG Tertiary or CONFIG.BGSecondary,
    Text = "◉ Self",
    TextColor3 = CONFIG.Text,
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    AutoButtonColor = false,
    Parent = ExplorerPage,
})
create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = SelfBtn})

-- Container for tree
local TreeContainer = create("Frame", {
    Size = UDim2.new(1, 0, 0, 0),
    Position = UDim2.new(0, 0, 0, 80),
    BackgroundTransparency = 1,
    AutomaticSize = Enum.AutomaticSize.Y,
    Parent = ExplorerPage,
})

-- Selection info
local SelectedInfo = create("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 1, -44),
    BackgroundColor3 = CONFIG.BGSecondary,
    BorderSizePixel = 0,
    Parent = ExplorerPage,
})
create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = SelectedInfo})
create("UIStroke", {Color = CONFIG.Accent, Thickness = 1, Transparency = 0.5, Parent = SelectedInfo})

local SelectedLbl = create("TextLabel", {
    Size = UDim2.new(1, -16, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    Text = "No selection",
    TextColor3 = CONFIG.TextDim,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    Parent = SelectedInfo,
})

-- Explorer logic
local selectedInstance = nil
local expanded = {}
local instanceRows = {}

local function getIcon(inst)
    local class = inst.ClassName
    if class == "Folder" then return "📁"
    elseif class == "Script" or class == "LocalScript" or class == "ModuleScript" then return "📜"
    elseif class == "Part" or class == "MeshPart" or class == "UnionOperation" then return "🧱"
    elseif class == "Model" then return "📦"
    elseif class:find("Gui") then return "🖼️"
    elseif class == "Humanoid" then return "🧍"
    elseif class == "Player" then return "👤"
    elseif class == "Camera" then return "📷"
    elseif class == "Light" or class:find("Light") then return "💡"
    elseif class:find("Sound") then return "🔊"
    elseif class == "Animation" then return "🎬"
    elseif class:find("Value") then return "🔢"
    elseif class == "Tool" then return "🔧"
    else return "⚙️"
    end
end

local function makeRow(inst, depth, parentFrame)
    local row = create("Frame", {
        Name = inst.Name,
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = CONFIG.BGSecondary,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = parentFrame,
    })
    
    local click = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = row,
    })
    
    local indent = create("Frame", {
        Size = UDim2.new(0, depth * 14, 0, 0),
        BackgroundTransparency = 1,
        Parent = row,
    })
    
    -- Arrow
    local children = inst:GetChildren()
    local hasChildren = #children > 0
    local arrow = create("TextButton", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, depth * 14 + 2, 0.5, -9),
        BackgroundTransparency = 1,
        Text = hasChildren and (expanded[inst] and "▼" or "▶") or " ",
        TextColor3 = CONFIG.TextDim,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        Parent = row,
    })
    
    local icon = create("TextLabel", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, depth * 14 + 22, 0.5, -9),
        BackgroundTransparency = 1,
        Text = getIcon(inst),
        TextColor3 = CONFIG.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = row,
    })
    
    local nameLbl = create("TextLabel", {
        Size = UDim2.new(1, -(depth * 14 + 90), 1, 0),
        Position = UDim2.new(0, depth * 14 + 42, 0, 0),
        BackgroundTransparency = 1,
        Text = inst.Name,
        TextColor3 = CONFIG.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = row,
    })
    
    local classLbl = create("TextLabel", {
        Size = UDim2.new(0, 80, 1, 0),
        Position = UDim2.new(1, -82, 0, 0),
        BackgroundTransparency = 1,
        Text = inst.ClassName,
        TextColor3 = CONFIG.TextDim,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = row,
    })
    
    local childContainer = create("Frame", {
        Name = "Children",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = expanded[inst] or false,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = row,
    })
    
    local function populateChildren()
        for _, child in ipairs(childContainer:GetChildren()) do
            child:Destroy()
        end
        for _, child in ipairs(children) do
            makeRow(child, depth + 1, childContainer)
        end
    end
    
    if expanded[inst] then
        populateChildren()
    end
    
    arrow.MouseButton1Click:Connect(function()
        if not hasChildren then return end
        expanded[inst] = not expanded[inst]
        arrow
