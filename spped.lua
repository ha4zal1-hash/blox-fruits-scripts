-- ====================================================================
--                      MY FIRST CUSTOM MULTI-HUB
-- ====================================================================

-- 1. Загружаем топовую библиотеку Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- 2. Настройки окна (стиль, размеры)
local Window = Fluent:CreateWindow({
    Title = "Quantum X Hub",
    SubTitle = "by AI & You",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Красивое размытие заднего фона
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Свернуть меню на левый Ctrl
})

-- 3. Создаем вкладки (Вспомни Redz Hub, там всё по категориям)
local Tabs = {
    Main = Window:AddTab({ Title = "Movement", Icon = "run" }),
    Combat = Window:AddTab({ Title = "Combat/Farm", Icon = "sword" }),
    Teleport = Window:AddTab({ Title = "Teleports", Icon = "map-pin" })
}

-- ====================================================================
-- ВКЛАДКА 1: ДВИЖЕНИЕ (MOVEMENT)
-- ====================================================================
Tabs.Main:AddSection("Player Physics")

-- Слайдер скорости (можно плавно выбирать от 16 до 300!)
local SpeedSlider = Tabs.Main:AddSlider("Slider", {
    Title = "WalkSpeed",
    Description = "Adjust your movement speed",
    Default = 16,
    Min = 16,
    Max = 300,
    Rounding = 0,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- Переключатель бесконечных прыжков
local InfiniteJumpEnabled = false
Tabs.Main:AddToggle("InfJump", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        InfiniteJumpEnabled = Value
    end
})

-- Логика бесконечного прыжка
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
    end
end)


-- ====================================================================
-- ВКЛАДКА 2: БОЙ И ФАРМ (COMBAT)
-- ====================================================================
Tabs.Combat:AddSection("Auto Combat")

local AutoClickEnabled = false
Tabs.Combat:AddToggle("FastAttack", {
    Title = "Auto Clicker (Fast Attack)",
    Default = false,
    Callback = function(Value)
        AutoClickEnabled = Value
    end
})

-- Бесконечный цикл для автокликера в отдельном потоке
task.spawn(function()
    while true do
        if AutoClickEnabled then
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0, 0))
        end
        task.wait(0.1) -- Задержка между ударами
    end
end)


-- ====================================================================
-- ВКЛАДКА 3: ТЕЛЕПОРТЫ (TELEPORTS)
-- ====================================================================
Tabs.Teleport:AddSection("Sea 1 Islands")

-- Функция для безопасного телепорта
local function tp(x, y, z)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
    end
end

-- Кнопки телепорта по координатам Первого Моря
Tabs.Teleport:AddButton({
    Title = "Teleport to Starter Island",
    Callback = function()
        tp(979.7, 16.5, 1429.9)
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Jungle",
    Callback = function()
        tp(-1611.0, 36.8, 147.4)
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Pirate Village",
    Callback = function()
        tp(-1181.3, 4.7, 3848.3)
    end
})

-- ====================================================================
-- ИНИЦИАЛИЗАЦИЯ
-- ====================================================================
Window:SelectTab(1)
Fluent:Notify({
    Title = "Quantum X",
    Content = "Hub loaded successfully! Enjoy.",
    Duration = 5
})
