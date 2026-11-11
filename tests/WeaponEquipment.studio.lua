-- Studio-only equipment security contract; run server-side after a player spawns.
local Players=game:GetService("Players")
local Authority=require(game:GetService("ServerScriptService"):WaitForChild("KageboundServer"):WaitForChild("WeaponAuthority"))
local player=Players:GetPlayers()[1]
assert(player,"Start a Studio play session before running this test")
local char=player.Character
assert(char,"Character must exist")
local active=Authority.Get(player)
local issued=Authority.GetIssuedTool(player,char)
assert(issued and issued:IsA("Tool"),"Server-issued tool must exist before equipment test")
local Weapons=require(game:GetService("ReplicatedStorage").KageboundShared.WeaponRules)
assert(Weapons.CanSelect(active),"Issued weapon must be a currently enabled archetype")
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
assert(Authority.GetIssuedTool(player,char)==issued,"Forged tool must not replace issued identity")
forged:Destroy()
if legitimate and legitimate.Parent then
    legitimate.Parent=char
    assert(Authority.IsEquipped(player,char,active),"Issued tool should regain authority when equipped")
end
print("WeaponEquipment forged-tool contract PASS; continue multiplayer QA")
