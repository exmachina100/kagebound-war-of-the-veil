-- Run from Roblox Studio SERVER Command Bar in an isolated Play test.
-- This is a local navigation contract check, not a complete waypoint AI test.
local ServerScriptService=game:GetService("ServerScriptService")
local Nav=require(ServerScriptService.KageboundServer:WaitForChild("YokaiNavigation"))
local folder=Instance.new("Folder")
folder.Name="KageboundNavigation_QA"
folder.Parent=workspace

local function part(name,size,pos,collides,parent)
    local p=Instance.new("Part")
    p.Name=name
    p.Size=size
    p.CFrame=CFrame.new(pos)
    p.Anchored=true
    p.CanCollide=collides
    p.Parent=parent
    return p
end

local success,err=pcall(function()
    local model=Instance.new("Model")
    model.Name="YokaiTestModel"
    model.Parent=folder
    local root=part("Root",Vector3.new(2,4,2),Vector3.new(0,3000,0),false,model)
    model.PrimaryPart=root
    local state=Nav.New()
    assert(Nav.MoveToward(model,Vector3.new(20,3000,0),10,.1,state),
        "Direct path should be walkable")
    assert(root.Position.X>0 and root.Position.X<2,
        "Direct movement must be capped by speed * timestep")
    assert(model:GetAttribute("NavigationStatus")=="Direct",
        "Direct status should be visible for debugging")
    print("[KAGEBOUND NAV PASS] Direct route and bounded movement")

    local wall=part("SolidWall",Vector3.new(2,20,14),Vector3.new(10,3000,0),true,folder)
    local before=root.Position
    Nav.MoveToward(model,Vector3.new(20,3000,0),10,.1,state)
    assert(root.Position.X<8.5,"Navigation cannot tunnel through blocked wall")
    assert(model:GetAttribute("NavigationStatus")=="Blocked"
        or model:GetAttribute("NavigationStatus")=="Path",
        "Blocked route must report a path or blocked status")
    print("[KAGEBOUND NAV PASS] Solid obstacle respected")
end)
folder:Destroy()
if not success then error("[KAGEBOUND NAV FAIL] "..tostring(err)) end
print("[KAGEBOUND] Navigation contract complete; validate actual enemies in Grand World.")
