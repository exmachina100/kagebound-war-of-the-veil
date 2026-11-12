# KAGEBOUND Approved Asset Manifest

## Current reconciliation — 2026-11-12

Historical no-import statements below are superseded by the verified 22-model
staging snapshot and [unified master evidence](KAGEBOUND_MASTER.md). This pass
reused 14 imported world templates and verified 18 runtime placements / 312
MeshParts with no unsafe cosmetic parts or executable descendants. Saved place
version 38; zero new mesh uploads and no final visual/gameplay signoff.
The [master queue](ASSET_PRODUCTION_QUEUE.md) covers every workstream.
[Local asset inventory](assets/MASTER_ASSET_INVENTORY.json) records 309 files,
hashes and 30 exact duplicate groups; no originals were removed or overwritten.

## 2026-11-12 source repair and live Studio audit

Actual ART-001..004 PNGs opened locally. New closed polearm **drafts**, preserved
separately from original v01: `assets/roblox-ready/weapons/KGB_WPN_Naginata_CLOSED_DRAFT_v02.obj`
(70 vertices, 120 triangles, 5 closed solids) and `KGB_WPN_Yari_CLOSED_DRAFT_v02.obj`
(96 vertices, 168 triangles, 6 closed solids), matching MTL, reproducible
`tools/close_polearm_drafts.py`, `POLEARMS_v02_validation.json` and import notes.
Positive per-component volume and consistent winding checked; assemblies are
not Boolean-unioned. No Studio imports/IDs, measured Studio pivots/scale, UVs,
rig or final visual signoff. Existing gameplay scripts and source PNGs unchanged.
See [evidence and missing archive inventory](assets/STUDIO_ASSET_AUDIT_2026-11-12.md).

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

- `src/server/YokaiEncounter.server.lua`: ART-001/002/004-inspired original Lantern Yokai enemy blockout (ivory ritual mask, vermilion horns, ink robe/body, violet spirit heart) with server-owned health. Procedural geometry only; no source mesh or authored animation yet.

- `src/server/ShinobiAppearance.server.lua`: ART-001/002 procedural avatar accessory pass with charcoal plated silhouette, crimson scarf, angular black hair, tilted ivory fox mask and gold accents. Zero-collision welds; **not** an imported R15 rig, finished mask mesh or finalized character model.
- `src/client/ProgressionHUD.client.lua`: ART-001/004-inspired small Spirit Shards / Veilblade Mastery HUD, reflects server-owned session counters.

## Optional animation pipeline v0.4
- `src/shared/AnimationCatalog.lua`: slots for Light1/2/3, Heavy, Parry, Dash, DoubleJump and Idle. All slot IDs **intentionally empty** until game-owned animations are published; no fake Roblox asset IDs.
- `src/client/ShinobiAnimation.client.lua`: plays owned Animator tracks when available; otherwise uses a local, temporary Veilblade `Tool.Grip` windup/follow-through. Does **not** authorize damage.
- `src/server/Veilblade.server.lua`: original ART-003-derived edge `Trail` with two blade attachments, a cosmetic proxy enabled on server-accepted Swing by the client. Not a final slash texture.
- Animation design and Studio publishing/verification: `docs/SHINOBI_ANIMATION_PIPELINE.md`.

- `src/server/DojoTraining.server.lua`: ART-001/004 ceremonial practice-post geometry with ivory mask motifs, warm-gold bands and a spirit-violet practice ring. Three tagged server-side training hitboxes; **not** the final asset kit.

- `src/server/DuelVeilfall.lua`: original ART-001/004 procedural round-local raised spectral routes and rift ring for Shadow Duel, still a greybox. Separate from open-world RegionalVeilfall; low-poly art replacement pending the asset workstream and Studio gameplay QA.

## New cinematic VFX boards — conversation handoff, NOT imported assets
Four GPT-generated 1672x941 RGB composite concept boards (Oni eruption, Veilfall stages, Kitsune blade/illusion, mythic move showcase) are packaged as `KAGEBOUND_VFX_ConceptPack_v01.zip`, available from the current conversation. Their filenames and role are documented in `docs/VFX_CONCEPT_HANDOFF.md`. They have **not yet been verified as GitHub files** and cannot be used directly as alpha ParticleEmitter textures; production sprite conversion and Studio QA are pending. Keep original ART-001..004 as style approval authority.

## Class and mask VFX assets v0.5
- **Reference boards verified on GitHub:** 4 user-approved concept-art PNGs under `assets/concept-art/`; four original cinematic boards under `assets/concept-sheets/vfx-v01/`; four original warrior VFX boards (Shinobi/Ronin/Onmyoji/Oni Disciple) under `assets/concept-sheets/clan-vfx-v01/`.
- **Transparent VFX texture handoff generated:** `KAGEBOUND_VFX_Flipbooks_v01.zip` (7 RGBA 1024×1024 / 16-frame atlases; source Python and manifest). These files are still **pending GitHub binary upload and Roblox Studio import**. Target path `assets/vfx/flipbooks/v01/`.
- **Runtime script integration committed:** `src/shared/VFXProfiles.lua`, `src/shared/VFXTextureCatalog.lua`, `src/client/VFXFactory.lua`, `src/client/VFXSpriteEmitter.lua`, and updated combat/mask FX renderers. Without verified Roblox upload IDs the game displays procedural neon-geometry FX only.
- **Original production instructions:** `docs/CLASS_VFX_PRODUCTION.md`, `docs/VFX_FLIPBOOK_IMPORT.md`. Do not mark effects production ready until both visual and Studio multiplayer QA pass.

## Source-controlled original 3D mesh exports — actual geometry, not game-approved yet
| Asset ID | GitHub file | Source / measured complexity | Current status |
| --- | --- | --- | --- |
| KGB_WPN_Veilblade_Default_GAME_v02 | `assets/roblox-ready/weapons/KGB_WPN_Veilblade_Default_GAME_v02.obj` with same-base `.mtl` | Reproducible `tools/generate_kagebound_obj.js`; ART-003 + existing OpenArt turnaround; 668 vertices / 1220 triangles / 32 mesh objects | 3d-draft; static OBJ pass, no uploaded MeshId, no Studio screenshot |
| KGB_PROP_DojoPracticePost_Default_GAME_v01 | `assets/roblox-ready/environment/KGB_PROP_DojoPracticePost_Default_GAME_v01.obj` with same-base `.mtl` | Same source; ART-001/004; 184 vertices / 296 triangles / 18 mesh objects | 3d-draft; static OBJ pass, no uploaded MeshId, no Studio screenshot |

`tools/check_kagebound_obj.js` rejects nonfinite vertices, bad face indices, degenerate triangles and missing material names. Its checks do not certify manifold geometry, UVs, normals, rigging, imported color or device performance. The game scripts can optionally display them when imported into `ServerStorage/KageboundArt` under the exact names documented in [ASSET_IMPORT_HANDOFF_v01.md](ASSET_IMPORT_HANDOFF_v01.md). **The current procedural asset path remains active until that actual import is done.**

## Live staging update — 2026-11-12
22 previously imported models now have measured Studio geometry/material evidence and recorded package + MeshPart IDs in assets/studio-import-batch/manifest.json and studio-snapshot-2026-11-12.json. Three new Creator Store candidates imported and isolated, one torii style adaptation. All remain drafts. No verified Shinobi/NPC import, final visual approval, mobile QA or cloud save. See [integration evidence](assets/STUDIO_INTEGRATION_2026-11-12.md).
