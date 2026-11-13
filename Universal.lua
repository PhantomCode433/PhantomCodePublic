--=====================================================================
-- UNIVERSAL SCRIPT BY PHANTOMCODE333 (FULL THEME OVERHAUL)
--=====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

pcall(function()
    local oldGui = CoreGui:FindFirstChild("UniversalScriptGui") or (LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("UniversalScriptGui"))
    if oldGui then oldGui:Destroy() end
end)

-- Базовый цвет (будет меняться)
local BaseColor = Color3.fromRGB(138, 43, 226) -- Фиолетовый по умолчанию

-- Таблицы для элементов интерфейса (Теги для покраски)
local ThemeMap = {
    DeepBg = {},   -- Самый темный фон (окно)
    MidBg = {},    -- Фон вкладок и контейнеров
    Accent = {},   -- Яркие элементы (ползунки, включенные тумблеры)
    TextPrimary = {}, -- Основной текст (белый)
    TextSecondary = {} -- Текст на вкладках (серый)
}

local function RegisterTheme(element, property, role)
    table.insert(ThemeMap[role], {obj = element, prop = property})
end

local State = {
    ESPEnabled = false,
    SpeedEnabled = false,
    SpeedValue = 16,
    JumpEnabled = false,
    JumpValue = 50,
    InfiniteJumpEnabled = false,
    FlyEnabled = false,
    FlySpeed = 50,
    NoclipEnabled = false
}

--=====================================================================
-- GUI
--=====================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalScriptGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 99999
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Кнопка открытия (US)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0, 20, 0, 100)
OpenBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
OpenBtn.Text = "US"
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 16
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
RegisterTheme(OpenBtn, "TextColor3", "Accent")
RegisterTheme(OpenBtn, "BackgroundColor3", "DeepBg")

-- Главное окно
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 380)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
RegisterTheme(Main, "BackgroundColor3", "DeepBg")

local MainScale = Instance.new("UIScale")
MainScale.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "UNIVERSAL SCRIPT BY PHANTOMCODE333"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header
RegisterTheme(Title, "TextColor3", "TextPrimary")

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20
CloseBtn.Parent = Header
RegisterTheme(CloseBtn, "TextColor3", "TextSecondary")

CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true OpenBtn.Visible = false end)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 35)
TabBar.Position = UDim2.new(0, 10, 0, 45)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Main
local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 5)

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -85)
Content.Position = UDim2.new(0, 10, 0, 85)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 2
Content.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent = Main

local Tabs, TabFrames = {}, {}
local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 1, 0)
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 11
    btn.Parent = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    RegisterTheme(btn, "BackgroundColor3", "MidBg")
    RegisterTheme(btn, "TextColor3", "TextSecondary")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = Content
    Instance.new("UIListLayout", frame).Padding = UDim.new(0, 6)

    TabFrames[name] = frame
    Tabs[name] = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(TabFrames) do f.Visible = false end
        for _, b in pairs(Tabs) do 
            b.BackgroundColor3 = ThemeMap.DeepBg[1].obj.BackgroundColor3
            b.TextColor3 = ThemeMap.TextSecondary[1].obj.TextColor3
        end
        frame.Visible = true
        btn.BackgroundColor3 = ThemeMap.DeepBg[1].obj.BackgroundColor3
        btn.TextColor3 = BaseColor
    end)
    return frame
end

-- Компоненты
local function MakeToggle(text, parent, initial, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -4, 0, 36)
    holder.Parent = parent
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 6)
    RegisterTheme(holder, "BackgroundColor3", "MidBg")
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    RegisterTheme(label, "TextColor3", "TextPrimary")
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 36, 0, 20)
    bg.Position = UDim2.new(1, -46, 0.5, -10)
    bg.Parent = holder
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = initial and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = bg
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = holder
    
    local isOn = initial
    
    local function updateVisuals()
        bg.BackgroundColor3 = isOn and BaseColor or ThemeMap.DeepBg[1].obj.BackgroundColor3
    end
    updateVisuals()
    
    -- Слушатель для смены цвета
    table.insert(ThemeMap.Accent, {obj = bg, prop = "BackgroundColor3", isToggle = true, getState = function() return isOn end})
    table.insert(ThemeMap.DeepBg, {obj = bg, prop = "BackgroundColor3", isToggle = true, getState = function() return not isOn end})
    
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = isOn and BaseColor or ThemeMap.DeepBg[1].obj.BackgroundColor3}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = isOn and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        pcall(callback, isOn)
    end)
    return holder
