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

function NewTab(Configs)
  local TabColorText = Configs_HUB.TextColor
  local ContainerVisible = true
  local DefaultSize = 16
  
  for i,v in pairs(ScrollTab:GetChildren()) do
    if v:IsA("TextButton") then
      TabColorText = Configs_HUB.DarkText
      DefaultSize = 15
    end
  end
  
  for i,v in pairs(Containers:GetChildren()) do
    if v:IsA("ScrollingFrame") then
      ContainerVisible = false
    end
  end
  
  local TextButton = SetConfigs(Create("TextButton", "Tab", ScrollTab), {
    Size = UDim2.new(1, 0, 0, 25),
    BackgroundTransparency = 1,
    Text = "",
    AutoButtonColor = false,
  })Corner(TextButton)Stroke(TextButton)
  
  ScrollTab.CanvasSize = ScrollTab.CanvasSize + UDim2.new(0, 0, 0, 35)
  
  local TabName = SetConfigs(Create("TextLabel", "TabName", TextButton), {
    TextColor3 = TabColorText,
    Size = UDim2.new(1, 0, 1, 0),
    Text = Configs.Name,
    TextSize = DefaultSize,
    Font = Enum.Font.SourceSansBold,
    BackgroundTransparency = 1
  })
  
  local Container = SetConfigs(Create("ScrollingFrame", Configs.Name, Containers), {
    Size = UDim2.new(1, 0, 1, -10),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    CanvasSize = UDim2.new(0, 0, 0, 10),
    ScrollingDirection = "Y",
    ScrollBarThickness = 0,
    AutomaticCanvasSize = "Y",
    Visible = ContainerVisible
  })
  
  local Selector = SetConfigs(Create("Frame", "Selector", TabButton), {
        Size = isFirstTab and UDim2.new(0, 4, 1, -10) or UDim2.new(0, 4, 0, 4),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Configs_HUB.Stroke,
        BackgroundTransparency = isFirstTab and 0 or 1
    })
    Corner(Selector, UDim.new(0.5, 0))
    
  local Padding = SetConfigs(Create("UIPadding", "Padding", Container), {
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10),
    PaddingTop = UDim.new(0, 10),
    PaddingBottom = UDim.new(0, 10)
  })
  
  local ListLayout = SetConfigs(Create("UIListLayout", "ListLayout", Container), {
    Padding = UDim.new(0, 5)
  })
  
  TextButton.MouseButton1Click:Connect(function()
    for _,v in pairs(Containers:GetChildren()) do
      if v:IsA("ScrollingFrame") then
        v.Visible = false
      end
    end
    Container.Visible = true
    for _,v in pairs(ScrollTab:GetChildren()) do
      if v.Name == TextButton.Name and v:FindFirstChild(TabName.Name) then
        v[TabName.Name].TextSize = 15
        TweenService:Create(v[TabName.Name],TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),
        {TextColor3 = Configs_HUB.DarkText}):Play()
      end
    end
    TabName.TextSize = 16
    TweenService:Create(TabName,TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut), {TextColor3 = Configs_HUB.TextColor}):Play()
  end)
  return Container
end

