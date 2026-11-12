-- Reusable free Store geometry, stripped and adapted before activation.
assert(not game:GetService("RunService"):IsRunning(), "Edit mode required")
assert(game.PlaceId==92077795105213,"Wrong place")
local storage=game.ServerStorage
local originals=assert(storage:FindFirstChild("KageboundCreatorStoreReview"))
local clone=require(game.ServerScriptService.KageboundServer.CosmeticWorldArt).Clone
local library=assert(storage:FindFirstChild("KageboundStoreArt"))
local report={}
local function install(source,name,height,id,creator,variant)
    if library:FindFirstChild(name) then return end
    local copy=assert(clone(source))
    if copy:IsA("BasePart") then local model=Instance.new("Model");copy.Parent=model;copy=model end
    -- Keep only rendering geometry: discard input/UI, constraints, sounds and logic.
    for _,v in ipairs(copy:GetDescendants()) do
        if not (v:IsA("BasePart") or v:IsA("Model") or v:IsA("Folder")
            or v:IsA("SurfaceAppearance") or v:IsA("DataModelMesh") or v:IsA("Decal") or v:IsA("Texture")) then
            v:Destroy()
        end
    end
    for _,v in ipairs(copy:GetDescendants()) do
        if v:IsA("BasePart") then
            if variant=="cliff" then v.Color=Color3.fromRGB(83,86,108);v.Material=Enum.Material.Slate
            elseif variant=="shrine" or variant=="frost" then
                local c=v.Color
                if c.R>c.G*1.25 then v.Color=Color3.fromRGB(154,47,72)
                elseif c.R+c.G+c.B<1 then v.Color=Color3.fromRGB(32,35,56)
                elseif c.R+c.G+c.B>2.3 then v.Color=variant=="frost" and Color3.fromRGB(215,229,239) or Color3.fromRGB(234,219,231) end
            end
        end
    end
    local _,size=copy:GetBoundingBox()
    copy:ScaleTo(copy:GetScale()*height/size.Y)
    copy:PivotTo(CFrame.identity)
    local box,bounds=copy:GetBoundingBox()
    copy:PivotTo(CFrame.new(-box.X,bounds.Y/2-box.Y,-box.Z))
    copy.WorldPivot=CFrame.identity
    copy.Name=name
    copy:SetAttribute("SourceAssetId",id);copy:SetAttribute("SourceCreator",creator)
    copy:SetAttribute("ArtReference","ART-001/004; WORLD_VISION")
    copy:SetAttribute("ArtStatus","adapted draft; final visual/device QA pending")
    copy.Parent=library
    local parts=0 for _,p in ipairs(copy:GetDescendants()) do if p:IsA("BasePart") then parts+=1 end end
    table.insert(report,{name=name,parts=parts,height=height})
end
local cliff=assert(originals:FindFirstChild("Review_Cliff_79063123394886")):FindFirstChildWhichIsA("MeshPart",true)
-- Extract the single mesh, excluding its 400+ descendants of unrelated UI/runtime.
local mesh=assert(cliff):Clone()
for _,child in ipairs(mesh:GetChildren()) do
    if not child:IsA("SurfaceAppearance") and not child:IsA("DataModelMesh") then child:Destroy() end
end
install(mesh,"Cliff",54,79063123394886,"Thisfros1046","cliff")
mesh:Destroy()
local shrine=assert(originals:FindFirstChild("Review_Shrine_16014204266"))
install(shrine,"GrandShrine",42,16014204266,"kedyhizm","shrine")
install(shrine,"FrozenShrine",32,16014204266,"kedyhizm","frost")
local pines=assert(originals:FindFirstChild("Review_Pine_8559395722"))
install(assert(pines:FindFirstChild("SpruceSnowy4",true)),"SnowPine",28,8559395722,"Cliosow","pine")
game:GetService("ChangeHistoryService"):SetWaypoint("KAGEBOUND adapted regional landmarks")
return report
