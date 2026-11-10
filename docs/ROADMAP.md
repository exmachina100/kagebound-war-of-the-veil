# Roadmap — KAGEBOUND: WAR OF THE VEIL

## Primary experience: Grand World
KAGEBOUND is a large-scale connected Japanese mythological adventure, not principally a small duel arena. Read [WORLD_VISION.md](WORLD_VISION.md) and test the [Grand World blockout](WORLD_TESTING.md). Five connected districts + exploration quest are committed but not Studio-validated. Ranked Shadow Duel/Clan Clash remain optional world activities; future Yokai Hunt, world bosses, PvP safety zones, traversal, collection, economy and dynamic regional Veilfall form the primary adventure loop. World issues #14–#18 track production.

## Design pillars
Original Japanese fantasy; competitive third-person melee; responsive traversal and tactical parries; masks alter tactics rather than simply increasing damage; map transformations called **Veilfall**; no pay-to-win.

## Original MVP 0.1 target
- 4 styles: Shinobi, Ronin, Onmyoji, Oni Disciple
- 8 weapons: Katana, Nodachi, Tanto, Naginata, Yari, Kanabo, Kusarigama, Yumi
- 3 mythic masks: Kitsune (illusions), Oni (knockback), Tengu (wind)
- 2 arenas; 2 PvP modes; 1 dojo lobby
- Join, choose loadout, fight, Veilfall, result screen, dojo return

## Delivery gates
### P0 — Foundation [GitHub files committed; Studio sync pending]
Source folders, Rojo map, art catalog, original design notes, VFX requirements. The original 338-line game concept is now archived in [GAME_DESIGN_ORIGINAL_338.md](GAME_DESIGN_ORIGINAL_338.md). Verify Rojo connection and startup output.

### P1 — Combat vertical slice [server-timed sweeps, stamina, mobile/controller input, equipped-weapon enforcement, Veilblade grip poses and blade Trail committed; Studio playtest pending]
Moonfall Bamboo greybox (server generated), 2 players, Shinobi, 3-hit katana combo, heavy attack, perfect parry, directional dash, round reset. Server validates hit detection, damage and cooldowns. No repeated hit registration.

### P2 — Mythic + Veilfall [Kitsune decoy, Oni knockback and Tengu wind prototype, dojo-only loadout switching and regional Veilfall scripted; Studio playtest pending]
Kitsune clone; Oni burst; Tengu wind. Server-timed Veilfall with preview warning, added traversal routes and consistent collision for all clients.

### P3 — Match loop [Shadow Duel + Veilfall + 4 warrior starter loadouts coded; Studio test and Clan Clash pending]
Shadow Duel 1v1, Clan Clash prototype, loadouts, scoring, results, and automatic dojo return.

### P4 — Content MVP [optional animation catalog and visual fallback coded; actual model/rig/animation assets pending]
Four styles, eight weapons, three masks, two finished arenas, dojo, weapon sounds, animations, gameplay VFX and HUD. Validate mobile and desktop graphics budgets.

### P5 — Progression / collection [session-only Spirit Shards and weapon mastery prototype committed; persistence and economy pending]
Mastery XP, cosmetics, currencies, shop, inventory, secure persistence, trading constraints and duplication protection. All gameplay powers earnable through play.

### P6 — Alpha / launch [not started]
Network/latency tests, accessibility, moderation and security, multiplayer soak, matchmaking, onboarding and analytics.

## Current 0.3 acceptance gate
Run [COMBAT_03_TEST.md](COMBAT_03_TEST.md) with two Studio clients. Verify world PvP safety, delayed katana sweeps, once-per-swing registration, stamina, guardbreak, double jump, Veilblade tool and regional Grand World Veilfall. The provided scripts are untested here; authored animations, final models, PvE and match state are still pending.

## First world PvE encounter (code committed; Studio test pending)
Three original Lantern Yokai are scripted in Moonfall Bamboo, with server-owned health, proximity pursuit, telegraphed attacks, parry handling, 14s respawn, and damage from the same swept katana hitboxes as PvP. These are **prototype enemies**, not a complete Yokai Hunt mode, boss AI, loot loop, or finished character assets. See [YOKAI_01_TEST.md](YOKAI_01_TEST.md) and issue #10.

