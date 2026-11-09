-- Original KAGEBOUND combat policy. Reference architecture only:
-- docs/REFERENCE_REPOSITORY_REVIEW.md. No One Piece implementation imported.
local Rules = {}

Rules.LightDamage = {12, 14, 18}
Rules.LightRange = 9
Rules.HeavyRange = 11
Rules.HeavyDamage = 27
Rules.LightCooldown = .34
Rules.HeavyCooldown = 1.05
Rules.ComboReset = 1
Rules.ParryWindow = .32
Rules.ParryCooldown = 1.3
Rules.DashCooldown = 1.7
Rules.DashSpeed = 68

Rules.MaxStamina = 100
Rules.StaminaRegenPerSecond = 16
Rules.ActionCost = {Light = 7, Heavy = 23, Parry = 14, Dash = 22}
Rules.VisualRefs = {"ART-001","ART-002","ART-003","ART-004"}

function Rules.NextCombo(previous, elapsed)
    local index = elapsed > Rules.ComboReset and 0 or previous
    return (index % #Rules.LightDamage) + 1
end

function Rules.CanSpend(stamina, action)
    local cost = Rules.ActionCost[action]
    return cost ~= nil and stamina >= cost
end

return Rules
