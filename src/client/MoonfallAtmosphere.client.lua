-- Moonfall atmosphere: texture-free, client-only spectral motes.
-- Uses Roblox particles (no unpublished IDs), bounded to local player's region.
-- Does not change sky, terrain, collisions, lighting, or server gameplay.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local folder = Instance.new("Folder")
folder.Name = "KGB_LocalMoonfallAtmosphere"
folder.Parent = Workspace.CurrentCamera or Workspace

local points = {}
local offsets = {
    Vector3.new(-24, 3, -16),
    Vector3.new(16, 5, -23),
    Vector3.new(27, 4, 19),
    Vector3.new(-18, 6, 24),
}
for i, offset in ipairs(offsets) do
    local anchor = Instance.new("Part")
    anchor.Name = "SpectralMotes_" .. i
    anchor.Size = Vector3.new(1, 1, 1)
    anchor.Transparency = 1
    anchor.Anchored = true
    anchor.CanCollide = false
    anchor.CanTouch = false
    anchor.CanQuery = false
    anchor.Parent = folder

    local emitter = Instance.new("ParticleEmitter")
    emitter.Name = "MoonfallSpiritDust"
    emitter.Enabled = false
    emitter.Rate = 3
    emitter.Lifetime = NumberRange.new(2.5, 4.5)
    emitter.Speed = NumberRange.new(0.4, 1.5)
    emitter.SpreadAngle = Vector2.new(30, 30)
    emitter.Acceleration = Vector3.new(0, 0.8, 0)
    emitter.Drag = 1
    emitter.LightEmission = 0.75
    emitter.LightInfluence = 0.15
    emitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(98, 179, 240)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(170, 119, 239)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(218, 230, 255)),
    })
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.2, 0.3),
        NumberSequenceKeypoint.new(0.75, 0.18),
        NumberSequenceKeypoint.new(1, 0),
    })
    emitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0.3),
        NumberSequenceKeypoint.new(0.8, 0.5),
        NumberSequenceKeypoint.new(1, 1),
    })
    emitter.Parent = anchor
    table.insert(points, {anchor = anchor, emitter = emitter, offset = offset})
end

local accumulator = 0
local connection
connection = RunService.Heartbeat:Connect(function(dt)
    if not player.Parent or not folder.Parent then
        connection:Disconnect()
        folder:Destroy()
        return
    end
    accumulator += dt
    if accumulator < 0.4 then return end
    accumulator = 0
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local enabled = root ~= nil and player:GetAttribute("KageboundRegion") == "MoonfallBamboo"
    for _, point in ipairs(points) do
        point.emitter.Enabled = enabled
        if enabled then
            point.anchor.CFrame = CFrame.new(root.Position + point.offset)
        end
    end
end)
