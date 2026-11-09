# KAGEBOUND — Mythic Mask Combat v0.2 | Studio test

**Authority:** docs/GAME_DESIGN.md, ART-002 / ART-003, docs/VFX_SPEC.md (FX-005/006/007).
**Verification:** scripts committed on main; multiplayer Roblox Studio execution NOT YET performed.

## Mask rules

| Mask | Active | Key / UI | Cooldown | Server behavior |
| --- | --- | --- | --- | --- |
| Kitsune | Fox illusion decoy | G / Y / MASK | 14 sec | Non-damaging 3.5 sec decoy; nearby Lantern Yokai can select the clone as a target, waste one telegraphed strike and destroy it |
| Oni | Crimson close-range shockwave | G / Y / MASK | 16 sec | 12-stud radius, 15 server damage and bounded knockback to eligible players; also staggers/damages eligible Lantern Yokai through the shared server resolver; cannot harm protected Kage Dojo players |
| Tengu | Directional aerial wind burst | G / Y / MASK | 12 sec | Self-propelled wind dash / vertical lift, server-owned impulse |

Selection by compact HUD buttons or Z/X cycling is **restricted to inside Kage Dojo** and **not permitted during a Shadow Duel**. The server validates selected masks; client attributes and HUD cannot authorize a cast.

## Studio functional acceptance
1. Pull latest GitHub main and run `rojo serve default.project.json`; reconnect and start two Studio clients.
2. In Kage Dojo, verify the mask toolbar shows Kitsune, Oni and Tengu; click each. Ensure `KageboundMask` changes only after server approval.
3. Travel outside the Dojo safe zone and select Kitsune beforehand. Press G: one non-damaging decoy; spam G: no extra decoys during 14-second cooldown.
4. Return to Kage Dojo; select Oni, travel to Moonfall. Stand within 12 studs of another player and press G. Server must validate distance, line of sight, duel membership and that both players are outside the safe zone. The other player should take 15 damage once and receive knockback. A wall or protective hub should block damage.
5. Select Tengu before departure; press G away from Dojo. Observe server-validated forward/upward impulse and the local cyan/violet VFX. Spam remote events: no cooldown bypass.
6. Stand inside Kage Dojo: Oni should never damage other players. Tengu movement may remain available; do not let movement push non-participants.
7. Enter opt-in Shadow Duel and verify mask selection is locked; casting is blocked during Countdown/Intermission and permitted during Active (with mask already equipped). Other players must not be damaged through the duel boundary.
8. Compare visual effects to approved ART-002/003 and the new draft VFX boards, but do **not** confuse presentation boards with transparent game sprites or finished particle effects.
9. Run `tests/MaskRules.studio.lua` in the Studio server command bar. This only tests static balance policy and does not replace two-client validation.

## Known limitations
- Oni now checks eligible Lantern Yokai models as well as players; test 15-damage PvE hit credit, barriers/LOS, and ensure duel participants cannot farm world enemies.
- Kitsune clone can now draw Lantern Yokai aggro within 35 studs and absorb one attack. It remains a non-combat model with a 3.5s lifetime and no player damage; test decoy-priority behavior, region leash, cleanup and 2-player duels.
- Game-pad/touch mask selection needs QA; ability input is unified G / controller Y / touch MASK.
- VFX are low-cost temporary neon geometry, *not* the final high-impact sprites/animation sequences.
- No final mask meshes, SFX, true rig animations, or gameplay-tested camera feedback yet.
- Cooldowns are managed server-side. Studio latency, spawn immunity and remote exploit scenarios still require validation.

## Additional PvE mask tests (server-side)
1. Select Oni at Kage Dojo, then attack a Lantern Yokai at Moonfall with G. Confirm that the enemy receives exactly 15 health damage through `EnemyDamage.lua` and stagger, and rewards the last validated player if it dies. No hits through solid walls or from out-of-range calls.
2. As a Shadow Duel participant, attempt to cast Oni at a nearby world enemy: the server must reject it even while combat is Active.
3. Select Kitsune, cast G at Moonfall within 35 studs of a Yokai; the enemy must switch to the decoy, telegraph, consume/destroy it without damaging a player, and resume a normal target afterward.
4. Verify no bonus mastery/Spirit Shards for a nonlethal decoy, no arbitrary client-supplied damage or cooldown, and no permanent dead AI state after a target vanishes.
5. Run `tests/EnemyDamage.studio.lua` in Studio Server Command Bar; it covers policy checks but cannot replace these 2-player tests.
