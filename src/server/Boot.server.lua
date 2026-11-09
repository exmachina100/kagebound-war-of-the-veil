local ReplicatedStorage = game:GetService("ReplicatedStorage")
local config = require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("GameConfig"))
print("[KAGEBOUND] Server boot:", config.Title, "| Stage: foundation only")
