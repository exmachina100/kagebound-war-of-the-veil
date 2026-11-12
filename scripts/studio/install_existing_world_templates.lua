-- Edit only. Reuses verified existing imports; no uploads or paid generation.
-- Original staging models remain unchanged. Never overwrites installed templates.
assert(not game:GetService("RunService"):IsRunning(), "Edit mode required")
assert(game.PlaceId == 92077795105213, "Wrong KAGEBOUND place")
local source = assert(workspace:FindFirstChild("KageboundAssetBatch22"), "Missing staging imports")
local storage = game:GetService("ServerStorage")
local clone = require(game.ServerScriptService.KageboundServer.CosmeticWorldArt).Clone
local report = {installed = {}, preserved = {}, errors = {}, uploads = 0}
local specs = {
    {"v07", "KageboundWorldArt", {"dojo_komainu_plinth", "dojo_ritual_banner", "dojo_suspended_bell", "moonfall_bamboo_fan", "moonfall_lantern_arch", "moonfall_stepping_stones"}},
    {"v08", "KageboundWorldArtV08", {"dojo_ceremonial_stones", "dojo_ritual_banner", "dojo_roof_eave_module", "dojo_shrine_pavilion", "dojo_stone_lantern", "dojo_torii_signature", "moonfall_arch_bridge", "moonfall_bamboo_grove"}},
}
-- Preflight every source before installing anything.
for _, spec in ipairs(specs) do
    for _, name in ipairs(spec[3]) do
        local model = assert(source:FindFirstChild(spec[1] .. "_" .. name), name)
        assert(model:IsA("Model"), "Expected imported Model: " .. name)
        local meshes = 0
        for _, part in ipairs(model:GetDescendants()) do
            assert(not part:IsA("LuaSourceContainer"), "Executable source in " .. name)
            if part:IsA("MeshPart") then
                assert(part.MeshId:match("^rbxassetid://%d+$"), "Unpublished mesh: " .. name)
                meshes += 1
            end
        end
        assert(meshes > 0, "Empty mesh model: " .. name)
    end
end
for _, spec in ipairs(specs) do
    local library = storage:FindFirstChild(spec[2])
    if not library then library = Instance.new("Folder"); library.Name = spec[2]; library.Parent = storage end
    for _, name in ipairs(spec[3]) do
        if library:FindFirstChild(name) then
            table.insert(report.preserved, spec[2] .. "/" .. name)
        else
            local original = source[spec[1] .. "_" .. name]
            local copy = assert(clone(original), "Invalid cosmetic clone")
            copy.Name = name
            -- Validation placed each source pivot at its authored origin.
            -- Normalize its display translation without changing local geometry.
            copy:PivotTo(CFrame.identity)
            copy:SetAttribute("KageboundSourceStaging", original.Name)
            copy:SetAttribute("KageboundArtStatus", "imported draft; visual/gameplay QA pending")
            copy.Parent = library
            local meshCount = 0
            for _, part in ipairs(copy:GetDescendants()) do
                if part:IsA("MeshPart") then meshCount += 1 end
            end
            table.insert(report.installed, {path=copy:GetFullName(), meshes=meshCount})
        end
        task.wait()
    end
end
game:GetService("ChangeHistoryService"):SetWaypoint("KAGEBOUND reuse 14 existing world mesh templates")
return game:GetService("HttpService"):JSONEncode(report)
