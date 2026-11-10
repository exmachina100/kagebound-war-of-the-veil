-- KAGEBOUND: server-owned primary weapon selection, v0.2.
-- Only playable archetypes may be selected. No client-supplied stats or damage.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Shared=ReplicatedStorage:WaitForChild("KageboundShared")
local Weapons=require(Shared:WaitForChild("WeaponRules"))
local World=require(Shared:WaitForChild("WorldConfig"))
local Duel=require(script.Parent:WaitForChild("DuelService"))
local Queues=require(script.Parent:WaitForChild("QueueRegistry"))
local Authority=require(script.Parent:WaitForChild("WeaponAuthority"))
local remote=ReplicatedStorage:FindFirstChild("KageboundWeapon")
if not remote then
    remote=Instance.new("RemoteEvent")
    remote.Name="KageboundWeapon"
    remote.Parent=ReplicatedStorage
end
local lastRequest={}
local function canSelect(player)
    if player.Parent~=Players or Duel.IsParticipant(player)
        or Queues.Mode(player)~=nil then return false end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health<=0 or not root then return false end
    if os.clock()<(player:GetAttribute("KageboundCombatBusyUntil") or 0) then return false end
    local dojo=World.Zones[1]
    if not dojo or dojo.id~="KageDojo" then return false end
    local dx=root.Position.X-dojo.x
    local dz=root.Position.Z-dojo.z
    return dx*dx+dz*dz<=Weapons.SelectionRadius*Weapons.SelectionRadius
end
local function register(player)
    -- Attributes mirror server decisions; they are never accepted as authority.
    Authority.Reset(player)
end
remote.OnServerEvent:Connect(function(player,action,requested)
    if action~="Select" or not Weapons.ValidRequest(requested)
        or not Weapons.CanSelect(requested) then return end
    local now=os.clock()
    if now-(lastRequest[player] or -math.huge)<0.25 then return end
    lastRequest[player]=now
    if not canSelect(player) then return end
    local equipment=script.Parent:FindFirstChild("KageboundEquipWeapon")
    if not equipment or not equipment:IsA("BindableFunction") then return end
    local previous=Authority.Get(player)
    if not Authority.Select(player,requested) then return end
    local ok,success=pcall(function() return equipment:Invoke(player,requested) end)
    if not ok or not success then
        Authority.Select(player,previous)
        pcall(function() equipment:Invoke(player,previous) end)
        return
    end
    remote:FireClient(player,"Selected",requested)
end)
Players.PlayerAdded:Connect(register)
for _,player in ipairs(Players:GetPlayers()) do register(player) end
Players.PlayerRemoving:Connect(function(player) lastRequest[player]=nil end)
print("[KAGEBOUND] Server weapon selection with verified equipment handoff ready")
