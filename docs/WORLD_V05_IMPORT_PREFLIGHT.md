# World v05 import preflight

Six existing GLB drafts were uploaded, approved and inserted. Owner: KAGEBOUND user 1559243747; universe 10775551787. The user approved six permanent asset uploads and confirmed the upload-directory grant on 12 November 2026.

| File stem | Meshes | Triangles | Largest mesh triangles | Bytes |
| --- | ---: | ---: | ---: | ---: |
| dojo_curved_roof_lod0 | 22 | 664 | 32 | 17144 |
| dojo_offering_pavilion_lod0 | 11 | 128 | 12 | 7864 |
| dojo_ceremonial_court_lod0 | 56 | 672 | 12 | 32236 |
| moonfall_arch_bridge_lod0 | 39 | 468 | 12 | 22648 |
| moonfall_bamboo_canopy_lod0 | 126 | 2632 | 32 | 80340 |
| moonfall_ritual_lantern_lod0 | 11 | 128 | 12 | 7692 |

Run `node tools/check_world_glb.js` to verify GLB headers, declared lengths, primitive/accessor counts, local position bounds, manifest triangle totals and per-mesh budgets. All six passed. Every primitive has vertex colors; no embedded images are present. The separate atlas is a reference, not an embedded applied texture. This is structural preflight, not proof of watertightness, correct winding or approved visual fidelity.

Source units are documented as approximate studs. Verify actual imported extents and grip/ground pivots; do not automatically apply a metre conversion to these files. Node-transformed world bounds, Studio materials and orientation still require import inspection. Individual meshes are far below the current 20000-triangle Roblox limit checked in official modeling specifications.

Permission probes for asset:read and asset:write both succeeded. The first roof POST was rejected before upload because the source directory was not approved for uploads. No operation ID or asset ID was created; there is no pending upload to duplicate.

The user then approved the source directory; the retry succeeded. Exactly six successful model uploads were performed. Operations and responses are saved in `assets/world/dojo_moonfall/v05/roblox-upload-receipts.json`. No duplicate uploads were used to evade moderation or directory controls.

| Model | Approved Roblox asset ID |
| --- | --- |
| Curved roof | 121636272241976 |
| Offering pavilion | 76400162744526 |
| Ceremonial court | 107366234868083 |
| Arch bridge | 109639603956237 |
| Bamboo canopy | 134708416868294 |
| Ritual lantern | 115776513142912 |

All expected MeshParts arrived: 22/11/56/39/126/11, total 265. No image assets/textures were generated. Vertex colors remained visibly present in staging despite default-grey MeshPart.Color properties; no additional color multiplication was applied. Original approximate-stud dimensions and positive-Y orientation were retained after restoring the imported model pivots to source origin. All local templates are anchored, noncolliding and nonqueryable.

Six native `.rbxm` files in `assets/roblox-ready/world-v05` were exported using Roblox SerializationService, with a successful engine serialize/deserialize roundtrip. Rojo maps them into ServerStorage/KageboundWorldV05. Each retains its PackageLink. Repairs affect these local templates; re-inserting or updating the uploaded packages restores the original uploaded properties. No repaired asset versions were published and no package links were removed.

WorldV05Art.server.lua installs three source-controlled cosmetic drafts: pavilion at (-75,.75,45), lantern at (-52,.75,58), bamboo at (95,.75,-720). Existing collision, hitboxes and legacy geometry remain intact. Roof/court/bridge are cached templates awaiting placement and traversal checks. Runtime validates expected part counts, rejects scripts and fails closed if ground/templates are missing; it does not perform uploads or runtime asset downloads.

ART-004 pixels and staging geometry were visually inspected. This remains a low-poly draft milestone, not final concept parity. Runtime structural checks pass, but current viewport captures show a white 3D scene with and without the imported art; in-world visual signoff remains open while that render/capture issue is investigated.
