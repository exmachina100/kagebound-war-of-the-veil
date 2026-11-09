# KAGEBOUND — First original mesh import handoff (batch 2026-11-10)

**Status:** two true low-poly geometry exports + matching MTL files **committed to GitHub main and statically checked**, not yet imported into Roblox Studio, rigged, or approved against screenshots. These are **original parametric models** authored from approved KAGEBOUND visual direction; they are not a 3D AI reconstruction of the OpenArt turnaround. The existing ART-003 OpenArt 2K turnaround is the visual reference, not geometry source.

## Files actually present
| Asset | File | Materials | Vertices | Triangles | Origin / bounds |
| --- | --- | --- | ---: | ---: | --- |
| KGB_WPN_Veilblade_Default_GAME_v02 | `assets/roblox-ready/weapons/KGB_WPN_Veilblade_Default_GAME_v02.obj` + same-base `.mtl` | Ink, Gold, Crimson, HotPink, Ivory | 668 | 1220 | Grip around (0,0,0). Bounding X -0.76..1.085, Y -2.72..6.01, Z -0.76..0.76 |
| KGB_PROP_DojoPracticePost_Default_GAME_v01 | `assets/roblox-ready/environment/KGB_PROP_DojoPracticePost_Default_GAME_v01.obj` + same-base `.mtl` | Stone, Gold, Ink, Graphite, Crimson, Ivory, Violet | 184 | 296 | Ground near Y=0; X/Z ±2.2, height 5.0 |

Material numbers in MTL are prototype color assignments. Imported Roblox materials/UVs are **not** verified and may need hand re-assignment in Studio or Blender. Weapon blade has dark body, pink edge, gold tsuba, wrap and tassel. Practice post has an ivory fox-mask, crimson bands and a spirit core.

## Rebuild and static preflight
On a machine with **Node.js**:
```powershell
git pull origin main
node tools/generate_kagebound_obj.js
node tools/check_kagebound_obj.js
```
The generator is deterministic and emits both OBJ and MTL files. The checker verifies finite vertices, existing face indices, nondegenerate triangles, declared material names and asset-specific poly budgets. It **does not** prove manifold/watertight solids, acceptable normals, Studio material appearance or physical gameplay behavior. Later run Blender/trimesh checks as appropriate and compare renders to approved ART-003/004.

## Import procedure for Veilblade
1. In Roblox Studio, use the 3D Importer to select `KGB_WPN_Veilblade_Default_GAME_v02.obj` with its same-directory `.mtl`. Preserve the distinct mesh/material components where importer permits.
2. Inspect size, handedness, blade silhouette, gold guard, fox omamori and crimson/magenta treatment. Reassign material/color manually if the OBJ/MTL colors do not transfer. **Do not** blindly rescale or rotate as this will affect grip alignment.
3. Group the imported MeshParts into a `Model` named exactly **`VeilbladeVisual`**. Ensure its **pivot is the handle's grip center**, the model's original OBJ (0,0,0). If the importer recenters the model, use Studio Pivot tools to restore this. Its blade should extend toward local +Y.
4. Create `ServerStorage/KageboundArt` (Folder) if it does not exist; put `VeilbladeVisual` in that Folder. This template is a **Studio object** and is not synchronized by the current source-only Rojo project.
5. The existing `src/server/Veilblade.server.lua` now detects the model and welds all imported pieces to the Tool Handle, disables their collisions/touch/queries, hides procedural visual parts but leaves the invisible blade Trail anchor and combat Tool intact. Without the model, the old working procedural sword remains visible.
6. Run `tests/ImportedVeilblade.studio.lua` in Studio SERVER Command Bar. Then play two players: verify Tool auto-equip and hand orientation, no duplicate blade, no collision, slash trail on authorized Swing and no damage while unequipped.
7. Record the actual Roblox asset IDs, imported component count, screenshot links and tested device details in `docs/ASSET_MANIFEST.md`. Do not invent IDs.

## Import procedure for Dojo practice post
1. Import `KGB_PROP_DojoPracticePost_Default_GAME_v01.obj` and associated `.mtl` using Studio's 3D Importer. Verify intended height about 5 studs plus ground placement offset.
2. Group MeshParts into **`DojoPracticePostVisual`** Model and set the **pivot near the base at original (0,0,0)**. Place it in `ServerStorage/KageboundArt`.
3. The existing `src/server/DojoTraining.server.lua` detects the template; for each of three posts it clones the imported visual, disables all collision and query flags, hides the older ceremonial visual blocks, and retains the invisible server hitbox and BillboardGui for HP/hit count. If no template exists, it keeps the procedural practice posts.
4. Run a two-player Dojo test using `docs/DOJO_TRAINING_TEST.md`: practice targets should lose 120 HP to accepted sword hits, recover after defeat, **never damage other players** in the SafeHub, and award no Spirit Shards or mastery.

## Roblox production gates
- **G4** true editable mesh geometry exists: PASS (OBJ/MTL).
- **G5** source+basic static geometry checks: PASS; mesh cleanup, normals/winding and Blender quality review PENDING.
- **G6** Studio import / real uploaded MeshId: PENDING.
- **G7** R15/other avatar grip alignment, 2-player damage, mobile performance, scene screenshot parity: PENDING.
- **G8** approved and signed-off import: PENDING.

Do not replace gameplay collision, hitboxes or server-controlled damage on the basis of cosmetic assets. After Studio visual validation, optimize materials and consider exporting a combined or rigged GLB/FBX if needed. **Neither of these static OBJs is a rigged character animation.**

Roblox documentation:
- https://create.roblox.com/docs/studio/importer
- https://create.roblox.com/docs/art/modeling/specifications

GitHub issue gates: Veilblade #24, Shinobi/weapon assets #21, Dojo QA #23.
