-- KAGEBOUND Clan Clash 2v2 Prototype | original Grand World team activity.
-- One isolated local-server team arena. No DataStore, ranks, clan rosters or rewards.
-- All queue, team assignment, HP totals, timers and scoring are server-owned.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local Shared=ReplicatedStorage:WaitForChild("KageboundShared")
local Rules=require(Shared:WaitForChild("ClanRules"))
local World=require(Shared:WaitForChild("WorldConfig"))
local Authority=require(script.Parent:WaitForChild("DuelService"))
local Queues=require(script.Parent:WaitForChild("QueueRegistry"))
local Veilfall=require(script.Parent:WaitForChild("DuelVeilfall"))
if not World.Enabled then return end

local event=ReplicatedStorage:FindFirstChild("KageboundClanClash")
if not event then
    event=Instance.new("RemoteEvent")
    event.Name="KageboundClanClash"
    event.Parent=ReplicatedStorage
end
local palette=World.Palette
local center=Rules.ArenaCenter
local waiting={}
local active=nil
local serial=0

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

local prior=Workspace:FindFirstChild("KageboundClanArena")
if prior then prior:Destroy() end
local arena=Instance.new("Model")
arena.Name="KageboundClanArena"
arena.Parent=Workspace
part(arena,"ClanFloor",Vector3.new(192,4,156),
    CFrame.new(center-Vector3.new(0,5,0)),palette.stone,true)
part(arena,"ClanSigil",Vector3.new(100,.14,74),
    CFrame.new(center-Vector3.new(0,2.9,0)),palette.spirit,false,Enum.Material.Neon)
for _,x in ipairs({-96,96}) do
    part(arena,"SideBarrier",Vector3.new(3,19,158),
        CFrame.new(center+Vector3.new(x,5,0)),palette.ink,true)
end
for _,z in ipairs({-78,78}) do
    part(arena,"EndBarrier",Vector3.new(195,19,3),
        CFrame.new(center+Vector3.new(0,5,z)),palette.ink,true)
end
for _,x in ipairs({-38,38}) do
    for _,z in ipairs({-25,25}) do
        part(arena,"Cover",Vector3.new(8,10,8),
            CFrame.new(center+Vector3.new(x,3,z)),palette.ink,true)
    end
end
local veilfall=Veilfall.new(arena,center,Rules,palette)
local kioskAt=Vector3.new(45,4,45)
local kiosk=part(Workspace,"KageboundClanKiosk",Vector3.new(8,7,2),
    CFrame.new(kioskAt),palette.ink,false,Enum.Material.Wood)
local prompt=Instance.new("ProximityPrompt")
prompt.Name="JoinClanClash"
prompt.ObjectText="CLAN CLASH — 2v2"
prompt.ActionText="Join Team Queue"
prompt.KeyboardKeyCode=Enum.KeyCode.E
prompt.HoldDuration=.5
prompt.MaxActivationDistance=15
prompt.RequiresLineOfSight=false
prompt.Parent=kiosk
local gui=Instance.new("SurfaceGui")
gui.Face=Enum.NormalId.Front
gui.CanvasSize=Vector2.new(512,256)
gui.Parent=kiosk
local title=Instance.new("TextLabel")
title.Size=UDim2.fromScale(1,1)
title.BackgroundTransparency=1
title.TextScaled=true
title.TextWrapped=true
title.Font=Enum.Font.GothamBold
title.TextColor3=palette.warm
title.Text="CLAN CLASH\n2v2 · FIRST TO THREE"
title.Parent=gui

local function live(p)
    return typeof(p)=="Instance" and p:IsA("Player") and p.Parent==Players
end
local function notify(p,kind,data)
    if live(p) then event:FireClient(p,kind,data or {}) end
end
local function participants(match)
    local out={}
    for _,p in ipairs(match.A) do table.insert(out,p) end
    for _,p in ipairs(match.B) do table.insert(out,p) end
    return out
end
local function broadcast(match,kind,data)
    for _,p in ipairs(participants(match)) do notify(p,kind,data) end
end
local function allLive(match)
    for _,p in ipairs(participants(match)) do
        if not live(p) then return false end
    end
    return true
