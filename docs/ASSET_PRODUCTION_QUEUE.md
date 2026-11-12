# KAGEBOUND — Active Asset Production Queue

## Connected Studio audit and closed polearm source batch — 2026-11-12

- Actual ART-001..004 PNGs opened; canonical docs and accessible chat content reviewed.
  Full conversation/ZIP review remains incomplete: unresolved chat references and unavailable
  archived 3D packages. See [precise audit](assets/STUDIO_ASSET_AUDIT_2026-11-12.md).
- Connected KAGEBOUND place 92077795105213 observed in Play; read-only server inventory and
  viewport captured. ServerStorage empty at runtime. **Zero new Studio imports**, no game
  scripts modified or published, no new IDs or verified Studio pivots/scale.
- Found open surfaces in repository polearm v01 variants. Preserved originals; added
  `KGB_WPN_Naginata_CLOSED_DRAFT_v02.obj/.mtl` (120 triangles, 5 closed components) and
  `KGB_WPN_Yari_CLOSED_DRAFT_v02.obj/.mtl` (168 triangles, 6 closed components), reproducible
  `tools/close_polearm_drafts.py`, component-volume/hash validation JSON. These are distinct
  from missing chat ZIP variants. **3d-draft**, no UV/rig/import/visual approval.
- All eight source OBJ checks pass. Desktop importer access failed at initialization;
  user subsequently confirmed the target and Play was stopped. Edit has no art templates.
  EditableMesh allocation and savable content API tests succeeded, but no MeshPart was
  inserted: session repeatedly returned to Play and Edit calls became unreachable.
  Competing-controller clarification pending. Recover original archives
  for Shinobi, masks, Yokai and guide batches; do not recreate or claim their imports.

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

## Nine-asset UV re-export batch — 2026-11-11
- Source archive: `KAGEBOUND_Nine_Asset_UV_Drafts_v02.zip` (conversation attachment; **binary upload to GitHub pending**). The originals remain unchanged.
- New versioned GLBs: `KGB_WPN_Naginata_Default_UV_DRAFT_v02.glb`, `KGB_WPN_Yari_Default_UV_DRAFT_v02.glb`, `KGB_WPN_Kanabo_Default_UV_DRAFT_v02.glb`, `KGB_WPN_Kusarigama_Default_UV_DRAFT_v02.glb`, `KGB_WPN_Yumi_Default_UV_DRAFT_v02.glb`, `KGB_MASK_Kitsune_Default_UV_DRAFT_v02.glb`, `KGB_MASK_Oni_Default_UV_DRAFT_v02.glb`, `KGB_MASK_Tengu_Default_UV_DRAFT_v02.glb`, `KGB_NPC_LanternYokai_Default_UV_DRAFT_v02.glb`.
- Actual GLB reimport verification: **9/9 files**, **4,692 triangles**, **119/119 UV-bearing components**, **119/119 watertight components**, **zero degenerate faces**. Flat 4x4 RGBA per-component textures and automatic planar UVs are draft-only, not production atlases.
- Reproducible converter committed: `assets/3d-source/uv-draft-v02/upgrade_meshes.py`; original v01 generators and models preserved. The archive includes validation.json and import README.
- **All nine remain 3d-draft**: no Studio import, rig/skin/animation, head fitting, grip or mobile QA. Existing gameplay weapon state unchanged. The exact ART-001..004 GitHub blobs were verified by SHA but connector returned empty binary content; pixel-level visual parity **not** claimed.
- No paid credits, no gameplay edits. Next: binary transfer and actual ART board comparison, then Studio import handoff.

## Nodachi and Tanto source-controlled OBJ batch — 2026-11-11
- **Two newly committed original weapon geometry drafts**, not just plans: `assets/roblox-ready/weapons/KGB_WPN_Nodachi_Default_DRAFT_v01.obj/.mtl` (112 vertices / 168 triangles / 14 closed box parts, 4.30 nominal units high); `assets/roblox-ready/weapons/KGB_WPN_Tanto_Default_DRAFT_v01.obj/.mtl` (88 vertices / 132 triangles / 11 closed box parts, 1.80 units high). Both have grip-base origin (0,0,0), Y-up, -Z forward, charcoal/steel/ivory-edge/crimson/gold material palette.
- Reproducible editable source **committed**: `tools/generate_kagebound_sword_pair.js`. OBJ faces and indices re-read from GitHub and checked; no Blender/Studio import performed. Primitive boxes are closed individually, but assembled meshes overlap and have not been Boolean-unioned. No UVs or GLB in this batch; OBJ/MTL is the actual Roblox-importable draft format.
- Nodachi handoff: two-handed reach/sweep with slow recovery; Tanto handoff: short-range fast slashes and dash follow-up. These are animation notes, **not** animation clips or gameplay changes.
- ART-003 PNG SHA was verified, but GitHub connector returned 0 binary bytes; visual fidelity comparison **blocked**. Both remain `3d-draft` (source-controlled, visual review and Studio QA pending). OpenArt 0 credits. No gameplay scripts modified.

