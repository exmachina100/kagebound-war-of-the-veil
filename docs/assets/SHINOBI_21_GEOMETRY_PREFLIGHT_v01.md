# Shinobi #21 — static GLB geometry preflight (2026-11-10)

Asset: `KGB_CHAR_Shinobi_Default_BLOCKOUT_v01.glb`. Source archive: `KAGEBOUND_Shinobi_Blockout_v01.zip` (conversation artifact, **not yet on GitHub**). Approved design anchors: ART-001 and ART-002; actual pixel-level comparison is still pending.

## Inspected geometry
- Reproducible Python generator: `kagebound_shinobi/generate_shinobi.py`, using trimesh/numpy.
- 40 distinct meshes, 1,428 triangles, GLB file 38,404 bytes. Source package includes generator and README.
- Y-up, -Z front, ground-origin; bounds X approximately -1.31 to 1.31, Y 0.015 to 5.834, Z -0.695 to 0.609.
- Seven vertex-color groups: ink, armor, edge, red, gold, ivory, hair.
- Previous run reports GLB reimport, watertight submeshes, and no degenerate faces. This does **not** imply union watertightness: intersecting separate parts are not Boolean-joined.

## Authoring gaps identified
1. Geometry is **not skinned**: no armature, joints, weights, animation tracks, or R15 Humanoid mapping.
2. Fox mask is a decorative hip attachment; it is **not** a wearable fitted mask. Preserve this distinction in naming and gameplay handoff.
3. No UV atlas; vertex colors may not survive Roblox material conversion without additional authoring.
4. Shoulder, elbow, hip, knee and wrist geometry must be split/weighted and tested for deformation before any rig-ready claim.
5. Current origin is ground-center rather than a verified HumanoidRootPart pivot; do not apply as an automatic avatar replacement.
6. Actual ART-001/002 PNG visual side-by-side and Roblox Studio import, materials, scale, camera silhouette and mobile QA are all outstanding.

## Handoff
1. Extract the existing ZIP without modifying original approved PNGs.
2. Import the GLB into Blender, compare front/side/back silhouette against the actual ART-002 board, and record deviations.
3. Preserve static geometry as v01; create v02 as a new version with R15-compatible rig, UV/material pass and explicit transform mapping.
4. Export skinned GLB or FBX only after real bone/weight inspection; then test import into Studio.
5. Keep gameplay scripts untouched; the main gameplay lane owns runtime replacement.

**Status:** 3d-draft, offline binary pending repository upload. **Not** imported, rigged, gameplay-QA'd or approved.
