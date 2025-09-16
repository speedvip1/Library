repeat task.wait() until game:IsLoaded()
local Configs_HUB = {
  Hub = Color3.fromRGB(10, 10, 10),
  Corner = UDim.new(0, 4),
  Stroke = Color3.fromRGB(255, 5, 5),
  TextColor = Color3.fromRGB(240, 240, 240),
  DarkText = Color3.fromRGB(240, 240, 240),
  Font = Enum.Font.FredokaOne
}
local Buttons_Hub = {
  Size = 30,
  TextSize = 14
}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function RainbowMenu(menu, menuColor)
  task.spawn(function()
    while task.wait() do
      local function tween(color)
        local menucolor = menuColor or "BackgroundColor3"
        local tween = TweenService:Create(menu, TweenInfo.new(2, Enum.EasingStyle.Linear),
        {[menucolor] = color})tween:play()tween.Completed:Wait()
      end
      tween(Color3.fromRGB(255, 0, 0))
      tween(Color3.fromRGB(0, 255, 0))
      tween(Color3.fromRGB(0, 0, 255))
      tween(Color3.fromRGB(0, 255, 255))
      tween(Color3.fromRGB(255, 100, 0))
      tween(Color3.fromRGB(255, 255, 0))
      tween(Color3.fromRGB(255, 255, 255))
      tween(Color3.fromRGB(100, 255, 0))
      tween(Color3.fromRGB())
    end
  end)
end

local function Create(instance, name, parent)
  local new = Instance.new(instance, parent)
  new.Name = name or instance or ScreenGui
  return new
end

local function SetConfigs(Element, Props)
	table.foreach(Props, function(Property, Value)
		Element[Property] = Value
	end)
	return Element
end

local function Corner(parent, radius)
  local new = Create("UICorner", "Corner", parent)
  new.CornerRadius = radius or Configs_HUB.Corner
end

local function Stroke(parent, Colorstk, stkmode)
  local new = Create("UIStroke", "Stroke", parent or CoreGui)
  new.ApplyStrokeMode = stkmode or "Border"
  if Configs_HUB.Stroke == "Rainbow" then
    RainbowMenu(new, "Color")
  else
    new.Color = Colorstk or Configs_HUB.Stroke
  end
  return new
end

local ScreenGui = Create("ScreenGui", "REDz HUB", CoreGui)

local ScreenFind = CoreGui:FindFirstChild(ScreenGui.Name)

if ScreenFind and ScreenFind ~= ScreenGui then
  ScreenFind:Destroy()
end

local Menu_Notifi = SetConfigs(Create("Frame", "Notificações", ScreenGui), {
  Size = UDim2.new(0, 300, 1, 0),
  Position = UDim2.new(1, 0, 0, 0),
  AnchorPoint = Vector2.new(1, 0),
  BackgroundTransparency = 1
})

local Padding = SetConfigs(Create("UIPadding", "Padding", Menu_Notifi), {
  PaddingLeft = UDim.new(0, 25),
  PaddingTop = UDim.new(0, 25),
  PaddingBottom = UDim.new(0, 50)
})

local ListLayout = SetConfigs(Create("UIListLayout", "ListLayout", Menu_Notifi), {
  Padding = UDim.new(0, 15),
  VerticalAlignment = "Bottom"
})

