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
Source folders, Rojo map, art catalog, original design notes, VFX requirements. Verify Rojo connection and startup output.

### P1 — Combat vertical slice [server-timed sweeps, stamina, touch/controller input, Veilblade blockout committed; Studio playtest pending]
Moonfall Bamboo greybox (server generated), 2 players, Shinobi, 3-hit katana combo, heavy attack, perfect parry, directional dash, round reset. Server validates hit detection, damage and cooldowns. No repeated hit registration.

### P2 — Mythic + Veilfall [regional Moonfall bridge cycle and Kitsune decoy prototype committed; Studio playtest pending]
Kitsune clone; Oni burst; Tengu wind. Server-timed Veilfall with preview warning, added traversal routes and consistent collision for all clients.

### P3 — Match loop [not started]
Shadow Duel 1v1, Clan Clash prototype, loadouts, scoring, results, and automatic dojo return.

### P4 — Content MVP [not started]
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
Original server-only RewardService and RewardPolicy award 25 Spirit Shards for first Whispers completion, or 6 Spirit Shards and 4 Veilblade Mastery on a Lantern Yokai defeat. Encounter tokens reject duplicate awards; no DataStore, commerce, inventory, trade or permanent save exists. ShinobiAppearance.server.lua adds a cosmetic no-collision ART-002 placeholder costume. See [PROGRESSION_01_TEST.md](PROGRESSION_01_TEST.md) and issue #11.

## External system references
Reviewed three user-provided Roblox projects; architectural findings and safety decisions in [REFERENCE_REPOSITORY_REVIEW.md](REFERENCE_REPOSITORY_REVIEW.md). KAGEBOUND implementations are original. Do not import copyrighted One Piece assets or scripts. Follow issue #9 (stamina security), #10 (Yokai AI), #11 (progression/shop/trading), #12 (animation marker hitboxes) and #13 (cross-platform controls).

## Mandatory visual production gate
Before refining any greybox or placeholder FX, inspect the approved concept images listed in [ART_DIRECTION.md](ART_DIRECTION.md). Both gameplay and visual gates must pass; do not mark a placeholder as final art. The four approved reference PNGs ART-001..004 are uploaded and recorded in ASSET_MANIFEST.md. Additional asset boards remain pending.

## Current verification and production tasks
- [Issue #19](https://github.com/exmachina100/kagebound-war-of-the-veil/issues/19): 2-player reward/appearance QA.
- [Issue #20](https://github.com/exmachina100/kagebound-war-of-the-veil/issues/20): durable save/recovery after session reward prototype.
- [Issue #21](https://github.com/exmachina100/kagebound-war-of-the-veil/issues/21): final Shinobi/Veilblade rig and authored animations matching ART-001/002/003.
- `src/server/StudioSmoke.server.lua` reports basic Rojo/runtime object presence in Studio only; it is **not a full gameplay or CI test**.

## Future updates
Wall run and grapple, Yokai Hunt PvE, Spirit Run parkour, synchronized spirit fusion, sword clashes, clan rivalries and seasonal invasions.

**Acceptance for first playable:** Two players complete a complete 1v1 round, with sword combat, defensive timing, mythic ability and Veilfall; return to dojo without manual intervention.
