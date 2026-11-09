-- Studio Command Bar / ServerScriptService temporary test only.
-- Exercise fixed reward catalog and duplicate-award policy before testing world encounters.
local policy = require(game.ReplicatedStorage.KageboundShared.RewardPolicy)
local function check(label, condition)
    assert(condition, "[KAGEBOUND REWARD FAIL] "..label)
    print("[KAGEBOUND REWARD PASS] "..label)
end
check("Whispers quest reward",policy.Get("WhispersQuest").shards == 25)
check("Lantern Yokai reward",policy.Get("LanternYokai").shards == 6)
check("No unknown reward source", policy.Get("OtherGame") == nil)
check("Valid GUID-like encounter key", policy.ValidKey("encounter-123"))
check("Reject blank key", not policy.ValidKey(""))
check("Reject oversized key", not policy.ValidKey(string.rep("x",130)))
check("Bounded rewards",policy.Get("LanternYokai").mastery > 0 and policy.Get("LanternYokai").mastery <= 20)
print("[KAGEBOUND] Reward policy contract ready. Run 2-client kill and quest tests.")
