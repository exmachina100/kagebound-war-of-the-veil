-- KAGEBOUND layered local VFX. ART-001/003/004; FX-001/002/003/004.
-- Complements the temporary Combat.client.lua pulses without affecting hitboxes.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local remote = ReplicatedStorage:WaitForChild("KageboundCombat")
local function rootOf(player)
    local model = player and player.Character
    return model and model:FindFirstChild("HumanoidRootPart")
end
local function wedgeBetween(name, a, b, width, hue, lifetime)
    local span = b-a
    if span.Magnitude < .02 then return end
    local p=Instance.new("Part")
    p.Name=name
    p.Anchored=true
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=false
    p.Material=Enum.Material.Neon
    p.Color=hue
    p.Size=Vector3.new(width,width,span.Magnitude)
    p.CFrame=CFrame.lookAt((a+b)/2,b)
    p.Transparency=.12
    p.Parent=workspace
    TweenService:Create(p,TweenInfo.new(lifetime,Enum.EasingStyle.Quad),{
        Transparency=1, Size=Vector3.new(width*.25,width*.25,span.Magnitude)
    }):Play()
    Debris:AddItem(p,lifetime+.08)
end
local function slash(root,heavy,combo)
    local radius=heavy and 7 or 5
    local center=root.Position+Vector3.new(0,2.2,0)
    local baseAngle=heavy and -.35 or ((combo or 1)-2)*.34
    local pink=heavy and Color3.fromRGB(254,65,116) or Color3.fromRGB(248,94,165)
    -- Graphic curved crescent follows horizontal root-facing local space.
    for i=1,12 do
        local a=math.rad(-75+150*(i-1)/12)+baseAngle
        local b=math.rad(-75+150*i/12)+baseAngle
        local function at(t)
            local horizontal=root.CFrame.LookVector*math.cos(t)+root.CFrame.RightVector*math.sin(t)
            return center+horizontal*radius+Vector3.new(0,math.sin(t)*1.2,0)
        end
        wedgeBetween("FX001_KatanaArc",at(a),at(b),heavy and .48 or .25,pink,.22)
    end
end
local function ring(root,hue,radius,segments,y)
    local mid=root.Position+Vector3.new(0,y or 2,0)
    for i=1,segments do
        local a=math.pi*2*(i-1)/segments
        local b=math.pi*2*i/segments
        wedgeBetween("FX003_SpiritRing",mid+Vector3.new(math.cos(a)*radius,0,math.sin(a)*radius),
            mid+Vector3.new(math.cos(b)*radius,0,math.sin(b)*radius),.22,hue,.3)
    end
end
remote.OnClientEvent:Connect(function(event,actor,arg1,arg2)
    local root=rootOf(actor)
    if not root then return end
    if event=="Swing" then
        slash(root,arg1=="Heavy",arg2)
    elseif event=="ParryStart" then
        ring(root,Color3.fromRGB(86,173,255),3,12,2)
    elseif event=="Parried" then
        ring(root,Color3.fromRGB(171,229,255),4.5,16,2.5)
    elseif event=="DashFX" then
        ring(root,Color3.fromRGB(185,97,217),2.2,10,.3)
    elseif event=="Hit" then
        ring(root,Color3.fromRGB(250,184,93),1.4,8,2)
    end
end)
print("[KAGEBOUND] Layered combat VFX ready (ART-001/003)")
