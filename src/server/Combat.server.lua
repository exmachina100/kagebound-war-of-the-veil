-- KAGEBOUND Combat 0.3 | original server-authored windup / active / recovery melee.
-- ART-001/003 drive VFX; hitboxes, damage, parry and stamina are never client-authored.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("KageboundShared")
local Rules = require(Shared:WaitForChild("CombatRules"))
local World = require(Shared:WaitForChild("WorldConfig"))
local DuelAuthority = require(script.Parent:WaitForChild("DuelService"))
local EnemyDamage = require(script.Parent:WaitForChild("EnemyDamage"))
local Classes = require(script.Parent:WaitForChild("ClassService"))
local WeaponAuthority = require(script.Parent:WaitForChild("WeaponAuthority"))
local WeaponAttacks = require(Shared:WaitForChild("WeaponAttackRules"))

local remote = ReplicatedStorage:FindFirstChild("KageboundCombat")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "KageboundCombat"
    remote.Parent = ReplicatedStorage
end

local state = {}

local function protectedHub(pos)
    if not World.Enabled then return false end
    for _, zone in ipairs(World.Zones) do
        if zone.kind == "SafeHub" then
            local offset = Vector2.new(pos.X-zone.x, pos.Z-zone.z)
            if offset.Magnitude <= zone.radius then return true end
        end
    end
    return false
end

local function inTrainingCircle(pos)
    if not World.Enabled or not World.TrainingGrounds then return false end
    local cfg=World.TrainingGrounds
    return (Vector2.new(pos.X-cfg.x,pos.Z-cfg.z)).Magnitude<=cfg.radius
end

local function canSwingAt(pos)
    return not protectedHub(pos) or inTrainingCircle(pos)
end

local function resetState(player)
    state[player] = {
        lightAt = -math.huge, heavyAt = -math.huge,
        attackReadyAt = -math.huge,
        parryAt = -math.huge, dashAt = -math.huge,
        comboAt = -math.huge, combo = 0,
        parryUntil = 0, busyUntil = 0, staggerUntil = 0,
        attackToken = 0, doubleJumpUsed = false, doubleJumpAt = -math.huge,
        stamina = Rules.MaxStamina, staminaAt = os.clock()
    }
    player:SetAttribute("KageboundStamina", Rules.MaxStamina)
    player:SetAttribute("KageboundParryUntil", 0)
    player:SetAttribute("KageboundCombatBusyUntil", 0)
end

local function markBusy(player,s,untilTime)
    s.busyUntil=untilTime
    player:SetAttribute("KageboundCombatBusyUntil",untilTime)
end

local function getState(player)
    if not state[player] then resetState(player) end
    return state[player]
end

local function updateStamina(player, s, now)
    local elapsed = math.clamp(now - s.staminaAt, 0, 1)
    s.stamina = math.min(Rules.MaxStamina, s.stamina + elapsed*Rules.StaminaRegenPerSecond)
    s.staminaAt = now
    player:SetAttribute("KageboundStamina", math.floor(s.stamina+0.5))
end

local function spend(player, s, action, now, overrideCost)
    updateStamina(player, s, now)
    local cost=overrideCost or Rules.ActionCost[action]
    if s.stamina<cost then return false end
    s.stamina -= cost
    player:SetAttribute("KageboundStamina", math.floor(s.stamina+0.5))
    return true
end

local function getRig(player)
    local char = player.Character
    if not char then return nil end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root or humanoid.Health <= 0 then return nil end
    return char, humanoid, root
end

-- Weapon ownership is checked on the server for every sword attack.
-- Tool in Backpack is NOT equipped and cannot authorize katana damage.
local function equippedWeapon(player, character)
    return WeaponAuthority.ActiveEquipped(player,character)
end

local function horizontalUnit(vector)
    if typeof(vector) ~= "Vector3" then return nil end
    if vector.X ~= vector.X or vector.Z ~= vector.Z then return nil end
    if math.abs(vector.X) > 100000 or math.abs(vector.Z) > 100000 then return nil end
    local horizontal = Vector3.new(vector.X,0,vector.Z)
    return horizontal.Magnitude > 0.1 and horizontal.Unit or nil
end

local function facing(root, targetPosition, threshold)
    local toTarget = horizontalUnit(targetPosition-root.Position)
    local forward = horizontalUnit(root.CFrame.LookVector)
    return toTarget ~= nil and forward ~= nil and forward:Dot(toTarget) >= threshold
