local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local SpeedWave = {
    Themes = {
        Dark = {
            Main = Color3.fromRGB(20, 20, 25),
            Secondary = Color3.fromRGB(30, 30, 35),
            Accent = Color3.fromRGB(200, 0, 0),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(180, 180, 180),
            Stroke = Color3.fromRGB(50, 50, 55)
        }
    },
    Windows = {},
    Notifications = {},
    Settings = {
        Theme = "Dark",
        AnimationSpeed = 0.25
    }
}

function SpeedWave:Create(instanceType, properties, children)
    local instance = Instance.new(instanceType)
    if properties then for property, value in pairs(properties) do instance[property] = value end end
    if children then for _, child in pairs(children) do child.Parent = instance end end
    return instance
end

function SpeedWave:Tween(instance, properties, duration, callback)
    local tweenInfo = TweenInfo.new(duration or self.Settings.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    if callback then tween.Completed:Connect(callback) end
    return tween
end

function SpeedWave:MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, startPos = false
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, startPos = true, input.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startPos
            frame.Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset + delta.X, frame.Position.Y.Scale, frame.Position.Y.Offset + delta.Y)
        end
    end)
end

function SpeedWave:CreateMainWindow()
    local theme = self.Themes[self.Settings.Theme]
    local screenGui = self:Create("ScreenGui", {Name = "SpeedWaveGUI", Parent = PlayerGui})
    
    local mainFrame = self:Create("Frame", {
        Name = "MainFrame", Parent = screenGui, Size = UDim2.new(0, 500, 0, 450),
        Position = UDim2.new(0.5, -250, 0.5, -225), BackgroundColor3 = theme.Main, ClipsDescendants = true
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        self:Create("UIStroke", {Color = theme.Stroke, Thickness = 2})
    })
    
    local titleBar = self:Create("Frame", {
        Name = "TitleBar", Parent = mainFrame, Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = theme.Accent, BorderSizePixel = 0
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10), Name = "TopCorner"}),
        self:Create("TextLabel", {
            Name = "Title", Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1, Text = "SPEED WAVE HUB", TextColor3 = theme.Text,
            Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left
        }),
        self:Create("TextButton", {
            Name = "CloseButton", Size = UDim2.new(0, 35, 0, 35), Position = UDim2.new(1, -35, 0, 0),
            BackgroundTransparency = 1, Text = "X", TextColor3 = theme.Text,
            Font = Enum.Font.GothamBold, TextSize = 16
        })
    })
    
    self:MakeDraggable(mainFrame, titleBar)
    
    titleBar.CloseButton.MouseButton1Click:Connect(function()
        self:Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, function() screenGui:Destroy() end)
    end)
    
    titleBar.CloseButton.MouseEnter:Connect(function()
        self:Tween(titleBar.CloseButton, {TextColor3 = Color3.fromRGB(255, 100, 100)})
    end)
    
    titleBar.CloseButton.MouseLeave:Connect(function()
        self:Tween(titleBar.CloseButton, {TextColor3 = theme.Text})
    end)
    
    local tabButtonsFrame = self:Create("Frame", {
        Name = "TabButtons", Parent = mainFrame, Size = UDim2.new(0, 150, 1, -45),
        Position = UDim2.new(0, 0, 0, 40), BackgroundTransparency = 1
    }, {
        self:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)}),
        self:Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10)})
    })
    
    local contentFrame = self:Create("ScrollingFrame", {
        Name = "ContentFrame", Parent = mainFrame, Size = UDim2.new(1, -160, 1, -55),
        Position = UDim2.new(0, 150, 0, 40), BackgroundTransparency = 1, ScrollBarThickness = 4,
        ScrollBarImageColor3 = theme.Accent, CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, {
        self:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)}),
        self:Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
    })
    
    local tabs = {}
    local tabContents = {}
    local currentTab = nil
    
    local function switchTab(tabName)
        if currentTab then currentTab.Visible = false end
        if tabContents[tabName] then
            tabContents[tabName].Visible = true
            currentTab = tabContents[tabName]
        end
    end
    
    local window = {
        GUI = screenGui,
        Tabs = tabs,
        AddTab = function(self, tabName)
            local tabButton = SpeedWave:Create("TextButton", {
                Name = tabName .. "Tab", Parent = tabButtonsFrame, Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = theme.Secondary, Text = tabName, TextColor3 = theme.Text,
                Font = Enum.Font.Gotham, TextSize = 13, AutoButtonColor = false
            }, {
                SpeedWave:Create("UICorner", {CornerRadius = UDim.new(0, 8)})
            })
            
            local tabContent = SpeedWave:Create("Frame", {
                Name = tabName .. "Content", Parent = contentFrame, Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1, Visible = false
            }, {
                SpeedWave:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})
            })
            
            tabContents[tabName] = tabContent
            tabs[tabName] = tabContent
            
            tabButton.MouseButton1Click:Connect(function()
                switchTab(tabName)
                SpeedWave:Tween(tabButton, {BackgroundColor3 = theme.Accent})
            end)
            
            tabButton.MouseEnter:Connect(function()
                if currentTab ~= tabContent then
                    SpeedWave:Tween(tabButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)})
                end
            end)
            
            tabButton.MouseLeave:Connect(function()
                if currentTab ~= tabContent then
                    SpeedWave:Tween(tabButton, {BackgroundColor3 = theme.Secondary})
                end
            end)
            
            if #tabs == 1 then switchTab(tabName) SpeedWave:Tween(tabButton, {BackgroundColor3 = theme.Accent}) end
            
            return tabContent
        end
    }
    
    return window