function AddToggle(parent, Configs)
  local name = Configs.Name or "Toggle"
  local Default = Configs.Default or false
  local Callback = Configs.Callback or function() end
  
  local TextButton = SetConfigs(Create("TextButton", "Frame", parent), {
    Size = UDim2.new(1, 0, 0, Buttons_Hub.Size),
    BackgroundColor3 = Configs_HUB.Hub,
    Text = ""
  })Stroke(TextButton)Corner(TextButton)
  
  local TextLabel = SetConfigs(Create("TextLabel", "Text", TextButton), {
    Size = UDim2.new(1, -10, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    TextSize = Buttons_Hub.TextSize,
    TextColor3 = Configs_HUB.TextColor,
    TextXAlignment = "Left",
    Text = name,
    Font = Configs_HUB.Font,
    BackgroundTransparency = 1
  })
  
  local Toggle = SetConfigs(Create("Frame", "OnOff", TextButton), {
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(1, -30, 0, 5),
    BackgroundTransparency = 1
  })Corner(Toggle, UDim.new(0, 6))Stroke(Toggle)
  
  local Toggle2 = SetConfigs(Create("Frame", "OnOff", Toggle), {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Visible = false
  })Corner(Toggle2, UDim.new(0, 6))
  
  if Configs_HUB.Stroke == "Rainbow" then
    RainbowMenu(Toggle2)
  else
    Toggle2.BackgroundColor3 = Configs_HUB.Stroke
  end
  
  local OnOff = false
  if Default == true then
    SetConfigs(Toggle2, {
      Size = UDim2.new(1, -2.5, 1, -2.5),
      Visible = true
    })
    OnOff = true
  end
  Callback(OnOff)
  TextButton.MouseButton1Click:Connect(function()
    if OnOff == false then
      Toggle2.Visible = true
      local tween = TweenService:Create(Toggle2, TweenInfo.new(0.2, Enum.EasingStyle.Linear),
      {Size = UDim2.new(1, -2.5, 1, -2.5)})tween:Play()tween.Completed:Wait()
      OnOff = true
    elseif OnOff == true then
      local tween = TweenService:Create(Toggle2, TweenInfo.new(0.2, Enum.EasingStyle.Linear),
      {Size = UDim2.new()})tween:Play()tween.Completed:Wait()
      Toggle2.Visible = false
      OnOff = false
    end
    Callback(OnOff)
  end)
  return {Toggle2, Callback, OnOff}
end

function UpdToggle(Toggle, OnOff)
  local OnOff = not OnOff
  local Toggle = Toggle
  
  if OnOff == false then
    Toggle.Visible = true
    local tween = TweenService:Create(Toggle, TweenInfo.new(0.2, Enum.EasingStyle.Linear),
    {Size = UDim2.new(1, -2.5, 1, -2.5)})tween:Play()tween.Completed:Wait()
    OnOff = true
  elseif OnOff == true then
    local tween = TweenService:Create(Toggle, TweenInfo.new(0.2, Enum.EasingStyle.Linear),
    {Size = UDim2.new()})tween:Play()tween.Completed:Wait()
    Toggle.Visible = false
    OnOff = false
  end
end

function AddButton(parent, Configs)
  local Callback = Configs.Callback or function() end
  local name = Configs.Name or "Button"
  
  local TextButton = SetConfigs(Create("TextButton", "Frame", parent), {
    Size = UDim2.new(1, 0, 0, Buttons_Hub.Size),
    BackgroundColor3 = Configs_HUB.Hub,
    Text = ""
  })Stroke(TextButton)Corner(TextButton)
  
  local TextLabel = SetConfigs(Create("TextLabel", "Text", TextButton), {
    Size = UDim2.new(1, -10, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    TextSize = Buttons_Hub.TextSize,
    TextColor3 = Configs_HUB.TextColor,
    TextXAlignment = "Left",
    Text = name,
    Font = Configs_HUB.Font,
    BackgroundTransparency = 1
  })
  
  local ImageLabel = SetConfigs(Create("ImageLabel", "Image", TextButton), {
    Image = "rbxassetid://99956220697276",
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(1, -30, 0, 5),
    BackgroundTransparency = 1
  })
  
  TextButton.MouseButton1Click:Connect(function()
    Callback("Click")
  end)
end

function AddDropdown(parent, Configs)
  local Callback = Configs.Callback or function() end
  local name = Configs.Name or "Dropdown"
  local Options = Configs.Options or {"1", "2"}
  local Default = Configs.Default or "1"
  
  local TextButton = SetConfigs(Create("TextButton", "Frame", parent), {
    Size = UDim2.new(1, 0, 0, Buttons_Hub.Size),
    BackgroundColor3 = Configs_HUB.Hub,
    AutoButtonColor = false,
    Text = ""
  })Stroke(TextButton)Corner(TextButton)
  
  local TextLabel = SetConfigs(Create("TextLabel", "Text", TextButton), {
    Size = UDim2.new(1, -10, 0, Buttons_Hub.Size),
    Position = UDim2.new(0, 10, 0, 0),
    TextSize = Buttons_Hub.TextSize,
    TextColor3 = Configs_HUB.TextColor,
    TextXAlignment = "Left",
    Text = name,
    Font = Configs_HUB.Font,
    BackgroundTransparency = 1
  })
  
  local default = SetConfigs(Create("TextLabel", "Default", TextButton), {
    Size = UDim2.new(1, -30, 0, 20),
    Position = UDim2.new(0, 0, 0, 12),
    TextXAlignment = "Right",
    TextColor3 = Configs_HUB.DarkText,
    BackgroundTransparency = 1,
    Text = "...",
    Font = Configs_HUB.Font,
    TextSize = 14
  })
  
  local A_1 = SetConfigs(Create("Frame", "...", TextButton), {
    Size = UDim2.new(1, 0, 0, 0),
    Position = UDim2.new(0, 0, 0, Buttons_Hub.Size + 5),
    Visible = false
  })Stroke(A_1)
  
  local ListDrop = SetConfigs(Create("ScrollingFrame", "ListDrop", TextButton), {
    Size = UDim2.new(1, -4, 1, -tonumber(Buttons_Hub.Size + 5)),
    Position = UDim2.new(0, 2, 1, 0),
    AnchorPoint = Vector2.new(0, 1),
    Visible = false,
    BackgroundTransparency = 1,
    BackgroundColor3 = Color3.fromRGB(100, 100, 100),
    ScrollingDirection = "Y",
    ElasticBehavior = "Never",
    ScrollBarThickness = 0,
    AutomaticCanvasSize = "Y",
    CanvasSize = UDim2.new(0, 0, 0, 0)
  })
  
  local Arrow = SetConfigs(Create("ImageLabel", "Arrow", TextButton), {
    Image = "rbxassetid://6031090990",
    Size = UDim2.new(0, Buttons_Hub.Size, 0, Buttons_Hub.Size),
    Position = UDim2.new(1, -30, 0, 0),
    BackgroundTransparency = 1
  })
  
  local Padding = SetConfigs(Create("UIPadding", "Padding", ListDrop), {
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10),
    PaddingTop = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 5)
  })
  
  local ListLayout = SetConfigs(Create("UIListLayout", "ListLayout", ListDrop), {
    Padding = UDim.new(0, 5)
  })
  
  local function AddOption(name)
    local NewOption = SetConfigs(Create("TextButton", "Option", ListDrop), {
      Size = UDim2.new(1, 0, 0, 20),
      Text = name,
      TextSize = 15,
      Font = Configs_HUB.Font,
      TextColor3 = Configs_HUB.DarkText,
      BackgroundTransparency = 0.5,
      TextXAlignment = "Left",
      BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    })Corner(NewOption)
    
    if NewOption.Text == Default then
      NewOption.TextColor3 = Configs_HUB.TextColor
      NewOption.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
      Callback(Default)
      default.Text = Default
    end
    
    NewOption.MouseButton1Click:Connect(function()
      for _,v in pairs(ListDrop:GetChildren()) do
        if v.Name == "Option" then
          v.TextColor3 = Configs_HUB.DarkText
          v.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
      end
      Callback(NewOption.Text)
      NewOption.TextColor3 = Configs_HUB.TextColor
      NewOption.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
      default.Text = NewOption.Text
    end)
    ListDrop.CanvasSize = ListDrop.CanvasSize + UDim2.new(0, 0, 0, 25)
  end
  
  for i = 1, #Options do
    AddOption(Options[i])
  end
  
  local DropOnOff = false
  TextButton.MouseButton1Click:Connect(function()
  local frameSize = UDim2.new(1, 0, 0, Buttons_Hub.Size)
    for i,v in pairs(ListDrop:GetChildren()) do
      if v.Name == "Option" and i <= 7 then
        frameSize = frameSize + UDim2.new(0, 0, 0, 25)
      end
    end
    if DropOnOff == false then
      DropOnOff = true
      A_1.Visible = DropOnOff
      ListDrop.Visible = DropOnOff
      local tween1 = TweenService:Create(TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = frameSize})
      local tween2 = TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 180})
      tween1:Play()tween2:Play()
    else
      DropOnOff = false
      local tween1 = TweenService:Create(TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 0, 0, Buttons_Hub.Size)})
      local tween2 = TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0})
      tween1:Play()tween2:Play()tween1.Completed:Wait()
      A_1.Visible = DropOnOff
      ListDrop.Visible = DropOnOff
    end
  end)
  ListDrop.CanvasSize = ListDrop.CanvasSize + UDim2.new(0, 0, 0, 10)
  return ListDrop
