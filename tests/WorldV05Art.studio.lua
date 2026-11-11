-- Run in a normal Studio server Script after startup. Structural safety only;
-- does not certify rendering, frame rate, traversal or final ART-004 parity.
local templates=game.ServerStorage:WaitForChild("KageboundWorldV05",20)
local counts={dojo_curved_roof=22,dojo_offering_pavilion=11,dojo_ceremonial_court=56,
    moonfall_arch_bridge=39,moonfall_bamboo_canopy=126,moonfall_ritual_lantern=11}
local total=0
assert(#templates:GetChildren()==6,"Expected six native model templates")
for name,expected in pairs(counts) do
    local model=templates:FindFirstChild(name)
    assert(model and model:IsA("Model"),"Missing template: "..name)
    local parts=0
    for _,item in ipairs(model:GetDescendants()) do
        assert(not item:IsA("LuaSourceContainer"),"Unexpected script in native template")
        if item:IsA("MeshPart") then
            parts+=1
            assert(item.MeshId~="","Missing uploaded mesh ID")
            assert(item.Anchored and not item.CanCollide and not item.CanTouch and not item.CanQuery,
                "Unsafe cosmetic template flags")
        end
    end
    assert(parts==expected,"Native mesh count mismatch: "..name)
    total+=parts
end
assert(total==265,"Expected 265 native MeshParts")
local world=workspace:WaitForChild("KageboundWorld",20)
local placed=world:WaitForChild("ImportedV05Art",20)
local deadline=os.clock()+15
while #placed:GetChildren()<3 and os.clock()<deadline do task.wait(.1) end
assert(#placed:GetChildren()==3,"Expected three cosmetic draft placements")
for _,model in ipairs(placed:GetChildren()) do
    assert(model:GetAttribute("KageboundAssetStage")=="ImportedDraft","Missing draft stage")
    for _,item in ipairs(model:GetDescendants()) do
        if item:IsA("BasePart") then
            assert(item.Anchored and not item.CanCollide and not item.CanTouch and not item.CanQuery,
                "Imported appearance affects gameplay collision/query")
        end
    end
end
print("[KAGEBOUND V05 PASS] Six templates, 265 meshes, three safe cosmetic draft placements")
