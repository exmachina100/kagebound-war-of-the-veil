-- Studio regression: shared cooldown must apply across Light/Heavy and weapon changes.
-- Run with two clients after equipping Katana, Tanto, and Nodachi in the dojo.
-- 1. Send Light then Heavy within the Light profile cooldown; Heavy must be rejected.
-- 2. Send Heavy then Light before Heavy cooldown expires; Light must be rejected.
-- 3. Switch weapons in dojo and immediately send another attack; existing cooldown must persist.
-- 4. Repeated Light remote spam must not multiply damage or bypass stamina.
-- 5. After cooldown expires, attacks resume with server-owned profile values.
-- 6. Check Shadow Duel/Clan friendly fire and SafeHub practice exclusions.
-- No automated Roblox runtime assertions are claimed by this checklist.
return true
