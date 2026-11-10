-- KAGEBOUND Combat 0.3 controls (keyboard, mouse, gamepad, touch).
-- ContextActionService creates touch controls; all gameplay is server-authorized.
-- Cosmetic VFX live in CombatVFX.client.lua, not here (avoid double spawns).
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local Rules = require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("CombatRules"))
local remote = ReplicatedStorage:WaitForChild("KageboundCombat")
local localReady = {Light=0,Heavy=0,Parry=0,Dash=0,DoubleJump=0}
local delays = {
    Light=Rules.LightCooldown,
    Heavy=Rules.HeavyCooldown,
    Parry=Rules.ParryCooldown,
    Dash=Rules.DashCooldown,
    DoubleJump=Rules.DoubleJumpCooldown
}

local function request(action, payload)
    if action=="Light" or action=="Heavy" then
        local character=player.Character
        local tool=character and character:FindFirstChild("Veilblade")
        if not tool or not tool:IsA("Tool") then return end
    end
    local now = os.clock()
    if now < localReady[action] then return end
    localReady[action] = now + delays[action]
    remote:FireServer(action,payload)
end

local function directionForDash()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local move = hum and hum.MoveDirection or Vector3.zero
    return move.Magnitude > 0.1 and move or root.CFrame.LookVector
end

local actions = {
    KageboundLight = "Light",
    KageboundHeavy = "Heavy",
    KageboundParry = "Parry",
    KageboundDash = "Dash"
}

local function onAction(name, inputState)
    if inputState ~= Enum.UserInputState.Begin then return Enum.ContextActionResult.Pass end
    if UserInputService:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
    local action = actions[name]
    if not action then return Enum.ContextActionResult.Pass end
    if action=="Dash" then
        local direction = directionForDash()
        if direction then request("Dash",direction) end
    else
        request(action)
    end
    return Enum.ContextActionResult.Sink
end

ContextActionService:BindAction("KageboundLight",onAction,true,
    Enum.UserInputType.MouseButton1,Enum.KeyCode.ButtonR2)
ContextActionService:BindAction("KageboundHeavy",onAction,true,
    Enum.KeyCode.R,Enum.KeyCode.ButtonX)
ContextActionService:BindAction("KageboundParry",onAction,true,
    Enum.KeyCode.F,Enum.KeyCode.ButtonL2)
ContextActionService:BindAction("KageboundDash",onAction,true,
    Enum.KeyCode.Q,Enum.KeyCode.ButtonB)

-- SetTitle/SetPosition only affect auto-created touch buttons.
for name,title in pairs({
    KageboundLight="SLASH", KageboundHeavy="HEAVY",
    KageboundParry="PARRY", KageboundDash="DASH"
}) do
    ContextActionService:SetTitle(name,title)
end
ContextActionService:SetPosition("KageboundLight",UDim2.new(1,-85,1,-145))
ContextActionService:SetPosition("KageboundHeavy",UDim2.new(1,-168,1,-145))
ContextActionService:SetPosition("KageboundParry",UDim2.new(1,-168,1,-220))
ContextActionService:SetPosition("KageboundDash",UDim2.new(1,-85,1,-220))

-- JumpRequest handles mobile, keyboard and controller. Require a release
-- between the ground jump and the second jump to avoid hold-to-auto-double-jump.
local doubleJumpUsed=false
local jumpReleased=false
local function watchCharacter(char)
    doubleJumpUsed=false
    jumpReleased=false
    local hum=char:WaitForChild("Humanoid",8)
    if hum then
        hum.StateChanged:Connect(function(_,newState)
            if newState==Enum.HumanoidStateType.Landed
                or newState==Enum.HumanoidStateType.Running then
                doubleJumpUsed=false
            end
        end)
    end
end
player.CharacterAdded:Connect(watchCharacter)
if player.Character then task.spawn(watchCharacter,player.Character) end
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode==Enum.KeyCode.Space or input.KeyCode==Enum.KeyCode.ButtonA
        or input.UserInputType==Enum.UserInputType.Touch then
        jumpReleased=true
    end
end)
UserInputService.JumpRequest:Connect(function()
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum.FloorMaterial~=Enum.Material.Air then
        doubleJumpUsed=false
        jumpReleased=false
        return -- Roblox default jump handles the first press
    end
    if doubleJumpUsed or not jumpReleased then return end
    doubleJumpUsed=true
    jumpReleased=false
    request("DoubleJump")
end)

local gui = Instance.new("ScreenGui")
gui.Name = "KageboundCombatHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")
local label = Instance.new("TextLabel")
label.Name = "Controls"
label.AnchorPoint = Vector2.new(.5,1)
label.Size = UDim2.new(.78,0,0,60)
label.Position = UDim2.new(.5,0,1,-14)
label.BackgroundColor3 = Color3.fromRGB(19,20,32)
label.BackgroundTransparency = .15
label.TextColor3 = Color3.fromRGB(240,232,226)
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.TextWrapped = true
label.Text = "KAGEBOUND | Mouse1: Slash   R: Heavy   F: Parry\nQ: Dash   G: Mask   H: Style   Space: Double Jump"
label.Visible = not UserInputService.TouchEnabled
label.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,10)
corner.Parent = label
print("[KAGEBOUND] Cross-platform combat input ready (server-timed strikes)")
