-- KAGEBOUND first original exploration quest: "Whispers Across the Veil".
-- Inspired by WORLD_VISION.md, NOT any One Piece quest code.
-- Server owns quest state, proximity validation and test reward.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local cfg=require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("WorldConfig"))
local Rewards=require(script.Parent:WaitForChild("RewardService"))
if not cfg.Enabled then return end
local world=Workspace:WaitForChild("KageboundWorld",45)
if not world then warn("[KAGEBOUND] Quest system: world missing") return end
local hub=world:WaitForChild("KageDojo",10)
if not hub then return end
local messages=ReplicatedStorage:FindFirstChild("KageboundQuestEvent") or Instance.new("RemoteEvent")
messages.Name="KageboundQuestEvent"
messages.Parent=ReplicatedStorage
local quests={}
local shrine=Instance.new("Model")
shrine.Name="ShrineKeeper_QuestGiver"
shrine.Parent=hub
local function part(name,size,position,color)
    local p=Instance.new("Part")
    p.Name=name
    p.Size=size
    p.Position=position
    p.Anchored=true
    p.CanCollide=false
    p.Material=Enum.Material.SmoothPlastic
    p.Color=color
    p.Parent=shrine
    return p
end
local torso=part("KeeperRobe",Vector3.new(3,5,2),Vector3.new(24,4,15),Color3.fromRGB(95,57,125))
part("KeeperMask",Vector3.new(2.4,2.4,1.4),Vector3.new(24,7.2,15),Color3.fromRGB(242,218,209))
part("KeeperHat",Vector3.new(4.2,.7,3.5),Vector3.new(24,8.6,15),Color3.fromRGB(142,51,77))
local prompt=Instance.new("ProximityPrompt")
prompt.Name="TalkToKeeper"
prompt.ActionText="Speak"
prompt.ObjectText="Keeper of the Veil"
prompt.MaxActivationDistance=12
prompt.RequiresLineOfSight=false
prompt.HoldDuration=.35
prompt.Parent=torso
local function stage(player)
    return quests[player.UserId] or 0
end
local function send(player,msg)
    messages:FireClient(player,msg,stage(player))
end
prompt.Triggered:Connect(function(player)
    local char=player.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root or (root.Position-torso.Position).Magnitude>15 then return end
    local st=stage(player)
    if st==0 then
        quests[player.UserId]=1
        send(player,"QUEST ACCEPTED: Whispers Across the Veil — travel to Moonfall Bamboo.")
    elseif st==1 then
        send(player,"Follow the north lantern road and discover the Moonfall Bamboo shrine.")
    elseif st==2 then
        quests[player.UserId]=3
        local awarded, receipt=Rewards.Award(player,"WhispersQuest","first-completion")
        if awarded then
            -- Retain historical quest-specific attribute for old HUDs.
            player:SetAttribute("KageboundQuestShards",25)
            send(player,"QUEST COMPLETE: +25 Spirit Shards (session only).")
        else
            send(player,"QUEST COMPLETE: reward already recorded for this session.")
        end
    else
        send(player,"The veil remembers your journey. Explore the other realms.")
    end
end)
local moon
for _,zone in ipairs(cfg.Zones) do if zone.id=="MoonfallBamboo" then moon=zone end end
Players.PlayerAdded:Connect(function(player)
    quests[player.UserId]=0
    player:SetAttribute("KageboundQuestShards",0)
    send(player,"Explore Kage Dojo. Speak to the Keeper of the Veil to begin.")
end)
for _,player in ipairs(Players:GetPlayers()) do
    quests[player.UserId]=0
    player:SetAttribute("KageboundQuestShards",0)
end
Players.PlayerRemoving:Connect(function(player) quests[player.UserId]=nil end)
task.spawn(function()
    while shrine.Parent do
        if moon then
            for _,player in ipairs(Players:GetPlayers()) do
                if stage(player)==1 then
                    local char=player.Character
                    local root=char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local delta=Vector2.new(root.Position.X-moon.x,root.Position.Z-moon.z)
                        if delta.Magnitude<90 then
                            quests[player.UserId]=2
                            send(player,"MOONFALL DISCOVERED — return to the Keeper in Kage Dojo.")
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)
print("[KAGEBOUND] World exploration quest initialized")
