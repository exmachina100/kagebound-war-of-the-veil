-- Install temporarily in Studio, then launch ExecuteMultiplayerTestAsync(2,
-- {audit="KageboundCombatV1"}). Removed from Edit data model after the test.
local STS=game:GetService("StudioTestService")
local ok,args=pcall(function() return STS:GetTestArgs() end)
if not ok or type(args)~="table" or args.audit~="KageboundCombatV1" then return end
local Players=game:GetService("Players")
local results={}
local function record(name,pass,details)
    table.insert(results,{name=name,pass=pass,details=details})
    assert(pass,name..": "..tostring(details))
end
local command=Instance.new("RemoteEvent")
command.Name="KageboundCombatAuditCommand"
command.Parent=game.ReplicatedStorage
local ready={}
local observed={}
local sent={}
command.OnServerEvent:Connect(function(player,message,kind)
    if message=="Ready" then ready[player]=true end
    if message=="Observed" then
        observed[player]=observed[player] or {}
        table.insert(observed[player],kind)
    end
    if message=="Sent" then sent[player]=kind end
end)
local success,err=pcall(function()
    -- Child Studio processes can take over 40 seconds to bootstrap on a cold run.
    local deadline=os.clock()+90
    local players
    repeat
        players=Players:GetPlayers()
        if #players==2 and ready[players[1]] and ready[players[2]] then break end
        task.wait(.1)
    until os.clock()>deadline
    local readyCount=0
    for _ in pairs(ready) do readyCount+=1 end
    assert(#players==2 and ready[players[1]] and ready[players[2]],
        ("Two clients not ready: %d players, %d handshakes"):format(#players,readyCount))
    local a,b=players[1],players[2]
    for _,p in ipairs(players) do
        local char=p.Character or p.CharacterAdded:Wait()
        assert(char:WaitForChild("Veilblade",10),"Issued weapon not equipped")
        -- Early test players can spawn on the place's default spawn before the
        -- generated dojo is ready. Remove its temporary invulnerability so
        -- SafeHub and PvP assertions exercise combat rules, not ForceFields.
        for _,child in ipairs(char:GetChildren()) do
            if child:IsA("ForceField") then child:Destroy() end
        end
        local regen=char:FindFirstChild("Health")
        if regen and regen:IsA("Script") then regen.Disabled=true end
    end
    local rules=require(game.ReplicatedStorage.KageboundShared.CombatRules)
    local authority=require(game.ServerScriptService.KageboundServer.WeaponAuthority)
    record("Both clients have issued equipped weapons",
        authority.ActiveEquipped(a,a.Character)=="Katana" and authority.ActiveEquipped(b,b.Character)=="Katana",
        tostring(authority.ActiveEquipped(a,a.Character)).." / "..tostring(authority.ActiveEquipped(b,b.Character)))
    local sequence=0
    local function actions(plan)
        local at=workspace:GetServerTimeNow()+2
        local expected={}
        for _,item in ipairs(plan) do
            sequence+=1
            expected[item[1]]=sequence
            command:FireClient(item[1],item[2],sequence,at+(item[3] or 0))
        end
        local deadline=os.clock()+12
        repeat
            local all=true
            for p,id in pairs(expected) do if sent[p]~=id then all=false end end
            if all then task.wait(.6) return end
            task.wait(.05)
        until os.clock()>deadline
        error("Client combat command acknowledgement timed out")
    end
    local function position(x,z)
        a.Character:PivotTo(CFrame.lookAt(Vector3.new(x,6,z),Vector3.new(x,6,z+5)))
        b.Character:PivotTo(CFrame.lookAt(Vector3.new(x,6,z+5),Vector3.new(x,6,z)))
        a.Character.Humanoid.Health=100
        b.Character.Humanoid.Health=100
        -- Stabilize this authority/hitbox test independently of streamed ground
        -- arrival and client physics after large fixture teleports.
        a.Character.HumanoidRootPart.Anchored=true
        b.Character.HumanoidRootPart.Anchored=true
        task.wait(.5)
    end
    position(64,65)
    actions({{a,"Light"}})
    record("Training swing accepted by server",#(observed[a] or {})>=2,
        table.concat(observed[a] or {},","))
    record("SafeHub blocks player damage",b.Character.Humanoid.Health==100,b.Character.Humanoid.Health)
    record("Training does not award shards",a:GetAttribute("KageboundSpiritShards")==0,
        a:GetAttribute("KageboundSpiritShards"))
    -- Outside the 290-stud SafeHub, within the clients' already-loaded vicinity.
    -- Long teleports can pause headless clients for streaming and must be tested
    -- separately from this controlled combat authority contract.
    position(340,0)
    task.wait(1.1)
    actions({{a,"Light"}})
    local damage=100-b.Character.Humanoid.Health
    record("One PvP hit across active samples",damage==rules.LightDamage[1],
        ("damage=%s stamina=%s distance=%.2f events=%s"):format(damage,
            tostring(a:GetAttribute("KageboundStamina")),
            (a.Character.HumanoidRootPart.Position-b.Character.HumanoidRootPart.Position).Magnitude,
            table.concat(observed[a] or {},",")))
    task.wait(1.2)
    b.Character.Humanoid.Health=100
    actions({{b,"Parry",0},{a,"Light",.04}})
    record("Timed parry stops light damage",b.Character.Humanoid.Health==100,b.Character.Humanoid.Health)
    task.wait(1.5)
    b.Character.Humanoid.Health=100
    actions({{a,"Heavy",0},{b,"Parry",.15}})
    local heavyDamage=100-b.Character.Humanoid.Health
    record("Heavy breaks active parry",heavyDamage==rules.HeavyDamage,heavyDamage)
    record("Players keep isolated rewards",a:GetAttribute("KageboundSpiritShards")==0
        and b:GetAttribute("KageboundSpiritShards")==0,"No combat currency awards")
end)
command:Destroy()
STS:EndTest({pass=success,error=not success and tostring(err) or nil,checks=results})
