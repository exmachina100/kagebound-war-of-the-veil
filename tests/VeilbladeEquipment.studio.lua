-- Studio SERVER Command Bar, inside disposable 2-player Play session.
-- Requires current KAGEBOUND scripts to have spawned and equipped the weapon.
local players=game:GetService("Players"):GetPlayers()
assert(#players>=1,"Need at least one player in Studio Play")
local combatRules=require(game.ReplicatedStorage.KageboundShared.CombatRules)
local function equipped(character)
    local tool=character and character:FindFirstChild("Veilblade")
    return tool and tool:IsA("Tool") and tool:FindFirstChild("Handle")~=nil
end
local function check(name,value)
    assert(value,"[KAGEBOUND WEAPON TEST FAIL] "..name)
    print("[KAGEBOUND WEAPON TEST PASS] "..name)
end
check("Weapon is equipped",equipped(players[1].Character) == true)
local tool=players[1].Character:FindFirstChild("Veilblade")
local edge=tool:FindFirstChild("BladeVeilEdge")
check("Blade edge exists",edge and edge:IsA("BasePart"))
local trail=edge and edge:FindFirstChild("VeilbladeTrail")
check("Trail exists and is default-off",trail and trail:IsA("Trail") and not trail.Enabled)
check("Trail attachment wiring",trail and trail.Attachment0 and trail.Attachment1)
check("Combat profile is still server-timed",combatRules.AttackTimeline.Light.windup>0)
print("[KAGEBOUND] Weapon visual checks passed; test unarmed attack manually as documented.")
