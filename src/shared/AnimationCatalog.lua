-- KAGEBOUND animation asset slots.
-- ART-001: attack personality; ART-002: Shinobi silhouette; ART-003: Veilblade.
-- EMPTY BY DESIGN: upload owned animation tracks using Roblox Studio first.
-- Never paste another game's animation IDs or copy its motion assets.
local Catalog = {}

Catalog.Shinobi = {
    Light1 = "", -- fast across-body opening slash
    Light2 = "", -- reverse cut with hip rotation
    Light3 = "", -- finishing diagonal slash, 18 damage
    Heavy = "",  -- long deliberate windup, guard-break impact
    Parry = "",  -- compact blade guard, blue counter feedback
    Dash = "",   -- optional acceleration / evasive step
    DoubleJump = "", -- optional airborne flourish
    Idle = ""    -- optional raised katana ready pose
}

-- Returns a well-formed Roblox animation URI or nil.
-- Actual permissions, publication and rig compatibility must be tested in Studio.
function Catalog.Resolve(value)
    if typeof(value) ~= "string" then return nil end
    local digits = value:match("^rbxassetid://(%d+)$") or value:match("^(%d+)$")
    if not digits then return nil end
    local n = tonumber(digits)
    if not n or n < 1 or n ~= n or n == math.huge then return nil end
    return "rbxassetid://"..digits
end
return Catalog
