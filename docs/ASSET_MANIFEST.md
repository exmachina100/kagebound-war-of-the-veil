# KAGEBOUND Approved Asset Manifest

## Confirmed GitHub visual references — uploaded on main

These are the **actual names of the four PNGs committed under** `assets/concept-art/`. Use these as the primary references for all design and implementation work.

| ID | Asset | GitHub path | Role |
|---|---|---|---|
| ART-001 | Overall game key art | `assets/concept-art/ChatGPT Image Nov 9, 2026, 09_55_15 PM-1.png` | Hero character, lighting, mythology and environment |
| ART-002 | Warrior styles concept sheet | `assets/concept-art/ChatGPT Image Nov 9, 2026, 09_55_24 PM-2.png` | Shinobi, Ronin, Onmyoji, Oni Disciple proportions and styling |
| ART-003 | Weapons and masks concept sheet | `assets/concept-art/ChatGPT Image Nov 9, 2026, 09_55_30 PM-3.png` | Katana and seven other weapons; Kitsune, Oni, Tengu masks and tools |
| ART-004 | Environment and game look concept sheet | `assets/concept-art/ChatGPT Image Nov 9, 2026, 09_55_36 PM-4.png` | Moonfall Bamboo normal/Veilfall, Kage Dojo lobby, props, palette and layout |

The first four images are source-of-truth design references. Do **not** replace them with unrelated stock images or unapproved generic game visuals. Compare Roblox Studio screenshots with these source boards.

## Pending supplementary artwork
- VFX/abilities board — to produce/upload
- Modular assets/UI board — to produce/upload
- Separated game-ready sprite textures, mesh assets, rigs, animation assets and sound effects — **not yet produced**

## Production asset tracking rules
For each actual implementation record asset ID, concept anchor ID, geometry/texture/animation source, expected scale, performance budget, Roblox uploaded asset ID and verification screenshot.

Note: PNG concept boards are illustrative references, not directly importable 3D rigs, particle effects or executable gameplay systems.

## Runtime prototype art (not final approved assets)
- `src/server/Veilblade.server.lua`: procedural Tool body of the ART-003 Katana / Veilblade. Dark blade, hot-pink edge, crimson details, gold guard, red tassel. The script creates geometry at runtime; it is not a texture or importable final mesh.
- `src/client/CombatVFX.client.lua`: short crimson/magenta arc and blue parry effects referencing ART-001/003; no final particle sprites, rigged swings or animation markers imported.
- `src/server/RegionalVeilfall.server.lua`: world-space Moonfall spectral bridge and rift visual placeholder referencing ART-004.

Each item requires visual side-by-side review against the actual uploaded four PNGs before final-art approval.
