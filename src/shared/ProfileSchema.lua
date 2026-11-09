-- Original KAGEBOUND v1 profile schema: deterministic, no yielding.
-- Intended for UpdateAsync callbacks after a separate opt-in Studio test.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Policy=require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("RewardPolicy"))
local Schema={}
Schema.Version=1
Schema.MaxRecentEncounters=128
Schema.MaxCount=1000000

local function bounded(value)
    if typeof(value)~="number" or value~=value or value==math.huge or value==-math.huge then
        return 0
    end
    return math.clamp(math.floor(value),0,Schema.MaxCount)
end

function Schema.New()
    return {
        version=Schema.Version,
        shards=0, mastery=0, yokaiDefeats=0,
        completedWhispers=false,
        recentEncounters={}
    }
end

-- Future versions are refused to avoid destructive downgrades.
-- Untrusted schema values are sanitized, and only bounded receipt tokens survive.
function Schema.Reconcile(raw)
    if typeof(raw)~="table" then return Schema.New() end
    if raw.version~=nil and (typeof(raw.version)~="number"
        or raw.version>Schema.Version or raw.version<0) then return nil end
    local r=Schema.New()
    r.shards=bounded(raw.shards)
    r.mastery=bounded(raw.mastery)
    r.yokaiDefeats=bounded(raw.yokaiDefeats)
    r.completedWhispers=raw.completedWhispers==true
    local seen={}
    if typeof(raw.recentEncounters)=="table" then
        for _,token in ipairs(raw.recentEncounters) do
            if Policy.ValidKey(token) and not seen[token]
                and #r.recentEncounters<Schema.MaxRecentEncounters then
                seen[token]=true
                table.insert(r.recentEncounters,token)
            end
        end
    end
    return r
end

-- Apply one *trusted server-authorized* reward event.
-- This method is pure: it never mutates the record from DataStore.
-- Returns newProfile, acceptedBool. Repeated UpdateAsync callbacks are safe.
function Schema.Apply(raw,source,token)
    local profile=Schema.Reconcile(raw)
    if not profile then return nil,false end
    local rule=Policy.Get(source)
    if not rule or not Policy.ValidKey(token) then return profile,false end
    if source=="WhispersQuest" then
        if profile.completedWhispers then return profile,false end
        profile.completedWhispers=true
    elseif source=="LanternYokai" then
        if table.find(profile.recentEncounters,token) then return profile,false end
        table.insert(profile.recentEncounters,token)
        while #profile.recentEncounters>Schema.MaxRecentEncounters do
            table.remove(profile.recentEncounters,1)
        end
        profile.yokaiDefeats=bounded(profile.yokaiDefeats+1)
    else
        return profile,false
    end
    profile.shards=bounded(profile.shards+rule.shards)
    profile.mastery=bounded(profile.mastery+rule.mastery)
    return profile,true
end
return Schema