end

function RefreshDropdown(Dropdown, NewOptions)
  for _,v in pairs(Dropdown:GetChildren()) do
    if v.Name == "Option" then
      v:Destroy()
    end
  end
  for i = 1, #NewOptions do
    AddOption(NewOptions[i])
  end
end

function AddSlider(parent, Configs)
  local name = Configs.Name or "Slider"
  local minvalue = Configs.MinValue or 10
  local maxvalue = Configs.MaxValue or 50
  local Default = Configs.Default or 25
  local SliderColor = Configs.SliderColor or Color3.fromRGB(0, 0, 255)
  local Callback = Configs.Callback or function() end
  
  if Default >= maxvalue then
    Default = maxvalue
  elseif Default <= minvalue then
    Default = minvalue
  end
  
  local Frame1 = SetConfigs(Create("Frame", "Frame", parent), {
    Size = UDim2.new(1, 0, 0, 55),
    BackgroundColor3 = Configs_HUB.Hub
  })Corner(Frame1)Stroke(Frame1)
  
  local TextLabel = SetConfigs(Create("TextLabel", "Text", Frame1), {
    Size = UDim2.new(1, -10, 0, 25),
    Position = UDim2.new(0, 10, 0, 0),
    TextSize = Buttons_Hub.TextSize,
    TextColor3 = Configs_HUB.TextColor,
    TextXAlignment = "Left",
    Text = name,
    Font = Configs_HUB.Font,
    BackgroundTransparency = 1
  })
  
  local TextBox = SetConfigs(Create("TextBox", "Text", Frame1), {
    AnchorPoint = Vector2.new(1, 0),
    Size = UDim2.new(0, 45, 0, 20),
    Position = UDim2.new(1, -10, 0, 5),
    ClearTextOnFocus = false,
    TextSize = 15,
    TextColor3 = Configs_HUB.TextColor,
    Text = Default,
    Font = Configs_HUB.Font,
    BackgroundTransparency = 1
  })Corner(TextBox)Stroke(TextBox)
  
  local Frame2 = SetConfigs(Create("Frame", "Slider", Frame1), {
    Size = UDim2.new(1, -20, 0, 3),
    Position = UDim2.new(0, 10, 1, -15),
    BackgroundColor3 = SliderColor
  })Corner(Frame2)
  
  local Slider = SetConfigs(Create("TextButton", "Slider", Frame2), {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0, 0, 0.5, 0),
    Size = UDim2.new(0, 20, 0, 20),
    TextSize = 10,
    Text = Default,
    BackgroundColor3 = SliderColor,
    TextColor3 = Configs_HUB.TextColor,
    Font = Configs_HUB.Font,
    Active = true,
    Draggable = true
  })Corner(Slider)

  local function UpdateCounter(A_1)
    Slider.Text = tostring(A_1)
    TextBox.Text = tostring(A_1)
    Callback(A_1)
  end
  
  local function SliderPos(Pos)
    local A_1 = string.gsub(Pos, "%D", "")
    local SliderPos = (tonumber(A_1) - minvalue) / (maxvalue - minvalue)
    local X_Offset = SliderPos * 310
    local SliderPosition = UDim2.new(0, X_Offset + 1, 0, 0)
    local tween = TweenService:Create(Slider, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Position = SliderPosition})tween:Play()
  end
  
  SliderPos(Default)
  Callback(Default)
  
  TextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
    local text = string.gsub(TextBox.Text, "%D", "")
      if tonumber(text) <= minvalue then
        UpdateCounter(minvalue)
        SliderPos(minvalue)
      elseif tonumber(text) >= maxvalue then
        UpdateCounter(maxvalue)
        SliderPos(maxvalue)
      else
        UpdateCounter(tonumber(text))
        SliderPos(text)
      end
    end
  end)
  
  Slider.Changed:Connect(function(Prop)
    if Prop == "Position" then
      local position = UDim2.new(0, math.clamp(Slider.Position.X.Offset, 0, 310), 0.5, 0)
      Slider.Position = position
      local SliderPos = Slider.Position.X.Offset / 310
      local A_1 = math.floor(((SliderPos * maxvalue) / maxvalue) * (maxvalue - minvalue) + minvalue)
      UpdateCounter(A_1)
    end
  end)
