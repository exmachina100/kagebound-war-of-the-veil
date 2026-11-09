-- KAGEBOUND default Shinobi hero visual prototype (ART-001, ART-002).
-- This is a lightweight welded blockout, not a substitute for final R15 mesh/rigger work.
-- Accessories never collide, touch, query or affect server gameplay hitboxes.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("GameConfig"))

local C = {
    ink = Color3.fromRGB(27,27,40),
    graphite = Color3.fromRGB(51,50,67),
    shadow = Color3.fromRGB(16,17,30),
    crimson = Color3.fromRGB(142,30,65),
    scarf = Color3.fromRGB(190,42,79),
    ivory = Color3.fromRGB(246,232,241),
    seal = Color3.fromRGB(246,89,153),
    gold = Color3.fromRGB(215,158,88)
}

local function mount(container,anchor,name,size,offset,color,material,wedge)
    if not anchor or not anchor:IsA("BasePart") then return nil end
    local item = Instance.new(wedge and "WedgePart" or "Part")
    item.Name = name
    item.Size = size
    item.CFrame = anchor.CFrame*offset
    item.Anchored = false
    item.Massless = true
    item.CanCollide = false
    item.CanTouch = false
    item.CanQuery = false
    item.CastShadow = false
    item.Color = color
    item.Material = material or Enum.Material.SmoothPlastic
    item.Parent = container
    local weld = Instance.new("WeldConstraint")
    weld.Name = "AppearanceWeld"
    weld.Part0 = anchor
    weld.Part1 = item
    weld.Parent = item
    return item
end

local function build(character)
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local head = character:FindFirstChild("Head")
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if not head or not torso then return end
    local existing = character:FindFirstChild("KageboundShinobiAppearance")
    if existing then existing:Destroy() end
    local model = Instance.new("Model")
    model.Name = "KageboundShinobiAppearance"
    model:SetAttribute("VisualReference", "ART-001 / ART-002")
    model.Parent = character

    -- Layered silhouette: broad shoulder armor and a short floating scarf.
    mount(model,torso,"UpperArmor",Vector3.new(2.35,.72,1.16),
        CFrame.new(0,.26,.03),C.ink,Enum.Material.SmoothPlastic)
    mount(model,torso,"Breastplate",Vector3.new(1.75,.65,.20),
        CFrame.new(0,-.04,-.63),C.graphite,Enum.Material.Metal)
    mount(model,torso,"CrimsonChestBand",Vector3.new(2.1,.16,.22),
        CFrame.new(0,-.29,-.78)*CFrame.Angles(0,0,math.rad(-12)),C.crimson,Enum.Material.Fabric)
    mount(model,torso,"ScarfCollar",Vector3.new(2.3,.34,1.45),
        CFrame.new(0,.76,-.04),C.scarf,Enum.Material.Fabric)
    mount(model,torso,"ScarfTailA",Vector3.new(.36,1.65,.14),
        CFrame.new(-.70,.02,.8)*CFrame.Angles(math.rad(17),0,math.rad(22)),C.crimson,Enum.Material.Fabric)
    mount(model,torso,"ScarfTailB",Vector3.new(.31,1.27,.14),
        CFrame.new(-1.09,.09,.78)*CFrame.Angles(math.rad(-22),0,math.rad(47)),C.scarf,Enum.Material.Fabric)
    mount(model,torso,"GoldHarness",Vector3.new(.48,.20,.22),
        CFrame.new(.5,-.08,-.76)*CFrame.Angles(0,0,math.rad(-28)),C.gold,Enum.Material.Metal)
    mount(model,torso,"FoxCharm",Vector3.new(.25,.48,.13),
        CFrame.new(.64,-.58,-.78),C.ivory,Enum.Material.SmoothPlastic)

    -- The white fox mask is worn at an angle on the forehead, not a full head replacement.
    local maskOffset=CFrame.new(.07,.36,-.62)*CFrame.Angles(math.rad(-18),0,math.rad(-13))
    mount(model,head,"KitsuneForeheadMask",Vector3.new(1.49,.68,.20),
        maskOffset,C.ivory,Enum.Material.SmoothPlastic)
    for _,side in ipairs({-1,1}) do
        mount(model,head,"FoxEar"..side,Vector3.new(.40,.76,.20),
            maskOffset*CFrame.new(side*.50,.62,0)*CFrame.Angles(0,0,math.rad(-side*16)),
            C.ivory,Enum.Material.SmoothPlastic,true)
        mount(model,head,"FoxEyemark"..side,Vector3.new(.37,.09,.06),
            maskOffset*CFrame.new(side*.36,-.09,-.15)*CFrame.Angles(0,0,math.rad(side*17)),
            C.seal,Enum.Material.Neon)
    end
    -- Pointed black hair tufts rather than a smooth helmet.
    for i=1,5 do
        local horizontal=(i-3)*.30
        mount(model,head,"ShadowHair"..i,Vector3.new(.46,.87,.60),
            CFrame.new(horizontal,.74,.18)*CFrame.Angles(math.rad(-12),0,math.rad((i-3)*18)),
            C.shadow,Enum.Material.SmoothPlastic,true)
    end
    local arms = {
        character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm"),
        character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm")
    }
    for i,arm in ipairs(arms) do
        if arm then
            mount(model,arm,"Gauntlet"..i,Vector3.new(arm.Size.X+.22,.55,arm.Size.Z+.18),
                CFrame.new(0,-arm.Size.Y*.24,0),C.graphite,Enum.Material.Metal)
            mount(model,arm,"CrimsonBand"..i,Vector3.new(arm.Size.X+.26,.16,arm.Size.Z+.22),
                CFrame.new(0,-arm.Size.Y*.36,0),C.crimson,Enum.Material.Fabric)
        end
    end
    local legs = {
        character:FindFirstChild("LeftLowerLeg") or character:FindFirstChild("Left Leg"),
        character:FindFirstChild("RightLowerLeg") or character:FindFirstChild("Right Leg")
    }
    for i,leg in ipairs(legs) do
        if leg then
            mount(model,leg,"ShinobiGreave"..i,Vector3.new(leg.Size.X+.22,.52,leg.Size.Z+.21),
                CFrame.new(0,-leg.Size.Y*.18,-.03),C.ink,Enum.Material.Metal)
        end
    end
end

local function apply(player,character)
    local deadline=os.clock()+8
    while character.Parent and os.clock()<deadline do
        if character:FindFirstChild("Head") and
            (character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")) then
            if (player:GetAttribute("KageboundWarriorStyle") or GameConfig.InitialWarrior)=="Shinobi" then
                build(character)
            end
            return
        end
        task.wait(.1)
    end
end

local function onPlayer(player)
    if player:GetAttribute("KageboundWarriorStyle")==nil then
        player:SetAttribute("KageboundWarriorStyle",GameConfig.InitialWarrior)
    end
    player.CharacterAdded:Connect(function(character)
        task.spawn(apply,player,character)
    end)
    if player.Character then task.spawn(apply,player,player.Character) end
end
Players.PlayerAdded:Connect(onPlayer)
for _,player in ipairs(Players:GetPlayers()) do onPlayer(player) end
print("[KAGEBOUND] ART-002 Shinobi starter appearance configured")
