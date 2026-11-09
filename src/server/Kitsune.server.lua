-- Kitsune mask ability prototype. ART-002 / ART-003 / FX-005.
-- Server-owned decoy is visual only: no damage, no hitbox, no automatic attacks.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Debris=game:GetService("Debris")
local DuelAuthority=require(script.Parent:WaitForChild("DuelService"))
local MaskRules=require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("MaskRules"))
local evt=ReplicatedStorage:FindFirstChild("KageboundKitsune")
if not evt then
    evt=Instance.new("RemoteEvent")
    evt.Name="KageboundKitsune"
    evt.Parent=ReplicatedStorage
end
local COOLDOWN=MaskRules.Kitsune.Cooldown
local LIFETIME=MaskRules.Kitsune.Lifetime
local state={}
local function makePart(parent,name,size,cf,color,transparency)
    local p=Instance.new("Part")
    p.Name=name
    p.Size=size
    p.CFrame=cf
    p.Anchored=true
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=false
    p.Material=Enum.Material.Neon
    p.Color=color
    p.Transparency=transparency
    p.Parent=parent
    return p
end
local function cast(player)
    if player:GetAttribute("KageboundMask")~="Kitsune" then return end
    if not DuelAuthority.CanAct(player) then return end
    local now=os.clock()
    if now-(state[player] or -1000)<COOLDOWN then return end
    local character=player.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    local hum=character and character:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health<=0 then return end
    state[player]=now
    local model=Instance.new("Model")
    model.Name="KitsuneDecoy_"..player.UserId
    model:SetAttribute("KageboundDecoy",true)
    model:SetAttribute("OwnerId",player.UserId)
    model.Parent=workspace
    local spawnCf=root.CFrame*CFrame.new(2,0,-5)
    local white=Color3.fromRGB(249,217,242)
    local pink=Color3.fromRGB(253,105,181)
    local dark=Color3.fromRGB(71,39,86)
    makePart(model,"Torso",Vector3.new(2.2,2.1,1.2),spawnCf*CFrame.new(0,0,0),dark,.18)
    makePart(model,"Head",Vector3.new(1.5,1.5,1.5),spawnCf*CFrame.new(0,1.75,0),white,.06)
    makePart(model,"LeftArm",Vector3.new(.7,2,1),spawnCf*CFrame.new(-1.5,0,0),pink,.23)
    makePart(model,"RightArm",Vector3.new(.7,2,1),spawnCf*CFrame.new(1.5,0,0),pink,.23)
    makePart(model,"LeftLeg",Vector3.new(.8,2,.9),spawnCf*CFrame.new(-.6,-2,0),dark,.25)
    makePart(model,"RightLeg",Vector3.new(.8,2,.9),spawnCf*CFrame.new(.6,-2,0),dark,.25)
    local crown=makePart(model,"FoxCrown",Vector3.new(1.8,.35,.35),spawnCf*CFrame.new(0,2.55,-.3),pink,.15)
    local point=Instance.new("PointLight")
    point.Color=pink
    point.Range=12
    point.Brightness=1
    point.Parent=crown
    local seal=makePart(model,"SpiritSeal",Vector3.new(3,.12,3),spawnCf*CFrame.new(0,-2.95,0),pink,.2)
    seal.Shape=Enum.PartType.Cylinder
    evt:FireAllClients("Cast",player,spawnCf.Position,LIFETIME)
    -- Slowly move the optical decoy ahead; no humanoid or harmful scripts.
    task.spawn(function()
        local count=14
        for i=1,count do
            if not model.Parent then break end
            local delta=spawnCf.LookVector*(i*0.45)
            for _,part in ipairs(model:GetChildren()) do
                if part:IsA("BasePart") then part.CFrame=part.CFrame+spawnCf.LookVector*.45 end
            end
            task.wait(LIFETIME/count)
        end
    end)
    Debris:AddItem(model,LIFETIME)
end
evt.OnServerEvent:Connect(function(player,action)
    if action=="Cast" then cast(player) end
end)
Players.PlayerRemoving:Connect(function(player) state[player]=nil end)
print("[KAGEBOUND] Kitsune decoy ability initialized")
