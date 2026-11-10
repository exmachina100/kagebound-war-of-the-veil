-- Studio-only equipment security contract; run with two test clients.
local Players=game:GetService("Players")
local Authority=require(game:GetService("ServerScriptService"):WaitForChild("KageboundServer"):WaitForChild("WeaponAuthority"))
local player=Players:GetPlayers()[1]
assert(player,"Start a Studio play session before running this test")
local char=player.Character
assert(char,"Character must exist")
assert(Authority.Get(player)=="Katana","Starter weapon should be Katana")
local forged=Instance.new("Tool")
forged.Name="Veilblade"
local handle=Instance.new("Part")
handle.Name="Handle"
handle.Parent=forged
forged.Parent=char
assert(not Authority.IsEquipped(player,char,"Katana"),"Forged tool must not authorize damage")
forged:Destroy()
print("WeaponEquipment security contract: forged tools denied; continue with live spawn/selection QA")
