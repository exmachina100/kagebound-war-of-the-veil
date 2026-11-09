-- Server-only, session-scoped Spirit Shards & Veilblade Mastery service.
-- No DataStore or player-to-player trading in this prototype.
-- Clients can READ mirrored attributes; client attribute edits never grant rewards.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Policy = require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("RewardPolicy"))

local Service = {}
local sessions = {}

local function newSession()
    return {shards = 0, mastery = 0, yokaiDefeats = 0, awarded = {}}
end

local function mirror(player, record)
    player:SetAttribute("KageboundSpiritShards",record.shards)
    player:SetAttribute("KageboundVeilbladeMastery",record.mastery)
    player:SetAttribute("KageboundYokaiDefeats",record.yokaiDefeats)
end

local function initialize(player)
    local record = sessions[player]
    if not record then
        record = newSession()
        sessions[player] = record
        mirror(player,record)
    end
    return record
end

-- Only trusted server scripts call this method. Never expose via RemoteEvent.
-- A unique source:token pair is credited once per current server session.
function Service.Award(player, source, token)
    if typeof(player) ~= "Instance" or not player:IsA("Player")
        or player.Parent ~= Players then return false, "invalid player" end
    local rule = Policy.Get(source)
    if not rule or not Policy.ValidKey(token) then return false, "invalid reward" end
    local record = initialize(player)
    local id = source..":"..token
    if record.awarded[id] then return false, "already awarded" end
    record.awarded[id] = true
    record.shards = math.clamp(record.shards+rule.shards,0,1000000)
    record.mastery = math.clamp(record.mastery+rule.mastery,0,1000000)
    if source == "LanternYokai" then
        record.yokaiDefeats = math.clamp(record.yokaiDefeats+1,0,1000000)
    end
    mirror(player,record)
    return true, {shards=rule.shards, mastery=rule.mastery, total=record.shards}
end

function Service.Snapshot(player)
    local record = sessions[player]
    if not record then return nil end
    return {shards=record.shards, mastery=record.mastery, yokaiDefeats=record.yokaiDefeats}
end

Players.PlayerAdded:Connect(initialize)
for _,player in ipairs(Players:GetPlayers()) do initialize(player) end
Players.PlayerRemoving:Connect(function(player) sessions[player] = nil end)
return Service
