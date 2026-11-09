-- Run in Roblox Studio's CLIENT Command Bar during a local Play test.
-- The VFX gallery is intentionally disabled in published live sessions.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
assert(player,"Use the CLIENT Command Bar, not server.")
local gui=player:WaitForChild("PlayerGui"):WaitForChild("KageboundVFXStudioPreview",10)
assert(gui,"Missing Studio VFX preview GUI")
local frame=gui:FindFirstChild("VFXPreviewToolbar")
assert(frame and frame:IsA("Frame"),"Missing preview panel")
for _,name in ipairs({"Shinobi","Ronin","Onmyoji","OniDisciple","Kitsune","Oni","Tengu","Parry"}) do
    assert(frame:FindFirstChild(name),"Missing class/mask preview: "..name)
    print("[KAGEBOUND VFX PREVIEW PASS] "..name)
end
local catalog=require(ReplicatedStorage.KageboundShared.VFXTextureCatalog)
assert(catalog.Resolve("Shinobi")==nil,"Expected blank default asset IDs until import")
print("[KAGEBOUND] Press P in Kage Dojo and click each local-only VFX button.")
