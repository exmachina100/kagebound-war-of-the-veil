local ReplicatedStorage = game:GetService("ReplicatedStorage")
local config = require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("GameConfig"))
print("[KAGEBOUND] Client boot:", config.Title)
