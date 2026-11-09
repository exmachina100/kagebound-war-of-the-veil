-- KAGEBOUND disabled-by-default DataStore adapter check.
-- Run ONLY on the Studio SERVER Command Bar, with at least one player.
-- This never contacts real DataStores while Config.Enabled=false.
local shared=game.ReplicatedStorage.KageboundShared
local cfg=require(shared.PersistenceConfig)
local schema=require(shared.ProfileSchema)
local store=require(game.ServerScriptService.KageboundServer.ProfileStore)
local player=game.Players:GetPlayers()[1]
assert(player,"Start local Studio Play with at least one player.")
assert(cfg.Enabled==false,"Do NOT run this test in a persistent production place")
assert(store.IsEnabled()==false,"ProfileStore must be disabled by default")
local ok,reason=store.Load(player)
assert(not ok and reason=="persistence disabled","Load should stop without network")
local saved,saveReason=store.SaveEvents(player,{{source="LanternYokai",token="qa"}})
assert(not saved and saveReason=="persistence disabled","Write should stop without network")
local blank=schema.New()
assert(blank.shards==0 and blank.version==cfg.Version,"Schema/config version mismatch")
print("[KAGEBOUND PERSISTENCE GATE PASS] Disabled adapter never accesses live DataStore")
