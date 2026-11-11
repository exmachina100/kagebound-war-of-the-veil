# KAGEBOUND v05 world art import
- Source: scripts/build_world_kit_v05.py; rebuild with `pip install trimesh numpy pillow`.
- Each asset has `_lod0.glb`, `_lod1.glb` and editable OBJ. Use GLB for vertex colors.
- Ground pivot at Y=0, positive Y up. Import through Studio 3D Importer; do not assume automatic upload.
- Mesh visuals: CanCollide=false, Anchored=true. Implement manifest proxy volumes as transparent anchored Parts.
- Verify collision, scale, normals, traversal, textures and silhouette against ART-001/004.
- Atlas is a palette reference, not a UV texture applied to GLBs; vertex colors provide base colors.
- No Studio test or Roblox asset IDs have been verified.
