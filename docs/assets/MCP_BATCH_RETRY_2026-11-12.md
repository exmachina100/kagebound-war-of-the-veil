# MCP batch retry — 2026-11-12

## Verified live execution

- Connected through Roblox Studio MCP to KAGEBOUND, place 92077795105213,
  universe 10775551787, creator/user 1559243747.
- Stopped Play and successfully queried the Edit model. Existing
  `ServerStorage/KageboundWorldV05` and `KageboundImportStaging` were preserved.
- Asset read/write scope probe returned HTTP 200. No uploads were attempted:
  confirmation of the approved upload folder is still pending.
- Started Play through MCP and ran the existing WeaponRules and MaskRules
  contracts against live server ModuleScripts: both passed.
- Studio output reported 30 smoke checks passed, 0 failed. Also observed
  repeated `cloud_2236283930.Vehicle Sim script:95` syntax errors and
  `rbxassetid://203785492` asset-type errors. These remain unresolved.
- Captured and inspected viewport `KAGEBOUND_pre_batch_20261112`: dark
  procedural dojo, magenta weapon, bright spawn surface and bottom HUD overlap.
  This is baseline evidence, not a screenshot of imported v07/v08 assets.
- Returned Studio to Edit. No new place save, publish or MeshId is claimed.

## Concrete prepared batch

Fetched and fast-forwarded local main from e9f717c to 8aeb846. The new
`tools/prepare_studio_asset_batch.js` prepares 22 uploadable GLBs under
`assets/studio-import-batch`, with source/output SHA-256, material metadata,
primitive counts and triangle counts in its manifest:

- Eight v08 LOD0 GLBs copied byte-for-byte, preserving embedded textures.
- Six v07 embedded glTF LOD0 files repackaged as GLB; geometry/material JSON
  and binary buffers preserved (only buffer URI removed).
- Five existing weapon OBJs and three mask OBJs converted with source vertex
  coordinates and face ordering preserved. OBJ sRGB Kd colors are converted
  to glTF linear base-color factors. These OBJs have plain materials, no maps.
- Original sources remain unchanged. No procedural replacement geometry.
- Converted OBJ inputs pass finite vertex, index and nondegenerate triangle
  checks; all 22 outputs fall below 20,000 triangles per primitive.
  This is not a watertightness, normal, visual, rigging or Studio import test.

Reproduce with `node tools/prepare_studio_asset_batch.js` from repo root.
The existing `node tools/check_kagebound_obj.js` passed its eight weapon/prop
checks. `node tools/check_source_integrity.js` fails on the pre-existing
`World sky registry key drift` assertion after the upstream WorldSky rewrite.
No assertion was weakened to conceal the failure. Python trimesh is absent.

## Remaining execution gate

The Roblox `rbx-import-asset` and `rbx-permissions` skills require confirmation
of an approved upload directory before any local file upload. Requested:
`C:\Users\Dell\Documents\ChatGPT\KAGEBOUND 01\repo\assets`.
Uploads will create permanent model assets under user 1559243747.

After confirmation, upload in world/weapon/mask batches, poll each operation
without duplicate uploads, insert into a separate staging folder and validate
geometry, texture transfer, dimensions, Y-up orientation and source pivots.
The v08 manifest uses approximate studs, so do not blindly apply a 1/0.28
scale factor. Masks face +Z in source and need explicit R15 fit review.
Do not activate gameplay template names until fit/scale checks pass. Save and
reopen/verify persistence before claiming a successful saved import.

**This retry imported zero models; 22 models are prepared, not Studio validated.**
