# KAGEBOUND Shadow Duel 0.1 — multiplayer acceptance

**Source of truth**: GAME_DESIGN.md, WORLD_VISION.md, ROADMAP.md, ART_DIRECTION.md, DuelRules.lua. Optional best-of-five PvP activity in **Grand World**. Script exists on GitHub; actual Studio two-client test is pending.

## Prerequisites
- Update local clone with `git pull origin main`; launch `rojo serve default.project.json`.
- Studio Test > Start with **2 players**, separate client windows, Output open.
- Confirm `KageboundServer/ShadowDuel` and `KageboundServer/DuelService`, `KageboundClient/ShadowDuelHUD`, and `KageboundShared/DuelRules`. Startup reports Shadow Duel queue ready.
- The queue kiosk is at Kage Dojo approx X=-45, Z=45 (within non-PvP safe hub). Use E in each client to enter queue.

## Expected loop
1. Both players consent via ProximityPrompt. First player sees waiting queue; second entry pairs them.
2. The server places them in the separate elevated duel space at ~ (1740,140,1720), resets characters/health for each round, and shows **3-second countdown**. Sword must re-equip after respawn.
3. During countdown and intermission, attack requests must be denied by `DuelService.CanAct`. After RoundStart, players can use Light/Heavy/Parry/Dash. Test 3-hit combo, heavy vs timed parry, once-per-swing and stamina.
4. At KO or **70-second timeout**, the server compares health. A win gives a point; equal health or mutual KO is a draw. Match ends on first to **three round wins** or after **five rounds**.
5. Round break is **4 seconds**; intermission should not permit damage.
6. End-of-match HUD shows winner and score, followed by a safe return to Kage Dojo via character respawn. Kiosk may then accept players again.
7. Queue cancellation must work. Forfeit must terminate the match without crediting the forfeit player as winner. Disconnect must clean membership and queue without trapping remaining player.
8. Existing **Kage Dojo SafeHub PvP protection** must stay intact; unrelated world players must never damage duellists or receive duel damage. Enemy rewards and dojo target hits remain separate from duel combat.
9. Test with a third player: they must not damage fighters, join a match already running, steal or duplicate the match's scoring, or interfere with the out-of-world arena.
10. Test remote spam of CancelQueue/Forfeit, death/respawn during preparation and each round, and rapid reconnect. No duplicate rewards, stuck HUD or permanent `KageboundDuelId` attributes.
11. Observe the approved ART-001/004 visual treatment. Arena is currently **procedural blockout**, not the finished Moonfall transformation, so don't mark visual QA complete.

## Static checks
- `tests/ShadowDuelRules.studio.lua` (Studio Server Command Bar).
- Verify `DuelService.CanDamage(a,b)` only admits matched, Active fighters when either participant is in a duel; never trust client-provided match scores or opponents.
- Verify `Combat.server.lua` calls DuelAuthority.CanDamage before applying PvP damage and CanAct before allowing melee.
- Check live console for script errors, 2 client HUDs and match phase attributes.

## Release blockers
- Actual 2-client Studio gameplay evidence (Output + screenshots)
- Arena out-of-bounds/escape handling, spectator and queue UX, long-running match cleanup, draw/forfeit edge cases
- Round-specific Veilfall scheduling, final assets, real animation IDs and cross-platform controls
- More than one simultaneous isolated duel or inter-server matchmaking, anti-exploit latency/teleport checks
- Clan Clash and expanded loadouts

**Do not describe Shadow Duel as production-validated until both gameplay and art gates pass.**