end

local function MakeSlider(text, parent, min, max, initial, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -4, 0, 48)
    holder.Parent = parent
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 6)
    RegisterTheme(holder, "BackgroundColor3", "MidBg")
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    RegisterTheme(label, "TextColor3", "TextPrimary")
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -24, 0, 16)
    bar.Position = UDim2.new(0, 12, 0, 26)
    bar.Parent = holder
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    RegisterTheme(bar, "BackgroundColor3", "DeepBg")
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((initial - min) / (max - min), 0, 1, 0)
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    RegisterTheme(fill, "BackgroundColor3", "Accent")
    
    local valText = Instance.new("TextLabel")
    valText.Size = UDim2.new(1, -10, 1, 0)
    valText.Position = UDim2.new(0, 5, 0, 0)
    valText.BackgroundTransparency = 1
    valText.Text = tostring(initial)
    valText.Font = Enum.Font.SourceSansBold
    valText.TextSize = 11
    valText.TextXAlignment = Enum.TextXAlignment.Left
    valText.Parent = bar
    RegisterTheme(valText, "TextColor3", "TextPrimary")
    
    local dragging = false
    local function setFromX(x)
        local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * rel + 0.5)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        valText.Text = tostring(val)
        pcall(callback, val)
    end
    
    bar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFromX(inp.Position.X)
        end
    end)
    bar.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            setFromX(inp.Position.X)
        end
    end)
    return holder
end

local function MakeInfoBtn(text, parent, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 36)
    btn.Text = "  " .. text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    RegisterTheme(btn, "BackgroundColor3", "MidBg")
    RegisterTheme(btn, "TextColor3", "TextPrimary")
    btn.MouseButton1Click:Connect(function() pcall(onClick) end)
    return btn
end

local tabVisuals = CreateTab("Visual")
local tabLocal = CreateTab("Local")
local tabPlayer = CreateTab("Player")
local tabConfig = CreateTab("Config")

tabVisuals.Visible = true
Tabs["Visual"].BackgroundColor3 = Color3.fromRGB(28, 28, 30)
Tabs["Visual"].TextColor3 = BaseColor

--=====================================================================
-- ЛОГИКА ИГРЫ
--=====================================================================
local function UpdateESP()
    for _, box in pairs(workspace:GetDescendants()) do
        if box.Name == "ESPBox" then box:Destroy() end
    end
    if not State.ESPEnabled then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESPBox"
                box.Size = Vector3.new(4, 5, 4)
                box.Adornee = hrp
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Transparency = 0.5
                box.Color3 = BaseColor
                box.Parent = hrp
            end
        end
    end
end

MakeToggle("ESP Players", tabVisuals, false, function(v) State.ESPEnabled = v UpdateESP() end)
MakeToggle("Noclip", tabVisuals, false, function(v)
    State.NoclipEnabled = v
    if not v and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end)

MakeToggle("Speed Regulator", tabLocal, false, function(v) 
    State.SpeedEnabled = v 
    if not v then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end)
MakeSlider("Speed Value", tabLocal, 16, 200, 16, function(v) State.SpeedValue = v end)

MakeToggle("Jump Regulator", tabLocal, false, function(v) 
    State.JumpEnabled = v
    if not v then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.UseJumpPower = true hum.JumpPower = 50 end
    end
end)
MakeSlider("Jump Value", tabLocal, 50, 500, 50, function(v) State.JumpValue = v end)

MakeToggle("Infinite Jump", tabLocal, false, function(v) State.InfiniteJumpEnabled = v end)
UserInputService.JumpRequest:Connect(function()
    if State.InfiniteJumpEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end) end
    end
end)

-- Fly
local flyBV, flyBG = nil, nil
local upBtn, downBtn = nil, nil
local isUpPressed, isDownPressed = false, false

