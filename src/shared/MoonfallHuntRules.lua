-- Pure Moonfall hunt progression policy; no remotes, currency or player attributes.
local Rules={}
Rules.Goal=3
Rules.RewardSource="MoonfallHunt"
Rules.RewardToken="MoonfallHuntV1"
local function count(value)
    return typeof(value)=="number" and value==value
        and value~=math.huge and value~=-math.huge and value>=0
        and value%1==0
end
function Rules.ValidCount(value)
    return count(value)
end
function Rules.Progress(baseline,current,previous)
    if not count(baseline) or not count(current) or not count(previous) then
        return nil
    end
    -- Counter resets must never subtract progress or mint progress.
    if current<baseline then return math.min(Rules.Goal,previous) end
    return math.min(Rules.Goal,math.max(previous,current-baseline))
end
function Rules.CanAccept(status,alive,distance)
    return status=="Available" and alive==true
        and typeof(distance)=="number" and distance==distance
        and distance>=0 and distance<=15
end
return Rules