## Session rewards and avatar visual pass (code committed, Studio test pending)
Original server-only RewardService and RewardPolicy award 25 Spirit Shards for first Whispers completion, or 6 Spirit Shards and 4 Veilblade Mastery on a Lantern Yokai defeat. Enemy navigation now requests bounded PathfindingService routes around collidable world obstacles (Studio QA pending). Encounter tokens reject duplicate awards; no DataStore, commerce, inventory, trade or permanent save exists. ShinobiAppearance.server.lua adds a cosmetic no-collision ART-002 placeholder costume. See [PROGRESSION_01_TEST.md](PROGRESSION_01_TEST.md) and issue #11.

## External system references
Reviewed three user-provided Roblox projects; architectural findings and safety decisions in [REFERENCE_REPOSITORY_REVIEW.md](REFERENCE_REPOSITORY_REVIEW.md). KAGEBOUND implementations are original. Do not import copyrighted One Piece assets or scripts. Follow issue #9 (stamina security), #10 (Yokai AI), #11 (progression/shop/trading), #12 (animation marker hitboxes) and #13 (cross-platform controls).

## Mandatory visual production gate
Before refining any greybox or placeholder FX, inspect the approved concept images listed in [ART_DIRECTION.md](ART_DIRECTION.md). Both gameplay and visual gates must pass; do not mark a placeholder as final art. The four approved reference PNGs ART-001..004 are uploaded and recorded in ASSET_MANIFEST.md. Additional asset boards remain pending.

## Safe Kage Dojo practice lane (code committed; Studio QA pending)
Kage Dojo now contains 3 ceremonial practice posts within the world-defined training circle. Sword attacks are allowed here **only against practice targets**; SafeHub player damage stays disabled and no rewards are granted. Posts display health/hit counts and reset on defeat. See [DOJO_TRAINING_TEST.md](DOJO_TRAINING_TEST.md) before signing off gameplay safety.

## Animation integration v0.4
`src/shared/AnimationCatalog.lua` holds empty slots for *owned* Shinobi animation IDs. `src/client/ShinobiAnimation.client.lua` plays authored tracks when available or uses temporary local Tool.Grip poses; the blade Trail follows only a server-accepted swing. **No animation assets have been published or verified**. Source-of-truth production guide: [SHINOBI_ANIMATION_PIPELINE.md](SHINOBI_ANIMATION_PIPELINE.md). Attacks now require Veilblade equipped and keep damage authority on the server. Studio QA remains open in issue #21.

