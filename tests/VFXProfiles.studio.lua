-- KAGEBOUND class VFX policy contract — SERVER Command Bar.
-- These are original visual profiles, not proof all class gameplay is implemented.
local Profiles=require(game.ReplicatedStorage.KageboundShared:WaitForChild("VFXProfiles"))
local expected={"Shinobi","Ronin","Onmyoji","Oni Disciple"}
local function check(label,ok)
    assert(ok,"[KAGEBOUND VFX PROFILE FAIL] "..label)
    print("[KAGEBOUND VFX PROFILE PASS] "..label)
end
for _,name in ipairs(expected) do
    local p=Profiles.Get(name)
    check(name.." has three palette colors",typeof(p.core)=="Color3"
        and typeof(p.edge)=="Color3" and typeof(p.defense)=="Color3")
    check(name.." has a GitHub concept sheet",p.board:find("assets/concept-sheets/clan-vfx-v01/",1,true)==1)
    check(name.." has six art directions",#p.abilities==6)
end
check("Fallback is Shinobi",Profiles.Get("Unknown")==Profiles.Get("Shinobi"))
check("Onmyoji motif distinct from Oni",Profiles.Get("Onmyoji").motif~=Profiles.Get("Oni Disciple").motif)
check("All three mask profiles",Profiles.GetMask("Kitsune")~=nil and Profiles.GetMask("Oni")~=nil and Profiles.GetMask("Tengu")~=nil)
print("[KAGEBOUND] All four visual languages mapped to uploaded concept boards.")
