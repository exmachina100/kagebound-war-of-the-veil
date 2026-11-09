-- KAGEBOUND Shadow Duel 0.1: opt-in world activity, original best-of-five.
-- Studio test required. ONE local server arena, no inter-server matchmaking or rewards.
-- Grand World remains active; players return to Kage Dojo after results.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local Shared=ReplicatedStorage:WaitForChild("KageboundShared")
local Rules=require(Shared:WaitForChild("DuelRules"))
local World=require(Shared:WaitForChild("WorldConfig"))
local Authority=require(script.Parent:WaitForChild("DuelService"))
local Veilfall=require(script.Parent:WaitForChild("DuelVeilfall"))
if not World.Enabled then return end

local event=ReplicatedStorage:FindFirstChild("KageboundShadowDuel")
if not event then
    event=Instance.new("RemoteEvent")
    event.Name="KageboundShadowDuel"
    event.Parent=ReplicatedStorage
end

local queue={}
local active=nil
local serial=0
local palette=World.Palette
local center=Rules.ArenaCenter

local function part(parent,name,size,cf,color,collidable,material)
    local p=Instance.new("Part")
    p.Name=name
    p.Size=size
    p.CFrame=cf
    p.Color=color
    p.Material=material or Enum.Material.Slate
    p.Anchored=true
    p.CanCollide=collidable==true
    p.CanTouch=false
    p.CanQuery=collidable==true
    p.TopSurface=Enum.SurfaceType.Smooth
    p.BottomSurface=Enum.SurfaceType.Smooth
    p.Parent=parent
    return p
end

local previous=Workspace:FindFirstChild("KageboundShadowDuelArena")
if previous then previous:Destroy() end
local arena=Instance.new("Model")
arena.Name="KageboundShadowDuelArena"
arena.Parent=Workspace
part(arena,"DuelFloor",Vector3.new(146,4,138),
    CFrame.new(center-Vector3.new(0,5,0)),palette.stone,true)
part(arena,"DuelCenter",Vector3.new(74,.15,74),
    CFrame.new(center-Vector3.new(0,2.9,0)),palette.ink,false,Enum.Material.Neon)
for _,x in ipairs({-73,73}) do
    part(arena,"Barrier",Vector3.new(3,15,142),
        CFrame.new(center+Vector3.new(x,4,0)),palette.ink,true)
end
for _,z in ipairs({-69,69}) do
    part(arena,"Barrier",Vector3.new(148,15,3),
        CFrame.new(center+Vector3.new(0,4,z)),palette.ink,true)
end
for i=1,20 do
    local a=(i-1)*math.pi*2/20
    local b=i*math.pi*2/20
    local r=38
    local v=Vector3.new(math.cos(a)*r,0,math.sin(a)*r)
    local w=Vector3.new(math.cos(b)*r,0,math.sin(b)*r)
    local delta=w-v
    part(arena,"DuelSigil_"..i,Vector3.new(.28,.15,delta.Magnitude),
        CFrame.lookAt(center-Vector3.new(0,2.72,0)+(v+w)*.5,
            center-Vector3.new(0,2.72,0)+w),
        palette.spirit,false,Enum.Material.Neon)
end
local veilfall=Veilfall.new(arena,center,Rules,palette)
-- Kage Dojo: join booth is deliberately inside the safe hub; server checks distance.
local kioskPos=Vector3.new(-45,4,45)
local kiosk=part(Workspace,"KageboundDuelKiosk",Vector3.new(8,7,2),
    CFrame.new(kioskPos),palette.ink,false,Enum.Material.Wood)
local prompt=Instance.new("ProximityPrompt")
prompt.Name="JoinShadowDuel"
prompt.ActionText="Join 1v1 Queue"
prompt.ObjectText="SHADOW DUEL | Best of Five"
prompt.KeyboardKeyCode=Enum.KeyCode.E
prompt.HoldDuration=.5
prompt.RequiresLineOfSight=false
prompt.MaxActivationDistance=15
prompt.Parent=kiosk
local textGui=Instance.new("SurfaceGui")
textGui.Face=Enum.NormalId.Front
textGui.CanvasSize=Vector2.new(512,256)
textGui.Parent=kiosk
local title=Instance.new("TextLabel")
title.Size=UDim2.fromScale(1,1)
title.BackgroundTransparency=1
title.Font=Enum.Font.GothamBold
title.TextScaled=true
title.TextWrapped=true
title.TextColor3=palette.warm
title.Text="SHADOW DUEL\n1v1 · FIRST TO THREE"
title.Parent=textGui

local function notify(player,name,data)
    if player.Parent==Players then event:FireClient(player,name,data or {}) end
end
local function removeFromQueue(player)
    for i=#queue,1,-1 do
        if queue[i]==player then table.remove(queue,i) end
    end
end
local function live(player)
    return player and player.Parent==Players
end
local function pairAlive(match)
    return live(match.a) and live(match.b)
end
local function broadcast(match,kind,payload)
    notify(match.a,kind,payload)
    notify(match.b,kind,payload)
end
local function phase(match,name)
    match.phase=name
    Authority.SetPhase(match.a,match.id,name)
    Authority.SetPhase(match.b,match.id,name)
end
local function spawnFrame(side)
    local position=center+Vector3.new(side*Rules.SpawnOffset,0,0)
    return CFrame.lookAt(position,center)
