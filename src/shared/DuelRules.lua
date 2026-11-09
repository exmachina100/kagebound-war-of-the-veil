-- Original KAGEBOUND Shadow Duel rules — optional 1v1 Grand World activity.
-- Pure module, server uses these rules; no client-authoritative results.
local Rules={}
Rules.MaxRounds=5
Rules.WinsRequired=3
Rules.RoundSeconds=70
Rules.CountdownSeconds=3
Rules.RoundBreakSeconds=4
Rules.ArenaCenter=Vector3.new(1740,140,1720)
Rules.SpawnOffset=28
-- Predictable, per-round spectral routes. 20+6+18+6=50s within 70s round.
Rules.Veilfall={StartAt=20,WarningSeconds=6,ActiveSeconds=18,ClosingSeconds=6}

-- Health values are evaluated by the server only at round end.
function Rules.ResolveRound(healthA,healthB)
    if typeof(healthA)~="number" or typeof(healthB)~="number" then return "Draw" end
    if healthA<=0 and healthB<=0 then return "Draw" end
    if healthA<=0 then return "B" end
    if healthB<=0 then return "A" end
    if math.abs(healthA-healthB)<0.01 then return "Draw" end
    return healthA>healthB and "A" or "B"
end

function Rules.MatchWinner(winsA,winsB,roundsPlayed)
    if winsA>=Rules.WinsRequired then return "A" end
    if winsB>=Rules.WinsRequired then return "B" end
    if roundsPlayed>=Rules.MaxRounds then
        if winsA==winsB then return "Draw" end
        return winsA>winsB and "A" or "B"
    end
    return nil
end

return Rules
