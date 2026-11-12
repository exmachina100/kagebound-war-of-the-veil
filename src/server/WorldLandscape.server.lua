-- Five authored regional landscapes, ART-001/004 and WORLD_VISION.
-- Native Terrain is additive and route-aware; never clears pre-existing terrain.
local Shared=game.ReplicatedStorage:WaitForChild("KageboundShared")
local Config=require(Shared:WaitForChild("WorldConfig"))
if not Config.Enabled then return end
local Rules=require(Shared:WaitForChild("LandscapeRules"))
local Clone=require(script.Parent:WaitForChild("CosmeticWorldArt")).Clone
local world=workspace:WaitForChild("KageboundWorld",60)
if not world or world:FindFirstChild("RegionalLandscapes") then return end
local library=game.ServerStorage:FindFirstChild("KageboundStoreArt")
local source=game.ServerStorage:FindFirstChild("KageboundWorldArtV08")
local fullRoofSource=game.ServerStorage:FindFirstChild("KageboundWorldV05")
local root=Instance.new("Folder");root.Name="RegionalLandscapes";root.Parent=world
local Terrain=workspace.Terrain
local zones={}
for _,z in ipairs(Config.Zones) do zones[z.id]=z end
local palette=Config.Palette
local function part(parent,name,size,cf,color,material,collision)
    local p=Instance.new("Part")
    p.Name=name;p.Size=size;p.CFrame=cf;p.Color=color;p.Material=material
    p.Anchored=true;p.CanCollide=collision==true;p.CanTouch=false;p.CanQuery=collision==true
    p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
    p.Parent=parent
    return p
end
local function prefab(parent,name,position,yaw,scale,tint)
    local template=(library and library:FindFirstChild(name)) or (source and source:FindFirstChild(name))
        or (fullRoofSource and fullRoofSource:FindFirstChild(name))
    if not template then return nil end
    local copy=Clone(template)
    if not copy then return nil end
    if copy:IsA("Model") then copy:ScaleTo(copy:GetScale()*(scale or 1)) end
    if name=="dojo_curved_roof" and copy:IsA("Model") then
        -- v05 roofs are authored at pavilion eave height, not at ground zero.
        -- Normalize a detached roof's base before placing it on a new tower.
        local box,size=copy:GetBoundingBox()
        copy.WorldPivot=CFrame.new(box.X,box.Y-size.Y/2,box.Z)
    end
    if tint then for _,p in ipairs(copy:GetDescendants()) do if p:IsA("BasePart") then p.Color=tint end end end
    copy.Name=name
    copy:PivotTo(CFrame.new(position)*CFrame.Angles(0,math.rad(yaw or 0),0))
    copy.Parent=parent
    return copy
end
local function stairs(folder,z,x,startZ,count,width,rise)
    for i=0,count-1 do
        part(folder,"WalkableStair",Vector3.new(width,.8,4.2),CFrame.new(z.x+x,1.76+i*rise,z.z+startZ+i*4),palette.stone,Enum.Material.Slate,true)
    end
end
local function lantern(parent,pos)
    return prefab(parent,"StoneLantern",pos,0,.8)
end
local function solidRoof(parent,position,width,depth,height)
    for _,side in ipairs({-1,1}) do
        local wedge=Instance.new("WedgePart")
        wedge.Name="WalkableCurvedRoofCore";wedge.Size=Vector3.new(width,height,depth/2)
        wedge.CFrame=CFrame.new(position+Vector3.new(0,height/2,side*depth/4))
            * CFrame.Angles(0,side==1 and math.pi or 0,0)
        wedge.Color=Color3.fromRGB(48,48,72);wedge.Material=Enum.Material.Slate
        wedge.Anchored=true;wedge.CanCollide=true;wedge.CanTouch=false;wedge.Parent=parent
        part(parent,"VermilionEave",Vector3.new(width+1,.5,.7),CFrame.new(position+Vector3.new(0,.2,side*depth/2)),palette.vermilion,Enum.Material.Wood,false)
    end
    part(parent,"GoldRoofRidge",Vector3.new(width+.8,.4,.5),CFrame.new(position+Vector3.new(0,height,0)),palette.warm,Enum.Material.Metal,false)
