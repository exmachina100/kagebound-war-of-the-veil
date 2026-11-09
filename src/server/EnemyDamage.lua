-- KAGEBOUND EnemyDamage — server-only shared source of truth for Yokai HP.
-- Used by katana attacks and original Oni mask. All inputs are authored by
-- trusted server scripts, but validated here again to prevent later misuse.
local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local DuelAuthority=require(script.Parent:WaitForChild("DuelService"))
local Service={}

local function finite(v)
    return typeof(v)=="number" and v==v and v~=math.huge and v~=-math.huge
end

function Service.IsValidHit(distance,health,damage,maxRange)
    return finite(distance) and distance>=0
        and finite(health) and health>0
        and finite(damage) and damage>0 and damage<=50
        and finite(maxRange) and maxRange>0 and maxRange<=25
        and distance<=maxRange+1
end

-- Returns applied (boolean), new HP (number or nil).
-- Does not decide visual effects or rewards; those stay separate.
function Service.Apply(attacker,model,damage,maxRange,staggerSeconds)
    if typeof(attacker)~="Instance" or not attacker:IsA("Player")
        or attacker.Parent~=Players or DuelAuthority.IsParticipant(attacker) then
        return false
    end
    local enemyFolder=Workspace:FindFirstChild("KageboundEnemies")
    if not enemyFolder or typeof(model)~="Instance" or not model:IsA("Model")
        or model.Parent~=enemyFolder
        or model:GetAttribute("KageboundEnemy")~=true
        or not model.PrimaryPart then return false end
    local char=attacker.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health<=0 then return false end
    local hp=model:GetAttribute("Health")
    local distance=(model.PrimaryPart.Position-root.Position).Magnitude
    if not Service.IsValidHit(distance,hp,damage,maxRange) then return false end

    -- Roblox Lua callbacks are sequential until a yield; this branch contains
    -- none, so two server attacks cannot spend the same final HP twice.
    local newHp=math.max(0,hp-damage)
    model:SetAttribute("LastDamagerUserId",attacker.UserId)
    model:SetAttribute("LastDamagedAt",os.clock())
    local stagger=finite(staggerSeconds) and math.clamp(staggerSeconds,0,1.5) or .15
    model:SetAttribute("StaggerUntil",os.clock()+stagger)
    model:SetAttribute("Health",newHp)
    return true,newHp
end
return Service