end

function AddColorPicker(parent, Configs)
  local name = Configs.Name or "Color Picker"
  local Default = Configs.Default or Color3.fromRGB(0, 0, 200)
  local Callback = Configs.Callback or function() end
  local ColorH, ColorS, ColorV = 1, 1, 1
  Callback(Default)
  
  local TextButton = SetConfigs(Create("Frame", "Frame", parent), {
    Size = UDim2.new(1, 0, 0, Buttons_Hub.Size),
    BackgroundColor3 = Configs_HUB.Hub,
  })Stroke(TextButton)Corner(TextButton)
  
  local click = SetConfigs(Create("TextButton", "Frame", TextButton), {
    Size = UDim2.new(1, 0, 0, Buttons_Hub.Size),
    BackgroundTransparency = 1,
    AutoButtonColor = false,
    Text = ""
  })
  
  local TextLabel = SetConfigs(Create("TextLabel", "Text", TextButton), {
    Size = UDim2.new(1, -10, 0, Buttons_Hub.Size),
    Position = UDim2.new(0, 10, 0, 0),
    TextSize = Buttons_Hub.TextSize,
    TextColor3 = Configs_HUB.TextColor,
    TextXAlignment = "Left",
    Text = name,
    Font = Configs_HUB.Font,
    BackgroundTransparency = 1
  })
  
  local picker = SetConfigs(Create("Frame", "Frame", TextButton), {
    Size = UDim2.new(0, 40, 0, tonumber(TextButton.Size.Y.Offset - 10)),
    Position = UDim2.new(1, -10, 0, 5),
    AnchorPoint = Vector2.new(1, 0),
    BackgroundColor3 = Default
  })Corner(picker)Stroke(picker)
  
  local UI_Grade = SetConfigs(Create("ImageLabel", "Frame", TextButton), {
    Size = UDim2.new(1, -100, 1, tonumber(-TextButton.Size.Y.Offset - 20)),
    Position = UDim2.new(0, 10, 0, tonumber(TextButton.Size.Y.Offset + 12.5)),
    Visible = false,
    Image = "rbxassetid://4155801252"
  })Corner(UI_Grade)Stroke(UI_Grade)
  
  local grade = SetConfigs(Create("Frame", "Frame", TextButton), {
    Size = UDim2.new(0, 30, 1, tonumber(-TextButton.Size.Y.Offset - 20)),
    Position = UDim2.new(1, -10, 0, tonumber(TextButton.Size.Y.Offset + 12.5)),
    AnchorPoint = Vector2.new(1, 0),
    Visible = false
  })Corner(grade)Stroke(grade)SetConfigs(Create("UIGradient", "Gradient", grade), {
    Rotation = 90,
    Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)),
      ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)),
      ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)),
      ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)),
      ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)),
      ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)),
      ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))
    })
  })
  
  local A_1 = SetConfigs(Create("Frame", "...", TextButton), {
    Size = UDim2.new(1, 0, 0, 0),
    Position = UDim2.new(0, 0, 0, Buttons_Hub.Size + 5),
    Visible = false
  })Stroke(A_1)
  
  local Select1 = SetConfigs(Create("Frame", "Frame", grade), {
    Size = UDim2.new(1, 0, 0, 10),
    Position = UDim2.new(0, 0, 0, select(3, Color3.toHSV(Default))),
    BackgroundTransparency = 1,
    Active = true,
    Draggable = true
  })Corner(Select1, UDim.new(2, 0))Stroke(Select1, Color3.fromRGB(255, 255, 255))
  
  local Select2 = SetConfigs(Create("Frame", "Frame", UI_Grade), {
    Size = UDim2.new(0, 15, 0, 15),
    Position = UDim2.new(0, select(2, Color3.toHSV(Default)), 0, select(1, Color3.toHSV(Default))),
    BackgroundTransparency = 1,
    Active = true,
    Draggable = true
  })Corner(Select2, UDim.new(2, 0))Stroke(Select2, Color3.fromRGB(255, 255, 255))
  
  local function callback()Callback(Color3.fromHSV(ColorH, ColorS, ColorV))end
  local function updcolorpicker()
    ColorH = tonumber(Select1.Position.Y.Offset) / 80
    ColorS = tonumber(215 - Select2.Position.X.Offset) / 215
    ColorV = tonumber(75 - Select2.Position.Y.Offset) / 75
    UI_Grade.ImageColor3 = Color3.fromHSV(ColorH, 1, 1)
    picker.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
    callback()
  end
  
  updcolorpicker()
  
  Select1.Changed:Connect(function(prop)
    if prop == "Position" then
      Select1.Position = UDim2.new(0, 0, 0, math.clamp(Select1.Position.Y.Offset, 0, 80))
      updcolorpicker()
    end
  end)
  
  Select2.Changed:Connect(function(prop)
    if prop == "Position" then
      Select2.Position = UDim2.new(0, math.clamp(Select2.Position.X.Offset, 0, 215), 0, math.clamp(Select2.Position.Y.Offset, 0, 75))
      updcolorpicker()
    end
  end)
  
  TextButton.Changed:Connect(function(prop)
    if prop == "Size" then
      if TextButton.Size.Y.Offset >= 60 then
        UI_Grade.Visible = true
        A_1.Visible = true
        grade.Visible = true
      else
        UI_Grade.Visible = false
        A_1.Visible = false
        grade.Visible = false
      end
    end
  end)
  
  local onoff = false
  click.MouseButton1Click:Connect(function()
    onoff = not onoff
    if onoff == true then
      local tween = TweenService:Create(TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Linear),
      {Size = UDim2.new(1, 0, 0, 140)})tween:play()tween.Completed:Wait()
    else
      local tween = TweenService:Create(TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Linear),
      {Size = UDim2.new(1, 0, 0, Buttons_Hub.Size)})tween:play()tween.Completed:Wait()
    end
  end)
