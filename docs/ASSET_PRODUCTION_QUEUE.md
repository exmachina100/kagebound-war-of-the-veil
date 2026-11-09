# KAGEBOUND — Active Asset Production Queue

**Art references**: ART-001..ART-004, uploaded in assets/concept-art. **Current 3D status:** procedural blockouts only, no published original R15 animation assets.

| Priority | Asset ID | References | Current stage | Next action |
| --- | --- | --- | --- | --- |
| 1 | KGB_WPN_Veilblade_Default | ART-003 | 3d-draft (prototype) | Completed OpenArt turnaround + procedural 516-triangle GLB/OBJ draft. Compare fidelity, import/rig/attach and test in Studio; no asset ID yet |
| 2 | KGB_CHAR_Shinobi_Default | ART-001/002 | briefed | Multi-view, editable R15 appearance and animation asset authoring |
| 3 | KGB_VFX_KatanaSlash_Default | ART-001/003 | briefed | Clean sprite + low graphics alternative and collision-timed effects |
| 4 | KGB_VFX_Parry_Default | ART-003 | briefed | Blue defensive VFX sprite and particle test |
| 5 | KGB_PROP_DojoPracticePost_Default | ART-004 | briefed | Approved prop geometry replacing blockout |
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
