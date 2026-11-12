-- Adapted free Creator Store props. ART-004 moonlit shrine and bamboo framing.
-- Templates installed by scripts/studio/prepare_store_world_dressing.lua.
local Config = require(game.ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("WorldConfig"))
if not Config.Enabled then return end
local library = game.ServerStorage:FindFirstChild("KageboundStoreArt")
if not library then return end
local world = workspace:WaitForChild("KageboundWorld", 60)
if not world or world:FindFirstChild("StoreWorldDressing") then return end
local clone = require(script.Parent:WaitForChild("CosmeticWorldArt")).Clone
local folder = Instance.new("Folder")
folder.Name = "StoreWorldDressing"
folder.Parent = world
local placements = {}
for _, z in ipairs({-45, -85, -115, -150}) do
    for _, x in ipairs({-20, 20}) do table.insert(placements, {"StoneLantern", x, z, 0}) end
end
for index, p in ipairs({{-42,-110},{42,-110},{-48,-140},{48,-140},{-36,-177},{36,-177}}) do
    table.insert(placements, {"Bamboo", p[1], p[2], index*43})
end
for i, item in ipairs(placements) do
    local template = library:FindFirstChild(item[1])
    local copy = template and clone(template)
    if copy then
        copy.Name = item[1] .. "_" .. i
        copy:PivotTo(CFrame.new(item[2], 1.76, item[3]) * CFrame.Angles(0, math.rad(item[4]), 0))
        copy.Parent = folder
    end
    task.wait()
end
