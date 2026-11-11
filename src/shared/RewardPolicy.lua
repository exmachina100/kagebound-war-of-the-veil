-- Original KAGEBOUND reward catalog. Fixed values ONLY, no input amounts from clients.
-- References: docs/WORLD_VISION.md, docs/GAME_DESIGN.md.
local Policy = {}
Policy.Catalog = {
    WhispersQuest = {shards = 25, mastery = 0, label = "Whispers Across the Veil"},
    MoonfallHunt = {shards = 25, mastery = 0, label = "Moonfall Lantern Hunt"},
    LanternYokai = {shards = 6, mastery = 4, label = "Lantern Yokai"},
    TravelGuide = {shards = 10, mastery = 0, label = "Pilgrim of the Veil"}
}
function Policy.Get(source)
    if typeof(source) ~= "string" then return nil end
    return Policy.Catalog[source]
end
function Policy.ValidKey(key)
    return typeof(key) == "string" and #key >= 1 and #key <= 128
end
return Policy
