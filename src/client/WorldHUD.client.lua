-- KAGEBOUND Grand World exploration HUD — position-based region and destination display.
-- Visual treatment from ART-001/ART-004; display is informational, never server authority.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local world=require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("WorldConfig"))
if not world.Enabled then return end
local gui=Instance.new("ScreenGui")
gui.Name="KageboundWorldHUD"
gui.ResetOnSpawn=false
gui.Parent=player:WaitForChild("PlayerGui")
local root=Instance.new("Frame")
root.Name="TravelDisplay"
root.AnchorPoint=Vector2.new(.5,0)
root.Position=UDim2.new(.5,0,0,22)
root.Size=UDim2.new(0,360,0,80)
root.BackgroundColor3=Color3.fromRGB(27,25,47)
root.BackgroundTransparency=.14
root.BorderSizePixel=0
root.Parent=gui
local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,12)
corner.Parent=root
local outline=Instance.new("UIStroke")
outline.Thickness=1
outline.Color=Color3.fromRGB(165,102,210)
outline.Transparency=.3
outline.Parent=root
local function textLabel(name,y,height,text,size,color)
    local l=Instance.new("TextLabel")
    l.Name=name
    l.Size=UDim2.new(1,-18,0,height)
    l.Position=UDim2.fromOffset(9,y)
    l.BackgroundTransparency=1
    l.TextXAlignment=Enum.TextXAlignment.Center
    l.Font=Enum.Font.GothamBold
    l.TextSize=size
    l.TextColor3=color
    l.Text=text
    l.Parent=root
    return l
end
local title=textLabel("Region",5,25,"KAGEBOUND  |  EXPLORING",16,Color3.fromRGB(244,224,248))
local detail=textLabel("NextLocation",34,18,"Finding nearest destination...",12,Color3.fromRGB(223,171,238))
local sub=textLabel("Coordinates",55,18,"World traversal prototype",11,Color3.fromRGB(187,188,201))
local function update()
    local character=player.Character
    local hrp=character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local pos=hrp.Position
    local selected=nil
    local closest=math.huge
    local nextZone=nil
    local nextDistance=math.huge
    for _,zone in ipairs(world.Zones) do
        local distance=(Vector2.new(pos.X,pos.Z)-Vector2.new(zone.x,zone.z)).Magnitude
        if distance<closest then closest=distance selected=zone end
        if distance>zone.radius and distance<nextDistance then nextDistance=distance nextZone=zone end
    end
    if selected then
        title.Text=selected.name:upper().."  |  LEVEL "..selected.level
        if closest>selected.radius then title.Text="BETWEEN THE REALMS  |  "..selected.name:upper() end
        local waypoint=(nextZone and nextZone.id~=selected.id) and nextZone or nil
        if not waypoint then
            for _,zone in ipairs(world.Zones) do
                if zone.id~=selected.id then
                    local d=(Vector2.new(pos.X,pos.Z)-Vector2.new(zone.x,zone.z)).Magnitude
                    if not waypoint or d<nextDistance then waypoint=zone nextDistance=d end
                end
            end
        end
        if waypoint then detail.Text="Nearby: "..waypoint.name.."  •  "..math.floor(nextDistance).." studs" end
    end
    sub.Text=("X %d   Z %d   |   Explore beyond the dojo"):format(math.floor(pos.X),math.floor(pos.Z))
end
task.spawn(function()
    while gui.Parent do
        update()
        task.wait(.35)
    end
end)
print("[KAGEBOUND] World HUD active")
