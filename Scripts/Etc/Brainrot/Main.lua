-- Modern Draggable Minizable Closable GUI for Roblox Mobile
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variables
local isDragging = false
local dragStart = nil
local startPos = nil
local isMinimized = false
local currentMode = "normal" -- "normal" or "advanced"
local currentItem = nil
local currentFolder = nil
local isLooping = false
local loopConnection = nil
local isGlitchy = false

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernSpawnGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame (Draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.95
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://13160448178"
Shadow.ImageTransparency = 0.7
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Spawn Manager"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamSemibold
Title.Parent = Header

-- Minimize Button
local MinimizeButton = Instance.new("ImageButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Image = "rbxassetid://6031090933"
MinimizeButton.ImageColor3 = Color3.fromRGB(200, 200, 200)
MinimizeButton.Parent = Header

-- Close Button
local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Image = "rbxassetid://6031090837"
CloseButton.ImageColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.Parent = Header

-- Content Container
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -20, 1, -60)
ContentContainer.Position = UDim2.new(0, 10, 0, 50)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ScrollBarThickness = 4
ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
ContentContainer.BottomImage = "rbxassetid://"
ContentContainer.MidImage = "rbxassetid://"
ContentContainer.TopImage = "rbxassetid://"
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentContainer.Parent = MainFrame

-- UIListLayout for Content
local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Name = "ContentLayout"
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = ContentContainer

-- Mode Selection
local ModeFrame = Instance.new("Frame")
ModeFrame.Name = "ModeFrame"
ModeFrame.Size = UDim2.new(1, 0, 0, 80)
ModeFrame.BackgroundTransparency = 1
ModeFrame.Parent = ContentContainer

local ModeLabel = Instance.new("TextLabel")
ModeLabel.Name = "ModeLabel"
ModeLabel.Size = UDim2.new(1, 0, 0, 20)
ModeLabel.Position = UDim2.new(0, 0, 0, 0)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Text = "Select Mode:"
ModeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ModeLabel.TextSize = 14
ModeLabel.Font = Enum.Font.Gotham
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModeLabel.Parent = ModeFrame

local NormalButton = Instance.new("TextButton")
NormalButton.Name = "NormalButton"
NormalButton.Size = UDim2.new(0.45, -5, 0, 35)
NormalButton.Position = UDim2.new(0, 0, 0, 25)
NormalButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
NormalButton.Text = "Normal"
NormalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NormalButton.TextSize = 14
NormalButton.Font = Enum.Font.GothamSemibold
NormalButton.BorderSizePixel = 0
NormalButton.Parent = ModeFrame

local NormalCorner = Instance.new("UICorner")
NormalCorner.CornerRadius = UDim.new(0, 8)
NormalCorner.Parent = NormalButton

local AdvancedButton = Instance.new("TextButton")
AdvancedButton.Name = "AdvancedButton"
AdvancedButton.Size = UDim2.new(0.45, -5, 0, 35)
AdvancedButton.Position = UDim2.new(0.55, 0, 0, 25)
AdvancedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
AdvancedButton.Text = "Advanced"
AdvancedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AdvancedButton.TextSize = 14
AdvancedButton.Font = Enum.Font.GothamSemibold
AdvancedButton.BorderSizePixel = 0
AdvancedButton.Parent = ModeFrame

local AdvancedCorner = Instance.new("UICorner")
AdvancedCorner.CornerRadius = UDim.new(0, 8)
AdvancedCorner.Parent = AdvancedButton

-- Items Container
local ItemsFrame = Instance.new("Frame")
ItemsFrame.Name = "ItemsFrame"
ItemsFrame.Size = UDim2.new(1, 0, 0, 0)
ItemsFrame.BackgroundTransparency = 1
ItemsFrame.Parent = ContentContainer

local ItemsLabel = Instance.new("TextLabel")
ItemsLabel.Name = "ItemsLabel"
ItemsLabel.Size = UDim2.new(1, 0, 0, 20)
ItemsLabel.Position = UDim2.new(0, 0, 0, 0)
ItemsLabel.BackgroundTransparency = 1
ItemsLabel.Text = "Select Item:"
ItemsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ItemsLabel.TextSize = 14
ItemsLabel.Font = Enum.Font.Gotham
ItemsLabel.TextXAlignment = Enum.TextXAlignment.Left
ItemsLabel.Parent = ItemsFrame

local ItemsScroll = Instance.new("ScrollingFrame")
ItemsScroll.Name = "ItemsScroll"
ItemsScroll.Size = UDim2.new(1, 0, 0, 150)
ItemsScroll.Position = UDim2.new(0, 0, 0, 25)
ItemsScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ItemsScroll.BackgroundTransparency = 0.5
ItemsScroll.BorderSizePixel = 0
ItemsScroll.ScrollBarThickness = 4
ItemsScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
ItemsScroll.BottomImage = "rbxassetid://"
ItemsScroll.MidImage = "rbxassetid://"
ItemsScroll.TopImage = "rbxassetid://"
ItemsScroll.Parent = ItemsFrame

local ItemsCorner = Instance.new("UICorner")
ItemsCorner.CornerRadius = UDim.new(0, 8)
ItemsCorner.Parent = ItemsScroll

local ItemsLayout = Instance.new("UIListLayout")
ItemsLayout.Name = "ItemsLayout"
ItemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
ItemsLayout.Padding = UDim.new(0, 4)
ItemsLayout.Parent = ItemsScroll

-- Spawn Controls
local SpawnFrame = Instance.new("Frame")
SpawnFrame.Name = "SpawnFrame"
SpawnFrame.Size = UDim2.new(1, 0, 0, 150)
SpawnFrame.BackgroundTransparency = 1
SpawnFrame.Parent = ContentContainer

local SpawnOnceButton = Instance.new("TextButton")
SpawnOnceButton.Name = "SpawnOnceButton"
SpawnOnceButton.Size = UDim2.new(1, 0, 0, 35)
SpawnOnceButton.Position = UDim2.new(0, 0, 0, 0)
SpawnOnceButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SpawnOnceButton.Text = "Spawn Once"
SpawnOnceButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnOnceButton.TextSize = 14
SpawnOnceButton.Font = Enum.Font.GothamSemibold
SpawnOnceButton.BorderSizePixel = 0
SpawnOnceButton.Parent = SpawnFrame

local SpawnOnceCorner = Instance.new("UICorner")
SpawnOnceCorner.CornerRadius = UDim.new(0, 8)
SpawnOnceCorner.Parent = SpawnOnceButton

local LoopContainer = Instance.new("Frame")
LoopContainer.Name = "LoopContainer"
LoopContainer.Size = UDim2.new(1, 0, 0, 35)
LoopContainer.Position = UDim2.new(0, 0, 0, 42)
LoopContainer.BackgroundTransparency = 1
LoopContainer.Parent = SpawnFrame

local LoopButton = Instance.new("TextButton")
LoopButton.Name = "LoopButton"
LoopButton.Size = UDim2.new(0.65, -5, 1, 0)
LoopButton.Position = UDim2.new(0, 0, 0, 0)
LoopButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
LoopButton.Text = "Loop Spawn"
LoopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LoopButton.TextSize = 14
LoopButton.Font = Enum.Font.GothamSemibold
LoopButton.BorderSizePixel = 0
LoopButton.Parent = LoopContainer

local LoopCorner = Instance.new("UICorner")
LoopCorner.CornerRadius = UDim.new(0, 8)
LoopCorner.Parent = LoopButton

local GlitchyButton = Instance.new("TextButton")
GlitchyButton.Name = "GlitchyButton"
GlitchyButton.Size = UDim2.new(0.35, -5, 1, 0)
GlitchyButton.Position = UDim2.new(0.67, 0, 0, 0)
GlitchyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
GlitchyButton.Text = "Glitchy"
GlitchyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GlitchyButton.TextSize = 12
GlitchyButton.Font = Enum.Font.GothamSemibold
GlitchyButton.BorderSizePixel = 0
GlitchyButton.Parent = LoopContainer

local GlitchyCorner = Instance.new("UICorner")
GlitchyCorner.CornerRadius = UDim.new(0, 8)
GlitchyCorner.Parent = GlitchyButton

local LoopToggle = Instance.new("TextLabel")
LoopToggle.Name = "LoopToggle"
LoopToggle.Size = UDim2.new(0, 20, 1, -10)
LoopToggle.Position = UDim2.new(1, -25, 0, 5)
LoopToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
LoopToggle.Text = ""
LoopToggle.BorderSizePixel = 0
LoopToggle.Parent = LoopContainer

local LoopToggleCorner = Instance.new("UICorner")
LoopToggleCorner.CornerRadius = UDim.new(1, 0)
LoopToggleCorner.Parent = LoopToggle

local ToggleIndicator = Instance.new("Frame")
ToggleIndicator.Name = "ToggleIndicator"
ToggleIndicator.Size = UDim2.new(0, 14, 0, 14)
ToggleIndicator.Position = UDim2.new(0, 3, 0, 3)
ToggleIndicator.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
ToggleIndicator.BorderSizePixel = 0
ToggleIndicator.Parent = LoopToggle

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleIndicator

-- Functions
local function updateContentSize()
    local totalHeight = 0
    for _, child in pairs(ContentContainer:GetChildren()) do
        if child:IsA("Frame") and child.Visible then
            totalHeight = totalHeight + child.Size.Y.Offset + ContentLayout.Padding.Offset
        end
    end
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

local function loadItems()
    -- Clear existing items
    for _, child in pairs(ItemsScroll:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Search for Items folder
    local itemsFolder = nil
    for _, child in pairs(ReplicatedStorage:GetChildren()) do
        if child.Name:lower():find("item") or child.Name:lower():find("ite") then
            itemsFolder = child
            break
        end
    end
    
    if not itemsFolder then
        local noItems = Instance.new("TextLabel")
        noItems.Size = UDim2.new(1, 0, 0, 30)
        noItems.BackgroundTransparency = 1
        noItems.Text = "No items folder found!"
        noItems.TextColor3 = Color3.fromRGB(255, 100, 100)
        noItems.TextSize = 14
        noItems.Font = Enum.Font.Gotham
        noItems.Parent = ItemsScroll
        return
    end
    
    -- Function to recursively add items
    local function addItems(parent, depth)
        depth = depth or 0
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("Folder") then
                -- Create folder button
                local folderBtn = Instance.new("TextButton")
                folderBtn.Size = UDim2.new(1, -10, 0, 30)
                folderBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                folderBtn.Text = string.rep("  ", depth) .. "📁 " .. child.Name
                folderBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
                folderBtn.TextSize = 13
                folderBtn.Font = Enum.Font.Gotham
                folderBtn.BorderSizePixel = 0
                folderBtn.Parent = ItemsScroll
                
                local folderCorner = Instance.new("UICorner")
                folderCorner.CornerRadius = UDim.new(0, 6)
                folderCorner.Parent = folderBtn
                
                folderBtn.MouseButton1Click:Connect(function()
                    currentFolder = child
                    loadItems() -- Reload to show contents
                end)
                
                -- Add children recursively
                addItems(child, depth + 1)
            else
                -- Create item button
                local itemBtn = Instance.new("TextButton")
                itemBtn.Size = UDim2.new(1, -10, 0, 30)
                itemBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                itemBtn.Text = string.rep("  ", depth) .. "📦 " .. child.Name
                itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                itemBtn.TextSize = 13
                itemBtn.Font = Enum.Font.Gotham
                itemBtn.BorderSizePixel = 0
                itemBtn.Parent = ItemsScroll
                
                local itemCorner = Instance.new("UICorner")
                itemCorner.CornerRadius = UDim.new(0, 6)
                itemCorner.Parent = itemBtn
                
                itemBtn.MouseButton1Click:Connect(function()
                    currentItem = child.Name
                    -- Highlight selected
                    for _, btn in pairs(ItemsScroll:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                        end
                    end
                    itemBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                end)
            end
        end
    end
    
    addItems(itemsFolder)
    
    -- Update scroll size
    local count = #ItemsScroll:GetChildren()
    ItemsScroll.CanvasSize = UDim2.new(0, 0, 0, count * 34)
end

local function spawnItem(itemName, mode)
    if not itemName then
        print("No item selected!")
        return
    end
    
    local Event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("ClaimHatchedItem")
    
    if mode == "normal" then
        Event:FireServer(itemName, "Mythical")
    else -- advanced
        Event:FireServer(itemName, "Common", "Normal")
    end
end

local function getRandomName()
    local names = {"Glitch", "Error", "Corrupt", "Void", "Null", "Phantom", "Wraith", "Specter"}
    return names[math.random(1, #names)] .. math.random(100, 999)
end

local function startLoop(glitchy)
    if isLooping then return end
    if not currentItem then
        print("No item selected!")
        return
    end
    
    isLooping = true
    isGlitchy = glitchy or false
    LoopButton.Text = "Stop Loop"
    LoopButton.BackgroundColor3 = Color3.fromRGB(70, 40, 40)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    
    loopConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not isLooping then return end
        
        local itemToSpawn = currentItem
        if isGlitchy then
            itemToSpawn = getRandomName()
        end
        
        spawnItem(itemToSpawn, currentMode)
    end)
end

local function stopLoop()
    isLooping = false
    if loopConnection then
        loopConnection:Disconnect()
        loopConnection = nil
    end
    LoopButton.Text = "Loop Spawn"
    LoopButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
end

-- Button Connections
NormalButton.MouseButton1Click:Connect(function()
    currentMode = "normal"
    NormalButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    AdvancedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
end)

AdvancedButton.MouseButton1Click:Connect(function()
    currentMode = "advanced"
    AdvancedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    NormalButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
end)

SpawnOnceButton.MouseButton1Click:Connect(function()
    if currentItem then
        spawnItem(currentItem, currentMode)
    else
        print("Please select an item first!")
    end
end)

LoopButton.MouseButton1Click:Connect(function()
    if isLooping then
        stopLoop()
    else
        startLoop(false)
    end
end)

GlitchyButton.MouseButton1Click:Connect(function()
    if isLooping then
        stopLoop()
    else
        startLoop(true)
    end
end)

-- Toggle for loop (click on toggle indicator)
LoopToggle.MouseButton1Click:Connect(function()
    if isLooping then
        stopLoop()
    else
        startLoop(isGlitchy)
    end
end)

-- Minimize
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 350, 0, 40)
        ContentContainer.Visible = false
        MinimizeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    else
        MainFrame.Size = UDim2.new(0, 350, 0, 500)
        ContentContainer.Visible = true
        MinimizeButton.ImageColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- Close
CloseButton.MouseButton1Click:Connect(function()
    if isLooping then
        stopLoop()
    end
    ScreenGui:Destroy()
end)

-- Dragging
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        MainFrame.Position = newPos
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- Initialize
loadItems()
NormalButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

-- Update sizes
ItemsFrame.Size = UDim2.new(1, 0, 0, 200)
SpawnFrame.Size = UDim2.new(1, 0, 0, 130)
updateContentSize()

-- Animation for nicer appearance
MainFrame.BackgroundTransparency = 0.05
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0.05
}):Play()
