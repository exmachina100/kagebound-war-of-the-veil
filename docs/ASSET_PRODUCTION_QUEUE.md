# KAGEBOUND — Active Asset Production Queue

**Art references**: ART-001..ART-004, uploaded in assets/concept-art. **Current 3D status:** procedural blockouts only, no published original R15 animation assets.

| Priority | Asset ID | References | Current stage | Next action |
| --- | --- | --- | --- | --- |
| 1 | KGB_WPN_Veilblade_Default | ART-003 | 3d-draft (GitHub OBJ v02) | New 1220-triangle OBJ/MTL and generator on main; previous offline 516-triangle GLB/OBJ v01 also exists in conversation. Import via ASSET_IMPORT_HANDOFF_v01.md; no Studio asset ID yet |
| 2 | KGB_CHAR_Shinobi_Default | ART-001/002 | briefed | Multi-view, editable R15 appearance and animation asset authoring |
| 3 | KGB_VFX_KatanaSlash_Default | ART-001/003 | briefed | Clean sprite + low graphics alternative and collision-timed effects |
| 4 | KGB_VFX_Parry_Default | ART-003 | briefed | Blue defensive VFX sprite and particle test |
| 5 | KGB_PROP_DojoPracticePost_Default | ART-004 | 3d-draft (GitHub OBJ v01) | New 296-triangle OBJ/MTL and generator on main. Import as visual-only template and validate 3 targets plus SafeHub immunity |
| 6 | KGB_NPC_LanternYokai_Default | ART-002/004 | briefed | Character front/side/back and rig-friendly original mesh |
| 7 | KGB_ENV_Moonfall_ModularKit | ART-004 | briefed | Reusable bamboo, torii, stone, lantern, bridge sheet / mesh kit |
| 8 | KGB_MASK_Kitsune_Default | ART-002/003 | briefed | Wearable mask turnaround and 3D conversion |

## Current OpenArt job
- Asset: KGB_WPN_Veilblade_Default_TURNAROUND_v01
- Provider/model: OpenArt Nano Banana 2 image2image, one image, 2K, 3:2
- Source: ART-003 exact image from GitHub (not a generic search asset)
- History ID: v3D6At8nMZrIQ64MoQoh
- Job completed: OpenArt resource ID 6qWN0Ruzt8oogNNv7fYs; concept available in OpenArt history. Visual fidelity/approval requires comparison against ART-003.
- Quoted generation cost: 30 credits, subject to OpenArt final billing.
- A separate original low-poly 3D Veilblade prototype was generated as editable Python geometry and exported as GLB/OBJ (27 mesh pieces, 516 triangles). It is **not** an AI reconstruction of the OpenArt turnaround, and it has **not** been imported or approved in Roblox. Files were generated in a conversation archive for local import; GitHub binary upload is pending.

## Next integration
Once the approved Veilblade 2D views are ready, build/convert the mesh with real geometry, check and optimize, import in Roblox Studio, replace current procedural parts by a versioned mesh and validate the equipped sword, trail attachments, game camera readability and server-owned damage.

## Veilblade prototype geometry and handoff
- Offline export package: `KAGEBOUND_Veilblade_v01_3D_Prototype.zip` from the development conversation containing `.glb`, `.obj`, reproducible `.py` generator and import readme.
- OpenArt turnaround source URL: https://cdn.openart.ai/openart-ai/production/2026-11/create-image/zJfldFkAyO87iqeQBjIU/image_1794254479643_167418f1_1794254480598_ab4a07b6.png
- No verified GitHub binary path / Roblox asset ID yet. Before replacing `src/server/Veilblade.server.lua`, import into Roblox Studio, check pivot, materials and blade trail attachment, use approved ART-003 for visual correction, confirm 2-player combat unaffected.

