local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local redzlib = {}

-- Utility Functions
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function Tween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Main Library
function redzlib:MakeWindow(config)
    local Window = {}
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RedzLib"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(60, 60, 70)
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = TopBar
    
    local TopCover = Instance.new("Frame")
    TopCover.Size = UDim2.new(1, 0, 0, 12)
    TopCover.Position = UDim2.new(0, 0, 1, -12)
    TopCover.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TopCover.BorderSizePixel = 0
    TopCover.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -100, 0, 30)
    Title.Position = UDim2.new(0, 15, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "Redz Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Size = UDim2.new(1, -100, 0, 15)
    SubTitle.Position = UDim2.new(0, 15, 0, 30)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = config.SubTitle or "by redz9999"
    SubTitle.TextColor3 = Color3.fromRGB(150, 150, 160)
    SubTitle.TextSize = 12
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = TopBar
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 140, 1, -60)
    TabContainer.Position = UDim2.new(0, 10, 0, 55)
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabContainer
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 5)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)
    TabPadding.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -165, 1, -65)
    ContentContainer.Position = UDim2.new(0, 155, 0, 60)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.ClipsDescendants = true
    ContentContainer.Parent = MainFrame
    
    MakeDraggable(MainFrame, TopBar)
    
    -- Minimize Button Function
    function Window:AddMinimizeButton(config)
        local MinimizeBtn = Instance.new("ImageButton")
        MinimizeBtn.Name = "MinimizeButton"
        MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
        MinimizeBtn.Position = UDim2.new(1, -45, 0, 7.5)
        MinimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        MinimizeBtn.BackgroundTransparency = config.Button.BackgroundTransparency or 0
        MinimizeBtn.BorderSizePixel = 0
        MinimizeBtn.Image = config.Button.Image or ""
        MinimizeBtn.Parent = TopBar
        
        local MinCorner = Instance.new("UICorner")
        MinCorner.CornerRadius = config.Corner.CornerRadius or UDim.new(0, 8)
        MinCorner.Parent = MinimizeBtn
        
        local minimized = false
        MinimizeBtn.MouseButton1Click:Connect(function()
            minimized = not minimized
            if minimized then
                Tween(MainFrame, {Size = UDim2.new(0, 550, 0, 50)}, 0.3)
            else
                Tween(MainFrame, {Size = UDim2.new(0, 550, 0, 400)}, 0.3)
            end
        end)
    end
    
    -- Make Tab Function
    function Window:MakeTab(config)
        local Tab = {}
        local tabName = config[1] or "Tab"
        local tabIcon = config[2] or "home"
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        TabButton.BorderSizePixel = 0
        TabButton.Text = "  " .. tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 210)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = TabContainer
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, 8)
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Parent = TabContent
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 5)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.Parent = TabContent
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(ContentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            for _, btn in pairs(TabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    Tween(btn, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
                    btn.TextColor3 = Color3.fromRGB(200, 200, 210)
                end
            end
            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(80, 120, 255)}, 0.2)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        if #TabContainer:GetChildren() == 4 then
            TabButton.MouseButton1Click:Fire()
        end
        
        -- Add Toggle
        function Tab:AddToggle(config)
            local Toggle = Instance.new("Frame")
            Toggle.Name = "Toggle"
            Toggle.Size = UDim2.new(1, 0, 0, 45)
            Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            Toggle.BorderSizePixel = 0
            Toggle.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = Toggle
            
            local ToggleName = Instance.new("TextLabel")
            ToggleName.Size = UDim2.new(1, -60, 1, 0)
            ToggleName.Position = UDim2.new(0, 12, 0, 0)
            ToggleName.BackgroundTransparency = 1
            ToggleName.Text = config.Name or "Toggle"
            ToggleName.TextColor3 = Color3.fromRGB(230, 230, 240)
            ToggleName.TextSize = 14
            ToggleName.Font = Enum.Font.GothamMedium
            ToggleName.TextXAlignment = Enum.TextXAlignment.Left
            ToggleName.Parent = Toggle
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 45, 0, 22)
            ToggleButton.Position = UDim2.new(1, -55, 0.5, -11)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.Parent = Toggle
            
            local ToggleBtnCorner = Instance.new("UICorner")
            ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
            ToggleBtnCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
            ToggleCircle.Position = UDim2.new(0, 2, 0.5, -9)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local toggled = config.Default or false
            
            if toggled then
                ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
                ToggleCircle.Position = UDim2.new(1, -20, 0.5, -9)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                if toggled then
                    Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(80, 120, 255)}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -20, 0.5, -9)}, 0.2)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -9)}, 0.2)
                end
                if config.Callback then
                    config.Callback(toggled)
                end
            end)
        end
        
        -- Add TextBox
        function Tab:AddTextBox(config)
            local TextBoxFrame = Instance.new("Frame")
            TextBoxFrame.Name = "TextBox"
            TextBoxFrame.Size = UDim2.new(1, 0, 0, 80)
            TextBoxFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            TextBoxFrame.BorderSizePixel = 0
            TextBoxFrame.Parent = TabContent
            
            local TBCorner = Instance.new("UICorner")
            TBCorner.CornerRadius = UDim.new(0, 8)
            TBCorner.Parent = TextBoxFrame
            
            local TBName = Instance.new("TextLabel")
            TBName.Size = UDim2.new(1, -20, 0, 20)
            TBName.Position = UDim2.new(0, 10, 0, 8)
            TBName.BackgroundTransparency = 1
            TBName.Text = config.Name or "TextBox"
            TBName.TextColor3 = Color3.fromRGB(230, 230, 240)
            TBName.TextSize = 14
            TBName.Font = Enum.Font.GothamBold
            TBName.TextXAlignment = Enum.TextXAlignment.Left
            TBName.Parent = TextBoxFrame
            
            local TBDesc = Instance.new("TextLabel")
            TBDesc.Size = UDim2.new(1, -20, 0, 15)
            TBDesc.Position = UDim2.new(0, 10, 0, 28)
            TBDesc.BackgroundTransparency = 1
            TBDesc.Text = config.Description or ""
            TBDesc.TextColor3 = Color3.fromRGB(150, 150, 160)
            TBDesc.TextSize = 11
            TBDesc.Font = Enum.Font.Gotham
            TBDesc.TextXAlignment = Enum.TextXAlignment.Left
            TBDesc.Parent = TextBoxFrame
            
            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -20, 0, 28)
            TextBox.Position = UDim2.new(0, 10, 1, -35)
            TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            TextBox.BorderSizePixel = 0
            TextBox.Text = ""
            TextBox.PlaceholderText = config.PlaceholderText or "Enter text..."
            TextBox.TextColor3 = Color3.fromRGB(230, 230, 240)
            TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
            TextBox.TextSize = 13
            TextBox.Font = Enum.Font.Gotham
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = TextBoxFrame
            
            local TBInputCorner = Instance.new("UICorner")
            TBInputCorner.CornerRadius = UDim.new(0, 6)
            TBInputCorner.Parent = TextBox
            
            local TBPadding = Instance.new("UIPadding")
            TBPadding.PaddingLeft = UDim.new(0, 8)
            TBPadding.Parent = TextBox
            
            TextBox.FocusLost:Connect(function(enter)
                if enter and config.Callback then
                    config.Callback(TextBox.Text)
                end
            end)
        end
        
        -- Add Button (NewButton)
        function Tab:NewButton(text, info, callback)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "Button"
            ButtonFrame.Size = UDim2.new(1, 0, 0, 60)
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = TabContent
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = ButtonFrame
            
            local BtnText = Instance.new("TextLabel")
            BtnText.Size = UDim2.new(1, -20, 0, 20)
            BtnText.Position = UDim2.new(0, 10, 0, 8)
            BtnText.BackgroundTransparency = 1
            BtnText.Text = text or "Button"
            BtnText.TextColor3 = Color3.fromRGB(230, 230, 240)
            BtnText.TextSize = 14
            BtnText.Font = Enum.Font.GothamBold
            BtnText.TextXAlignment = Enum.TextXAlignment.Left
            BtnText.Parent = ButtonFrame
            
            local BtnInfo = Instance.new("TextLabel")
            BtnInfo.Size = UDim2.new(1, -20, 0, 15)
            BtnInfo.Position = UDim2.new(0, 10, 0, 28)
            BtnInfo.BackgroundTransparency = 1
            BtnInfo.Text = info or ""
            BtnInfo.TextColor3 = Color3.fromRGB(150, 150, 160)
            BtnInfo.TextSize = 11
            BtnInfo.Font = Enum.Font.Gotham
            BtnInfo.TextXAlignment = Enum.TextXAlignment.Left
            BtnInfo.Parent = ButtonFrame
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(0, 60, 0, 22)
            Button.Position = UDim2.new(1, -70, 1, -28)
            Button.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
            Button.BorderSizePixel = 0
            Button.Text = "Click"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 12
            Button.Font = Enum.Font.GothamBold
            Button.Parent = ButtonFrame
            
            local BtnClickCorner = Instance.new("UICorner")
            BtnClickCorner.CornerRadius = UDim.new(0, 6)
            BtnClickCorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(100, 140, 255)}, 0.1)
                wait(0.1)
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(80, 120, 255)}, 0.1)
                if callback then
                    callback()
                end
            end)
        end
        
        -- Add Discord Invite
        function Tab:AddDiscordInvite(config)
            local DiscordFrame = Instance.new("Frame")
            DiscordFrame.Name = "DiscordInvite"
            DiscordFrame.Size = UDim2.new(1, 0, 0, 70)
            DiscordFrame.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
            DiscordFrame.BorderSizePixel = 0
            DiscordFrame.Parent = TabContent
            
            local DiscordCorner = Instance.new("UICorner")
            DiscordCorner.CornerRadius = UDim.new(0, 8)
            DiscordCorner.Parent = DiscordFrame
            
            local Logo = Instance.new("ImageLabel")
            Logo.Size = UDim2.new(0, 50, 0, 50)
            Logo.Position = UDim2.new(0, 10, 0.5, -25)
            Logo.BackgroundTransparency = 1
            Logo.Image = config.Logo or ""
            Logo.Parent = DiscordFrame
            
            local LogoCorner = Instance.new("UICorner")
            LogoCorner.CornerRadius = UDim.new(1, 0)
            LogoCorner.Parent = Logo
            
            local DiscordName = Instance.new("TextLabel")
            DiscordName.Size = UDim2.new(1, -140, 0, 22)
            DiscordName.Position = UDim2.new(0, 70, 0, 12)
            DiscordName.BackgroundTransparency = 1
            DiscordName.Text = config.Name or "Discord Server"
            DiscordName.TextColor3 = Color3.fromRGB(255, 255, 255)
            DiscordName.TextSize = 15
            DiscordName.Font = Enum.Font.GothamBold
            DiscordName.TextXAlignment = Enum.TextXAlignment.Left
            DiscordName.Parent = DiscordFrame
            
            local DiscordDesc = Instance.new("TextLabel")
            DiscordDesc.Size = UDim2.new(1, -140, 0, 18)
            DiscordDesc.Position = UDim2.new(0, 70, 0, 36)
            DiscordDesc.BackgroundTransparency = 1
            DiscordDesc.Text = config.Description or "Join our server"
            DiscordDesc.TextColor3 = Color3.fromRGB(220, 220, 230)
            DiscordDesc.TextSize = 12
            DiscordDesc.Font = Enum.Font.Gotham
            DiscordDesc.TextXAlignment = Enum.TextXAlignment.Left
            DiscordDesc.Parent = DiscordFrame
            
            local JoinButton = Instance.new("TextButton")
            JoinButton.Size = UDim2.new(0, 60, 0, 28)
            JoinButton.Position = UDim2.new(1, -70, 0.5, -14)
            JoinButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            JoinButton.BorderSizePixel = 0
            JoinButton.Text = "Join"
            JoinButton.TextColor3 = Color3.fromRGB(88, 101, 242)
            JoinButton.TextSize = 13
            JoinButton.Font = Enum.Font.GothamBold
            JoinButton.Parent = DiscordFrame
            
            local JoinCorner = Instance.new("UICorner")
            JoinCorner.CornerRadius = UDim.new(0, 6)
            JoinCorner.Parent = JoinButton
            
            JoinButton.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(config.Invite or "")
                end
            end)
        end
        
        return Tab
    end
    
    return Window
end

return redzlib
