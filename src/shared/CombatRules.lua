-- KAGEBOUND combat policy — ORIGINAL implementation grounded in GAME_DESIGN.md.
-- Timings are server-owned. Animation events must never authorize damage.
local Rules = {}

Rules.LightDamage = {12, 14, 18}
Rules.LightRange = 9
Rules.HeavyRange = 11
Rules.HeavyDamage = 27
Rules.LightCooldown = 0.34
Rules.HeavyCooldown = 1.05
Rules.ComboReset = 1
Rules.ParryWindow = 0.32
Rules.ParryCooldown = 1.3
Rules.DashCooldown = 1.7
Rules.DashSpeed = 68
Rules.DoubleJumpVelocity = 48
Rules.DoubleJumpCooldown = 0.3

-- The active frame begins *after* windup. Recovery blocks cancel-spam.
-- Total light duration intentionally does not exceed the client input cadence.
Rules.AttackTimeline = {
    Light = {windup = 0.12, active = 0.12, recovery = 0.08, width = 8, height = 6},
    Heavy = {windup = 0.35, active = 0.16, recovery = 0.30, width = 10, height = 6.5}
}
Rules.AttackSamples = 3
Rules.HeavyBreaksParry = true
Rules.ParryStagger = 0.28
Rules.GuardBreakStagger = 0.35
Rules.MaxPlayersHitPerSwing = 5

Rules.MaxStamina = 100
Rules.StaminaRegenPerSecond = 16
Rules.ActionCost = {Light = 7, Heavy = 23, Parry = 14, Dash = 22, DoubleJump = 12}
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
