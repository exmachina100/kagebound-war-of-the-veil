-- Run after Rojo sync; does not substitute for 2-player travel QA.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KageboundShared")
local Guides=require(Shared:WaitForChild("WorldGuideRules"))
local Regions=require(Shared:WaitForChild("RegionRules"))
assert(#Guides.NPCs==3)
for _,npc in ipairs(Guides.NPCs) do
    assert(Guides.Find(npc.id)==npc)
    assert(Regions.ById(npc.region))
    assert(Regions.ById(npc.destination))
    assert(Guides.Position(npc)~=nil)
    assert(npc.id~=npc.destination)
end
assert(Guides.Find("Unknown")==nil)
print("World guide policy PASS; live quest and prompt QA pending")