function MakeNotifi(Configs)
  local Title = Configs.Title or "REDz HUB"
  local text = Configs.Text or "Notificação"
  local time = Configs.Time or 5
  
  local Frame1 = SetConfigs(Create("Frame", "Frame", Menu_Notifi), {
    Size = UDim2.new(2, 0, 0, 75),
    BackgroundTransparency = 1
  })
  
  local Frame2 = SetConfigs(Create("Frame", "Notifi", Frame1), {
    Size = UDim2.new(0, Menu_Notifi.Size.X.Offset - 50, 0, 75),
    BackgroundColor3 = Configs_HUB.Hub,
    Position = UDim2.new(0, Menu_Notifi.Size.X.Offset, 0, 0),
    AutomaticSize = "Y"
  })Corner(Frame2)
  
  local TextLabel = SetConfigs(Create("TextLabel", "Title", Frame2), {
    Size = UDim2.new(1, 0, 0, 25),
    Font = Configs_HUB.Font,
    BackgroundTransparency = 1,
    Text = Title,
    TextSize = 20,
    Position = UDim2.new(0, 20, 0, 5),
    TextXAlignment = "Left",
    TextColor3 = Configs_HUB.TextColor
  })
  
  local TextButton = SetConfigs(Create("TextButton", "Close", Frame2), {
    Text = "X",
    Font = Configs_HUB.Font,
    TextSize = 20,
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(200, 200, 200),
    Position = UDim2.new(1, -5, 0, 5),
    AnchorPoint = Vector2.new(1, 0),
    Size = UDim2.new(0, 25, 0, 25)
  })
  
  local TextLabel = SetConfigs(Create("TextLabel", "Text", Frame2), {
    Size = UDim2.new(1, -TextButton.Size.Y.Offset, 0, 0),
    Position = UDim2.new(0, 20, 0, TextButton.Size.Y.Offset + 10),
    TextSize = 15,
    TextColor3 = Configs_HUB.DarkText,
    TextXAlignment = "Left",
    Text = text,
    Font = Configs_HUB.Font,
    BackgroundTransparency = 1,
    AutomaticSize = Enum.AutomaticSize.Y,
    TextWrapped = true
  })
  
  local FrameSize = SetConfigs(Create("Frame", "Frame", Frame2), {
    Size = UDim2.new(1, -2, 0, 2),
    BackgroundColor3 = Configs_HUB.Stroke,
    Position = UDim2.new(0, 2, 0, 30)
  })Corner(FrameSize, UDim.new(0, 0))
  
  task.spawn(function()
    local tween = TweenService:Create(FrameSize, TweenInfo.new(time, Enum.EasingStyle.Linear),
    {Size = UDim2.new(0, 0, 0, 2)})tween:Play()tween.Completed:Wait()
  end)
  
  TextButton.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(Frame2, TweenInfo.new(0.1, Enum.EasingStyle.Linear),
    {Position = UDim2.new(0, -20, 0, 0)})tween:Play()tween.Completed:Wait()
    local tween = TweenService:Create(Frame2, TweenInfo.new(0.5, Enum.EasingStyle.Linear),
    {Position = UDim2.new(0, Menu_Notifi.Size.X.Offset, 0, 0)})tween:Play()tween.Completed:Wait()
    Frame1:Destroy()
  end)
  
  task.spawn(function()
    local tween = TweenService:Create(Frame2, TweenInfo.new(0.5, Enum.EasingStyle.Linear),
    {Position = UDim2.new(0, -20, 0, 0)})tween:Play()tween.Completed:Wait()
    local tween = TweenService:Create(Frame2, TweenInfo.new(0.1, Enum.EasingStyle.Linear),
    {Position = UDim2.new()})tween:Play()tween.Completed:Wait()
    task.wait(time)
    if Frame2 then
      local tween = TweenService:Create(Frame2, TweenInfo.new(0.1, Enum.EasingStyle.Linear),
      {Position = UDim2.new(0, -20, 0, 0)})tween:Play()tween.Completed:Wait()
      local tween = TweenService:Create(Frame2, TweenInfo.new(0.5, Enum.EasingStyle.Linear),
      {Position = UDim2.new(0, Menu_Notifi.Size.X.Offset, 0, 0)})tween:Play()tween.Completed:Wait()
      Frame1:Destroy()
    end
  end)
end

local Menu = SetConfigs(Create("Frame", "Menu Inicial", ScreenGui), {
  Size = UDim2.new(0, 0, 0, 0),
  BackgroundColor3 = Configs_HUB.Hub,
  AnchorPoint = Vector2.new(0.5, 0.5),
  Position = UDim2.new(0.5, 0, 0.5, 0),
  Active = true,
})Corner(Menu, UDim.new(0, 6))

local function LinhaAdd(tamanho, posicao, anchor)
  local linha = SetConfigs(Create("Frame", "Linha", Menu), {
    Size = tamanho,
    Position = posicao,
    AnchorPoint = anchor or Vector2.new(),
    BorderSizePixel = 0
  })
  if Configs_HUB.Stroke == "Rainbow" then
    RainbowMenu(linha)
  else
    linha.BackgroundColor3 = Configs_HUB.Stroke
  end
  return linha
end

local Credits = SetConfigs(Create("TextLabel", "Credits", Menu), {
  Size = UDim2.new(1, 0, 1, 0),
  Position = UDim2.new(0, 10, 0, 0),
  Text = "by : يوسف",
  BackgroundTransparency = 1,
  TextColor3 = Configs_HUB.TextColor,
  Font = Configs_HUB.Font,
  Visible = false,
  TextSize = 15,
  TextXAlignment = "Left",
  TextTransparency = 1
})

local tween = TweenService:Create(Menu, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 0, 0, 40)})tween:Play()tween.Completed:Wait()
local tween = TweenService:Create(Menu, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 150, 0, 40)})tween:Play()tween.Completed:Wait(0.5)
Credits.Visible = true
for i = 1, 0, -0.1 do task.wait()
  Credits.TextTransparency = i
