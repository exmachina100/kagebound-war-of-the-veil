-- Edit-only, reversible review batch. Reuses existing imported meshes; no uploads.
assert(not game:GetService('RunService'):IsRunning(), 'Edit mode required')
assert(game.PlaceId == 92077795105213, 'Wrong place')
local name = 'KageboundEquipmentFitReview'
assert(not workspace:FindFirstChild(name), 'Review exists; preserve it rather than overwrite')
local source = assert(workspace:FindFirstChild('KageboundAssetBatch22'))
local batch = Instance.new('Folder')
batch.Name = name
batch:SetAttribute('Status', 'DRAFT: static R15 fit only; no gameplay or art approval')
batch.Parent = workspace
local report = {rows = {}, uploads = 0, gameplayScriptsChanged = 0}
local function sanitize(model)
    for _,p in model:GetDescendants() do
        assert(not p:IsA('LuaSourceContainer'), 'Unexpected executable content')
        if p:IsA('BasePart') then
            p.CanCollide, p.CanTouch, p.CanQuery = false, false, false
            p.Massless = true
        end
    end
end
for i,kind in {'Kitsune','Oni','Tengu','Veilblade'} do
    local rig = game:GetService('Players'):CreateHumanoidModelFromDescriptionAsync(Instance.new('HumanoidDescription'), Enum.HumanoidRigType.R15)
    -- Default Roblox rigs include Animate; static inspection mannequins need no code.
    for _,p in rig:GetDescendants() do if p:IsA('LuaSourceContainer') then p:Destroy() end end
    rig.Name = kind .. '_R15_Fit_DRAFT'
    sanitize(rig)
    for _,p in rig:GetDescendants() do if p:IsA('BasePart') then p.Anchored = p.Name == 'HumanoidRootPart' end end
    rig:PivotTo(CFrame.new(180 + (i-1)*8, 8, 100))
    local cf,size = rig:GetBoundingBox()
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {batch}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local hit = assert(workspace:Raycast(Vector3.new(180+(i-1)*8,50,100), Vector3.new(0,-100,0),params), 'No ground')
    rig:PivotTo(rig:GetPivot() + Vector3.new(0,hit.Position.Y - (cf.Y-size.Y/2),0))
    rig.Parent = batch
    local key = kind == 'Veilblade' and 'weapon_KGB_WPN_Veilblade_Default_GAME_v02' or 'mask_KGB_MASK_'..kind..'_Wearable_DRAFT_v01'
    local original = assert(source:FindFirstChild(key), key)
    local visual = original:Clone()
    visual.Name = kind..'_FittedVisual_DRAFT'
    sanitize(visual)
    local target = kind == 'Veilblade' and rig.RightHand or rig.Head
    if kind == 'Veilblade' then
        -- Source pivot was verified at grip midpoint; retain authored size.
        visual:PivotTo(target.CFrame * CFrame.new(0,-0.4,0) * CFrame.Angles(0,0,-math.pi/2))
    else
        -- Imported source is baked facing -Z. Face centre is source Y=1.3.
        visual:PivotTo(target.CFrame * CFrame.new(0,-1.3,-target.Size.Z/2-0.04))
    end
    visual.Parent = rig
    local count = 0
    for _,p in visual:GetDescendants() do
        if p:IsA('BasePart') then
            p.Anchored = false
            local weld = Instance.new('WeldConstraint')
            weld.Name, weld.Part0, weld.Part1, weld.Parent = 'ReviewFitWeld', target, p, p
            count += 1
        end
    end
    local anchor = Instance.new('Attachment')
    anchor.Name = kind..'ReviewFitAttachment'
    anchor.CFrame = target.CFrame:ToObjectSpace(visual:GetPivot())
    anchor.Parent = target
    visual:SetAttribute('SourceModel', original:GetFullName())
    visual:SetAttribute('Reference', kind == 'Veilblade' and 'ART-003' or 'ART-002/003')
    local _,bounds = visual:GetBoundingBox()
    table.insert(report.rows,{name=rig.Name,meshCount=count,size={bounds.X,bounds.Y,bounds.Z},groundY=hit.Position.Y,target=target.Name})
    task.wait()
end
game:GetService('ChangeHistoryService'):SetWaypoint('KAGEBOUND isolated R15 weapon and mask fitting review')
return report
