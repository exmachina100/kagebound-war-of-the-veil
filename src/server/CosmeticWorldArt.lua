-- Prepare world-art clones outside the DataModel, before any code can execute.
-- Callers retain placement/scale ownership; procedural geometry owns collision.
local CosmeticWorldArt = {}

function CosmeticWorldArt.Clone(template)
    if not template or not (template:IsA("Model") or template:IsA("BasePart")) then
        return nil
    end
    local copy = template:Clone()
    if not copy then return nil end -- Non-Archivable template.
    local parts = {}
    if copy:IsA("BasePart") then table.insert(parts, copy) end
    for _, descendant in ipairs(copy:GetDescendants()) do
        if descendant:IsA("LuaSourceContainer") then
            descendant:Destroy()
        elseif descendant:IsA("BasePart") then
            table.insert(parts, descendant)
        end
    end
    local count = 0
    for _, part in ipairs(parts) do
        -- A part beneath a removed script may already have been destroyed.
        if part == copy or part:IsDescendantOf(copy) then
            part.Anchored = true
            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false
            count += 1
        end
    end
    if count == 0 then
        copy:Destroy()
        return nil
    end
    return copy
end

return CosmeticWorldArt
