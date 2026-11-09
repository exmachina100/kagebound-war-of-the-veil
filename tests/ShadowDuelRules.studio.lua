-- KAGEBOUND Shadow Duel policy contract.
-- Execute in Roblox Studio SERVER Command Bar during a Play test.
local Rules=require(game.ReplicatedStorage.KageboundShared:WaitForChild("DuelRules"))
local function check(label,value)
    assert(value,"[KAGEBOUND DUEL FAIL] "..label)
    print("[KAGEBOUND DUEL PASS] "..label)
end
check("Best of five is first to three",Rules.MaxRounds==5 and Rules.WinsRequired==3)
check("Round duration bounded",Rules.RoundSeconds>=40 and Rules.RoundSeconds<=120)
check("Countdown minimum",Rules.CountdownSeconds>=2)
check("KO resolves",Rules.ResolveRound(0,60)=="B" and Rules.ResolveRound(100,0)=="A")
check("Simultaneous KO draws",Rules.ResolveRound(0,0)=="Draw")
check("Time health lead resolves",Rules.ResolveRound(38,50)=="B")
check("Tied health draws",Rules.ResolveRound(60,60)=="Draw")
check("Early victory",Rules.MatchWinner(3,1,3)=="A")
check("Five rounds score resolves",Rules.MatchWinner(2,1,5)=="A")
check("Five rounds tie is draw",Rules.MatchWinner(2,2,5)=="Draw")
check("Before game end no winner",Rules.MatchWinner(1,0,2)==nil)
print("[KAGEBOUND] Pure Shadow Duel rule checks ready; perform two-client gameplay QA.")
