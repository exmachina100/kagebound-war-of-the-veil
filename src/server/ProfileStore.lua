-- KAGEBOUND ProfileStore — opt-in DataStore adapter, NOT YET LIVE.
-- No requests are made while PersistenceConfig.Enabled=false.
-- Future RewardService integration requires Studio save/reload and concurrency QA.
local DataStoreService=game:GetService("DataStoreService")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KageboundShared")
local Config=require(Shared:WaitForChild("PersistenceConfig"))
local Schema=require(Shared:WaitForChild("ProfileSchema"))
local Policy=require(Shared:WaitForChild("RewardPolicy"))
local Store={}

local handle=nil
if Config.Enabled then
    handle=DataStoreService:GetDataStore(Config.StoreName)
end

local function keyFor(player)
    if typeof(player)~="Instance" or not player:IsA("Player") then return nil end
    return "user_"..tostring(player.UserId)
end

function Store.IsEnabled()
    return Config.Enabled==true and handle~=nil
end

local function retryRequest(fn)
    for attempt=1,Config.MaxRetries do
        local ok,value=pcall(fn)
        if ok and value~=nil then return true,value end
        if attempt<Config.MaxRetries then
            local waitSeconds=math.min(1.4*2^(attempt-1),5)
            task.wait(waitSeconds+math.random()*.25) -- never yield in UpdateAsync callback
        end
    end
    return false,nil
end

function Store.Load(player)
    if not Store.IsEnabled() then return false,"persistence disabled" end
    local key=keyFor(player)
    if not key then return false,"invalid player" end
    local ok,result=retryRequest(function()
        -- For an empty profile GetAsync returns nil, which means a new user.
        local value=handle:GetAsync(key)
        return value==nil and Schema.New() or value
    end)
    if not ok then return false,"datastore read unavailable" end
    local profile=Schema.Reconcile(result)
    if not profile then return false,"unsupported future schema" end
    return true,profile
end

-- Later called by trusted server-side event journal only.
-- Never expose this API to a RemoteEvent, player-supplied amounts or tokens.
-- UpdateAsync's callback is deterministic and does not yield.
function Store.SaveEvents(player,events)
    if not Store.IsEnabled() then return false,"persistence disabled" end
    local key=keyFor(player)
    if not key or typeof(events)~="table"
        or #events<1 or #events>Config.MaxEventsPerCommit then
        return false,"invalid event batch"
    end
    -- Validate the entire batch before opening a network transaction.
    for _,event in ipairs(events) do
        if typeof(event)~="table" or not Policy.Get(event.source)
            or not Policy.ValidKey(event.token) then
            return false,"invalid event"
        end
    end
    local ok,result=retryRequest(function()
        return handle:UpdateAsync(key,function(old,keyInfo)
            local state=Schema.Reconcile(old)
            if not state then return nil end -- refuse downgrade
            for _,event in ipairs(events) do
                local nextState=Schema.Apply(state,event.source,event.token)
                if not nextState then return nil end
                state=nextState
            end
            local userIds=keyInfo and keyInfo:GetUserIds() or {player.UserId}
            local metadata=keyInfo and keyInfo:GetMetadata() or {}
            return state,userIds,metadata
        end)
    end)
    if not ok then return false,"datastore write unavailable or unsupported schema" end
    local profile=Schema.Reconcile(result)
    if not profile then return false,"schema verification failed" end
    return true,profile
end

return Store