end
task.wait(1)
for i = 0, 1, 0.1 do task.wait()
  Credits.TextTransparency = i
end
Credits:Destroy()
local tween = TweenService:Create(Menu, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 500, 0, 270)})tween:Play()tween.Completed:Wait()
Menu.AnchorPoint = Vector2.new(0, 0)
Menu.Position = UDim2.new(0.5, -250, 0.5, -135)
Menu.Draggable = true

local TopBar = SetConfigs(Create("Frame", "Top Bar", Menu), {
  Size = UDim2.new(1, 0, 0, 35),
  BackgroundColor3 = Configs_HUB.Hub,
})Corner(TopBar)

local Title = SetConfigs(Create("TextLabel", "Title", TopBar), {
  Text = "REDz HUB",
  BackgroundTransparency = 1,
  TextColor3 = Configs_HUB.TextColor,
  TextSize = 25,
  Position = UDim2.new(0, 20, 0, 0),
  Size = UDim2.new(1, 0, 1, 0),
  Font = Configs_HUB.Font,
  TextXAlignment = "Left"
})

function AddInfo(Configs)
  SetConfigs(Title, {
    Text = Configs.Title or "REDz HUB",
    Font = Configs.Font or Enum.Font.FredokaOne
  })
end

task.spawn(function()
  while task.wait() do
    local tween = TweenService:Create(Title,TweenInfo.new(2,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{TextColor3 = Configs_HUB.DarkText})
    tween:Play()
    tween.Completed:Wait()
    local tween = TweenService:Create(Title,TweenInfo.new(2,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{TextColor3 = Configs_HUB.TextColor})
    tween:Play()
    tween.Completed:Wait()
  end
end)

local MinimizeBtn = SetConfigs(Create("TextButton", "Minimize BTN", TopBar), {
  Size = UDim2.new(0, TopBar.Size.Y.Offset, 0, TopBar.Size.Y.Offset),
  Position = UDim2.new(1, -80, 0, -2.5),
  Text = "+",
  TextSize = 30,
  TextColor3 = Color3.fromRGB(240, 240, 240),
  BackgroundTransparency = 1,
  Font = Configs_HUB.Font
})
local Minimize = false
MinimizeBtn.MouseButton1Click:Connect(function()
  if Minimize == false then
    for _,v in pairs(Menu:GetChildren()) do
      if v.Name == "Linha" then
        v.Visible = false
      end
    end
    local Containers = Menu:FindFirstChild("Containers")
    if Containers then
      Containers.Visible = false
    end
    local ScrollBar = Menu:FindFirstChild("ScrollBar")
    if ScrollBar then
      ScrollBar.Visible = false
    end
    local tween = TweenService:Create(Menu, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 500, 0, 35)})tween:Play()tween.Completed:Wait()
    local tween = TweenService:Create(Menu, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(0, Title.TextBounds.X + 120, 0, 35)})tween:Play()tween.Completed:Wait()
    Minimize = true
    MinimizeBtn.Text = "+"
  else
    local tween = TweenService:Create(Menu, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 500, 0, 35)})tween:Play()tween.Completed:Wait()
    local tween = TweenService:Create(Menu, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 500, 0, 270)})tween:Play()tween.Completed:Wait()
    Minimize = false
    MinimizeBtn.Text = "-"
    local Containers = Menu:FindFirstChild("Containers")
    if Containers then
      Containers.Visible = true
    end
    local ScrollBar = Menu:FindFirstChild("ScrollBar")
    if ScrollBar then
      ScrollBar.Visible = true
    end
    for _,v in pairs(Menu:GetChildren()) do
      if v.Name == "Linha" then
        v.Visible = true
      end
    end
  end
end)

local CloseBTN = SetConfigs(Create("TextButton", "Close BTN", TopBar), {
  Size = UDim2.new(0, TopBar.Size.Y.Offset, 0, TopBar.Size.Y.Offset),
  Position = MinimizeBtn.Position + UDim2.new(0, MinimizeBtn.Size.X.Offset + 5, 0, 2),
  Text = "X",
  TextSize = 30,
  TextColor3 = Color3.fromRGB(240, 0, 0),
  BackgroundTransparency = 1,
  Font = Configs_HUB.Font
})
CloseBTN.MouseButton1Click:Connect(function()
  local Containers = Menu:FindFirstChild("Containers")
  if Containers then
    Containers.Visible = false
  end
  local tween = TweenService:Create(Menu, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 0)})
  tween:Play()
  tween.Completed:Wait()
  ScreenGui:Destroy()
end)

