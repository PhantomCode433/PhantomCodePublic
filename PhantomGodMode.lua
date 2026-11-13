local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local godModeEnabled = false
local loopConnection = nil
local savedPosition = Vector3.new(0, 50, 0)

-- ==========================================
-- ДИЗАЙН GUI
-- ==========================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PhantomCode_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Основное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 270, 0, 100)
MainFrame.Position = UDim2.new(0.5, -135, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

-- Обводка окна
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(130, 255, 100) 
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Заголовок (Убрал "v2")
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 25)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "PhantomCode god mode" -- Изменил текст
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(200, 100, 255)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(150, 255, 100)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(200, 100, 255))
}
TitleGradient.Parent = Title

-- Кнопка Свернуть [-]
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 2)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "—" 
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.Parent = MainFrame

-- Внутренняя темная плашка
local InnerFrame = Instance.new("Frame")
InnerFrame.Size = UDim2.new(1, -20, 0, 50)
InnerFrame.Position = UDim2.new(0, 10, 0, 35)
InnerFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 12)
InnerFrame.BorderSizePixel = 0
InnerFrame.Parent = MainFrame

local InnerCorner = Instance.new("UICorner")
InnerCorner.CornerRadius = UDim.new(0, 4)
InnerCorner.Parent = InnerFrame

-- Кнопка "GOD MODE: OFF"
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Text = "GOD MODE: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(150, 100, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.Parent = InnerFrame

-- ==========================================
-- КРУГЛАЯ КНОПКА "P" (БЕЛАЯ С ЧЕРНОЙ БУКВОЙ)
-- ==========================================
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 50, 0, 50) 
OpenButton.Position = UDim2.new(0.5, -25, 0.1, 0) 
OpenButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Белый фон
OpenButton.Text = "P" 
OpenButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Черная буква
OpenButton.Font = Enum.Font.GothamBlack
OpenButton.TextSize = 28
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0) 
OpenCorner.Parent = OpenButton

-- Черная обводка (чтобы белый круг не исчезал на светлом фоне)
local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(0, 0, 0) 
OpenStroke.Thickness = 2
OpenStroke.Parent = OpenButton

-- ==========================================
-- ЛОГИКА GUI
-- ==========================================

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

-- ==========================================
-- ЖЕСТКИЙ АНТИ-РЕСЕТ И АНТИ-ВОЙД
-- ==========================================

local function startGodMode()
    if loopConnection then loopConnection:Disconnect() end
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPosition = char.HumanoidRootPart.Position
    end

    loopConnection = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        
        if hum and hrp then
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
            
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            if hum:GetState() == Enum.HumanoidStateType.Dead then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            
            if hrp.Position.Y < -50 then
                hrp.CFrame = CFrame.new(savedPosition + Vector3.new(0, 5, 0)) 
            else
                if hrp.Position.Y > -10 then
                    savedPosition = hrp.Position
                end
            end
            
            local parts = workspace:GetPartBoundsInRadius(hrp.Position, 15)
            for _, part in ipairs(parts) do
                if part:IsA("BasePart") and part.CanTouch then
                    local color = part.Color
                    if (color.R > 0.7 and color.G < 0.3 and color.B < 0.3) or 
                       (color.R > 0.8 and color.G > 0.4 and color.B < 0.2) then
                        part.CanTouch = false
                    end
                end
            end
        end
    end)
end

ToggleButton.MouseButton1Click:Connect(function()
    godModeEnabled = not godModeEnabled
    
    if godModeEnabled then
        ToggleButton.Text = "GOD MODE: ON"
        ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 100)
        startGodMode()
    else
        ToggleButton.Text = "GOD MODE: OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(150, 100, 255)
        if loopConnection then
            loopConnection:Disconnect()
            loopConnection = nil
        end
        
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if godModeEnabled then
        task.wait(1)
        startGodMode()
    end
end)