end

function MinimizeButton(Configs)
    local image = Configs.Image or "rbxassetid://6031090990"
    local size = Configs.Size or {40, 40}
    local color = Configs.Color or Configs_HUB.Stroke
    local useCorner = Configs.Corner == nil and true or Configs.Corner
    local useStroke = Configs.Stroke == nil and true or Configs.Stroke
    local strokeColor = Configs.StrokeColor or color

    local Button = SetConfigs(Create("ImageButton", "MinimizeButton", ScreenGui), {
        Size = UDim2.new(0, size[1], 0, size[2]),
        Position = UDim2.new(0, 20, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = image,
        ImageColor3 = color,
        BackgroundColor3 = Configs_HUB.Hub,
        BackgroundTransparency = 0.4,
        Draggable = true,
        Active = true
    })

    if useCorner then
        Corner(Button, UDim.new(1, 0))
    end

    if useStroke then
        Stroke(Button, strokeColor)
    end

    Button.MouseButton1Click:Connect(function()
        Menu.Visible = not Menu.Visible
    end)

    return Button
end

function AddGameImage(parent, Configs)
    local gameUrl = Configs.Url or "https://www.roblox.com/games/920587237/Adopt-Me"
    local copyText = Configs.CopyText or ""
    local imageSize = Configs.Size or UDim2.new(1, 0, 0, 120)

    local gameId = string.match(gameUrl, "/games/(%d+)/")

    if not gameId then
        warn("Invalid Roblox game URL:", gameUrl)
        gameId = "0" 
    end
    
    local imageUrl = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. gameId .. "&width=420&height=420&format=png"

    local ImageButton = SetConfigs(Create("ImageButton", "GameImage", parent), {
        Size = imageSize,
        Image = imageUrl, 
        BackgroundColor3 = Configs_HUB.Hub,
        BackgroundTransparency = 0.5,
        ScaleType = Enum.ScaleType.Crop 
    })
    Stroke(ImageButton)
    Corner(ImageButton)

    local ClickDelay = false
    ImageButton.MouseButton1Click:Connect(function()
        local textToCopy = copyText
        if textToCopy == "" then
            textToCopy = gameId
        end

        if setclipboard then
            setclipboard(textToCopy)
        end

        if ClickDelay then return end
        ClickDelay = true

        local originalColor = ImageButton.ImageColor3
        ImageButton.ImageColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(0.2)
        ImageButton.ImageColor3 = originalColor
        ClickDelay = false
    end)

    return ImageButton
end
function AddSection(parent, name)
    if type(name) == "table" then
        name = name.Name or "Section"
    end
    
    name = name or "Section"

    local Frame = SetConfigs(Create("Frame", "SectionFrame", parent), {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1 
    })

    local Line1 = SetConfigs(Create("Frame", "Line", Frame), {
        Size = UDim2.new(0.35, 0, 0, 2),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Configs_HUB.Stroke
    })
    Corner(Line1)

    local TextLabel = SetConfigs(Create("TextLabel", "Text", Frame), {
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = name,
        Font = Configs_HUB.Font,
        TextSize = 14,
        TextColor3 = Configs_HUB.DarkText,
        BackgroundTransparency = 1
    })

    local Line2 = SetConfigs(Create("Frame", "Line", Frame), {
        Size = UDim2.new(0.35, 0, 0, 2),
        Position = UDim2.new(1, 0, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Configs_HUB.Stroke
    })
    Corner(Line2)

    return Frame
end
function AddSection(parent, name)
    if type(name) == "table" then
        name = name.Name or "Section"
    end
    
    name = name or "Section"

    local Frame = SetConfigs(Create("Frame", "SectionFrame", parent), {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1 
    })

    local Line1 = SetConfigs(Create("Frame", "Line", Frame), {
        Size = UDim2.new(0.35, 0, 0, 2),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Configs_HUB.Stroke
    })
    Corner(Line1)

    local TextLabel = SetConfigs(Create("TextLabel", "Text", Frame), {
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = name,
        Font = Configs_HUB.Font,
        TextSize = 14,
        TextColor3 = Configs_HUB.DarkText,
        BackgroundTransparency = 1
    })

    local Line2 = SetConfigs(Create("Frame", "Line", Frame), {
        Size = UDim2.new(0.35, 0, 0, 2),
        Position = UDim2.new(1, 0, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Configs_HUB.Stroke
    })
    Corner(Line2)

    return Frame
end
function AddDiscordInvite(parent, Configs)
    local Title = Configs.Title or "Discord Server"
    local Desc = Configs.Desc or "Click to join our community!"
    local Logo = Configs.Logo or "rbxassetid://3919948894"
    local Invite = Configs.Invite or "https://discord.gg/your-invite"

    local InviteHolder = SetConfigs(Create("Frame", "DiscordInvite", parent), {
        Size = UDim2.new(1, 0, 0, 75),
        BackgroundColor3 = Configs_HUB.Hub,
        BackgroundTransparency = 0.5
    })
    Corner(InviteHolder)
    Stroke(InviteHolder)

    local ImageLabel = SetConfigs(Create("ImageLabel", "Logo", InviteHolder), {
        Size = UDim2.new(0, 45, 0, 45),
        Position = UDim2.new(0, 15, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = Logo,
        BackgroundTransparency = 1
    })
    Corner(ImageLabel, UDim.new(1, 0))

    local LTitle = SetConfigs(Create("TextLabel", "ServerTitle", InviteHolder), {
        Size = UDim2.new(1, -150, 0, 20),
        Position = UDim2.new(0, 70, 0, 10),
        Font = Configs_HUB.Font,
        TextColor3 = Color3.fromRGB(0, 0, 255),
        TextXAlignment = "Left",
        BackgroundTransparency = 1,
        TextSize = 16,
        Text = Title
    })

    local LDesc = SetConfigs(Create("TextLabel", "ServerDesc", InviteHolder), {
        Size = UDim2.new(1, -150, 0, 30),
        Position = UDim2.new(0, 70, 0, 35),
        Font = Configs_HUB.Font,
        TextColor3 = Configs_HUB.DarkText,
        TextXAlignment = "Left",
        BackgroundTransparency = 1,
        TextSize = 12,
        Text = Desc,
        TextWrapped = true
    })

    local JoinButton = SetConfigs(Create("TextButton", "JoinButton", InviteHolder), {
        Size = UDim2.new(0, 60, 0, 30),
        Position = UDim2.new(1, -45, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = "Join",
        Font = Configs_HUB.Font,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    })
    Corner(JoinButton)

    local ClickDelay = false
    JoinButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(Invite)
        end
        
        if ClickDelay then return end
        ClickDelay = true
        
        local originalText = JoinButton.Text
        JoinButton.Text = "Copied!"
        task.wait(3)
        JoinButton.Text = originalText
        ClickDelay = false
    end)

    return InviteHolder
end

function AddTelegramInvite(parent, Configs)
    local Title = Configs.Title or "Telegram Shannel"
    local Desc = Configs.Desc or "Click to join our community!"
    local Logo = Configs.Logo or "rbxassetid://3919948894"
    local Invite = Configs.Invite or "https://t.me/your-invite"

    local InviteHolder = SetConfigs(Create("Frame", "TelegramInvite", parent), {
        Size = UDim2.new(1, 0, 0, 75),
        BackgroundColor3 = Configs_HUB.Hub,
        BackgroundTransparency = 0.5
    })
    Corner(InviteHolder)
    Stroke(InviteHolder)

    local ImageLabel = SetConfigs(Create("ImageLabel", "Logo", InviteHolder), {
        Size = UDim2.new(0, 45, 0, 45),
        Position = UDim2.new(0, 15, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = Logo,
        BackgroundTransparency = 1
    })
    Corner(ImageLabel, UDim.new(1, 0))

    local LTitle = SetConfigs(Create("TextLabel", "ChannelTitle", InviteHolder), {
        Size = UDim2.new(1, -150, 0, 20),
        Position = UDim2.new(0, 70, 0, 10),
        Font = Configs_HUB.Font,
        TextColor3 = Color3.fromRGB(0, 136, 204),
        TextXAlignment = "Left",
        BackgroundTransparency = 1,
        TextSize = 16,
        Text = Title
    })

    local LDesc = SetConfigs(Create("TextLabel", "ChannelDesc", InviteHolder), {
        Size = UDim2.new(1, -150, 0, 30),
        Position = UDim2.new(0, 70, 0, 35),
        Font = Configs_HUB.Font,
        TextColor3 = Configs_HUB.DarkText,
        TextXAlignment = "Left",
        BackgroundTransparency = 1,
        TextSize = 12,
        Text = Desc,
        TextWrapped = true
    })

    local JoinButton = SetConfigs(Create("TextButton", "JoinButton", InviteHolder), {
        Size = UDim2.new(0, 60, 0, 30),
        Position = UDim2.new(1, -45, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = "Join",
        Font = Configs_HUB.Font,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundColor3 = Color3.fromRGB(0, 136, 204)
    })
    Corner(JoinButton)

    local ClickDelay = false
    JoinButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(Invite)
        end
        
        if ClickDelay then return end
        ClickDelay = true
        
        local originalText = JoinButton.Text
        JoinButton.Text = "Copied"
        task.wait(3)
        JoinButton.Text = originalText
        ClickDelay = false
    end)

    return InviteHolder
end

function AddTextBox(parent, Configs)
    local Callback = Configs.Callback or function() end
    local name = Configs.Name or "TextBox"
    local Default = Configs.Default or "..."

    local Frame = SetConfigs(Create("Frame", "Frame", parent), {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Configs_HUB.Hub,
    })
    Stroke(Frame)
    Corner(Frame)

    local TextLabel = SetConfigs(Create("TextLabel", "Text", Frame), {
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextSize = Buttons_Hub.TextSize,
        TextColor3 = Configs_HUB.TextColor,
        TextXAlignment = "Left",
        Text = name,
        Font = Configs_HUB.Font,
        BackgroundTransparency = 1
    })

    local TextBox = SetConfigs(Create("TextBox", "TextBox", Frame), {
        Size = UDim2.new(0, 50, 1, -10),
        Position = UDim2.new(1, -55, 0, 5),
        ClearTextOnFocus = false,
        BackgroundTransparency = 1,
        Text = Default,
        TextColor3 = Configs_HUB.TextColor,
        Font = Configs_HUB.Font,
        PlaceholderText = "Input",
        TextScaled = true
    })
    Corner(TextBox)
    Stroke(TextBox)

    Callback(Default)
    
    TextBox.FocusLost:Connect(function()
        Callback(TextBox.Text)
        TextBox.Text = ""
    end)
end

function AddLabel(parent, Configs)
  local name = Configs[1] or "Label"
  local Frame = SetConfigs(Create("Frame", "Frame", parent), {
    Size = UDim2.new(1, 0, 0, 25),
    BackgroundColor3 = Configs_HUB.Hub,
    AutomaticSize = Enum.AutomaticSize.Y
  })Stroke(Frame)Corner(Frame)
  
  local TextLabel = SetConfigs(Create("TextLabel", "Text", Frame), {
    Size = UDim2.new(1, -10, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    TextSize = Buttons_Hub.TextSize,
    TextColor3 = Configs_HUB.TextColor,
    TextXAlignment = "Left",
    Text = name,
    Font = Configs_HUB.Font,
    BackgroundTransparency = 1,
    AutomaticSize = Enum.AutomaticSize.Y,
    TextWrapped = true
  })
  return TextLabel
end

function AddParagraph(parent, Configs)
  local name = Configs[1] or "Paragraph"
  local text = Configs[2] or "..."
  local Frame = SetConfigs(Create("Frame", "Frame", parent), {
    Size = UDim2.new(1, 0, 0, 25),
    BackgroundColor3 = Configs_HUB.Hub,
    AutomaticSize = Enum.AutomaticSize.Y
  })Stroke(Frame)Corner(Frame)
  
  local TextLabel1 = SetConfigs(Create("TextLabel", "Text", Frame), {
    Size = UDim2.new(1, -10, 0, 15),
    Position = UDim2.new(0, 10, 0, 5),
    TextSize = 14,
    TextColor3 = Configs_HUB.TextColor,
    TextXAlignment = "Left",
    Text = name,
    Font = Configs_HUB.Font,
    BackgroundTransparency = 1,
    TextWrapped = true
  })
  
  local TextLabel2 = SetConfigs(Create("TextLabel", "Text", Frame), {
    Size = UDim2.new(1, -10, 0, 15),
    Position = TextLabel1.Position + UDim2.new(0, 0, 0, 15),
    TextSize = 12,
    TextColor3 = Configs_HUB.DarkText,
    TextXAlignment = "Left",
    Text = text,
    Font = Configs_HUB.Font,
    BackgroundTransparency = 1,
    AutomaticSize = Enum.AutomaticSize.Y,
    TextWrapped = true
  })
end

function AddTextBox(parent, Configs)
  local Callback = Configs.Callback or function() end
  local name = Configs.Name or "TextBox"
  local Default = Configs.Default or "..."
  
  local Frame = SetConfigs(Create("Frame", "Frame", parent), {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Configs_HUB.Hub,
  })Stroke(Frame)Corner(Frame)
  
  local TextLabel = SetConfigs(Create("TextLabel", "Text", Frame), {
    Size = UDim2.new(1, -10, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    TextSize = Buttons_Hub.TextSize,
    TextColor3 = Configs_HUB.TextColor,
    TextXAlignment = "Left",
    Text = name,
    Font = Configs_HUB.Font,
    BackgroundTransparency = 1
  })
  
  local TextBox = SetConfigs(Create("TextBox", "TextBox", Frame), {
    Size = UDim2.new(0, 50, 1, -10),
    Position = UDim2.new(1, -55, 0, 5),
    ClearTextOnFocus = false,
    BackgroundTransparency = 1,
    Text = Default,
    TextColor3 = Configs_HUB.TextColor,
    Font = Configs_HUB.Font,
    PlaceholderText = "Input",
    TextScaled = true
  })Corner(TextBox)Stroke(TextBox)
  
  Callback(Default)
  TextBox.FocusLost:Connect(function()
    Callback(TextBox.Text)
    TextBox.Text = ""
  end)
end

function Mobile_Atalho(Configs)
  local name = Configs.Name or "Atalho"
  local Callback = Configs.Callback or function() end
  local visible = Configs.Visible or false
  
  local Toggle_Atalho = SetConfigs(Create("Frame", "Atalho", ScreenGui), {
    Size = UDim2.new(0, 100, 0, 60),
    Position = UDim2.new(0.8, 0, 0.8, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Configs_HUB.Hub,
    Draggable = true,
    Active = true,
    Visible = visible
  })Corner(Toggle_Atalho)
  
  local TextLabel = SetConfigs(Create("TextLabel", "TextLabel", Toggle_Atalho), {
    Size = UDim2.new(1, 0, 0, 20),
    TextSize = 20,
    Font = Enum.Font.FredokaOne,
    TextColor3 = Configs_HUB.TextColor,
    Text = name,
    BackgroundTransparency = 1
  })
  
  local Button = SetConfigs(Create("TextButton", "Button", Toggle_Atalho), {
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = ""
  })
  
  local Frame = SetConfigs(Create("Frame", "Frame", Button), {
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(1, -40, 1, -15),
    BackgroundTransparency = 1
  })Corner(Frame, UDim.new(2, 0))
  
  local Frame2 = SetConfigs(Create("Frame", "Frame", Frame), {
    Position = UDim2.new(0, 5, 0.5, 0),
    AnchorPoint = Vector2.new(0, 0.5),
    Size = UDim2.new(0, 17, 0, 17),
    BackgroundTransparency = 1
  })Corner(Frame2, UDim.new(5, 0))
  
  local stroke = SetConfigs(Stroke(Frame, Color3.fromRGB(100, 100, 100)), {
    Thickness = 3
  })
  
  local stroke = SetConfigs(Stroke(Frame2, Color3.fromRGB(100, 100, 100)), {
    Thickness = 3
  })
  
  local OnOff = false
  Callback(OnOff)
  Button.MouseButton1Click:Connect(function()
    if OnOff == false then
      TweenService:Create(Frame2, TweenInfo.new(0.2, Enum.EasingStyle.Linear),
      {Position = UDim2.new(1, -22, 0.5, 0)}):play()
    else
      TweenService:Create(Frame2, TweenInfo.new(0.2, Enum.EasingStyle.Linear),
      {Position = UDim2.new(0, 5, 0.5, 0)}):play()
    end
    OnOff = not OnOff
    Callback(OnOff)
  end)
  
  return Toggle_Atalho
end

LinhaAdd(UDim2.new(0, 1, 1, -TopBar.Size.Y.Offset), UDim2.new(0, ScrollTab.Size.X.Offset, 1, 0), Vector2.new(0, 1))
LinhaAdd(UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0, TopBar.Size.Y.Offset))
LinhaAdd(UDim2.new(0, ScrollTab.Size.X.Offset, 0, 1), UDim2.new(0, 0, 1, -55))
