local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui") or gethui()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function AntiAFK()
    LocalPlayer.Idled:connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

AntiAFK()

local Library = {
    Themes = {
        DarkerRed = {
            ["Color Hub 1"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(10,10,10)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(20,20,20)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(10,10,10))
            }),
            ["Color Hub 2"] = Color3.fromRGB(30,30,30),
            ["Color Stroke"] = Color3.fromRGB(40,40,40),
            ["Color Theme"] = Color3.fromRGB(200,0,0),
            ["Color Text"] = Color3.fromRGB(255,255,255),
            ["Color Dark Text"] = Color3.fromRGB(150,150,150)
        }
    },
    Info = {Version = ""},
    Save = {
        UISize = {550,350},
        TabSize = 160,
        Theme = "DarkerRed"
    },
    Instances = {},
    Elements = {},
    Options = {},
    Flags = {},
    Tabs = {}
}

local function CreateInstance(className, props, children)
    local instance = Instance.new(className)
    if props then
        for prop, value in pairs(props) do
            instance[prop] = value
        end
    end
    if children then
        for _, child in pairs(children) do
            child.Parent = instance
        end
    end
    return instance
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 7)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(40,40,40)
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = "Border"
    stroke.Parent = parent
    return stroke
end

local ScreenGui = CreateInstance("ScreenGui", {
    Name = "Speed Hub X Lib V3",
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local MainFrame = CreateInstance("Frame", {
    Name = "Main",
    Parent = ScreenGui,
    Size = UDim2.new(0, 550, 0, 350),
    Position = UDim2.new(0.5, -275, 0.5, -175),
    BackgroundColor3 = Color3.fromRGB(30,30,30),
    Active = true,
    Draggable = true
}, {
    CreateCorner(MainFrame)
})

local TopBar = CreateInstance("Frame", {
    Name = "TopBar",
    Parent = MainFrame,
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(20,20,20)
}, {
    CreateCorner(TopBar, {TopLeft = 7, TopRight = 7}),
    CreateInstance("TextLabel", {
        Name = "Title",
        Text = "Speed Hub X",
        TextColor3 = Color3.fromRGB(255,255,255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 0, 20)
    }),
    CreateInstance("TextButton", {
        Name = "Close",
        Text = "X",
        TextColor3 = Color3.fromRGB(255,100,100),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Position = UDim2.new(1, -30, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20)
    })
})

local TabsContainer = CreateInstance("Frame", {
    Name = "TabsContainer",
    Parent = MainFrame,
    Size = UDim2.new(0, 160, 1, -30),
    Position = UDim2.new(0, 0, 0, 30),
    BackgroundTransparency = 1
})

local ContentContainer = CreateInstance("ScrollingFrame", {
    Name = "ContentContainer",
    Parent = MainFrame,
    Size = UDim2.new(1, -160, 1, -30),
    Position = UDim2.new(0, 160, 0, 30),
    BackgroundTransparency = 1,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Color3.fromRGB(200,0,0),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
}, {
    CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 10)
    }),
    CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })
})

