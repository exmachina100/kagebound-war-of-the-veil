# Character / Weapon Asset Lane — coordination plan (2026-11-11)

This is an **asset-lane planning record**, not a claim that a new model was produced. Read with `GAME_DESIGN_ORIGINAL_338.md`, `WORLD_VISION.md`, `ART_DIRECTION.md`, `STYLE_GUIDE.md`, `ASSET_CREATION_WORKFLOW.md`, `ASSET_MANIFEST.md` and `ASSET_PRODUCTION_QUEUE.md`. Original ART-001..004 PNGs remain the authority; never replace them with stock art.

## Cross-thread dependency update
- Main gameplay has **five unverified playtest weapons** (Katana, Nodachi, Tanto, Naginata, Yari); Kanabo, Kusarigama and Yumi remain disabled. No imported weapon art/Studio QA inferred.
- Grand World P1 now has three guide NPC travel quests and session rewards; guide NPCs are currently procedural, so authored guide visuals are useful **after** the first combat-critical art handoff.
- Animation slots exist but owned/published clips are absent. The proposed separate animation automation was rejected at the five-active-task limit; do not imply it is operating.
- Environment/VFX production belongs to separate lanes; do not duplicate Moonfall kit or flipbook jobs.

## Exact one-asset-per-run queue
1. **Shinobi #21** (current active asset): retain v01 and v02 unchanged. Review exact ART-001/002 pixels, correct silhouette and UV/material fidelity, build a separately versioned R15-compatible *draft* with actual armature, weight validation, GLB/FBX reimport, triangle count, pivot and joint map. Do not label rigged without measured skin data. Existing v02 remains static 3d-draft, offline.
2. **Veilblade #24**: existing 1,220-triangle OBJ/MTL v02 on main is 3d-draft. Do not redo concept; prioritize Studio import handoff, grip alignment, visual silhouette against ART-003, and evidence. A Studio-only gate cannot be closed by source inspection.
3. **Kitsune wearable mask**: original low-poly watertight draft from ART-003, separate from Shinobi's decorative hip accessory; fit and head attachment/pivot documented.
4. **Lantern Yokai NPC**: rig-friendly mesh/LOD from existing original procedural enemy and approved motifs, without editing server behavior.
5. **Three Grand World guide NPC appearances**: each as its own asset/run; follow current world region and quest roles, not generic duplicated mannequins.
6. **Nodachi / Tanto / Naginata / Yari**: one asset/run, prioritize enabled playtest weapons; reuse approved weapon motifs, maintain authored geometry and hand pivots.
7. Remaining masks/warrior styles/heavy/ranged weapons according to actual current game demand.

## Delivery and verification gate
For each run: inspect main + relevant issue, choose **one** unmet asset/stage, preserve existing source, produce actual GLB/OBJ or genuinely rigged FBX/GLB with editable generator/source, validate reimport, mesh counts, watertightness/degenerates, UV/materials and scale/orientation; commit verified binaries and source where supported. Record exact path and commit SHA. If not pushed, mark **offline/pending**. Studio import, animation, two-player gameplay and mobile QA are separate explicit gates. No fake IDs or CI claims.

## Credit / lane boundaries
At most 30 OpenArt credits per run, preferably zero for already approved concept sheets; no paid 3D service or other build credits. Never modify `src/server`, `src/client` or combat gameplay scripts. Keep source PNGs immutable. One completed asset advancement per run, not simultaneous duplicates.
