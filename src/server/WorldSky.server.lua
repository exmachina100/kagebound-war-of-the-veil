-- KAGEBOUND world sky: safe, complete-six-face cubemap switching for Moonfall and Veilfall.
-- Never install partial cubemaps or fabricate Roblox asset IDs.
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared = ReplicatedStorage:WaitForChild("KageboundShared")
local cfg = require(shared:WaitForChild("SkyConfig"))
local registry = require(shared:WaitForChild("RuntimeAssetRegistry"))
local sky = Lighting:FindFirstChild("KageboundSky")
if not sky then
    sky = Instance.new("Sky")
    sky.Name = "KageboundSky"
    sky.Parent = Lighting
end
local fields = {Bk="SkyboxBk", Dn="SkyboxDn", Ft="SkyboxFt", Lf="SkyboxLf", Rt="SkyboxRt", Up="SkyboxUp"}
local order = {"Bk","Dn","Ft","Lf","Rt","Up"}
local function asset(id)
    if type(id) == "number" and id > 0 and id % 1 == 0 then
        return "rbxassetid://" .. tostring(id)
    end
    if type(id) == "string" and id:match("^rbxassetid://%d+$") then return id end
    return nil
end
-- Prefer verified owned runtime images; creator-store sky IDs remain a complete fallback.\nlocal function resolve(variant)
    local faces = {}
    local configFaces = variant == "veilfall" and cfg.VeilfallFaces or cfg.Faces
    for _, key in ipairs(order) do
        local id = configFaces and asset(configFaces[key])
        local published = registry.get("ui.skybox." .. variant .. ".v01." .. string.lower(key))
        local resolved = asset(published) or id
        if not resolved then return nil end
        faces[key] = resolved
    end
    return faces
end
local moonfall = resolve("moonfall")
local veilfall = resolve("veilfall")
local function applyFaces(faces)
    if not faces then return false end
    for _, key in ipairs(order) do sky[fields[key]] = faces[key] end
    return true
end
local atmosphere = Lighting:FindFirstChild("KageboundAtmosphere")
if not atmosphere then
    atmosphere = Instance.new("Atmosphere")
    atmosphere.Name = "KageboundAtmosphere"
    atmosphere.Parent = Lighting
end
local function apply(veil)
    local values = veil and cfg.Veilfall or cfg.Atmosphere
    for property, value in pairs(values) do atmosphere[property] = value end
    if veil then
        -- If Veilfall faces are missing, retain the complete Moonfall sky instead of mixing faces.
        if not applyFaces(veilfall) then applyFaces(moonfall) end
    else
        applyFaces(moonfall)
    end
end
sky.CelestialBodiesShown = not moonfall -- Keep the native moon while custom faces are absent.
sky.StarCount = 2200
sky.MoonAngularSize = 18
for property, value in pairs(cfg.Lighting) do Lighting[property] = value end
if not moonfall then
    warn("[KAGEBOUND] Moonfall sky awaiting all six published image IDs; atmospheric fallback active")
end
if not veilfall then
    warn("[KAGEBOUND] Veilfall sky awaiting all six published image IDs; atmospheric transition only")
end
local function update()
    apply(Lighting:GetAttribute("KageboundVeilfall") == true)
end
update()
Lighting:GetAttributeChangedSignal("KageboundVeilfall"):Connect(update)
