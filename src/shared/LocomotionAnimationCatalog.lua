-- Original R15 locomotion asset slots. Empty means Roblox default Animate fallback.
-- Publish and verify KAGEBOUND-owned animations before inserting IDs.
local Catalog={}
Catalog.Universal={
    Idle="",CombatIdle="",WalkForward="",WalkBackward="",StrafeLeft="",StrafeRight="",
    Run="",Sprint="",Start="",Stop="",Pivot="",Jump="",Fall="",Land="",
    Dash="",Parry="",Stagger="",GuardBreak="",Veilfall="",
}
Catalog.Classes={Shinobi={},Ronin={},Onmyoji={},OniDisciple={}}
function Catalog.Resolve(className,state)
    if typeof(state)~="string" or Catalog.Universal[state]==nil then return nil end
    local variant=Catalog.Classes[className]
    local id=(variant and variant[state]) or Catalog.Universal[state]
    if typeof(id)~="string" then return nil end
    local digits=id:match("^rbxassetid://(%d+)$") or id:match("^(%d+)$")
    if not digits or tonumber(digits)==0 then return nil end
    return "rbxassetid://"..digits
end
return Catalog
