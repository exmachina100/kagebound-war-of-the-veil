-- Cosmetic world-art loader. Requires Studio-imported MeshPart/Model templates and
-- explicitly positioned placement anchors; never guesses a region's origin.
-- Anchors: Workspace/KageboundWorld/ArtPlacementAnchors/<asset name> (BasePart).
-- Templates: ServerStorage/KageboundArt/WorldEnvironment/<asset name>.
-- All gameplay collision and existing procedural world parts remain untouched.
local CosmeticWorldArt = require(script.Parent:WaitForChild("CosmeticWorldArt"))
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local world = Workspace:WaitForChild("KageboundWorld", 120)
if not world then
    warn("[KAGEBOUND] World art skipped: KageboundWorld not ready")
    return
end

local names = {
    "KageDojoShrine", "DojoRitualAltar", "DojoClanBanner",
    "MoonfallBambooCluster", "MoonfallBridge", "MoonfallStonePath",
    "MoonfallToriiGate", "ShrineStoneLantern",
    "DojoCeremonialTorii", "DojoShrineArchedRoof", "MoonfallSacredBamboo",
    "DojoCurvedRoofModule", "DojoShojiWall", "MoonfallBambooTall",
    "MoonfallFallenBamboo", "MoonfallStoneLanternTall", "ShrineRopeBell",
}

local art = ServerStorage:FindFirstChild("KageboundArt")
local library = art and art:FindFirstChild("WorldEnvironment")
local anchors = world:FindFirstChild("ArtPlacementAnchors")
if not library or not anchors then
    warn("[KAGEBOUND] World art not installed: import templates and add explicit ArtPlacementAnchors")
    return
end

local installed = world:FindFirstChild("ImportedWorldArt")
if not installed then
    installed = Instance.new("Folder")
    installed.Name = "ImportedWorldArt"
    installed.Parent = world
end

local count = 0
local skipped = 0
for _, name in ipairs(names) do
    local template = library:FindFirstChild(name)
    local anchor = anchors:FindFirstChild(name)
    if not installed:FindFirstChild(name) and template and anchor
        and anchor:IsA("BasePart")
        and (template:IsA("Model") or template:IsA("BasePart")) then
        local clone = CosmeticWorldArt.Clone(template)
        if clone then
            clone.Name = name
            clone:PivotTo(anchor.CFrame)
            clone.Parent = installed
            count += 1
        else
            skipped += 1
        end
    elseif not installed:FindFirstChild(name) then
        skipped += 1
    end
end
print(("[KAGEBOUND] World art: %d cosmetic templates placed; %d unavailable or empty; gameplay geometry unchanged"):format(count,skipped))
