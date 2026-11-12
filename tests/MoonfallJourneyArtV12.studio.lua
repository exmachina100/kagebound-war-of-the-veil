-- Run in Roblox Studio Command Bar during Play after WorldArt scripts settle.
-- Verifies the v12 Dojo-to-Moonfall dressing is present and remains cosmetic.
local world = workspace:FindFirstChild("KageboundWorld")
assert(world, "KageboundWorld missing")
local folder = world:FindFirstChild("MoonfallJourneyArtV12")
assert(folder, "MoonfallJourneyArtV12 missing; imported templates or server script may be absent")

local expected = {
    MoonfallTrailStone_01 = true,
    MoonfallTrailStone_02 = true,
    MoonfallTrailStone_03 = true,
    MoonfallTrailLantern_01 = true,
    MoonfallTrailLantern_02 = true,
}
local models, parts, unsafe = 0, 0, 0
for _, child in ipairs(folder:GetChildren()) do
    assert(expected[child.Name], "Unexpected journey placement: " .. child.Name)
    expected[child.Name] = nil
    models += 1
    local function inspect(part)
        if not part:IsA("BasePart") then return end
        parts += 1
        if not part.Anchored or part.CanCollide or part.CanTouch or part.CanQuery then
            unsafe += 1
        end
    end
    inspect(child)
    for _, descendant in ipairs(child:GetDescendants()) do inspect(descendant) end
end
for name in pairs(expected) do error("Missing journey placement: " .. name) end
assert(models == 5, ("Expected 5 placements, got %d"):format(models))
assert(parts == 29, ("Expected 29 imported MeshParts, got %d"):format(parts))
assert(unsafe == 0, ("Found %d unsafe cosmetic parts"):format(unsafe))
assert(folder:GetAttribute("PlacementCount") == 5, "PlacementCount attribute mismatch")
assert(folder:GetAttribute("MeshPartCount") == 29, "MeshPartCount attribute mismatch")
print("[KAGEBOUND JourneyArt QA] PASS — 5 models, 29 MeshParts, 0 unsafe parts")