## New active Duel Veilfall environment dependency
- Asset ID: `KGB_ENV_DuelVeilfall_SpectralRoutes_Default`
- References: ART-001 and ART-004; code prototype: `src/server/DuelVeilfall.lua`
- Stage: `briefed` (eight server-controlled procedural surfaces plus decorative spirit ring; **not yet** imported low-poly meshes)
- Export goal: real static `.glb/.gltf` low-poly mesh kit (or `.obj` fallback) with editable source, safe collision proxies, pivot/scale and graphics tiers. Replace cosmetics only after two-player Studio validation, and keep server collision authoritative.
- Production rule: existing approved concept images satisfy G2; no redundant image generation required if geometry can be modeled directly.

## New original grand-scale VFX concepts (8 PNGs verified on GitHub main)
- `KGB_VFX_FX006_OniBossEruption_CONCEPT_v01.png`: original boss-scale rupture visual reference (ART-001/002/004), 2D concept-draft only.
- `KGB_VFX_FX008_VeilfallSequence_CONCEPT_v01.png`: phased portal and spectral route reference (ART-001/004), concept-draft only.
- `KGB_VFX_FX005_KitsuneUltimate_CONCEPT_v01.png`: original Kitsune and high-energy sword attack reference (ART-001/002/003), concept-draft only.
- `KGB_VFX_MythicMovesShowcase_CONCEPT_v01.png`: multi-ability showreel board, concept-draft only. Text rendered inside any image is not authoritative naming or proof of implemented abilities.
- Source: user-facing `KAGEBOUND_VFX_ConceptPack_v01.zip`, four PNGs and `VFX_CONCEPT_MANIFEST.json`; expected extraction into `assets/concept-sheets/vfx-v01/`. **GitHub PNG binary upload has been verified** for `assets/concept-sheets/vfx-v01/` and `assets/concept-sheets/clan-vfx-v01/`.
- Next production task: create distinct transparent sprite sheets and optional low-poly FX geometry, add timing and mobile tiers, then Studio test. See [VFX_CONCEPT_HANDOFF.md](VFX_CONCEPT_HANDOFF.md).

## Transparent texture development — new deliverables
- Seven generated original RGBA 1024×1024 Grid4x4 flipbooks: Shinobi, Ronin, Onmyoji, Oni, Kitsune, Tengu, Parry. Handoff archive in this conversation: `KAGEBOUND_VFX_Flipbooks_v01.zip` (includes exact Python source and metadata). **Generated, but binary files not yet committed to GitHub or uploaded to Roblox.**
- Target repository path: `assets/vfx/flipbooks/v01/`.
- Runtime hookup committed: `src/shared/VFXTextureCatalog.lua` (no fake IDs) + `src/client/VFXSpriteEmitter.lua` + layered geometry `src/client/VFXFactory.lua`. Four class profiles and four class board references in `src/shared/VFXProfiles.lua`.
- See [VFX_FLIPBOOK_IMPORT.md](VFX_FLIPBOOK_IMPORT.md) and [CLASS_VFX_PRODUCTION.md](CLASS_VFX_PRODUCTION.md). Next: local PNG upload, real asset IDs, Studio two-player VFX and mobile performance QA.

## Verified new source-controlled mesh batch
- `assets/roblox-ready/weapons/KGB_WPN_Veilblade_Default_GAME_v02.obj` and matching `.mtl` — **668 vertices / 1220 triangles / 32 mesh objects**, grip origin at (0,0,0), ART-003 source.
- `assets/roblox-ready/environment/KGB_PROP_DojoPracticePost_Default_GAME_v01.obj` and matching `.mtl` — **184 vertices / 296 triangles / 18 mesh objects**, ground base at Y≈0, ART-001/004 source.
- Generator: `tools/generate_kagebound_obj.js`. Validator: `tools/check_kagebound_obj.js`.
- Measured preflight: finite vertices, valid face indices, no degenerate triangles, valid MTL refs, below preliminary low-poly budgets. Both files pass the checker, **not yet Blender watertight/normal or Roblox Studio QA**.
- Studio-only cosmetic integration: `ServerStorage/KageboundArt/VeilbladeVisual` and `ServerStorage/KageboundArt/DojoPracticePostVisual`, consumed automatically by `src/server/Veilblade.server.lua` / `src/server/DojoTraining.server.lua` with existing visual fallback. See [import handoff](ASSET_IMPORT_HANDOFF_v01.md).
- Both assets remain **3d-draft**, not `imported` or `validated`.

