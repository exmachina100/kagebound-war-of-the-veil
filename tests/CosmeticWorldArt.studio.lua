-- Run in Studio Edit Command Bar after syncing src/server/CosmeticWorldArt.lua.
-- Fixtures remain unparented; originals must remain intact.
local sanitizer = require(game:GetService("ServerScriptService").KageboundServer.CosmeticWorldArt)
local owned = {}
local function keep(instance)
    table.insert(owned, instance)
    return instance
end
local checks = 0
local function check(value, message)
    assert(value, message)
    checks += 1
end
local function safe(part)
    return part.Anchored and not part.CanCollide and not part.CanTouch and not part.CanQuery
end
local ok, result = pcall(function()
    local model = keep(Instance.new("Model"))
    local part = Instance.new("Part")
    part.Size = Vector3.new(2, 3, 4)
    part.CFrame = CFrame.new(4, 5, 6)
    part.Parent = model
    local nested = Instance.new("Folder")
    nested.Parent = model
    for _, className in ipairs({"Script", "LocalScript", "ModuleScript"}) do
        Instance.new(className, nested)
    end
    local copy = keep(sanitizer.Clone(model))
    check(copy ~= nil and copy.Parent == nil, "clone must be prepared outside DataModel")
    check(safe(copy:FindFirstChildWhichIsA("BasePart")), "model geometry must be cosmetic")
    for _, descendant in ipairs(copy:GetDescendants()) do
        check(not descendant:IsA("LuaSourceContainer"), "executable descendant survived")
    end
    check(#nested:GetChildren() == 3 and not part.Anchored and part.CanCollide,
        "original template was mutated")
    check(copy:GetPivot() == model:GetPivot(), "source pivot changed")
    check(copy:FindFirstChildWhichIsA("BasePart").Size == part.Size, "source size changed")

    local rootPart = keep(Instance.new("Part"))
    local childPart = Instance.new("Part", rootPart)
    Instance.new("Script", childPart)
    local partCopy = keep(sanitizer.Clone(rootPart))
    check(safe(partCopy) and safe(partCopy:FindFirstChildWhichIsA("BasePart")),
        "BasePart root and nested geometry must both be sanitized")
    check(partCopy:FindFirstChildWhichIsA("Script", true) == nil, "nested script survived")
    local empty = keep(Instance.new("Model"))
    check(sanitizer.Clone(empty) == nil, "empty model must be rejected")
    rootPart.Archivable = false
    check(sanitizer.Clone(rootPart) == nil, "non-Archivable template must be skipped")
    check(sanitizer.Clone(nested) == nil, "unsupported root must be rejected")
    return {passed = checks, scope = "cosmetic clone fixtures; no world art promotion or gameplay QA"}
end)
for _, instance in ipairs(owned) do instance:Destroy() end
assert(ok, result)
print("[KAGEBOUND CosmeticWorldArt] " .. checks .. " fixture checks passed")
return result
