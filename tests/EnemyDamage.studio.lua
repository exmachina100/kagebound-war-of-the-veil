-- KAGEBOUND enemy damage policy contract — run in Studio SERVER Command Bar.
-- Written before refactoring sword and Oni mask to use the same resolver.
local Service=require(game.ServerScriptService.KageboundServer:WaitForChild("EnemyDamage"))
local function check(label,predicate)
    assert(predicate,"[KAGEBOUND ENEMY DAMAGE FAIL] "..label)
    print("[KAGEBOUND ENEMY DAMAGE PASS] "..label)
end
check("Valid sword strike",Service.IsValidHit(9,110,18,11))
check("Valid Oni pulse",Service.IsValidHit(12,110,15,12))
check("Reject distant strike",not Service.IsValidHit(35,110,15,12))
check("Reject dead enemy",not Service.IsValidHit(3,0,12,9))
check("Reject negative and zero damage",not Service.IsValidHit(3,100,0,9) and not Service.IsValidHit(3,100,-1,9))
check("Reject huge damage",not Service.IsValidHit(3,100,5000,9))
check("Reject NaN",not Service.IsValidHit(0/0,100,10,12))
check("Reject excessive attack range",not Service.IsValidHit(2,100,10,999))
print("[KAGEBOUND] Enemy damage policy contract complete; multiplayer / reward test remains required.")
