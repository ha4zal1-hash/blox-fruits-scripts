local lp = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local f = Instance.new("Frame", gui)
f.Size, f.Position, f.Active, f.BackgroundColor3 = UDim2.new(0, 120, 0, 50), UDim2.new(0.5, -60, 0.4, -25), true, Color3.fromRGB(30,30,30)

local t = Instance.new("TextButton", f)
t.Size, t.Text, t.BackgroundColor3 = UDim2.new(1,0,1,0), "Speed: 200", Color3.fromRGB(0, 100, 0)
t.TextColor3 = Color3.new(1,1,1)

local hb = Instance.new("TextButton", gui)
hb.Size, hb.Position, hb.Text = UDim2.new(0,30,0,30), UDim2.new(0,10,0.5,-15), "👁️"

local en = true
RS.Heartbeat:Connect(function()
    if en and lp.Character then
        local root = lp.Character:FindFirstChild("HumanoidRootPart")
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if root and hum and hum.MoveDirection.Magnitude > 0 then
            root.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * 200, root.AssemblyLinearVelocity.Y, hum.MoveDirection.Z * 200)
        end
    end
end)

t.MouseButton1Click:Connect(function()
    en = not en
    t.Text = en and "Speed: 200" or "Speed: OFF"
    t.BackgroundColor3 = en and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
end)

hb.MouseButton1Click:Connect(function() f.Visible = not f.Visible end)

local drag, start, pos
f.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag, start, pos = true, i.Position, f.Position end
end)
UIS.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - start
        f.Position = UDim2.new(pos.X.Scale, pos.X.Offset + delta.X, pos.Y.Scale, pos.Y.Offset + delta.Y)
    end
    if i.UserInputState == Enum.UserInputState.End and i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)
