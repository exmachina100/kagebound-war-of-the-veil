-- KAGEBOUND Shadow Duel Veilfall v0.1.
-- Server-authoritative arena transformation, separate from Grand World Veilfall.
-- ART-001 / ART-004, FX-008 / FX-009. This is procedural placeholder art.
local DuelVeilfall = {}
DuelVeilfall.__index = DuelVeilfall

local function piece(parent,name,size,cf,color,collision)
    local p=Instance.new("Part")
    p.Name=name
    p.Size=size
    p.CFrame=cf
    p.Color=color
    p.Anchored=true
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=false
    p.CastShadow=false
    p.Material=Enum.Material.Neon
    p.Transparency=1
    p.Parent=parent
    return p
end

function DuelVeilfall.new(arena,center,rules,palette)
    local self=setmetatable({},DuelVeilfall)
    self.center=center
    self.rules=rules
    self.version=0
    self.active=false
    self.platforms={}
    self.decorations={}
    local previous=arena:FindFirstChild("VeilfallRuntime")
    if previous then previous:Destroy() end
    self.folder=Instance.new("Folder")
    self.folder.Name="VeilfallRuntime"
    self.folder.Parent=arena

    -- Four low-raised, clean platforms leave floor continuously accessible.
    -- Players may jump onto them during Veilfall; none blocks spawn positions.
    for i,coords in ipairs({
        {-18,-20},{18,-20},{-18,20},{18,20}
    }) do
        local part=piece(self.folder,"SpiritRise_"..i,Vector3.new(15,1.25,12),
            CFrame.new(center+Vector3.new(coords[1],-0.2,coords[2])),
            i%2==0 and palette.spirit or Color3.fromRGB(224,85,174),true)
        table.insert(self.platforms,part)
    end
    for i=1,4 do
        local z=-30+(i-1)*20
        local bridge=piece(self.folder,"SpectralRoute_"..i,Vector3.new(8,1.25,16),
            CFrame.new(center+Vector3.new(0,-0.2,z)),
            palette.spirit,true)
        table.insert(self.platforms,bridge)
    end

    -- Ring segments are decoration only: excluded from overlap/raycast queries.
    local ringCenter=center+Vector3.new(0,17,0)
    local segments=20
    for i=1,segments do
        local a=2*math.pi*(i-1)/segments
        local b=2*math.pi*i/segments
        local va=ringCenter+Vector3.new(math.cos(a)*25,math.sin(a)*10,0)
        local vb=ringCenter+Vector3.new(math.cos(b)*25,math.sin(b)*10,0)
        local length=(vb-va).Magnitude
        local p=piece(self.folder,"VeilArc_"..i,Vector3.new(.4,.4,length),
            CFrame.lookAt((va+vb)*.5,vb),
            i%2==0 and palette.spirit or Color3.fromRGB(246,113,186),false)
        table.insert(self.decorations,p)
    end
    return self
end

function DuelVeilfall:_repositionStanding(players)
    for _,player in ipairs(players or {}) do
        local character=player and player.Character
        local root=character and character:FindFirstChild("HumanoidRootPart")
        if root then
            for _,platform in ipairs(self.platforms) do
                local localPos=platform.CFrame:PointToObjectSpace(root.Position)
                if math.abs(localPos.X)<=platform.Size.X*.5+1
                    and math.abs(localPos.Z)<=platform.Size.Z*.5+1
                    and localPos.Y>=0 and localPos.Y<=9 then
                    -- The permanent duel floor is directly underneath.
                    root.CFrame=CFrame.new(root.Position.X,self.center.Y+1,root.Position.Z)
                        * root.CFrame.Rotation
                    root.AssemblyLinearVelocity=Vector3.new(
                        root.AssemblyLinearVelocity.X,0,root.AssemblyLinearVelocity.Z)
                    break
                end
            end
        end
    end
end

function DuelVeilfall:_apply(enabled)
    self.active=enabled
    for _,p in ipairs(self.platforms) do
        if p.Parent then
            if enabled then
                p.CanCollide=true
                p.CanQuery=true
            else
                p.CanCollide=false
                p.CanQuery=false
            end
            p.Transparency=enabled and .16 or 1
        end
    end
    for _,p in ipairs(self.decorations) do
        if p.Parent then p.Transparency=enabled and .24 or 1 end
    end
end

function DuelVeilfall:Stop(players)
    self.version+=1 -- invalidate stale scheduled transitions
    if self.active then self:_repositionStanding(players) end
    self:_apply(false)
end

function DuelVeilfall:Start(players,allowed,notify)
    self:Stop(players)
    local token=self.version
    local timing=self.rules.Veilfall
    task.spawn(function()
        local function isValid()
            return self.version==token and self.folder.Parent~=nil and allowed()
        end
        task.wait(timing.StartAt)
        if not isValid() then return end
        notify("VeilWarning",{seconds=timing.WarningSeconds})
        task.wait(timing.WarningSeconds)
        if not isValid() then return end
        self:_apply(true)
        notify("VeilActive",{duration=timing.ActiveSeconds+timing.ClosingSeconds})
        task.wait(timing.ActiveSeconds)
        if not isValid() then return end
        notify("VeilClosing",{seconds=timing.ClosingSeconds})
        task.wait(timing.ClosingSeconds)
        if not isValid() then return end
        self:Stop(players)
        notify("VeilClosed",{})
    end)
end

return DuelVeilfall
