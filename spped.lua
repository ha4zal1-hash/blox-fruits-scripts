-- ====================================================================
--            LYUT1E HUB V2 — ULTIMATE UNLEASHED (THIRD SEA)
-- ====================================================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("lyut1eHub") then CoreGui.lyut1eHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "lyut1eHub"
ScreenGui.ResetOnSpawn = false

-- Главное окно
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 430)
MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

-- Сайдбар
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 14)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 50)
Logo.Text = "lyut1e hub v2"
Logo.TextColor3 = Color3.fromRGB(0, 255, 200)
Logo.TextSize = 22
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
    Page.ScrollBarThickness = 4; Page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 200); Page.Visible = (TotalPages == 1)
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 8)
    
    local TabButton = Instance.new("TextButton", Sidebar)
    TabButton.Size = UDim2.new(0.85, 0, 0, 36)
    TabButton.Position = UDim2.new(0.075, 0, 0, 60 + ((TotalPages - 1) * 42))
    TabButton.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
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
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
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
    B.Size = UDim2.new(0.95, 0, 0, 36); B.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    B.Text = text; B.TextColor3 = Color3.fromRGB(240, 240, 240); B.TextSize = 14
    B.Font = Enum.Font.SourceSansSemibold; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    B.MouseButton1Click:Connect(callback)
end

local function AddSection(page, txt)
    local L = Instance.new("TextLabel", page)
    L.Size = UDim2.new(0.95, 0, 0, 20); L.Text = "— " .. string.upper(txt) .. " —"; L.TextColor3 = Color3.fromRGB(100, 100, 110)
    L.TextSize = 11; L.Font = Enum.Font.SourceSansBold; L.BackgroundTransparency = 1
end

-- Вкладки хаба
local FarmPage = CreatePage("Main Farm")
local CombatPage = CreatePage("Combat & Stats")
local MovePage = CreatePage("Movement & Exploit")
local TeleportPage = CreatePage("Third Sea TPs")
local VisualPage = CreatePage("Visuals / ESP")

-- ====================================================================
--                      ДВИЖОК СКРИПТОВ
-- ====================================================================

-- Настройки твинов
local function SecureTP(targetCFrame)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        local info = TweenInfo.new(distance / 250, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, info, {CFrame = targetCFrame})
        tween:Play()
        return tween
    end
end

-- Авто-экипировка боевого стиля
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

-- [1. ВКЛАДКА ФАРМА]
AddSection(FarmPage, "Level Farming")
local AutoFarm = false
AddToggle(FarmPage, "Auto Farm Level (Third Sea)", function(v) AutoFarm = v end)

task.spawn(function()
    while true do
        if AutoFarm then
            pcall(function()
                EquipWeapon()
                local enemy = nil
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        enemy = v; break
                    end
                end
                if enemy then
                    -- Встаем над мобом, чтобы он мазал
                    LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0)
                else
                    SecureTP(CFrame.new(-9511, 400, -5111)) -- Лобби замка, если пусто
                end
            end)
        end
        task.wait(0.1)
    end
end)

-- [2. БОЙ И АВТО-СТАТЫ]
AddSection(CombatPage, "Fast Attack Tweak")
local FastAttack = false
AddToggle(CombatPage, "Super Fast Attack", function(v) FastAttack = v end)

task.spawn(function()
    while true do
        if FastAttack or AutoFarm then
            local VU = game:GetService("VirtualUser")
            VU:CaptureController(); VU:ClickButton1(Vector2.new(0, 0))
        end
        task.wait(0.005) -- Ультра-кликер 2026 года
    end
end)

AddSection(CombatPage, "Auto Assign Stats")
local AutoStats = false
AddToggle(CombatPage, "Auto Upgrade Melee Stats", function(v) AutoStats = v end)

task.spawn(function()
    while true do
        if AutoStats then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
            end)
        end
        task.wait(0.5)
    end
end)

-- [3. ДВИЖЕНИЕ И EXPLOIT (ОБНОВЛЕНИЕ)]
AddSection(MovePage, "Noclip Wallhack")
local Noclip = false
AddToggle(MovePage, "Enable Noclip (Сквозь стены)", function(v) Noclip = v end)

RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

AddSection(MovePage, "Movement physics")
local SpeedValue = 16
AddButton(MovePage, "Set Speed to 120", function() SpeedValue = 120 end)
AddButton(MovePage, "Set Speed to 250", function() SpeedValue = 250 end)
AddButton(MovePage, "Reset Speed (16)", function() SpeedValue = 16 end)

task.spawn(function()
    while true do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
        end
        task.wait(0.2)
    end
end)

local InfJump = false
AddToggle(MovePage, "Infinite Jump (Бесконечный прыжок)", function(v) InfJump = v end)
UserInputService.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- [4. ТЕЛЕПОРТЫ (ТРЕТИЙ МИР)]
AddSection(TeleportPage, "Safe Teleports")
AddButton(TeleportPage, "Floating Turtle (Черепаха)", function() SecureTP(CFrame.new(-13240, 330, -7670)) end)
AddButton(TeleportPage, "Castle on the Sea (Замок)", function() SecureTP(CFrame.new(-9511, 400, -5111)) end)
AddButton(TeleportPage, "Hydra Island (Гидра)", function() SecureTP(CFrame.new(5230, 10, -1210)) end)
AddButton(TeleportPage, "Port Town (Порт)", function() SecureTP(CFrame.new(-5340, 20, -5300)) end)

-- [5. ВИЗУАЛЫ И ESP]
AddSection(VisualPage, "Wallhack Player ESP")
local EspEnabled = false
local EspFolders = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    local function apply()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not player.Character.HumanoidRootPart:FindFirstChild("Lyut1eHighlight") then
            local Highlight = Instance.new("Highlight")
            Highlight.Name = "Lyut1eHighlight"
            Highlight.FillColor = Color3.fromRGB(0, 255, 200)
            Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            Highlight.FillTransparency = 0.5
            Highlight.Parent = player.Character.HumanoidRootPart
        end
    end
    player.CharacterAdded:Connect(apply)
    if player.Character then apply() end
end

AddToggle(VisualPage, "Player Highlight ESP (Сквозь стены)", function(v)
    EspEnabled = v
    if EspEnabled then
        for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
        Players.PlayerAdded:Connect(CreateESP)
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.HumanoidRootPart:FindFirstChild("Lyut1eHighlight") then
                p.Character.HumanoidRootPart.Lyut1eHighlight:Destroy()
            end
        end
    end
end)

-- Кнопка закрытия Х
local Cl = Instance.new("TextButton", MainFrame)
Cl.Size = UDim2.new(0, 24, 0, 24); Cl.Position = UDim2.new(1, -30, 0, 8)
Cl.BackgroundColor3 = Color3.fromRGB(180, 50, 50); Cl.Text = "X"; Cl.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Cl).CornerRadius = UDim.new(0, 4)
Cl.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
