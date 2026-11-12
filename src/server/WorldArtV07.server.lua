-- KAGEBOUND v07 environment prefab integration, visuals only.
-- Import the v07 glTFs into ServerStorage/KageboundWorldArt as named Models.
-- Existing GrandWorld geometry retains collision and gameplay authority.
local CosmeticWorldArt = require(script.Parent:WaitForChild("CosmeticWorldArt"))
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local cfg = require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("WorldConfig"))
if not cfg.Enabled then return end
local source = ServerStorage:FindFirstChild("KageboundWorldArt")
if not source then return end
local world = Workspace:WaitForChild("KageboundWorld", 60)
if not world then return end
local zones = {}
for _, z in ipairs(cfg.Zones) do zones[z.id] = z end
local placements = {
    {zone="KageDojo", asset="dojo_komainu_plinth", x=-18, z=-52, yaw=15, scale=2.1},
    {zone="KageDojo", asset="dojo_komainu_plinth", x=18, z=-52, yaw=-15, scale=2.1},
    {zone="KageDojo", asset="dojo_suspended_bell", x=46, z=42, yaw=90, scale=1.6},
    {zone="KageDojo", asset="dojo_ritual_banner", x=-34, z=8, yaw=30, scale=2.3},
    {zone="KageDojo", asset="dojo_ritual_banner", x=34, z=8, yaw=-30, scale=2.3},
    {zone="MoonfallBamboo", asset="moonfall_bamboo_fan", x=-65, z=-36, yaw=40, scale=2.4},
    {zone="MoonfallBamboo", asset="moonfall_bamboo_fan", x=65, z=-28, yaw=-20, scale=2.8},
    {zone="MoonfallBamboo", asset="moonfall_bamboo_fan", x=78, z=62, yaw=100, scale=2.2},
    {zone="MoonfallBamboo", asset="moonfall_stepping_stones", x=0, z=32, yaw=0, scale=2.0},
    {zone="MoonfallBamboo", asset="moonfall_lantern_arch", x=0, z=-43, yaw=0, scale=2.3},
}
local parent = world:FindFirstChild("ImportedEnvironmentArt")
if not parent then
    parent = Instance.new("Folder")
    parent.Name = "ImportedEnvironmentArt"
    parent.Parent = world
end
local placed = 0
local missing = {}
for _, item in ipairs(placements) do
    local zone = zones[item.zone]
    local template = source:FindFirstChild(item.asset)
    if zone and template and (template:IsA("Model") or template:IsA("BasePart")) then
        local copy = CosmeticWorldArt.Clone(template)
        if copy then
            copy.Name = item.asset .. "_v07"
            local cf = CFrame.new(zone.x + item.x, 1.76, zone.z + item.z)
                * CFrame.Angles(0, math.rad(item.yaw), 0)
            if copy:IsA("Model") then
                copy:ScaleTo(item.scale)
                copy:PivotTo(cf)
            else
                copy.Size *= item.scale
                copy.CFrame = cf
            end
            copy.Parent = parent
            placed += 1
        end
    else
        missing[item.asset] = true
    end
end
if placed > 0 then
    print("[KAGEBOUND WorldArt v07] Placed " .. placed .. " visual prefabs")
end
for name in pairs(missing) do
    warn("[KAGEBOUND WorldArt v07] Missing imported prefab: " .. name)
end
