-- KAGEBOUND Veilblade: lightweight procedural starter katana.
-- Reference ART-003 weapon board. This is a *visual blockout*, not a final mesh.
-- Server creates one tool per spawn; combat authority remains Combat.server.lua.
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local Authority = require(script.Parent:WaitForChild("WeaponAuthority"))
local Weapons = require(game:GetService("ReplicatedStorage"):WaitForChild("KageboundShared"):WaitForChild("WeaponRules"))

local INK = Color3.fromRGB(32,30,51)
local CRIMSON = Color3.fromRGB(145,31,65)
local HOT = Color3.fromRGB(255,91,153)
local GOLD = Color3.fromRGB(226,166,92)

local function createKatana(weaponName)
    local tool = Instance.new("Tool")
    tool.Name = "Veilblade"
    weaponName=weaponName or "Katana"
    local lengthScale=weaponName=="Nodachi" and 1.35 or weaponName=="Tanto" and .58 or 1
    tool.ToolTip = "KAGEBOUND • "..weaponName.." [ART-003 prototype]"
    tool:SetAttribute("KageboundWeaponVisual",weaponName)
    tool.CanBeDropped = false
    tool.RequiresHandle = true
    tool.Grip = CFrame.new(0,-.4*lengthScale,0)

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(.37,2.2*lengthScale,.37)
    handle.Color = INK
    handle.Material = Enum.Material.SmoothPlastic
    handle.Anchored = false
    handle.CanCollide = false
    handle.CanTouch = false
    handle.CanQuery = false
    handle.Massless = true
    handle.Parent = tool

    local function fitted(name,size,offset,color,material)
        local p = Instance.new("Part")
        p.Name = name
        p.Size = Vector3.new(size.X,size.Y*lengthScale,size.Z)
        p.Color = color
        p.Material = material or Enum.Material.SmoothPlastic
        local position=offset.Position
        p.CFrame = handle.CFrame*CFrame.new(position.X,position.Y*lengthScale,position.Z)*offset.Rotation
        p.Anchored = false
        p.CanCollide = false
        p.CanTouch = false
        p.CanQuery = false
        p.CastShadow = false
        p.Massless = true
        p.Parent = tool
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = p
        weld.Parent = p
        return p
    end

    fitted("BladeShadow",Vector3.new(.35,4.4,.65),
        CFrame.new(0,3.32,0)*CFrame.Angles(0,0,math.rad(-3)),INK,Enum.Material.Metal)
    local bladeEdge = fitted("BladeVeilEdge",Vector3.new(.11,4.3,.68),
        CFrame.new(.19,3.4,0)*CFrame.Angles(0,0,math.rad(-3)),HOT,Enum.Material.Neon)
    fitted("BladeCrimsonCore",Vector3.new(.13,4.0,.4),
        CFrame.new(.04,3.28,-.15)*CFrame.Angles(0,0,math.rad(-3)),CRIMSON,Enum.Material.Metal)
    fitted("KissakiTip",Vector3.new(.19,.67,.54),
        CFrame.new(-.15,5.78,0)*CFrame.Angles(0,0,math.rad(-18)),HOT,Enum.Material.Neon)
    fitted("GoldTsuba",Vector3.new(1.2,.28,.9),
        CFrame.new(0,1.15,0),GOLD,Enum.Material.Metal)
    fitted("HiltWrap",Vector3.new(.45,.18,.46),
        CFrame.new(0,-.2,0),CRIMSON,Enum.Material.Fabric)
    fitted("Pommel",Vector3.new(.54,.32,.54),
        CFrame.new(0,-1.2,0),GOLD,Enum.Material.Metal)
    fitted("RedTassel",Vector3.new(.13,1.2,.13),
        CFrame.new(.35,-1.65,0),CRIMSON,Enum.Material.Fabric)
    -- Polearm blockouts: distinct reach silhouettes without imported meshes.
    -- Existing sword parts are hidden; these pieces weld to the same server tool.
    if weaponName=="Naginata" or weaponName=="Yari" then
        for _,part in ipairs(tool:GetChildren()) do
            if part:IsA("BasePart") and part.Name~="Handle" then
                part.Transparency=1
            end
        end
        handle.Size=Vector3.new(.28,4.5,.28)
        tool.Grip=CFrame.new(0,-1.5,0)
        fitted("PoleShaft",Vector3.new(.25,6.5,.25),
            CFrame.new(0,1.7,0),INK,Enum.Material.Wood)
        fitted("PoleWrap",Vector3.new(.33,1.6,.33),
            CFrame.new(0,-.8,0),CRIMSON,Enum.Material.Fabric)
        fitted("PoleCollar",Vector3.new(.48,.35,.48),
            CFrame.new(0,4.95,0),GOLD,Enum.Material.Metal)
        if weaponName=="Naginata" then
            fitted("NaginataCurvedBlade",Vector3.new(.23,2.6,.65),
                CFrame.new(.12,6.25,0)*CFrame.Angles(0,0,math.rad(-8)),
                HOT,Enum.Material.Metal)
            bladeEdge = fitted("NaginataEdge",Vector3.new(.09,2.35,.72),
                CFrame.new(.3,6.25,0)*CFrame.Angles(0,0,math.rad(-8)),
                Color3.fromRGB(245,224,235),Enum.Material.Neon)
        else
            bladeEdge = fitted("YariSpearhead",Vector3.new(.27,2.4,.38),
                CFrame.new(0,6.15,0),HOT,Enum.Material.Metal)
            fitted("YariPoint",Vector3.new(.15,.75,.2),
                CFrame.new(0,7.65,0),Color3.fromRGB(245,224,235),Enum.Material.Neon)
        end
    end
    -- Blade-attached trail is cosmetic. Client enables it only on server Swing.
    -- Attachment span creates a narrow anime-fantasy slash ribbon at the blade.
    local base = Instance.new("Attachment")
    base.Name = "TrailBase"
    base.Position = Vector3.new(0,-bladeEdge.Size.Y*.45,0)
    base.Parent = bladeEdge
    local tip = Instance.new("Attachment")
    tip.Name = "TrailTip"
    tip.Position = Vector3.new(0,bladeEdge.Size.Y*.45,0)
    tip.Parent = bladeEdge
    local trail = Instance.new("Trail")
    trail.Name = "VeilbladeTrail"
    trail.Attachment0 = base
    trail.Attachment1 = tip
    trail.Color = ColorSequence.new(CRIMSON,HOT)
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.14),
        NumberSequenceKeypoint.new(1,1)
    })
    trail.Lifetime = 0.15
    trail.MinLength = 0.05
    trail.LightEmission = 0.7
    trail.FaceCamera = true
    trail.Enabled = false
    trail.Parent = bladeEdge
    return tool
