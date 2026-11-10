-- KAGEBOUND server class loadouts: validate client requests and route to ClassService.
-- No client-provided damage, target, speed, cooldown or style attributes are trusted.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Classes=require(script.Parent:WaitForChild("ClassService"))
local evt=ReplicatedStorage:WaitForChild("KageboundClass")

evt.OnServerEvent:Connect(function(player,action,value)
    if action=="Select" then
        Classes.Select(player,value)
    elseif action=="Cast" then
        Classes.Cast(player)
    end
end)
print("[KAGEBOUND] Four warrior classes and class abilities online")
