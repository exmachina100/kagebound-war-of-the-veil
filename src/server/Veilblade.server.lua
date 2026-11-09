-- KAGEBOUND Veilblade: lightweight procedural starter katana.
-- Reference ART-003 weapon board. This is a *visual blockout*, not a final mesh.
-- Server creates one tool per spawn; combat authority remains Combat.server.lua.
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local INK = Color3.fromRGB(32,30,51)
local CRIMSON = Color3.fromRGB(145,31,65)
local HOT = Color3.fromRGB(255,91,153)
local GOLD = Color3.fromRGB(226,166,92)

local function createKatana()
    local tool = Instance.new("Tool")
    tool.Name = "Veilblade"
    tool.ToolTip = "KAGEBOUND • Shinobi Katana [ART-003]"
    tool.CanBeDropped = false
    tool.RequiresHandle = true
    tool.Grip = CFrame.new(0,-.4,0)

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(.37,2.2,.37)
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
        p.Size = size
        p.Color = color
        p.Material = material or Enum.Material.SmoothPlastic
        p.CFrame = handle.CFrame*offset
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
    -- Blade-attached trail is cosmetic. Client enables it only on server Swing.
    -- Attachment span creates a narrow anime-fantasy slash ribbon at the blade.
    local base = Instance.new("Attachment")
    base.Name = "TrailBase"
    base.Position = Vector3.new(0,-1.85,0)
    base.Parent = bladeEdge
    local tip = Instance.new("Attachment")
    tip.Name = "TrailTip"
    tip.Position = Vector3.new(0,1.95,0)
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
local function applyImportedVisual(tool)
    local art = ServerStorage:FindFirstChild("KageboundArt")
    local reference = art and art:FindFirstChild("VeilbladeVisual")
    if not reference or not reference:IsA("Model") then return false end
    local handle = tool:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then return false end
    local clone = reference:Clone()
    clone.Name = "VeilbladeVisual"
    clone.Parent = tool
    clone:PivotTo(handle.CFrame)
    local count = 0
    for _, part in ipairs(clone:GetDescendants()) do
        if part:IsA("BasePart") then
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
    for _,part in ipairs(tool:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = 1 -- preserve invisible blade trail anchor
        end
    end
    tool:SetAttribute("KageboundImportedVisual",true)
    return true
end

local function equip(player,character)
    local backpack = player:WaitForChild("Backpack",8)
    local humanoid = character:WaitForChild("Humanoid",8)
    if not backpack or not humanoid or player.Character ~= character then return end
    local previous = backpack:FindFirstChild("Veilblade")
    if previous then previous:Destroy() end
    local held = character:FindFirstChild("Veilblade")
    if held then held:Destroy() end
    local tool = createKatana()
    applyImportedVisual(tool) -- fallback stays visible unless Studio import exists
    tool.Parent = backpack
    -- Automatically equip for MVP combat; the player can switch weapons later.
    task.defer(function()
        if player.Character == character and humanoid.Health > 0 and tool.Parent == backpack then
            humanoid:EquipTool(tool)
        end
    end)
end

local function register(player)
    player.CharacterAdded:Connect(function(char)
        task.spawn(equip,player,char)
    end)
    if player.Character then task.spawn(equip,player,player.Character) end
end

Players.PlayerAdded:Connect(register)
for _,player in ipairs(Players:GetPlayers()) do register(player) end
print("[KAGEBOUND] Veilblade prototype equipment ready (ART-003)")
