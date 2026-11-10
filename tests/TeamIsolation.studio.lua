-- KAGEBOUND 2v2 and 1v1 team-authority contract.
-- Run ONLY in an isolated Studio SERVER Command Bar with 4 test players,
-- before joining any real queue. Automatically clears QA membership.
local Players=game:GetService("Players")
local Server=game:GetService("ServerScriptService").KageboundServer
local Authority=require(Server:WaitForChild("DuelService"))
local Queues=require(Server:WaitForChild("QueueRegistry"))
local players=Players:GetPlayers()
assert(#players>=4,"Use Test > Start with at least four player clients")
local a1,b1,a2,b2=players[1],players[2],players[3],players[4]
local id="qa-clan-"..tostring(math.floor(os.clock()*1000))
local function check(label,value)
    assert(value,"[KAGEBOUND TEAM QA FAIL] "..label)
    print("[KAGEBOUND TEAM QA PASS] "..label)
end
check("Can queue Shadow Duel",Queues.Enter(a1,"ShadowDuel"))
check("Cannot queue another mode simultaneously",not Queues.Enter(a1,"ClanClash"))
check("Cancel existing queue",Queues.Leave(a1,"ShadowDuel"))
check("Can queue Clan after cancel",Queues.Enter(a1,"ClanClash"))
check("Release Clan queue",Queues.Leave(a1,"ClanClash"))
local members={a1,b1,a2,b2}
local teams={"A","B","A","B"}
for i,p in ipairs(members) do
    check("Assign participant "..i,Authority.Assign(p,id,teams[i]))
    check("Mark active "..i,Authority.SetPhase(p,id,"Active"))
end
check("Cross-team attacks allowed",Authority.CanDamage(a1,b1) and Authority.CanDamage(a2,b2))
check("Friendly fire blocked",not Authority.CanDamage(a1,a2) and not Authority.CanDamage(b1,b2))
check("Self damage forbidden",not Authority.CanDamage(a1,a1))
check("Team is server mirrored",a1:GetAttribute("KageboundMatchTeam")=="A"
    and b1:GetAttribute("KageboundMatchTeam")=="B")
Authority.SetPhase(b1,id,"Intermission")
check("Inactive opponent cannot be damaged",not Authority.CanDamage(a1,b1))
for _,p in ipairs(members) do Authority.Clear(p,id) end
check("Team mirror cleared",a1:GetAttribute("KageboundMatchTeam")=="")
local legacy="qa-duel-"..id
check("Legacy duel A assigned",Authority.Assign(a1,legacy))
check("Legacy duel B assigned",Authority.Assign(b1,legacy))
Authority.SetPhase(a1,legacy,"Active")
Authority.SetPhase(b1,legacy,"Active")
check("Legacy 1v1 remains damageable",Authority.CanDamage(a1,b1))
Authority.Clear(a1,legacy)
Authority.Clear(b1,legacy)
print("[KAGEBOUND] Four-player team isolation contract passed. Test the actual match next.")
