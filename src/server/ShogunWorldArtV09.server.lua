-- KAGEBOUND Shogun's Last City v09 optional art placement.
-- Only imported models from ServerStorage are used; existing world collision remains authoritative.
local CosmeticWorldArt = require(script.Parent:WaitForChild("CosmeticWorldArt"))
local ServerStorage=game:GetService("ServerStorage")
local Workspace=game:GetService("Workspace")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local cfg=require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("WorldConfig"))
if not cfg.Enabled then return end
local source=ServerStorage:FindFirstChild("KageboundWorldArt")
if not source then return end
local world=Workspace:WaitForChild("KageboundWorld",60)
if not world then return end
local zone
for _,candidate in ipairs(cfg.Zones) do
    if candidate.id=="ShogunLastCity" then zone=candidate break end
end
if not zone then return end
local parent=Instance.new("Folder")
parent.Name="ShogunImportedArtV09"
parent.Parent=world
local placements={
    {"shogun_citadel_gate",0,-78,0,3.0},
    {"shogun_pagoda_watchtower",-130,45,15,2.5},
    {"shogun_city_wall_module",-48,-82,0,3.0},
    {"shogun_city_wall_module",48,-82,0,3.0},
    {"shogun_guard_watchpost",130,-65,0,2.5},
    {"shogun_market_shop",-70,85,90,2.5},
    {"shogun_market_shop",75,95,-90,2.5},
    {"shogun_stone_stairway",0,66,180,2.2},
    {"shogun_canal_arch_bridge",0,140,0,2.0},
    {"shogun_street_lantern",-30,-50,0,2.5},
    {"shogun_street_lantern",30,-50,0,2.5},
}
local placed=0
for _,entry in ipairs(placements) do
    local prefab=source:FindFirstChild(entry[1])
    if prefab and (prefab:IsA("Model") or prefab:IsA("BasePart")) then
        local instance = CosmeticWorldArt.Clone(prefab)
        if instance then
            instance.Name=entry[1]
            local cf=CFrame.new(zone.x+entry[2],1.76,zone.z+entry[3])*CFrame.Angles(0,math.rad(entry[4]),0)
            if instance:IsA("Model") then
                instance:ScaleTo(entry[5])
                instance:PivotTo(cf)
            else
                instance.Size*=entry[5]
                instance.CFrame=cf
            end
            instance.Parent = parent
            placed+=1
        end
    end
end
print("[KAGEBOUND Shogun WorldArt] "..placed.." optional prefabs placed; greybox collision preserved")
