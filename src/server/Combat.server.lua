-- Server-authoritative KAGEBOUND combat prototype.
-- All hit tests, damage, cooldowns and parry outcomes are decided here.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rules = require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("CombatRules"))
local remote = ReplicatedStorage:FindFirstChild("KageboundCombat")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "KageboundCombat"
    remote.Parent = ReplicatedStorage
end

local LIGHT_DAMAGE = Rules.LightDamage
local LIGHT_RANGE = Rules.LightRange
local HEAVY_RANGE = Rules.HeavyRange
local PARRY_WINDOW = Rules.ParryWindow
local PARRY_COOLDOWN = Rules.ParryCooldown
local DASH_COOLDOWN = Rules.DashCooldown
local DASH_SPEED = Rules.DashSpeed
local state = {}

local function getState(player)
    if not state[player] then
        state[player] = {
            lightAt = -math.huge, heavyAt = -math.huge, parryAt = -math.huge, dashAt = -math.huge,
            comboAt = -math.huge, combo = 0, parryUntil = 0,
            stamina = Rules.MaxStamina, staminaAt = os.clock()
        }
    end
    return state[player]
end
-- Stamina is tracked exclusively on the server; Player attributes are read-only HUD mirrors.
local function updateStamina(player, s, now)
    local elapsed = math.clamp(now - s.staminaAt, 0, 1)
    s.stamina = math.min(Rules.MaxStamina, s.stamina + elapsed * Rules.StaminaRegenPerSecond)
    s.staminaAt = now
    player:SetAttribute("KageboundStamina", math.floor(s.stamina + .5))
end
local function spend(player, s, action, now)
    updateStamina(player, s, now)
    if not Rules.CanSpend(s.stamina, action) then return false end
    s.stamina -= Rules.ActionCost[action]
    player:SetAttribute("KageboundStamina", math.floor(s.stamina + .5))
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
local function horizontalUnit(vec)
    if typeof(vec) ~= "Vector3" then return nil end
    if vec.X ~= vec.X or vec.Z ~= vec.Z or math.abs(vec.X) > 100000 or math.abs(vec.Z) > 100000 then return nil end
    local horizontal = Vector3.new(vec.X, 0, vec.Z)
    if horizontal.Magnitude < 0.1 then return nil end
    return horizontal.Unit
end
local function facing(root, targetPosition)
    local displacement = targetPosition - root.Position
    local dir = horizontalUnit(displacement)
    if not dir then return false end
    local forward = horizontalUnit(root.CFrame.LookVector)
    return forward and forward:Dot(dir) > 0.25
end
local function obstruction(char, targetChar, origin, destination)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {char, targetChar}
    local hit = workspace:Raycast(origin, destination - origin, params)
    return hit ~= nil
end
local function attack(player, heavy)
    local now = os.clock()
    local s = getState(player)
    local char, _, root = getRig(player)
    if not root then return end
    local combo, cooldown, damage, range
    if heavy then
        if now - s.heavyAt < Rules.HeavyCooldown or now - s.lightAt < Rules.LightCooldown then return end
        if not spend(player, s, "Heavy", now) then return end
        s.heavyAt = now
        s.combo = 0
        combo, cooldown, damage, range = 0, Rules.HeavyCooldown, Rules.HeavyDamage, HEAVY_RANGE
    else
        if now - s.lightAt < Rules.LightCooldown or now - s.heavyAt < 0.7 then return end
        if not spend(player, s, "Light", now) then return end
        s.lightAt = now
        s.combo = Rules.NextCombo(s.combo, now - s.comboAt)
        s.comboAt = now
        combo, cooldown, damage, range = s.combo, Rules.LightCooldown, LIGHT_DAMAGE[s.combo], LIGHT_RANGE
    end
    remote:FireAllClients("Swing", player, heavy and "Heavy" or "Light", combo)
    for _, opponent in ipairs(Players:GetPlayers()) do
        if opponent ~= player then
            local otherChar, otherHum, otherRoot = getRig(opponent)
            if otherRoot then
                local offset = otherRoot.Position - root.Position
                if offset.Magnitude <= range and math.abs(offset.Y) <= 6 and facing(root, otherRoot.Position) and not obstruction(char, otherChar, root.Position+Vector3.new(0,2,0), otherRoot.Position+Vector3.new(0,2,0)) then
                    local otherState = getState(opponent)
                    if now <= otherState.parryUntil and facing(otherRoot, root.Position) then
                        otherState.parryUntil = 0
                        remote:FireAllClients("Parried", opponent, player)
                    else
                        otherHum:TakeDamage(damage)
                        remote:FireAllClients("Hit", opponent, damage)
                    end
                end
            end
        end
    end
end

remote.OnServerEvent:Connect(function(player, action, payload)
    if typeof(action) ~= "string" then return end
    local now = os.clock()
    local s = getState(player)
    local _, humanoid, root = getRig(player)
    if not root then return end
    if action == "Light" then
        attack(player, false)
    elseif action == "Heavy" then
        attack(player, true)
    elseif action == "Parry" then
        if now - s.parryAt < PARRY_COOLDOWN then return end
        if not spend(player, s, "Parry", now) then return end
        s.parryAt = now
        s.parryUntil = now + PARRY_WINDOW
        remote:FireAllClients("ParryStart", player)
    elseif action == "Dash" then
        if now - s.dashAt < DASH_COOLDOWN then return end
        local direction = horizontalUnit(payload)
        if not direction then return end
        if not spend(player, s, "Dash", now) then return end
        -- Client supplies intent only, capped to a normalized direction.
        -- Prevent dashing upward/flying; Roblox physics replicates movement.
        s.dashAt = now
        root.AssemblyLinearVelocity = direction * DASH_SPEED + Vector3.new(0, math.max(root.AssemblyLinearVelocity.Y, 0), 0)
        remote:FireAllClients("DashFX", player)
    end
end)

Players.PlayerAdded:Connect(function(player)
    local s = getState(player)
    player:SetAttribute("KageboundStamina", Rules.MaxStamina)
end)
for _,player in ipairs(Players:GetPlayers()) do
    getState(player)
    player:SetAttribute("KageboundStamina", Rules.MaxStamina)
end
task.spawn(function()
    while true do
        task.wait(.25)
        local now = os.clock()
        for player, s in pairs(state) do
            if player.Parent then updateStamina(player,s,now) end
        end
    end
end)
Players.PlayerRemoving:Connect(function(player) state[player] = nil end)
print("[KAGEBOUND] Shinobi combat server ready")
