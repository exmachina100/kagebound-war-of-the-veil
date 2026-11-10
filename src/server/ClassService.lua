-- KAGEBOUND WarriorStyle server service 0.1
-- Four distinct starter actives; selection is Dojo-only, locked in Shadow Duel.
-- Server is authoritative for style, cooldown, defense and target eligibility.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Shared=ReplicatedStorage:WaitForChild("KageboundShared")
local Rules=require(Shared:WaitForChild("ClassRules"))
local World=require(Shared:WaitForChild("WorldConfig"))
local Duel=require(script.Parent:WaitForChild("DuelService"))

local Service={}
local state={}
local remote=ReplicatedStorage:FindFirstChild("KageboundClass")
if not remote then
    remote=Instance.new("RemoteEvent")
    remote.Name="KageboundClass"
    remote.Parent=ReplicatedStorage
end

local function rig(player)
    local char=player.Character
    local humanoid=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if humanoid and root and humanoid.Health>0 then return char,humanoid,root end
end

local function inHub(pos,maxRadius)
    if not World.Enabled then return true end -- support legacy lobby mode
    for _,zone in ipairs(World.Zones) do
        if zone.kind=="SafeHub" then
            local delta=Vector2.new(pos.X-zone.x,pos.Z-zone.z)
            return delta.Magnitude<=math.min(maxRadius or zone.radius,zone.radius)
        end
    end
    return false
end

local function clearSlow(player,hum,token)
    local record=state[player]
    if not record or record.slowToken~=token then return end
    if not hum.Parent or hum.Health<=0 then return end
    local rule=Rules.Get(record.style)
    hum.WalkSpeed=rule and rule.WalkSpeed or 16
end

local function applyWalkSpeed(player)
    local record=state[player]
    local _,hum=rig(player)
    if not record or not hum then return end
    local rule=Rules.Get(record.style)
    if not rule then return end
    local now=os.clock()
    if record.slowUntil and record.slowUntil>now then
        hum.WalkSpeed=Rules.Get("Onmyoji").SealSlowSpeed
    else
        hum.WalkSpeed=rule.WalkSpeed
    end
end

local function initialize(player)
    if state[player] then return state[player] end
    local selected=player:GetAttribute("KageboundWarriorStyle")
    if not Rules.IsValid(selected) then selected="Shinobi" end
    state[player]={
        style=selected,cooldowns={},guardUntil=0,armorUntil=0,
        slowUntil=0,slowToken=0,globalCastAt=-math.huge,lastSelect=-math.huge
    }
    player:SetAttribute("KageboundWarriorStyle",selected)
    player:SetAttribute("KageboundClassBusyUntil",0)
    player:SetAttribute("KageboundClassCooldownUntil",0)
    player.CharacterAdded:Connect(function(character)
        local hum=character:WaitForChild("Humanoid",8)
        if hum and state[player] then
            state[player].guardUntil=0
            state[player].armorUntil=0
            state[player].slowUntil=0
            state[player].slowToken+=1
            player:SetAttribute("KageboundClassBusyUntil",0)
            applyWalkSpeed(player)
        end
    end)
    task.defer(applyWalkSpeed,player)
    return state[player]
end

function Service.GetStyle(player)
    local record=state[player]
    return record and record.style or "Shinobi"
end

function Service.Select(player,requested)
    local rule=Rules.Get(requested)
    if not rule or player.Parent~=Players or Duel.IsParticipant(player) then return false end
    local _,_,root=rig(player)
    if not root or not inHub(root.Position,Rules.SelectionRadius) then return false end
    local record=initialize(player)
    local now=os.clock()
    if now-record.lastSelect<.35 or now-record.globalCastAt<2 then return false end
    record.lastSelect=now
    record.style=requested
    record.guardUntil=0
    record.armorUntil=0
    player:SetAttribute("KageboundWarriorStyle",requested)
    applyWalkSpeed(player)
    remote:FireClient(player,"Selected",{style=requested})
    return true
end

local function unitDirection(root)
    local v=root.CFrame.LookVector
    local horizontal=Vector3.new(v.X,0,v.Z)
    if horizontal.Magnitude<.1 then return nil end
    return horizontal.Unit
end

local function lineClear(attacker,target,from,to)
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={attacker,target}
    params.RespectCanCollide=true
    return workspace:Raycast(from,to-from,params)==nil
end

local function slowTarget(target,seconds,speed)
    local record=initialize(target)
    local _,hum=rig(target)
    if not hum then return end
    local now=os.clock()
    record.slowUntil=math.max(record.slowUntil or 0,now+seconds)
    record.slowToken+=1
    local token=record.slowToken
    hum.WalkSpeed=speed
    task.delay(seconds+.03,function()
        local current=state[target]
        if current and current.slowToken==token and os.clock()>=current.slowUntil then
            clearSlow(target,hum,token)
        end
    end)
end