local function CreateMobileFlyButtons()
    if upBtn then upBtn:Destroy() end
    if downBtn then downBtn:Destroy() end
    local FlyControls = Instance.new("Frame")
    FlyControls.Name = "FlyControls"
    FlyControls.Size = UDim2.new(0, 100, 0, 100)
    FlyControls.Position = UDim2.new(1, -120, 0.5, -50)
    FlyControls.BackgroundTransparency = 1
    FlyControls.Parent = ScreenGui
    local FlyScale = Instance.new("UIScale")
    FlyScale.Parent = FlyControls
    
    upBtn = Instance.new("TextButton")
    upBtn.Size = UDim2.new(0, 45, 0, 45)
    upBtn.Position = UDim2.new(0, 0, 0, 0)
    upBtn.Text = "▲"
    upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    upBtn.Font = Enum.Font.SourceSansBold
    upBtn.TextSize = 20
    upBtn.Visible = false
    upBtn.Parent = FlyControls
    Instance.new("UICorner", upBtn).CornerRadius = UDim.new(1, 0)
    RegisterTheme(upBtn, "BackgroundColor3", "Accent")
    
    downBtn = Instance.new("TextButton")
    downBtn.Size = UDim2.new(0, 45, 0, 45)
    downBtn.Position = UDim2.new(0, 0, 0, 55)
    downBtn.Text = "▼"
    downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    downBtn.Font = Enum.Font.SourceSansBold
    downBtn.TextSize = 20
    downBtn.Visible = false
    downBtn.Parent = FlyControls
    Instance.new("UICorner", downBtn).CornerRadius = UDim.new(1, 0)
    RegisterTheme(downBtn, "BackgroundColor3", "Accent")

    upBtn.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then isUpPressed = true end end)
    upBtn.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then isUpPressed = false end end)
    downBtn.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then isDownPressed = true end end)
    downBtn.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then isDownPressed = false end end)
    return FlyControls, FlyScale
end
local FlyControls, FlyScale = CreateMobileFlyButtons()

MakeToggle("Fly", tabLocal, false, function(v)
    State.FlyEnabled = v
    upBtn.Visible = v
    downBtn.Visible = v
    if not v then
        if flyBV then flyBV:Destroy() flyBV = nil end
        if flyBG then flyBG:Destroy() flyBG = nil end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
        end
    end
end)
MakeSlider("Fly Regulator", tabLocal, 10, 300, 50, function(v) State.FlySpeed = v end)

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if State.SpeedEnabled then hum.WalkSpeed = State.SpeedValue end
    if State.JumpEnabled then hum.UseJumpPower = true hum.JumpPower = State.JumpValue end
    if State.NoclipEnabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not State.FlyEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hrp and hum then
        if not flyBV or flyBV.Parent ~= hrp then
            if flyBV then flyBV:Destroy() end
            if flyBG then flyBG:Destroy() end
            flyBV = Instance.new("BodyVelocity", hrp)
            flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyBG = Instance.new("BodyGyro", hrp)
            flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            flyBG.P = 9e4
        end
        local moveDir = hum.MoveDirection
        if isUpPressed then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if isDownPressed then moveDir = moveDir - Vector3.new(0, 1, 0) end
        flyBV.Velocity = moveDir * State.FlySpeed
        flyBG.CFrame = Camera.CFrame
    end
end)

--=====================================================================
-- PLAYER & CONFIG
--=====================================================================
local dateString = "Unknown"
pcall(function()
    local joinTime = os.time() - (LocalPlayer.AccountAge * 86400)
    dateString = os.date("%d.%m.%Y", joinTime)
end)

MakeInfoBtn("Name: " .. LocalPlayer.Name, tabPlayer, function() pcall(function() setclipboard(LocalPlayer.Name) end) end)
MakeInfoBtn("User: " .. tostring(LocalPlayer.UserId), tabPlayer, function() pcall(function() setclipboard(tostring(LocalPlayer.UserId)) end) end)
MakeInfoBtn("Data (Дата): " .. dateString, tabPlayer, function() pcall(function() setclipboard(dateString) end) end)

MakeSlider("GUI Scale", tabConfig, 50, 150, 100, function(v)
    local scale = v / 100
    MainScale.Scale = scale
    FlyScale.Scale = scale
end)

