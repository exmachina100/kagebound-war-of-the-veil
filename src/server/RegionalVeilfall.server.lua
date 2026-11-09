-- Regional Veilfall 0.1 — works in GRAND WORLD, not the legacy enclosed arena.
-- Original sky-rift/spectral bridge concept derived from ART-004.
-- The server controls bridge collisions and gives 6s advance closure notice.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local Players=game:GetService("Players")
local World=require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("WorldConfig"))
if not World.Enabled then return end

local zone=nil
for _,entry in ipairs(World.Zones) do
    if entry.id=="MoonfallBamboo" then zone=entry break end
end
if not zone then warn("[KAGEBOUND] Regional Veilfall: missing MoonfallBamboo zone") return end

local event=ReplicatedStorage:FindFirstChild("KageboundVeilfall")
if not event then
    event=Instance.new("RemoteEvent")
    event.Name="KageboundVeilfall"
    event.Parent=ReplicatedStorage
end

local world=Workspace:WaitForChild("KageboundWorld",45)
local district=world and world:WaitForChild(zone.id,45)
if not district then warn("[KAGEBOUND] Regional Veilfall: district not ready") return end
local previous=district:FindFirstChild("MoonfallRift")
if previous then previous:Destroy() end
local folder=Instance.new("Folder")
folder.Name="MoonfallRift"
folder.Parent=district

local color=Color3.fromRGB(184,84,243)
local hot=Color3.fromRGB(244,103,209)
local bridgeParts={}
local atmosphereParts={}

local function create(name,size,cf,tint,collidable)
    local p=Instance.new("Part")
    p.Name=name
    p.Size=size
    p.CFrame=cf
    p.Anchored=true
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=false
    p.CastShadow=false
    p.Material=Enum.Material.Neon
    p.Color=tint
    p.Transparency=1
    p.Parent=folder
    table.insert(collidable and bridgeParts or atmosphereParts,p)
    return p
end

-- Reappearing elevated bridge across the ceremonial courtyard.
-- Players can reach the bridge from either low ramp, unlike disconnected sky pads.
for i=-4,4 do
    create("SpiritBridge_"..i,Vector3.new(13,1.3,13),
        CFrame.new(zone.x+i*12,5.25,zone.z+38),
        i%2==0 and color or hot,true)
end
for _,side in ipairs({-1,1}) do
    create("BridgeRamp",Vector3.new(18,1.5,13),
        CFrame.new(zone.x+side*61,3.1,zone.z+38)
            *CFrame.Angles(0,0,math.rad(-side*13)),
        color,true)
end
-- Spectral overhead rift: only visual; never blocks traversal or sword queries.
local center=Vector3.new(zone.x,48,zone.z+38)
for i=1,20 do
    local a=(i-1)*math.pi*2/20
    local b=i*math.pi*2/20
    local pa=center+Vector3.new(math.cos(a)*24,math.sin(a)*8,0)
    local pb=center+Vector3.new(math.cos(b)*24,math.sin(b)*8,0)
    local delta=pb-pa
    create("RiftArc_"..i,Vector3.new(.75,.75,delta.Magnitude),
        CFrame.lookAt((pa+pb)/2,pb),i%2==0 and hot or color,false)
end

local function nearZone(player)
    local char=player.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local offset=Vector2.new(root.Position.X-zone.x,root.Position.Z-zone.z)
    return offset.Magnitude <= zone.radius+80
end
local function announce(state,seconds)
    for _,player in ipairs(Players:GetPlayers()) do
        if nearZone(player) then event:FireClient(player,state,seconds) end
    end
end
local function setActive(enabled)
    for _,p in ipairs(bridgeParts) do
        -- CanQuery is false only while CanCollide is false.
        if enabled then
            p.CanQuery=true
            p.CanCollide=true
        else
            p.CanCollide=false
            p.CanQuery=false
        end
        p.Transparency=enabled and .18 or 1
    end
    for _,p in ipairs(atmosphereParts) do
        p.Transparency=enabled and .22 or 1
    end
    announce(enabled and "Active" or "Closed")
end
local function relocateBridgeUsers()
    for _,player in ipairs(Players:GetPlayers()) do
        local char=player.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if root then
            for _,platform in ipairs(bridgeParts) do
                local localPos=platform.CFrame:PointToObjectSpace(root.Position)
                if math.abs(localPos.X)<=platform.Size.X/2+1
                    and math.abs(localPos.Z)<=platform.Size.Z/2+1
                    and localPos.Y>=0 and localPos.Y<=9 then
                    root.CFrame=CFrame.new(root.Position.X,9,root.Position.Z)
                    break
                end
            end
        end
    end
end

task.spawn(function()
    while district.Parent do
        task.wait(55)
        if not district.Parent then break end
        announce("Warning",6)
        task.wait(6)
        if not district.Parent then break end
        setActive(true)
        task.wait(34)
        announce("Closing",6)
        task.wait(6)
        relocateBridgeUsers()
        setActive(false)
    end
end)
print("[KAGEBOUND] Grand World Moonfall regional Veilfall enabled (ART-004)")
