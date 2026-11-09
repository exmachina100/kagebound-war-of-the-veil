-- KAGEBOUND local combat VFX 0.3 — concept ART-001/003 and FX-001..004.
-- Crimson core & magenta veil edge inspired by the approved Veilblade sheet.
-- Visuals never determine damage; the server authorizes every VFX event.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local UIS = game:GetService("UserInputService")
local remote = ReplicatedStorage:WaitForChild("KageboundCombat")

local mobile = UIS.TouchEnabled
local MAX_DISTANCE = 185
local slashSegments = mobile and 6 or 11
local ringSegments = mobile and 8 or 12

local C = {
    hot = Color3.fromRGB(255,94,155),
    crimson = Color3.fromRGB(204,35,88),
    veil = Color3.fromRGB(178,78,245),
    parry = Color3.fromRGB(112,204,255),
    gold = Color3.fromRGB(255,195,112),
    ivory = Color3.fromRGB(255,227,239)
}

local function visible(root)
    local camera = workspace.CurrentCamera
    return camera == nil or (camera.CFrame.Position-root.Position).Magnitude <= MAX_DISTANCE
end

local function rootOf(actor)
    local char = actor and actor.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function line(name,a,b,width,color,duration)
    local offset=b-a
    if offset.Magnitude < 0.02 then return end
    local p=Instance.new("Part")
    p.Name=name
    p.Anchored=true
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=false
    p.CastShadow=false
    p.Material=Enum.Material.Neon
    p.Color=color
    p.Transparency=.09
    p.Size=Vector3.new(width,width,offset.Magnitude)
    p.CFrame=CFrame.lookAt((a+b)/2,b)
    p.Parent=workspace
    TweenService:Create(p,TweenInfo.new(duration,Enum.EasingStyle.Quad),{
        Transparency=1,
        Size=Vector3.new(width*.18,width*.18,offset.Magnitude)
    }):Play()
    Debris:AddItem(p,duration+.06)
end

local function spark(root,color)
    local cf=root.CFrame
    local pos=root.Position+cf.LookVector*3+Vector3.new(0,1.3,0)
    local right=cf.RightVector
    line("FX001_Windup",pos-right*.36,pos+right*.36,.22,color,.19)
end

local function slash(root,heavy,combo)
    local cf=root.CFrame
    local center=root.Position+Vector3.new(0,1.7,0)
    local radius=heavy and 7 or 5
    local twist=(combo or 1)==2 and -.24 or .18
    local offset=heavy and -.28 or twist
    local function arc(t,r)
        return center+(cf.LookVector*math.cos(t)+cf.RightVector*math.sin(t))*r
            +Vector3.new(0,math.sin(t)*1.15,0)
    end
    for i=1,slashSegments do
        local a=math.rad(-76+152*(i-1)/slashSegments)+offset
        local b=math.rad(-76+152*i/slashSegments)+offset
        local outerColor=heavy and C.veil or C.crimson
        if not mobile then
            line("FX001_VeilbladeOuter",arc(a,radius+.18),arc(b,radius+.18),
                heavy and .42 or .31,outerColor,.24)
        end
        line("FX001_VeilbladeCore",arc(a,radius),arc(b,radius),
            heavy and .22 or .16,C.hot,.20)
    end
end

local function ring(root,color,radius,segments,height,kind)
    local center=root.Position+Vector3.new(0,height or 2,0)
    for i=1,segments do
        local a=math.pi*2*(i-1)/segments
        local b=math.pi*2*i/segments
        local pa=center+Vector3.new(math.cos(a)*radius,0,math.sin(a)*radius)
        local pb=center+Vector3.new(math.cos(b)*radius,0,math.sin(b)*radius)
        line(kind,pa,pb,.19,color,.30)
    end
end

remote.OnClientEvent:Connect(function(event,actor,arg1,arg2)
    local root=rootOf(actor)
    if not root or not visible(root) then return end
    if event=="Windup" then
        spark(root,arg1=="Heavy" and C.veil or C.hot)
    elseif event=="Swing" then
        slash(root,arg1=="Heavy",arg2)
    elseif event=="ParryStart" then
        ring(root,C.parry,2.4,ringSegments,2,"FX003_ParryGuard")
    elseif event=="Parried" then
        ring(root,C.ivory,4,ringSegments,2.4,"FX003_PerfectCounter")
    elseif event=="GuardBroken" then
        ring(root,C.crimson,3.7,ringSegments,2.3,"FX003_GuardBreak")
    elseif event=="DashFX" then
        ring(root,C.veil,2.3,ringSegments,.3,"FX004_Dash")
    elseif event=="Hit" then
        ring(root,C.gold,1.5,ringSegments,2,"FX002_Impact")
    end
end)
print("[KAGEBOUND] Reference-driven combat VFX 0.3 initialized")