end

local function hasLineOfSight(attackerChar, targetChar, from, to)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {attackerChar, targetChar}
    params.RespectCanCollide = true -- ignore decorative leaves and local VFX
    return workspace:Raycast(from, to-from, params) == nil
end

-- Active strike: rectangular sweep in front of the character, sampled three
-- times. Ignore world art and only query character assemblies; line of sight
-- prevents hitting behind walls. The hitRegistry prevents multi-hit per swing.
local function sweep(player, attackerChar, attackerRoot, s, heavy, damage, range, hitRegistry, profile)
    local targets = {}
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player then
            local otherChar, _, otherRoot = getRig(other)
            if otherRoot and not protectedHub(otherRoot.Position)
                and DuelAuthority.CanDamage(player,other) then
                table.insert(targets, otherChar)
            end
        end
    end
    local enemyFolder = workspace:FindFirstChild("KageboundEnemies")
    if enemyFolder and not DuelAuthority.IsParticipant(player) then
        for _,enemy in ipairs(enemyFolder:GetChildren()) do
            if enemy:IsA("Model") and enemy:GetAttribute("KageboundEnemy")==true
                and (enemy:GetAttribute("Health") or 0)>0 and enemy.PrimaryPart then
                table.insert(targets,enemy)
            end
        end
    end
    local practice=workspace:FindFirstChild("KageboundTraining")
    if practice and not DuelAuthority.IsParticipant(player)
        and inTrainingCircle(attackerRoot.Position) then
        for _,dummy in ipairs(practice:GetChildren()) do
            if dummy:IsA("Model") and dummy:GetAttribute("KageboundTrainingTarget")==true
                and dummy.PrimaryPart and (dummy:GetAttribute("Health") or 0)>0 then
                table.insert(targets,dummy)
            end
        end
    end
    if #targets == 0 then return false end

    local params = OverlapParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = targets
    params.MaxParts = 128
    local size = profile
    local box = attackerRoot.CFrame*CFrame.new(0,0,-(range/2+0.6))
    local candidates = workspace:GetPartBoundsInBox(box, Vector3.new(size.width,size.height,range), params)
    local hitCount = 0

    for _, part in ipairs(candidates) do
        local model = part:FindFirstAncestorOfClass("Model")
        local opponent = model and Players:GetPlayerFromCharacter(model)
        if opponent and opponent ~= player and not hitRegistry[opponent] then
            local opponentChar, opponentHum, opponentRoot = getRig(opponent)
            if opponentRoot and opponentChar == model then
                local delta = opponentRoot.Position-attackerRoot.Position
                if delta.Magnitude <= range+1 and math.abs(delta.Y) <= 6
                    and facing(attackerRoot, opponentRoot.Position, 0.26)
                    and not protectedHub(opponentRoot.Position)
                    and DuelAuthority.CanDamage(player,opponent)
                    and hasLineOfSight(attackerChar, opponentChar,
                        attackerRoot.Position+Vector3.new(0,1,0),
                        opponentRoot.Position+Vector3.new(0,1,0)) then

                    hitRegistry[opponent] = true
                    local opponentState = getState(opponent)
                    local serverParryUntil = opponent:GetAttribute("KageboundParryUntil") or 0
                    local isParrying = os.clock() <= opponentState.parryUntil
                        and typeof(serverParryUntil) == "number"
                        and os.clock() <= serverParryUntil
                        and facing(opponentRoot, attackerRoot.Position, 0.25)

                    if isParrying and not profile.guardBreak then
                        opponentState.parryUntil = 0
                        opponent:SetAttribute("KageboundParryUntil",0)
                        s.staggerUntil = os.clock()+Rules.ParryStagger
                        s.attackToken += 1 -- parry cancels further active samples
                        remote:FireAllClients("Parried", opponent, player)
                        return true
                    end

                    if isParrying then
                        opponentState.parryUntil = 0
                        opponent:SetAttribute("KageboundParryUntil",0)
                        markBusy(opponent,opponentState,os.clock()+Rules.GuardBreakStagger)
                        opponentState.staggerUntil = opponentState.busyUntil
                        opponentState.attackToken += 1
                        remote:FireAllClients("GuardBroken", opponent, player)
                    end
                    local finalDamage,guarded=Classes.ResolveDefense(opponent,
                        attackerRoot.Position,damage,heavy)
                    if guarded then
                        s.staggerUntil=os.clock()+.16
                        s.attackToken+=1
                        remote:FireAllClients("ClassGuard",opponent,player)
                        return true
                    end
                    if finalDamage>0 then
                        opponentHum:TakeDamage(finalDamage)
                        remote:FireAllClients("Hit", opponent, finalDamage)
                    end
                    hitCount += 1
                    if hitCount >= Rules.MaxPlayersHitPerSwing then return true end
                end
            end
        elseif model and model:GetAttribute("KageboundEnemy")==true
            and model.PrimaryPart and not hitRegistry[model] then
            local enemyRoot=model.PrimaryPart
            local health=tonumber(model:GetAttribute("Health")) or 0
            local delta=enemyRoot.Position-attackerRoot.Position
            if health>0 and delta.Magnitude<=range+1 and math.abs(delta.Y)<=6
                and facing(attackerRoot,enemyRoot.Position,0.26)
                and hasLineOfSight(attackerChar,model,
                    attackerRoot.Position+Vector3.new(0,1,0),
                    enemyRoot.Position+Vector3.new(0,1,0)) then
                local applied=EnemyDamage.Apply(player,model,damage,range,0.17)
                if applied then
                    hitRegistry[model]=true
                    remote:FireAllClients("HitTarget",model,damage)
                    hitCount+=1
                    if hitCount >= Rules.MaxPlayersHitPerSwing then return true end
                end
            end
        elseif model and model:GetAttribute("KageboundTrainingTarget")==true
            and model.PrimaryPart and not hitRegistry[model]
            and inTrainingCircle(attackerRoot.Position) then
            -- Training is the only sword target permitted within the social hub.
            -- No player damage, NPC reward, kill credit or inventory mutation.
            local dummyRoot=model.PrimaryPart
            local health=tonumber(model:GetAttribute("Health")) or 0
            local delta=dummyRoot.Position-attackerRoot.Position
            if health>0 and delta.Magnitude<=range+1 and math.abs(delta.Y)<=6
                and facing(attackerRoot,dummyRoot.Position,0.26)
                and hasLineOfSight(attackerChar,model,
                    attackerRoot.Position+Vector3.new(0,1,0),
                    dummyRoot.Position+Vector3.new(0,1,0)) then
                hitRegistry[model]=true
                model:SetAttribute("HitCount",(model:GetAttribute("HitCount") or 0)+1)
                model:SetAttribute("Health",math.max(0,health-damage))
                remote:FireAllClients("HitTarget",model,damage)
                hitCount+=1
                if hitCount>=Rules.MaxPlayersHitPerSwing then return true end
            end
        end
    end
    return false