end
local function timberFacade(parent,body)
    -- Broad plaster panels and timber rhythm read at gameplay distance.
    for side=0,3 do
        local width=side%2==0 and body.Size.X or body.Size.Z
        local depth=side%2==0 and body.Size.Z or body.Size.X
        local face=body.CFrame*CFrame.Angles(0,side*math.pi/2,0)*CFrame.new(0,0,-depth/2-.12)
        part(parent,"ShojiPlaster",Vector3.new(width-1,body.Size.Y-2,.15),face,Color3.fromRGB(169,157,174),Enum.Material.SmoothPlastic,false)
        for _,x in ipairs({-width*.44,0,width*.44}) do
            part(parent,"TimberUpright",Vector3.new(.6,body.Size.Y,.35),face*CFrame.new(x,0,-.2),palette.vermilion,Enum.Material.Wood,false)
        end
        local floors=math.max(1,math.floor(body.Size.Y/12))
        for floor=0,floors do
            local y=-body.Size.Y/2+1+floor*(body.Size.Y-2)/floors
            part(parent,"TimberCrossbeam",Vector3.new(width,.65,.4),face*CFrame.new(0,y,-.25),palette.ink,Enum.Material.Wood,false)
        end
        for _,x in ipairs({-width*.24,width*.24}) do
            part(parent,"WarmShojiWindow",Vector3.new(3,4,.12),face*CFrame.new(x,body.Size.Y*.18,-.3),Color3.fromRGB(194,132,75),Enum.Material.Neon,false)
        end
    end
end
local function terrainRing(folder,z)
    local hills=0
    for i=1,18 do
        local a=i*math.pi*2/18+.12
        local radius=28+(i%4)*7
        local distance=z.radius-35+(i%3)*16
        local x,zz=z.x+math.cos(a)*distance,z.z+math.sin(a)*distance
        local height=z.id=="FrozenShrine" and 65+(i%4)*19 or 22+(i%4)*8
        -- Include the reused mesh footprint, not only the Terrain sphere.
        if Rules.CanPlaceHill(Vector2.new(x,zz),math.max(radius,height*.85),Config.Zones,Config.Routes) then
            local material=z.id=="FrozenShrine" and Enum.Material.Glacier or Enum.Material.Rock
            Terrain:FillBall(Vector3.new(x,1,zz),radius,material)
            Terrain:FillBall(Vector3.new(x,height*.35,zz),radius*.8,material)
            Terrain:FillBall(Vector3.new(x,height*.65,zz),radius*.55,material)
            local top=z.id=="FrozenShrine" and Enum.Material.Snow or Enum.Material.Grass
            if z.id~="YomiRift" then Terrain:FillBall(Vector3.new(x,height*.8,zz),radius*.45,top) end
            if z.id~="FrozenShrine" then prefab(folder,"Cliff",Vector3.new(x,0,zz),i*37,height/54) end
            hills+=1
        end
        if i%3==0 then task.wait() end
    end
    folder:SetAttribute("TerrainHills",hills)
