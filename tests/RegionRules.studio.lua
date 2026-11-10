-- Studio-only Grand World P1 region policy tests.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KageboundShared")
local World=require(Shared:WaitForChild("WorldConfig"))
local Regions=require(Shared:WaitForChild("RegionRules"))
assert(#World.Zones==5)
for _,zone in ipairs(World.Zones) do
    local at=Regions.At(Vector3.new(zone.x,0,zone.z))
    assert(at and at.id==zone.id,"Region center must resolve: "..zone.id)
    assert(Regions.ById(zone.id)==zone)
end
assert(Regions.ById("Unknown")==nil)
assert(Regions.At("invalid")==nil)
assert(Regions.IsConnected("KageDojo","MoonfallBamboo"))
assert(Regions.IsConnected("MoonfallBamboo","KageDojo"))
assert(not Regions.IsConnected("MoonfallBamboo","YomiRift"))
print("Grand World region policy PASS; requires multiplayer Studio runtime QA")
