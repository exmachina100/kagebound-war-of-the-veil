-- KAGEBOUND — compact player progression HUD.
-- Read-only view of server-owned session Spirit Shards and weapon mastery.
-- ART-001..004: charcoal, warm gold, violet/magenta. No replicated purchase logic.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "KageboundProgressionHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Name = "Progression"
panel.AnchorPoint = Vector2.new(0,1)
panel.Position = UDim2.new(0,20,1,-91)
panel.Size = UDim2.fromOffset(278,50)
panel.BackgroundColor3 = Color3.fromRGB(24,21,40)
panel.BackgroundTransparency = .12
panel.BorderSizePixel = 0
panel.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,9)
corner.Parent = panel
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(156,89,199)
border.Transparency = .45
border.Thickness = 1
border.Parent = panel
local top = Instance.new("TextLabel")
top.Name="SpiritShards"
top.Size=UDim2.new(1,-16,0,20)
top.Position=UDim2.fromOffset(8,3)
top.BackgroundTransparency=1
top.TextXAlignment=Enum.TextXAlignment.Left
top.Font=Enum.Font.GothamBold
top.TextSize=13
top.TextColor3=Color3.fromRGB(251,199,119)
top.Parent=panel
local bottom = Instance.new("TextLabel")
bottom.Name="Mastery"
bottom.Size=UDim2.new(1,-16,0,19)
bottom.Position=UDim2.fromOffset(8,25)
bottom.BackgroundTransparency=1
bottom.TextXAlignment=Enum.TextXAlignment.Left
bottom.Font=Enum.Font.GothamMedium
bottom.TextSize=12
bottom.TextColor3=Color3.fromRGB(217,160,246)
bottom.Parent=panel

local lastShards = nil
local function update()
    local shards = tonumber(player:GetAttribute("KageboundSpiritShards")) or 0
    local mastery = tonumber(player:GetAttribute("KageboundVeilbladeMastery")) or 0
    local defeats = tonumber(player:GetAttribute("KageboundYokaiDefeats")) or 0
    top.Text = ("SPIRIT SHARDS    %d"):format(shards)
    bottom.Text = ("VEILBLADE   Mastery %d  ·  Yokai %d"):format(mastery,defeats)
    if lastShards and shards>lastShards then
        top.TextColor3 = Color3.fromRGB(255,240,193)
        TweenService:Create(top,TweenInfo.new(.5),{
            TextColor3=Color3.fromRGB(251,199,119)
        }):Play()
    end
    lastShards=shards
end
player:GetAttributeChangedSignal("KageboundSpiritShards"):Connect(update)
player:GetAttributeChangedSignal("KageboundVeilbladeMastery"):Connect(update)
player:GetAttributeChangedSignal("KageboundYokaiDefeats"):Connect(update)
update()
print("[KAGEBOUND] Session progression HUD ready")