local function ofudaSeal(player,char,root,rule)
    local forward=unitDirection(root)
    if not forward then return false end
    local center=root.Position+forward*rule.SealCenterForward
    if not inHub(root.Position) then
        for _,target in ipairs(Players:GetPlayers()) do
            if target~=player and Duel.CanDamage(player,target) then
                local otherChar,_,otherRoot=rig(target)
                if otherRoot and not inHub(otherRoot.Position)
                    and (otherRoot.Position-center).Magnitude<=rule.SealRadius
                    and math.abs(otherRoot.Position.Y-center.Y)<=7
                    and lineClear(char,otherChar,root.Position+Vector3.new(0,1.3,0),
                        otherRoot.Position+Vector3.new(0,1.3,0)) then
                    slowTarget(target,rule.SealSlowSeconds,rule.SealSlowSpeed)
                end
            end
        end
        if not Duel.IsParticipant(player) then
            local enemies=workspace:FindFirstChild("KageboundEnemies")
            if enemies then
                for _,enemy in ipairs(enemies:GetChildren()) do
                    if enemy:IsA("Model") and enemy:GetAttribute("KageboundEnemy")==true
                        and enemy.PrimaryPart and (enemy:GetAttribute("Health") or 0)>0 then
                        local at=enemy.PrimaryPart.Position
                        if (at-center).Magnitude<=rule.SealRadius
                            and math.abs(at.Y-center.Y)<=7
                            and lineClear(char,enemy,root.Position+Vector3.new(0,1.3,0),
                                at+Vector3.new(0,1.3,0)) then
                            enemy:SetAttribute("StaggerUntil",
                                math.max(enemy:GetAttribute("StaggerUntil") or 0,
                                    os.clock()+rule.SealNPCStagger))
                        end
                    end
                end
            end
        end
    end
    remote:FireAllClients("AbilityFX",player,"Onmyoji",center)
    return true
end

function Service.Cast(player)
    local record=state[player]
    if not record or not Duel.CanAct(player) then return false end
    local char,hum,root=rig(player)
    if not root then return false end
    local rule=Rules.Get(record.style)
    if not rule then return false end
    local now=os.clock()
    if now<(player:GetAttribute("KageboundCombatBusyUntil") or 0)
        or now<(player:GetAttribute("KageboundClassBusyUntil") or 0)
        or now-(record.cooldowns[record.style] or -math.huge)<rule.Cooldown
        or now-record.globalCastAt<.5 then return false end
    local ok=false
    if record.style=="Shinobi" then
        local forward=unitDirection(root)
        if forward then
            root.AssemblyLinearVelocity=forward*rule.SlipSpeed
                +Vector3.new(0,math.max(0,root.AssemblyLinearVelocity.Y),0)
            remote:FireAllClients("AbilityFX",player,record.style,root.Position)
            ok=true
        end
    elseif record.style=="Ronin" then
        record.guardUntil=now+rule.GuardSeconds
        remote:FireAllClients("AbilityFX",player,record.style,root.Position)
        ok=true
    elseif record.style=="Onmyoji" then
        ok=ofudaSeal(player,char,root,rule)
    elseif record.style=="Oni Disciple" then
        record.armorUntil=now+rule.ArmorSeconds
        remote:FireAllClients("AbilityFX",player,record.style,root.Position)
        ok=true
    end
    if not ok then return false end
    record.globalCastAt=now
    record.cooldowns[record.style]=now
    player:SetAttribute("KageboundClassBusyUntil",now+.22)
    local untilTime=now+rule.Cooldown
    player:SetAttribute("KageboundClassCooldownUntil",untilTime)
    remote:FireClient(player,"Cooldown",{style=record.style,seconds=rule.Cooldown,ability=rule.Ability})
    return true
end

-- Call only from trusted server-authorized hit paths.
-- Returns actual damage, whether a frontal Ronin Moon Guard blocked it.
function Service.ResolveDefense(victim,attackerPosition,rawDamage,heavy)
    local amount=Rules.ClampDamage(rawDamage)
    local record=state[victim]
    if amount==0 or not record then return amount,false end
    local _,_,root=rig(victim)
    if not root then return amount,false end
    local now=os.clock()
    if record.style=="Ronin" and now<=record.guardUntil then
        local direction=attackerPosition-root.Position
        local horizontal=Vector3.new(direction.X,0,direction.Z)
        local forward=unitDirection(root)
        if forward and horizontal.Magnitude>.1
            and forward:Dot(horizontal.Unit)>=.25 then
            record.guardUntil=0 -- consumed by the first correctly faced attack
            if heavy then
                -- Heavy attacks still break a Ronin guard; consistent with
                -- the game's heavy-breaks-parry core combat rule.
                remote:FireAllClients("DefenseFX",victim,"RoninBroken",root.Position)
                return amount,false
            end
            remote:FireAllClients("DefenseFX",victim,"Ronin",root.Position)
            return 0,true
        end
    end
    if record.style=="Oni Disciple" and now<=record.armorUntil then
        amount=math.max(1,math.floor(amount*(1-Rules.Get("Oni Disciple").DamageReduction)+.5))
        remote:FireAllClients("DefenseFX",victim,"Oni Disciple",root.Position)
    end
    return amount,false
end

Players.PlayerAdded:Connect(initialize)
for _,player in ipairs(Players:GetPlayers()) do initialize(player) end
Players.PlayerRemoving:Connect(function(player) state[player]=nil end)
return Service
