-- KAGEBOUND animation presentation contract (run via Studio SERVER Command Bar).
-- Requirements are recorded before implementing the driver.
-- Does not prove an uploaded animation is available or visually correct.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KageboundShared")
local Catalog=require(Shared:WaitForChild("AnimationCatalog"))
local Rules=require(Shared:WaitForChild("CombatRules"))
local function check(name,ok)
    assert(ok,"[KAGEBOUND ANIMATION FAIL] "..name)
    print("[KAGEBOUND ANIMATION PASS] "..name)
end
check("Shinobi library exists",typeof(Catalog.Shinobi)=="table")
check("All five attack/defense slots exist",
    Catalog.Shinobi.Light1~=nil and Catalog.Shinobi.Light2~=nil
    and Catalog.Shinobi.Light3~=nil and Catalog.Shinobi.Heavy~=nil
    and Catalog.Shinobi.Parry~=nil)
check("Unpublished slots have no fabricated asset IDs",
    Catalog.Resolve(Catalog.Shinobi.Light1)==nil)
check("Reject non-digit animation URI",Catalog.Resolve("rbxassetid://fake")==nil)
check("Resolve real numeric ID",Catalog.Resolve("123456")=="rbxassetid://123456")
check("Resolve numeric asset URI",Catalog.Resolve("rbxassetid://98765")=="rbxassetid://98765")
check("Reject zero and negative",Catalog.Resolve("0")==nil and Catalog.Resolve("-10")==nil)
check("Light strike remains server-timed",Rules.AttackTimeline.Light.windup>0
    and Rules.AttackTimeline.Light.active>0)
print("[KAGEBOUND] Animation contract prepared; verify in Studio before signoff.")
