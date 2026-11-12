-- Reuse the source-controlled v08 imports. Cosmetic draft placements, ART-004.
-- Existing GrandWorld geometry retains collision and traversal authority.
local Storage = game:GetService("ServerStorage")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("KageboundShared")
local Config = require(Shared:WaitForChild("WorldConfig"))
if not Config.Enabled then return end
local library = Storage:FindFirstChild("KageboundWorldArtV08")
if not library then return end
local world = workspace:WaitForChild("KageboundWorld", 60)
if not world then return end
local Clone = require(script.Parent:WaitForChild("CosmeticWorldArt")).Clone
local zones = {}
for _, zone in ipairs(Config.Zones) do zones[zone.id] = zone end
local placements = {
    {"KageDojo", "dojo_shrine_pavilion", -140, 100, 0},
    {"KageDojo", "dojo_torii_signature", -140, 80, 0},
    {"KageDojo", "dojo_stone_lantern", -152, 80, 0},
    {"KageDojo", "dojo_ritual_banner", -128, 80, 0},
    {"KageDojo", "dojo_ceremonial_stones", -140, 120, 0},
    {"KageDojo", "dojo_roof_eave_module", -140, 145, 0},
    {"MoonfallBamboo", "moonfall_bamboo_grove", 105, -35, 0},
    {"MoonfallBamboo", "moonfall_arch_bridge", 105, 35, 0},
}
local folder = world:FindFirstChild("ImportedWorldArtV08")
if folder then return end -- Avoid duplicate placement if invoked again.
folder = Instance.new("Folder")
folder.Name = "ImportedWorldArtV08"
folder:SetAttribute("Status", "draft cosmetics; collision and visual QA pending")
folder.Parent = world
local count = 0
for _, item in ipairs(placements) do
    local zone, template = zones[item[1]], library:FindFirstChild(item[2])
    if zone and template then
        local copy = Clone(template)
        if copy then
            copy.Name = item[2]
            -- Imported world pivots preserve authored ground, Y=0.
            copy:PivotTo(CFrame.new(zone.x + item[3], 1.76, zone.z + item[4])
                * CFrame.Angles(0, math.rad(item[5]), 0))
            copy.Parent = folder
            count += 1
        end
    end
    task.wait()
end
print("[KAGEBOUND WorldArt v08] Placed " .. count .. " existing imported draft cosmetics")