## Grand World NPC appearance batch — 2026-11-12
- Locally exported and reimported three new static GLBs: DojoMentor (204 triangles), BambooScout (268), CityArchivist (204); 51/51 closed watertight components, zero degenerate faces, 676 triangles total.
- Source, validation and README: conversation ZIP `KAGEBOUND_GrandWorld_Three_Guide_NPCs_v01.zip`, local `/mnt/data/kagebound_guides/`. Binary/source **not on GitHub**; pending upload. Y-up, -Z front, ground origin; vertex colors, no UV atlas or rig.
- Stage: **3d-draft**, not Studio imported or QA. Actual ART-001/002/004 image comparison and mapping to existing guide IDs pending. No gameplay changes.

## Studio staging package — 2026-11-12
- **13 actual GLB drafts independently reimported and verified:** Shinobi #21, 3 Grand World guide NPCs, 5 weapons (Naginata/Yari/Kanabo/Kusarigama/Yumi), 3 masks (Kitsune/Oni/Tengu), Lantern Yokai. Total 6,796 triangles, 210/210 individually watertight components, 0 degenerate faces.
- **13 OBJ fallbacks newly exported** from those GLBs, with validation metadata and import notes. Exact local ZIP `/mnt/data/KAGEBOUND_Studio_Import_Handoff_20261112.zip`; local assembly script `/mnt/data/build_kagebound_studio_handoff.py`. GitHub doc `docs/assets/STUDIO_IMPORT_HANDOFF_13_ASSETS_2026-11-12.md`.
- All 13 remain `3d-draft`. **Not** imported into Studio; no rigs, Roblox IDs, visual reference pixel comparison or QA. GitHub binary/source upload remains pending. No gameplay code changes.

## Wearable mask mesh batch — 2026-11-12
- **Three original OBJ/MTL wearable-form geometric drafts committed on `main`:** `assets/roblox-ready/masks/KGB_MASK_{Kitsune,Oni,Tengu}_Wearable_DRAFT_v01.obj`, shared `KGB_MASK_Materials_DRAFT_v01.mtl`, editable `tools/generate_kagebound_wearable_masks.js`.
- Kitsune: 106 vertices / 200 triangles; Oni: 106 / 200; Tengu: 102 / 196. GitHub readback verified each OBJ has **0 degenerate faces and 0 nonmanifold/boundary edges** (all undirected edges used twice). 596 triangles total. Multiple closed components per mask, not fused or R15-fitted.
- Y-up, front +Z, origin at ground; approximately 1.45 units wide, center 1.3 units high; four flat MTL materials. No UV atlas, GLB, Roblox import, rig/attachment or Studio QA. **Stage: `3d-draft`**. Geometry is a provisional geometric mask silhouette, not approved-reference pixel fidelity: ART-003 binary image was inaccessible through GitHub connector (0 bytes).
- Keep previous decorative mask models intact; this batch specifically targets separate wearable geometry. Mask powers/animation remain main gameplay lane.

## Three guide NPCs — source-controlled OBJ draft v02 (2026-11-12)
- **Committed actual new geometry**: `assets/roblox-ready/characters/npc/KGB_NPC_{DojoMentor,BambooScout,CityArchivist}_STATIC_DRAFT_v02.obj` and shared `KGB_NPC_Guides_DRAFT_v02.mtl`; editable generator `tools/generate_kagebound_guide_npcs.js`. These are new simpler Roblox-style modular drafts, not exact reexports of prior offline GLBs; preserve earlier v01.
- Fetched all three OBJ files back from GitHub and checked face indices/topology: DojoMentor **88 vertices / 132 triangles / 11 closed cuboids**, BambooScout **96 / 144 / 12**, CityArchivist **96 / 144 / 12**. Total **420 triangles / 35 watertight components**; zero nonmanifold edges in the indexed OBJ meshes. Materials are KAGEBOUND palette approximations.
- Y-up, -Z forward, origin at ground center, 1 model unit = 1 draft stud; static, unrigged, no UV atlas. Stage **3d-draft**; Studio import, approved PNG pixel comparison, R15 fitting and animation unverified. No gameplay code changes. Approved ART-001/002/004 blobs located but GitHub connector returned zero PNG bytes.

