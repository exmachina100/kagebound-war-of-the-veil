# KAGEBOUND — Studio import handoff for 13 verified static 3D drafts (2026-11-12)

**Asset lane only.** No gameplay scripts, Roblox Studio scene, or published Roblox IDs were changed. Existing sources preserved.

## Exported and independently reimported assets
| Group | Asset | Triangles | Closed mesh components |
|---|---|---:|---:|
| Character | Shinobi #21 static UV v02 | 1428 | 40/40 |
| Grand World | Dojo Mentor | 204 | 17/17 |
| Grand World | Bamboo Scout | 268 | 17/17 |
| Grand World | City Archivist | 204 | 17/17 |
| Weapon | Naginata UV v02 | 212 | 9/9 |
| Weapon | Yari UV v02 | 180 | 8/8 |
| Weapon | Kanabo UV v02 | 672 | 46/46 |
| Weapon | Kusarigama UV v02 | 504 | 13/13 |
| Weapon | Yumi UV v02 | 484 | 11/11 |
| Mask | Kitsune UV v02 | 760 | 8/8 |
| Mask | Oni UV v02 | 572 | 8/8 |
| Mask | Tengu UV v02 | 592 | 6/6 |
| Yokai | Lantern Yokai UV v02 | 716 | 10/10 |
| **Total** | **13 assets** | **6796** | **210/210** |

Local archive: `/mnt/data/KAGEBOUND_Studio_Import_Handoff_20261112.zip`. Contains **13 GLB, 13 newly exported OBJ fallback meshes**, exported MTL/textures as applicable, `validation.json`, and `README.md`. The local reproducible assembly script is `/mnt/data/build_kagebound_studio_handoff.py`. Source GLBs came from the prior verified conversation archives; the GLB bytes are preserved, not new visual revisions.

### Studio steps (pending, NOT performed)
1. Import GLB via Studio 3D Importer, one at a time, into a new staging folder. OBJ fallback if necessary.
2. Compare visual silhouettes against **actual** approved ART-001..004 images. Current GitHub file API confirms PNG SHAs but returns empty image bytes, so comparison is **blocked**.
3. Validate Y-up/-Z facing, ground origin, real stud scale, grip pivots, materials, collisions and device performance.
4. Shinobi, Yokai and guide NPCs are **static, unrigged**. Masks are not yet R15 head fitted.
5. Record screenshots, Studio mesh IDs and successful imports before any asset is promoted from `3d-draft`.

The 210 watertight results are **per mesh component**, not Boolean-unioned assemblies. No degenerate faces detected in the reimported 13 GLBs. **Binary upload to GitHub main pending**. No paid credits consumed. Veilblade #24, Nodachi and Tanto existing source-controlled OBJ drafts remain unchanged.