local ScrollTab = SetConfigs(Create("ScrollingFrame", "ScrollBar", Menu), {
  Size = UDim2.new(0, 150, 1, -90),
  Position = UDim2.new(0, 0, 0, TopBar.Size.Y.Offset),
  CanvasSize = UDim2.new(0, 0, 0, 0),
  BackgroundColor3 = Color3.fromRGB(60, 60, 60),
  BackgroundTransparency = 1,
  ScrollingDirection = "Y",
  AutomaticCanvasSize = "Y",
  ScrollBarThickness = 0
})

local MenuInfo = SetConfigs(Create("Frame", "Frame", Menu), {
  Size = UDim2.new(0, ScrollTab.Size.X.Offset, 0, 55),
  Position = UDim2.new(0, 0, 1, 0),
  AnchorPoint = Vector2.new(0, 1),
  BackgroundTransparency = 1
})

local Padding = SetConfigs(Create("UIPadding", "Padding", ScrollTab), {
  PaddingLeft = UDim.new(0, 10),
  PaddingRight = UDim.new(0, 10),
  PaddingTop = UDim.new(0, 10),
  PaddingBottom = UDim.new(0, 10)
})

local ListLayout = SetConfigs(Create("UIListLayout", "ListLayout", ScrollTab), {
  Padding = UDim.new(0, 5)
})

local Containers = SetConfigs(Create("Frame", "Containers", Menu), {
  Size = UDim2.new(1, -ScrollTab.Size.X.Offset, 1, -TopBar.Size.Y.Offset),
  Position = UDim2.new(1, 0, 1, 0),
  AnchorPoint = Vector2.new(1, 1),
  BackgroundTransparency = 1
})

local function NewTab(tabName)
    local TabButton = SetConfigs(Create("TextButton", tabName or "NewTab", ScrollTab), {
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Text = "",
        AutoButtonColor = false
    })
    
    local Corner = Instance.new("UICorner", TabButton)
    Corner.CornerRadius = UDim.new(1, 0) -- هذا يجعل الزر دائرياً بالكامل

    TabButton.MouseEnter:Connect(function()
        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)
    
    TabButton.MouseLeave:Connect(function()
        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
    end)

    local InnerCircle = SetConfigs(Create("Frame", "InnerCircle", TabButton), {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 10, 0.5, -15),
        BackgroundColor3 = Configs_HUB.Stroke,
        BackgroundTransparency = 0.7
    })
    Instance.new("UICorner", InnerCircle).CornerRadius = UDim.new(1, 0)

    local TabText = SetConfigs(Create("TextLabel", "TabText", TabButton), {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 50, 0, 0),
        BackgroundTransparency = 1,
        Text = tabName or "NewTab",
        TextColor3 = Configs_HUB.TextColor,
        Font = Configs_HUB.Font,
        TextSize = 14,
        TextXAlignment = "Left"
    })

    local TabContainer = SetConfigs(Create("ScrollingFrame", tabName or "NewTab", Containers), {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ScrollBarThickness = 5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = "Y"
    })
    
    local TabLayout = SetConfigs(Create("UIListLayout", "ListLayout", TabContainer), {
        Padding = UDim.new(0, 5),
        SortOrder = "LayoutOrder"
    })
    
    local TabPadding = SetConfigs(Create("UIPadding", "Padding", TabContainer), {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10)
    })

    TabButton.MouseButton1Click:Connect(function()

        for _, child in pairs(Containers:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end

        TabContainer.Visible = true

        for _, btn in pairs(ScrollTab:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                TweenService:Create(btn:FindFirstChild("InnerCircle"), TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
            end
        end

        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
        TweenService:Create(InnerCircle, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)

    if #ScrollTab:GetChildren() == 2 then -- الزر الأول بعد ListLayout
        TabButton.MouseButton1Click:Invoke()
    end

    local tabFunctions = {}
    
    function tabFunctions:AddButton(config)
        local Button = SetConfigs(Create("TextButton", config.Text or "Button", TabContainer), {
            Size = UDim2.new(1, -20, 0, 40),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            Text = config.Text or "Button",
            TextColor3 = Configs_HUB.TextColor,
            Font = Configs_HUB.Font,
            TextSize = 14,
            AutoButtonColor = false
        })
        Corner(Button)
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            if config.Callback then
                config.Callback()
            end
        end)
        
        return Button
    end
    
    function tabFunctions:AddLabel(text)
        local Label = SetConfigs(Create("TextLabel", "Label", TabContainer), {
            Size = UDim2.new(1, -20, 0, 30),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Configs_HUB.TextColor,
            Font = Configs_HUB.Font,
            TextSize = 14,
            TextXAlignment = "Left"
        })
        
        return Label
    end
    
    return tabFunctions
end
