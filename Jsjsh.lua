-- Advanced UI Library for Roblox
-- By: [Your Name]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- المكتبة الرئيسية
local NeoUI = {
    Themes = {
        Dark = {
            Main = Color3.fromRGB(25, 25, 25),
            Secondary = Color3.fromRGB(35, 35, 35),
            Accent = Color3.fromRGB(0, 170, 255),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(180, 180, 180),
            Stroke = Color3.fromRGB(60, 60, 60)
        },
        Light = {
            Main = Color3.fromRGB(240, 240, 240),
            Secondary = Color3.fromRGB(220, 220, 220),
            Accent = Color3.fromRGB(0, 120, 215),
            Text = Color3.fromRGB(30, 30, 30),
            SubText = Color3.fromRGB(100, 100, 100),
            Stroke = Color3.fromRGB(200, 200, 200)
        }
    },
    Windows = {},
    Elements = {},
    Settings = {
        Theme = "Dark",
        AnimationSpeed = 0.25
    }
}

-- وظائف مساعدة
function NeoUI:Create(instanceType, properties, children)
    local instance = Instance.new(instanceType)
    
    if properties then
        for property, value in pairs(properties) do
            instance[property] = value
        end
    end
    
    if children then
        for _, child in pairs(children) do
            child.Parent = instance
        end
    end
    
    return instance
end

function NeoUI:Tween(instance, properties, duration, callback)
    local tweenInfo = TweenInfo.new(duration or self.Settings.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    
    tween:Play()
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    return tween
end

function NeoUI:MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging = false
    local dragInput, startPos, startTime

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = input.Position
            startTime = tick()
            
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
            local delta = input.Position - startPos
            self:Tween(frame, {Position = UDim2.new(
                frame.Position.X.Scale, 
                frame.Position.X.Offset + delta.X,
                frame.Position.Y.Scale, 
                frame.Position.Y.Offset + delta.Y
            )}, 0.1)
        end
    end)
end

-- إنشاء النوافذ
function NeoUI:CreateWindow(options)
    options = options or {}
    local windowName = options.Name or "NeoUI Window"
    local theme = self.Themes[self.Settings.Theme]
    
    local screenGui = self:Create("ScreenGui", {
        Name = windowName,
        Parent = PlayerGui
    })
    
    local mainFrame = self:Create("Frame", {
        Name = "MainFrame",
        Parent = screenGui,
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = theme.Main,
        ClipsDescendants = true
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Create("UIStroke", {
            Color = theme.Stroke,
            Thickness = 2
        })
    })
    
    local titleBar = self:Create("Frame", {
        Name = "TitleBar",
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = theme.Secondary,
        BorderSizePixel = 0
    }, {
        self:Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Name = "TopCorner"
        }),
        self:Create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = windowName,
            TextColor3 = theme.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        self:Create("TextButton", {
            Name = "CloseButton",
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -30, 0, 0),
            BackgroundTransparency = 1,
            Text = "X",
            TextColor3 = theme.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 14
        })
    })
    
    -- جعل النافذة قابلة للسحب
    self:MakeDraggable(mainFrame, titleBar)
    
    -- زر الإغلاق
    titleBar.CloseButton.MouseButton1Click:Connect(function()
        self:Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, function()
            screenGui:Destroy()
        end)
    end)
    
    -- تأثيرات عند المرور بالفأرة
    titleBar.CloseButton.MouseEnter:Connect(function()
        self:Tween(titleBar.CloseButton, {TextColor3 = Color3.fromRGB(255, 80, 80)})
    end)
    
    titleBar.CloseButton.MouseLeave:Connect(function()
        self:Tween(titleBar.CloseButton, {TextColor3 = theme.Text})
    end)
    
    local tabContainer = self:Create("Frame", {
        Name = "TabContainer",
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1
    })
    
    local contentContainer = self:Create("ScrollingFrame", {
        Name = "ContentContainer",
        Parent = mainFrame,
        Size = UDim2.new(1, -20, 1, -80),
        Position = UDim2.new(0, 10, 0, 70),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, {
        self:Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
    })
    
    local window = {
        GUI = screenGui,
        Tabs = {},
        CurrentTab = nil
    }
    
    function window:AddTab(tabName)
        local tabButton = self:Create("TextButton", {
            Name = tabName .. "Tab",
            Parent = tabContainer,
            Size = UDim2.new(0, 100, 1, 0),
            BackgroundColor3 = theme.Secondary,
            Text = tabName,
            TextColor3 = theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            AutoButtonColor = false
        }, {
            self:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
        })
        
        local tabContent = self:Create("Frame", {
            Name = tabName .. "Content",
            Parent = contentContainer,
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Visible = false
        }, {
            self:Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10)
            })
        })
        
        local tab = {
            Name = tabName,
            Button = tabButton,
            Content = tabContent
        }
        
        tabButton.MouseButton1Click:Connect(function()
            window:SwitchTab(tabName)
        end)
        
        table.insert(self.Tabs, tab)
        
        if #self.Tabs == 1 then
            window:SwitchTab(tabName)
        end
        
        return tab
    end
    
    function window:SwitchTab(tabName)
        for _, tab in pairs(self.Tabs) do
            tab.Content.Visible = (tab.Name == tabName)
            self:Tween(tab.Button, {
                BackgroundColor3 = (tab.Name == tabName) and theme.Accent or theme.Secondary
            })
        end
        self.CurrentTab = tabName
    end
    
    table.insert(self.Windows, window)
    return window
