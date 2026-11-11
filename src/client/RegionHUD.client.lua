-- Lightweight Grand World region HUD; server attributes are display-only.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local TweenService=game:GetService("TweenService")
local player=Players.LocalPlayer
local Regions=require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("RegionRules"))
local gui=Instance.new("ScreenGui")
gui.Name="KageboundRegionHUD"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.Parent=player:WaitForChild("PlayerGui")
local label=Instance.new("TextLabel")
label.Name="Region"
label.AnchorPoint=Vector2.new(.5,0)
label.Position=UDim2.new(.5,0,0,74)
label.Size=UDim2.new(1,-24,0,150)
local labelConstraint=Instance.new("UISizeConstraint")
labelConstraint.MaxSize=Vector2.new(380,150)
labelConstraint.Parent=label
label.BackgroundColor3=Color3.fromRGB(27,28,44)
label.BackgroundTransparency=.18
label.TextColor3=Color3.fromRGB(238,225,207)
label.Font=Enum.Font.GothamBold
label.TextScaled=false
label.TextSize=15
label.TextWrapped=true
label.Parent=gui
local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,10)
corner.Parent=label
-- Reward feedback uses replicated server-owned session totals; no client reward requests.
local toast=Instance.new("TextLabel")
toast.Name="RewardFeedback"
toast.AnchorPoint=Vector2.new(.5,0)
toast.Position=UDim2.new(.5,0,0,234)
toast.Size=UDim2.new(1,-24,0,40)
toast.BackgroundColor3=Color3.fromRGB(40,33,63)
toast.BackgroundTransparency=1
toast.TextColor3=Color3.fromRGB(248,212,143)
toast.Font=Enum.Font.GothamBold
toast.TextSize=17
toast.TextTransparency=1
toast.Visible=false
toast.Parent=gui
local toastCorner=Instance.new("UICorner")
toastCorner.CornerRadius=UDim.new(0,9)
toastCorner.Parent=toast
local toastSize=Instance.new("UISizeConstraint")
toastSize.MaxSize=Vector2.new(380,40)
toastSize.Parent=toast
local toastVersion=0
local initialized={}
local function showReward(message)
    toastVersion+=1
    local version=toastVersion
    toast.Text=message
    toast.Visible=true
    TweenService:Create(toast,TweenInfo.new(.18),{
        BackgroundTransparency=.12,TextTransparency=0
    }):Play()
    task.delay(2.6,function()
        if version~=toastVersion or not toast.Parent then return end
        local fade=TweenService:Create(toast,TweenInfo.new(.35),{
            BackgroundTransparency=1,TextTransparency=1
        })
        fade:Play()
        fade.Completed:Wait()
        if version==toastVersion then toast.Visible=false end
    end)
end
local function observeTotal(attribute,labelText)
    local function changed()
        local value=player:GetAttribute(attribute)
        if typeof(value)~="number" then return end
        local old=initialized[attribute]
        initialized[attribute]=value
        if old~=nil and value>old then
            showReward("+"..tostring(value-old).." "..labelText)
        end
    end
    player:GetAttributeChangedSignal(attribute):Connect(changed)
    changed() -- establish baseline; joining must not show a false reward
end
observeTotal("KageboundSpiritShards","Spirit Shards")
observeTotal("KageboundVeilbladeMastery","Veilblade Mastery")
local function refresh()
    local zone=Regions.ById(player:GetAttribute("KageboundRegion"))
    local count=player:GetAttribute("KageboundRegionsDiscovered") or 0
    local title=(zone and zone.name or "Between the Veils").." • "..count.."/5 explored"
    local target=Regions.ById(player:GetAttribute("KageboundGuideDestination"))
    if target then
        local char=player.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        local distance=root and math.floor((Vector2.new(root.Position.X-target.x,root.Position.Z-target.z)).Magnitude)
        title=title.."\nGuide: "..target.name..(distance and (" • "..distance.." studs") or "")
    end
    local quest=player:GetAttribute("KageboundTravelQuest")
    if quest and quest~="" then title=title.."\nJourney: "..quest end
    local finished=player:GetAttribute("KageboundTravelCompleted") or 0
    title=title.."\nJourneys: "..finished.."/3"
    local defeats=player:GetAttribute("KageboundYokaiDefeats") or 0
    local shards=player:GetAttribute("KageboundSpiritShards") or 0
    local mastery=player:GetAttribute("KageboundVeilbladeMastery") or 0
    if zone and zone.id=="MoonfallBamboo" then
        title=title.."\nLantern Yokai defeated: "..defeats
        local hunt=player:GetAttribute("KageboundHuntStatus")
        if hunt=="Active" then
            local progress=player:GetAttribute("KageboundHuntProgress") or 0
            local goal=player:GetAttribute("KageboundHuntGoal") or 3
            title=title.."\nHunt: "..progress.."/"..goal.." Lantern Yokai"
        elseif hunt=="Completed" then
            title=title.."\nHunt complete: Moonfall bounty claimed"
        elseif hunt=="Available" then
            local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local boardPosition=Vector3.new(zone.x+35,5,zone.z+45)
            local distance=root and math.floor((root.Position-boardPosition).Magnitude)
            title=title.."\nBounty Board: "..(distance and (distance.." studs away") or "find the notice")
        end
    end
    title=title.."\nSpirit Shards: "..shards.." | Mastery: "..mastery
    label.Text=title
end
player:GetAttributeChangedSignal("KageboundGuideDestination"):Connect(refresh)
player:GetAttributeChangedSignal("KageboundTravelQuest"):Connect(refresh)
player:GetAttributeChangedSignal("KageboundTravelCompleted"):Connect(refresh)
player:GetAttributeChangedSignal("KageboundRegion"):Connect(refresh)
player:GetAttributeChangedSignal("KageboundRegionsDiscovered"):Connect(refresh)
player:GetAttributeChangedSignal("KageboundYokaiDefeats"):Connect(refresh)
player:GetAttributeChangedSignal("KageboundSpiritShards"):Connect(refresh)
player:GetAttributeChangedSignal("KageboundVeilbladeMastery"):Connect(refresh)
player:GetAttributeChangedSignal("KageboundHuntStatus"):Connect(refresh)
player:GetAttributeChangedSignal("KageboundHuntProgress"):Connect(refresh)
refresh()

task.spawn(function()
    while gui.Parent do
        task.wait(2)
        local target=player:GetAttribute("KageboundGuideDestination")
        if (target and target~="") or player:GetAttribute("KageboundRegion")=="MoonfallBamboo" then refresh() end
    end
end)
