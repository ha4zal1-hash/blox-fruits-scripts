-- ====================================================================
--                      LYUT1E HUB — PREMIUM EDITION (2026)
-- ====================================================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- Защита от дублирования интерфейса
if CoreGui:FindFirstChild("lyut1eHub") then
    CoreGui.lyut1eHub:Destroy()
end

-- Основной контейнер GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "lyut1eHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Главный фрейм (Окно хаба)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 560, 0, 390)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Перетаскивание по экрану мышкой/пальцем
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Боковое меню (Сайдбар для вкладок)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

-- Логотип / Название хаба
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 50)
Logo.Text = "lyut1e hub"
Logo.TextColor3 = Color3.fromRGB(0, 220, 255) -- Сочный бирюзовый неон
Logo.TextSize = 22
Logo.Font = Enum.Font.FredokaOne
Logo.BackgroundTransparency = 1
Logo.Parent = Sidebar

-- Декоративная неоновая полоска под логотипом
local Line = Instance.new("Frame")
Line.Size = UDim2.new(0.8, 0, 0, 2)
Line.Position = UDim2.new(0.1, 0, 0, 45)
Line.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
Line.BorderSizePixel = 0
Line.Parent = Sidebar

-- Главная рабочая область для страниц
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -165, 1, -20)
ContentFrame.Position = UDim2.new(0, 155, 0, 10)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local Pages = {}
local TotalPages = 0

-- Функция создания страниц (категорий)
local function CreatePage(name)
    TotalPages = TotalPages + 1
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Color3.fromRGB(0, 220, 255)
    Page.Visible = false
    Page.Parent = ContentFrame
    
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 10)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Page
    
    Pages[name] = Page
    
    -- Кнопка переключения вкладки в сайдбаре
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.85, 0, 0, 36)
    TabButton.Position = UDim2.new(0.075, 0, 0, 60 + ((TotalPages - 1) * 44))
    TabButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    TabButton.Text = "  " .. name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 14
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.Parent = Sidebar
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = TabButton
    
    TabButton.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    
    if TotalPages == 1 then Page.Visible = true end -- Показываем первую страницу сразу
    return Page
end

-- Функция добавления заголовков секций
local function AddSection(page, titleText)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.95, 0, 0, 25)
    Label.Text = "—— " .. string.upper(titleText) .. " ——"
    Label.TextColor3 = Color3.fromRGB(120, 120, 130)
    Label.TextSize = 12
    Label.Font = Enum.Font.SourceSansBold
    Label.BackgroundTransparency = 1
    Label.Parent = page
end

-- Функция добавления обычных функциональных кнопок
local function AddButton(page, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.95, 0, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    Btn.TextSize = 15
    Btn.Font = Enum.Font.SourceSansSemibold
    Btn.Parent = page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn
    
    -- Визуальный эффект при наведении мыши/нажатии
    Btn.MouseEnter:Connect(function() Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48) end)
    Btn.MouseLeave:Connect(function() Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35) end)
    
    Btn.MouseButton1Click:Connect(callback)
end

-- Функция добавления переключателей (On/Off)
local function AddToggle(page, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.95, 0, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Frame.Parent = page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextSize = 15
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSansSemibold
    Label.Parent = Frame
    
    local Indicator = Instance.new("TextButton")
    Indicator.Size = UDim2.new(0, 55, 0, 24)
    Indicator.Position = UDim2.new(0.8, 0, 0.2, 0)
    Indicator.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    Indicator.Text = "OFF"
    Indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
    Indicator.Font = Enum.Font.SourceSansBold
    Indicator.TextSize = 13
    Indicator.Parent = Frame
    
    local IndCorner = Instance.new("UICorner")
    IndCorner.CornerRadius = UDim.new(0, 4)
    IndCorner.Parent = Indicator
    
    local state = false
    Indicator.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Indicator.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            Indicator.Text = "ON"
        else
            Indicator.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
            Indicator.Text = "OFF"
        end
        callback(state)
    end)
end

-- ====================================================================
--                  ИНИЦИАЛИЗАЦИЯ СТРАНИЦ И ФУНКЦИЙ
-- ====================================================================
local FarmTab = CreatePage("Main & Farm")
local MoveTab = CreatePage("Movement")
local TeleportTab = CreatePage("Teleports")
local MiscTab = CreatePage("Misc Settings")

-- [1. СТРАНИЦА ФАРМА]
AddSection(FarmTab, "Combat Hacks")

local AutoAttack = false
local AttackSpeed = 0.05

AddToggle(FarmTab, "Fast Auto Attack (Clicker)", function(state)
    AutoAttack = state
end)

-- Отдельный быстрый поток для обработки ударов
task.spawn(function()
    while true do
        if AutoAttack then
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0, 0))
        end
        task.wait(AttackSpeed)
    end
end)

AddSection(FarmTab, "Attack Speed Tweak")
AddButton(FarmTab, "Set Attack Speed: Ludicrous (0.01s)", function() AttackSpeed = 0.01 end)
AddButton(FarmTab, "Set Attack Speed: Safe (0.08s)", function() AttackSpeed = 0.08 end)

-- [2. СТРАНИЦА ДВИЖЕНИЯ]
AddSection(MoveTab, "Speed Modifier")

AddButton(MoveTab, "Speedhack: Max Velocity (250)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 250
    end
end)

AddButton(MoveTab, "Speedhack: Legit Speed (60)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 60
    end
end)

AddButton(MoveTab, "Reset Speed to Standard (16)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

AddSection(MoveTab, "Air Control")
local InfJump = false
AddToggle(MoveTab, "Enable Infinite Jump", function(state)
    InfJump = state
end)

UserInputService.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- [3. СТРАНИЦА ТЕЛЕПОРТОВ]
AddSection(TeleportTab, "Sea 1 Locations")

local function tp(x, y, z)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
    end
end

AddButton(TeleportTab, "TP: Pirate Starter Island", function() tp(979, 16, 1429) end)
AddButton(TeleportTab, "TP: Jungle Island", function() tp(-1611, 36, 147) end)
AddButton(TeleportTab, "TP: Pirate Village", function() tp(-1181, 4, 3848) end)
AddButton(TeleportTab, "TP: Desert Island", function() tp(1094, 6, 4195) end)
AddButton(TeleportTab, "TP: Frozen Village (Snow)", function() tp(1286, 6, -1342) end)

-- [4. СТРАНИЦА НАСТРОЕК (MISC)]
AddSection(MiscTab, "Server Management")

AddButton(MiscTab, "Rejoin Current Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

AddSection(MiscTab, "UI Control")
AddButton(MiscTab, "Completely Destroy GUI", function()
    ScreenGui:Destroy()
end)

-- Кнопка быстрого закрытия меню (Верхний правый угол)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