function Library:AddTab(tabName, icon)
    local TabButton = CreateInstance("TextButton", {
        Name = tabName,
        Text = tabName,
        Parent = TabsContainer,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        TextColor3 = Color3.fromRGB(255,255,255),
        Font = Enum.Font.GothamMedium,
        TextSize = 12
    }, {
        CreateCorner(TabButton, 5),
        CreateInstance("UIStroke", {
            Color = Color3.fromRGB(60,60,60),
            Thickness = 1
        })
    })
    
    local TabContent = CreateInstance("Frame", {
        Name = tabName .. "Content",
        Parent = ContentContainer,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Visible = false
    }, {
        CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 5)
        })
    })
    
    TabButton.MouseButton1Click:Connect(function()
        for _, child in pairs(ContentContainer:GetChildren()) do
            if child:IsA("Frame") then
                child.Visible = false
            end
        end
        TabContent.Visible = true
    end)
    
    local Tab = {}
    
    function Tab:AddToggle(options)
        local toggleName = options.Name or "Toggle"
        local defaultValue = options.Default or false
        local callback = options.Callback or function() end
        
        local ToggleFrame = CreateInstance("Frame", {
            Name = toggleName,
            Parent = TabContent,
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundTransparency = 1
        })
        
        local ToggleButton = CreateInstance("TextButton", {
            Name = "ToggleButton",
            Parent = ToggleFrame,
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -10, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = defaultValue and Color3.fromRGB(200,0,0) or Color3.fromRGB(60,60,60),
            Text = "",
            AutoButtonColor = false
        }, {
            CreateCorner(ToggleButton, 10),
            CreateInstance("Frame", {
                Name = "ToggleCircle",
                Size = UDim2.new(0, 14, 0, 14),
                Position = defaultValue and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(255,255,255)
            }, {
                CreateCorner(nil, 7)
            })
        })
        
        local ToggleLabel = CreateInstance("TextLabel", {
            Name = "ToggleLabel",
            Parent = ToggleFrame,
            Size = UDim2.new(1, -50, 1, 0),
            Text = toggleName,
            TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local isToggled = defaultValue
        
        ToggleButton.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            callback(isToggled)
            
            local tween = TweenService:Create(
                ToggleButton.ToggleCircle,
                TweenInfo.new(0.2),
                {Position = isToggled and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)}
            )
            tween:Play()
            
            ToggleButton.BackgroundColor3 = isToggled and Color3.fromRGB(200,0,0) or Color3.fromRGB(60,60,60)
        end)
        
        local ToggleObject = {}
        function ToggleObject:Set(value)
            if isToggled ~= value then
                ToggleButton.MouseButton1Click:Fire()
            end
        end
        
        function ToggleObject:Get()
            return isToggled
        end
        
        return ToggleObject
    end
    
    function Tab:AddButton(options)
        local buttonName = options.Name or "Button"
        local callback = options.Callback or function() end
        
        local Button = CreateInstance("TextButton", {
            Name = buttonName,
            Parent = TabContent,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(40,40,40),
            Text = buttonName,
            TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            AutoButtonColor = false
        }, {
            CreateCorner(Button, 5),
            CreateInstance("UIStroke", {
                Color = Color3.fromRGB(60,60,60),
                Thickness = 1
            })
        })
        
        Button.MouseButton1Click:Connect(callback)
        
        local ButtonObject = {}
        function ButtonObject:SetText(text)
            Button.Text = text
        end
        
        return ButtonObject
    end
    
    function Tab:AddSlider(options)
        local sliderName = options.Name or "Slider"
        local minValue = options.Min or 0
        local maxValue = options.Max or 100
        local defaultValue = options.Default or 50
        local callback = options.Callback or function() end
        
        local SliderFrame = CreateInstance("Frame", {
            Name = sliderName,
            Parent = TabContent,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundTransparency = 1
        })
        
        local SliderLabel = CreateInstance("TextLabel", {
            Name = "SliderLabel",
            Parent = SliderFrame,
            Size = UDim2.new(1, 0, 0, 15),
            Text = sliderName .. ": " .. defaultValue,
            TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local SliderBar = CreateInstance("Frame", {
            Name = "SliderBar",
            Parent = SliderFrame,
            Size = UDim2.new(1, 0, 0, 5),
            Position = UDim2.new(0, 0, 1, -5),
            BackgroundColor3 = Color3.fromRGB(60,60,60)
        }, {
            CreateCorner(SliderBar, 3)
        })
        
        local SliderFill = CreateInstance("Frame", {
            Name = "SliderFill",
            Parent = SliderBar,
            Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(200,0,0)
        }, {
            CreateCorner(SliderFill, 3)
        })
        
        local SliderButton = CreateInstance("Frame", {
            Name = "SliderButton",
            Parent = SliderBar,
            Size = UDim2.new(0, 15, 0, 15),
            Position = UDim2.new(SliderFill.Size.X.Scale, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255,255,255)
        }, {
            CreateCorner(SliderButton, 7)
        })
        
        local isDragging = false
        local currentValue = defaultValue
        
        local function updateSlider(value)
            currentValue = math.clamp(value, minValue, maxValue)
            local percent = (currentValue - minValue) / (maxValue - minValue)
            
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderButton.Position = UDim2.new(percent, 0, 0.5, 0)
            SliderLabel.Text = sliderName .. ": " .. currentValue
            
            callback(currentValue)
        end
        
        SliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = true
            end
        end)
        
        SliderButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = UserInputService:GetMouseLocation()
                local sliderAbsPos = SliderBar.AbsolutePosition
                local sliderAbsSize = SliderBar.AbsoluteSize
                
                local relativeX = (mousePos.X - sliderAbsPos.X) / sliderAbsSize.X
                relativeX = math.clamp(relativeX, 0, 1)
                
                local value = minValue + (relativeX * (maxValue - minValue))
                updateSlider(value)
            end
        end)
        
        updateSlider(defaultValue)
        
        local SliderObject = {}
        function SliderObject:Set(value)
            updateSlider(value)
        end
        
        function SliderObject:Get()
            return currentValue
        end
        
        return SliderObject
    end
    
    function Tab:AddDropdown(options)
        local dropdownName = options.Name or "Dropdown"
        local optionsList = options.Options or {}
        local defaultValue = options.Default or ""
        local callback = options.Callback or function() end
        
        local DropdownFrame = CreateInstance("Frame", {
            Name = dropdownName,
            Parent = TabContent,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1
        })
        
        local DropdownButton = CreateInstance("TextButton", {
            Name = "DropdownButton",
            Parent = DropdownFrame,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(40,40,40),
            Text = defaultValue ~= "" and defaultValue or "Select...",
            TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            AutoButtonColor = false
        }, {
            CreateCorner(DropdownButton, 5),
            CreateInstance("UIStroke", {
                Color = Color3.fromRGB(60,60,60),
                Thickness = 1
            }),
            CreateInstance("TextLabel", {
                Text = "▼",
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -20, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(200,200,200),
                Font = Enum.Font.GothamBold,
                TextSize = 10
            })
        })
        
        local DropdownList = CreateInstance("Frame", {
            Name = "DropdownList",
            Parent = DropdownFrame,
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 1, 5),
            BackgroundColor3 = Color3.fromRGB(40,40,40),
            Visible = false,
            ClipsDescendants = true
        }, {
            CreateCorner(DropdownList, 5),
            CreateInstance("UIStroke", {
                Color = Color3.fromRGB(60,60,60),
                Thickness = 1
            }),
            CreateInstance("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ScrollBarThickness = 3,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y
            }, {
                CreateInstance("UIListLayout", {
                    Padding = UDim.new(0, 2)
                })
            })
        })
        
        local isOpen = false
        local currentSelection = defaultValue
        
        local function toggleDropdown()
            isOpen = not isOpen
            DropdownList.Visible = isOpen
            
            if isOpen then
                local optionCount = #optionsList
                DropdownList.Size = UDim2.new(1, 0, 0, math.min(optionCount * 30, 150))
            else
                DropdownList.Size = UDim2.new(1, 0, 0, 0)
            end
        end
        
        local function selectOption(option)
            currentSelection = option
            DropdownButton.Text = option
            toggleDropdown()
            callback(option)
        end
        
        DropdownButton.MouseButton1Click:Connect(toggleDropdown)
        
        for _, option in pairs(optionsList) do
            local OptionButton = CreateInstance("TextButton", {
                Name = option,
                Parent = DropdownList.ScrollingFrame,
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundColor3 = Color3.fromRGB(50,50,50),
                Text = option,
                TextColor3 = Color3.fromRGB(255,255,255),
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                AutoButtonColor = false
            }, {
                CreateCorner(OptionButton, 3)
            })
            
            OptionButton.MouseButton1Click:Connect(function()
                selectOption(option)
            end)
        end
        
        local DropdownObject = {}
        function DropdownObject:Set(value)
            if table.find(optionsList, value) then
                selectOption(value)
            end
        end
        
        function DropdownObject:Get()
            return currentSelection
        end
        
        return DropdownObject
    end
    
    if #TabsContainer:GetChildren() == 1 then
        TabContent.Visible = true
    end
    
    return Tab
end

TopBar.Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

return Library
