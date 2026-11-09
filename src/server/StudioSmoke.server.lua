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
check("RewardPolicy present",shared:FindFirstChild("RewardPolicy")~=nil)
check("Server RewardService present",script.Parent:FindFirstChild("RewardService")~=nil)
check("Shinobi appearance script present",script.Parent:FindFirstChild("ShinobiAppearance")~=nil)
check("Veilblade equipment script present",script.Parent:FindFirstChild("Veilblade")~=nil)
check("Combat remote active",ReplicatedStorage:WaitForChild("KageboundCombat",20)~=nil)
if worldConfig.Enabled then
    local world=Workspace:WaitForChild("KageboundWorld",35)
    check("Grand World generated",world~=nil)
    local moonfall=world and world:FindFirstChild("MoonfallBamboo")
    check("Moonfall Bamboo region",moonfall~=nil)
    local enemies=Workspace:WaitForChild("KageboundEnemies",25)
    check("Original Yokai folder created",enemies~=nil)
    if enemies then
        check("Three Yokai spawned",#enemies:GetChildren()>=3)
    end
    check("Regional Veilfall remote active",
        ReplicatedStorage:WaitForChild("KageboundVeilfall",20)~=nil)
else
    check("Legacy arena exists",Workspace:WaitForChild("KageboundArena",30)~=nil)
end
print(("[KAGEBOUND SMOKE] %d checks passed, %d failed; inspect client output separately."):format(successes,failures))
