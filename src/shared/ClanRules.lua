-- KAGEBOUND Clan Clash: optional Grand World team arena prototype.
-- 2v2 supported now, future queue expansion to 3v3..5v5 after Studio testing.
local Rules={}
Rules.MinTeamSize=2
Rules.MaxTeamSize=5
Rules.TeamSize=2
Rules.RequiredPlayers=Rules.TeamSize*2
Rules.RoundSeconds=80
Rules.CountdownSeconds=3
Rules.RoundBreakSeconds=4
Rules.WinsRequired=3
Rules.MaxRounds=5
Rules.ArenaCenter=Vector3.new(2160,145,2090)
Rules.SpawnOffset=39
Rules.Veilfall={StartAt=24,WarningSeconds=6,ActiveSeconds=22,ClosingSeconds=6}

function Rules.ResolveRound(aliveA,aliveB,hpA,hpB)
    if aliveA<=0 and aliveB<=0 then return "Draw" end
    if aliveA<=0 then return "B" end
    if aliveB<=0 then return "A" end
    if math.abs(hpA-hpB)<.01 then return "Draw" end
    return hpA>hpB and "A" or "B"
end
function Rules.MatchWinner(scoreA,scoreB,roundsPlayed)
    if scoreA>=Rules.WinsRequired then return "A" end
    if scoreB>=Rules.WinsRequired then return "B" end
    if roundsPlayed>=Rules.MaxRounds then
        if scoreA==scoreB then return "Draw" end
        return scoreA>scoreB and "A" or "B"
    end
    return nil
end
return Rules
