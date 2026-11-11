-- Run in Roblox Studio Server Command Bar. Requires a real player and world spawn.
-- Manual acceptance: talk to Elder Kaito, walk to Moonfall Bamboo,
-- confirm +10 shards and Journeys 1/3; repeat prompt cannot double-award.
-- Next speak to Scout Hana, reach Shogun's Last City, then Archivist Ren → Yomi Rift.
-- Verify two players receive independent rewards; client attribute spoofing
-- does not alter server-owned RewardService.Snapshot; leaving resets session.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KageboundShared")
local Guides=require(Shared:WaitForChild("WorldGuideRules"))
local Policy=require(Shared:WaitForChild("RewardPolicy"))
local seen={}
for _,npc in ipairs(Guides.NPCs) do
    assert(not seen[npc.id], "duplicate guide receipt token")
    seen[npc.id]=true
    assert(type(npc.destination)=="string")
    assert(Policy.ValidKey(npc.id))
end
assert(Policy.Get("TravelGuide").shards==10)
assert(#Guides.NPCs==3)
print("Travel guide reward contract PASS; Studio multiplayer integration unverified")
