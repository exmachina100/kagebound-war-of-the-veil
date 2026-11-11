-- KAGEBOUND optional authenticated flipbook ParticleEmitter renderer.
-- On missing/unpublished Roblox Texture IDs, return false and keep geometry FX.
-- Source originals: four class sheets + ART-001..004 + transparent 4x4 export pack.
local Debris=game:GetService("Debris")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Catalog=require(ReplicatedStorage:WaitForChild("KageboundShared"):WaitForChild("VFXTextureCatalog"))
local Sprite={}

function Sprite.Play(root,key,size,lifetime)
    local uri=Catalog.Resolve(key)
    if not uri or not root or not root:IsA("BasePart") then return false end
    local attachment=Instance.new("Attachment")
    attachment.Name="KGB_VFX_"..key
    attachment.Position=Vector3.new(0,1.5,0)
    attachment.Parent=root

    local e=Instance.new("ParticleEmitter")
    e.Name="KGB_"..key.."_Flipbook"
    e.Texture=uri
    e.FlipbookLayout=Enum.ParticleFlipbookLayout.Grid4x4
    e.FlipbookMode=Enum.ParticleFlipbookMode.OneShot
    e.FlipbookBlendFrames=true
    e.Enabled=false
    e.Rate=0
    e.Speed=NumberRange.new(0)
    e.Lifetime=NumberRange.new(math.clamp(lifetime or .55,.2,1.5))
    e.Size=NumberSequence.new(math.clamp(size or 6,1,20))
    e.LightEmission=.8
    e.LightInfluence=0
    e.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,.05),
        NumberSequenceKeypoint.new(.7,.12),
        NumberSequenceKeypoint.new(1,1)
    })
    e.Parent=attachment
    e:Emit(1)
    Debris:AddItem(attachment,math.clamp(lifetime or .55,.2,1.5)+.3)
    return true
end
return Sprite
