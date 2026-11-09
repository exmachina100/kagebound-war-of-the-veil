-- KAGEBOUND mythic mask ability service — original Oni and Tengu actives.
-- Kitsune remains in Kitsune.server.lua; this service owns mask selection.
-- Server validates loadout, duel phase, hub safety, target eligibility and cooldown.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Shared=ReplicatedStorage:WaitForChild("KageboundShared")
local MaskRules=require(Shared:WaitForChild("MaskRules"))
local World=require(Shared:WaitForChild("WorldConfig"))
local DuelAuthority=require(script.Parent:WaitForChild("DuelService"))

local remote=ReplicatedStorage:FindFirstChild("KageboundMask")
if not remote then
    remote=Instance.new("RemoteEvent")
    remote.Name="KageboundMask"
    remote.Parent=ReplicatedStorage
end

local state={} -- session-only, server-owned cooldowns by player/mask
local function alive(player)
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if hum and root and hum.Health>0 then return char,hum,root end
end

local function inSafeHub(position)
    if not World.Enabled then return false end
    for _,zone in ipairs(World.Zones) do
        if zone.kind=="SafeHub" then
            local vec=Vector2.new(position.X-zone.x,position.Z-zone.z)
            if vec.Magnitude<=zone.radius then return true end
        end
    end
    return false
end

local function canSelect(player)
    if DuelAuthority.IsParticipant(player) then return false end
    local _,_,root=alive(player)
    if not root then return false end
    local dojo=World.Zones[1]
    local planar=Vector2.new(root.Position.X-dojo.x,root.Position.Z-dojo.z)
    return planar.Magnitude<=MaskRules.SelectDistance
end

local function hasLineOfSight(charA,charB,a,b)
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={charA,charB}
    params.RespectCanCollide=true
    return workspace:Raycast(a,b-a,params)==nil
end

local function oniBurst(player,char,root)
    if inSafeHub(root.Position) then return false end
    local rules=MaskRules.Oni
    for _,opponent in ipairs(Players:GetPlayers()) do
        if opponent~=player and DuelAuthority.CanDamage(player,opponent) then
            local targetChar,targetHum,targetRoot=alive(opponent)
            if targetRoot and not inSafeHub(targetRoot.Position) then
                local displacement=targetRoot.Position-root.Position
                local horizontal=Vector3.new(displacement.X,0,displacement.Z)
                if horizontal.Magnitude>=.1 and horizontal.Magnitude<=rules.Radius
                    and hasLineOfSight(char,targetChar,root.Position+Vector3.new(0,1,0),
                        targetRoot.Position+Vector3.new(0,1,0)) then
                    targetHum:TakeDamage(rules.Damage)
                    targetRoot.AssemblyLinearVelocity=horizontal.Unit*rules.Knockback
                        +Vector3.new(0,rules.UpwardSpeed,0)
                end
            end
        end
    end
    remote:FireAllClients("OniFX",player)
    return true
end

local function tenguWind(player,root)
    local rules=MaskRules.Tengu
    local face=Vector3.new(root.CFrame.LookVector.X,0,root.CFrame.LookVector.Z)
    if face.Magnitude<=.1 then return false end
    root.AssemblyLinearVelocity=face.Unit*rules.ForwardSpeed
        +Vector3.new(0,rules.UpwardSpeed,0)
    remote:FireAllClients("TenguFX",player)
    return true
end

local function cast(player)
    if not DuelAuthority.CanAct(player) then return end
    local char,_,root=alive(player)
    if not root then return end
    local mask=player:GetAttribute("KageboundMask")
    if mask~="Oni" and mask~="Tengu" then return end
    local now=os.clock()
    local record=state[player]
    if not record then return end
    local rules=MaskRules[mask]
    if now-(record[mask] or -math.huge)<rules.Cooldown then return end
    local ok
    if mask=="Oni" then ok=oniBurst(player,char,root)
    else ok=tenguWind(player,root) end
    if not ok then return end
    record[mask]=now
    remote:FireClient(player,"Cooldown",{mask=mask,seconds=rules.Cooldown})
end

remote.OnServerEvent:Connect(function(player,action,selected)
    if action=="Select" then
        if not MaskRules.IsValid(selected) or not canSelect(player) then return end
        player:SetAttribute("KageboundMask",selected)
        remote:FireClient(player,"Selected",{mask=selected})
    elseif action=="Cast" then
        cast(player)
    end
end)

local function register(player)
    state[player]={}
    if not MaskRules.IsValid(player:GetAttribute("KageboundMask")) then
        player:SetAttribute("KageboundMask","Kitsune")
    end
end
Players.PlayerAdded:Connect(register)
for _,player in ipairs(Players:GetPlayers()) do register(player) end
Players.PlayerRemoving:Connect(function(player) state[player]=nil end)
print("[KAGEBOUND] Three mythic masks: Kitsune selection, Oni burst, Tengu wind ready")
