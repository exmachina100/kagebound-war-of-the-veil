-- KAGEBOUND Moonfall Bamboo art pass v0.2
-- Approved anchors: ART-001 (key art), ART-004 (environment/Veilfall).
-- This is stylized procedural Roblox geometry, NOT an imported finished model.
-- All purely decorative components are non-colliding; gameplay platform routes are explicit.
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local arena = Workspace:WaitForChild("KageboundArena", 20)
if not arena then warn("[KAGEBOUND] Arena art skipped: arena missing") return end
local old = arena:FindFirstChild("MoonfallArt")
if old then old:Destroy() end
local art = Instance.new("Folder")
art.Name = "MoonfallArt"
art.Parent = arena

local C = {
    charcoal = Color3.fromRGB(27, 29, 48),
    stone = Color3.fromRGB(67, 69, 87),
    slate = Color3.fromRGB(95, 99, 122),
    red = Color3.fromRGB(150, 43, 68),
    redDark = Color3.fromRGB(79, 27, 48),
    indigo = Color3.fromRGB(49, 41, 92),
    veil = Color3.fromRGB(177, 79, 241),
    pink = Color3.fromRGB(245, 92, 177),
    ivory = Color3.fromRGB(235, 221, 211),
    gold = Color3.fromRGB(255, 188, 113),
    green = Color3.fromRGB(37, 86, 69),
}
local function block(name, size, cf, color, material, collides)
    local p = Instance.new("Part")
    p.Name, p.Size, p.CFrame = name, size, cf
    p.Anchored = true
    p.CanCollide = collides == true
    p.CanTouch, p.CanQuery = false, collides == true
    p.Material, p.Color = material or Enum.Material.SmoothPlastic, color
    p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
    p.Parent = art
    return p
end
local function box(name, size, x,y,z, color, material, collision)
    return block(name, size, CFrame.new(x,y,z), color, material, collision)
end
local function orb(name, r, position, color, material)
    local p = block(name, Vector3.new(r,r,r), CFrame.new(position), color, material)
    p.Shape = Enum.PartType.Ball
    return p
end
local function beamBetween(name, startPos, endPos, width, color, material)
    local span = endPos-startPos
    return block(name, Vector3.new(width,width,span.Magnitude),
        CFrame.lookAt((startPos+endPos)/2,endPos),color,material)
end

-- Mysterious circular emblem: low-profile segmented neon ring, intentionally no collision.
local function ring(name, center, radius, segments, color, thickness)
    for i=1,segments do
        local a=(i-1)*math.pi*2/segments
        local b=i*math.pi*2/segments
        local pa=center+Vector3.new(math.cos(a)*radius,0,math.sin(a)*radius)
        local pb=center+Vector3.new(math.cos(b)*radius,0,math.sin(b)*radius)
        beamBetween(name..i,pa,pb,thickness,color,Enum.Material.Neon)
    end
end
ring("DuelSigilOuter", Vector3.new(0,1.18,0), 15, 32, C.veil, .19)
ring("DuelSigilInner", Vector3.new(0,1.2,0), 8, 24, C.pink, .16)
ring("DuelSigilCore", Vector3.new(0,1.22,0), 3, 16, C.ivory, .12)

-- Ancient shrine silhouette beyond the north duelling lane; purely scenic.
local shrineZ=-58
box("ShrinePlinth",Vector3.new(25,2,12),0,2,shrineZ,C.stone,Enum.Material.Slate)
for _,x in ipairs({-11,11}) do
    box("ShrineColumn",Vector3.new(1.6,14,1.6),x,10,shrineZ,C.red,Enum.Material.Wood)
end
for tier=1,3 do
    local y=14+(tier-1)*5.3
    local width=29-tier*3.5
    box("ShrineRoof",Vector3.new(width,1.5,10.5-tier),0,y,shrineZ,C.charcoal,Enum.Material.Slate)
    box("RoofVermilion",Vector3.new(width+1.5,.35,11.5-tier),0,y+.9,shrineZ,C.redDark)
