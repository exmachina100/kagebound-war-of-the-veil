-- Temporary fixture for StudioTestService; never mapped into production source.
-- Avoid client GetTestArgs, which has a documented engine limitation. This file
-- is installed only for the isolated session; the server owns the audit remote.
local command=game.ReplicatedStorage:WaitForChild("KageboundCombatAuditCommand",45)
if not command then return end
command.OnClientEvent:Connect(function(action,sequence,atTime)
    if atTime then task.wait(math.max(0,atTime-workspace:GetServerTimeNow())) end
    game.ReplicatedStorage.KageboundCombat:FireServer(action)
    command:FireServer("Sent",sequence)
end)
game.ReplicatedStorage.KageboundCombat.OnClientEvent:Connect(function(kind,actor)
    if actor==game.Players.LocalPlayer and (kind=="Windup" or kind=="Swing") then
        command:FireServer("Observed",kind)
    end
end)
command:FireServer("Ready")
