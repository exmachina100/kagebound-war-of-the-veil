-- KAGEBOUND Grand World v0.1. Server builds a connected exploration greybox.
-- Art anchors ART-001..ART-004; source of truth docs/WORLD_VISION.md.
-- This is a test environment, NOT final hand-modeled land or production streaming.
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local cfg=require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("WorldConfig"))
if not cfg.Enabled then return end
local previous=Workspace:FindFirstChild("KageboundWorld")
if previous then previous:Destroy() end
local world=Instance.new("Folder")
world.Name="KageboundWorld"
world.Parent=Workspace
local rootByName={}
local p=cfg.Palette
local function block(parent,name,size,cf,color,material,collides)
    local obj=Instance.new("Part")
    obj.Name=name
    obj.Size=size
    obj.CFrame=cf
    obj.Anchored=true
    obj.CanCollide=collides~=false
    obj.CanTouch=false
    obj.Material=material or Enum.Material.SmoothPlastic
    obj.Color=color
    obj.TopSurface=Enum.SurfaceType.Smooth
    obj.BottomSurface=Enum.SurfaceType.Smooth
    obj.Parent=parent
    return obj
end
local function ball(parent,name,pos,diameter,color)
    local part=block(parent,name,Vector3.new(diameter,diameter,diameter),CFrame.new(pos),color,Enum.Material.SmoothPlastic,false)
    part.Shape=Enum.PartType.Ball
    return part
end
local function path(parent,from,to,width,color)
    local delta=to-from
    local midpoint=(from+to)*.5
    return block(parent,"WalkablePath",Vector3.new(width,2,delta.Magnitude+4),CFrame.lookAt(midpoint,to),color,Enum.Material.Slate,true)
end
local function labelAt(parent,text,pos)
    local pole=block(parent,"MapMarker",Vector3.new(1,10,1),CFrame.new(pos),p.vermilion,Enum.Material.Wood)
    local gui=Instance.new("BillboardGui")
    gui.Name="RegionName"
    gui.Size=UDim2.fromOffset(240,62)
    gui.StudsOffsetWorldSpace=Vector3.new(0,9,0)
    gui.MaxDistance=300
    gui.AlwaysOnTop=true
    gui.Parent=pole
    local t=Instance.new("TextLabel")
    t.BackgroundColor3=p.ink
    t.BackgroundTransparency=.2
    t.Size=UDim2.fromScale(1,1)
    t.Text=text
    t.TextColor3=Color3.fromRGB(250,230,216)
    t.Font=Enum.Font.GothamBold
    t.TextScaled=true
    t.Parent=gui
end
local function torii(parent,x,z,size)
    local width=size*1.4
    for _,dx in ipairs({-width/2,width/2}) do
        block(parent,"ToriiPillar",Vector3.new(size*.13,size*1.4,size*.13),CFrame.new(x+dx,size*.7,z),p.vermilion,Enum.Material.Wood)
    end
    block(parent,"ToriiCrown",Vector3.new(width+size*.6,size*.15,size*.3),CFrame.new(x,size*1.43,z),p.vermilion,Enum.Material.Wood)
    block(parent,"ToriiBrace",Vector3.new(width,size*.08,size*.12),CFrame.new(x,size*1.12,z),p.ink,Enum.Material.Wood)
end
local function lantern(parent,x,z,accent)
    block(parent,"LanternPost",Vector3.new(1.4,7,1.4),CFrame.new(x,4,z),p.ink,Enum.Material.Wood)
    local light=block(parent,"Lantern",Vector3.new(3,3,3),CFrame.new(x,8.8,z),accent,Enum.Material.Neon,false)
    local point=Instance.new("PointLight")
    point.Color=accent
    point.Brightness=1
    point.Range=22
    point.Parent=light