end

function SpeedWave:AddButton(tab, options)
    local theme = self.Themes[self.Settings.Theme]
    local button = self:Create("TextButton", {
        Name = options.Name or "Button", Parent = tab, Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = theme.Secondary, Text = options.Name or "Button", TextColor3 = theme.Text,
        Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Create("UIPadding", {PaddingLeft = UDim.new(0, 10)})
    })
    
    button.MouseEnter:Connect(function()
        self:Tween(button, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)})
    end)
    
    button.MouseLeave:Connect(function()
        self:Tween(button, {BackgroundColor3 = theme.Secondary})
    end)
    
    if options.Callback then
        button.MouseButton1Click:Connect(options.Callback)
    end
    
    return button
end

function SpeedWave:AddToggle(tab, options)
    local theme = self.Themes[self.Settings.Theme]
    local toggleFrame = self:Create("Frame", {
        Name = options.Name or "Toggle", Parent = tab, Size = UDim2.new(1, 0, 0, 35),
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
        Name = "Label", Parent = toggleFrame, Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1, Text = options.Name or "Toggle", TextColor3 = theme.Text,
        Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local toggleButton = self:Create("TextButton", {
        Name = "ToggleButton", Parent = toggleFrame, Size = UDim2.new(0, 50, 0, 25),
        BackgroundColor3 = theme.Secondary, Text = "", AutoButtonColor = false
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        self:Create("UIStroke", {Color = theme.Stroke, Thickness = 1})
    })
    
    local toggleCircle = self:Create("Frame", {
        Name = "ToggleCircle", Parent = toggleButton, Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 3, 0.5, -10), BackgroundColor3 = theme.Text,
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
        if options.Callback then options.Callback(isToggled) end
    end)
    
    updateToggle()
    
    return {
        SetState = function(state) isToggled = state updateToggle() end,
        GetState = function() return isToggled end
    }
end

function SpeedWave:AddSlider(tab, options)
    local theme = self.Themes[self.Settings.Theme]
    local sliderFrame = self:Create("Frame", {
        Name = options.Name or "Slider", Parent = tab, Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1
    }, {
        self:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    })
    
    local topFrame = self:Create("Frame", {
        Name = "TopFrame", Parent = sliderFrame, Size = UDim2.new(1, 0, 0, 20),
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
        Name = "Label", Parent = topFrame, Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1, Text = options.Name or "Slider", TextColor3 = theme.Text,
        Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local valueLabel = self:Create("TextLabel", {
        Name = "ValueLabel", Parent = topFrame, Size = UDim2.new(0.3, 0, 1, 0),
        BackgroundTransparency = 1, Text = tostring(options.Default or options.Min or 0),
        TextColor3 = theme.SubText, Font = Enum.Font.Gotham, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    local sliderBar = self:Create("Frame", {
        Name = "SliderBar", Parent = sliderFrame, Size = UDim2.new(1, 0, 0, 10),
        BackgroundColor3 = theme.Secondary, ClipsDescendants = true
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 5)})
    })
    
    local sliderFill = self:Create("Frame", {
        Name = "SliderFill", Parent = sliderBar, Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundColor3 = options.SliderColor or theme.Accent
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 5)})
    })
    
    local sliderButton = self:Create("TextButton", {
        Name = "SliderButton", Parent = sliderBar, Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, -8, 0.5, -8), BackgroundColor3 = theme.Text,
        Text = "", AutoButtonColor = false, ZIndex = 2
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    })
    
    local minValue, maxValue = options.Min or 0, options.Max or 100
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
        if options.Callback then options.Callback(currentValue) end
    end
    
    sliderButton.MouseButton1Down:Connect(function() isSliding = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then isSliding = false end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isSliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos, sliderSize = sliderBar.AbsolutePosition, sliderBar.AbsoluteSize
            local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
            setValue(minValue + relativeX * (maxValue - minValue))
        end
    end)
    
    updateSlider()
    
    return {SetValue = setValue, GetValue = function() return currentValue end}