end
local function readyCharacter(player,spawnCF)
    if not live(player) then return nil end
    local ok,err=pcall(function() player:LoadCharacterAsync() end)
    if not ok then
        warn("[KAGEBOUND] Shadow Duel character reset failed",player.UserId,err)
        return nil
    end
    local character=player.Character
    local root=character and character:WaitForChild("HumanoidRootPart",10)
    local hum=character and character:WaitForChild("Humanoid",10)
    if not root or not hum or not live(player) then return nil end
    root.CFrame=spawnCF
    root.AssemblyLinearVelocity=Vector3.zero
    hum.Health=hum.MaxHealth
    -- CharacterAdded also re-equips starter Veilblade from Veilblade.server.lua.
    return hum
end

local function finish(match,winner,reason)
    if match.finished then return end
    match.finished=true
    veilfall:Stop({match.a,match.b})
    phase(match,"Finished")
    local label
    if winner=="A" then label=match.a.Name
    elseif winner=="B" then label=match.b.Name
    else label="DRAW" end
    broadcast(match,"MatchEnd",{
        winner=winner, winnerName=label,reason=reason or "Result",
        scoreA=match.scoreA,scoreB=match.scoreB
    })
    task.wait(4)
    for _,p in ipairs({match.a,match.b}) do
        Authority.Clear(p,match.id)
        if live(p) then
            -- Deliberate safe-hub return, not a wilderness teleport.
            pcall(function() p:LoadCharacterAsync() end)
        end
    end
end

local function runMatch(match)
    for index=1,Rules.MaxRounds do
        if not pairAlive(match) or match.forfeit then break end
        match.round=index
        phase(match,"Preparing")
        local humA=readyCharacter(match.a,spawnFrame(-1))
        local humB=readyCharacter(match.b,spawnFrame(1))
        if not humA or not humB then
            match.forfeit=not humA and match.a or match.b
            break
        end
        phase(match,"Countdown")
        for remaining=Rules.CountdownSeconds,1,-1 do
            broadcast(match,"Countdown",{round=index,seconds=remaining,
                scoreA=match.scoreA,scoreB=match.scoreB})
            task.wait(1)
            if match.forfeit or not pairAlive(match) then break end
        end
        if match.forfeit or not pairAlive(match) then break end
        phase(match,"Active")
        broadcast(match,"RoundStart",{round=index,
            duration=Rules.RoundSeconds,scoreA=match.scoreA,scoreB=match.scoreB})
        veilfall:Start({match.a,match.b},
            function()
                return active==match and not match.finished and not match.forfeit
                    and match.phase=="Active" and pairAlive(match)
            end,
            function(kind,payload)
                broadcast(match,kind,payload)
            end)
        local deadline=os.clock()+Rules.RoundSeconds
        repeat
            if match.forfeit or not pairAlive(match) then break end
            if humA.Health<=0 or humB.Health<=0 then break end
            task.wait(.15)
        until os.clock()>=deadline
        veilfall:Stop({match.a,match.b})
        if match.forfeit or not pairAlive(match) then break end
        phase(match,"Intermission")
        local result=Rules.ResolveRound(humA.Health,humB.Health)
        if result=="A" then match.scoreA+=1
        elseif result=="B" then match.scoreB+=1 end
        broadcast(match,"RoundResult",{
            round=index,result=result,scoreA=match.scoreA,scoreB=match.scoreB
        })
        local winner=Rules.MatchWinner(match.scoreA,match.scoreB,index)
        if winner then finish(match,winner,"Best of five") return end
        task.wait(Rules.RoundBreakSeconds)
    end
    if match.forfeit or not pairAlive(match) then
        local winner=(match.forfeit==match.a or not live(match.a)) and "B" or "A"
        finish(match,winner,"Forfeit or disconnect")
    else
        finish(match,Rules.MatchWinner(match.scoreA,match.scoreB,Rules.MaxRounds) or "Draw","Round limit")
    end
end

local function tryPair()
    if active then return end
    while #queue>=2 do
        local a=table.remove(queue,1)
        local b=table.remove(queue,1)
        if live(a) and live(b) and a~=b and not Authority.IsParticipant(a)
            and not Authority.IsParticipant(b) then
            serial+=1
            local id="duel-"..tostring(serial)
            if not Authority.Assign(a,id) then return end
            if not Authority.Assign(b,id) then
                Authority.Clear(a,id)
                return
            end
            local match={
                id=id,a=a,b=b,scoreA=0,scoreB=0,round=0,phase="Preparing",finished=false
            }
            active=match
            broadcast(match,"MatchFound",{opponentA=b.Name,opponentB=a.Name})
            task.spawn(function()
                local ok,err=pcall(runMatch,match)
                if not ok then
                    warn("[KAGEBOUND] Shadow Duel failed:",err)
                    finish(match,"Draw","Server error")
                end
                if active==match then active=nil end
                task.defer(tryPair)
            end)
            return
        end
    end
end

prompt.Triggered:Connect(function(player)
    local char=player.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root or (root.Position-kioskPos).Magnitude>18
        or Authority.IsParticipant(player) then return end
    if table.find(queue,player) then
        removeFromQueue(player)
        notify(player,"QueueCancelled")
        return
    end
    table.insert(queue,player)
    notify(player,"Queued",{position=#queue})
    tryPair()
end)

event.OnServerEvent:Connect(function(player,action)
    if action=="CancelQueue" then
        if table.find(queue,player) then
            removeFromQueue(player)
            notify(player,"QueueCancelled")
        end
    elseif action=="Forfeit" and active and (player==active.a or player==active.b) then
        active.forfeit=player
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeFromQueue(player)
    if active and (player==active.a or player==active.b) then
        active.forfeit=player
    end
end)
print("[KAGEBOUND] Shadow Duel 1v1 queue and five-round arena ready (ART-001/004)")
