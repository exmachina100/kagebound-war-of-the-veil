-- KAGEBOUND ClassService integration contract: Studio SERVER Command Bar only.
-- Run in a disposable Play session. This teleports the first tester to Dojo.
-- Requires at least one connected Player and a synchronized Grand World.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Classes=require(game.ServerScriptService.KageboundServer:WaitForChild("ClassService"))
local Duel=require(game.ServerScriptService.KageboundServer:WaitForChild("DuelService"))
local Rules=require(ReplicatedStorage.KageboundShared:WaitForChild("ClassRules"))
local player=Players:GetPlayers()[1]
assert(player,"Run with at least one Studio test client")
local char=player.Character or player.CharacterAdded:Wait()
local root=char:WaitForChild("HumanoidRootPart",8)
local hum=char:WaitForChild("Humanoid",8)
assert(root and hum,"Character root and humanoid required")
local startCf=root.CFrame
root.CFrame=CFrame.new(0,8,0)
local function check(label,condition)
    assert(condition,"[KAGEBOUND CLASS SERVICE FAIL] "..label)
    print("[KAGEBOUND CLASS SERVICE PASS] "..label)
end
local original=Classes.GetStyle(player)
check("Unknown style is rejected",Classes.Select(player,"Invalid_Ripoff")==false)
for i,name in ipairs(Rules.Order) do
    if i>1 then task.wait(.4) end
    check(name.." can be selected at Dojo",Classes.Select(player,name)==true)
    check(name.." held server-side",Classes.GetStyle(player)==name)
    check(name.." mirrored for VFX",player:GetAttribute("KageboundWarriorStyle")==name)
    check(name.." applies configured speed",hum.WalkSpeed==Rules.Get(name).WalkSpeed)
end
root.CFrame=CFrame.new(0,8,-780)
task.wait(.4)
check("Switching outside hub rejected",Classes.Select(player,"Shinobi")==false)
root.CFrame=CFrame.new(0,8,0)
task.wait(.4)
local id="qa-class-test-"..player.UserId
check("Duel can reserve player",Duel.Assign(player,id)==true)
check("Switching in preparing duel rejected",Classes.Select(player,"Shinobi")==false)
Duel.Clear(player,id)
task.wait(.4)
check("Session class restored",Classes.Select(player,original)==true)
root.CFrame=startCf
print("[KAGEBOUND] Class loadout contract complete. Test actual ability casts against two players separately.")
