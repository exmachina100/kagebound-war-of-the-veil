-- KAGEBOUND desktop input and light-weight prototype effects.
-- Mouse1 light, R heavy, F parry, Q dash. Server decides all damage.
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("KageboundCombat")
local localCooldown = {Light = 0, Heavy = 0, Parry = 0, Dash = 0}
local delays = {Light = 0.34, Heavy = 1.05, Parry = 1.3, Dash = 1.7}
local function send(action, payload)
    local now = os.clock()
    if now < localCooldown[action] then return end
    localCooldown[action] = now + delays[action]
    remote:FireServer(action, payload)
end
local function getRoot(target)
    local char = target and target.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end
UIS.InputBegan:Connect(function(input, processed)
    if processed or UIS:GetFocusedTextBox() then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        send("Light")
    elseif input.KeyCode == Enum.KeyCode.R then
        send("Heavy")
    elseif input.KeyCode == Enum.KeyCode.F then
        send("Parry")
    elseif input.KeyCode == Enum.KeyCode.Q then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = getRoot(player)
        if not root then return end
        local dir = hum and hum.MoveDirection or Vector3.zero
        if dir.Magnitude < 0.1 then dir = root.CFrame.LookVector end
        send("Dash", dir)
    end
end)
local gui = Instance.new("ScreenGui")
gui.Name = "KageboundCombatHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")
local label = Instance.new("TextLabel")
label.Name = "Controls"
label.Size = UDim2.new(0, 390, 0, 68)
label.Position = UDim2.new(0.5, -195, 1, -84)
label.BackgroundColor3 = Color3.fromRGB(19, 20, 32)
label.BackgroundTransparency = 0.2
label.TextColor3 = Color3.fromRGB(240, 232, 226)
label.Font = Enum.Font.GothamBold
label.TextSize = 15
label.Text = "KAGEBOUND | Mouse1: Combo  •  R: Heavy\nF: Parry  •  Q: Directional Dash"
label.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = label

local function pulseAt(pos, color, size)
    local fx = Instance.new("Part")
    fx.Name = "KageboundLocalFX"
    fx.Shape = Enum.PartType.Ball
    fx.Material = Enum.Material.Neon
    fx.Color = color
    fx.Size = Vector3.new(1, 1, 1) * size
    fx.Position = pos
    fx.Anchored = true
    fx.CanCollide = false
    fx.CanTouch = false
    fx.CanQuery = false
    fx.Transparency = 0.3
    fx.Parent = workspace
    TweenService:Create(fx, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {
        Size = Vector3.new(1, 1, 1) * size * 2.5,
        Transparency = 1
    }):Play()
    Debris:AddItem(fx, 0.33)
end
remote.OnClientEvent:Connect(function(event, actor, arg1, arg2)
    local root = getRoot(actor)
    if not root then return end
    if event == "Swing" then
        pulseAt(root.Position + root.CFrame.LookVector * 4 + Vector3.new(0, 2, 0), arg1 == "Heavy" and Color3.fromRGB(255, 55, 105) or Color3.fromRGB(255, 107, 130), 1.9)
    elseif event == "ParryStart" then
        pulseAt(root.Position + Vector3.new(0, 2.5, 0), Color3.fromRGB(65, 170, 255), 2)
    elseif event == "DashFX" then
        pulseAt(root.Position, Color3.fromRGB(193, 117, 235), 1.6)
    elseif event == "Parried" then
        pulseAt(root.Position + Vector3.new(0, 2.5, 0), Color3.fromRGB(105, 220, 255), 3.5)
    elseif event == "Hit" then
        pulseAt(root.Position + Vector3.new(0, 2, 0), Color3.fromRGB(255, 196, 92), 2.4)
    end
end)
print("[KAGEBOUND] Shinobi combat controls ready")
