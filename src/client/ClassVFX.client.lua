-- KAGEBOUND original class-ability VFX; presentation only.
-- All casts/defense events originate in ClassService on the server.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Shared=ReplicatedStorage:WaitForChild("KageboundShared")
local Profiles=require(Shared:WaitForChild("VFXProfiles"))
local Factory=require(script.Parent:WaitForChild("VFXFactory"))
local remote=ReplicatedStorage:WaitForChild("KageboundClass")

remote.OnClientEvent:Connect(function(event,player,style,at)
    if event~="AbilityFX" and event~="DefenseFX" then return end
    local root=Factory.Root(player)
    if not Factory.Visible(root) then return end
    if event=="DefenseFX" then
        if style=="Ronin" then
            Factory.Parry(root,Profiles.Get("Ronin"),true)
        elseif style=="RoninBroken" then
            Factory.Impact(root,Profiles.Get("Oni Disciple"),4)
        elseif style=="Oni Disciple" then
            Factory.Ring(root,3.1,1.2,Profiles.Get("Oni Disciple").edge,
                "FX_Class_IronResolve",nil,.32)
        end
    elseif style=="Shinobi" then
        Factory.Ring(root,2.4,.2,Profiles.Get("Shinobi").edge,
            "FX_Class_ShadowSlip",nil,.26)
        Factory.Spokes(root,9,4.2,1.2,Profiles.Get("Shinobi").core,
            "FX_Class_FoxRibbon",.27)
    elseif style=="Ronin" then
        Factory.Parry(root,Profiles.Get("Ronin"),false)
        Factory.Ring(root,3,1.1,Profiles.Get("Ronin").edge,
            "FX_Class_MoonGuard",nil,.42)
    elseif style=="Onmyoji" then
        -- VFXFactory.Seal and Spokes only require a positional origin;
        -- the seal is centered at the SERVER-supplied validated location.
        local origin={Position=typeof(at)=="Vector3" and at or root.Position}
        Factory.Seal(origin,Profiles.Get("Onmyoji"),.25,7,"FX_Class_OfudaSeal")
        Factory.Spokes(origin,12,7,1.7,Profiles.Get("Onmyoji").edge,
            "FX_Class_OfudaWard",.47)
    elseif style=="Oni Disciple" then
        Factory.Ring(root,4,.4,Profiles.Get("Oni Disciple").core,
            "FX_Class_IronResolve",nil,.5)
        Factory.Seal(root,Profiles.Get("Oni Disciple"),.7,3.3,
            "FX_Class_OniIronStance")
    end
end)
print("[KAGEBOUND] Class VFX bound to server-authored abilities")
