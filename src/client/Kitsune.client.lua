-- Kitsune decoy action G, with ability-level local cooldown for basic HUD.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local evt=ReplicatedStorage:WaitForChild("KageboundKitsune")
local player=Players.LocalPlayer
local at=0
UIS.InputBegan:Connect(function(input,used)
    if used or UIS:GetFocusedTextBox() then return end
    if input.KeyCode==Enum.KeyCode.G then
        local now=os.clock()
        if now-at<14 then return end
        at=now
        evt:FireServer("Cast")
    end
end)
local hud=player:WaitForChild("PlayerGui"):WaitForChild("KageboundCombatHUD",15)
if hud then
    local label=hud:FindFirstChild("Controls")
    if label and label:IsA("TextLabel") then
        label.Text=label.Text.."  •  G: Kitsune Clone"
    end
end
evt.OnClientEvent:Connect(function(action,caster)
    if action=="Cast" and caster==player then
        print("[KAGEBOUND] Kitsune decoy deployed")
    end
end)
