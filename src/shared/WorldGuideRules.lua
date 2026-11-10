-- Grand World P1: original NPC waypoint and exploration policy.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KageboundShared")
local Regions=require(Shared:WaitForChild("RegionRules"))
local Guide={}
Guide.NPCs={
    {id="DojoGuide",name="Elder Kaito",region="KageDojo",offset=Vector3.new(35,3,-35),role="Travel Mentor",destination="MoonfallBamboo"},
    {id="MoonfallScout",name="Scout Hana",region="MoonfallBamboo",offset=Vector3.new(42,3,35),role="Yokai Tracker",destination="ShogunLastCity"},
    {id="CityArchivist",name="Archivist Ren",region="ShogunLastCity",offset=Vector3.new(-38,3,30),role="Veil Historian",destination="YomiRift"},
}
function Guide.Position(npc)
    local region=npc and Regions.ById(npc.region)
    if not region then return nil end
    return Vector3.new(region.x,0,region.z)+npc.offset
end
function Guide.Find(id)
    if typeof(id)~="string" then return nil end
    for _,npc in ipairs(Guide.NPCs) do
        if npc.id==id then return npc end
    end
    return nil
end
return Guide
