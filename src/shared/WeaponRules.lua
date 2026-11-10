-- KAGEBOUND weapon policy v0.1. Original design: eight primary archetypes.
-- Pure shared definitions; only trusted server code may apply these values.
local Rules={}
Rules.Default="Katana"
Rules.Order={"Katana","Nodachi","Tanto","Naginata","Yari","Kanabo","Kusarigama","Yumi"}
Rules.SelectionRadius=260
Rules.Weapons={
    Katana={kind="Sword",light={12,13,16},heavy=25,reach=7,lightCooldown=.34,heavyCooldown=1.1,windup=.13,stamina=12,guardBreak=true,implemented=true},
    Nodachi={kind="Sword",light={17,19,21},heavy=32,reach=9.5,lightCooldown=.62,heavyCooldown=1.55,windup=.28,stamina=19,guardBreak=true,implemented=false},
    Tanto={kind="Sword",light={8,9,11},heavy=18,reach=4.5,lightCooldown=.22,heavyCooldown=.85,windup=.08,stamina=8,guardBreak=false,implemented=false},
    Naginata={kind="Polearm",implemented=false},
    Yari={kind="Polearm",implemented=false},
    Kanabo={kind="Heavy",implemented=false},
    Kusarigama={kind="Flexible",implemented=false},
    Yumi={kind="Ranged",implemented=false}
}
function Rules.Get(name)
    if typeof(name)~="string" then return nil end
    return Rules.Weapons[name]
end
function Rules.CanSelect(name)
    local weapon=Rules.Get(name)
    -- Never grant unfinished archetypes a live combat advantage.
    return weapon~=nil and weapon.implemented==true
end
function Rules.ValidRequest(name)
    return typeof(name)=="string" and #name<=32 and Rules.Get(name)~=nil
end
return Rules
