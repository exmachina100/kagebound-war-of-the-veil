-- KAGEBOUND Studio-only integration smoke report.
-- Checks Rojo-generated structure after the Grand World has had time to initialize.
-- It does NOT simulate combat, verify live NPC AI, or certify visual quality.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local shared=ReplicatedStorage:WaitForChild("KageboundShared",15)
if not shared then warn("[KAGEBOUND SMOKE] Shared modules not synchronized") return end
local worldConfig=require(shared:WaitForChild("WorldConfig"))
local successes=0
local failures=0
local function check(label,predicate)
    if predicate then
        successes+=1
        print("[KAGEBOUND SMOKE PASS] "..label)
    else
        failures+=1
        warn("[KAGEBOUND SMOKE FAIL] "..label)
    end
end
check("CombatRules present",shared:FindFirstChild("CombatRules")~=nil)
check("MaskRules present",shared:FindFirstChild("MaskRules")~=nil)
check("ClassRules present",shared:FindFirstChild("ClassRules")~=nil)
check("ClanRules present",shared:FindFirstChild("ClanRules")~=nil)
check("Four-class VFX profiles present",shared:FindFirstChild("VFXProfiles")~=nil)
check("VFX texture catalog present",shared:FindFirstChild("VFXTextureCatalog")~=nil)
check("RewardPolicy present",shared:FindFirstChild("RewardPolicy")~=nil)
check("ProfileSchema present",shared:FindFirstChild("ProfileSchema")~=nil)
check("PersistenceConfig present",shared:FindFirstChild("PersistenceConfig")~=nil)
check("Server RewardService present",script.Parent:FindFirstChild("RewardService")~=nil)
check("Disabled-by-default ProfileStore present",script.Parent:FindFirstChild("ProfileStore")~=nil)
check("Server EnemyDamage present",script.Parent:FindFirstChild("EnemyDamage")~=nil)
check("Four-class service present",script.Parent:FindFirstChild("ClassService")~=nil)
check("Server Match QueueRegistry present",script.Parent:FindFirstChild("QueueRegistry")~=nil)
check("ClanClash server controller present",script.Parent:FindFirstChild("ClanClash")~=nil)
check("Four-class remote service script present",script.Parent:FindFirstChild("ClassLoadout")~=nil)
check("Shinobi appearance script present",script.Parent:FindFirstChild("ShinobiAppearance")~=nil)
check("Veilblade equipment script present",script.Parent:FindFirstChild("Veilblade")~=nil)
check("Combat remote active",ReplicatedStorage:WaitForChild("KageboundCombat",20)~=nil)
check("Three-mask remote active",ReplicatedStorage:WaitForChild("KageboundMask",20)~=nil)
check("Four-class remote active",ReplicatedStorage:WaitForChild("KageboundClass",20)~=nil)
check("Clan Clash remote active",ReplicatedStorage:WaitForChild("KageboundClanClash",20)~=nil)
check("Kitsune decoy remote active",ReplicatedStorage:WaitForChild("KageboundKitsune",20)~=nil)
if worldConfig.Enabled then
    local world=Workspace:WaitForChild("KageboundWorld",35)
    check("Grand World generated",world~=nil)
    -- The world folder is parented before districts are built across yielded frames.
    local moonfall=world and world:WaitForChild("MoonfallBamboo",35)
    check("Moonfall Bamboo region",moonfall~=nil)
    local enemies=Workspace:WaitForChild("KageboundEnemies",25)
    check("Original Yokai folder created",enemies~=nil)
    if enemies then
        local deadline=os.clock()+6
        while enemies.Parent and #enemies:GetChildren()<3 and os.clock()<deadline do
            task.wait(.2)
        end
        check("Three Yokai spawned",#enemies:GetChildren()>=3)
    end
    check("Regional Veilfall remote active",
        ReplicatedStorage:WaitForChild("KageboundVeilfall",20)~=nil)
else
    check("Legacy arena exists",Workspace:WaitForChild("KageboundArena",30)~=nil)
end
print(("[KAGEBOUND SMOKE] %d checks passed, %d failed; inspect client output separately."):format(successes,failures))
