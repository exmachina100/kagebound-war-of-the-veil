-- KAGEBOUND Kitsune mask presentation; input handled in MaskHUD.client.lua.
-- Server owns clone placement, cooldown and decoy eligibility. Client FX only.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Shared=ReplicatedStorage:WaitForChild("KageboundShared")
local Profiles=require(Shared:WaitForChild("VFXProfiles"))
local Factory=require(script.Parent:WaitForChild("VFXFactory"))
local event=ReplicatedStorage:WaitForChild("KageboundKitsune")

event.OnClientEvent:Connect(function(action,caster)
    if action~="Cast" then return end
    local root=Factory.Root(caster)
    if not Factory.Visible(root) then return end
    Factory.Kitsune(root,Profiles.GetMask("Kitsune"))
end)
