# KAGEBOUND — Four Warrior Loadouts v0.1 / Roblox Studio Test

**Design authority:** `GAME_DESIGN.md`, `GAME_DESIGN_ORIGINAL_338.md`, `WORLD_VISION.md`, `CLASS_VFX_PRODUCTION.md`, ART-001/002/003 and uploaded class VFX concept sheets. This is a playable **starter ability per class**, not all six proposed ultimate/move concepts.

**Code status:** committed on GitHub main; actual Roblox Studio multiplayer and performance validation **NOT PERFORMED** by the assistant.

## Player controls
- **Choose a style:** in Kage Dojo, click Shinobi / Ronin / Onmyoji / Oni Disciple in the small right-side toolbar. Class switching is denied outside a radius-260 dojo selection area and while in any Shadow Duel phase.
- **Class active:** H on keyboard; controller L1; touch button STYLE. The ability is separate from G/Y MASK, Mouse1/R sword and Q dash.
- **Weapon:** Veilblade remains the shared temporary weapon for all four; class never permanently locks a main weapon. Future authored class-specific weapons/animations need separate Studio imports.

| Class | Passive prototype | First server-owned active | Cooldown | Target / effect |
| --- | --- | --- | --- | --- |
| Shinobi | WalkSpeed 18 | Shadow Slip | 11 sec | Directional short momentum burst 78 studs/sec; no invulnerability |
| Ronin | WalkSpeed 16 | Moon Guard | 12 sec | 0.7 sec defensive window, block one frontal light/Yokai/Oni-mask strike; heavy bypasses guard |
| Onmyoji | WalkSpeed 16 | Ofuda Seal | 15 sec | 10-stud radius seal 10 studs ahead; 1.2 sec WalkSpeed 8 slow on eligible players, 0.6-sec Yokai stagger; no damage |
| Oni Disciple | WalkSpeed 14 | Iron Resolve | 15 sec | 2.1 sec 50% mitigation of incoming eligible server hits; no invulnerability |

Ability balance is provisional, fixed in `src/shared/ClassRules.lua` and enforced in `src/server/ClassService.lua`. VFX and UI are cosmetic. No client-provided target, damage, velocity or cooldown is accepted.

## Studio game loop
1. Pull latest GitHub main and reconnect `rojo serve default.project.json`. Start a **two-player** Play test with Output open.
2. Explorer confirms `ReplicatedStorage/KageboundShared/ClassRules`, `ReplicatedStorage/KageboundClass`, `ServerScriptService/KageboundServer/ClassService`, `ClassLoadout`, `StarterPlayerScripts/KageboundClient/ClassHUD` and `ClassVFX`.
3. At Kage Dojo (near 0,0,0), select each class. Its server-owned `KageboundWarriorStyle` attribute should match; Humanoid.WalkSpeed should update to 18 / 16 / 16 / 14 as appropriate.
4. Select Ronin, travel to Moonfall. Have player B swing lightly toward the facing Ronin while H is active: the first eligible hit is blocked; repeating outside the window must cause ordinary damage. **Heavy attack must bypass Moon Guard**, as it does core parry.
5. Select Onmyoji at Dojo, return to Moonfall; cast H near an opponent. The server should slow an eligible player briefly (not damage them), and if a Lantern Yokai is inside the valid seal volume it should stagger. Cast behind a solid wall: the target must not be controlled.
6. Select Oni Disciple at Dojo; cast H while being hit by another player and by a Lantern Yokai. Incoming damage is reduced approximately 50%, but not zero. Verify safe-zone PvP is still impossible.
7. Select Shinobi; H gives a quick directional movement impulse (not teleport through walls), followed by 11-second server cooldown. Try while rooted/staggered/playing other actions and look for movement exploits.
8. Enter **Shadow Duel**. While Preparing, Countdown or Intermission, style casts must be blocked. While Active, class cast is allowed. Class switching must be denied for the whole match. Confirm that no player outside that match can be slowed, damaged or guarded by the duelists.
9. Try class selection at Moonfall / Shogun city / in the air well above the Dojo: it must be rejected. Client attributes or remote payloads must not grant a style or change damage.
10. Spam Cast and Select remotes in a local adversarial test. A cooldown must remain server-controlled; in-place rapid re-selection must not reset it. Respawning should restore correct movement and clear temporary defense statuses.
11. Switch from Shinobi to another style at Dojo. The procedural Shinobi-only fox mask/armor should disappear; other styles still need **original class-specific production meshes** from the asset workstream.
12. Review the four distinct class FX against `assets/concept-sheets/clan-vfx-v01/` in Studio. Press **P** to open the separate Studio-only VFX concept preview for more detailed art evaluation.

## Studio contract scripts
- `tests/ClassRules.studio.lua` (server Command Bar) — shared policy validation.
- `tests/ClassService.studio.lua` (server Command Bar) — four class selection, rejection outside dojo, locking in a duel; runs in a **disposable** test session because it teleports the first player and momentarily assigns duel membership.
- `tests/EnemyDamage.studio.lua`, `tests/MaskRules.studio.lua` and `tests/CombatRules.studio.lua` — related combat regression contracts.
- Studio-only `src/server/StudioSmoke.server.lua` reports the class modules/remote. Passing static/smoke checks is **not proof** of actual multiplayer balance.

## Limitations / remaining work
- Class selector shows all four as selectable for this free prototype; future unlock progression, owned costumes and persistent class preferences are not implemented.
- Only **one starter active** per style is implemented, not the six named VFX board moves, ultimates, passives, advanced combo movesets or their true rig animations.
- Class models for Ronin, Onmyoji and Oni Disciple are not imported. Existing ART-002 Shinobi appearance is a procedural placeholder.
- The current slow affects `Humanoid.WalkSpeed` and restores it after a timer; network latency, competing speed buffs, server-owned root / movement and race conditions still require detailed testing.
- No Roblox Studio tests, device-performance tests or CI execution were performed during this implementation. The code must pass actual two-client testing before marking the milestone validated.
