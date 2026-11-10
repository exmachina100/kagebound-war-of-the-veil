# Weapon gameplay ↔ asset production contract
Updated 2026-11-10. Source: GAME_DESIGN.md, WORLD_VISION.md, ROADMAP.md, ART_DIRECTION.md.

Every playable weapon needs BOTH a server-authoritative gameplay path and an original art path. Do not confuse server-created blockout parts with a finished importable mesh. Weapon asset agent owns the mesh/generator/material/import files; main gameplay owns rules, combat, equip, HUD and tests. Animation workstream owns R15 choreography once a task slot becomes available.

| Weapon | Gameplay status | Asset requirement | Gate |
| --- | --- | --- | --- |
| Katana | Selectable playtest | ART-003 Veilblade mesh export and Studio import | Imported mesh + two-client QA |
| Nodachi | Selectable playtest | Original elongated blade mesh, distinct guard and grip | Correct hand pivot + attack timing |
| Tanto | Selectable playtest | Compact blade and short hilt mesh | Short-range readability |
| Naginata | Selectable playtest | Curved polearm blade, long shaft, original GLB/OBJ + generator | Hitbox and 2-hand pose QA |
| Yari | Selectable playtest | Spear-point shaft, original GLB/OBJ + generator | Narrow thrust readability and 2-hand pose QA |
| Kanabo | Not playable | Heavy studded club mesh + generator | New server attack archetype, heavy stagger balance |
| Kusarigama | Not playable | Sickle + chain visual prototype + generator | Chain simulation/collision budget, server hit rules |
| Yumi | Not playable | Bow + projectile assets + generator | Server-authoritative ranged projectile, ammo/LOS QA |

## Per-weapon asset delivery
1. Follow approved ART-001..004 and STYLE_GUIDE; preserve original Japanese-fantasy silhouettes, no copied IP.
2. Commit actual importable geometry (GLB/OBJ), reproducible editable source and material/UV information where connector supports binaries. Otherwise report verified local handoff explicitly.
3. Record triangles, scale, forward/up axes, handle grip pivot, two-hand grip offsets where applicable, collision proxies, mobile LOD, and exact file paths.
4. Provide animation timing notes matched to WeaponAttackRules.lua; do not modify gameplay from asset agent.
5. Roblox Studio import, wield, VFX, 2-client combat and 30/60 FPS performance must be verified before calling art complete.

## Coordination and priority
Main gameplay's primary experience remains Grand World exploration → quests → Yokai → mastery/rewards → masks/Veilfall → optional duels. Weapon additions are a parallel content track. Prioritize finishing the two already-enabled polearm assets and their combat verification before enabling Kanabo/Kusarigama/Yumi. Avoid spawning expensive physics chains or client-authoritative projectiles.
