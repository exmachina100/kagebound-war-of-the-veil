-- Integration check for a disposable single-player Studio server session.
-- Accept the Moonfall hunt through its board before running in a normal server
-- Script. This intentionally defeats three enemies and changes session rewards.
-- It does not test player sword input, combat balance or multiplayer attribution.
local RunService=game:GetService("RunService")
assert(RunService:IsStudio(),"Studio only")
local player=game.Players:GetPlayers()[1]
assert(player and player:GetAttribute("KageboundHuntStatus")=="Active",
    "Accept a fresh Moonfall hunt before running this check")
assert(#game.Players:GetPlayers()==1,"Use an isolated single-player test session")
local character=player.Character
assert(character and character:FindFirstChild("HumanoidRootPart"),"Character not ready")
local root=game.ServerScriptService.KageboundServer
local Damage=require(root.EnemyDamage)
local Rewards=require(root.RewardService)
local before=Rewards.Snapshot(player)
local original=character:GetPivot()
local enemies={}
for _,enemy in ipairs(workspace.KageboundEnemies:GetChildren()) do
    if enemy:IsA("Model") and enemy.PrimaryPart
        and (enemy:GetAttribute("Health") or 0)>0 then
        table.insert(enemies,enemy)
    end
end
assert(#enemies>=3,"Three live enemies required")
local ok,err=pcall(function()
    for i=1,3 do
        local enemy=enemies[i]
        character:PivotTo(enemy.PrimaryPart.CFrame*CFrame.new(0,2,5))
        while (enemy:GetAttribute("Health") or 0)>0 do
            assert(Damage.Apply(player,enemy,50,25,.2),"Controlled server hit rejected")
        end
    end
    character:PivotTo(original)
    local deadline=os.clock()+8
    while player:GetAttribute("KageboundHuntStatus")~="Completed"
        and os.clock()<deadline do task.wait(.1) end
    local after=Rewards.Snapshot(player)
    assert(player:GetAttribute("KageboundHuntStatus")=="Completed","Hunt did not finish")
    assert(player:GetAttribute("KageboundHuntProgress")==3,"Expected three hunt defeats")
    assert(after.yokaiDefeats-before.yokaiDefeats==3,"Expected three credited defeats")
    assert(after.shards-before.shards==43,"Expected 18 enemy shards plus 25 bounty shards")
    assert(after.mastery-before.mastery==12,"Expected 12 enemy mastery")
    assert(not Rewards.Award(player,"MoonfallHunt","MoonfallHuntV1"),"Duplicate bounty accepted")
    local duplicate=Rewards.Snapshot(player)
    assert(duplicate.shards==after.shards and duplicate.mastery==after.mastery,
        "Duplicate request changed rewards")
end)
if character.Parent then character:PivotTo(original) end
assert(ok,err)
print("[KAGEBOUND HUNT PASS] Three defeats, bounty completion and duplicate-receipt rejection")
