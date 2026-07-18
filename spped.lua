-- 1. Load Orion UI Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

-- 2. Create Window
local Window = OrionLib:MakeWindow({Name = "My First Hub", HidePremium = false, SaveConfig = true})

-- 3. Create Tab
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998"})

-- 4. Speedhack Button
MainTab:AddButton({
    Name = "Speedhack 200",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 200
        OrionLib:MakeNotification({Name = "Success", Text = "Speed set to 200", Time = 2})
    end    
})

-- 5. Autofarm Button (Placeholder)
MainTab:AddButton({
    Name = "Autofarm (ON)",
    Callback = function()
        print("Autofarm started!")
        OrionLib:MakeNotification({Name = "Status", Text = "Autofarm enabled (test)", Time = 2})
    end    
})

-- Initialize
OrionLib:Init()