## Auxiliary weapon-tool geometry batch — 2026-11-12
- Four **new actual local GLB + OBJ drafts**: `KGB_TOOL_Kunai_Default_DRAFT_v01` (72 triangles / 4 closed components), `KGB_TOOL_Shuriken_Default_DRAFT_v01` (84 / 7), `KGB_TOOL_Ofuda_Default_DRAFT_v01` (48 / 4), `KGB_TOOL_WarFan_Default_DRAFT_v01` (96 / 8). Total **300 triangles, 23 watertight individual components**. GLBs exported and reimported; hashes and sizes recorded in `validation.json`.
- Editable procedural Python source `kagebound_tools_generate.py`, 8 geometry files, validation and import README are in verified conversation artifact `/mnt/data/KAGEBOUND_Tools_Batch_v01.zip`. **All 10 artifact files remain local, not committed to GitHub**; source/binary transfer pending. No UV atlas; GLB vertex colors, OBJ fallback. Stage `provisional-3d-draft`, not visual-approved, rigged, Studio imported, or QA.
- These are distinct accessory tool silhouettes from canonical GAME_DESIGN, not substitutes for full weapon meshes. ART-003 GitHub blob SHA confirmed but binary image content was empty via connector; actual approved PNG pixel review remains blocked. No OpenArt credits used, no gameplay scripts touched.

## Shinobi modular costume batch — 2026-11-12
- **5 new local rigid-accessory geometry drafts** for Shinobi #21: scarf, shoulder armor, forearm guards, waist sash, back talisman. Each has exported and reimported GLB, OBJ fallback, editable `generate.py`, `validation.json`, and import README in `KAGEBOUND_Shinobi_Modular_Accessories_v01.zip` (`/mnt/data/kagebound_shinobi_kit/`). **Local-only, GitHub binary/source upload pending**.
- Y-up / front -Z / ground origin, ~5.5-stud character fitting approximation. Vertex colors, no UV atlas, no skin weights, no R15 attachments, no Roblox Studio import. All component meshes closed/watertight and positive-volume, exported GLB scene counts rechecked. **Stage `3d-draft`, not rigged or approved**.
- ART-001/002 visual anchor in style documents; approved PNG pixels still unavailable from connector (0-byte response). No paid services, no gameplay script changes. Existing Shinobi base mesh preserved.

## Live Studio integration and Creator Store reuse — 2026-11-12
- User-confirmed plan: expedite with compatible Roblox assets, adapting to actual ART-001..004; visual match remains mandatory.
- Verified/repaired 22 pre-existing staging imports (328 MeshParts; 271 textured; 10,000 source triangles), exact package IDs and per-part scene snapshot committed. These 22 were not newly imported this pass. Geometry/material staging checks passed at 0.001 studs; gameplay/visual gates pending.
- Newly imported three free Store candidates: torii 4917170415, R6 samurai 8988047057, katana 15283548889. Zero scripts found. Originals isolated in ServerStorage; non-colliding visual review copies. Torii copied, scaled to 8 studs wide and recolored; no final approval.
- Three source-controlled static guide OBJs converted to GLB (420 triangles); Roblox upload blocked by automatic approval review pending explicit payload approval. Shinobi/modular costume source archives remain missing locally.
- See docs/assets/STUDIO_INTEGRATION_2026-11-12.md for exact checks, new GitHub code review, source preservation and save/performance limits.

## Warrior class silhouette accessory drafts — 2026-11-12 (independent asset lane)
- **3 original static OBJ drafts committed on main** for previously under-served warrior silhouettes, without altering Shinobi #21 or gameplay: RoninMantle (96 triangles / 8 closed box components), OnmyojiScroll (108 / 9), OniBracers (120 / 10). Total **324 triangles, 216 vertices, 27 closed cuboid components**.
- Paths: `assets/roblox-ready/characters/class-kits/KGB_CLASS_{RoninMantle,OnmyojiScroll,OniBracers}_STATIC_DRAFT_v01.obj`; shared `KGB_ClassKit_DRAFT_v01.mtl`; editable `tools/generate_kagebound_class_kits_v01.js`.
- GitHub readback verified 3/3 OBJ files, face-index bounds and face counts. Y-up, -Z front, ground-centered character coordinate frame; nominal 5.5-stud fitting assumption. Individual boxes are volumetric and closed, but assembled pieces overlap; no Boolean union, UVs, GLB, skin weights, R15 fitting, Studio import, visual screenshot or mobile QA. **Stage: 3d-draft**, not final or approved.
- References: ART-002 warrior style board; ART-001 palette. The exact approved PNG pixel content could not be inspected through the GitHub text connector in this run; these are **provisional silhouette geometry**, not reference-approved art. No OpenArt credits, no paid 3D services, no gameplay scripts touched.
- Next: direct ART-002 visual review, rigid attachment fitting against live R15, UV/material refinement and verified Studio import; keep all source geometry editable.
