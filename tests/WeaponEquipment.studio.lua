-- Studio-only equipment security contract; run server-side after a player spawns.
local Players=game:GetService("Players")
local Authority=require(game:GetService("ServerScriptService"):WaitForChild("KageboundServer"):WaitForChild("WeaponAuthority"))
local player=Players:GetPlayers()[1]
assert(player,"Start a Studio play session before running this test")
local char=player.Character
assert(char,"Character must exist")
local active=Authority.Get(player)
assert(active=="Katana" or active=="Nodachi" or active=="Tanto")
local legitimate=char:FindFirstChild("Veilblade")
if legitimate then
    legitimate.Parent=player:WaitForChild("Backpack")
end
local forged=Instance.new("Tool")
forged.Name="Veilblade"
local handle=Instance.new("Part")
handle.Name="Handle"
handle.Parent=forged
forged.Parent=char
assert(not Authority.IsEquipped(player,char,active),"Forged tool must not authorize damage")
forged:Destroy()
if legitimate and legitimate.Parent then
    legitimate.Parent=char
    assert(Authority.IsEquipped(player,char,active),"Issued tool should regain authority when equipped")
end
print("WeaponEquipment forged-tool contract PASS; continue multiplayer QA")
