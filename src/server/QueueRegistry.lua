-- KAGEBOUND server-only shared queue ownership.
-- Prevents entering Shadow Duel and Clan Clash at the same time.
local Players=game:GetService("Players")
local Registry={}
local waiting={}
function Registry.Enter(player,mode)
    if typeof(player)~="Instance" or not player:IsA("Player") or player.Parent~=Players then return false end
    if mode~="ShadowDuel" and mode~="ClanClash" then return false end
    if waiting[player] then return false end
    waiting[player]=mode
    return true
end
function Registry.Leave(player,mode)
    if not waiting[player] or (mode and waiting[player]~=mode) then return false end
    waiting[player]=nil
    return true
end
function Registry.Mode(player)
    return waiting[player]
end
Players.PlayerRemoving:Connect(function(player) waiting[player]=nil end)
return Registry