end
local function teamOf(match,player)
    for _,p in ipairs(match.A) do if p==player then return "A" end end
    for _,p in ipairs(match.B) do if p==player then return "B" end end
end
local function phase(match,nextState)
    match.phase=nextState
    for _,p in ipairs(participants(match)) do
        Authority.SetPhase(p,match.id,nextState)
    end
end
local function removeWaiting(player)
    for i=#waiting,1,-1 do
        if waiting[i]==player then table.remove(waiting,i) end
    end
    Queues.Leave(player,"ClanClash")
end

local function spawnFrame(team,index)
    local side=team=="A" and -1 or 1
    local p=center+Vector3.new(side*Rules.SpawnOffset,0,
        index==1 and -13 or 13)
    return CFrame.lookAt(p,center)
end
local function resetCharacter(player,cf)
    if not live(player) then return nil end
    local ok,err=pcall(function() player:LoadCharacterAsync() end)
    if not ok then
        warn("[KAGEBOUND] Clan Clash reset failed",player.UserId,err)
        return nil
    end
    local char=player.Character
    local root=char and char:WaitForChild("HumanoidRootPart",10)
    local hum=char and char:WaitForChild("Humanoid",10)
    if not root or not hum or not live(player) then return nil end
    root.CFrame=cf
    root.AssemblyLinearVelocity=Vector3.zero
    hum.Health=hum.MaxHealth
    return hum
end
local function aliveAndHealth(match)
    local aliveA,aliveB,hpA,hpB=0,0,0,0
    for _,p in ipairs(match.A) do
        local hum=match.humanoids[p]
        if hum and hum.Parent and hum.Health>0 then
            aliveA+=1
            hpA+=hum.Health
        end
    end
    for _,p in ipairs(match.B) do
        local hum=match.humanoids[p]
        if hum and hum.Parent and hum.Health>0 then
            aliveB+=1
            hpB+=hum.Health
        end
    end
    return aliveA,aliveB,hpA,hpB
end

local function finish(match,winner,why)
    if match.finished then return end
    match.finished=true
    veilfall:Stop(participants(match))
    phase(match,"Finished")
    broadcast(match,"MatchEnd",{
        winner=winner,why=why or "Round limit",
        scoreA=match.scoreA,scoreB=match.scoreB
    })
    task.wait(4)
    for _,p in ipairs(participants(match)) do
        Authority.Clear(p,match.id)
        if live(p) then pcall(function() p:LoadCharacterAsync() end) end
    end
end

local function runMatch(match)
    for round=1,Rules.MaxRounds do
        if match.forfeit or not allLive(match) then break end
        phase(match,"Preparing")
        match.humanoids={}
        local failed=nil
        for _,team in ipairs({"A","B"}) do
            for index,p in ipairs(match[team]) do
                local hum=resetCharacter(p,spawnFrame(team,index))
                if not hum then failed=p break end
                match.humanoids[p]=hum
            end
            if failed then break end
        end
        if failed then match.forfeit=failed break end
        phase(match,"Countdown")
        for seconds=Rules.CountdownSeconds,1,-1 do
            broadcast(match,"Countdown",{
                round=round,seconds=seconds,scoreA=match.scoreA,scoreB=match.scoreB
            })
            task.wait(1)
            if match.forfeit or not allLive(match) then break end
        end
        if match.forfeit or not allLive(match) then break end
        phase(match,"Active")
        broadcast(match,"RoundStart",{
            round=round,seconds=Rules.RoundSeconds,
            scoreA=match.scoreA,scoreB=match.scoreB
        })
        veilfall:Start(participants(match),
            function()
                return active==match and not match.finished and not match.forfeit
                    and match.phase=="Active" and allLive(match)
            end,
            function(kind,data) broadcast(match,kind,data) end)
        local deadline=os.clock()+Rules.RoundSeconds
        repeat
            if match.forfeit or not allLive(match) then break end
            local aliveA,aliveB=aliveAndHealth(match)
            if aliveA==0 or aliveB==0 then break end
            for _,p in ipairs(participants(match)) do
                local char=p.Character
                local root=char and char:FindFirstChild("HumanoidRootPart")
                local hum=match.humanoids[p]
                if root and hum and hum.Health>0
                    and (root.Position-center).Magnitude>150 then
                    hum.Health=0 -- server-enforced escape / out-of-bounds KO
                end
            end
            task.wait(.2)
        until os.clock()>=deadline
        veilfall:Stop(participants(match))
        if match.forfeit or not allLive(match) then break end
        phase(match,"Intermission")
        local a,b,hpA,hpB=aliveAndHealth(match)
        local outcome=Rules.ResolveRound(a,b,hpA,hpB)
        if outcome=="A" then match.scoreA+=1
        elseif outcome=="B" then match.scoreB+=1 end
        broadcast(match,"RoundResult",{
            round=round,result=outcome,
            scoreA=match.scoreA,scoreB=match.scoreB
        })
        local winner=Rules.MatchWinner(match.scoreA,match.scoreB,round)
        if winner then finish(match,winner,"Best of five") return end
        task.wait(Rules.RoundBreakSeconds)
    end
    if match.forfeit or not allLive(match) then
        local forfeiter=match.forfeit
        if not forfeiter then
            for _,p in ipairs(participants(match)) do
                if not live(p) then forfeiter=p break end
            end
        end
        local losingTeam=teamOf(match,forfeiter)
        finish(match,losingTeam=="A" and "B" or "A","Forfeit or disconnect")
    else
        finish(match,Rules.MatchWinner(match.scoreA,match.scoreB,Rules.MaxRounds) or "Draw",
            "Round limit")
    end
