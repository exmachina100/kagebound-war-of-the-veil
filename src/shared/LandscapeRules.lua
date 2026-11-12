-- Deterministic clearance policy for additive terrain. No player state or rewards.
local Rules = {}
function Rules.DistanceToSegment(point, a, b)
    local delta = b-a
    if delta.Magnitude == 0 then return (point-a).Magnitude end
    local t = math.clamp((point-a):Dot(delta)/delta:Dot(delta), 0, 1)
    return (point-(a+delta*t)).Magnitude
end
function Rules.RouteClear(point, radius, zones, routes, margin)
    local byId = {}
    for _, zone in ipairs(zones) do
        byId[zone.id] = Vector2.new(zone.x, zone.z)
    end
    for _, edge in ipairs(routes) do
        local a,b=byId[edge[1]],byId[edge[2]]
        if a and b and Rules.DistanceToSegment(point,a,b) < radius+(margin or 40) then return false end
    end
    return true
end
function Rules.CanPlaceHill(point, radius, zones, routes)
    for _,zone in ipairs(zones) do
        -- Reserves plaza, training and existing NPC/enemy gameplay space.
        if (point-Vector2.new(zone.x,zone.z)).Magnitude < radius+125 then return false end
    end
    return Rules.RouteClear(point,radius,zones,routes)
end
return Rules
