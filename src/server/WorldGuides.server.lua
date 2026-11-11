-- Grand World P1: three server-spawned NPC interaction prototypes.
-- Dialogue/waypoint hints only. No rewards, unlocks or client-owned quest state.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Shared=ReplicatedStorage:WaitForChild("KageboundShared")
local Guides=require(Shared:WaitForChild("WorldGuideRules"))
local World=require(Shared:WaitForChild("WorldConfig"))
if not World.Enabled then return end
local active={}
local completed={}
local Players=game:GetService("Players")
local Regions=require(Shared:WaitForChild("RegionRules"))
local function publish(player)
    local quest=active[player]
    player:SetAttribute("KageboundTravelQuest",quest and quest.id or "")
    player:SetAttribute("KageboundTravelTarget",quest and quest.destination or "")
    player:SetAttribute("KageboundTravelCompleted",completed[player] and #completed[player] or 0)
    player:SetAttribute("KageboundGuideDestination",quest and quest.destination or "")
end
Players.PlayerAdded:Connect(function(player)
    completed[player]={}
    publish(player)
end)
for _,player in ipairs(Players:GetPlayers()) do
    completed[player]={}
    publish(player)
end
Players.PlayerRemoving:Connect(function(player)
    active[player]=nil
    completed[player]=nil
end)
local folder=Instance.new("Folder")
folder.Name="KageboundGuides"
folder.Parent=workspace
for _,npc in ipairs(Guides.NPCs) do
    local position=Guides.Position(npc)
    if position then
        local model=Instance.new("Model")
        model.Name=npc.id
        model.Parent=folder
        local base=Instance.new("Part")
        base.Name="GuideMarker"
        base.Anchored=true
        base.Size=Vector3.new(4,7,4)
        base.Position=position+Vector3.new(0,3.5,0)
        base.Material=Enum.Material.Slate
        base.Color=Color3.fromRGB(56,49,74)
        base.Parent=model
        model.PrimaryPart=base
        local prompt=Instance.new("ProximityPrompt")
        prompt.Name="Talk"
        prompt.ActionText="Ask about the path"
        prompt.ObjectText=npc.name.." • "..npc.role
        prompt.MaxActivationDistance=11
        prompt.RequiresLineOfSight=true
        prompt.HoldDuration=.3
        prompt.Parent=base
        local tag=Instance.new("BillboardGui")
        tag.Size=UDim2.fromOffset(190,45)
        tag.StudsOffsetWorldSpace=Vector3.new(0,5,0)
        tag.MaxDistance=90
        tag.Parent=base
        local label=Instance.new("TextLabel")
        label.Size=UDim2.fromScale(1,1)
        label.BackgroundTransparency=.35
        label.BackgroundColor3=Color3.fromRGB(26,24,39)
        label.TextColor3=Color3.fromRGB(245,219,178)
        label.Font=Enum.Font.GothamBold
        label.TextScaled=true
        label.Text=npc.name
        label.Parent=tag
        prompt.Triggered:Connect(function(player)
            local char=player.Character
            local hum=char and char:FindFirstChildOfClass("Humanoid")
            local root=char and char:FindFirstChild("HumanoidRootPart")
            if not hum or hum.Health<=0 or not root
                or (root.Position-base.Position).Magnitude>15 then return end
            if active[player] then return end
            completed[player]=completed[player] or {}
            for _,done in ipairs(completed[player]) do
                if done==npc.id then return end
            end
            active[player]={id=npc.id,destination=npc.destination}
            player:SetAttribute("KageboundGuideSpeaker",npc.name)
            publish(player)
        end)
    end
end

-- Quest progress is derived only from server-observed character positions.
task.spawn(function()
    while true do
        task.wait(0.75)
        for player,quest in pairs(active) do
            local char=player.Character
            local hum=char and char:FindFirstChildOfClass("Humanoid")
            local root=char and char:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health>0 and root then
                local zone=Regions.At(root.Position)
                if zone and zone.id==quest.destination then
                    completed[player]=completed[player] or {}
                    table.insert(completed[player],quest.id)
                    active[player]=nil
                    player:SetAttribute("KageboundLastTravelCompletion",quest.id)
                    publish(player)
                end
            end
        end
    end
end)
