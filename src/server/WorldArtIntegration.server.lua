-- KAGEBOUND world-art placement layer. Never changes combat or authoritative gameplay.
-- Import approved mesh prefabs into ServerStorage/KageboundWorldArt in Roblox Studio.
-- Prefab names match manifest asset keys. Missing prefabs fail closed, preserving greybox.
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local cfg = require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("WorldConfig"))
if not cfg.Enabled then return end
local source = ServerStorage:FindFirstChild("KageboundWorldArt")
if not source then
    warn("[KAGEBOUND WorldArt] Import prefabs into ServerStorage/KageboundWorldArt; no visual replacement attempted")
    return
end
local world = Workspace:WaitForChild("KageboundWorld", 60)
if not world then return end
local zoneById = {}
for _, zone in ipairs(cfg.Zones) do zoneById[zone.id] = zone end
local placements = {
    {zone="KageDojo", prefab="dojo_fox_emblem_gate", x=0, z=-78, yaw=0, scale=2.8},
    {zone="KageDojo", prefab="dojo_kitsune_shrine_altar", x=0, z=31, yaw=180, scale=2.3},
    {zone="KageDojo", prefab="moonfall_spirit_waystone", x=-28, z=22, yaw=20, scale=1.7},
    {zone="MoonfallBamboo", prefab="moonfall_moss_rock_arch", x=0, z=-72, yaw=0, scale=3.0},
    {zone="MoonfallBamboo", prefab="moonfall_spirit_waystone", x=31, z=18, yaw=130, scale=2.0},
    {zone="MoonfallBamboo", prefab="dojo_fox_emblem_gate", x=-45, z=45, yaw=70, scale=2.0},
}
local artFolder = Instance.new("Folder")
artFolder.Name = "ImportedEnvironmentArt"
artFolder.Parent = world
local count=0
for _, item in ipairs(placements) do
    local zone=zoneById[item.zone]
    local prefab=source:FindFirstChild(item.prefab)
    if zone and prefab and (prefab:IsA("Model") or prefab:IsA("BasePart")) then
        local copy=prefab:Clone()
        copy.Name=item.prefab
        copy.Parent=artFolder
        if copy:IsA("Model") then
            copy:ScaleTo(item.scale)
            copy:PivotTo(CFrame.new(zone.x+item.x, 1.76, zone.z+item.z)*CFrame.Angles(0, math.rad(item.yaw), 0))
        else
            copy.Size*=item.scale
            copy.CFrame=CFrame.new(zone.x+item.x, 1.76, zone.z+item.z)*CFrame.Angles(0, math.rad(item.yaw), 0)
        end
        for _, part in ipairs(copy:IsA("Model") and copy:GetDescendants() or {copy}) do
            if part:IsA("BasePart") then
                part.Anchored=true
                part.CanCollide=false -- Original greybox remains collision authority until QA
                part.CanTouch=false
            end
        end
        count+=1
    end
end
print("[KAGEBOUND WorldArt] Placed "..count.." imported visual prefabs; greybox collision preserved")
