# Automated asset pipeline — KAGEBOUND

**Owner:** personal Roblox account `1559243747`.
**GitHub:** main branch, `.github/workflows/runtime-asset-sync.yml`.

## What runs automatically
1. Any new or changed files under `assets/` on `main` trigger catalog regeneration.
2. `scripts/build_asset_catalog.py` indexes historical and new PNG/JPG/WEBP, OBJ/GLB/FBX and other supported source files with SHA256.
3. Only **runtime PNG files under `assets/ui/` and `assets/vfx/`** are automatically uploaded to Roblox. Original concept images and mesh source files are retained as references, not mislabeled as finished game assets.
4. `scripts/publish_runtime_assets.py` uploads eligible PNGs via Open Cloud and polls for confirmed asset IDs; existing same-hash IDs are reused.
5. `scripts/build_runtime_registry.py` generates `src/shared/RuntimeAssetRegistry.lua` from confirmed IDs.
6. `src/client/RuntimeAssetQuickbar.client.lua` uses the runtime registry for weapon, Kitsune and Veilfall icon imagery; it falls back to native text when asset IDs are unavailable.
7. The existing OpenArt icon import workflow commits PNGs to `assets/ui/icons/v01/`, which triggers the unified publisher.

## Previously created assets
- `assets/concept-art/`: approved ART-001..004; indexed as art references, never automatically published as in-game sprites.
- `assets/concept-sheets/vfx-v01/` and `assets/concept-sheets/clan-vfx-v01/`: original VFX concept references, indexed but **not** usable flipbooks until converted into properly transparent runtime sprites.
- `assets/ui/icons/v01/`: generated 16-icon atlas and slices; runtime icon PNGs eligible for upload.
- Any committed `assets/vfx/**/*.png`: eligible for runtime upload. Flipbook animations must additionally have timing, frame count, and emitter implementation.
- Meshes / models / animations: source-tracked only; Roblox Open Cloud image uploader does not magically convert these to validated Roblox MeshParts, rigged avatars, or Animation IDs. These require a dedicated verified importer and in-game placement.

## New asset production convention
- Place final UI icon PNGs under `assets/ui/<collection>/<version>/`.
- Place game-ready transparent VFX sprites under `assets/vfx/<family>/<version>/`.
- Keep reference images in `assets/concept-art/` or `assets/concept-sheets/`.
- Commit source files to main. Do not manually enter Roblox asset IDs.
- Runtime image references use `RuntimeAssetRegistry.get("ui.icons.v01.kitsune")` or corresponding relative asset key.
- Never store API keys in GitHub files; `ROBLOX_OPEN_CLOUD_API_KEY` must be a repository Actions secret.

## Security and validation
- Roblox creator must have upload permission and experience access to the images.
- Upload completion is not moderation approval. Confirm image usability in Studio.
- Auto-publishing is limited to designated runtime folders to prevent concept images or unsafe/unfinished artwork being pushed to Roblox.
- No claims of full integration without successful workflow run, Roblox asset IDs, Rojo sync and Studio visual QA.
- GitHub Actions permission and branch protection must permit bot commits, or the job must be adjusted to open a PR.
- If a run fails, inspect Actions logs; the system is fail-closed rather than assigning invented IDs.

## Remaining asset classes
- 3D: create a dedicated asset-pack build and Roblox mesh-import workflow with pivot, scale, collision, texture and permission verification.
- Animations: rig-specific animation authoring, Roblox publishing and server/client animation mapping.
- VFX: source sprites to runtime flipbooks, emitter configuration, LOD and timing.
- Sound: rights-safe source, Roblox audio permissions and runtime registry.
- Studio QA: avatar fit, hitboxes, replication, performance, controller/mobile.