end

local function attack(player, heavy)
    local now = os.clock()
    local s = getState(player)
    local char, _, root = getRig(player)
    if not root or not canSwingAt(root.Position) then return end
    local weaponName=equippedWeapon(player,char)
    if not weaponName or not DuelAuthority.CanAct(player) then return end
    if now < s.busyUntil or now < s.staggerUntil or now < s.attackReadyAt
        or now<(player:GetAttribute("KageboundClassBusyUntil") or 0) then return end

    local action = heavy and "Heavy" or "Light"
    local combo, damage, range, profile

    if heavy then
        profile=WeaponAttacks.Resolve(weaponName,true,0)
        if not profile or now-s.heavyAt < profile.cooldown or now-s.lightAt < Rules.LightCooldown then return end
        if not spend(player,s,"Heavy",now,profile.cost) then return end
        s.heavyAt = now
        s.combo = 0
        combo, damage, range = 0, profile.damage, profile.range
    else
        if now-s.heavyAt < 0.7 then return end
        local nextCombo=Rules.NextCombo(s.combo,now-s.comboAt)
        profile=WeaponAttacks.Resolve(weaponName,false,nextCombo)
        if not profile or now-s.lightAt<profile.cooldown or not spend(player,s,"Light",now,profile.cost) then return end
        s.lightAt=now
        s.combo=nextCombo
        s.comboAt=now
        combo, damage, range = s.combo, profile.damage, profile.range
    end

    -- Shared cooldown survives light/heavy alternation and cannot be bypassed
    -- by swapping weapon profiles between requests.
    s.attackReadyAt = now + profile.cooldown
    s.parryUntil = 0
    player:SetAttribute("KageboundParryUntil",0)
    markBusy(player,s,now+profile.windup+profile.active+profile.recovery)
    s.attackToken += 1
    local token = s.attackToken
    local issuedTool=WeaponAuthority.GetIssuedTool(player,char)
    remote:FireAllClients("Windup",player,action,combo)

    task.delay(profile.windup,function()
        local actorChar, _, actorRoot = getRig(player)
        if not actorRoot or actorChar ~= char or state[player] ~= s
            or s.attackToken ~= token or not canSwingAt(actorRoot.Position)
            or equippedWeapon(player,actorChar)~=weaponName
            or WeaponAuthority.GetIssuedTool(player,actorChar)~=issuedTool
            or not DuelAuthority.CanAct(player) then return end
        remote:FireAllClients("Swing",player,action,combo)

        local hitRegistry = {}
        for i=1,Rules.AttackSamples do
            actorChar, _, actorRoot = getRig(player)
            if not actorRoot or actorChar ~= char or s.attackToken ~= token
                or not canSwingAt(actorRoot.Position)
                or equippedWeapon(player,actorChar)~=weaponName
                or not DuelAuthority.CanAct(player) then break end
            local interrupted = sweep(player,actorChar,actorRoot,s,heavy,damage,range,hitRegistry,profile)
            if interrupted then break end
            if i < Rules.AttackSamples then
                task.wait(profile.active/(Rules.AttackSamples-1))
            end
        end
    end)
