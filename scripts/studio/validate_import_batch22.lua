-- Invoke in Edit through MCP with primitive-specs.json decoded as the argument.
-- Repairs this staging copy only; does not publish packages or activate equipment.
return function(specs)
    local folder = assert(workspace:FindFirstChild("KageboundAssetBatch22"), "Missing batch")
    local function vec(a) return Vector3.new(a[1], a[2], a[3]) end
    -- This batch imports with a baked 180-degree Y rotation; retain that convention.
    local function center(a) return Vector3.new(-a[1], a[2], -a[3]) end
    local report = {models = {}, errors = {}, meshCount = 0, texturedCount = 0}
    for index, spec in ipairs(specs) do
        local model = folder:FindFirstChild(spec.name)
        local row = {name = spec.name, meshes = 0, textured = 0, repairedColors = 0, mismatches = {}}
        table.insert(report.models, row)
        if not model then
            table.insert(report.errors, spec.name .. ": model missing")
            continue
        end
        local parts, actualMean, expectedMean = {}, Vector3.zero, Vector3.zero
        for _, p in model:GetDescendants() do
            if p:IsA("MeshPart") then
                table.insert(parts, p)
                actualMean += p.Position
            elseif p:IsA("LuaSourceContainer") then
                table.insert(report.errors, spec.name .. ": unexpected executable source")
            end
        end
        if #parts ~= #spec.primitives then
            table.insert(report.errors, spec.name .. ": source/import mesh count mismatch")
            continue
        end
        for _, primitive in ipairs(spec.primitives) do expectedMean += center(primitive.center) end
        local offset = (actualMean - expectedMean) / #parts
        local pairsToMatch = {}
        for i, p in ipairs(parts) do
            for j, primitive in ipairs(spec.primitives) do
                local score = (p.Size - vec(primitive.size)).Magnitude
                    + (p.Position - offset - center(primitive.center)).Magnitude
                table.insert(pairsToMatch, {i=i, j=j, score=score})
            end
        end
        table.sort(pairsToMatch, function(a,b) return a.score < b.score end)
        local usedParts, usedSpecs, assignments = {}, {}, {}
        for _, pair in ipairs(pairsToMatch) do
            if not usedParts[pair.i] and not usedSpecs[pair.j] then
                usedParts[pair.i], usedSpecs[pair.j] = true, true
                table.insert(assignments, pair)
            end
        end
        local safe = true
        for _, match in ipairs(assignments) do
            if match.score > 0.001 then
                safe = false
                table.insert(row.mismatches, {part=parts[match.i].Name, deviation=match.score})
            end
        end
        if not safe then
            table.insert(report.errors, spec.name .. ": primitive dimensions/positions differ from source")
            continue
        end
        local sourceMinY = math.huge
        for _, p in ipairs(spec.primitives) do sourceMinY = math.min(sourceMinY, p.center[2]-p.size[2]/2) end
        -- Keep authored source ground for world pieces; ground weapon/mask displays.
        local origin = Vector3.new(180 + ((index-1)%6)*18,
            1 - ((spec.group == "weapon" or spec.group == "mask") and sourceMinY or 0),
            math.floor((index-1)/6)*24)
        local maxDeviation = 0
        for _, match in ipairs(assignments) do
            local p, primitive = parts[match.i], spec.primitives[match.j]
            local expectedColor = Color3.new(unpack(primitive.color))
            if (Vector3.new(p.Color.R,p.Color.G,p.Color.B)-vec(primitive.color)).Magnitude > 0.01 then
                row.repairedColors += 1
            end
            p.Color = expectedColor
            p.Anchored, p.CanCollide, p.CanTouch, p.CanQuery = true, false, false, false
            p.CFrame += origin - offset
            p:SetAttribute("KageboundSourceMaterial", primitive.material)
            maxDeviation = math.max(maxDeviation, match.score)
            local sa = p:FindFirstChildWhichIsA("SurfaceAppearance")
            local textured = p.TextureID ~= "" or (sa and tostring(sa.ColorMap) ~= "")
            if textured then row.textured += 1 end
            if primitive.textured and not textured then table.insert(report.errors, spec.name .. ": missing texture") end
            if p.MeshId == "" then table.insert(report.errors, spec.name .. ": missing MeshId") end
        end
        model.WorldPivot = CFrame.new(origin)
        model:SetAttribute("KageboundImportGroup", spec.group)
        model:SetAttribute("KageboundImportQA", "geometry/material staging checks; gameplay fit pending")
        row.meshes = #parts
        row.maxPrimitiveDeviation = maxDeviation
        row.sourceOrigin = {origin.X,origin.Y,origin.Z}
        local _, size = model:GetBoundingBox()
        row.size = {size.X,size.Y,size.Z}
        report.meshCount += row.meshes
        report.texturedCount += row.textured
        task.wait()
    end
    game:GetService("ChangeHistoryService"):SetWaypoint("Validate and arrange 22 imported KAGEBOUND models")
    return report
end
