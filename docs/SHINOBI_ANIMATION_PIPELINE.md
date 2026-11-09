# Shinobi & Veilblade — animation production pipeline v0.4

**Canonical references**: ART-001 (hero silhouette and attack intensity), ART-002 (Shinobi costume and proportions), ART-003 (Veilblade katana, crimson/pink edge, dark hilt, gold fittings and red tassel); canonical design and combat timing in `docs/GAME_DESIGN.md` and `src/shared/CombatRules.lua`.

**Status**: Code integration and a local fallback grip pose are on GitHub. **No authored animation clips or usable Roblox animation asset IDs have been uploaded**, and no Roblox Studio runtime/visual acceptance test has passed. Do not describe the current block-built sword or pose as production-quality animation.

## Current runtime mechanism
- `src/shared/AnimationCatalog.lua`: optional animation IDs, currently blank (intentionally never invented).
- `src/client/ShinobiAnimation.client.lua`: when server accepts an action, attempts to load/play a configured Animator track; otherwise moves the equipped Veilblade's `Tool.Grip` locally through wind-up and follow-through poses.
- `src/server/Veilblade.server.lua`: places a disabled magenta-crimson `Trail` on blade attachments, which the owning client's animation driver briefly enables during a server-approved `Swing`.
- `src/server/Combat.server.lua`: damage and hit windows are independent of client animation, marker signals or Tool.Grip; the server requires an equipped Veilblade throughout the active strike.

The fallback works with the Tool rather than writing to `Motor6D.Transform`. New Roblox avatars can use `AnimationConstraint` joints, and custom Motor6D edits would not be a robust final solution. The temporary grip pose is local-only and other clients may rely on the replicated sword trail/arc VFX until authored character animations are present. The attached blade trail is intended as an art proxy, not a final textured slash sprite.

## Studio animation tasks (ART-001/002/003)
Use **Avatar → Animation Editor** with a KAGEBOUND R15 rig matching the approved blocky Shinobi silhouette. Ensure animation assets are published under an account/group with permission to load them in this experience. The current production approach is R15, but run R6 fallback/compatibility QA if permitted avatar types vary.

| AnimationCatalog.Shinobi slot | Motion design | Server timeline constraint |
| --- | --- | --- |
| `Light1` | narrow, confident forehand slash; fast hip torque, crisp taper | wind-up 0.12 s / active 0.12 s / recovery 0.08 s |
| `Light2` | reverse cross-cut at waist/shoulder level, opposite follow-through | same light timeline, combo index 2 |
| `Light3` | dramatic diagonal finishing blow, widest silhouette | same light timeline, 18 damage (server) |
| `Heavy` | weight shift, pronounced backswing, committed finishing cut | wind-up 0.35 s / active 0.16 s / recovery 0.30 s |
| `Parry` | tight near-body katana guard with bright blue counter accent | 0.32 s server window |
| `Dash` | low shinobi evasive posture, forward scarf motion | movement/cooldown stay server-owned |
| `DoubleJump` | controlled aerial tuck / landing recovery | server stamina and impulse stay authoritative |
| `Idle` | optional alert raised sword ready pose | not yet hooked into the runtime |

**Target authoring notes**: Pose on a 30/60 FPS timeline, avoid huge oversized animation arcs, and keep weapon motion aligned with the actual grip/hand. Every move needs identifiable anticipation, strike, and recovery, and must remain readable in multiplayer at ordinary camera distance.

**Suggested animation marker labels (cosmetic only)**: `SlashStart`, `SlashEnd`, `Whoosh`, `Footstep`. Markers may trigger **local particles/audio only**; never use marker callbacks to send damage, claimed hit targets, cooldown resets or arbitrary combat data to the server. The server's own Windup/Swing events are authoritative until animation timing is separately reconciled.

## How to attach animation IDs
1. In Studio, select the authored KAGEBOUND avatar rig. Open Animation Editor.
2. Create the Light1, Light2, Light3, Heavy and Parry tracks; publish each as **your own** animation asset.
3. Copy the published asset IDs from the Creator Dashboard/Animation Editor.
4. Edit `src/shared/AnimationCatalog.lua` (locally in your cloned repo), e.g. `Light1 = "1234567890"` using **your actual** published ID; leave unproduced slots blank.
5. `git add src/shared/AnimationCatalog.lua && git commit -m "Register owned Shinobi animations" && git push origin main`.
6. Run `rojo serve default.project.json` and reconnect Studio. Press Play and confirm the output does not warn about inaccessible/missing animations. A numeric ID alone does not prove asset permissions or rig compatibility.
7. Compare from a close-up and gameplay camera with ART-001/002/003. Verify timing against the server's VFX and health changes.

## Studio testing
- Run `tests/AnimationCatalog.studio.lua` and `tests/VeilbladeEquipment.studio.lua` in the **server** Command Bar during a Studio Play test. The catalog contract assumes unregistered slots; after adding IDs, adapt its empty-slot assertion.
- 2-player test near Moonfall Bamboo: auto-equip Veilblade; try Light1→2→3 and Heavy; visible windup/swing/trail. Check distinct directions and parry pose. Facing the enemy is required for server damage. Unequip the sword, and ensure attacks no longer cause damage or display accepted slash VFX.
- Respawn, reequip and ensure neither old grip tweens nor old animation tracks linger.
- Test 30 FPS/mobile, R15, streaming transitions and high-latency simulation. No giant screen-filling trails; maintain clarity in front of the real enemy silhouette.
- Log a visual screenshot/short video for reference review, then register exact Roblox animation IDs and model versions in `docs/ASSET_MANIFEST.md`.

## Platform references
- https://create.roblox.com/docs/animation/editor
- https://create.roblox.com/docs/tutorials/use-case-tutorials/animation/create-an-animation
- https://create.roblox.com/docs/reference/engine/classes/Animator
- https://create.roblox.com/docs/reference/engine/classes/Tool
- https://create.roblox.com/docs/reference/engine/classes/Trail
