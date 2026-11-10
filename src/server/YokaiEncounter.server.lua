-- KAGEBOUND Yokai Encounter 0.1: original Lantern Yokai for Moonfall Bamboo.
-- One small server-authoritative PvE prototype, not imported One Piece assets.
-- Visual anchors ART-001/002/004. Does NOT use client-owned combat values.
local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local HttpService=game:GetService("HttpService")
local Rewards=require(script.Parent:WaitForChild("RewardService"))
local Navigation=require(script.Parent:WaitForChild("YokaiNavigation"))
local DuelAuthority=require(script.Parent:WaitForChild("DuelService"))
local Classes=require(script.Parent:WaitForChild("ClassService"))
local World=require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("WorldConfig"))
if not World.Enabled then return end

local moonfall=nil
for _,zone in ipairs(World.Zones) do
    if zone.id=="MoonfallBamboo" then moonfall=zone break end
end
if not moonfall then return end
local world=Workspace:WaitForChild("KageboundWorld",45)
local district=world and world:WaitForChild("MoonfallBamboo",45)
if not district then warn("[KAGEBOUND] Yokai encounter: Moonfall zone missing") return end
local previous=Workspace:FindFirstChild("KageboundEnemies")
if previous then previous:Destroy() end
local folder=Instance.new("Folder")
folder.Name="KageboundEnemies"
folder.Parent=Workspace
local combat=ReplicatedStorage:WaitForChild("KageboundCombat",30)
if not combat then warn("[KAGEBOUND] Yokai encounter: combat event unavailable") return end

local C={
    body=Color3.fromRGB(41,31,60),mask=Color3.fromRGB(232,208,233),
    ruby=Color3.fromRGB(210,45,91),veil=Color3.fromRGB(190,78,233),
    gold=Color3.fromRGB(246,168,102)
}
local function piece(model,name,size,cf,color,material)
    local p=Instance.new("Part")
    p.Name=name
    p.Size=size
    p.CFrame=cf
    p.Anchored=true
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=true -- server melee overlap must be able to find the Yokai
    p.CastShadow=false
    p.Color=color
    p.Material=material or Enum.Material.SmoothPlastic
    p.Parent=model
    return p
end

local function createEnemy(index,position)
    local model=Instance.new("Model")
    model.Name="Moonfall_LanternYokai_"..index
    model:SetAttribute("KageboundEnemy",true)
    model:SetAttribute("EncounterToken",HttpService:GenerateGUID(false))
    model:SetAttribute("LastDamagerUserId",0)
    model:SetAttribute("LastDamagedAt",0)
    model:SetAttribute("StaggerUntil",0)
    model:SetAttribute("Health",110)
    model:SetAttribute("MaxHealth",110)
    model:SetAttribute("AIState","Idle")
    model.Parent=folder
    local cf=CFrame.new(position)
    local root=piece(model,"Root",Vector3.new(2.7,3.8,2.2),cf,C.body,Enum.Material.Slate)
    model.PrimaryPart=root
    piece(model,"IvoryMask",Vector3.new(2.1,2.1,.45),cf*CFrame.new(0,1,-1.25),C.mask)
    piece(model,"LeftHorn",Vector3.new(.45,1.9,.45),cf*CFrame.new(-.85,2.75,-1.25),C.ruby,Enum.Material.Neon)
    piece(model,"RightHorn",Vector3.new(.45,1.9,.45),cf*CFrame.new(.85,2.75,-1.25),C.ruby,Enum.Material.Neon)
    piece(model,"LeftArm",Vector3.new(.7,2.6,.9),cf*CFrame.new(-2,.05,0),C.body)
    piece(model,"RightArm",Vector3.new(.7,2.6,.9),cf*CFrame.new(2,.05,0),C.body)
    piece(model,"SpiritHeart",Vector3.new(1,.7,.3),cf*CFrame.new(0,.2,-1.3),C.veil,Enum.Material.Neon)
    local light=Instance.new("PointLight")
    light.Color=C.veil
    light.Brightness=.8
    light.Range=12
    light.Parent=root
    local tag=Instance.new("BillboardGui")
    tag.Name="YokaiHealth"
    tag.Size=UDim2.fromOffset(150,50)
    tag.StudsOffsetWorldSpace=Vector3.new(0,4,0)
    tag.MaxDistance=90
    tag.AlwaysOnTop=false
    tag.Parent=root
    local label=Instance.new("TextLabel")
    label.Size=UDim2.fromScale(1,1)
    label.BackgroundColor3=C.body
    label.BackgroundTransparency=.28
    label.TextColor3=C.mask
    label.Font=Enum.Font.GothamBold
    label.TextScaled=true
    label.Parent=tag
    local function redraw()
        label.Text=("LANTERN YOKAI\n%d / 110"):format(math.max(0,model:GetAttribute("Health") or 0))
    end
    model:GetAttributeChangedSignal("Health"):Connect(redraw)
    redraw()
    return model
end

