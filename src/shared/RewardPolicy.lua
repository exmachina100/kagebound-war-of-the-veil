-- Original KAGEBOUND reward catalog. Fixed values ONLY, no input amounts from clients.
-- References: docs/WORLD_VISION.md, docs/GAME_DESIGN.md.
local Policy = {}
Policy.Catalog = {
    WhispersQuest = {shards = 25, mastery = 0, label = "Whispers Across the Veil"},
    LanternYokai = {shards = 6, mastery = 4, label = "Lantern Yokai"}
}
function Policy.Get(source)
    if typeof(source) ~= "string" then return nil end
    return Policy.Catalog[source]
end
function Policy.ValidKey(key)
    return typeof(key) == "string" and #key >= 1 and #key <= 128
end
return Policy
