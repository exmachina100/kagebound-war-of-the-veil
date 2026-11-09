-- KAGEBOUND Veilfall prototype (ART-004 / FX-008, FX-009).
-- Server manages collision & platform timing. Visual warnings replicate to clients.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local arena=Workspace:WaitForChild("KageboundArena",25)
if not arena then warn("[KAGEBOUND] Veilfall could not find arena") return end

local evt=ReplicatedStorage:FindFirstChild("KageboundVeilfall")
if not evt then
    evt=Instance.new("RemoteEvent")
    evt.Name="KageboundVeilfall"
    evt.Parent=ReplicatedStorage
end
local platforms=Instance.new("Folder")
platforms.Name="VeilfallPlatforms"
platforms.Parent=arena
local anchors={
    Vector3.new(-34,9,-12), Vector3.new(-46,13,-12),
    Vector3.new(34,9,-12), Vector3.new(46,13,-12),
    Vector3.new(-34,9,15), Vector3.new(-46,13,15),
    Vector3.new(34,9,15), Vector3.new(46,13,15)
}
for index, position in ipairs(anchors) do
    local p=Instance.new("Part")
    p.Name="SpiritPlatform_"..index
    p.Size=Vector3.new(12,1.5,12)
    p.Position=position
    p.Anchored=true
    p.Material=Enum.Material.Neon
    p.Color=Color3.fromRGB(151,84,211)
    p.Transparency=1
    p.CanCollide=false
    p.CanTouch=false
    p.Parent=platforms
end
local active=false
local function setActive(on)
    active=on
    for _,p in ipairs(platforms:GetChildren()) do
        if p:IsA("BasePart") then
            p.CanCollide=on
            p.Transparency=on and .23 or 1
        end
    end
    evt:FireAllClients(on and "Active" or "Closed")
end
-- Brief predictable countdown, 40s active window, then normal arena.
task.spawn(function()
    while arena.Parent do
        task.wait(35)
        if not arena.Parent then break end
        evt:FireAllClients("Warning", 6)
        task.wait(6)
        if not arena.Parent then break end
        setActive(true)
        task.wait(40)
        setActive(false)
    end
end)
print("[KAGEBOUND] Veilfall cycle initialized (6s warning, 40s active)")
