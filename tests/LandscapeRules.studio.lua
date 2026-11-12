-- Run in Studio Edit after syncing shared sources. No DataModel mutations.
local Shared=game.ReplicatedStorage.KageboundShared
local Rules=require(Shared.LandscapeRules)
local Config=require(Shared.WorldConfig)
assert(Rules.DistanceToSegment(Vector2.new(5,4),Vector2.new(0,0),Vector2.new(10,0))==4)
assert(Rules.DistanceToSegment(Vector2.new(-3,0),Vector2.new(0,0),Vector2.new(10,0))==3)
assert(Rules.DistanceToSegment(Vector2.new(3,4),Vector2.zero,Vector2.zero)==5)
for _,z in ipairs(Config.Zones) do
    assert(not Rules.CanPlaceHill(Vector2.new(z.x,z.z),35,Config.Zones,Config.Routes),z.id.." plaza obstructed")
end
local lookup={}
local samples=0
for _,z in ipairs(Config.Zones) do lookup[z.id]=Vector2.new(z.x,z.z) end
for _,e in ipairs(Config.Routes) do
    for i=0,10 do
        local p=lookup[e[1]]:Lerp(lookup[e[2]],i/10)
        assert(not Rules.CanPlaceHill(p,35,Config.Zones,Config.Routes),"Travel route obstructed")
        samples+=1
    end
end
assert(Rules.CanPlaceHill(Vector2.new(-1050,-550),30,Config.Zones,Config.Routes),"Clear highland site rejected")
return "PASS: distance edge cases, five reserved centers, "..samples.." travel-route samples and clear mountain site"
