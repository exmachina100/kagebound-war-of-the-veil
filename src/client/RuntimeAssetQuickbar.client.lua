-- KAGEBOUND: runtime-published UI artwork, with Roblox-native fallbacks.
-- RuntimeAssetRegistry is generated only from confirmed Roblox asset IDs.
-- The UI remains functional if upload, moderation, or replication is pending.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local shared = ReplicatedStorage:WaitForChild("KageboundShared", 15)
if not shared then return end
local module = shared:FindFirstChild("RuntimeAssetRegistry")
if not module then return end
local ok, registry = pcall(require, module)
if not ok then warn("[KAGEBOUND] UI asset registry unavailable"); return end

local gui = Instance.new("ScreenGui")
gui.Name = "KageboundAssetQuickbar"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 2
gui.Parent = player:WaitForChild("PlayerGui")

-- Decorative equipment strip; do not intercept combat touch input.
local holder = Instance.new("Frame")
holder.Name = "MythicEquipment"
holder.AnchorPoint = Vector2.new(1, 0)
holder.Position = UDim2.new(1, -14, 0, 86)
holder.Size = UDim2.fromOffset(112, 38)
holder.BackgroundColor3 = Color3.fromRGB(32, 35, 56)
holder.BackgroundTransparency = 0.18
holder.BorderSizePixel = 0
holder.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = holder
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(169, 91, 228)
stroke.Transparency = 0.55
stroke.Parent = holder

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 6)
layout.Parent = holder
for _, item in ipairs({
    {name="weapon", symbol="W"},
    {name="kitsune", symbol="K"},
    {name="veilfall", symbol="V"},
}) do
    local tile = Instance.new("Frame")
    tile.Size = UDim2.fromOffset(30, 30)
    tile.BackgroundTransparency = 1
    tile.Parent = holder
    local fallback = Instance.new("TextLabel")
    fallback.Name = "Fallback"
    fallback.Size = UDim2.fromScale(1, 1)
    fallback.BackgroundTransparency = 1
    fallback.Font = Enum.Font.GothamBold
    fallback.TextColor3 = Color3.fromRGB(244, 229, 244)
    fallback.TextSize = 16
    fallback.Text = item.symbol
    fallback.Parent = tile
    local icon = Instance.new("ImageLabel")
    icon.Name = item.name
    icon.Size = UDim2.fromScale(1, 1)
    icon.BackgroundTransparency = 1
    icon.ScaleType = Enum.ScaleType.Fit
    icon.Parent = tile
    local asset = registry.get("ui.icons.v01." .. item.name)
    if asset then
        icon.Image = asset
        icon.Visible = true
        fallback.Visible = false
    else
        icon.Visible = false
    end
end