end

-- Optional real Studio-imported OBJ mesh visual.
-- The live hitbox/damage does NOT change; only the fallback parts are hidden.
-- Importers must preserve an origin at the grip midpoint (0,0,0).
local function applyImportedVisual(tool,weaponName)
    local art = ServerStorage:FindFirstChild("KageboundArt")
    local variants = {Katana="VeilbladeVisual",Nodachi="NodachiVisual",Tanto="TantoVisual",Naginata="NaginataVisual",Yari="YariVisual"}
    local visualName = variants[weaponName]
    if not visualName then return false end
    local reference = art and art:FindFirstChild(visualName)
    if not reference or not reference:IsA("Model") then return false end
    local handle = tool:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then return false end
    local clone = reference:Clone()
    clone.Name = visualName
    clone:PivotTo(handle.CFrame)
    local count = 0
    for _, part in ipairs(clone:GetDescendants()) do
        if part:IsA("LuaSourceContainer") then
            part:Destroy()
        elseif part:IsA("BasePart") then
            part.Anchored = false
            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false
            part.Massless = true
            part.CastShadow = false
            local weld = Instance.new("WeldConstraint")
            weld.Name = "VeilbladeVisualWeld"
            weld.Part0 = handle
            weld.Part1 = part
            weld.Parent = part
            count += 1
        end
    end
    if count == 0 then
        clone:Destroy()
        return false
    end
    -- Sanitize while detached; embedded code never enters an executing tree.
    clone.Parent = tool
    for _,part in ipairs(tool:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = 1 -- preserve invisible blade trail anchor
        end
    end
    tool:SetAttribute("KageboundImportedVisual",true)
    return true
end

local function equip(player,character,weaponName)
    local backpack = player:WaitForChild("Backpack",8)
    local humanoid = character:WaitForChild("Humanoid",8)
    if not backpack or not humanoid or humanoid.Health<=0
        or player.Character ~= character then return false end
    weaponName=weaponName or Authority.Get(player)
    if not weaponName or not Weapons.CanSelect(weaponName) then return false end

    -- Prepare replacement before removing the current registered weapon.
    -- No yielding after validation: selection and tool handoff stay atomic.
    local tool=createKatana(weaponName)
    applyImportedVisual(tool,weaponName)
    if player.Character~=character or humanoid.Health<=0 then
        tool:Destroy()
        return false
    end
    local previous=backpack:FindFirstChild("Veilblade")
    local held=character:FindFirstChild("Veilblade")
    if previous then previous.Name="VeilbladeRetired" end
    if held then held.Name="VeilbladeRetired" end
    tool.Parent=backpack
    if not Authority.RegisterTool(player,character,tool,weaponName) then
        tool:Destroy()
        if previous then previous.Name="Veilblade" end
        if held then held.Name="Veilblade" end
        return false
    end
    if previous then previous:Destroy() end
    if held then held:Destroy() end
    task.defer(function()
        if player.Character==character and humanoid.Health>0
            and Authority.Get(player)==weaponName and tool.Parent==backpack then
            humanoid:EquipTool(tool)
        end
    end)
    return true
end

local equipRequest=Instance.new("BindableFunction")
equipRequest.Name="KageboundEquipWeapon"
equipRequest.OnInvoke=function(player,weaponName)
    if player.Character==nil then return false end
    return equip(player,player.Character,weaponName)==true
end
equipRequest.Parent=script.Parent

local function register(player)
    player.CharacterAdded:Connect(function(char)
        Authority.ClearTool(player)
        task.spawn(equip,player,char)
    end)
    if player.Character then task.spawn(equip,player,player.Character) end
end

Players.PlayerAdded:Connect(register)
for _,player in ipairs(Players:GetPlayers()) do register(player) end
print("[KAGEBOUND] Veilblade prototype equipment ready (ART-003)")
