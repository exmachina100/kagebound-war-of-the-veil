# KAGEBOUND v07 — Studio import and runtime placement

The six original v07 assets have editable OBJ files and embedded glTF 2.0 LOD0/LOD1 variants in this directory. The glTF materials use PBR base-color factors; they are **not** authored photographic texture maps. Do not label these as final textured production assets.

## Prefab import
1. In Studio, import each `*_lod0.gltf` via the 3D Importer. Inspect axis orientation, normal direction and material appearance before saving.
2. Assemble a Model with each of these exact names: `dojo_komainu_plinth`, `dojo_suspended_bell`, `dojo_ritual_banner`, `moonfall_bamboo_fan`, `moonfall_stepping_stones`, `moonfall_lantern_arch`.
3. Set each Model's pivot to its ground center (Y=0 in source space), verify source scale and place all six in `ServerStorage/KageboundWorldArt`.
4. `src/server/WorldArtV07.server.lua` places ten instances across Kage Dojo and Moonfall Bamboo, and skips missing models safely. The existing greybox retains collision authority.
5. Do not use mesh collision as gameplay authority. `collision_proxies.json` contains provisional local-space authoring volumes. Validate navigation before creating anchored invisible collision Parts.
6. Compare in-game Studio screenshots with ART-001 and ART-004, especially material hierarchy, silhouette, moonlit readability and mobile quality. Record visual deviations.
7. Import LOD1 manually for distant scenery only after confirming that its reduced geometry retains silhouette.
8. Check streaming, frame time, triangle budget, occlusion, walkability and spawn visibility.

No Roblox IDs, Studio import success, screenshot parity or collision QA are claimed by this source handoff.
