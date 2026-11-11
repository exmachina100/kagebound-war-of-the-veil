-- KAGEBOUND sky installer: safe until six real Roblox image IDs exist.
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared = ReplicatedStorage:WaitForChild("KageboundShared")
local cfg = require(shared:WaitForChild("SkyConfig"))
local sky = Lighting:FindFirstChild("KageboundSky")
if not sky then
    sky = Instance.new("Sky")
    sky.Name = "KageboundSky"
    sky.Parent = Lighting
end
local fields = {Bk="SkyboxBk", Dn="SkyboxDn", Ft="SkyboxFt", Lf="SkyboxLf", Rt="SkyboxRt", Up="SkyboxUp"}
local valid = true
for key in pairs(fields) do
    local id = cfg.Faces[key]
    if type(id) ~= "number" or id <= 0 then valid = false end
end
if valid then
    for key, property in pairs(fields) do
        sky[property] = "rbxassetid://" .. tostring(cfg.Faces[key])
    end
else
    warn("[KAGEBOUND] Custom cubemap pending six published Roblox images; using atmospheric fallback")
end
sky.CelestialBodiesShown = false
sky.StarCount = 2200
local atmosphere = Lighting:FindFirstChild("KageboundAtmosphere")
if not atmosphere then
    atmosphere = Instance.new("Atmosphere")
    atmosphere.Name = "KageboundAtmosphere"
    atmosphere.Parent = Lighting
end
local function apply(preset)
    local values = preset and cfg.Veilfall or cfg.Atmosphere
    for property, value in pairs(values) do atmosphere[property] = value end
end
apply(false)
Lighting.ClockTime = 21.5
Lighting.Brightness = 2
Lighting.Ambient = Color3.fromRGB(45, 39, 78)
Lighting.OutdoorAmbient = Color3.fromRGB(67, 62, 112)
-- World-event systems may set Lighting attribute to synchronize the sky mood.
Lighting:GetAttributeChangedSignal("KageboundVeilfall"):Connect(function()
    apply(Lighting:GetAttribute("KageboundVeilfall") == true)
end)
