-- Edit-only, idempotent preparation of reused free Store geometry.
assert(not game:GetService("RunService"):IsRunning(), "Edit mode required")
assert(game.PlaceId == 92077795105213, "Wrong place")
local storage = game.ServerStorage
local originals = assert(storage:FindFirstChild("KageboundCreatorStoreReview"))
local Clone = require(game.ServerScriptService.KageboundServer.CosmeticWorldArt).Clone
local library = storage:FindFirstChild("KageboundStoreArt")
if not library then library=Instance.new("Folder");library.Name="KageboundStoreArt";library.Parent=storage end
local report = {}
local function finish(model, name, id, creator, height)
    model.Name = name
    for _,v in ipairs(model:GetDescendants()) do
        if v:IsA("Sound") or v:IsA("ParticleEmitter") or v:IsA("Light") or v:IsA("Camera") then v:Destroy() end
    end
    local _, size = model:GetBoundingBox()
    model:ScaleTo(model:GetScale() * height / size.Y)
    model:PivotTo(CFrame.identity)
    local box, bounds = model:GetBoundingBox()
    model:PivotTo(CFrame.new(-box.X, bounds.Y/2-box.Y, -box.Z))
    -- Pivot is ground center; geometry stays above it.
    model.WorldPivot = CFrame.identity
    model:SetAttribute("SourceAssetId", id)
    model:SetAttribute("SourceCreator", creator)
    model:SetAttribute("ArtReference", "ART-004")
    model:SetAttribute("ArtStatus", "adapted draft; device and final visual QA pending")
    model.Parent = library
    table.insert(report, {name=name,parts=#model:GetDescendants(),height=height})
end
if not library:FindFirstChild("StoneLantern") then
    local source = assert(originals:FindFirstChild("Review_StoneLantern_873427672"))
    local best, difference
    for _,m in ipairs(source:GetDescendants()) do
        if m:IsA("Model") and m.Name=="Shrine Toro 1" then
            local _,s=m:GetBoundingBox()
            local d=math.abs(s.Y-4.79722)
            if not difference or d<difference then best,difference=m,d end
        end
    end
    local model=assert(Clone(assert(best)), "Lantern clone failed")
    for _,v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            if v.Material==Enum.Material.Neon then
                v.Color=Color3.fromRGB(250,182,107)
            else v.Color=Color3.fromRGB(83,86,108);v.Material=Enum.Material.Slate end
        end
    end
    -- Inherited lights are removed; install only bounded controlled lighting.
    finish(model,"StoneLantern",873427672,"nezko",6)
    for _,v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") and v.Material==Enum.Material.Neon then
            local light=Instance.new("PointLight");light.Name="LanternGold";light.Color=v.Color;light.Brightness=1.8;light.Range=18;light.Shadows=false;light.Parent=v
        end
    end
end
if not library:FindFirstChild("Bamboo") then
    local model=assert(Clone(assert(originals:FindFirstChild("Review_Bamboo_114095523"))))
    for _,v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Color=v.Color.G>v.Color.R and Color3.fromRGB(45,86,74) or Color3.fromRGB(94,111,65)
            v.Material=Enum.Material.SmoothPlastic
        end
    end
    finish(model,"Bamboo",114095523,"Athiaus",22)
end
game:GetService("ChangeHistoryService"):SetWaypoint("KAGEBOUND adapted Store lantern and bamboo")
return report
