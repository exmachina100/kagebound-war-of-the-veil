-- KAGEBOUND environment mesh integration (cosmetic-only).
-- Imported Studio templates belong in ServerStorage/KageboundArt/WorldEnvironment.
-- This script never changes gameplay hitboxes or terrain collisions.
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local world = Workspace:WaitForChild("KageboundWorld", 120)
if not world then
    warn("[KAGEBOUND] World asset integration skipped: Grand World missing")
    return
end

local art = ServerStorage:FindFirstChild("KageboundArt")
local library = art and art:FindFirstChild("WorldEnvironment")
if not library then
    warn("[KAGEBOUND] WorldEnvironment templates not imported; procedural world preserved")
    return
end

local placements = {
    {name = "KageDojoShrine", region = "KageDojo", offset = Vector3.new(0, 0, -35)},
    {name = "DojoRitualAltar", region = "KageDojo", offset = Vector3.new(0, 0, -24)},
    {name = "DojoClanBanner", region = "KageDojo", offset = Vector3.new(-12, 0, -27)},
    {name = "MoonfallBambooCluster", region = "MoonfallBamboo", offset = Vector3.new(24, 0, 15)},
    {name = "MoonfallBridge", region = "MoonfallBamboo", offset = Vector3.new(0, 0, 0)},
    {name = "MoonfallStonePath", region = "MoonfallBamboo", offset = Vector3.new(-15, 0, 12)},
    {name = "MoonfallToriiGate", region = "MoonfallBamboo", offset = Vector3.new(0, 0, 35)},
    {name = "ShrineStoneLantern", region = "MoonfallBamboo", offset = Vector3.new(12, 0, 30)},
}

local installed = world:FindFirstChild("ImportedWorldArt")
if not installed then
    installed = Instance.new("Folder")
    installed.Name = "ImportedWorldArt"
    installed.Parent = world
end

local function regionPosition(region)
    if region:IsA("Model") then
        return region:GetPivot().Position
    elseif region:IsA("BasePart") then
        return region.Position
    elseif region:IsA("Folder") then
        local base = region:FindFirstChildWhichIsA("BasePart", true)
        return base and base.Position
    end
    return nil
end

local count = 0
for _, entry in ipairs(placements) do
    if not installed:FindFirstChild(entry.name) then
        local template = library:FindFirstChild(entry.name)
        local region = world:FindFirstChild(entry.region)
        local position = region and regionPosition(region)
        if template and position and (template:IsA("Model") or template:IsA("BasePart")) then
            local copy = template:Clone()
            copy.Name = entry.name
            for _, descendant in ipairs(copy:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true
                    descendant.CanCollide = false
                    descendant.CanTouch = false
                    descendant.CanQuery = false
                end
            end
            if copy:IsA("BasePart") then
                copy.Anchored = true
            end
            copy:PivotTo(CFrame.new(position + entry.offset))
            copy.Parent = installed
            count += 1
        end
    end
end
print(("[KAGEBOUND] Installed %d imported cosmetic world templates; no gameplay collision modified"):format(count))
