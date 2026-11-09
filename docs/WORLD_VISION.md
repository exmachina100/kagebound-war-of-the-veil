# KAGEBOUND: WAR OF THE VEIL — Grand World Vision

**Design decision, 2026-11-09:** KAGEBOUND is an interconnected large-scale Japanese mythological action-adventure Roblox world, with the progression, exploration and spectacle of grand anime-inspired Roblox games. It is **not** principally a small enclosed arena battler. Competitive duels remain one activity within the world.

## Source of truth
This document expands—not replaces—[GAME_DESIGN.md](GAME_DESIGN.md), [ROADMAP.md](ROADMAP.md), [ART_DIRECTION.md](ART_DIRECTION.md), [ASSET_MANIFEST.md](ASSET_MANIFEST.md), and [VFX_SPEC.md](VFX_SPEC.md). The four approved visual references (ART-001..004) are mandatory. The original 338-line uploaded document remains pending import and should be preserved verbatim.

## Core gameplay loop
Explore enormous connected lands → discover hidden shrines/NPC villages/camps → acquire quests, defeat Yokai and bosses → master fighting styles, weapons and masks → earn mastery/rewards/cosmetics → access new zones, traversal techniques and Veilfall secrets → join world events, clan conflicts or optional ranked duels.

## World atlas
| Region | Role | Traversal and landmark | Intended activity |
| --- | --- | --- | --- |
| Kage Dojo / Veilbound Hamlet | Social hub + training grounds | roofs, training squares, forge, trade stalls | onboarding, styles, NPCs, inventory, matchmaking |
| Moonfall Bamboo | Starter wilderness + sprawling forest | shrines, streams, bamboo cliffs, hidden caverns | early Yokai, movement challenges, first boss |
| Shogun's Last City | Urban vertical district | fortress rooftops, markets, gardens, canals | ronin quests, clan contracts, rooftop parkour |
| Frozen Shrine Highlands | Ice mountain range | passes, broken temples, cave tunnels | Yuki-onna chains, vertical traversal |
| Yomi Rift | Dangerous spirit frontier | fractured mountains, spirit bridges, dimension gates | world bosses, advanced masks, large Veilfall events |

Later major zones: Sunken Kappa Marsh, Tengu Sky Peaks, Kitsune Mirage Forest, Iron Oni Citadel, Coastal Samurai Port, Ancient Imperial Ruins. Their availability depends on content and performance budgets, not a requirement to spawn thousands of parts immediately.

## Combat and experience rules
- Skill-based sword/melee combat, parry, dash, movement, masks, Veil Burst; server owns damage and currency.
- Support dozens of players per world eventually, with separate ranked PvP instances. Target server population depends on performance tests, not an unsupported promise.
- PvP is opt-in in overworld safe areas; no spawn griefing. The old Shadow Duel and Clan Clash modes remain, reached through world activities.
- RPG progression emphasizes access, moveset choices, equipment and cosmetics—not purely overpowering newcomers with pay-to-win stats.
- Bosses must telegraph and use finite-state AI; never reuse One Piece art, story or characters.

## Veilfall at world scale
Veilfall becomes a **regional / world event**, not just an arena timer. A warning opens spectral crossings, changes the route network, awakens world bosses or reveals quests, then closes with safe player relocation. Transition rules and rewards must be fully server-authoritative.

## Visual direction
The approved concept images are non-negotiable. ART-001 key art anchors blockbuster moonlit shrine presentation. ART-004 anchors layered cliffs, floating Veilfall routes, Kage Dojo, lanterns and bamboo. ART-002/003 anchor humanoid Roblox silhouettes and equipment. The current world script is a **procedural exploration greybox**, not the quality bar for release.

## Technical architecture
- One source-controlled Luau project via Rojo.
- `WorldConfig.lua`: region metadata, paths and design constants.
- `GrandWorld.server.lua`: current deterministic environment prototype, 5 districts + connected roads.
- `MoonfallArena.server.lua`, `MoonfallArt.server.lua`, `Veilfall.server.lua`: gated legacy arena prototypes, not active when Grand World is enabled.
- Next: move world generation to modular zone packages; terrain meshes / Terrain voxels, river and cliff composition; data-driven WorldEventService, QuestService, RegionService, NPCService, InventoryService, TravelService.
- For scale: `Workspace.StreamingEnabled` should be configured and assessed in the Studio place, use content partitioning / chunk streaming, pooled VFX, mesh instancing and bounded NPC spawning.
- Durable save data / economy comes later after tests; no trusting client attributes for spendable state.

## Releases and acceptance
**World P0 (current code, untested):** 5 explorable regions, continuous ground, cross-region paths, Kage Dojo spawn and landmark blockouts; legacy walls disabled. This *does not* claim the giant world is fully populated or visually finished.

**World P1:** Traversal loop on foot from Kage Dojo → Moonfall Bamboo → Shogun's Last City; 3 NPCs, quests and first named Yokai enemy, map markers. Verify with multiple clients.

**World P2:** Deep region terrain/architecture, real Japanese fantasy prop kits aligned to approved boards, combat animation/VFX fidelity, regional Veilfall, first boss, region progression.

**World P3:** Full hub economy and weapon/mask collection, repeated PvE loops, clans, regional events and travel conveniences.

**World P4:** Expand full world roster, sustained performance and data persistence with moderation/anti-exploit, mobile optimization, matchmaking and polish.
