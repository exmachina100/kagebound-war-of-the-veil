-- Paste into the ROBLOX STUDIO Command Bar *while the game is running*,
-- or run from a temporary Studio test script. Not mounted by Rojo.
local Rules = require(game.ReplicatedStorage.KageboundShared.CombatRules)
local function approx(a,b)
    return math.abs(a-b) < 1e-6
end
local function check(name, predicate)
    assert(predicate, "[KAGEBOUND CHECK FAIL] "..name)
    print("[KAGEBOUND CHECK PASS] "..name)
end
check("Three-step combo", Rules.NextCombo(0,0)==1 and Rules.NextCombo(1,.4)==2 and Rules.NextCombo(2,.4)==3)
check("Combo wraps", Rules.NextCombo(3,.4)==1)
check("Combo resets after timeout", Rules.NextCombo(2,1.2)==1)
check("Server stamina cost", Rules.CanSpend(7,"Light") and not Rules.CanSpend(6,"Light"))
check("Unknown action rejected", not Rules.CanSpend(100,"Hacker"))
check("Wind-up configured", Rules.AttackTimeline.Light.windup>0 and Rules.AttackTimeline.Heavy.windup>Rules.AttackTimeline.Light.windup)
check("Active windows configured", Rules.AttackTimeline.Light.active>0 and Rules.AttackTimeline.Heavy.active>0)
check("Light total fits cooldown", Rules.AttackTimeline.Light.windup+Rules.AttackTimeline.Light.active+Rules.AttackTimeline.Light.recovery <= Rules.LightCooldown)
check("Sweep samples bounded", Rules.AttackSamples>=2 and Rules.AttackSamples<=5)
check("Double jump costs stamina", Rules.CanSpend(12,"DoubleJump") and not Rules.CanSpend(11,"DoubleJump"))
check("Double jump bounded impulse", Rules.DoubleJumpVelocity > 20 and Rules.DoubleJumpVelocity < 70)
check("Guard break is heavy only", Rules.HeavyBreaksParry == true)
print("[KAGEBOUND] Combat policy checks passed; still run the multiplayer functional test.")
