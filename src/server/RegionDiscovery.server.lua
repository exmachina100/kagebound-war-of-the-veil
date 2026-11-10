-- Server-owned Grand World discovery, session only; no DataStore writes.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Regions=require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("RegionRules"))
local seen={}
local lastRegion={}
local function register(player)
    seen[player]={}
    lastRegion[player]=nil
    player:SetAttribute("KageboundRegion","")
    player:SetAttribute("KageboundRegionsDiscovered",0)
end
local function tickPlayer(player)
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health<=0 or not root then return end
    local zone=Regions.At(root.Position)
    local id=zone and zone.id or ""
    if lastRegion[player]~=id then
        lastRegion[player]=id
        player:SetAttribute("KageboundRegion",id)
    end
    if zone and not seen[player][id] then
        seen[player][id]=true
        local count=0
        for _ in pairs(seen[player]) do count+=1 end
        player:SetAttribute("KageboundRegionsDiscovered",count)
        -- World exploration is not a currency award. Rewards require a
        -- separate server-authoritative, replay-safe receipt contract.
        print("[KAGEBOUND] Region discovered:",player.UserId,id,count)
    end
end
Players.PlayerAdded:Connect(register)
for _,player in ipairs(Players:GetPlayers()) do register(player) end
Players.PlayerRemoving:Connect(function(player)
    seen[player]=nil
    lastRegion[player]=nil
end)
task.spawn(function()
    while true do
        task.wait(0.5)
        for _,player in ipairs(Players:GetPlayers()) do
            if seen[player] then tickPlayer(player) end
        end
    end
end)
