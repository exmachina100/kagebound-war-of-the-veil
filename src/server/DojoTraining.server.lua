-- KAGEBOUND Kage Dojo training lane 0.1
-- SafeHub PvP remains disabled. Only these tagged, server-owned practice
-- targets accept sword hits, and they never grant Spirit Shards or XP.
-- Visual styling: ART-001 key art, ART-004 Kage Dojo ceremonial courtyard.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local ServerStorage=game:GetService("ServerStorage")
local World=require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("WorldConfig"))
if not World.Enabled or not World.TrainingGrounds then return end
local world=Workspace:WaitForChild("KageboundWorld",45)
local dojo=world and world:WaitForChild("KageDojo",30)
if not dojo then warn("[KAGEBOUND] Dojo training: world unavailable") return end

local old=Workspace:FindFirstChild("KageboundTraining")
if old then old:Destroy() end
local folder=Instance.new("Folder")
folder.Name="KageboundTraining"
folder.Parent=Workspace
local hub=World.TrainingGrounds
local palette=World.Palette

local function part(parent,name,size,cf,color,material,isTarget)
    local p=Instance.new("Part")
    p.Name=name
    p.Anchored=true
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=isTarget==true
    p.CastShadow=false
    p.Size=size
    p.CFrame=cf
    p.Color=color
    p.Material=material or Enum.Material.SmoothPlastic
    p.Parent=parent
    return p
end

-- Optional original visual mesh imported into ServerStorage/KageboundArt.
-- All gameplay hitboxes and server health remain on the invisible practice root.
local function importedVisual(model,root,x,z)
    local art=ServerStorage:FindFirstChild("KageboundArt")
    local template=art and art:FindFirstChild("DojoPracticePostVisual")
    if not template or not template:IsA("Model") then return false end
    local visual=template:Clone()
    visual.Name="DojoPracticePostVisual"
    visual.Parent=model
    visual:PivotTo(CFrame.new(x,1,z)) -- authored OBJ origin is at its ground base
    local count=0
    for _,p in ipairs(visual:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Anchored=true
            p.CanCollide=false
            p.CanTouch=false
            p.CanQuery=false
            p.CastShadow=false
            count+=1
        end
    end
    if count==0 then visual:Destroy() return false end
    for _,p in ipairs(model:GetChildren()) do
        if p:IsA("BasePart") then p.Transparency=1 end
    end
    root.CanQuery=true
    model:SetAttribute("KageboundImportedVisual",true)
    return true
end

local function dummy(index,x,z)
    local model=Instance.new("Model")
    model.Name="PracticePost_"..index
    model.Parent=folder
    model:SetAttribute("KageboundTrainingTarget",true)
    model:SetAttribute("VisualReference","ART-004")
    model:SetAttribute("MaxHealth",120)
    model:SetAttribute("Health",120)
    model:SetAttribute("HitCount",0)
    local origin=CFrame.new(x,3.75,z)
    local root=part(model,"PracticeHitbox",Vector3.new(3,4.2,2.4),origin,
        palette.ink,Enum.Material.Wood,true)
    model.PrimaryPart=root
    part(model,"BodyStrap",Vector3.new(3.3,.32,2.6),origin*CFrame.new(0,.1,0),
        palette.vermilion,Enum.Material.Fabric)
    part(model,"Mask",Vector3.new(2.3,1.8,.26),origin*CFrame.new(0,1,-1.35),
        Color3.fromRGB(234,219,231),Enum.Material.SmoothPlastic)
    part(model,"MaskMark",Vector3.new(.75,.15,.12),origin*CFrame.new(0,1,-1.55),
        palette.spirit,Enum.Material.Neon)
    part(model,"GoldBand",Vector3.new(3.25,.26,2.55),origin*CFrame.new(0,-1.2,0),
        palette.warm,Enum.Material.Metal)
    part(model,"FootBase",Vector3.new(4.5,.35,4.5),CFrame.new(x,1.1,z),
        palette.stone,Enum.Material.Slate)
    importedVisual(model,root,x,z)
    local gui=Instance.new("BillboardGui")
    gui.Name="PracticeHealthBillboard"
    gui.Size=UDim2.fromOffset(164,54)
    gui.StudsOffsetWorldSpace=Vector3.new(0,3.8,0)
    gui.MaxDistance=75
    gui.Parent=root
    local label=Instance.new("TextLabel")
    label.Name="HealthLabel"
    label.Size=UDim2.fromScale(1,1)
    label.BackgroundColor3=palette.ink
    label.BackgroundTransparency=.15
    label.TextColor3=palette.warm
    label.Font=Enum.Font.GothamBold
    label.TextScaled=true
    label.TextWrapped=true
    label.Parent=gui
    local round=Instance.new("UICorner")
    round.CornerRadius=UDim.new(0,7)
    round.Parent=label

    local resetToken=0
    local function sync()
        local health=model:GetAttribute("Health") or 0
        local count=model:GetAttribute("HitCount") or 0
        label.Text=("PRACTICE POST %d\nHP %d / 120   HITS %d"):format(index,math.floor(health),count)
        if health<=0 then
            resetToken+=1
            local token=resetToken
            task.delay(2,function()
                if model.Parent and resetToken==token then
                    model:SetAttribute("Health",120)
                    label.TextColor3=palette.warm
                end
            end)
            label.TextColor3=Color3.fromRGB(249,113,184)
        end
    end
    model:GetAttributeChangedSignal("Health"):Connect(sync)
    model:GetAttributeChangedSignal("HitCount"):Connect(sync)
    sync()
end

for i=-1,1 do
    dummy(i+2,hub.x+i*11,hub.z+11)
end
-- Non-colliding spirit ring marks where practice is allowed.
local center=Vector3.new(hub.x,1.18,hub.z)
for i=1,24 do
    local a=(i-1)*math.pi*2/24
    local b=i*math.pi*2/24
    local pa=center+Vector3.new(math.cos(a)*hub.radius,0,math.sin(a)*hub.radius)
    local pb=center+Vector3.new(math.cos(b)*hub.radius,0,math.sin(b)*hub.radius)
    local delta=pb-pa
    part(folder,"TrainingRing",Vector3.new(.19,.16,delta.Magnitude),
        CFrame.lookAt((pa+pb)/2,pb),palette.spirit,Enum.Material.Neon)
end
local sign=part(folder,"DojoTrainingSign",Vector3.new(16,4,.4),
    CFrame.new(hub.x,6,hub.z-19),palette.ink,Enum.Material.Wood)
local board=Instance.new("SurfaceGui")
board.Face=Enum.NormalId.Front
board.CanvasSize=Vector2.new(460,120)
board.Parent=sign
local caption=Instance.new("TextLabel")
caption.Size=UDim2.fromScale(1,1)
caption.BackgroundTransparency=1
caption.Text="KAGE DOJO\nSHINOBI PRACTICE"
caption.TextScaled=true
caption.Font=Enum.Font.GothamBold
caption.TextColor3=palette.warm
caption.Parent=board
print("[KAGEBOUND] Kage Dojo practice lane ready: 3 safe targets (ART-004)")
