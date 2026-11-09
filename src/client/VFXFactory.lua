-- KAGEBOUND VFXFactory v0.5 — cosmetic world-space shapes.
-- Art references: ART-001..004 + the 8 original concept sheets in
-- assets/concept-sheets/{vfx-v01,clan-vfx-v01}. No copied anime assets.
-- All authority remains with server combat/mask/Veilfall scripts.
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local UIS=game:GetService("UserInputService")
local Factory={}
local mobile=UIS.TouchEnabled
local MAX_PARTS=mobile and 105 or 260
local MAX_DISTANCE=mobile and 125 or 205
local active=0
local folder=Instance.new("Folder")
folder.Name="KageboundLocalVFX"
folder.Parent=workspace

function Factory.Root(actor)
    if typeof(actor)~="Instance" then return nil end
    if actor:IsA("Player") then
        local char=actor.Character
        return char and char:FindFirstChild("HumanoidRootPart")
    end
    if actor:IsA("Model") then
        return actor.PrimaryPart or actor:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end

function Factory.Visible(root)
    if not root then return false end
    local cam=workspace.CurrentCamera
    return not cam or (cam.CFrame.Position-root.Position).Magnitude <= MAX_DISTANCE
end

local function piece(name,cf,size,color,duration,startAlpha)
    if active>=MAX_PARTS then return nil end
    local p=Instance.new("Part")
    p.Name=name
    p.Anchored=true
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=false
    p.CastShadow=false
    p.Material=Enum.Material.Neon
    p.Color=color
    p.Transparency=startAlpha or .12
    p.Size=size
    p.CFrame=cf
    p.Parent=folder
    active+=1
    local t=math.clamp(duration or .3,.07,1.6)
    TweenService:Create(p,TweenInfo.new(t,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{
        Transparency=1,
        Size=Vector3.new(math.max(.035,size.X*.13),math.max(.035,size.Y*.13),
            math.max(.035,size.Z*.75))
    }):Play()
    Debris:AddItem(p,t+.12)
    task.delay(t+.13,function()
        active=math.max(0,active-1)
    end)
    return p
end

function Factory.Line(name,a,b,width,color,duration)
    local d=b-a
    if d.Magnitude<=.03 then return end
    return piece(name,CFrame.lookAt((a+b)*.5,b),
        Vector3.new(width,width,d.Magnitude),color,duration)
end

function Factory.Ring(root,radius,height,color,label,segments,duration)
    if not Factory.Visible(root) then return end
    local n=segments or (mobile and 8 or 16)
    local center=root.Position+Vector3.new(0,height or .5,0)
    for i=1,n do
        local a=(i-1)*math.pi*2/n
        local b=i*math.pi*2/n
        local p1=center+Vector3.new(math.cos(a)*radius,0,math.sin(a)*radius)
        local p2=center+Vector3.new(math.cos(b)*radius,0,math.sin(b)*radius)
        Factory.Line(label,p1,p2,.18,color,duration or .36)
    end
end

function Factory.Spokes(root,count,radius,height,color,label,duration)
    if not Factory.Visible(root) then return end
    local center=root.Position+Vector3.new(0,height or 1,0)
    local n=math.min(count,mobile and 5 or 14)
    for i=1,n do
        local t=2*math.pi*i/n
        local rv=Vector3.new(math.cos(t),math.sin(t*.55)*.35,math.sin(t))
        Factory.Line(label,center+rv*radius*.18,center+rv*radius,
            .11,color,duration or .26)
    end
end

function Factory.Seal(root,profile,height,radius,label)
    if not Factory.Visible(root) then return end
    local n=mobile and 6 or 12
    Factory.Ring(root,radius,height,profile.core,label.."_Circle",n,.46)
    Factory.Ring(root,radius*.67,height+.05,profile.edge,label.."_Inner",n,.35)
    Factory.Spokes(root,6,radius*.94,height,profile.edge,label.."_Runes",.4)
end

function Factory.Slash(root,profile,heavy,combo)
    if not Factory.Visible(root) then return end
    local base=root.Position+Vector3.new(0,1.6,0)
    local cf=root.CFrame
    local radius=heavy and 7.4 or 5.1
    local n=mobile and 7 or 15
    local phase=combo==2 and -.22 or (combo==3 and .38 or .06)
    local sign=combo==2 and -1 or 1
    local function point(t,r,h)
        return base+(cf.LookVector*math.cos(t)+cf.RightVector*math.sin(t))*r
            +Vector3.new(0,math.sin(t*sign)*h,0)
    end
    -- Three layered independent crescent edges: ink shadow, hot core and veil.
    for i=1,n do
        local a=math.rad(-77+154*(i-1)/n)+phase
        local b=math.rad(-77+154*i/n)+phase
        if not mobile then
            Factory.Line("FX001_CrescentOuter",point(a,radius+.31,1.35),
                point(b,radius+.31,1.35),heavy and .42 or .30,
                profile.edge,.28)
        end
        Factory.Line("FX001_CrescentCore",point(a,radius,1.28),
            point(b,radius,1.28),heavy and .29 or .19,profile.core,.21)
    end
    Factory.Spokes(root,heavy and 12 or 5,heavy and 5 or 2,1.7,
        profile.edge,"FX001_SlashStreaks",.16)
end

function Factory.Windup(root,profile,heavy)
    if not Factory.Visible(root) then return end
    local center=root.Position+root.CFrame.LookVector*2+Vector3.new(0,1.5,0)
    local right=root.CFrame.RightVector
    Factory.Line("FX001_Charge",center-right*.6,center+right*.6,
        heavy and .35 or .20,profile.core,heavy and .30 or .15)
    if heavy then
        Factory.Ring(root,2.8,.3,profile.edge,"FX001_HeavyCharge",mobile and 6 or 10,.28)
    end
end

function Factory.Impact(root,profile,radius)
    if not Factory.Visible(root) then return end
    Factory.Ring(root,radius or 2.5,1.4,profile.core,"FX002_Impact",mobile and 8 or 13,.23)
    Factory.Spokes(root,mobile and 5 or 12,radius or 2.5,1.5,profile.edge,
        "FX002_ImpactGlints",.18)
end

function Factory.Parry(root,profile,perfect)
    if not Factory.Visible(root) then return end
    Factory.Ring(root,perfect and 4.8 or 2.8,1.9,profile.defense,
        perfect and "FX003_Perfect" or "FX003_Parry",mobile and 9 or 18,.34)
    if perfect then
        Factory.Spokes(root,12,5,1.8,profile.edge,"FX003_CounterSpark",.25)
        Factory.Seal(root,profile,1.7,2.2,"FX003_ParrySigil")
    end
end

function Factory.Oni(root,profile)
    if not Factory.Visible(root) then return end
    Factory.Ring(root,7,.2,profile.core,"FX006_RuptureInner",mobile and 9 or 18,.55)
    Factory.Ring(root,13,.4,profile.edge,"FX006_RuptureOuter",mobile and 10 or 20,.66)
    Factory.Spokes(root,16,12,.2,profile.core,"FX006_GroundCracks",.57)
    -- Ground shockwave appears vast; server gameplay radius stays at 12 studs.
    if not mobile then Factory.Seal(root,profile,.55,4.6,"FX006_OniHornSeal") end
end

function Factory.Tengu(root,profile)
    if not Factory.Visible(root) then return end
    local n=mobile and 5 or 10
    for i=1,n do
        local t=i/n
        local a=t*math.pi*3
        local center=root.Position+Vector3.new(0,t*6-.2,0)
        local rv=Vector3.new(math.cos(a),0,math.sin(a))*((1-t)*3.2+1)
        local nextAngle=a+math.pi*.45
        local endpoint=center+Vector3.new(math.cos(nextAngle)*3,1.1,math.sin(nextAngle)*3)
        Factory.Line("FX007_WindRibbon",center+rv,endpoint,
            .14, i%2==0 and profile.core or profile.edge,.40)
    end
    Factory.Ring(root,3,.15,profile.core,"FX007_WindLaunch",mobile and 7 or 12,.3)
end

function Factory.Kitsune(root,profile)
    if not Factory.Visible(root) then return end
    Factory.Seal(root,profile,.25,4.2,"FX005_FoxSeal")
    Factory.Spokes(root,11,5.8,2,profile.edge,"FX005_FoxAfterimages",.4)
end

return Factory
