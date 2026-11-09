# Roadmap — KAGEBOUND: WAR OF THE VEIL

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

### P1 — Combat vertical slice [initial code + server-owned stamina committed; Roblox playtest pending]
Moonfall Bamboo greybox (server generated), 2 players, Shinobi, 3-hit katana combo, heavy attack, perfect parry, directional dash, round reset. Server validates hit detection, damage and cooldowns. No repeated hit registration.

### P2 — Mythic + Veilfall [basic timed Veilfall implemented; untested; mask powers pending]
Kitsune clone; Oni burst; Tengu wind. Server-timed Veilfall with preview warning, added traversal routes and consistent collision for all clients.

### P3 — Match loop [not started]
Shadow Duel 1v1, Clan Clash prototype, loadouts, scoring, results, and automatic dojo return.

### P4 — Content MVP [not started]
Four styles, eight weapons, three masks, two finished arenas, dojo, weapon sounds, animations, gameplay VFX and HUD. Validate mobile and desktop graphics budgets.

### P5 — Progression / collection [not started]
Mastery XP, cosmetics, currencies, shop, inventory, secure persistence, trading constraints and duplication protection. All gameplay powers earnable through play.

### P6 — Alpha / launch [not started]
Network/latency tests, accessibility, moderation and security, multiplayer soak, matchmaking, onboarding and analytics.

## External system references
Reviewed three user-provided Roblox projects; architectural findings and safety decisions in [REFERENCE_REPOSITORY_REVIEW.md](REFERENCE_REPOSITORY_REVIEW.md). KAGEBOUND implementations are original. Do not import copyrighted One Piece assets or scripts. Follow issue #9 (stamina security), #10 (Yokai AI), #11 (progression/shop/trading), #12 (animation marker hitboxes) and #13 (cross-platform controls).

## Mandatory visual production gate
Before refining any greybox or placeholder FX, inspect the approved concept images listed in [ART_DIRECTION.md](ART_DIRECTION.md). Both gameplay and visual gates must pass; do not mark a placeholder as final art. The four approved reference PNGs ART-001..004 are uploaded and recorded in ASSET_MANIFEST.md. Additional asset boards remain pending.

## Future updates
Wall run and grapple, Yokai Hunt PvE, Spirit Run parkour, synchronized spirit fusion, sword clashes, clan rivalries and seasonal invasions.

**Acceptance for first playable:** Two players complete a complete 1v1 round, with sword combat, defensive timing, mythic ability and Veilfall; return to dojo without manual intervention.
