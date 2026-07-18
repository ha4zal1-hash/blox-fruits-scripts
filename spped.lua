-- 1. Сразу включаем скорость (как в твоей первой рабочей версии)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 200

-- 2. Включаем бесконечный цикл для авто-атаки (автофарм)
_G.AutoAttack = true -- Если захочешь выключить, поменяй true на false

spawn(function()
    while _G.AutoAttack do
        -- Этот код имитирует клик мышки (удар в игре) каждые 0.1 секунды
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(0, 0))
        
        task.wait(0.1) -- Скорость ударов
    end
end)
