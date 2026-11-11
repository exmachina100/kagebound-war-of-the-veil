-- KAGEBOUND UI icon registry. Replace 0 with Roblox uploaded image asset IDs.
-- Source artwork: assets/ui/icons/v01/ (OpenArt import workflow).
-- Safe fallback: callers must hide image and retain their text/native icon
-- when IconRegistry.get(name) returns nil.
local Icons = {}
local ids = {
    slash = 0, parry = 0, dash = 0, veilfall = 0,
    kitsune = 0, oni = 0, tengu = 0, ofuda = 0,
    world_map = 0, quest = 0, inventory = 0, weapon = 0,
    spirit_shard = 0, dojo = 0, clan = 0, settings = 0,
}
function Icons.get(name)
    local id = ids[name]
    if type(id) ~= "number" or id <= 0 then return nil end
    return "rbxassetid://" .. tostring(id)
end
function Icons.apply(imageLabel, name)
    local uri = Icons.get(name)
    if uri then
        imageLabel.Image = uri
        imageLabel.Visible = true
        return true
    end
    imageLabel.Visible = false
    return false
end
return Icons
