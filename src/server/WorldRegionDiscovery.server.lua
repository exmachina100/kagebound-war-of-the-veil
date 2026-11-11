-- KAGEBOUND: server-authoritative region discovery for Grand World.
-- Read-only exploration state; never grants currency, mastery or combat power.
-- Region boundaries use the existing WorldConfig atlas; paths between zones
-- intentionally count as wilderness rather than claiming a nearby region.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local World = require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("WorldConfig"))
if not World.Enabled then return end

local INTERVAL = 0.5
local DISCOVERY_PREFIX = "Discovered_"
local function regionAt(position)
    local selected, nearest = nil, math.huge
    for _, zone in ipairs(World.Zones) do
        local dx, dz = position.X - zone.x, position.Z - zone.z
        local distanceSquared = dx * dx + dz * dz
        if distanceSquared <= zone.radius * zone.radius and distanceSquared < nearest then
            selected, nearest = zone, distanceSquared
        end
    end
    return selected
end

local function track(player)
    player:SetAttribute("CurrentRegion", "")
    player:SetAttribute("CurrentRegionName", "")
    player:SetAttribute("RegionsDiscovered", 0)
    local discovered = {}
    while player.Parent == Players do
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local zone = root and humanoid and humanoid.Health > 0 and regionAt(root.Position) or nil
        local id = zone and zone.id or ""
        if player:GetAttribute("CurrentRegion") ~= id then
            player:SetAttribute("CurrentRegion", id)
            player:SetAttribute("CurrentRegionName", zone and zone.name or "")
        end
        if zone and not discovered[id] then
            discovered[id] = true
            player:SetAttribute(DISCOVERY_PREFIX .. id, true)
            local count = player:GetAttribute("RegionsDiscovered") or 0
            player:SetAttribute("RegionsDiscovered", count + 1)
        end
        task.wait(INTERVAL)
    end
end

Players.PlayerAdded:Connect(function(player)
    task.spawn(track, player)
end)
for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(track, player)
end
