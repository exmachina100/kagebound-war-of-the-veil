-- KAGEBOUND original mythic-mask policy; all server-authoritative.
-- Source: docs/GAME_DESIGN.md (Kitsune illusion / Oni knockback / Tengu wind).
local Rules = {}
Rules.Order = {"Kitsune","Oni","Tengu"}
Rules.Kitsune={Cooldown=14,Lifetime=3.5}
Rules.Oni={Cooldown=16,Radius=12,Damage=15,Knockback=65,UpwardSpeed=16}
Rules.Tengu={Cooldown=12,ForwardSpeed=52,UpwardSpeed=38}
Rules.SelectDistance=260 -- must be within Kage Dojo safe-hub radius 290
function Rules.IsValid(name)
    return typeof(name)=="string" and table.find(Rules.Order,name)~=nil
end
return Rules
