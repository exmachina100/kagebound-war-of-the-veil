-- KAGEBOUND mythic mask VFX v0.5 — original FX-005/006/007.
-- ART-003 / vfx-v01 grand-scale boards are source direction. Render-only.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Shared=ReplicatedStorage:WaitForChild("KageboundShared")
local Profiles=require(Shared:WaitForChild("VFXProfiles"))
local Factory=require(script.Parent:WaitForChild("VFXFactory"))
local remote=ReplicatedStorage:WaitForChild("KageboundMask")

remote.OnClientEvent:Connect(function(event,actor)
    if event~="OniFX" and event~="TenguFX" and event~="OniImpactFX" then return end
    local root=Factory.Root(actor)
    if not Factory.Visible(root) then return end
    if event=="OniFX" then
        Factory.Oni(root,Profiles.GetMask("Oni"))
    elseif event=="OniImpactFX" then
        Factory.Impact(root,Profiles.GetMask("Oni"),3.2)
    elseif event=="TenguFX" then
        Factory.Tengu(root,Profiles.GetMask("Tengu"))
    end
end)
print("[KAGEBOUND] Grand-scale Oni/Tengu mask VFX online (cosmetic only)")
