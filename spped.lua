-- ====================================================================
--            LYUT1E HUB V2 — THIRD SEA OVERHAUL (2026)
-- ====================================================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("lyut1eHub") then CoreGui.lyut1eHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "lyut1eHub"
ScreenGui.ResetOnSpawn = false

-- Главное окно
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 580, 0, 410)
MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Сайдбар
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 50)
Logo.Text = "lyut1e hub v2"
Logo.TextColor3 = Color3.fromRGB(0, 255, 200)
Logo.TextSize = 20
Logo.Font = Enum.Font.FredokaOne
Logo.BackgroundTransparency = 1

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -175, 1, -20)
ContentFrame.Position = UDim2.new(0, 170, 0, 10)
ContentFrame.BackgroundTransparency = 1

local Pages, TotalPages = {}, 0

local function CreatePage(name)
    TotalPages = TotalPages + 1
    local Page = Instance.new("ScrollingFrame", ContentFrame)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1; Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 4; Page.Visible = (TotalPages == 1)
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 8)
    
    local TabButton = Instance.new("TextButton", Sidebar)
    TabButton.Size = UDim2.new(0.85, 0, 0, 36)
    TabButton.Position = UDim2.new(0.075, 0, 0, 60 + ((TotalPages - 1) * 42))
    TabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TabButton.Text = "  " .. name
    TabButton.TextColor3 = Color3.fromRGB(240, 240, 240)
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    Pages[name] = Page
    return Page
end

local function AddToggle(page, text, callback)
    local Frame = Instance.new("Frame", page)
    Frame.Size = UDim2.new(0.95, 0, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0); Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Text = text; Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left; Label.TextSize = 14; Label.BackgroundTransparency = 1
    
    local Indicator = Instance.new("TextButton", Frame)
    Indicator.Size = UDim2.new(0, 55, 0, 24); Indicator.Position = UDim2.new(0.78, 0, 0.2, 0)
    Indicator.BackgroundColor3 = Color3.fromRGB(200, 50, 50); Indicator.Text = "OFF"
    Indicator.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 4)
    
    local state = false
    Indicator.MouseButton1Click:Connect(function()
        state = not state
        Indicator.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
        Indicator.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

local function AddButton(page, text, callback)
    local B = Instance.new("TextButton", page)
    B.Size = UDim2.new(0.95, 0, 0, 36); B.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    B.Text = text; B.TextColor3 = Color3.fromRGB(240, 240, 240); B.TextSize = 14
    B.Font = Enum.Font.SourceSansSemibold; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    B.MouseButton1Click:Connect(callback)
end

-- Вкладки
local FarmPage = CreatePage("Main Farm")
local TeleportPage = CreatePage("Third Sea TPs")
local StatusPage = CreatePage("Stats & Local")

-- ====================================================================
-- ЛОГИКА И СКРИПТЫ (ТРЕТИЙ МИР)
-- ====================================================================

-- Безопасный телепорт (Tween) против античита
local function SecureTP(targetCFrame)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        local speed = 250 -- Оптимальная скорость плавного полета в 2026 году
        local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, info, {CFrame = targetCFrame})
        tween:Play()
        return tween
    end
end

-- Авто-экипировка боевого стиля (Melee)
local function EquipWeapon()
    local backpack = LocalPlayer.Backpack
    local char = LocalPlayer.Character
    if char then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool:FindFirstChild("Combat")) then
                char.Humanoid:EquipTool(tool)
                break
            end
        end
    end
end

-- 1. Вкладка фарма
local AutoFarm = false
AddToggle(FarmPage, "Auto Farm Level (Third Sea)", function(state)
    AutoFarm = state
end)

local FastAttack = false
AddToggle(FarmPage, "Super Fast Attack", function(state)
    FastAttack = state
end)

-- Поток для автофарма
task.spawn(function()
    while true do
        if AutoFarm then
            pcall(function()
                EquipWeapon()
                -- Поиск ближайшего моба в Третьем мире
                local targetMob = nil
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        targetMob = v
                        break
                    end
                end
                
                if targetMob then
                    -- Телепортируемся НАД мобом, чтобы он нас не бил
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                else
                    -- Если мобов нет, летим на спавн мобов Третьего мира (Плавающий замок для примера)
                    SecureTP(CFrame.new(-9511, 400, -5111))
                end
            end)
        end
        task.wait(0.1)
    end
end)

-- Поток быстрых ударов
task.spawn(function()
    while true do
        if FastAttack or AutoFarm then
            local VU = game:GetService("VirtualUser")
            VU:CaptureController()
            VU:ClickButton1(Vector2.new(0, 0))
        end
        task.wait(0.01) -- Максимальная скорость кликов
    end
end)

-- 2. Вкладка телепортов (Только Третий мир!)
AddButton(TeleportPage, "TP to Floating Turtle (Черепаха)", function()
    SecureTP(CFrame.new(-13240, 330, -7670))
end)

AddButton(TeleportPage, "TP to Castle on the Sea (Замок)", function()
    SecureTP(CFrame.new(-9511, 400, -5111))
end)

AddButton(TeleportPage, "TP to Hydra Island (Гидра)", function()
    SecureTP(CFrame.new(5230, 10, -1210))
end)

AddButton(TeleportPage, "TP to Port Town (Порт)", function()
    SecureTP(CFrame.new(-5340, 20, -5300))
end)

-- 3. Настройки персонажа
local SpeedValue = 16
AddButton(StatusPage, "Boost Speed (100)", function()
    SpeedValue = 100
end)
AddButton(StatusPage, "Reset Speed (16)", function()
    SpeedValue = 16
end)

task.spawn(function()
    while true do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
        end
        task.wait(0.5)
    end
end)

-- Кнопка закрытия Х
local Cl = Instance.new("TextButton", MainFrame)
Cl.Size = UDim2.new(0, 24, 0, 24); Cl.Position = UDim2.new(1, -30, 0, 8)
Cl.BackgroundColor3 = Color3.fromRGB(180, 50, 50); Cl.Text = "X"; Cl.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Cl).CornerRadius = UDim.new(0, 4)
Cl.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