end

-- إضافة العناصر إلى التبويبات
function NeoUI:AddButton(tab, options)
    options = options or {}
    local theme = self.Themes[self.Settings.Theme]
    
    local button = self:Create("TextButton", {
        Name = options.Name or "Button",
        Parent = tab.Content,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.Secondary,
        Text = options.Text or "Button",
        TextColor3 = theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        AutoButtonColor = false
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        self:Create("UIStroke", {
            Color = theme.Stroke,
            Thickness = 1
        })
    })
    
    button.MouseEnter:Connect(function()
        self:Tween(button, {BackgroundColor3 = theme.Accent})
    end)
    
    button.MouseLeave:Connect(function()
        self:Tween(button, {BackgroundColor3 = theme.Secondary})
    end)
    
    if options.Callback then
        button.MouseButton1Click:Connect(options.Callback)
    end
    
    return button
end

function NeoUI:AddToggle(tab, options)
    options = options or {}
    local theme = self.Themes[self.Settings.Theme]
    
    local toggleFrame = self:Create("Frame", {
        Name = options.Name or "Toggle",
        Parent = tab.Content,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1
    }, {
        self:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
    })
    
    local label = self:Create("TextLabel", {
        Name = "Label",
        Parent = toggleFrame,
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = options.Text or "Toggle",
        TextColor3 = theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local toggleButton = self:Create("TextButton", {
        Name = "ToggleButton",
        Parent = toggleFrame,
        Size = UDim2.new(0, 50, 0, 25),
        BackgroundColor3 = theme.Secondary,
        Text = "",
        AutoButtonColor = false
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        self:Create("UIStroke", {
            Color = theme.Stroke,
            Thickness = 1
        })
    })
    
    local toggleCircle = self:Create("Frame", {
        Name = "ToggleCircle",
        Parent = toggleButton,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 3, 0.5, -10),
        BackgroundColor3 = theme.Text,
        AnchorPoint = Vector2.new(0, 0.5)
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)})
    })
    
    local isToggled = options.Default or false
    
    local function updateToggle()
        if isToggled then
            self:Tween(toggleButton, {BackgroundColor3 = theme.Accent})
            self:Tween(toggleCircle, {Position = UDim2.new(1, -23, 0.5, -10)})
        else
            self:Tween(toggleButton, {BackgroundColor3 = theme.Secondary})
            self:Tween(toggleCircle, {Position = UDim2.new(0, 3, 0.5, -10)})
        end
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateToggle()
        if options.Callback then
            options.Callback(isToggled)
        end
    end)
    
    updateToggle()
    
    return {
        SetState = function(state)
            isToggled = state
            updateToggle()
        end,
        GetState = function()
            return isToggled
        end
    }
end

function NeoUI:AddSlider(tab, options)
    options = options or {}
    local theme = self.Themes[self.Settings.Theme]
    
    local sliderFrame = self:Create("Frame", {
        Name = options.Name or "Slider",
        Parent = tab.Content,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1
    }, {
        self:Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })
    })
    
    local topFrame = self:Create("Frame", {
        Name = "TopFrame",
        Parent = sliderFrame,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1
    }, {
        self:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
    })
    
    local label = self:Create("TextLabel", {
        Name = "Label",
        Parent = topFrame,
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = options.Text or "Slider",
        TextColor3 = theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local valueLabel = self:Create("TextLabel", {
        Name = "ValueLabel",
        Parent = topFrame,
        Size = UDim2.new(0.3, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = tostring(options.Default or options.Min or 0),
        TextColor3 = theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    local sliderBar = self:Create("Frame", {
        Name = "SliderBar",
        Parent = sliderFrame,
        Size = UDim2.new(1, 0, 0, 10),
        BackgroundColor3 = theme.Secondary,
        ClipsDescendants = true
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 5)})
    })
    
    local sliderFill = self:Create("Frame", {
        Name = "SliderFill",
        Parent = sliderBar,
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundColor3 = theme.Accent
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 5)})
    })
    
    local sliderButton = self:Create("TextButton", {
        Name = "SliderButton",
        Parent = sliderBar,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, -8, 0.5, -8),
        BackgroundColor3 = theme.Text,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 2
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    })
    
    local minValue = options.Min or 0
    local maxValue = options.Max or 100
    local currentValue = options.Default or minValue
    local isSliding = false
    
    local function updateSlider()
        local percentage = (currentValue - minValue) / (maxValue - minValue)
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderButton.Position = UDim2.new(percentage, -8, 0.5, -8)
        valueLabel.Text = tostring(math.floor(currentValue))
    end
    
    local function setValue(value)
        currentValue = math.clamp(value, minValue, maxValue)
        updateSlider()
        if options.Callback then
            options.Callback(currentValue)
        end
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        isSliding = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isSliding = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isSliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = sliderBar.AbsolutePosition
            local sliderSize = sliderBar.AbsoluteSize
            local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
            setValue(minValue + relativeX * (maxValue - minValue))
        end
    end)
    
    updateSlider()
    
    return {
        SetValue = setValue,
        GetValue = function() return currentValue end
    }
end

return NeoUI
