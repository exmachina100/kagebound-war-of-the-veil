-- Run in Roblox Studio SERVER Command Bar after importing environment models.
-- Read-only QA: checks actual templates, anchors, placed clones and collision.
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local expected = {
    "KageDojoShrine", "DojoRitualAltar", "DojoClanBanner",
    "MoonfallBambooCluster", "MoonfallBridge", "MoonfallStonePath",
    "MoonfallToriiGate", "ShrineStoneLantern",
}
local world = Workspace:FindFirstChild("KageboundWorld")
local art = ServerStorage:FindFirstChild("KageboundArt")
local library = art and art:FindFirstChild("WorldEnvironment")
local anchors = world and world:FindFirstChild("ArtPlacementAnchors")
local installed = world and world:FindFirstChild("ImportedWorldArt")
local errors = {}
local function check(ok, message)
    if not ok then table.insert(errors, message) end
end
check(world ~= nil, "Missing KageboundWorld")
check(library ~= nil, "Missing ServerStorage/KageboundArt/WorldEnvironment")
check(anchors ~= nil, "Missing KageboundWorld/ArtPlacementAnchors")
check(installed ~= nil, "Missing KageboundWorld/ImportedWorldArt")
local present = 0
for _, name in ipairs(expected) do
    local template = library and library:FindFirstChild(name)
    local anchor = anchors and anchors:FindFirstChild(name)
    local clone = installed and installed:FindFirstChild(name)
    check(template and (template:IsA("Model") or template:IsA("BasePart")), name .. ": imported template absent")
    check(anchor and anchor:IsA("BasePart"), name .. ": placement anchor absent")
    check(clone and (clone:IsA("Model") or clone:IsA("BasePart")), name .. ": installed clone absent")
    if clone then
        present += 1
        local parts = {}
        if clone:IsA("BasePart") then table.insert(parts, clone) end
        for _, part in ipairs(clone:GetDescendants()) do
            if part:IsA("BasePart") then table.insert(parts, part) end
        end
        check(#parts > 0, name .. ": no mesh or part geometry")
        for _, part in ipairs(parts) do
            check(part.Anchored and not part.CanCollide and not part.CanTouch and not part.CanQuery,
                name .. ": unsafe cosmetic collision on " .. part:GetFullName())
            if part:IsA("MeshPart") then
                check(part.MeshId ~= "", name .. ": MeshPart missing MeshId")
            end
        end
        if anchor and anchor:IsA("BasePart") then
            check((clone:GetPivot().Position - anchor.Position).Magnitude < 0.05,
                name .. ": installed pivot does not match anchor")
        end
    end
end
print(("[KAGEBOUND][WorldArtQA] %d/%d installed; %d issues"):format(present, #expected, #errors))
for _, message in ipairs(errors) do warn("[KAGEBOUND][WorldArtQA] " .. message) end
if #errors == 0 then
    print("[KAGEBOUND][WorldArtQA] Static Studio scene checks passed; multiplayer, visual and mobile QA still required")
end