end

function SpeedWave:AddDropdown(tab, options)
    local theme = self.Themes[self.Settings.Theme]
    local dropdownFrame = self:Create("Frame", {
        Name = options.Name or "Dropdown", Parent = tab, Size = UDim2.new(1, 0, 0, 35),
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
        Name = "Label", Parent = dropdownFrame, Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1, Text = options.Name or "Dropdown", TextColor3 = theme.Text,
        Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local dropdownButton = self:Create("TextButton", {
        Name = "DropdownButton", Parent = dropdownFrame, Size = UDim2.new(0.3, 0, 0, 25),
        BackgroundColor3 = theme.Secondary, Text = options.Defaul or "Select", TextColor3 = theme.Text,
        Font = Enum.Font.Gotham, TextSize = 12, AutoButtonColor = false
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
    })
    
    local dropdownMenu = self:Create("ScrollingFrame", {
        Name = "DropdownMenu", Parent = dropdownFrame, Size = UDim2.new(0.3, 0, 0, 100),
        Position = UDim2.new(0.7, 0, 1, 5), BackgroundColor3 = theme.Secondary,
        ScrollBarThickness = 4, ScrollBarImageColor3 = theme.Accent, Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        self:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)}),
        self:Create("UIPadding", {PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)})
    })
    
    local isOpen = false
    
    local function toggleMenu()
        isOpen = not isOpen
        dropdownMenu.Visible = isOpen
    end
    
    dropdownButton.MouseButton1Click:Connect(toggleMenu)
    
    for _, option in ipairs(options.Options or {}) do
        local optionButton = self:Create("TextButton", {
            Name = option, Parent = dropdownMenu, Size = UDim2.new(1, -10, 0, 25),
            BackgroundColor3 = theme.Main, Text = option, TextColor3 = theme.Text,
            Font = Enum.Font.Gotham, TextSize = 12, AutoButtonColor = false
        }, {
            self:Create("UICorner", {CornerRadius = UDim.new(0, 4)})
        })
        
        optionButton.MouseEnter:Connect(function()
            self:Tween(optionButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)})
        end)
        
        optionButton.MouseLeave:Connect(function()
            self:Tween(optionButton, {BackgroundColor3 = theme.Main})
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = option
            toggleMenu()
            if options.Callback then options.Callback(option) end
        end)
    end
    
    return {
        SetOptions = function(newOptions)
            for _, child in ipairs(dropdownMenu:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            for _, option in ipairs(newOptions) do
                local optionButton = self:Create("TextButton", {
                    Name = option, Parent = dropdownMenu, Size = UDim2.new(1, -10, 0, 25),
                    BackgroundColor3 = theme.Main, Text = option, TextColor3 = theme.Text,
                    Font = Enum.Font.Gotham, TextSize = 12, AutoButtonColor = false
                }, {
                    self:Create("UICorner", {CornerRadius = UDim.new(0, 4)})
                })
                
                optionButton.MouseEnter:Connect(function()
                    self:Tween(optionButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)})
                end)
                
                optionButton.MouseLeave:Connect(function()
                    self:Tween(optionButton, {BackgroundColor3 = theme.Main})
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    dropdownButton.Text = option
                    toggleMenu()
                    if options.Callback then options.Callback(option) end
                end)
            end
        end
    }
