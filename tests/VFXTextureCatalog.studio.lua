-- KAGEBOUND VFX texture catalog contract: Studio SERVER Command Bar.
-- Checks slot definitions and empty/unpublished-ID fallback behavior.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KageboundShared")
local Catalog=require(Shared:WaitForChild("VFXTextureCatalog"))
local function check(label,value)
    assert(value,"[KAGEBOUND VFX TEXTURE FAIL] "..label)
    print("[KAGEBOUND VFX TEXTURE PASS] "..label)
end
for _,name in ipairs({"Shinobi","Ronin","Onmyoji","Oni","Kitsune","Tengu","Parry"}) do
    check("Atlas filename exists for "..name,typeof(Catalog.Files[name])=="string"
        and Catalog.Files[name]:match("%.png$")~=nil)
end
check("No fake texture IDs in default catalog",Catalog.Resolve("Shinobi")==nil)
check("Unknown slot rejected",Catalog.Resolve("NotAnAbility")==nil)
-- After real Roblox uploads, replace the empty-ID test with an expected,
-- published URI, then run this and the two-client visual test again.
print("[KAGEBOUND] Sprite atlas catalog available; Roblox upload/permissions still require visual QA.")
