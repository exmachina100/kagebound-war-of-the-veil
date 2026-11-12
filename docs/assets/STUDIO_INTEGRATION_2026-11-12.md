# KAGEBOUND live asset integration — 2026-11-12

## Plan and controlling references
Use Roblox Creator Store models, rigs and equipment to expedite production where reusable geometry meets the requirements. Adapt selected geometry to ART-001..004; Japanese subject matter alone is insufficient. Preserve original creator attribution and source IDs. Quarantine executable content before activating any third-party model. Do not promote until visual and gameplay gates pass.

Read the original 338-line concept, GAME_DESIGN, WORLD_VISION, ART_DIRECTION, STYLE_GUIDE, asset workflow, manifest and queue. Opened the actual four approved PNGs locally. ART-001/002 require blocky layered characters, charcoal armor, crimson scarf and ivory fox identity. ART-003 requires tapered dark blades, magenta edge, gold fittings and distinct sculpted mask faces. ART-004 requires layered shrine roof curves, vermilion torii, warm lanterns and moonlit violet surroundings.

## Live evidence
MCP read the Edit scene for KAGEBOUND place 92077795105213, universe 10775551787, studio ec3ac846-a74b-41b1-9a66-300bb0e969fd. Place owner and signed-in Studio user both 1559243747.

**22 source-controlled models were already imported at turn start. This pass verified, repaired material colors, separated overlaps and arranged those existing imports; it did not newly import those 22.** Workspace/KageboundAssetBatch22 now has 328 MeshParts, 271 textured parts, 328 distinct mesh IDs and eight color-map IDs. Source GLBs total 10,000 triangles. Every expected component matched source bounds/position within 0.001 studs (maximum observed deviation below 0.00003). GLB importer uses a baked 180-degree Y rotation; validation accounts for it without changing the model shape. All 328 parts anchored, CanCollide/CanTouch/CanQuery false; zero scripts.

Fourteen environment assets: eight v08 (ceremonial stones, ritual banner, roof eave, shrine pavilion, stone lantern, torii, arch bridge, bamboo grove); six v07 (komainu plinth, ritual banner, suspended bell, bamboo fan, lantern arch, stepping stones). Five weapons: Veilblade v02, Nodachi, Tanto, closed Naginata/Yari v02. Three wearable-form masks: Kitsune, Oni, Tengu. Exact package IDs and source SHA-256 values are in assets/studio-import-batch/manifest.json; per-part mesh/texture IDs, colors, sizes and CFrames in studio-snapshot-2026-11-12.json. Strict execution results in studio-validation-2026-11-12.json.

Veilblade measured 8.73 studs high; Nodachi 4.44; Tanto 1.94; Naginata 8.90; Yari 9.20. These are staged draft source scales, not verified wielding fit. Masks approximately 1.45 studs wide; no R15 head-fit approval.

## Creator Store batch: three NEW imports
Searched free Creator Store results for Japanese torii, samurai rig and katana. Evaluated four results per query. Selected these for isolated inspection, not final art:

| Asset / creator | Roblox ID | Observed hierarchy / dimensions | Decision |
|---|---|---|---|
| Japanese Torii Gate / u_niversaal | 4917170415 | Model, 21 Parts, no meshes/scripts, 22.17 x 16.67 x 1.57 studs | Useful structural base; copied and adapted to 8.00 x 6.02 x 0.57, crimson Wood and charcoal Slate. Needs rope, fox banner/detail and ART-004 lighting review. |
| Japanese Samurai (WORKING RIG) / Reflecterr | 8988047057 | 21 parts, 15 mesh-bearing, 20 Motor6Ds, R6 Humanoid, 4.55 x 5.68 x 6.42 | Review-only; red heavy samurai silhouette cannot replace Shinobi. R6 does not establish R15 compatibility. |
| Sword katana / Haantoca | 15283548889 | One mesh-bearing part and one Motor6D, 0.40 x 0.42 x 4.68 | Review-only; plain sword lacks ART-003 dark/magenta signature. Existing original Veilblade retained. |

Originals under ServerStorage/KageboundCreatorStoreReview. No LuaSourceContainers found in any imported candidate; QuarantinedCode folder exists for future scripts. Non-colliding inspection copies in Workspace/KageboundStoreVisualReview. Adapted torii copy named KGB_PROP_StoreTorii_STYLE_DRAFT_v01, with attribution/reference attributes. Original copies preserved. These imports are Creator Store models, not cross-owner private inventory transfers. No paid purchases or inference spend.

Saved live screenshot: ../../assets/studio-import-batch/store-torii-adapted.jpg. Other overview/mask/rig screenshots reviewed through native MCP session images. Mask fronts remain flat/oversimplified; Oni is ivory rather than the approved red demonic face. No final visual parity approval.

## NPC and Shinobi blockers
Converted the three already source-controlled STATIC_DRAFT_v02 guide OBJ/MTL assets to GLBs using tools/prepare_studio_asset_batch.js --npcs. Six/five/six material primitives, 132/144/144 triangles, 420 total; hashes in npc-manifest.json. This is a format conversion, not recovery of earlier offline versions. No rig or animations added.

Automatic approval review rejected uploading DojoMentor GLB to Roblox Open Cloud, stating external cloud payload authorization was insufficient. Upload was not retried by another route. BambooScout and CityArchivist uploads were not attempted. User approval for these three exact payloads to Roblox creator 1559243747 is pending.

Original Shinobi #21 GLB, the consolidated 13-model archive, auxiliary tools and newly documented modular costume ZIP remain unavailable in this checkout. The referenced chat returns unresolved content-reference markers and no attachments. Do not claim imported Shinobi or replace it with the Store samurai.

## Performance, preservation and save limits
Edit-session memory observed 1813.06 MB (whole Studio session, not this batch's incremental cost); Workspace had 804 descendants before the adapted torii copy. No FPS, draw-call, mobile, two-client or runtime benchmark. Bamboo alone has 125 MeshParts; merge compatible materials/components and use LOD before production placement. All assets remain staging drafts.

No gameplay LuaSourceContainer writes performed and git diff -- src is empty. Raw script before/after responses matched but hit output limits, so a complete source-hash comparison is not claimed. No models added under auto-activation KageboundArt/KageboundWorldArt folders. Cloud save/publish and close/reopen persistence were not verified. Package IDs are persistent uploads from earlier work; live arrangement/material repairs must be saved separately. Rojo source-only project does not serialize the staging models. Reinsert recorded package IDs and run the checked-in validator with primitive-specs.json to reproduce the 22-model staging repair.

## GitHub update review
Fetched main a1bd91135f6a27cb9109e6c3a4b1647a0ba4da0d. Since 1934c54: bb49b43 adds Shogun v09 generator; 5a9b207 build workflow; 59ddb45 optional placement; a1bd911 records five offline Shinobi accessory drafts. The placement script only activates with ServerStorage/KageboundWorldArt and WorldConfig enabled. It places 11 prefab instances from eight names. Existing greybox collision remains authoritative.

Fixed two verified build-check defects without gameplay changes: Shogun workflow double-prefixed root/path; source integrity checker expected old assetRegistry variable/literal rather than current registry + variant expression. Source integrity now passes; eight OBJ checks pass. Full Shogun Python build not executed locally because trimesh is unavailable. Its workflow runs on the workflow change and must be checked independently.

Placement review finding: src/server/ShogunWorldArtV09.server.lua parents clone into world before sanitizing and never clears CanQuery or quarantines embedded code. Only trusted original, pre-sanitized prefabs may enter that auto-activation folder. Keep Store candidates isolated until that path is hardened; no gameplay-script patch made in this asset pass.