end
for _,z in ipairs(Config.Zones) do
    local folder=Instance.new("Folder");folder.Name=z.id;folder.Parent=root
    folder:SetAttribute("Reference","ART-001/004 + WORLD_VISION")
    terrainRing(folder,z)
    if z.id=="KageDojo" then
        local district=world:FindFirstChild(z.id)
        if district then
            for _,building in ipairs(district:GetChildren()) do
                if building:IsA("BasePart") and building.Name=="DojoHouse" then timberFacade(folder,building)
                elseif building:IsA("BasePart") and building.Name=="DojoRoof" then
                    building.Transparency=1
                    solidRoof(folder,building.Position-Vector3.new(0,2,0),building.Size.X,building.Size.Z,7)
                    prefab(folder,"dojo_curved_roof",building.Position-Vector3.new(0,2,0),0,3.8)
                end
            end
        end
        -- Main shrine aligns with the existing lantern procession. Hide only the
        -- earlier decorative pavilion; its authoritative world geometry is untouched.
        local old=world:FindFirstChild("ImportedWorldArtV08")
        if old then local p=old:FindFirstChild("dojo_shrine_pavilion");if p then p:Destroy() end end
        prefab(folder,"GrandShrine",Vector3.new(0,1.76,-165),180,1)
        for _,x in ipairs({-52,52}) do
            for _,zz in ipairs({-120,-180}) do prefab(folder,"Bamboo",Vector3.new(x,1.76,zz),x,.8) end
        end
    elseif z.id=="MoonfallBamboo" then
        local district=world:FindFirstChild(z.id)
        if district then for _,p in ipairs(district:GetChildren()) do
            if p:IsA("BasePart") and p.Name=="BambooCrown" then p.Transparency=1 end
        end end
        -- East shrine terrace leaves north/south travel and enemy center clear.
        stairs(folder,z,145,-45,18,12,.75)
        part(folder,"ShrineTerrace",Vector3.new(72,3,45),CFrame.new(z.x+145,13.75,z.z+45),palette.stone,Enum.Material.Slate,true)
        prefab(folder,"dojo_shrine_pavilion",Vector3.new(z.x+145,15.25,z.z+45),180,2.2)
        prefab(folder,"dojo_torii_signature",Vector3.new(z.x+145,1.76,z.z-55),0,2)
        for i=1,22 do
            local a=i*2.39996
            local d=95+(i%5)*22
            local x,zz=math.cos(a)*d,math.sin(a)*d
            if math.abs(x)>45 and not (x>110 and math.abs(zz)<80) then
                prefab(folder,"Bamboo",Vector3.new(z.x+x,1.76,z.z+zz),i*29,.75+(i%3)*.12)
            end
            if i%4==0 then task.wait() end
        end
        for _,zz in ipairs({-45,-10,25}) do lantern(folder,Vector3.new(z.x+133,2,z.z+zz)) end
        -- Decorative stream and waterfall do not replace walkable ground.
        local pool=part(folder,"MoonfallStream",Vector3.new(24,.25,105),CFrame.new(z.x-115,1.3,z.z-20),Color3.fromRGB(66,143,177),Enum.Material.Glass,false)
        pool.Transparency=.25
        local fall=part(folder,"Waterfall",Vector3.new(9,32,.4),CFrame.new(z.x-115,17,z.z-73),Color3.fromRGB(143,202,227),Enum.Material.Glass,false)
        fall.Transparency=.35
        prefab(folder,"Cliff",Vector3.new(z.x-115,0,z.z-88),90,.65)
    elseif z.id=="ShogunLastCity" then
        -- Apply full curved roofs to the original district towers too. Their
        -- existing roof collision remains, with the replacement mesh sized to it.
        local district=world:FindFirstChild(z.id)
        if district then
            for _,building in ipairs(district:GetChildren()) do
                if building:IsA("BasePart") and building.Name=="Tower" then
                    building.Color=Color3.fromRGB(65,57,83)
                    timberFacade(folder,building)
                    for window=1,3 do
                        part(folder,"LanternWindow",Vector3.new(4,5,.2),building.CFrame*CFrame.new((window-2)*8,building.Size.Y*.24,-building.Size.Z/2-.15),palette.warm,Enum.Material.Neon,false)
                    end
                elseif building:IsA("BasePart") and building.Name=="PagodaRoof" and fullRoofSource then
                    local roof=prefab(folder,"dojo_curved_roof",building.Position-Vector3.new(0,2,0),0,1)
                    if roof and roof:IsA("Model") then
                        local _,size=roof:GetBoundingBox()
                        roof:ScaleTo(roof:GetScale()*building.Size.X/size.X)
                        roof:PivotTo(CFrame.new(building.Position-Vector3.new(0,2,0)))
                        building.Transparency=1
                        solidRoof(folder,building.Position-Vector3.new(0,2,0),building.Size.X,building.Size.Z,7)
                    end
                end
            end
        end
        -- Tiered eaves replace the readability of flat block roofs; existing
        -- tower collision remains in GrandWorld.
        for i=1,6 do
            local x=((i-1)%3-1)*100
            local zz=100+math.floor((i-1)/3)*85
            if not Rules.RouteClear(Vector2.new(z.x+x,z.z+zz),24,Config.Zones,Config.Routes,18) then continue end
            local h=24+(i%3)*12
            local tower=part(folder,"CitadelTower",Vector3.new(29,h,29),CFrame.new(z.x+x,h/2+1,z.z+zz),palette.ink,Enum.Material.Wood,true)
            timberFacade(folder,tower)
            for upper=1,2 do
                part(folder,"UpperPagodaStorey",Vector3.new(29-upper*6,8,29-upper*6),CFrame.new(z.x+x,h-3+upper*8,z.z+zz),Color3.fromRGB(65,57,83),Enum.Material.Wood,true)
            end
            for tier=0,2 do
                prefab(folder,"dojo_curved_roof",Vector3.new(z.x+x,h+2+tier*8,z.z+zz),0,2.6-tier*.45)
                solidRoof(folder,Vector3.new(z.x+x,h+2+tier*8,z.z+zz),40-tier*8,38-tier*8,5)
            end
            lantern(folder,Vector3.new(z.x+x-17,1.76,z.z+zz-17))
            task.wait()
        end
        for _,x in ipairs({-52,52}) do
            part(folder,"CanalSurface",Vector3.new(17,.25,190),CFrame.new(z.x+x,1.3,z.z-10),Color3.fromRGB(67,116,150),Enum.Material.Glass,false).Transparency=.3
            prefab(folder,"moonfall_arch_bridge",Vector3.new(z.x+x,1.76,z.z+55),90,1.4)
        end
    elseif z.id=="FrozenShrine" then
        local district=world:FindFirstChild(z.id)
        if district then
            for _,ice in ipairs(district:GetChildren()) do
                if ice:IsA("BasePart") and ice.Name=="IceSpire" then
                    ice.Transparency=1;ice.CanCollide=false;ice.CanQuery=false
                    if Rules.CanPlaceHill(Vector2.new(ice.Position.X,ice.Position.Z),10,Config.Zones,Config.Routes) then
                        local shard=Instance.new("WedgePart")
                        shard.Name="WalkableIceShard";shard.Size=ice.Size;shard.CFrame=ice.CFrame*CFrame.Angles(0,ice.Position.X%6,0)
                        shard.Color=Color3.fromRGB(123,183,213);shard.Material=Enum.Material.Glacier
                        shard.Anchored=true;shard.CanCollide=true;shard.CanTouch=false;shard.Parent=folder
                    end
                end
            end
        end
        stairs(folder,z,0,110,24,15,.75)
        part(folder,"FrozenTempleTerrace",Vector3.new(90,4,45),CFrame.new(z.x,18,z.z+225),Color3.fromRGB(123,171,197),Enum.Material.Glacier,true)
        prefab(folder,"FrozenShrine",Vector3.new(z.x,20,z.z+225),180,1)
        prefab(folder,"dojo_torii_signature",Vector3.new(z.x,1.76,z.z+104),0,2.5,Color3.fromRGB(123,171,197))
        for i=1,18 do
            local a=i*2.39996
            local d=110+(i%4)*29
            local x,zz=math.cos(a)*d,math.sin(a)*d
            if math.abs(x)>32 then prefab(folder,"SnowPine",Vector3.new(z.x+x,1.76,z.z+zz),i*41,.8+(i%3)*.12) end
            if i%4==0 then task.wait() end
        end
        for i=0,3 do lantern(folder,Vector3.new(z.x-12,2+i*4.5,z.z+116+i*24)) end
    elseif z.id=="YomiRift" then
        local district=world:FindFirstChild(z.id)
        if district then for _,p in ipairs(district:GetChildren()) do
            if p:IsA("BasePart") and p.Name=="SpiritWisp" then
                p.Shape=Enum.PartType.Block;p.Size=Vector3.new(.35,3,.35);p.Color=palette.spirit
            end
        end end
        -- Static, clearly supported exploration platforms, separate from the
        -- warning-driven RegionalVeilfall collision system.
        for i=1,5 do
            local x=-135+(i-1)*54
            local y=5+(i%3)*7
            prefab(folder,"Cliff",Vector3.new(z.x+x,y-23,z.z+200),i*57,.45,Color3.fromRGB(68,53,103))
            part(folder,"SpiritIslandWalkable",Vector3.new(42,3,38),CFrame.new(z.x+x,y,z.z+200),palette.ink,Enum.Material.Slate,true)
            for _,side in ipairs({-1,1}) do
                part(folder,"SpiritIslandRim",Vector3.new(42,.25,.35),CFrame.new(z.x+x,y+1.6,z.z+200+side*19),palette.spirit,Enum.Material.Neon,false)
                part(folder,"SpiritIslandRim",Vector3.new(.35,.25,38),CFrame.new(z.x+x+side*21,y+1.6,z.z+200),palette.spirit,Enum.Material.Neon,false)
            end
            if i<5 then
                local nextY=5+((i+1)%3)*7
                local a=Vector3.new(z.x+x,y+1.8,z.z+200)
                local b=Vector3.new(z.x+x+54,nextY+1.8,z.z+200)
                part(folder,"StaticSpiritBridge",Vector3.new(10,1,(b-a).Magnitude+5),CFrame.lookAt((a+b)/2,b),palette.stone,Enum.Material.Slate,true)
            end
            task.wait()
        end
        stairs(folder,z,-135,106,16,12,.75)
        part(folder,"IslandAccessLanding",Vector3.new(12,1,36),CFrame.new(z.x-135,13,z.z+182),palette.stone,Enum.Material.Slate,true)
        prefab(folder,"dojo_torii_signature",Vector3.new(z.x,1.76,z.z-105),0,3,Color3.fromRGB(83,47,122))
        -- Rift silhouette: slender separated pillars, no opaque full-screen glow.
        for _,x in ipairs({-28,28}) do
            part(folder,"RiftPillar",Vector3.new(4,40,5),CFrame.new(z.x+x,21,z.z-105)*CFrame.Angles(0,0,math.rad(x>0 and -8 or 8)),palette.ink,Enum.Material.Slate,true)
            part(folder,"RiftSeam",Vector3.new(.35,30,5.2),CFrame.new(z.x+x,23,z.z-105),palette.spirit,Enum.Material.Neon,false)
        end
    end
    folder:SetAttribute("BuildComplete",true)
    task.wait()
end
root:SetAttribute("BuildComplete",true)
print("[KAGEBOUND] Five regional landscapes built; route corridors reserved")
