-- KAGEBOUND Kitsune decoy event listener.
-- Input and mask selection are centralized in MaskHUD.client.lua.
-- Keep this listener independent of action authority.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local event=ReplicatedStorage:WaitForChild("KageboundKitsune")
event.OnClientEvent:Connect(function(action,caster)
    if action=="Cast" and caster==player then
        print("[KAGEBOUND] Kitsune decoy deployed (server-authorized)")
    end
end)
