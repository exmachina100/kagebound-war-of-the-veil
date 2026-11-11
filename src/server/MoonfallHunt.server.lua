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
-- A visible diegetic quest board, not an invisible interaction trigger.
local face=Instance.new("SurfaceGui")
face.Name="BountyNotice"
face.Face=Enum.NormalId.Front
face.PixelsPerStud=48
face.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
face.Parent=questRoot
local notice=Instance.new("TextLabel")
notice.Name="Notice"
notice.Size=UDim2.fromScale(1,1)
notice.BackgroundColor3=Color3.fromRGB(38,29,48)
notice.BorderSizePixel=0
notice.TextColor3=Color3.fromRGB(247,211,151)
notice.Font=Enum.Font.GothamBold
notice.TextScaled=true
notice.TextWrapped=true
notice.Text="MOONFALL HUNT\n3 LANTERN YOKAI\n25 SPIRIT SHARDS"
notice.Parent=face
local glow=Instance.new("PointLight")
glow.Name="BountyGlow"
glow.Color=Color3.fromRGB(234,145,107)
glow.Brightness=.65
glow.Range=16
glow.Parent=questRoot
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
    local record={status="Available",progress=0,baseline=0,lastDefeats=0}
    records[player]=record
    publish(player,record)
    record.defeatConnection=player:GetAttributeChangedSignal("KageboundYokaiDefeats"):Connect(function()
        if records[player]~=record or record.status~="Active" then return end
        local defeats=player:GetAttribute("KageboundYokaiDefeats")
        if typeof(defeats)~="number" then return end
        -- A monotonic, server-replicated defeat counter is the sole source of progress.\n        -- Never regress progress if another server system resets the session counter.\n        record.progress=math.max(record.progress,math.clamp(math.floor(defeats-record.baseline),0,GOAL))
        if record.progress>=GOAL then
            -- Fixed server reward policy and one session receipt.
            local awarded=Rewards.Award(player,"MoonfallHunt","MoonfallHuntV1")
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
    local defeats=player:GetAttribute("KageboundYokaiDefeats")\n    record.baseline=typeof(defeats)=="number" and math.max(0,math.floor(defeats)) or 0
    record.progress=0
    record.status="Active"
    publish(player,record)
end)
Players.PlayerAdded:Connect(register)
for _,player in ipairs(Players:GetPlayers()) do register(player) end
Players.PlayerRemoving:Connect(function(player)\n    local record=records[player]\n    if record and record.defeatConnection then record.defeatConnection:Disconnect() end\n    records[player]=nil\nend)
print("[KAGEBOUND] Moonfall bounty: defeat 3 Lantern Yokai for dedicated MoonfallHunt reward")
