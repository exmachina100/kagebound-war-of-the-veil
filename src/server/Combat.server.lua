-- Server-authoritative KAGEBOUND combat prototype.
-- All hit tests, damage, cooldowns and parry outcomes are decided here.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:FindFirstChild("KageboundCombat")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "KageboundCombat"
    remote.Parent = ReplicatedStorage
end

local LIGHT_DAMAGE = {12, 14, 18}
local LIGHT_RANGE = 9
local HEAVY_RANGE = 11
local PARRY_WINDOW = 0.32
local PARRY_COOLDOWN = 1.3
local DASH_COOLDOWN = 1.7
local DASH_SPEED = 68
local state = {}

local function getState(player)
    if not state[player] then
        state[player] = {
            lightAt = 0, heavyAt = 0, parryAt = 0, dashAt = 0,
            comboAt = 0, combo = 0, parryUntil = 0
        }
    end
    return state[player]
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
        if now - s.heavyAt < 1.05 or now - s.lightAt < 0.35 then return end
        s.heavyAt = now
        s.combo = 0
        combo, cooldown, damage, range = 0, 1.05, 27, HEAVY_RANGE
    else
        if now - s.lightAt < 0.34 or now - s.heavyAt < 0.7 then return end
        s.lightAt = now
        if now - s.comboAt > 1 then s.combo = 0 end
        s.combo = (s.combo % 3) + 1
        s.comboAt = now
        combo, cooldown, damage, range = s.combo, 0.34, LIGHT_DAMAGE[s.combo], LIGHT_RANGE
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
        s.parryAt = now
        s.parryUntil = now + PARRY_WINDOW
        remote:FireAllClients("ParryStart", player)
    elseif action == "Dash" then
        if now - s.dashAt < DASH_COOLDOWN then return end
        local direction = horizontalUnit(payload)
        if not direction then return end
        -- Client supplies intent only, capped to a normalized direction.
        -- Prevent dashing upward/flying; Roblox physics replicates movement.
        s.dashAt = now
        root.AssemblyLinearVelocity = direction * DASH_SPEED + Vector3.new(0, math.max(root.AssemblyLinearVelocity.Y, 0), 0)
        remote:FireAllClients("DashFX", player)
    end
end)

Players.PlayerRemoving:Connect(function(player) state[player] = nil end)
print("[KAGEBOUND] Shinobi combat server ready")
