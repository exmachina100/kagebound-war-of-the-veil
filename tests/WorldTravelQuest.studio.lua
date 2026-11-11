-- Studio policy assertions for world travel quest data and progression.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KageboundShared")
local Guides=require(Shared:WaitForChild("WorldGuideRules"))
local Regions=require(Shared:WaitForChild("RegionRules"))
local visited={}
for _,npc in ipairs(Guides.NPCs) do
    assert(not visited[npc.id],"Duplicate quest id")
    visited[npc.id]=true
    assert(Regions.IsConnected(npc.region,npc.destination),"Quest must follow a connected world route")
    assert(Regions.At(Guides.Position(npc)).id==npc.region,"NPC must be in assigned region")
end
print("Grand World travel-quest topology PASS; two-client quest QA pending")
