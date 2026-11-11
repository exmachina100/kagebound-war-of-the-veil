-- Run manually in Roblox Studio Command Bar (server context).
-- Read-only asset import audit. No instances created, moved, or modified.
local ServerStorage=game:GetService("ServerStorage")
local Workspace=game:GetService("Workspace")
local art=ServerStorage:FindFirstChild("KageboundArt")
local world=Workspace:FindFirstChild("KageboundWorld")
local library=art and art:FindFirstChild("WorldEnvironment")
local anchors=world and world:FindFirstChild("ArtPlacementAnchors")
local worldNames={
"KageDojoShrine","DojoRitualAltar","DojoClanBanner","MoonfallBambooCluster",
"MoonfallBridge","MoonfallStonePath","MoonfallToriiGate","ShrineStoneLantern",
"DojoCeremonialTorii","DojoShrineArchedRoof","MoonfallSacredBamboo",
"DojoCurvedRoofModule","DojoShojiWall","MoonfallBambooTall",
"MoonfallFallenBamboo","MoonfallStoneLanternTall","ShrineRopeBell"}
local weaponNames={"VeilbladeVisual","NodachiVisual","TantoVisual","NaginataVisual","YariVisual"}
local counts={ready=0,missing=0,invalid=0,meshparts=0,unpublished=0}
local function checkParts(model,name)
    local parts={}
    if model:IsA("BasePart") then table.insert(parts,model) end
    for _,v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") then table.insert(parts,v) end
    end
    if #parts==0 then
        warn("[ASSET AUDIT] EMPTY "..name)
        counts.invalid+=1
        return false
    end
    for _,part in ipairs(parts) do
        if part:IsA("MeshPart") then
            counts.meshparts+=1
            if part.MeshId=="" then
                warn("[ASSET AUDIT] UNPUBLISHED MESH "..part:GetFullName())
                counts.unpublished+=1
            end
        end
    end
    return true
end
for _,name in ipairs(worldNames) do
    local model=library and library:FindFirstChild(name)
    local anchor=anchors and anchors:FindFirstChild(name)
    if not model or not anchor then
        counts.missing+=1
        warn("[ASSET AUDIT] WORLD MISSING "..name.." template="..tostring(model~=nil).." anchor="..tostring(anchor~=nil))
    elseif not (model:IsA("Model") or model:IsA("BasePart")) or not anchor:IsA("BasePart") then
        counts.invalid+=1
        warn("[ASSET AUDIT] WORLD INVALID TYPE "..name)
    elseif checkParts(model,name) then
        counts.ready+=1
    end
end
for _,name in ipairs(weaponNames) do
    local model=art and art:FindFirstChild(name)
    if not model then
        counts.missing+=1
        warn("[ASSET AUDIT] WEAPON MISSING "..name)
    elseif not model:IsA("Model") then
        counts.invalid+=1
        warn("[ASSET AUDIT] WEAPON NOT MODEL "..name)
    elseif checkParts(model,name) then
        counts.ready+=1
    end
end
print(("[ASSET AUDIT] %d/%d slots ready; missing=%d invalid=%d meshparts=%d empty MeshIds=%d"):format(
counts.ready,#worldNames+#weaponNames,counts.missing,counts.invalid,counts.meshparts,counts.unpublished))
-- This is a static Studio import check only, NOT combat, rigging, networking or device QA.
