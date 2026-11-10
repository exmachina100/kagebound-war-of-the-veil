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

### P3 — Match loop [Shadow Duel + Veilfall, 2v2 Clan Clash, four starter class loadouts coded; Studio multiplayer QA pending]
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

## Clan Clash 2v2 — team arena prototype (unverified)
`src/shared/ClanRules.lua`, `src/server/ClanClash.server.lua`, `src/client/ClanClashHUD.client.lua` now implement an isolated **2v2**, first-to-three/best-of-five team match with server-controlled scores, intermission, 80-second rounds, forfeit/disconnect cleanup and mid-round Veilfall warnings/collision. `DuelService.lua` has backward-compatible team membership and bans friendly fire; `QueueRegistry.lua` prevents simultaneous Shadow Duel/Clan queue participation. Four-player Studio QA and team spectator/skill isolation are pending in [CLAN_CLASH_TEST.md](CLAN_CLASH_TEST.md), issue [#30](https://github.com/exmachina100/kagebound-war-of-the-veil/issues/30). True clan membership, parties, scalable 3v3–5v5, ranked matchmaking and other content remain open.

## Weapon arsenal issue #31 — policy foundation (2026-11-10)
Eight canonical archetypes and provisional profiles now exist in `src/shared/WeaponRules.lua` (commit `91fbe974775f933ea5740b222072963c483a72c9`); the Studio-only policy contract is `tests/WeaponRules.studio.lua` (commit `c493d58b7314c17c073cb2dcbb0d0571da474464`). Only Katana is flagged implemented. Nodachi and Tanto numbers are **design targets, not live attack mechanics**; all other archetypes are nonselectable placeholders. Existing Veilblade combat remains unchanged. No Roblox Studio test or source CI run was executed for these commits. Next: implement server-owned dojo weapon selection and actual distinct Nodachi/Tanto strikes through the existing Combat damage pipeline, then Studio PvP/Clan/PvE QA. Do not expose nonimplemented weapons as playable.

## Weapon selection server gate — 2026-11-10
Commit `84694df2f1185150aaf40691086202110e29282b` adds `src/server/WeaponSelection.server.lua`: a server-side Kage Dojo proximity/health/match-phase/rate-limit check for `KageboundWeapon` Select requests. Only `WeaponRules.CanSelect`-enabled weapons are accepted; currently **Katana only**. The replicated selection attribute is a display mirror, not a combat-authoritative weapon source. Existing Veilblade remains the sole attack tool and fallback; Nodachi/Tanto are NOT playable. Source was committed, but Luau execution, remote spoofing, lifecycle and multiplayer Studio QA have NOT been run. Next: integrate a server-owned weapon equip/attack authority and add distinct Nodachi/Tanto moves without trusting client attributes.

## Weapon selection queue isolation — 2026-11-10
Commit `fe217cb864f9741ad71b6d86588196772bb7843c` adds `QueueRegistry.Mode(player)` to the server's dojo weapon-selection gate. A player queued for either Shadow Duel or Clan Clash can no longer change weapons through `KageboundWeapon` even before match participation begins. Existing in-match `DuelService.IsParticipant` check remains. This is a targeted source-level security change, **not** a complete server-owned weapon inventory or Nodachi/Tanto implementation. Studio QA needed: while queued in each mode, fire `Select/Katana` and confirm no `Selected` response; leave queue and confirm dojo selection resumes; verify disconnect cleanup, match entry, and that nonimplemented weapon names are still rejected. No Studio execution claimed.

## Server-only weapon authority — 2026-11-10
Commits `a295f8b3c9fabaa2f946e4841049a627bcc9671f`, `bceafec287a8654abd7aa2889e43eb026364bf69`, `6a2bee6632321919cc0bdcadc2493918b0085fee` add `WeaponAuthority.lua`, route dojo selection through a private server table and require that authority plus equipped Veilblade for sword attacks. The `KageboundPrimaryWeapon` attribute remains display-only; changing it on the client must not grant damage rights. **Katana is still the only enabled archetype**; Nodachi/Tanto profiles remain design-only. This is source integration, not Roblox Studio validation. QA gate: spawn/respawn, spoof replicated weapon attribute, forged Select calls, unequip, queued/in-match selection, Shadow Duel/Clan friendly fire and NPC/training hits. Note: `WeaponAuthority.Reset` is currently called by weapon selection player registration, so test script initialization ordering and ensure no unintended resets. No Studio tests or CI were run in this pass.

## Weapon attack-profile contracts — 2026-11-10
Commits `b0a235e41e6be4aeafd5f319a9eac69fc73d262f` (Studio policy test), `dfa875a1fe0ff1f9c289bc1128b8ee353471a608` (`WeaponAttackRules.lua`), and `e2fb25c719d2563a70249158672ed85e563b81ed` (Katana Combat refactor) define distinct Nodachi/Tanto reach, damage, windup, cooldown, stamina and guard-break design profiles. The live combat path resolves Katana damage/range/timeline/guard-break from the shared module while preserving existing Katana values. **Nodachi/Tanto are still disabled** in `WeaponRules.CanSelect`, not equipped and not live attacks. `tests/WeaponAttackRules.studio.lua` must run in Studio; no Studio test execution or CI validation is claimed. Next safe step: server-created named tools, server-only ownership verification, atomic equip on dojo selection, profile-driven combat and PvP/PvE regression. Avoid touching separate art-agent assets.

## Nodachi/Tanto source integration — 2026-11-10 (issue #31)
Weapon equipment and attack path now accepts three swords in source: Katana, Nodachi and Tanto. Commits: forged-tool test `b408c80`, private issued-instance authority `ec6edaa`, Veilblade registration `c169cf3`, server equipment prototype and bindable `01e97de`, active equipped-weapon lookup `d5a55c0`, profile-based combat `fb0d368`, Tanto cooldown fix `b7692d2`, dojo equipment swap/rollback `9b2d6b2`, enabling two profiles `fbe5f61`, selection policy test `58b5b78`, forged-tool test refinement `fcc6bd9`. Three source-selectable sword archetypes are **not equivalent to Studio-verified gameplay**. Distinct procedural visual proxies are not approved final asset models. The source-only test files are not executed by GitHub CI. Studio QA: fresh spawn and respawn; server-issued tool registration; dojo swaps, unequip and equip; weapon spoofing; selection during windup and queues; 2-player parry/guard break; 4-player Clan friendly fire; Yokai and training dummy hitboxes; mobile input and VFX; disconnect; invalid remote payloads. Keep persistence disabled. Next: run Studio QA and fix failures before declaring milestone complete; then implement Naginata/Yari.

## Original character locomotion side workstream — 2026-11-10
Research and staged movement/animation design saved in `docs/CHARACTER_MOVEMENT_RESEARCH_AND_PLAN.md` (`36fa5299bef128a02311f04cf62497799960284d`). It evaluates licensed/open-source Roblox movement patterns, but imports **no** third-party scripts, game files or copyrighted anime animation assets. Pure `LocomotionRules.lua` (`670f169d72521f652bb22f6a8ac37fa3cf1145ea`) and Studio-only policy assertions (`564a92108d0d5e0459cb86ccfa2d88bb06961c81`) establish original movement state targets; new traversal abilities are explicitly disabled. Starter weapon registration race fix (`83c70497b1e0f6a6769c723dc6621beca74517b3`) prevents late weapon-selection script startup from clearing an already-issued tool. No Studio or CI execution claimed. Primary gameplay issue #31 remains open; next: live three-sword Studio QA, then server-authoritative sprint and original R15 animation layering.

## R15 locomotion animation director — 2026-11-10
`src/shared/LocomotionAnimationCatalog.lua` (`52fabe6ba5e8c5c773f9589b6a6179585fa762ae`) adds only empty KAGEBOUND-owned animation slots, distinct from the existing combat `AnimationCatalog.lua` API. `src/client/LocomotionAnimation.client.lua` (`562ac715e8a0c1c80ed86dc76a900dd7b0349e75`) tracks Humanoid movement states and optionally loads, caches, crossfades and cleans up R15 movement clips when verified assets become available; until then Roblox default Animate remains. `tests/LocomotionAnimationCatalog.studio.lua` (`512a084bc4672db6f0fde629d4fea9fa3cb7827e`) adds Studio-only empty-slot/fallback assertions. This is not a completed custom animation pack, server sprint mechanic or Studio-tested character movement. Next: author and upload original clips, verify priority conflicts with default Animate and combat overlays, then build sprint server authority and touch/gamepad inputs. Preserve active three-sword multiplayer QA as primary gameplay gate.

## Main combat continuation — 2026-11-10
After the locomotion side task, main gameplay resumed. `c934ffc5da4e7909380b1161ff61e660d2319f30` stages the next sword tool before retiring the previous tool, and guards deferred auto-equip against stale selections. `eba00ebc16adfd2b7073a4dc83e67fc94fb33776` aligns local Light/Heavy input cadence to server weapon profiles (the server remains authoritative). Naginata/Yari data profiles (`9aed133da6cf5dafb31c15f15d6c294cf0d5d481`) and polearm reach/narrow thrust attack-profile support (`66c2457e7822d545a8e8df47ceffa9003760133b`) are staged behind `implemented=false`; Studio-only contracts updated (`e8c4132b9f75cac768dccfdf7861fc2e112541d9`). **Neither polearm is playable**; no rigged art or weapon animations are imported. Critical remaining gates: Studio multiplayer verification of sword equip/respawn/rollbacks and hitbox behavior, server-authoritative polearm equip and distinct animation/attack paths, then anti-exploit/latency/mobile QA. No Luau Studio test or CI success is claimed for these commits.

## Independent animation handoff and melee authority — 2026-11-10
Animation production brief assigned in `docs/ANIMATION_AGENT_STATUS.md` (`d1c7406ed6886f95c198d7fab5195ea865ddfaaf`). A separate scheduled automation was attempted but rejected because the account has five of five available active tasks; **no animation automation is running**. Do not silently repurpose another agent. Main gameplay changes: serialized weapon-selection swaps (`82bc89f12b18bd126cd033df2521ce249f7d42fa`); delayed sword windup and active sweeps validate original server-issued tool identity (`05a8db0bd9c33f43cca4aeb723529aa22450af2f`, `e90522166d1a1ede1ed99f9cd6753f0ff3331567`); Studio-only forged-equipment assertion expanded (`62e3f9138a763a60fc90327f1253a8daf58a6575`). Roblox Studio tests and GitHub CI were not run in this session. Next: verify sword selection, spawn/respawn, attack cancellation, parry and Clan Clash in Studio before enabling staged polearms.

## Five-weapon playtest milestone — 2026-11-10
Main gameplay commits: `b9cf4f4910505e6722fa536bf138bbfecb31faa9` adds original procedural Naginata/Yari tool visuals using server-created welded parts, no imported assets; `8a6e589993abb6dc106ea96681ef2ba3a17a8c60` rejects disabled archetypes in the server equipment factory; `b37b6247d7fa4966cebb4b76d7e3b782bf7ecb03` enables Naginata and Yari as **unverified playtest** selections, alongside Katana/Nodachi/Tanto; `3696b98039150b60663bbc29dc73991502f62ad3` and `280a94bf2b9df9b8e03082fad2bca856965738a0` update Studio-only tests. Remaining archetypes Kanabo/Kusarigama/Yumi remain disabled. Acceptance still requires Roblox Studio multiplayer tests of polearm reach, server damage, parry/guard break, selection/respawn, tool handoff, animation readability and 30/60 FPS/mobile controls. Procedural polearms are blockouts; do not represent as finished art or QA-complete.

## Grand World P1 exploration continuation — 2026-11-10
Re-centered the main build on the **Grand World** primary adventure loop (see `WORLD_VISION.md`), rather than treating the optional duels as the entire game. `src/shared/RegionRules.lua` (`265f5f1c8c7b27796805ec60abd075b6592077df`) resolves five world regions and graph adjacency. `src/server/RegionDiscovery.server.lua` (`eff13f6f00810866df76734851f5557343566cca`) samples player positions every 0.5 seconds and tracks visited regions server-side in memory. `src/client/RegionHUD.client.lua` (`ee596b5436a28399dab271bdf75a22a07383e6da`) shows the current district and session discovery count. `tests/RegionRules.studio.lua` (`570ecb515dc5d5b20250ccc2c4de6e93877ff8ed`) specifies region center and route contracts. **No permanent save, rewards, NPC dialogue, map fast travel, or completed World P1 acceptance is claimed.** Next World P1: three distinct NPCs, server-owned quest offers/accept/turn-in, map waypoints, and named Yokai encounter; Studio multiplayer validation and world performance remain gates.

## Grand World P1 — bundled quest-loop slice (2026-11-10)
Single multi-file commit adds a server-owned three-guide travel quest: NPC proximity prompts start one active journey at a time; the server checks actual player region to complete it, tracks completion per NPC once per session, publishes display-only attributes, and clears the destination. No currency rewards or persistence are claimed. Includes guide policy tests and quest HUD messaging. Acceptance: Studio two-client interaction, cross-region walking, no duplicate completion, respawn handling and HUD update. Next: named Yokai objective, quest reward receipts and NPC dialogue UI. Continue weapon/asset pairing in parallel.
