# KAGEBOUND — Asset Production Rules v1

This document is mandatory for each KAGEBOUND content milestone, alongside docs/GAME_DESIGN.md, docs/WORLD_VISION.md, docs/ROADMAP.md, docs/ART_DIRECTION.md, and docs/ASSET_MANIFEST.md.

## Canonical images
ART-001: approved key art. ART-002: four warrior designs. ART-003: weapons and masks. ART-004: Moonfall / dojo / Veilfall. All four original PNGs are in assets/concept-art/. Open the actual relevant image before asset generation; do not substitute generic Roblox or anime imagery.

## Standing rules
1. Retain the approved Japanese mythology, stylized Roblox silhouette and color language. Never copy models, animations, VFX or copyrighted material from the One Piece reference games.
2. Begin every **new** character, weapon, enemy or environment form with a reference-backed 2D concept or turnaround. Code-only geometry for testing is explicitly a greybox exception.
3. Create assets as gameplay advances: each major playable system receives associated visual work in the same or next development batch. Do not defer all artwork until launch.
4. Keep source images unchanged; give new files versioned names. Record generation provider, prompt, source IDs, selected image and original asset location.
5. A 2D concept, video, or Gaussian splat is not a usable Roblox 3D mesh. A real mesh must be exported, checked and imported.
6. Gameplay authority stays on the server. VFX and animation clips only communicate visual events, not hit damage, inventory changes or rewards.
7. Track each asset in docs/ASSET_PRODUCTION_QUEUE.md and docs/ASSET_MANIFEST.md with a GitHub issue and evidence of QA.
8. GitHub main is the source-code authority; Rojo syncs scripts, not Roblox Studio asset imports. Verify every binary upload and do not invent IDs or completed imports.

## Stage gates
| Stage | Deliverable | Approval condition |
| --- | --- | --- |
| G0 Brief | Asset ID, gameplay role, art anchors, scale, issue | Needed by current roadmap |
| G1 Visual reference | Actual approved PNG inspected and signatures recorded | Correct source used |
| G2 Image | OpenArt concept / multi-view / sprite sheet | Faithful silhouette and palette |
| G3 Selection | Approved design and variants | No uncontrolled style change |
| G4 Conversion | True geometry via capable 3D generator or modeling | Usable OBJ/FBX/GLB and source |
| G5 Cleanup | Blender topology, materials, pivots, UVs, attachment/rig | Roblox-oriented and efficient |
| G6 Import | Studio import, actual asset ID, collision, animations/VFX | Runs in game |
| G7 QA | Side-by-side screenshots against ART board; mobile + gameplay tests | Visual and function pass |
| G8 Archive | Source/export paths, provenance, SHA, issues, tests | Mark validated |

## Tool routing
OpenArt image models: reference-backed images, 3-view turnarounds, concept and texture sheets, 2D VFX and icons. Use image-to-image with the approved PNG as an actual image input when possible. Do not assume OpenArt image/video generation produces rigged meshes.

3D tools (when supported/connected): convert selected concept to an editable mesh. Blender/local mesh construction: topology, UV, pivots, shape cleanup, rigging and export. Roblox Studio: import as MeshPart/model, create and publish animation assets, test actual scale, physics and device budgets. GitHub: source, docs, scripts and verified binaries.

## Naming
Use KGB_CATEGORY_Name_Variant_STAGE_vNN. Examples: KGB_WPN_Veilblade_Default_CONCEPT_v01.png, KGB_WPN_Veilblade_Default_GAME_v01.glb, KGB_VFX_Parry_Default_SPRITE_v01.png.

Recommended folders: assets/concept-sheets, assets/characters, assets/weapons, assets/environment, assets/vfx, assets/ui, assets/3d-source, assets/roblox-ready, assets/templates.

## Recurring active-development cadence
At each significant gameplay implementation pass, select the highest-priority feasible art task that supports the feature. If a 3D tool or binary upload is not available, create a truthful blocked record and continue with a feasible image/VFX/geometry task; never claim an import that has not happened. This is a rule for work during active turns, not an unattended or periodic background process.

## Required status
backlog -> briefed -> concept-draft -> concept-approved -> 3d-draft -> game-prep -> imported -> gameplay-qa -> visual-qa -> validated. Use blocked or needs-revision when appropriate. Do not mark final until both gameplay and visual gates pass.
