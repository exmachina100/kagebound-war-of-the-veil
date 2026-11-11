# World Art Placement — Studio integration gate

Source loader: `src/server/WorldAssetIntegration.server.lua`. This is **cosmetic integration**, not a runtime mesh importer. OBJ/GLB binaries in GitHub do not automatically become Roblox MeshParts through Rojo.

## Import and placement

1. Import each of the eight exports from `assets/world/dojo-moonfall/v01/` using Roblox Studio 3D Importer. Review materials, scale, orientation, pivots and normals. Do not claim an asset ID before Roblox provides one.
2. Create `ServerStorage/KageboundArt/WorldEnvironment` and store imported Models/MeshParts with these **exact** names:
   - `KageDojoShrine`
   - `DojoRitualAltar`
   - `DojoClanBanner`
   - `MoonfallBambooCluster`
   - `MoonfallBridge`
   - `MoonfallStonePath`
   - `MoonfallToriiGate`
   - `ShrineStoneLantern`
3. After Grand World has generated, create `Workspace/KageboundWorld/ArtPlacementAnchors`. Add eight anchored, transparent, noncolliding BaseParts named exactly as above. Their **CFrame** specifies final model pivot and rotation; position them manually against the actual generated world and approved ART-001..004.
4. Start a new Play session after saving anchors and templates in the place. The loader clones only valid models with at least one BasePart into `KageboundWorld/ImportedWorldArt`.
5. Inspect placement, occlusion, lighting, silhouette and scale in Studio. Decorative clones have collision/touch/query disabled; existing bridge and world gameplay geometry is deliberately retained.
6. Confirm missing templates/anchors do not break startup, duplicate copies are not created, and a two-player session can cross the Moonfall bridge and activate Veilfall.
7. Check mobile graphics and frame rate. Record screenshots and actual uploaded MeshIds in the asset manifest.

## Acceptance criteria

- Eight correctly named imported templates and eight corresponding placed anchors.
- Exactly eight cosmetic clones after fresh Play; none if templates/anchors absent.
- No altered gameplay collision, bridge hitboxes, server damage or quest triggers.
- ART-001..004 visual review and Studio two-player/mobile checks recorded.

**Not verified by this commit:** Studio imports, real MeshIds, final CFrames, material fidelity, screenshots or runtime QA. Do not call this a completed world art pass until those gates pass.
