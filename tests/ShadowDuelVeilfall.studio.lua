-- KAGEBOUND Studio-only Duel Veilfall policy checks.
-- Paste into Server Command Bar during Play, after Rojo sync.
local Shared=game.ReplicatedStorage:WaitForChild("KageboundShared")
local rules=require(Shared:WaitForChild("DuelRules"))
local config=rules.Veilfall
local function check(name,yes)
    assert(yes,"[KAGEBOUND DUEL VEILFALL FAIL] "..name)
    print("[KAGEBOUND DUEL VEILFALL PASS] "..name)
end
check("Veilfall policy exists",type(config)=="table")
check("Warning occurs during the active round",config.StartAt>0 and config.WarningSeconds>=3)
check("Active bridges have measurable lifetime",config.ActiveSeconds>8)
check("Closing warning precedes removal",config.ClosingSeconds>=4)
check("All phases fit the round",config.StartAt+config.WarningSeconds+config.ActiveSeconds+config.ClosingSeconds < rules.RoundSeconds)
check("Duel Veilfall module exists",game.ServerScriptService.KageboundServer:FindFirstChild("DuelVeilfall")~=nil)
local area=workspace:WaitForChild("KageboundShadowDuelArena",15)
check("Duel arena exists",area~=nil)
local parts=area and area:FindFirstChild("VeilfallRuntime")
check("Veilfall runtime geometry exists",parts~=nil and #parts:GetChildren()>=6)
print("[KAGEBOUND] Run two-client timing/early-KO/disconnect/collision tests; this is only a contract check.")
