-- KAGEBOUND four warrior loadout policy v0.1.
-- GAME_DESIGN.md: classes change tactic/movement, never lock main weapons.
-- All combat constants are enforced on the server; UI can only request.
local Rules={}
Rules.Order={"Shinobi","Ronin","Onmyoji","Oni Disciple"}
Rules.WeaponLock=false
Rules.SelectionRadius=260
Rules.Classes={
    Shinobi={
        Ability="Shadow Slip",Cooldown=11,WalkSpeed=18,
        SlipSpeed=78,SlipSeconds=.22
    },
    Ronin={
        Ability="Moon Guard",Cooldown=12,WalkSpeed=16,
        GuardSeconds=.7
    },
    Onmyoji={
        Ability="Ofuda Seal",Cooldown=15,WalkSpeed=16,
        SealRadius=10,SealCenterForward=10,
        SealSlowSeconds=1.2,SealSlowSpeed=8,SealNPCStagger=.6
    },
    ["Oni Disciple"]={
        Ability="Iron Resolve",Cooldown=15,WalkSpeed=14,
        ArmorSeconds=2.1,DamageReduction=.5
    }
}
function Rules.Get(name)
    return typeof(name)=="string" and Rules.Classes[name] or nil
end
function Rules.IsValid(name)
    return Rules.Get(name)~=nil
end
function Rules.ClampDamage(v)
    if typeof(v)~="number" or v~=v or v<=0 or v==math.huge then return 0 end
    return math.clamp(v,0,60)
end
return Rules