end

function SpeedWave:AddTextBox(tab, options)
    local theme = self.Themes[self.Settings.Theme]
    local textBoxFrame = self:Create("Frame", {
        Name = options.Name or "TextBox", Parent = tab, Size = UDim2.new(1, 0, 0, 35),
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
        Name = "Label", Parent = textBoxFrame, Size = UDim2.new(0.3, 0, 1, 0),
        BackgroundTransparency = 1, Text = options.Name or "Input", TextColor3 = theme.Text,
        Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local textBox = self:Create("TextBox", {
        Name = "TextBox", Parent = textBoxFrame, Size = UDim2.new(0.7, 0, 0, 25),
        BackgroundColor3 = theme.Secondary, Text = options.Default or "", TextColor3 = theme.Text,
        Font = Enum.Font.Gotham, TextSize = 13, PlaceholderText = options.Name or "Type here...",
        ClearTextOnFocus = false
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        self:Create("UIPadding", {PaddingLeft = UDim.new(0, 5)})
    })
    
    textBox.FocusLost:Connect(function()
        if options.Callback then options.Callback(textBox.Text) end
    end)
    
    return {
        SetText = function(text) textBox.Text = text end,
        GetText = function() return textBox.Text end
    }
end

function SpeedWave:AddSection(tab, options)
    local theme = self.Themes[self.Settings.Theme]
    local section = self:Create("Frame", {
        Name = options.Name or "Section", Parent = tab, Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1
    }, {
        self:Create("TextLabel", {
            Name = "SectionLabel", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Text = options.Name or "Section", TextColor3 = theme.Accent, Font = Enum.Font.GothamBold,
            TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
        }),
        self:Create("UIStroke", {
            Color = theme.Accent, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })
    })
    
    return section
end

function SpeedWave:AddLabel(tab, options)
    local theme = self.Themes[self.Settings.Theme]
    local label = self:Create("TextLabel", {
        Name = "Label", Parent = tab, Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1, Text = options[1] or "Label", TextColor3 = theme.Text,
        Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left
    })
    
    return label
end

function SpeedWave:AddParagraph(tab, options)
    local theme = self.Themes[self.Settings.Theme]
    local paragraphFrame = self:Create("Frame", {
        Name = "Paragraph", Parent = tab, Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1
    }, {
        self:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    })
    
    local title = self:Create("TextLabel", {
        Name = "Title", Parent = paragraphFrame, Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1, Text = options[1] or "Title", TextColor3 = theme.Text,
        Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local content = self:Create("TextLabel", {
        Name = "Content", Parent = paragraphFrame, Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1, Text = options[2] or "Content", TextColor3 = theme.SubText,
        Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    })
    
    return {Title = title, Content = content}
end

function SpeedWave:AddColorPicker(tab, options)
    local theme = self.Themes[self.Settings.Theme]
    local colorPickerFrame = self:Create("Frame", {
        Name = options.Name or "ColorPicker", Parent = tab, Size = UDim2.new(1, 0, 0, 35),
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
        Name = "Label", Parent = colorPickerFrame, Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1, Text = options.Name or "Color Picker", TextColor3 = theme.Text,
        Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local colorButton = self:Create("TextButton", {
        Name = "ColorButton", Parent = colorPickerFrame, Size = UDim2.new(0, 25, 0, 25),
        BackgroundColor3 = options.Default or Color3.fromRGB(200, 0, 0), AutoButtonColor = false
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        self:Create("UIStroke", {Color = theme.Stroke, Thickness = 1})
    })
    
    colorButton.MouseButton1Click:Connect(function()
        if options.Callback then options.Callback(colorButton.BackgroundColor3) end
    end)
    
    return {
        SetColor = function(color) colorButton.BackgroundColor3 = color end,
        GetColor = function() return colorButton.BackgroundColor3 end
    }
end

function SpeedWave:MakeNotifi(options)
    local theme = self.Themes[self.Settings.Theme]
    local notification = self:Create("Frame", {
        Name = "Notification", Parent = PlayerGui, Size = UDim2.new(0, 300, 0, 60),
        Position = UDim2.new(1, -320, 0, 10), BackgroundColor3 = theme.Main,
        ClipsDescendants = true
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Create("UIStroke", {Color = theme.Stroke, Thickness = 2}),
        self:Create("Frame", {
            Name = "Header", Size = UDim2.new(1, 0, 0, 20), BackgroundColor3 = theme.Accent,
            BorderSizePixel = 0
        }, {
            self:Create("UICorner", {CornerRadius = UDim.new(0, 8), Name = "TopCorner"}),
            self:Create("TextLabel", {
                Name = "Title", Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1, Text = options.Title or "Notification",
                TextColor3 = theme.Text, Font = Enum.Font.GothamBold, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        }),
        self:Create("TextLabel", {
            Name = "Text", Size = UDim2.new(1, -10, 1, -25), Position = UDim2.new(0, 10, 0, 25),
            BackgroundTransparency = 1, Text = options.Text or "Notification text",
            TextColor3 = theme.Text, Font = Enum.Font.Gotham, TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
        })
    })
    
    self:Tween(notification, {Position = UDim2.new(1, -320, 0, 10)})
    
    task.delay(options.Time or 5, function()
        self:Tween(notification, {Position = UDim2.new(1, 320, 0, 10)}, 0.5, function()
            notification:Destroy()
        end)
    end)
end

function SpeedWave:AddInfo(tab, options)
    local theme = self.Themes[self.Settings.Theme]
    local infoFrame = self:Create("Frame", {
        Name = "Info", Parent = tab, Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1
    }, {
        self:Create("TextLabel", {
            Name = "InfoText", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Text = options.Title or "SPEED WAVE HUB", TextColor3 = theme.Accent,
            Font = options.Font or Enum.Font.GothamBold, TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Center
        })
    })
    
    return infoFrame
end

function SpeedWave:MinimizeButton(options)
    local theme = self.Themes[self.Settings.Theme]
    local minimizeButton = self:Create("ImageButton", {
        Name = "MinimizeButton", Parent = PlayerGui, Size = UDim2.new(0, options.Size[1] or 50, 0, options.Size[2] or 50),
        Position = UDim2.new(0, 10, 0, 10), BackgroundColor3 = options.Color or theme.Accent,
        Image = options.Image or "", ScaleType = Enum.ScaleType.Fit, AutoButtonColor = false
    })
    
    if options.Corner then
        self:Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = minimizeButton})
    end
    
    if options.Stroke then
        self:Create("UIStroke", {
            Color = options.StrokeColor or theme.Stroke,
            Thickness = 2,
            Parent = minimizeButton
        })
    end
    
    local mainWindow = self.Windows[1]
    local isMinimized = false
    
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            self:Tween(mainWindow.GUI.MainFrame, {Size = UDim2.new(0, 0, 0, 0)})
        else
            self:Tween(mainWindow.GUI.MainFrame, {Size = UDim2.new(0, 500, 0, 450)})
        end
    end)
    
    return minimizeButton
end

function SpeedWave:AddDiscordInvite(tab, options)
    local theme = self.Themes[self.Settings.Theme]
    local discordFrame = self:Create("Frame", {
        Name = "DiscordInvite", Parent = tab, Size = UDim2.new(1, 0, 0, 80),
        BackgroundColor3 = theme.Secondary, ClipsDescendants = true
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        }),
        self:Create("UIPadding", {PaddingLeft = UDim.new(0, 10)})
    })
    
    local logo = self:Create("ImageLabel", {
        Name = "Logo", Parent = discordFrame, Size = UDim2.new(0, 50, 0, 50),
        Image = options.Logo or "rbxassetid://80702623942042", BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Fit
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 25)})
    })
    
    local textFrame = self:Create("Frame", {
        Name = "TextFrame", Parent = discordFrame, Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1
    }, {
        self:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    })
    
    local title = self:Create("TextLabel", {
        Name = "Title", Parent = textFrame, Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1, Text = options.Title or "Discord Server",
        TextColor3 = theme.Text, Font = Enum.Font.GothamBold, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local desc = self:Create("TextLabel", {
        Name = "Desc", Parent = textFrame, Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1, Text = options.Desc or "Join our Discord server",
        TextColor3 = theme.SubText, Font = Enum.Font.Gotham, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
    })
    
    local joinButton = self:Create("TextButton", {
        Name = "JoinButton", Parent = discordFrame, Size = UDim2.new(0, 60, 0, 25),
        BackgroundColor3 = theme.Accent, Text = "Join", TextColor3 = theme.Text,
        Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
    })
    
    joinButton.MouseButton1Click:Connect(function()
        setclipboard(options.Invite or "https://discord.gg/example")
        self:MakeNotifi({Title = "Discord", Text = "Invite link copied to clipboard!", Time = 3})
    end)
    
    return discordFrame
end

function SpeedWave:AddTelegramInvite(tab, options)
    local theme = self.Themes[self.Settings.Theme]
    local telegramFrame = self:Create("Frame", {
        Name = "TelegramInvite", Parent = tab, Size = UDim2.new(1, 0, 0, 80),
        BackgroundColor3 = theme.Secondary, ClipsDescendants = true
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        }),
        self:Create("UIPadding", {PaddingLeft = UDim.new(0, 10)})
    })
    
    local logo = self:Create("ImageLabel", {
        Name = "Logo", Parent = telegramFrame, Size = UDim2.new(0, 50, 0, 50),
        Image = options.Logo or "rbxassetid://80314562853706", BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Fit
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 25)})
    })
    
    local textFrame = self:Create("Frame", {
        Name = "TextFrame", Parent = telegramFrame, Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1
    }, {
        self:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    })
    
    local title = self:Create("TextLabel", {
        Name = "Title", Parent = textFrame, Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1, Text = options.Title or "Telegram Channel",
        TextColor3 = theme.Text, Font = Enum.Font.GothamBold, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local desc = self:Create("TextLabel", {
        Name = "Desc", Parent = textFrame, Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1, Text = options.Desc or "Join our Telegram channel",
        TextColor3 = theme.SubText, Font = Enum.Font.Gotham, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
    })
    
    local joinButton = self:Create("TextButton", {
        Name = "JoinButton", Parent = telegramFrame, Size = UDim2.new(0, 60, 0, 25),
        BackgroundColor3 = Color3.fromRGB(0, 136, 204), Text = "Join", TextColor3 = theme.Text,
        Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
    })
    
    joinButton.MouseButton1Click:Connect(function()
        setclipboard(options.Invite or "https://t.me/example")
        self:MakeNotifi({Title = "Telegram", Text = "Invite link copied to clipboard!", Time = 3})
    end)
    
    return telegramFrame
end

function SpeedWave:AddGameImage(tab, options)
    local theme = self.Themes[self.Settings.Theme]
    local gameFrame = self:Create("Frame", {
        Name = "GameImage", Parent = tab, Size = UDim2.new(1, 0, 0, 100),
        BackgroundColor3 = theme.Secondary, ClipsDescendants = true
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    })
    
    local gameImage = self:Create("ImageLabel", {
        Name = "Image", Parent = gameFrame, Size = UDim2.new(1, 0, 1, 0),
        Image = "rbxassetid://0", BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Crop
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    })
    
    local overlay = self:Create("TextButton", {
        Name = "Overlay", Parent = gameFrame, Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.7,
        Text = "", AutoButtonColor = false
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Create("TextLabel", {
            Name = "GameName", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Text = "Game Name", TextColor3 = theme.Text, Font = Enum.Font.GothamBold,
            TextSize = 14, TextXAlignment = Enum.TextXAlignment.Center
        })
    })
    
    if options.CopyText then
        overlay.MouseButton1Click:Connect(function()
            setclipboard(options.CopyText)
            self:MakeNotifi({Title = "Game", Text = "Link copied to clipboard!", Time = 3})
        end)
    end
    
    return gameFrame
end

return SpeedWave