## Current verification and production tasks
- [Issue #19](https://github.com/exmachina100/kagebound-war-of-the-veil/issues/19): 2-player reward/appearance QA.
- [Issue #20](https://github.com/exmachina100/kagebound-war-of-the-veil/issues/20): durable save/recovery after session reward prototype.
- [Issue #21](https://github.com/exmachina100/kagebound-war-of-the-veil/issues/21): final Shinobi/Veilblade rig and authored animations matching ART-001/002/003.
- `src/server/StudioSmoke.server.lua` reports basic Rojo/runtime object presence in Studio only; it is **not a full gameplay or CI test**.

## Future updates
Wall run and grapple, Yokai Hunt PvE, Spirit Run parkour, synchronized spirit fusion, sword clashes, clan rivalries and seasonal invasions.

**Acceptance for first playable:** Two players complete a complete 1v1 round, with sword combat, defensive timing, mythic ability and Veilfall; return to dojo without manual intervention.

## Asset pipeline milestone — Veilblade v01 (concept completed / draft mesh, Roblox QA pending)
The mandatory [asset production workflow](ASSET_CREATION_WORKFLOW.md), [style guide](STYLE_GUIDE.md) and [active queue](ASSET_PRODUCTION_QUEUE.md) are committed. First real artwork batch uses approved ART-003 as OpenArt image-to-image reference: the Veilblade 2K turnaround is generated. A separate original 516-triangle parametric GLB/OBJ mesh draft and source script were exported in the conversation as a handoff ZIP, **not yet uploaded to GitHub or Roblox Studio**. Do not claim screenshot parity or replace the live procedural Tool before issue [#24](https://github.com/exmachina100/kagebound-war-of-the-veil/issues/24) passes.

## Shadow Duel multiplayer QA
The code in `src/server/ShadowDuel.server.lua`, `DuelService.lua`, `DuelRules.lua` and `src/client/ShadowDuelHUD.client.lua` provides an opt-in first-to-three / best-of-five 1v1 arena prototype. The dedicated [Studio test](SHADOW_DUEL_TEST.md) is required before marking P3 complete. Current prototype remains separate from final arena art and round-triggered Veilfall.

## Shadow Duel spectral route transition (server code committed; Studio QA pending)
The optional 1v1 Shadow Duel now schedules a predictable round-local Veilfall with 6s opening and closing warning, server-owned spectral platforms and cleanup on KO/forfeit/timeouts. It does not change Grand World RegionalVeilfall. Run [SHADOW_DUEL_TEST.md](SHADOW_DUEL_TEST.md) and [tests/ShadowDuelVeilfall.studio.lua](../tests/ShadowDuelVeilfall.studio.lua); production low-poly route art must follow [ASSET_CREATION_WORKFLOW.md](ASSET_CREATION_WORKFLOW.md). No live Studio execution claimed.

## Three-mask milestone and cinematic VFX handoff (code committed; Studio QA pending)
`src/shared/MaskRules.lua`, `src/server/MaskAbilities.server.lua`, `src/client/MaskHUD.client.lua` and `src/client/MaskVFX.client.lua` implement original Oni/Tengu skills and server-restricted loadout switching, while existing Kitsune checks the selected mask. Run [MYTHIC_MASKS_TEST.md](MYTHIC_MASKS_TEST.md) before P2 signoff. Four new **GPT-generated VFX concept boards** have been packed for artist handoff (conversation archive, not GitHub images yet). See [VFX_CONCEPT_HANDOFF.md](VFX_CONCEPT_HANDOFF.md); they're not finished transparent emitter textures, animations, or game-ready effects.

## Current active milestone — PvE mask integration and class VFX v0.5
Server melee and Oni mask damage now share `src/server/EnemyDamage.lua` with centralized health, last-hitter credit and stagger validation. Kitsune decoys now divert Lantern Yokai and can absorb one enemy swing. `src/shared/VFXProfiles.lua` and `src/client/VFXFactory.lua` support original visual identities for Shinobi, Ronin, Onmyoji and Oni Disciple, grounded in the eight uploaded GitHub concept sheets. Seven transparent 4×4 VFX PNG texture **prototypes** were generated in the current conversation; **not yet on GitHub** and no real Roblox image IDs yet. `VFXSpriteEmitter.lua` uses optional particle textures after real upload, keeping geometric fallback. See [CLASS_VFX_PRODUCTION.md](CLASS_VFX_PRODUCTION.md), [VFX_FLIPBOOK_IMPORT.md](VFX_FLIPBOOK_IMPORT.md) and [MYTHIC_MASKS_TEST.md](MYTHIC_MASKS_TEST.md). Studio functional and visual QA remains outstanding.

## Persistence P5 foundation (adapter code only — deliberately disabled)
`src/shared/ProfileSchema.lua` defines replay-safe quest/Yokai receipt semantics; `src/server/ProfileStore.lua` is a server-side `UpdateAsync` adapter behind `src/shared/PersistenceConfig.lua` (`Enabled=false`). **It is not connected to the live session-only `RewardService`**. Run `tests/ProfileSchema.studio.lua` and `tests/ProfileStore.studio.lua` only in a disposable Studio test. Read [PERSISTENCE_GATE.md](PERSISTENCE_GATE.md) before enabling in a private test place, and keep issue #20 open for true server-concurrency/save/load work.

## Source-controlled 3D asset exports (2026-11-10)
The asset workflow and style rules are now linked to **two actual GitHub OBJ/MTL exports**, not just concept sheets or an offline handoff ZIP: a 1220-triangle ART-003 Veilblade v02 and a 296-triangle ART-004 Dojo practice-post v01. They are reproducible using `tools/generate_kagebound_obj.js`, and a static geometry/material validation pass was recorded. Cosmetic template integration to `ServerStorage/KageboundArt` has been added with safe procedural fallback. See [ASSET_IMPORT_HANDOFF_v01.md](ASSET_IMPORT_HANDOFF_v01.md). Live Studio import, MeshId registration, visual parity and gameplay QA remain pending. This milestone does not imply full G6/G7 completion.

## Four playable warrior loadouts — code committed, Roblox QA pending
All four original player styles now have a **server-authoritative starter ability** with dojo-only selection: Shinobi Shadow Slip, Ronin Moon Guard, Onmyoji Ofuda Seal and Oni Disciple Iron Resolve. This is ONE distinct starter move per style, **not** all six proposed VFX-board moves or full final weapons. Basic WalkSpeed reflects style; main weapon and masks remain independently selectable. Class cooldowns, PvP matching, hub safety, NPC conditions, guarded hit damage and class VFX are server-controlled. See [FOUR_WARRIORS_TEST.md](FOUR_WARRIORS_TEST.md), `src/shared/ClassRules.lua`, `src/server/ClassService.lua`, `src/client/ClassHUD.client.lua`; issue #29. Actual Studio gameplay, authored visual assets, class-specific animations and competitive balancing are pending.
