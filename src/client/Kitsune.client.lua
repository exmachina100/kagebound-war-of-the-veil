-- ART-003 Kitsune decoy prototype: key G / gamepad Y / touch FOX.
-- Server enforces cooldown and creates the non-damaging decoy.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local evt = ReplicatedStorage:WaitForChild("KageboundKitsune")
local player = Players.LocalPlayer
local lastRequested = -math.huge
local COOLDOWN = 14
local function cast(_, inputState)
    if inputState ~= Enum.UserInputState.Begin then return Enum.ContextActionResult.Pass end
    if UserInputService:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
    local now = os.clock()
    if now-lastRequested >= COOLDOWN then
        lastRequested = now
        evt:FireServer("Cast")
    end
    return Enum.ContextActionResult.Sink
end
ContextActionService:BindAction("KageboundKitsune",cast,true,Enum.KeyCode.G,Enum.KeyCode.ButtonY)
ContextActionService:SetTitle("KageboundKitsune","FOX")
ContextActionService:SetPosition("KageboundKitsune",UDim2.new(1,-255,1,-145))
evt.OnClientEvent:Connect(function(action,caster)
    if action=="Cast" and caster==player then
        print("[KAGEBOUND] Kitsune decoy deployed")
    end
end)