## Shinobi static geometry workstream — 2026-11-10
- Asset: `KGB_CHAR_Shinobi_Default`, ART-001/ART-002. **Stage: 3d-draft (offline, pending binary GitHub upload)**; no rig, Studio import, animation, or visual sign-off.
- Verified local output: `KAGEBOUND_Shinobi_Blockout_v01.zip` containing `kagebound_shinobi/generate_shinobi.py`, `KGB_CHAR_Shinobi_Default_BLOCKOUT_v01.glb`, `README.md`. Generated with trimesh 4.11.1; GLB reimport: **40 closed submeshes, 1,428 triangles, all watertight, zero degenerate triangles**. Y-up, -Z forward, ground pivot, nominal height 5.83 units; 7-color vertex-color appearance kit.
- This is a **static appearance blockout**, not a skinned R15 character or finished mesh. Actual approved PNG pixel-by-pixel comparison is pending, as are bone weights, animation, UV texture work, scale/material checks, Studio import, and mobile QA. No Roblox ID assigned.
- Binary and generator were produced in the automation working container, **not committed to GitHub**. Next: transfer the exact ZIP contents into `assets/3d-source/characters/` and `assets/roblox-ready/characters/` after reference review, then import/rig in Studio. No gameplay scripts changed.

## Shinobi #21 source preflight — follow-up 2026-11-10
- Inspected the existing offline ZIP generator and GLB handoff. Audited the 40-part / 1,428-triangle static mesh's R15, UV/material, accessory, pivot and import limitations.
- Source-controlled audit: `docs/assets/SHINOBI_21_GEOMETRY_PREFLIGHT_v01.md` (commit `8137fe7a5c05aacac0a998f60702abd4deb90543`).
- Stage remains **3d-draft**; binary/source still require upload to GitHub and approved PNG pixel-level review. No rigging, Studio import or QA claimed. No gameplay scripts touched.

## Shinobi #21 UV geometry v02 — 2026-11-10
- Produced offline `KAGEBOUND_Shinobi_UV_Blockout_v02.zip`, containing original `generate_shinobi_v02.py`, `KGB_CHAR_Shinobi_Default_BLOCKOUT_v02.glb`, README, and measured `validation.json`.
- Reimported GLB: **49,428 bytes; 40 meshes; 1,428 triangles; 40/40 watertight parts; 40/40 UV-bearing meshes; zero degenerate faces**. Cylindrical per-part UVs and tiny RGBA flat-color textures are provisional, not an approved texture atlas.
- Y-up, -Z forward, ground pivot; height approximately 5.83 units. Previous v01 preserved.
- **Stage remains 3d-draft**. No R15 skin/rig, animation, Studio import, screenshot or device QA. ART-001/002 exact PNG comparison pending. Binary/source are verified locally, **not pushed to GitHub**; package is a conversation attachment.
- Next: reference comparison and R15 segmentation/weights; do not edit gameplay scripts.