-- Палитра цветов
local colorHolder = Instance.new("Frame")
colorHolder.Size = UDim2.new(1, -4, 0, 60)
colorHolder.Parent = tabConfig
Instance.new("UICorner", colorHolder).CornerRadius = UDim.new(0, 6)
RegisterTheme(colorHolder, "BackgroundColor3", "MidBg")

local colorLabel = Instance.new("TextLabel")
colorLabel.Size = UDim2.new(1, -20, 0, 20)
colorLabel.Position = UDim2.new(0, 12, 0, 4)
colorLabel.BackgroundTransparency = 1
colorLabel.Text = "Color GUI (Выбери цвет)"
colorLabel.Font = Enum.Font.SourceSansBold
colorLabel.TextSize = 12
colorLabel.TextXAlignment = Enum.TextXAlignment.Left
colorLabel.Parent = colorHolder
RegisterTheme(colorLabel, "TextColor3", "TextPrimary")

local btnHolder = Instance.new("Frame")
btnHolder.Size = UDim2.new(1, -20, 0, 26)
btnHolder.Position = UDim2.new(0, 10, 0, 26)
btnHolder.BackgroundTransparency = 1
btnHolder.Parent = colorHolder
local btnLayout = Instance.new("UIListLayout", btnHolder)
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.Padding = UDim.new(0, 8)

local themes = {
    Color3.fromRGB(138, 43, 226), -- Фиолетовый
    Color3.fromRGB(0, 170, 255),  -- Синий
    Color3.fromRGB(255, 50, 50),  -- Красный
    Color3.fromRGB(50, 255, 50),  -- Зеленый
    Color3.fromRGB(255, 150, 0),  -- Оранжевый
    Color3.fromRGB(220, 220, 220) -- Белый (Серый)
}

-- Функция применения темы ко ВСЕМУ интерфейсу
local function ApplyTheme(color)
    BaseColor = color
    -- Вычисляем оттенки
    local deepBg = color:Lerp(Color3.fromRGB(0,0,0), 0.85)  -- Очень темный для фона
    local midBg = color:Lerp(Color3.fromRGB(0,0,0), 0.7)    -- Темный для кнопок
    local textPrim = Color3.fromRGB(255, 255, 255)          -- Белый текст
    local textSec = color:Lerp(Color3.fromRGB(255,255,255), 0.3) -- Светлый текст
    
    -- 1. Красим DeepBg (Главное окно, фон ползунков)
    for _, data in pairs(ThemeMap.DeepBg) do
        if data.isToggle then
            if data.getState() then data.obj[data.prop] = deepBg end
        else
            data.obj[data.prop] = deepBg
        end
    end
    
    -- 2. Красим MidBg (Фон вкладок, контейнеры)
    for _, data in pairs(ThemeMap.MidBg) do
        data.obj[data.prop] = midBg
    end
    
    -- 3. Красим Accent (Ползунки, включенные тумблеры, текст)
    for _, data in pairs(ThemeMap.Accent) do
        if data.isToggle then
            if data.getState() then data.obj[data.prop] = color end
        else
            data.obj[data.prop] = color
        end
    end
    
    -- 4. Красим TextPrimary (Белый текст)
    for _, data in pairs(ThemeMap.TextPrimary) do
        data.obj[data.prop] = textPrim
    end
    
    -- 5. Красим TextSecondary (Серый текст, крестик)
    for _, data in pairs(ThemeMap.TextSecondary) do
        data.obj[data.prop] = textSec
    end
    
    -- Красим активную вкладку
    for name, frame in pairs(TabFrames) do
        if frame.Visible then
            Tabs[name].BackgroundColor3 = deepBg
            Tabs[name].TextColor3 = color
        end
    end
    
    -- Обновляем ESP
    UpdateESP()
end

for _, color in ipairs(themes) do
    local cBtn = Instance.new("TextButton")
    cBtn.Size = UDim2.new(0, 24, 0, 24)
    cBtn.BackgroundColor3 = color
    cBtn.Text = ""
    cBtn.Parent = btnHolder
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(1, 0)
    
    cBtn.MouseButton1Click:Connect(function()
        ApplyTheme(color)
    end)
end

-- Применяем фиолетовую тему при старте
ApplyTheme(themes[1])

print("[UNIVERSAL SCRIPT] Loaded. FULL THEME SYSTEM ACTIVE.")