end
-- One continuous walkable landmass, with roads to districts. No boxed-in battle arena.
block(world,"GrandWorldBase",Vector3.new(2700,7,2700),CFrame.new(0,-5,0),Color3.fromRGB(39,64,62),Enum.Material.Grass)
for _,z in ipairs(cfg.Zones) do
    local district=Instance.new("Folder")
    district.Name=z.id
    district.Parent=world
    rootByName[z.id]=district
    district:SetAttribute("Region",z.name)
    district:SetAttribute("Level",z.level)
    district:SetAttribute("Kind",z.kind)
    local baseY=.25
    block(district,"DistrictGround",Vector3.new(z.radius*2,1,z.radius*2),CFrame.new(z.x,baseY,z.z),z.tint,Enum.Material.Ground)
    block(district,"DistrictPlaza",Vector3.new(90,1,90),CFrame.new(z.x,1.25,z.z),p.stone,Enum.Material.Slate)
    labelAt(district,z.name.."  |  Lv "..z.level,Vector3.new(z.x,6,z.z-54))
    torii(district,z.x,z.z-78,22)
    for j=1,8 do
        local angle=(j/8)*math.pi*2
        lantern(district,z.x+math.cos(angle)*88,z.z+math.sin(angle)*88,z.accent)
    end
    if z.id=="KageDojo" then
        for i=1,6 do
            local a=i*math.pi/3
            local bx=z.x+math.cos(a)*120
            local bz=z.z+math.sin(a)*120
            block(district,"DojoHouse",Vector3.new(34,20,30),CFrame.new(bx,11,bz),p.ink,Enum.Material.Wood)
            block(district,"DojoRoof",Vector3.new(42,5,37),CFrame.new(bx,23,bz),p.vermilion,Enum.Material.Slate)
        end
        local spawn=Instance.new("SpawnLocation")
        spawn.Name="KageboundWorldSpawn"
        spawn.Anchored=true
        spawn.Neutral=true
        spawn.Size=Vector3.new(13,1,13)
        spawn.Position=Vector3.new(z.x,2.5,z.z)
        spawn.Duration=0
        spawn.Color=p.warm
        spawn.Material=Enum.Material.Neon
        spawn.Parent=district
    elseif z.id=="MoonfallBamboo" then
        for i=1,58 do
            local angle=i*2.399963
            local radius=120+(i%7)*23
            local x=z.x+math.cos(angle)*radius
            local zz=z.z+math.sin(angle)*radius
            local h=20+(i%5)*6
            block(district,"Bamboo",Vector3.new(1.6,h,1.6),CFrame.new(x,h/2+1,zz),Color3.fromRGB(47,107,73),Enum.Material.Wood,false)
            ball(district,"BambooCrown",Vector3.new(x,h+1,zz),5,Color3.fromRGB(41,81,67))
        end
    elseif z.id=="ShogunLastCity" then
        for i=1,14 do
            local x=z.x+((i-1)%5-2)*73
            local zz=z.z+(math.floor((i-1)/5)-1)*88
            local h=35+(i%4)*17
            block(district,"Tower",Vector3.new(33,h,33),CFrame.new(x,h/2+1,zz),p.ink,Enum.Material.Wood)
            block(district,"PagodaRoof",Vector3.new(44,4,44),CFrame.new(x,h+3,zz),p.vermilion,Enum.Material.Slate)
        end
    elseif z.id=="FrozenShrine" then
        for i=1,20 do
            local angle=i*2.399963
            local radius=105+(i%6)*29
            local x=z.x+math.cos(angle)*radius
            local zz=z.z+math.sin(angle)*radius
            local height=27+(i%4)*14
            block(district,"IceSpire",Vector3.new(13,height,13),CFrame.new(x,height/2+1,zz),z.accent,Enum.Material.Ice)
        end
    elseif z.id=="YomiRift" then
        for i=1,18 do
            local angle=i*2.399963
            local radius=100+(i%5)*28
            local x=z.x+math.cos(angle)*radius
            local zz=z.z+math.sin(angle)*radius
            local height=20+(i%5)*13
            block(district,"YomiMonolith",Vector3.new(10,height,10),CFrame.new(x,height/2+1,zz),p.ink,Enum.Material.Slate)
            ball(district,"SpiritWisp",Vector3.new(x,height+5,zz),4,p.spirit).Material=Enum.Material.Neon
        end
    end
    task.wait()
end
local roads=Instance.new("Folder")
roads.Name="TravelRoutes"
roads.Parent=world
local lookup={}
for _,z in ipairs(cfg.Zones) do lookup[z.id]=z end
for _,edge in ipairs(cfg.Routes) do
    local a,b=lookup[edge[1]],lookup[edge[2]]
    if a and b then
        local start=Vector3.new(a.x,1.7,a.z)
        local finish=Vector3.new(b.x,1.7,b.z)
        path(roads,start,finish,24,p.stone)
        for i=1,5 do
            local alpha=i/6
            local pos=start:Lerp(finish,alpha)
            lantern(roads,pos.X+16,pos.Z+16,p.warm)
        end
    end
end
-- WorldSky.server.lua owns the global sky, Atmosphere and Lighting presets.
-- Do not overwrite its moonlit baseline or Veilfall transitions here.
print("[KAGEBOUND] Grand World generated: "..#cfg.Zones.." connected regions")
