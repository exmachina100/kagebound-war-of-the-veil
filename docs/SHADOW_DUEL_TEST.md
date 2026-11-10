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

## Shadow Duel Veilfall 0.2 (new server-controlled round event; NOT Studio tested)
- New module `src/server/DuelVeilfall.lua` creates `KageboundShadowDuelArena/VeilfallRuntime`. This is **procedural visual and collision geometry**; assets are pending the ART-001/004 low-poly pipeline.
- `src/shared/DuelRules.lua` defines a deterministic event on every Active round: at **20s**, show **6s warning**, then **18s active spectral routes**, followed by **6s closing warning**, then hide collision and effects. The event ends well before the 70s round deadline.
- During an active duel, both fighters should see a secondary Veilfall HUD banner. The main round timer and score **must not reset** when these banners arrive.
- Verify eight raised spectral surfaces activate on the server for both clients, not through local client toggles. Their colliders and CanQuery should be disabled when hidden.
- If a fighter remains on a surface when it closes, the server should place the fighter safely above the permanent floor at the **same X/Z location** and clear vertical velocity.
- If a KO, forfeit, disconnect or round timeout occurs during the 20-second wait, opening warning, active phase or closing warning, the script must invalidate pending transitions and clean up collision before the next round.
- No Studio client should be able to send arbitrary Veilfall commands, claim extra bridge time or damage. The event is controlled by the match controller only, not by any RemoteEvent from clients.
- Run `tests/ShadowDuelVeilfall.studio.lua` in Studio server Command Bar. Separately test the actual timeline and collision in a **two-player Studio session**, and compare with the ART-004 environment board.
- Match-isolated Veilfall must not alter the permanent regional Moonfall Veilfall, Grand World traversal, social Kage Dojo collision, or Player attributes outside the match.

## Four-style loadout regression
- Select Shinobi / Ronin / Onmyoji / Oni Disciple before queuing. A class loadout remains locked throughout Preparing, Countdown, Active, Intermission and Finished; only return to Kage Dojo can change it.
- The **H / L1 / STYLE** active works only while DuelService.CanAct is true. Confirm that Onmyoji seal affects only the opponent in the same active match, never spectators or world Yokai. Ronin Moon Guard blocks a valid frontal light strike but not a heavy guard breaker. Oni Iron Resolve reduces but never negates all incoming damage; Shinobi Shadow Slip should not escape arena collision.
- Verify class-specific WalkSpeed survives each round's character respawn, and temporary guards/slow/armor do not persist from one round to another.
- Do not infer that class selection unlocks final R15 rig/animation assets; the four class visual sheets are separate from live imported content. See [FOUR_WARRIORS_TEST.md](FOUR_WARRIORS_TEST.md).

## Cross-mode regression — Clan Clash added
The server now has a second optional world match mode, Clan Clash 2v2, and a shared `QueueRegistry.lua`. While queued for Shadow Duel, the Clan Clash kiosk should reject an attempted second queue, and vice versa. After cancelling, players may change modes. `DuelService.Assign(p,id)` preserves the original Shadow Duel no-team path; `DuelService.Assign(p,id,"A"|"B")` is used by Clan Clash and prohibits friendly fire. Run `tests/TeamIsolation.studio.lua` in a disposable four-player Studio local server and separately verify the real Shadow Duel match lifecycle. Clan Clash must not interfere with Shadow Duel's own Veilfall arena or remote HUD.
