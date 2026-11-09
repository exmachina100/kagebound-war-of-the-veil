-- Run ONLY in the SERVER Command Bar during a local Studio Play test.
-- Grants one deliberately artificial 6-shard test reward in that play session.
-- Quitting Play discards it; this is not a live-server test harness.
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Rewards = require(game.ServerScriptService.KageboundServer:WaitForChild("RewardService"))
local Policy = require(game.ReplicatedStorage.KageboundShared:WaitForChild("RewardPolicy"))
local player = Players:GetPlayers()[1]
assert(player, "Start a local Studio Play test with at least one player")
local function check(label, truth)
    assert(truth, "[KAGEBOUND REWARD TEST FAIL] "..label)
    print("[KAGEBOUND REWARD TEST PASS] "..label)
end
local start = Rewards.Snapshot(player)
local token = "qa-"..HttpService:GenerateGUID(false)
local granted, info = Rewards.Award(player, "LanternYokai", token)
check("First server award accepted", granted and type(info) == "table")
local second = Rewards.Award(player, "LanternYokai", token)
check("Duplicate encounter rejected", second == false)
local unknown = Rewards.Award(player, "OnePieceFruit", "irrelevant")
check("Unknown source rejected", unknown == false)
local blank = Rewards.Award(player, "LanternYokai", "")
check("Empty award key rejected", blank == false)
local finished = Rewards.Snapshot(player)
check("Exactly one reward applied", finished.shards == start.shards + Policy.Get("LanternYokai").shards)
check("Mastery credited exactly once", finished.mastery == start.mastery + Policy.Get("LanternYokai").mastery)
check("Defeat count once", finished.yokaiDefeats == start.yokaiDefeats + 1)
check("Read-only HUD attribute mirrors server", player:GetAttribute("KageboundSpiritShards") == finished.shards)
print("[KAGEBOUND] Progression service local contract checks passed")