## Weapon batch — 2026-11-11: Naginata / Yari / Kanabo geometry
- **Three original offline GLB + OBJ draft pairs exported and GLBs reimported**, with editable `generate_weapons.py`, `validation.json` and import README packaged in conversation artifact `KAGEBOUND_Weapon_Batch_Naginata_Yari_Kanabo_v01.zip`. **Not committed as binaries to GitHub**; source generator also offline pending upload.
- `KGB_WPN_Naginata_Default_DRAFT_v01` — **212 triangles**, 9 watertight submeshes, 0 degenerate faces, Y-up height 5.23 units. ART-003. **3d-draft/offline**; enabled gameplay playtest prototype, no Studio art import. Attack handoff: long-reach wide sweep.
- `KGB_WPN_Yari_Default_DRAFT_v01` — **180 triangles**, 8 watertight submeshes, 0 degenerate faces, Y-up height 5.675 units. ART-003. **3d-draft/offline**; enabled gameplay playtest prototype, no Studio art import. Attack handoff: narrow forward thrust.
- `KGB_WPN_Kanabo_Default_DRAFT_v01` — **672 triangles**, 46 watertight submeshes, 0 degenerate faces, Y-up height 4.45 units. ART-003. **3d-draft/offline**; gameplay archetype remains disabled. Attack handoff: heavy overhead guard break.
- All three grip-base pivots at (0,0,0), -Z forward, vertex-color materials, no UV atlas or rig; component-wise watertight only, not Boolean union. Existing source files unchanged. Actual ART-003 pixel-level comparison and Blender/Studio import/performance QA **not performed**. OpenArt spend: **0**.
- Target repo paths after verified binary transfer: `assets/roblox-ready/weapons/<asset>.glb`, matching `.obj`; generator `assets/3d-source/weapons/generate_weapons.py`. Next weapon tickets: Kusarigama (staged), Yumi (staged); do not claim complete art from gameplay procedural parts.

## Six-asset original geometry batch — 2026-11-11
**Locally generated and GLB reimport-verified; not yet pushed as binaries to GitHub.** Downloadable archive: `KAGEBOUND_Asset_Batch_Kusarigama_Yumi_Masks_Yokai_20261111.zip`. Includes GLB and OBJ for each asset, Python editable generator, validation.json and README. All 56 component meshes are individually watertight with no detected degenerate faces; assemblies are not Boolean-unioned. No Studio import or final-art signoff.

| Asset | Reference | Triangles | Components | Stage | Handoff |
|---|---|---:|---:|---|---|
| KGB_WPN_Kusarigama_Default_DRAFT_v01 | ART-003 | 504 | 13 | 3d-draft, offline | Chain posed rigidly; swinging/pull animation, collision and server combat QA pending |
| KGB_WPN_Yumi_Default_DRAFT_v01 | ART-003 | 484 | 11 | 3d-draft, offline | Bowstring decorative; draw/release animation and projectile QA pending |
| KGB_MASK_Kitsune_Default_DRAFT_v01 | ART-003 | 760 | 8 | 3d-draft, offline | R15 head fit and wearable pivot pending |
| KGB_MASK_Oni_Default_DRAFT_v01 | ART-003 | 572 | 8 | 3d-draft, offline | R15 head fit and wearable pivot pending |
| KGB_MASK_Tengu_Default_DRAFT_v01 | ART-003 | 592 | 6 | 3d-draft, offline | R15 head fit and wearable pivot pending |
| KGB_NPC_LanternYokai_Default_DRAFT_v01 | ART-001/002/004 | 716 | 10 | 3d-draft, offline | Static NPC only; rig/animation/LOD pending |

All are Y-up; GLB uses vertex colors, OBJ fallback included. Per-asset bounds and file sizes recorded in archive validation.json. The approved ART-001..004 PNGs are confirmed by manifest but exact pixels could not be retrieved by this runtime; **reference parity remains pending**. OpenArt spend 0. Preserve existing Veilblade #24 OBJ and Shinobi #21 UV GLB; do not repeat their completed geometry stages. Naginata/Yari/Kanabo prior offline drafts remain pending binary transfer. GitHub target paths: `assets/roblox-ready/weapons/`, `assets/roblox-ready/masks/`, `assets/roblox-ready/characters/`; generator target `assets/3d-source/`. No gameplay scripts modified.
