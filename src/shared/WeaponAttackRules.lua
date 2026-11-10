-- Pure attack profiles: no client-provided damage, cooldown or hitbox data.
-- Unimplemented weapon profiles are for balancing/Studio testing only.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KageboundShared")
local Combat=require(Shared:WaitForChild("CombatRules"))
local Weapons=require(Shared:WaitForChild("WeaponRules"))
local Profiles={}
function Profiles.Resolve(name,heavy,combo)
    local weapon=Weapons.Get(name)
    if not weapon or (weapon.kind~="Sword" and weapon.kind~="Polearm") then return nil end
    if typeof(heavy)~="boolean" then return nil end
    if not heavy and (typeof(combo)~="number" or combo%1~=0 or combo<1 or combo>3) then return nil end
    local action=heavy and "Heavy" or "Light"
    local timeline=Combat.AttackTimeline[action]
    if name=="Katana" then
        return {
            damage=heavy and Combat.HeavyDamage or Combat.LightDamage[combo],
            range=heavy and Combat.HeavyRange or Combat.LightRange,
            cooldown=heavy and Combat.HeavyCooldown or Combat.LightCooldown,
            cost=Combat.ActionCost[action],
            windup=timeline.windup,active=timeline.active,recovery=timeline.recovery,
            width=timeline.width,height=timeline.height,
            guardBreak=heavy and Combat.HeavyBreaksParry or false,
        }
    end
    local windup=heavy and weapon.windup+0.15 or weapon.windup
    local width=weapon.kind=="Polearm" and (name=="Yari" and 4.5 or 7) or timeline.width
    return {
        damage=heavy and weapon.heavy or weapon.light[combo],
        range=weapon.reach,
        cooldown=heavy and weapon.heavyCooldown or weapon.lightCooldown,
        cost=heavy and weapon.stamina+9 or weapon.stamina,
        windup=windup,active=timeline.active,recovery=timeline.recovery,
        width=width,height=timeline.height,
        guardBreak=heavy and weapon.guardBreak or false,
    }
end
return Profiles
