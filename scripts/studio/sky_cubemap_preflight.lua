-- KAGEBOUND sky cubemap preflight (run in Studio Command Bar after publishing).
-- Does not invent IDs or change the active fallback.
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared = ReplicatedStorage:WaitForChild("KageboundShared")
local cfg = require(shared:WaitForChild("SkyConfig"))
local registry = require(shared:WaitForChild("RuntimeAssetRegistry"))
local suffixes = {"Bk", "Dn", "Ft", "Lf", "Rt", "Up"}
local missing = {}
local resolved = {}
for _, face in ipairs(suffixes) do
    local id = cfg.Faces[face]
    local path = "ui.skybox.moonfall.v01." .. string.lower(face)
    local uri = type(id) == "number" and id > 0 and ("rbxassetid://" .. id) or registry.get(path)
    if type(uri) ~= "string" or not uri:match("^rbxassetid://%d+$") then
        table.insert(missing, face)
    else
        resolved[face] = uri
    end
end
if #missing > 0 then
    warn("[KAGEBOUND SKY QA] Missing confirmed IDs: " .. table.concat(missing, ", "))
else
    print("[KAGEBOUND SKY QA] All six image references exist; visually inspect seams, face orientation and moderation in Studio.")
    for _, face in ipairs(suffixes) do print(face, resolved[face]) end
end
local sky = Lighting:FindFirstChild("KageboundSky")
assert(sky and sky:IsA("Sky"), "KageboundSky missing")
print("[KAGEBOUND SKY QA] Fallback remains managed by WorldSky.server.lua")