end

local function tryMatch()
    if active or #waiting<Rules.RequiredPlayers then return end
    local picked={}
    while #waiting>0 and #picked<Rules.RequiredPlayers do
        local p=table.remove(waiting,1)
        Queues.Leave(p,"ClanClash")
        if live(p) and not Authority.IsParticipant(p) then
            table.insert(picked,p)
        end
    end
    if #picked<Rules.RequiredPlayers then
        for i=#picked,1,-1 do
            local p=picked[i]
            if Queues.Enter(p,"ClanClash") then table.insert(waiting,1,p) end
        end
        return
    end
    serial+=1
    local match={id="clan-"..serial,A={},B={},
        scoreA=0,scoreB=0,phase="Preparing",finished=false,humanoids={}}
    local assigned={}
    for i,p in ipairs(picked) do
        local team=i%2==1 and "A" or "B"
        if Authority.Assign(p,match.id,team) then
            table.insert(match[team],p)
            table.insert(assigned,p)
        else
            for _,previous in ipairs(assigned) do Authority.Clear(previous,match.id) end
            task.defer(tryMatch)
            return
        end
    end
    active=match
    broadcast(match,"MatchFound",{
        teamA={match.A[1].Name,match.A[2].Name},
        teamB={match.B[1].Name,match.B[2].Name}
    })
    task.spawn(function()
        local ok,err=pcall(runMatch,match)
        if not ok then
            warn("[KAGEBOUND] Clan Clash error:",err)
            finish(match,"Draw","Server error")
        end
        if active==match then active=nil end
        task.defer(tryMatch)
    end)
end

prompt.Triggered:Connect(function(player)
    local char=player.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root or (root.Position-kioskAt).Magnitude>18
        or Authority.IsParticipant(player) then return end
    if table.find(waiting,player) then
        removeWaiting(player)
        notify(player,"QueueCancelled")
        return
    end
    if not Queues.Enter(player,"ClanClash") then
        notify(player,"QueueBlocked")
        return
    end
    table.insert(waiting,player)
    notify(player,"Queued",{count=#waiting,need=Rules.RequiredPlayers})
    tryMatch()
end)

event.OnServerEvent:Connect(function(player,action)
    if action=="CancelQueue" and table.find(waiting,player) then
        removeWaiting(player)
        notify(player,"QueueCancelled")
    elseif action=="Forfeit" and active and teamOf(active,player) then
        active.forfeit=player
    end
end)
Players.PlayerRemoving:Connect(function(player)
    removeWaiting(player)
    if active and teamOf(active,player) then active.forfeit=player end
end)
print("[KAGEBOUND] Clan Clash 2v2 best-of-five team arena ready (Studio QA pending)")
