-- Moonfall Bamboo: repeatable procedural greybox for KAGEBOUND PvP.
-- Every part is created by the server; no manual Studio geometry required.
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
if Workspace:FindFirstChild("KageboundArena") then Workspace.KageboundArena:Destroy() end
local arena = Instance.new("Folder")
arena.Name = "KageboundArena"
arena.Parent = Workspace

local function part(name, size, position, color, material, collision, parent)
    local p = Instance.new("Part")
    p.Name = name
    p.Anchored = true
    p.Size = size
    p.Position = position
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.CanCollide = collision ~= false
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = parent or arena
    return p
end

local stone = Color3.fromRGB(72, 74, 87)
local trim = Color3.fromRGB(132, 63, 72)
local wood = Color3.fromRGB(85, 46, 45)
part("ArenaFloor", Vector3.new(136, 3, 136), Vector3.new(0, -1.5, 0), Color3.fromRGB(37, 48, 55), Enum.Material.Slate)
part("DuelPlatform", Vector3.new(64, 1, 64), Vector3.new(0, 0.5, 0), stone, Enum.Material.Slate)
part("CenterSeal", Vector3.new(17, 0.15, 17), Vector3.new(0, 1.09, 0), Color3.fromRGB(99, 69, 117), Enum.Material.Neon, false)
-- Four low, readable arena cover blocks; main duel center remains open.
for _, spec in ipairs({
    {-22, -22, 12, 6}, {22, -22, 12, 6}, {-22, 22, 12, 6}, {22, 22, 12, 6}
}) do
    part("StoneCover", Vector3.new(spec[3], spec[4], 5), Vector3.new(spec[1], spec[4]/2+1, spec[2]), stone, Enum.Material.Slate)
end
-- Boundary: visible rail with solid collision. Can jump over at advanced traversal later.
for _, z in ipairs({-67, 67}) do
    part("OuterWall", Vector3.new(136, 13, 2), Vector3.new(0, 6.5, z), Color3.fromRGB(32, 39, 46), Enum.Material.Slate)
end
for _, x in ipairs({-67, 67}) do
    part("OuterWall", Vector3.new(2, 13, 136), Vector3.new(x, 6.5, 0), Color3.fromRGB(32, 39, 46), Enum.Material.Slate)
end
local function torii(x, z)
    part("ToriiLeft", Vector3.new(2, 18, 2), Vector3.new(x-8, 9, z), trim, Enum.Material.Wood)
    part("ToriiRight", Vector3.new(2, 18, 2), Vector3.new(x+8, 9, z), trim, Enum.Material.Wood)
    part("ToriiBeam", Vector3.new(23, 2.2, 3), Vector3.new(x, 18, z), trim, Enum.Material.Wood)
    part("ToriiCrossbar", Vector3.new(18, 1, 2), Vector3.new(x, 14, z), wood, Enum.Material.Wood)
end
torii(0, -43)
torii(0, 43)
-- Decorative bamboo; outside the main 64x64 duel platform.
for i = 1, 32 do
    local angle = (i / 32) * math.pi * 2
    local radius = 50 + (i % 3) * 4
    local x, z = math.cos(angle) * radius, math.sin(angle) * radius
    local height = 17 + (i % 5) * 3
    local trunk = part("BambooTrunk", Vector3.new(1.5, height, 1.5), Vector3.new(x, height/2, z), Color3.fromRGB(64, 104, 75), Enum.Material.Wood, false)
    trunk.Shape = Enum.PartType.Cylinder
    local leaves = part("BambooCanopy", Vector3.new(6, 4, 6), Vector3.new(x, height+1, z), Color3.fromRGB(41, 86, 70), Enum.Material.Grass, false)
    leaves.Shape = Enum.PartType.Ball
end
local function lamp(x, z)
    local post = part("LanternPost", Vector3.new(1.6, 6, 1.6), Vector3.new(x, 3, z), wood, Enum.Material.Wood)
    local light = part("LanternGlow", Vector3.new(3, 3, 3), Vector3.new(x, 7, z), Color3.fromRGB(255, 182, 97), Enum.Material.Neon, false)
    local point = Instance.new("PointLight")
    point.Brightness = 1.5
    point.Range = 19
    point.Color = light.Color
    point.Parent = light
end
for _, x in ipairs({-38, 38}) do
    for _, z in ipairs({-38, 38}) do lamp(x, z) end
end
local function spawn(name, x, z)
    local s = Instance.new("SpawnLocation")
    s.Name = name
    s.Size = Vector3.new(8, 1, 8)
    s.Position = Vector3.new(x, 1.8, z)
    s.Anchored = true
    s.Neutral = true
    s.AllowTeamChangeOnTouch = false
    s.Duration = 0
    s.Color = Color3.fromRGB(58, 119, 138)
    s.Material = Enum.Material.Neon
    s.Parent = arena
end
spawn("SpawnWest", -35, 0)
spawn("SpawnEast", 35, 0)
Lighting.ClockTime = 0
Lighting.Brightness = 2
Lighting.Ambient = Color3.fromRGB(72, 73, 104)
Lighting.OutdoorAmbient = Color3.fromRGB(61, 65, 87)
Lighting.FogEnd = 235
Lighting.FogColor = Color3.fromRGB(71, 61, 91)
print("[KAGEBOUND] Moonfall Bamboo greybox loaded")
