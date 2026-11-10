-- Lightweight Grand World region HUD; server attributes are display-only.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
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
label.Size=UDim2.new(0,320,0,44)
label.BackgroundColor3=Color3.fromRGB(27,28,44)
label.BackgroundTransparency=.18
label.TextColor3=Color3.fromRGB(238,225,207)
label.Font=Enum.Font.GothamBold
label.TextScaled=true
label.TextWrapped=true
label.Parent=gui
local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,10)
corner.Parent=label
local function refresh()
    local zone=Regions.ById(player:GetAttribute("KageboundRegion"))
    local count=player:GetAttribute("KageboundRegionsDiscovered") or 0
    label.Text=(zone and zone.name or "Between the Veils").."  •  "..count.."/5 explored"
end
local function destinationHint()
    local target=Regions.ById(player:GetAttribute("KageboundGuideDestination"))
    if not target then return end
    local char=player.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local distance=math.floor((Vector2.new(root.Position.X-target.x,root.Position.Z-target.z)).Magnitude)
    label.Text=target.name.."  •  "..distance.." studs ahead"
end
player:GetAttributeChangedSignal("KageboundGuideDestination"):Connect(destinationHint)
player:GetAttributeChangedSignal("KageboundRegion"):Connect(refresh)
player:GetAttributeChangedSignal("KageboundRegionsDiscovered"):Connect(refresh)
refresh()
