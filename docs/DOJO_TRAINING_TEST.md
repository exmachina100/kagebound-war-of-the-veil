# Kage Dojo training lane 0.1 — Studio acceptance test

**Code on main; not yet executed in Roblox Studio.**
Source: `docs/WORLD_VISION.md` (safe social hub and training grounds), `docs/GAME_DESIGN.md`, ART-001 and ART-004 (Kage Dojo lanterns, ceremonial dark stone, fox motif). The posts are **procedural placeholders**, not final approved world assets.

## What was added
- `src/shared/WorldConfig.lua`: practice circle centered around **X 64, Z 65**, radius 33 studs.
- `src/server/DojoTraining.server.lua`: three noncolliding practice posts near **Z 76**, with 120 HP each, hit counters and automatic 2-second health reset when reduced to zero. Cosmetic fox masks, warm gold accents and violet training-ring outline.
- `src/server/Combat.server.lua`: server permits an equipped Veilblade to perform katana swings inside this circle, but the existing `protectedHub` player-damage logic still prevents PvP. Training target damage is bounded to tagged posts. No Spirit Shards, mastery, quest progress or enemy kill credit is awarded for dummies.

## Studio test steps
1. Stop previous Rojo server with Ctrl+C. Run `git pull origin main` then `rojo serve default.project.json`.
2. Connect Rojo from Roblox Studio. **Test with two players**. Spawn at Kage Dojo and inspect Explorer.
3. Expect `Workspace/KageboundTraining/PracticePost_1`, `PracticePost_2` and `PracticePost_3` and 24 glowing outline segments. Studio Output: `[KAGEBOUND] Kage Dojo practice lane ready: 3 safe targets (ART-004)`.
4. Walk from spawn toward **X 64, Z 65** and face the posts at **Z 76**. Equip the Veilblade; click Mouse1 for a 3-hit sequence and R for heavy. Expect windup/follow-through, blade trail, impact VFX and decreasing health labels.
5. Health resets to 120 two seconds after reaching zero; hit counter continues counting for this server session.
6. Have player B stand in the same practice area directly in front of player A. Attack toward player B while a post is behind them. **Player B must not lose health**. Only tagged posts can take damage in the hub.
7. Stand elsewhere inside Kage Dojo, outside the 33-stud training circle. Sword attacks should be rejected. In the full Moonfall Bamboo region, ordinary player-versus-player attacks remain governed by server cooldowns and hub protection.
8. Check two clients' Spirit Shards and Veilblade Mastery attributes before and after hitting posts; neither counter may change.
9. Unequip Veilblade and attack. No accepted Windup/Swing or server damage should occur.
10. Run `tests/DojoTraining.studio.lua` in the **server** Command Bar. All three target models should be collidable=false and hitbox-queryable.
11. Compare appearance and VFX with actual ART-001/004 reference boards. Capture an in-game screenshot and record any silhouette or readability deviations.

## Current limits
- Animated katana clips are pending publication. Weapon grip fallback is local; the server-owned attack remains authoritative.
- Training is only sword-combo feedback, not NPC sparring. No parry tutorial, AI defensive practice, level-based damage or matchmaking.
- Posts have no persistent high scores. All hit counters and health reset when the server closes.
- The Studio test and live multiplayer damage security are pending. Do not claim the practice lane is verified solely from code presence.
