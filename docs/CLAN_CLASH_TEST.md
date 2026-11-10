# KAGEBOUND — Clan Clash 2v2 v0.1 | Four-player Studio QA

**Implementation status:** code committed to main; multiplayer Roblox Studio runtime, visual QA and performance **NOT YET VERIFIED**. Canonical source: `GAME_DESIGN.md`, `GAME_DESIGN_ORIGINAL_338.md`, `WORLD_VISION.md`, `ART_DIRECTION.md`. Only **2v2** is implemented; 3v3 to 5v5, clan rosters and matchmaking are future production work.

## Ground rules
- 4 players queue at the **Clan Clash kiosk in Kage Dojo (X≈45, Z≈45)**. Separate from Shadow Duel kiosk (X≈−45, Z≈45).
- First four players are assigned to two server-authoritative teams A and B, two per side. One local match per Roblox server.
- Match: best-of-five, first to three round wins; 3-second countdown, 80-second round, 4-second break, five-round maximum.
- At knockout or time limit, server counts **surviving teammates** first and compares remaining total team health when both sides have survivors. No client chooses winner, scores, target/team or damage.
- Arena is an isolated procedural 192×156-footprint test layout at approximately (2160, 145, 2090) with collision walls, cover and ART-004-inspired spectral motifs. Not final approved environmental art.
- During an active match, no **friendly fire**, no external-world PvP or Yokai hits, no damage between separate Shadow Duel/Clan Clash participants, and no attacks during countdown/intermission.
- One player cannot queue for both match modes simultaneously. Cancellation and disconnection release queue ownership.
- Veilfall: first warning after 24 seconds, 6-second countdown, server-owned spirit platforms active for 22 seconds and 6-second closing warning. If the round ends early, platform collisions are cleared; players standing on closing platforms should be safely repositioned.
- Final result triggers character reload/return to Kage Dojo. There is NO reward payout, ranking, clan progression or persistent matchmaking yet.

## Studio test
1. Run `git pull origin main` in your clone, `rojo serve default.project.json` and reconnect the Rojo Studio plugin.
2. Start a **4-player Studio local server test**. Check Output for `[KAGEBOUND] Clan Clash 2v2 best-of-five team arena ready` and Studio smoke results for ClanRules, QueueRegistry, Clan Clash remote/script.
3. Two players queue at Clan kiosk, then two more. A 2-player queue should WAIT and not launch a match. The fourth join should start the match and show team names/score on all four client HUDs.
4. During Countdown, attempt Light/Heavy/Class/Mask skill casts; no damage or harmful effects should be authorized.
5. During Active, team A players may attack team B but MUST NOT damage each other, even with AoE Oni mask or Onmyoji Seal slow. Repeat with a fifth spectator in the arena: spectators must not receive eligible match hits or act as participants.
6. Trigger KO for both team A members; team B wins the round. Separately, time out with both sides alive and check that server totals HP correctly. Test exact tie should be a draw.
7. Wait through Veilfall warning → activation → closing. Check the server collision is synchronized for all four clients and no one drops through deleted platforms during early KO or forfeit.
8. Test class selection in dojo BEFORE queuing; after matching, class selection must be rejected throughout all phases. Style WalkSpeed and class-specific abilities should survive arena respawns; G mythic masks continue to be independent.
9. Try to join Shadow Duel while waiting for Clan Clash and vice versa. The second request must be blocked. Cancel the first queue; joining the other should then work.
10. Forfeit with either team while Active and disconnect a participant during Preparing/Active/Intermission. Verify remaining players are released, no one remains in the isolated arena, and the next queued group can start.
11. Test quick repeated queue prompts, duplicate remote calls, manual character resets, two match modes in the same server, and leaving/rejoining. No stale `KageboundDuelId`, `KageboundMatchTeam`, `KageboundMatchMode` or queue membership may remain.
12. Profile low-end mobile and 4-player melee/VFX simultaneous combat; watch parts, beams and particle overdraw. Compare arena screenshots to ART-004; a procedural arena is not final art.

## Contract tests
- `tests/ClanRules.studio.lua` — pure scoring and round policy.
- `tests/TeamIsolation.studio.lua` — run in an **idle four-player Studio server**; temporarily assigns members to a QA match, verifies friendly-fire rejection, cross-team eligibility, one-queue ownership and original 1v1 backward compatibility; automatically clears those test assignments.
- `tests/ClassRules.studio.lua`, `tests/ClassService.studio.lua`, `tests/MaskRules.studio.lua` — regression rules.
- These tests have NOT been executed by ChatGPT in Roblox Studio.

## Major release blockers
- Four-player end-to-end Studio runs + logs; team UI/lobby polish, map boundaries/escape handling, failure recovery and camera tests
- Party invitations, clan registration, skill-based matchmaking, team-color identity, player grouping and genuine 3v3–5v5 support
- More arena variants, polished moonlit environment meshes/lighting, authored rig/animation VFX, sound
- Balance: class slows and mitigation, team combos, latency, spawn immunity, anti-cheat, leaving/rejoining, queue flood/DoS tests
- Secure rewards, inventory and progression, all controlled on server

Keep Clan Clash as a **prototype**, not a production-ready live release, until those gates pass.