end
box("ShrineSpiritBanner",Vector3.new(6.5,8,.25),0,9.1,shrineZ+6,C.indigo,Enum.Material.Fabric)
local banner=art:FindFirstChild("ShrineSpiritBanner")
local sg=Instance.new("SurfaceGui")
sg.Face=Enum.NormalId.Front
sg.CanvasSize=Vector2.new(256,256)
sg.AlwaysOnTop=false
sg.Parent=banner
local mark=Instance.new("TextLabel")
mark.Size=UDim2.fromScale(1,1)
mark.BackgroundTransparency=1
mark.Text="狐"
mark.TextScaled=true
mark.Font=Enum.Font.GothamBold
mark.TextColor3=C.pink
mark.Parent=sg

-- Rock terraces, lantern-lit stepping routes and flowing violet-white water.
for _,side in ipairs({-1,1}) do
    local x=side*48
    box("CliffBase",Vector3.new(19,13,30),x,6.5,-24,C.stone,Enum.Material.Rock)
    box("CliffCap",Vector3.new(18,1.4,29),x,13.6,-24,C.slate,Enum.Material.Slate)
    -- Walkable elevated route and two ramps starting outside duel square.
    box("UpperWalkway",Vector3.new(12,1,40),x,14.6,-16,C.slate,Enum.Material.Slate,true)
    local ramp=block("UpperRamp",Vector3.new(12,1,30),
        CFrame.new(side*48,7.5,17)*CFrame.Angles(math.rad(-27),0,0),
        C.stone,Enum.Material.Slate,true)
    for j=1,6 do
        local z=-38+j*5
        box("WaterfallFoam",Vector3.new(.22,11,1.2),side*58.5,7,z,
            j%2==0 and C.ivory or C.veil,Enum.Material.Neon)
    end
    for j=1,5 do
        local z=-36+j*7
        box("BridgeRailPost",Vector3.new(.6,5,.6),x-side*6,17,z,C.redDark,Enum.Material.Wood)
    end
end

-- The moon is a decorative sphere outside playable bounds, not a skybox texture.
orb("Moon",40,Vector3.new(14,100,-166),Color3.fromRGB(188,174,237),Enum.Material.Neon)

-- Extra smaller torii, ribbon ornaments and paper lanterns framing playable space.
for _,s in ipairs({-1,1}) do
    for _,z in ipairs({-44,44}) do
        local x=s*29
        box("ToriiPillar",Vector3.new(1,12,1),x-4,7,z,C.red,Enum.Material.Wood)
        box("ToriiPillar",Vector3.new(1,12,1),x+4,7,z,C.red,Enum.Material.Wood)
        box("ToriiCap",Vector3.new(13,1,2),x,13,z,C.redDark,Enum.Material.Wood)
        box("ShrineLantern",Vector3.new(2.3,2.8,2.3),x,8,z+4,C.gold,Enum.Material.Neon)
    end
end
-- Lightweight sakura accents kept on the edges (not over combat sightlines).
for i=1,24 do
    local angle=i*2.39996
    local radius=56+(i%4)
    local x,z=math.cos(angle)*radius,math.sin(angle)*radius
    local blossom=orb("SakuraCrown",6,Vector3.new(x,13+(i%3),z),
        i%3==0 and C.ivory or C.pink,Enum.Material.SmoothPlastic)
    blossom.Transparency=.22
end

local atmosphere=Lighting:FindFirstChild("KageboundAtmosphere")
if not atmosphere then atmosphere=Instance.new("Atmosphere") atmosphere.Name="KageboundAtmosphere" atmosphere.Parent=Lighting end
atmosphere.Density=.23
atmosphere.Haze=1.5
atmosphere.Color=Color3.fromRGB(153,130,207)
atmosphere.Decay=Color3.fromRGB(65,51,105)
local grade=Lighting:FindFirstChild("KageboundColorGrade")
if not grade then grade=Instance.new("ColorCorrectionEffect") grade.Name="KageboundColorGrade" grade.Parent=Lighting end
grade.TintColor=Color3.fromRGB(229,215,255)
grade.Contrast=.09
grade.Saturation=.13
print("[KAGEBOUND] Moonfall art pass loaded (ART-001 / ART-004)")
