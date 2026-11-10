-- Grand World P1: three server-spawned NPC interaction prototypes.
-- Dialogue/waypoint hints only. No rewards, unlocks or client-owned quest state.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Shared=ReplicatedStorage:WaitForChild("KageboundShared")
local Guides=require(Shared:WaitForChild("WorldGuideRules"))
local World=require(Shared:WaitForChild("WorldConfig"))
if not World.Enabled then return end
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
            player:SetAttribute("KageboundGuideDestination",npc.destination)
            player:SetAttribute("KageboundGuideSpeaker",npc.name)
        end)
    end
end
