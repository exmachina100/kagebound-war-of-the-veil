-- KAGEBOUND: unobtrusive region discovery HUD, driven by server attributes.
-- Approved ART-001/004 visual language: charcoal, ivory, violet, warm gold.
-- Does not trust the client for discovery, progression or rewards.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "KageboundRegionDiscovery"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 3
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "RegionBanner"
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Position = UDim2.fromScale(0.5, 0.095)
frame.Size = UDim2.new(0.72, 0, 0, 68)
frame.BackgroundColor3 = Color3.fromRGB(25, 24, 43)
frame.BackgroundTransparency = 1
frame.Visible = false
frame.Parent = gui
local size = Instance.new("UISizeConstraint")
size.MaxSize = Vector2.new(390, 68)
size.MinSize = Vector2.new(190, 58)
size.Parent = frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 9)
corner.Parent = frame
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(174, 103, 223)
border.Thickness = 1
border.Transparency = 1
border.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "RegionTitle"
title.Size = UDim2.new(1, -24, 0, 35)
title.Position = UDim2.fromOffset(12, 7)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(244, 229, 244)
title.Font = Enum.Font.GothamBold
title.TextSize = 19
title.TextScaled = false
title.TextTruncate = Enum.TextTruncate.AtEnd
title.Parent = frame
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -24, 0, 20)
subtitle.Position = UDim2.fromOffset(12, 40)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.fromRGB(251, 185, 119)
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextSize = 12
subtitle.Parent = frame

local serial = 0
local lastRegion = nil
local function update()
    local id = player:GetAttribute("CurrentRegion") or ""
    if id == lastRegion then return end
    lastRegion = id
    serial += 1
    local ticket = serial
    if id == "" then
        frame.Visible = false
        return
    end
    local name = player:GetAttribute("CurrentRegionName")
    if not name or name == "" then
        -- The server writes both attributes sequentially; wait for the name.
        task.defer(function()
            if ticket == serial then update() end
        end)
        return
    end
    title.Text = name
    subtitle.Text = "VEILBOUND WORLD  •  REGION ENTERED"
    frame.Visible = true
    frame.BackgroundTransparency = 1
    border.Transparency = 1
    TweenService:Create(frame, TweenInfo.new(0.22), {BackgroundTransparency = 0.12}):Play()
    TweenService:Create(border, TweenInfo.new(0.22), {Transparency = 0.15}):Play()
    task.delay(3.1, function()
        if ticket ~= serial then return end
        local fade = TweenService:Create(frame, TweenInfo.new(0.45), {BackgroundTransparency = 1})
        TweenService:Create(border, TweenInfo.new(0.45), {Transparency = 1}):Play()
        fade:Play()
        fade.Completed:Wait()
        if ticket == serial then frame.Visible = false end
    end)
end
player:GetAttributeChangedSignal("CurrentRegion"):Connect(update)
player:GetAttributeChangedSignal("CurrentRegionName"):Connect(update)
update()
