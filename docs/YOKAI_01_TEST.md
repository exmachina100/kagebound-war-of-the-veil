# KAGEBOUND — Lantern Yokai combat test (Grand World PvE 0.1)

**Status:** Code implemented and committed; Roblox Studio runtime still unverified.

## Canonical design
This enemy is an original, non-One-Piece Moonfall Lantern Yokai, referencing approved ART-001/002/004.
The humanoid silhouette, ivory mask, vermilion horns, ink body and violet spirit heart are **temporary procedural geometry**, not final meshes or animation assets.
See [GAME_DESIGN](GAME_DESIGN.md), [WORLD_VISION](WORLD_VISION.md), [VFX_SPEC](VFX_SPEC.md).

## Setup
1. Update your local Rojo clone: `git pull origin main`; then `rojo serve default.project.json`.
2. In Studio, start a 2-player test. Explorer should include `Workspace/KageboundEnemies`.
3. Expected Output includes `[KAGEBOUND] Moonfall Lantern Yokai: 3 server-owned PvE enemies online`.
4. Travel to Moonfall Bamboo, center approx **X=0, Z=-780**. Enemies spawn around (X=-90, Z=-755), (X=88, Z=-795) and (X=10, Z=-888).
5. Alternatively use the server-side command bar in a Studio Play test to relocate test players near one enemy, e.g. `game.Players:GetPlayers()[1].Character.HumanoidRootPart.CFrame=CFrame.new(-90,8,-746)`.

## Behavior and acceptance
- Enemy has **110 HP** and a floating name/HP label. Approaches players within approximately 65 studs of itself (and up to 85 studs from its home).
- When within approximately 10 studs it **telegraphs** an attack for 0.70s; get out of range to avoid damage.
- If still in range without a successful parry or solid obstruction, it inflicts **11 damage**, then recovers for ~0.85s.
- Press **F** during the final 0.32 seconds before contact. With an active server parry window the attack should not deal damage. Confirm the blue parry ring.
- Press **Mouse1** for 3-hit katana strikes or **R** for a heavy strike. Damage to Yokai must be computed exclusively by the server with the same swept attack hitbox as player PvP. Each swing should damage the Yokai **once**, even if multiple body parts overlap.
- Health must decrease from 110 to 0 and cause defeat VFX, then the enemy should respawn after approximately 14 seconds.
- Attacking from behind a solid wall or outside reach should not deal damage.
- Keep one player in Kage Dojo and another near Moonfall; the enemy must not appear in or attack inside the safe hub.
- Observe no duplicate damage from a single swing, no malformed model pivots, no telegraph spamming, and no progression rewards being awarded (rewards aren't implemented yet).
- Verify the same behavior with 2 players present simultaneously, without one player impersonating another via remotes.

## Known limitations
- The NPC is an anchored, script-pivoted procedural block model, **not** a Roblox Humanoid rig with authored run/attack animations.
- Simple state machine: Return / Pursue / Telegraph / Recover / Defeated. No coordinated groups, pathfinding, wall avoidance, feinting, dodge, stagger, boss phases, loot or persistent reward grants.
- Enemy hitbox and health are server-owned, but not penetration-tested in a live Roblox multiplayer test.
- No AI spawn culling or world streaming integration yet. Test client/server load on mobile before increasing counts.
- NPC and player parry share a server-set timing attribute for this prototype. A future defense service must unify parry consumption across PvP and PvE to eliminate cross-mode edge cases.

**Next gate:** record actual Studio Output and screenshots against ART-001/002/004, then add hit reactions, navigation and server-owned reward transactions before more enemy varieties.
