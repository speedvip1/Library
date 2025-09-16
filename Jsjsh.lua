-- Services
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui") or gethui()
local Players = game:GetService("Players")

-- Variables
local LocalPlayer = Players.LocalPlayer
local ViewportSize = workspace.CurrentCamera.ViewportSize
local Scale = ViewportSize.Y / 450

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Library Configuration
local SpeedHubX = {
    Themes = {
        DarkerRed = {
            ["Color Hub 1"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(10, 10, 10)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(20, 20, 20)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(10, 10, 10))
            }),
            ["Color Hub 2"] = Color3.fromRGB(30, 30, 30),
            ["Color Stroke"] = Color3.fromRGB(40, 40, 40),
            ["Color Theme"] = Color3.fromRGB(200, 0, 0),
            ["Color Text"] = Color3.fromRGB(255, 255, 255),
            ["Color Dark Text"] = Color3.fromRGB(150, 150, 150)
        }
    },
    Info = {Version = ""},
    Save = {UISize = {550, 350}, TabSize = 160, Theme = "DarkerRed"},
    Instances = {},
    Elements = {},
    Options = {},
    Flags = {},
    Tabs = {},
    Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Main/main/Icons.lua"))()
}

-- Helper Functions
local function CreateInstance(instanceType, properties, children)
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

local function ApplyProperties(instance, properties)
    if properties then
        for property, value in pairs(properties) do
            instance[property] = value
        end
    end
    return instance
end

local function AddChildren(instance, children)
    if children then
        for _, child in pairs(children) do
            child.Parent = instance
        end
    end
    return instance
end

local function TrackInstance(instance, instanceType)
    table.insert(SpeedHubX.Instances, {Instance = instance, Type = instanceType})
    return instance
end

-- File Operations
local function VerifyTheme(themeName)
    return SpeedHubX.Themes[themeName] ~= nil
end

local function SaveToFile(filename, data)
    if writefile then
        local encoded = HttpService:JSONEncode(data)
        writefile(filename, encoded)
    end
end

local function LoadFromFile(filename)
    if readfile and isfile and isfile(filename) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(filename))
        end)
        
        if success and type(data) == "table" then
            if data.UISize then SpeedHubX.Save.UISize = data.UISize end
            if data.TabSize then SpeedHubX.Save.TabSize = data.TabSize end
            if data.Theme and VerifyTheme(data.Theme) then SpeedHubX.Save.Theme = data.Theme end
        end
    end
end

-- Load saved settings
LoadFromFile("Speed Hub X V3.lua")

-- UI Creation
local MainUI = CreateInstance("ScreenGui", {
    Name = "Speed Hub X Lib V3",
    Parent = CoreGui
}, {
    CreateInstance("UIScale", {Scale = Scale, Name = "Scale"})
})

-- Remove duplicate UI if exists
local existingUI = CoreGui:FindFirstChild(MainUI.Name)
if existingUI and existingUI ~= MainUI then
    existingUI:Destroy()
end

-- Element Creation Functions
SpeedHubX.Elements.Corner = function(parent, cornerRadius)
    return TrackInstance(CreateInstance("UICorner", {
        Parent = parent,
        CornerRadius = cornerRadius or UDim.new(0, 7)
    }), "Corner")
end

SpeedHubX.Elements.Stroke = function(parent, color, thickness)
    return TrackInstance(CreateInstance("UIStroke", {
        Parent = parent,
        Color = color or SpeedHubX.Themes[SpeedHubX.Save.Theme]["Color Stroke"],
        Thickness = thickness or 1,
        ApplyStrokeMode = "Border"
    }), "Stroke")
end

SpeedHubX.Elements.Button = function(parent, properties, callback)
    local button = TrackInstance(CreateInstance("TextButton", {
        Parent = parent,
        Text = "",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = SpeedHubX.Themes[SpeedHubX.Save.Theme]["Color Hub 2"],
        AutoButtonColor = false
    }), "Frame")
    
    ApplyProperties(button, properties)
    
    button.MouseEnter:Connect(function()
        button.BackgroundTransparency = 0.4
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundTransparency = 0
    end)
    
    if callback then
        button.Activated:Connect(callback)
    end
    
    return button
end

SpeedHubX.Elements.Gradient = function(parent, properties)
    return TrackInstance(CreateInstance("UIGradient", {
        Parent = parent,
        Color = SpeedHubX.Themes[SpeedHubX.Save.Theme]["Color Hub 1"]
    }), "Gradient")
end

-- Additional UI creation functions would follow the same pattern...

-- Main Library Functions
function SpeedHubX:GetIcon(iconName)
    if iconName:find("rbxassetid://") or iconName:len() < 1 then
        return iconName
    end
    
    iconName = iconName:lower():gsub("lucide", ""):gsub("-", "")
    
    for name, icon in pairs(self.Icons) do
        name = name:gsub("lucide", ""):gsub("-", "")
        if name == iconName then
            return icon
        end
    end
    
    for name, icon in pairs(self.Icons) do
        name = name:gsub("lucide", ""):gsub("-", "")
        if name:find(iconName) then
            return icon
        end
    end
    
    return iconName
end

function SpeedHubX:SetTheme(themeName)
    if not VerifyTheme(themeName) then return end
    
    self.Save.Theme = themeName
    SaveToFile("Speed Hub X V3.lua", self.Save)
    
    local theme = self.Themes[themeName]
    
    for _, instanceData in pairs(self.Instances) do
        local instance = instanceData.Instance
        
        if instanceData.Type == "Gradient" then
            instance.Color = theme["Color Hub 1"]
        elseif instanceData.Type == "Frame" then
            instance.BackgroundColor3 = theme["Color Hub 2"]
        elseif instanceData.Type == "Stroke" then
            instance.Color = theme["Color Stroke"]
        elseif instanceData.Type == "Theme" then
            instance.BackgroundColor3 = theme["Color Theme"]
        elseif instanceData.Type == "Text" then
            instance.TextColor3 = theme["Color Text"]
        elseif instanceData.Type == "DarkText" then
            instance.TextColor3 = theme["Color Dark Text"]
        elseif instanceData.Type == "ScrollBar" then
            instance.ScrollBarImageColor3 = theme["Color Theme"]
        end
    end
end

function SpeedHubX:SetScale(newScale)
    Scale = ViewportSize.Y / math.clamp(newScale, 300, 2000)
    MainUI.Scale.Scale = Scale
end

function SpeedHubX:MakeWindow(options)
    -- Window creation code would follow the same organized pattern
    -- This is a simplified version for demonstration
    local windowName = options.Name or options.Title or ""
    local subTitle = options.SubTitle or ""
    local saveFolder = options.SaveFolder or false
    local saveRejoin = options.SaveRejoin or false
    
    -- Window creation logic here...
    
    return {
        CloseBtn = function()
            -- Close window logic
        end,
        Minimize = function()
            -- Minimize window logic
        end,
        Set = function(title, subtitle)
            -- Set title logic
        end,
        -- Other window methods...
    }
end

return SpeedHubX
