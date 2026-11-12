-- KAGEBOUND Dojo-to-Moonfall journey dressing v12.
-- Reuses the already imported v07/v08 source-controlled meshes.
-- ART-004: a readable stepping-stone approach from the forest trail to the
-- existing Moonfall arch bridge and shrine terrace. Decorative copies only;
-- GrandWorld road, bridge collision and all gameplay authority remain intact.
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("WorldConfig"))
if not Config.Enabled then return end

local world = workspace:WaitForChild("KageboundWorld", 60)
if not world then
    warn("[KAGEBOUND JourneyArt] KageboundWorld was not ready")
    return
end
if world:FindFirstChild("MoonfallJourneyArtV12") then return end

local zone
for _, candidate in ipairs(Config.Zones) do
    if candidate.id == "MoonfallBamboo" then
        zone = candidate
        break
    end
end
if not zone then
    warn("[KAGEBOUND JourneyArt] MoonfallBamboo zone is missing")
    return
end

local v07 = ServerStorage:FindFirstChild("KageboundWorldArt")
local v08 = ServerStorage:FindFirstChild("KageboundWorldArtV08")
local Clone = require(script.Parent:WaitForChild("CosmeticWorldArt")).Clone

-- The existing center stepping-stone cluster is at local (0, 32); these
-- three short runs turn east toward the existing arch bridge at (105, 35).
-- Two imported lanterns mark the forest entry and the far shrine approach.
local placements = {
    {library = v07, template = "moonfall_stepping_stones", name = "MoonfallTrailStone_01", x = 32, z = 32, yaw = 90, scale = 1.15},
    {library = v07, template = "moonfall_stepping_stones", name = "MoonfallTrailStone_02", x = 63, z = 32, yaw = 90, scale = 1.15},
    {library = v07, template = "moonfall_stepping_stones", name = "MoonfallTrailStone_03", x = 94, z = 35, yaw = 90, scale = 1.15},
    {library = v08, template = "dojo_stone_lantern", name = "MoonfallTrailLantern_01", x = 28, z = 5, yaw = 0, scale = 1.1},
    {library = v08, template = "dojo_stone_lantern", name = "MoonfallTrailLantern_02", x = 136, z = 66, yaw = 0, scale = 1.1},
}

local resolved = {}
for _, item in ipairs(placements) do
    local template = item.library and item.library:FindFirstChild(item.template)
    if template then
        table.insert(resolved, {item = item, template = template})
    else
        warn("[KAGEBOUND JourneyArt] Missing imported template: " .. item.template)
    end
end
if #resolved == 0 then
    warn("[KAGEBOUND JourneyArt] No imported journey templates available; skipped")
    return
end

local folder = Instance.new("Folder")
folder.Name = "MoonfallJourneyArtV12"
folder:SetAttribute("Reference", "ART-004")
folder:SetAttribute("Status", "cosmetic trail dressing; existing route and bridge collision remain authoritative")
folder.Parent = world

local placed, partCount = 0, 0
for _, entry in ipairs(resolved) do
    local item = entry.item
    local copy = Clone(entry.template)
    if copy then
        copy.Name = item.name
        if copy:IsA("Model") then
            copy:ScaleTo(item.scale)
        elseif copy:IsA("BasePart") then
            copy.Size *= item.scale
        end
        copy:PivotTo(
            CFrame.new(zone.x + item.x, 1.76, zone.z + item.z)
                * CFrame.Angles(0, math.rad(item.yaw), 0)
        )
        copy.Parent = folder
        placed += 1
        if copy:IsA("BasePart") then partCount += 1 end
        for _, descendant in ipairs(copy:GetDescendants()) do
            if descendant:IsA("BasePart") then partCount += 1 end
        end
    end
    task.wait()
end

folder:SetAttribute("PlacementCount", placed)
folder:SetAttribute("MeshPartCount", partCount)
print(("[KAGEBOUND JourneyArt] Placed %d cosmetic journey models / %d parts; no gameplay collision changed"):format(placed, partCount))