local function nearestTarget(origin,home)
    local best,range=nil,65
    for _,player in ipairs(Players:GetPlayers()) do
        local char=player.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if root and hum and hum.Health>0 and not DuelAuthority.IsParticipant(player) then
            local homeDelta=root.Position-home
            local dist=(root.Position-origin).Magnitude
            if Vector3.new(homeDelta.X,0,homeDelta.Z).Magnitude<=85 and dist<range then
                best,range=player,dist
            end
        end
    end
    -- Kitsune optical decoys are now real non-damaging distraction targets.
    -- Prioritize an active nearby fox over a player, but never from a different
    -- encounter region or a player participating in Shadow Duel.
    for _,decoy in ipairs(workspace:GetChildren()) do
        if decoy:IsA("Model") and decoy:GetAttribute("KageboundDecoy")==true then
            local ownerId=decoy:GetAttribute("OwnerId")
            local owner=typeof(ownerId)=="number" and Players:GetPlayerByUserId(ownerId)
            local decoyRoot=decoy.PrimaryPart
            if owner and not DuelAuthority.IsParticipant(owner) and decoyRoot then
                local dist=(decoyRoot.Position-origin).Magnitude
                local homeOffset=decoyRoot.Position-home
                local homeDistance=Vector3.new(homeOffset.X,0,homeOffset.Z).Magnitude
                if dist<=35 and homeDistance<=85 then
                    return decoy,dist
                end
            end
        end
    end
    return best,range
end
local function targetRig(target)
    if typeof(target)~="Instance" then return nil,nil end
    if target:IsA("Model") and target:GetAttribute("KageboundDecoy")==true then
        return nil,target.PrimaryPart
    end
    if not target:IsA("Player") then return nil,nil end
    local char=target.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if hum and root and hum.Health>0 then return hum,root end
end
local homes={
    Vector3.new(moonfall.x-90,3.7,moonfall.z+25),
    Vector3.new(moonfall.x+88,3.7,moonfall.z-15),
    Vector3.new(moonfall.x+10,3.7,moonfall.z-108)
}
for i,home in ipairs(homes) do
    task.spawn(function()
        while folder.Parent do
            local model=createEnemy(i,home)
            local navigation=Navigation.New()
            while model.Parent and (model:GetAttribute("Health") or 0)>0 do
                local root=model.PrimaryPart
                local target,distance=nearestTarget(root.Position,home)
                local staggerUntil=model:GetAttribute("StaggerUntil") or 0
                if os.clock()<staggerUntil then
                    model:SetAttribute("AIState","Stagger")
                    task.wait(.12)
                elseif target and distance<=10 then
                    model:SetAttribute("AIState","Telegraph")
                    combat:FireAllClients("YokaiTelegraph",model)
                    task.wait(.70)
                    local hum,enemyRoot=targetRig(target)
                    if model.Parent and (model:GetAttribute("Health") or 0)>0 and enemyRoot
                        and os.clock()>=(model:GetAttribute("StaggerUntil") or 0) then
                        if (enemyRoot.Position-model.PrimaryPart.Position).Magnitude<=10 then
                            if target:IsA("Model") and target:GetAttribute("KageboundDecoy")==true then
                                -- A fox illusion absorbs a Yokai swing with no damage or reward.
                                combat:FireAllClients("YokaiStrike",model)
                                target:Destroy()
                            elseif hum and target:IsA("Player") then
                                local parryUntil=target:GetAttribute("KageboundParryUntil") or 0
                                local toward=model.PrimaryPart.Position-enemyRoot.Position
                                local toEnemy=Vector3.new(toward.X,0,toward.Z)
                                local face=Vector3.new(enemyRoot.CFrame.LookVector.X,0,enemyRoot.CFrame.LookVector.Z)
                                local facing=toEnemy.Magnitude>.1 and face.Magnitude>.1
                                    and face.Unit:Dot(toEnemy.Unit)>.25
                                if facing and typeof(parryUntil)=="number"
                                    and os.clock()<=parryUntil then
                                    target:SetAttribute("KageboundParryUntil",0)
                                    combat:FireAllClients("Parried",target)
                                else
                                    local params=RaycastParams.new()
                                    params.FilterType=Enum.RaycastFilterType.Exclude
                                    params.FilterDescendantsInstances={model,target.Character}
                                    params.RespectCanCollide=true
                                    local from=model.PrimaryPart.Position
                                    local obstruction=workspace:Raycast(from,enemyRoot.Position-from,params)
                                    if not obstruction then
                                        local finalDamage,guarded=Classes.ResolveDefense(target,
                                            model.PrimaryPart.Position,11,false)
                                        if not guarded then
                                            if finalDamage>0 then hum:TakeDamage(finalDamage) end
                                            combat:FireAllClients("YokaiStrike",model)
                                            combat:FireAllClients("Hit",target,finalDamage)
                                        else
                                            combat:FireAllClients("Parried",target)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    model:SetAttribute("AIState","Recover")
                    task.wait(.85)
                else
                    model:SetAttribute("AIState",target and "Pursue" or "Return")
                    local _,targetRoot=targetRig(target)
                    Navigation.MoveToward(model,targetRoot and targetRoot.Position or home,12,.14,navigation)
                    task.wait(.14)
                end
            end
            if model.Parent then
                model:SetAttribute("AIState","Defeated")
                if (model:GetAttribute("Health") or 0)<=0 then
                    local killerId=model:GetAttribute("LastDamagerUserId")
                    local hitAt=model:GetAttribute("LastDamagedAt")
                    if typeof(killerId)=="number" and killerId>0
                        and typeof(hitAt)=="number" and os.clock()-hitAt<20 then
                        local killer=Players:GetPlayerByUserId(killerId)
                        if killer then
                            local ok=Rewards.Award(killer,"LanternYokai",model:GetAttribute("EncounterToken"))
                            if ok then
                                print("[KAGEBOUND] Lantern Yokai defeat rewarded:",killer.UserId)
                            end
                        end
                    end
                    combat:FireAllClients("YokaiDefeated",model)
                end
                task.wait(.3) -- allow death effect to resolve before destruction
                model:Destroy()
            end
            task.wait(14)
        end
    end)
end
print("[KAGEBOUND] Moonfall Lantern Yokai: 3 server-owned PvE enemies online")
