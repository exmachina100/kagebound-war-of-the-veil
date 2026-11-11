-- Moonfall Hunt: server-owned Lantern Yokai bounty, session-scoped.
-- Uses RewardService's authoritative defeat count; no client RemoteEvent or client amount.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local Rewards=require(script.Parent:WaitForChild("RewardService"))
local World=require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("WorldConfig"))
if not World.Enabled then return end
local zone
for _,z in ipairs(World.Zones) do
    if z.id=="MoonfallBamboo" then zone=z break end
end
if not zone then return end
local world=Workspace:WaitForChild("KageboundWorld",45)
local district=world and world:WaitForChild("MoonfallBamboo",45)
if not district then return end
local questRoot=Instance.new("Part")
questRoot.Name="MoonfallHuntNotice"
questRoot.Size=Vector3.new(5,6,2)
questRoot.CFrame=CFrame.new(zone.x+35,5,zone.z+45)
questRoot.Anchored=true
questRoot.Material=Enum.Material.Wood
questRoot.Color=Color3.fromRGB(73,48,60)
questRoot.CanCollide=true
questRoot.Parent=district
local prompt=Instance.new("ProximityPrompt")
prompt.Name="AcceptMoonfallHunt"
prompt.ActionText="Accept Yokai Hunt"
prompt.ObjectText="Moonfall Bounty Board"
prompt.MaxActivationDistance=12
prompt.HoldDuration=.5
prompt.RequiresLineOfSight=true
prompt.Parent=questRoot
local GOAL=3
local records={}
local function publish(player,record)
    player:SetAttribute("KageboundHuntStatus",record.status)
    player:SetAttribute("KageboundHuntProgress",record.progress)
    player:SetAttribute("KageboundHuntGoal",GOAL)
end
local function register(player)
    local record={status="Available",progress=0,baseline=0}
    records[player]=record
    publish(player,record)
    player:GetAttributeChangedSignal("KageboundYokaiDefeats"):Connect(function()
        if records[player]~=record or record.status~="Active" then return end
        local defeats=player:GetAttribute("KageboundYokaiDefeats")
        if typeof(defeats)~="number" then return end
        record.progress=math.clamp(math.floor(defeats-record.baseline),0,GOAL)
        if record.progress>=GOAL then
            -- Fixed server reward policy and one session receipt.
            local awarded=Rewards.Award(player,"WhispersQuest","MoonfallHuntV1")
            if awarded then record.status="Completed" end
        end
        publish(player,record)
    end)
end
prompt.Triggered:Connect(function(player)
    local record=records[player]
    if not record or record.status~="Available" then return end
    local char=player.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health<=0
        or (root.Position-questRoot.Position).Magnitude>15 then return end
    record.baseline=player:GetAttribute("KageboundYokaiDefeats") or 0
    record.progress=0
    record.status="Active"
    publish(player,record)
end)
Players.PlayerAdded:Connect(register)
for _,player in ipairs(Players:GetPlayers()) do register(player) end
Players.PlayerRemoving:Connect(function(player) records[player]=nil end)
print("[KAGEBOUND] Moonfall bounty: defeat 3 Lantern Yokai for WhispersQuest reward")
