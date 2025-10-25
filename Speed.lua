-- Services
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerMouse = Player:GetMouse()

-- Library
local redzlib = {}
redzlib.Tabs = {}
redzlib.Options = {}

-- Theme
local Theme = {
    Background = Color3.fromRGB(25, 25, 25),
    TopBar = Color3.fromRGB(35, 35, 35),
    Element = Color3.fromRGB(40, 40, 40),
    Theme = Color3.fromRGB(255, 85, 85),
    Text = Color3.fromRGB(255, 255, 255),
    Stroke = Color3.fromRGB(60, 60, 60)
}

-- Utility Functions
local function Create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function Make(className, parent, properties)
    local instance = Create(className, properties)
    instance.Parent = parent
    return instance
end

local function CreateTween(object, property, value, duration)
    TweenService:Create(object, TweenInfo.new(duration), {[property] = value}):Play()
end

local function InsertTheme(object, property)
    if Theme[property] then
        object[property] = Theme[property]
    end
    return object
end

-- Main Window
function redzlib:MakeWindow(config)
    local Window = {}
    Window.Title = config.Title or "redz Hub"
    Window.SubTitle = config.SubTitle or "by redz9999"
    Window.SaveFolder = config.SaveFolder or "redzlib"
    
    -- ScreenGui
    local ScreenGui = Make("ScreenGui", CoreGui, {
        Name = "redzlibUI",
        ResetOnSpawn = false
    })
    
    -- Main Frame
    local MainFrame = Make("Frame", ScreenGui, {
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = Theme.Background,
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    
    Make("UICorner", MainFrame, {CornerRadius = UDim.new(0, 12)})
    Make("UIStroke", MainFrame, {Color = Theme.Stroke, Thickness = 2})
    
    -- Top Bar
    local TopBar = Make("Frame", MainFrame, {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.TopBar
    })
    
    Make("UICorner", TopBar, {CornerRadius = UDim.new(0, 12, 0, 0)})
    
    -- Title
    local TitleLabel = Make("TextLabel", TopBar, {
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = Window.Title,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local SubTitleLabel = Make("TextLabel", TopBar, {
        Size = UDim2.new(0.7, 0, 1, -20),
        Position = UDim2.new(0, 15, 0, 20),
        BackgroundTransparency = 1,
        Text = Window.SubTitle,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Close Button
    local CloseButton = Make("TextButton", TopBar, {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 60, 60),
        Text = "×",
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 20
    })
    
    Make("UICorner", CloseButton, {CornerRadius = UDim.new(0, 8)})
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tabs Container
    local TabsContainer = Make("Frame", MainFrame, {
        Size = UDim2.new(0, 120, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1
    })
    
    local TabsScroll = Make("ScrollingFrame", TabsContainer, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    Make("UIListLayout", TabsScroll, {Padding = UDim.new(0, 5)})
    Make("UIPadding", TabsScroll, {PaddingTop = UDim.new(0, 10)})
    
    -- Content Container
    local ContentContainer = Make("Frame", MainFrame, {
        Size = UDim2.new(1, -120, 1, -40),
        Position = UDim2.new(0, 120, 0, 40),
        BackgroundTransparency = 1
    })
    
    -- Dragging
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Window Functions
    function Window:AddMinimizeButton(config)
        local MinimizeButton = Make("TextButton", TopBar, {
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -70, 0.5, -15),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = config.Button.BackgroundColor3 or Theme.Theme,
            BackgroundTransparency = config.Button.BackgroundTransparency or 0,
            Text = "",
            AutoButtonColor = false
        })
        
        Make("UICorner", MinimizeButton, {CornerRadius = config.Corner.CornerRadius or UDim.new(0, 8)})
        
        if config.Button.Image then
            Make("ImageLabel", MinimizeButton, {
                Size = UDim2.new(0.7, 0, 0.7, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Image = config.Button.Image
            })
        end
        
        local minimized = false
        MinimizeButton.MouseButton1Click:Connect(function()
            minimized = not minimized
            if minimized then
                CreateTween(MainFrame, "Size", UDim2.new(0, 500, 0, 40), 0.3)
                CreateTween(ContentContainer, "Visible", false, 0.3)
                CreateTween(TabsContainer, "Visible", false, 0.3)
            else
                CreateTween(MainFrame, "Size", UDim2.new(0, 500, 0, 400), 0.3)
                CreateTween(ContentContainer, "Visible", true, 0.3)
                CreateTween(TabsContainer, "Visible", true, 0.3)
            end
        end)
    end
    
    function Window:MakeTab(config)
        if type(config) == "table" then
            local tabName = config[1] or config.Name or "Tab"
            local tabIcon = config[2] or config.Icon or ""
            
            local Tab = {}
            local TabButton = Make("TextButton", TabsScroll, {
                Size = UDim2.new(0.9, 0, 0, 35),
                BackgroundColor3 = Theme.Element,
                Text = "",
                AutoButtonColor = false
            })
            
            Make("UICorner", TabButton, {CornerRadius = UDim.new(0, 8)})
            
            local TabContent = Make("ScrollingFrame", ContentContainer, {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = Theme.Theme,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                Visible = false
            })
            
            Make("UIListLayout", TabContent, {Padding = UDim.new(0, 8)})
            Make("UIPadding", TabContent, {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10)
            })
            
            local TabLabel = Make("TextLabel", TabButton, {
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = tabName,
                TextColor3 = Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            if tabIcon ~= "" then
                TabLabel.Size = UDim2.new(1, -30, 1, 0)
                TabLabel.Position = UDim2.new(0, 30, 0, 0)
                
                Make("ImageLabel", TabButton, {
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0, 5, 0.5, -10),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Image = tabIcon
                })
            end
            
            -- Auto resize tabs scroll
            local function UpdateTabsSize()
                local contentSize = TabsScroll.UIListLayout.AbsoluteContentSize
                TabsScroll.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y)
            end
            
            UpdateTabsSize()
            TabsScroll.ChildAdded:Connect(UpdateTabsSize)
            TabsScroll.ChildRemoved:Connect(UpdateTabsSize)
            
            -- Auto resize tab content
            local function UpdateTabSize()
                local contentSize = TabContent.UIListLayout.AbsoluteContentSize
                TabContent.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 20)
            end
            
            TabContent.ChildAdded:Connect(UpdateTabSize)
            TabContent.ChildRemoved:Connect(UpdateTabSize)
            TabContent.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateTabSize)
            
            -- Tab switching
            local function SelectTab()
                for _, tab in pairs(ContentContainer:GetChildren()) do
                    if tab:IsA("ScrollingFrame") then
                        tab.Visible = false
                    end
                end
                
                for _, btn in pairs(TabsScroll:GetChildren()) do
                    if btn:IsA("TextButton") then
                        CreateTween(btn, "BackgroundColor3", Theme.Element, 0.2)
                    end
                end
                
                TabContent.Visible = true
                CreateTween(TabButton, "BackgroundColor3", Theme.Theme, 0.2)
            end
            
            TabButton.MouseButton1Click:Connect(SelectTab)
            
            -- Make first tab active
            if #TabsScroll:GetChildren() == 1 then
                SelectTab()
            end
            
            -- Tab Functions
            function Tab:AddTextBox(config)
                local textBoxFrame = Make("Frame", TabContent, {
                    Size = UDim2.new(1, 0, 0, 60),
                    BackgroundColor3 = Theme.Element
                })
                
                Make("UICorner", textBoxFrame, {CornerRadius = UDim.new(0, 8)})
                Make("UIStroke", textBoxFrame, {Color = Theme.Stroke, Thickness = 1})
                
                local titleLabel = Make("TextLabel", textBoxFrame, {
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1,
                    Text = config.Name or "Text Box",
                    TextColor3 = Theme.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local descLabel = Make("TextLabel", textBoxFrame, {
                    Size = UDim2.new(1, -20, 0, 15),
                    Position = UDim2.new(0, 10, 0, 25),
                    BackgroundTransparency = 1,
                    Text = config.Description or "",
                    TextColor3 = Color3.fromRGB(180, 180, 180),
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local textBox = Make("TextBox", textBoxFrame, {
                    Size = UDim2.new(1, -20, 0, 25),
                    Position = UDim2.new(0, 10, 1, -30),
                    BackgroundColor3 = Theme.Background,
                    TextColor3 = Theme.Text,
                    PlaceholderText = config.PlaceholderText or "Type here...",
                    Font = Enum.Font.Gotham,
                    TextSize = 12
                })
                
                Make("UICorner", textBox, {CornerRadius = UDim.new(0, 6)})
                
                textBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        config.Callback(textBox.Text)
                    end
                end)
                
                UpdateTabSize()
            end
            
            function Tab:NewButton(name, description, callback)
                local buttonFrame = Make("Frame", TabContent, {
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundColor3 = Theme.Element
                })
                
                Make("UICorner", buttonFrame, {CornerRadius = UDim.new(0, 8)})
                Make("UIStroke", buttonFrame, {Color = Theme.Stroke, Thickness = 1})
                
                local button = Make("TextButton", buttonFrame, {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = ""
                })
                
                local titleLabel = Make("TextLabel", buttonFrame, {
                    Size = UDim2.new(1, -20, 0, 25),
                    Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local descLabel = Make("TextLabel", buttonFrame, {
                    Size = UDim2.new(1, -20, 0, 15),
                    Position = UDim2.new(0, 10, 0, 30),
                    BackgroundTransparency = 1,
                    Text = description,
                    TextColor3 = Color3.fromRGB(180, 180, 180),
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                button.MouseButton1Click:Connect(callback)
                
                -- Hover effects
                button.MouseEnter:Connect(function()
                    CreateTween(buttonFrame, "BackgroundColor3", Color3.fromRGB(
                        Theme.Element.R * 255 + 10,
                        Theme.Element.G * 255 + 10,
                        Theme.Element.B * 255 + 10
                    ), 0.2)
                end)
                
                button.MouseLeave:Connect(function()
                    CreateTween(buttonFrame, "BackgroundColor3", Theme.Element, 0.2)
                end)
                
                UpdateTabSize()
            end
            
            function Tab:AddToggle(config)
                local toggleFrame = Make("Frame", TabContent, {
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundColor3 = Theme.Element
                })
                
                Make("UICorner", toggleFrame, {CornerRadius = UDim.new(0, 8)})
                Make("UIStroke", toggleFrame, {Color = Theme.Stroke, Thickness = 1})
                
                local titleLabel = Make("TextLabel", toggleFrame, {
                    Size = UDim2.new(0.7, 0, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name or "Toggle",
                    TextColor3 = Theme.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local toggleButton = Make("TextButton", toggleFrame, {
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -50, 0.5, -10),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = config.Default and Theme.Theme or Theme.Stroke,
                    Text = "",
                    AutoButtonColor = false
                })
                
                Make("UICorner", toggleButton, {CornerRadius = UDim.new(1, 0)})
                
                local toggleKnob = Make("Frame", toggleButton, {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = config.Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Theme.Text
                })
                
                Make("UICorner", toggleKnob, {CornerRadius = UDim.new(1, 0)})
                
                local toggled = config.Default or false
                
                toggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    
                    if toggled then
                        CreateTween(toggleButton, "BackgroundColor3", Theme.Theme, 0.2)
                        CreateTween(toggleKnob, "Position", UDim2.new(1, -18, 0.5, -8), 0.2)
                    else
                        CreateTween(toggleButton, "BackgroundColor3", Theme.Stroke, 0.2)
                        CreateTween(toggleKnob, "Position", UDim2.new(0, 2, 0.5, -8), 0.2)
                    end
                    
                    config.Callback(toggled)
                end)
                
                UpdateTabSize()
            end
            
            function Tab:AddDiscordInvite(config)
                local discordFrame = Make("Frame", TabContent, {
                    Size = UDim2.new(1, 0, 0, 80),
                    BackgroundColor3 = Theme.Element
                })
                
                Make("UICorner", discordFrame, {CornerRadius = UDim.new(0, 8)})
                Make("UIStroke", discordFrame, {Color = Theme.Stroke, Thickness = 1})
                
                if config.Logo then
                    Make("ImageLabel", discordFrame, {
                        Size = UDim2.new(0, 50, 0, 50),
                        Position = UDim2.new(0, 15, 0.5, -25),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundTransparency = 1,
                        Image = config.Logo
                    })
                end
                
                local titleLabel = Make("TextLabel", discordFrame, {
                    Size = UDim2.new(0.7, -60, 0, 25),
                    Position = UDim2.new(0, 75, 0, 15),
                    BackgroundTransparency = 1,
                    Text = config.Name or "Discord",
                    TextColor3 = Theme.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local descLabel = Make("TextLabel", discordFrame, {
                    Size = UDim2.new(0.7, -60, 0, 15),
                    Position = UDim2.new(0, 75, 0, 40),
                    BackgroundTransparency = 1,
                    Text = config.Description or "Join our server!",
                    TextColor3 = Color3.fromRGB(180, 180, 180),
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local joinButton = Make("TextButton", discordFrame, {
                    Size = UDim2.new(0, 80, 0, 25),
                    Position = UDim2.new(1, -90, 0.5, -12),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Theme.Theme,
                    Text = "Join",
                    TextColor3 = Theme.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 12
                })
                
                Make("UICorner", joinButton, {CornerRadius = UDim.new(0, 6)})
                
                joinButton.MouseButton1Click:Connect(function()
                    if config.Invite then
                        setclipboard(config.Invite)
                    end
                end)
                
                UpdateTabSize()
            end
            
            return Tab
        end
    end
    
    return Window
end

return redzlib            frame.Position = UDim2.new(
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
