-- KAGEBOUND Combat VFX 0.5 — follows actual server combat events.
-- Four original warrior VFX identities are read from VFXProfiles and
-- the uploaded ART-001..004 / clan-vfx-v01 concept sheets.
-- All effects are client-only; gameplay is ALWAYS server-authoritative.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Shared=ReplicatedStorage:WaitForChild("KageboundShared")
local Profiles=require(Shared:WaitForChild("VFXProfiles"))
local Factory=require(script.Parent:WaitForChild("VFXFactory"))
local remote=ReplicatedStorage:WaitForChild("KageboundCombat")

local function profileFor(actor)
    if typeof(actor)=="Instance" and actor:IsA("Player") then
        return Profiles.Get(actor:GetAttribute("KageboundWarriorStyle"))
    end
    if typeof(actor)=="Instance" and actor:IsA("Model")
        and actor:GetAttribute("KageboundEnemy") then
        return Profiles.Get("Oni Disciple")
    end
    return Profiles.Get("Shinobi")
end

remote.OnClientEvent:Connect(function(event,actor,action,combo)
    local root=Factory.Root(actor)
    if not Factory.Visible(root) then return end
    local profile=profileFor(actor)
    if event=="Windup" then
        Factory.Windup(root,profile,action=="Heavy")
    elseif event=="Swing" then
        Factory.Slash(root,profile,action=="Heavy",combo)
    elseif event=="ParryStart" then
        Factory.Parry(root,profile,false)
    elseif event=="Parried" then
        Factory.Parry(root,profile,true)
    elseif event=="GuardBroken" then
        Factory.Impact(root,Profiles.Get("Oni Disciple"),4.4)
    elseif event=="DashFX" then
        Factory.Ring(root,2.6,.2,profile.edge,"FX004_Dash",nil,.28)
    elseif event=="DoubleJumpFX" then
        Factory.Tengu(root,Profiles.GetMask("Tengu"))
    elseif event=="Hit" or event=="HitTarget" then
        Factory.Impact(root,profile,event=="Hit" and 1.8 or 2.6)
    elseif event=="YokaiTelegraph" then
        Factory.Ring(root,5,.1,profile.core,"FX010_YokaiWarning",nil,.52)
    elseif event=="YokaiStrike" then
        Factory.Oni(root,profile)
    elseif event=="YokaiDefeated" then
        Factory.Seal(root,Profiles.Get("Onmyoji"),1.7,4.4,"FX010_YokaiDefeat")
    end
end)
print("[KAGEBOUND] Four-class combat VFX profiles online (render-only)")
