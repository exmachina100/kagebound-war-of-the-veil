-- Run in Roblox Studio SERVER Command Bar during a Play test.
-- Behavior contract written BEFORE the class/loadout implementation.
local S=game:GetService("ReplicatedStorage"):WaitForChild("KageboundShared")
local Rules=require(S:WaitForChild("ClassRules"))
local function check(label,value)
    assert(value,"[KAGEBOUND CLASS FAIL] "..label)
    print("[KAGEBOUND CLASS PASS] "..label)
end
check("Four original warrior styles",#Rules.Order==4)
for _,name in ipairs({"Shinobi","Ronin","Onmyoji","Oni Disciple"}) do
    local rule=Rules.Get(name)
    check(name.." registered",rule and rule.WalkSpeed>0 and rule.Cooldown>=8)
    check(name.." unique active",rule and type(rule.Ability)=="string" and #rule.Ability>0)
end
check("Unknown class rejected",Rules.Get("OnePieceFruit")==nil and not Rules.IsValid("OnePieceFruit"))
check("Shinobi mobility advantage",Rules.Get("Shinobi").WalkSpeed>Rules.Get("Oni Disciple").WalkSpeed)
check("Ronin guard window bounded",Rules.Get("Ronin").GuardSeconds>=.4 and Rules.Get("Ronin").GuardSeconds<=1.2)
check("Oni armor window bounded",Rules.Get("Oni Disciple").ArmorSeconds<=3 and Rules.Get("Oni Disciple").DamageReduction<=.6)
check("Onmyoji seal has bounded radius",Rules.Get("Onmyoji").SealRadius<=13 and Rules.Get("Onmyoji").SealSlowSeconds<=2)
check("No permanent weapon lock",Rules.WeaponLock==false)
print("[KAGEBOUND CLASS] Rules validated. Run 2-player loadout and ability QA separately.")
