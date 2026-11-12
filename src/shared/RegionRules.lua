-- Pure region discovery policy for Grand World P1.
local World=require(game:GetService("ReplicatedStorage"):WaitForChild("KageboundShared"):WaitForChild("WorldConfig"))
local Regions={}
function Regions.At(position)
    if typeof(position)~="Vector3" then return nil end
    local closest=nil
    local distance=math.huge
    for _,zone in ipairs(World.Zones) do
        local dx=position.X-zone.x
        local dz=position.Z-zone.z
        local d=dx*dx+dz*dz
        if d<=zone.radius*zone.radius and d<distance then
            closest=zone
            distance=d
        end
    end
    return closest
end
function Regions.ById(id)
    if typeof(id)~="string" then return nil end
    for _,zone in ipairs(World.Zones) do
        if zone.id==id then return zone end
    end
    return nil
end
function Regions.IsConnected(a,b)
    if a==b then return Regions.ById(a)~=nil end
    for _,route in ipairs(World.Routes) do
        if (route[1]==a and route[2]==b) or (route[2]==a and route[1]==b) then
            return true
        end
    end
    return false
end
return Regions