end

remote.OnServerEvent:Connect(function(player, action, payload)
    if typeof(action) ~= "string" then return end
    local now = os.clock()
    local s = getState(player)
    local _, humanoid, root = getRig(player)
    if not root or not DuelAuthority.CanAct(player)
        or now<(player:GetAttribute("KageboundClassBusyUntil") or 0) then return end
    if humanoid.FloorMaterial ~= Enum.Material.Air then s.doubleJumpUsed = false end

    if action == "Light" then
        attack(player,false)
    elseif action == "Heavy" then
        attack(player,true)
    elseif action == "Parry" then
        if protectedHub(root.Position) or now < s.busyUntil
            or now < s.staggerUntil or now-s.parryAt < Rules.ParryCooldown then return end
        if not spend(player,s,"Parry",now) then return end
        s.parryAt = now
        s.parryUntil = now+Rules.ParryWindow
        player:SetAttribute("KageboundParryUntil",s.parryUntil)
        markBusy(player,s,s.parryUntil)
        remote:FireAllClients("ParryStart",player)
    elseif action == "DoubleJump" then
        if now < s.busyUntil or now < s.staggerUntil or s.doubleJumpUsed
            or now-s.doubleJumpAt < Rules.DoubleJumpCooldown then return end
        if humanoid.FloorMaterial ~= Enum.Material.Air then return end
        if not spend(player,s,"DoubleJump",now) then return end
        s.doubleJumpUsed = true
        s.doubleJumpAt = now
        local velocity = root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity = Vector3.new(velocity.X,Rules.DoubleJumpVelocity,velocity.Z)
        remote:FireAllClients("DoubleJumpFX",player)
    elseif action == "Dash" then
        if now < s.busyUntil or now < s.staggerUntil
            or now-s.dashAt < Rules.DashCooldown then return end
        local direction = horizontalUnit(payload)
        if not direction or not spend(player,s,"Dash",now) then return end
        s.dashAt = now
        markBusy(player,s,now+0.16)
        -- Client sends normalized intent; only the server controls velocity.
        root.AssemblyLinearVelocity = direction*Rules.DashSpeed
            + Vector3.new(0,math.clamp(root.AssemblyLinearVelocity.Y,0,35),0)
        remote:FireAllClients("DashFX",player)
    end
end)

local function register(player)
    resetState(player)
    player.CharacterAdded:Connect(function()
        resetState(player)
    end)
end
Players.PlayerAdded:Connect(register)
for _,player in ipairs(Players:GetPlayers()) do register(player) end
Players.PlayerRemoving:Connect(function(player) state[player] = nil end)

task.spawn(function()
    while true do
        task.wait(0.25)
        local now=os.clock()
        for player,s in pairs(state) do
            if player.Parent == Players then
                updateStamina(player,s,now)
                local _, hum = getRig(player)
                if hum and hum.FloorMaterial ~= Enum.Material.Air then s.doubleJumpUsed = false end
            end
        end
    end
end)
print("[KAGEBOUND] Combat v0.3: server-timed active windows / box sweeps / safe hub")
