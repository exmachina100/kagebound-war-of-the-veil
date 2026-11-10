-- Run manually in Studio command bar after Rojo sync (not run in CI).
local Rules=require(game.ReplicatedStorage.KageboundShared.WeaponRules)
assert(#Rules.Order==8)
assert(Rules.Default=="Katana")
for _,name in ipairs(Rules.Order) do
    assert(Rules.Get(name)~=nil,name)
end
assert(Rules.CanSelect("Katana"))
assert(not Rules.CanSelect("Nodachi"))
assert(not Rules.CanSelect("Tanto"))
assert(not Rules.CanSelect("Yumi"))
assert(not Rules.CanSelect("Fake"))
assert(not Rules.ValidRequest({}))
assert(not Rules.ValidRequest(string.rep("x",100)))
assert(Rules.Get("Nodachi").reach>Rules.Get("Katana").reach)
assert(Rules.Get("Tanto").reach<Rules.Get("Katana").reach)
assert(Rules.Get("Tanto").lightCooldown<Rules.Get("Nodachi").lightCooldown)
print("WeaponRules Studio policy PASS (not a multiplayer combat test)")
