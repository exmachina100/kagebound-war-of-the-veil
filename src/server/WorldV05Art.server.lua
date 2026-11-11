-- Native source-controlled templates; no uploads or network asset loads at runtime.
-- Cosmetic draft placements. Existing world collision and gameplay remain intact.
local ServerStorage=game:GetService("ServerStorage")
local Workspace=game:GetService("Workspace")
local World=require(game.ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("WorldConfig"))
if not World.Enabled then return end
local templates=ServerStorage:WaitForChild("KageboundWorldV05",30)
local world=Workspace:WaitForChild("KageboundWorld",60)
if not templates or not world then
    warn("[KAGEBOUND V05] Native templates or world missing; keeping procedural fallback")
    return
end
if world:FindFirstChild("ImportedV05Art") then return end
local folder=Instance.new("Folder")
folder.Name="ImportedV05Art"
folder.Parent=world
-- These three noncolliding appearances can be added without changing traversal.
-- Roof/court/bridge remain available as templates until their collision/placement QA.
local placements={
    {name="dojo_offering_pavilion",zone="KageDojo",x=-75,z=45,scale=3,parts=11},
    {name="moonfall_ritual_lantern",zone="KageDojo",x=-52,z=58,scale=1.8,parts=11},
    {name="moonfall_bamboo_canopy",zone="MoonfallBamboo",x=95,z=60,scale=2.2,parts=126},
}
local zones={}
for _,zone in ipairs(World.Zones) do zones[zone.id]=zone end
local installed=0
for _,entry in ipairs(placements) do
    local zone=zones[entry.zone]
    local district=world:WaitForChild(entry.zone,30)
    local template=templates:FindFirstChild(entry.name)
    if zone and district and template and template:IsA("Model") then
        local clone=template:Clone()
        local count=0
        local valid=true
        for _,item in ipairs(clone:GetDescendants()) do
            if item:IsA("LuaSourceContainer") then valid=false end
            if item:IsA("BasePart") then
                count+=1
                item.Anchored=true
                item.CanCollide=false
                item.CanTouch=false
                item.CanQuery=false
            end
        end
        if valid and count==entry.parts then
            local x,z=zone.x+entry.x,zone.z+entry.z
            local params=RaycastParams.new()
            params.FilterType=Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances={folder}
            params.RespectCanCollide=true
            local ground=Workspace:Raycast(Vector3.new(x,250,z),Vector3.new(0,-500,0),params)
            if ground and ground.Instance:IsDescendantOf(world) then
                clone:ScaleTo(entry.scale)
                clone:PivotTo(CFrame.new(x,ground.Position.Y,z))
                clone:SetAttribute("KageboundAssetStage","ImportedDraft")
                clone:SetAttribute("KageboundVisualReference","ART-001/004")
                clone.Parent=folder
                installed+=1
            else
                clone:Destroy()
                warn("[KAGEBOUND V05] Ground missing for "..entry.name)
            end
        else
            clone:Destroy()
            warn("[KAGEBOUND V05] Template rejected: "..entry.name)
        end
    end
    task.wait()
end
print(("[KAGEBOUND V05] %d cosmetic drafts installed; six native templates available"):format(installed))
