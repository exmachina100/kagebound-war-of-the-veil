-- Run from Studio SERVER Command Bar after importing an optional VeilbladeVisual model.
-- These checks do not create any mesh upload or bypass Roblox asset permissions.
local ServerStorage=game:GetService("ServerStorage")
local art=ServerStorage:FindFirstChild("KageboundArt")
local template=art and art:FindFirstChild("VeilbladeVisual")
if not template then
    print("[KAGEBOUND IMPORT] No optional VeilbladeVisual in ServerStorage/KageboundArt; procedural fallback remains expected.")
    return
end
assert(template:IsA("Model"),"VeilbladeVisual must be Model")
local count=0
for _,part in ipairs(template:GetDescendants()) do
    if part:IsA("MeshPart") then
        count+=1
        assert(part.MeshId~="","MeshPart has no uploaded MeshId")
    end
end
assert(count>0,"Imported visual needs at least one MeshPart")
print("[KAGEBOUND IMPORT PASS] VeilbladeVisual contains",count,"MeshPart(s).")
print("[KAGEBOUND IMPORT] Start a 2-player Play test to confirm auto-equip, hand alignment and swing trail.")
