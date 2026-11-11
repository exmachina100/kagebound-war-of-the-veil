# KAGEBOUND world v04 — import and placement

Original Kage Dojo / Moonfall production-source geometry. Reference anchors ART-001 and ART-004; not approved in Studio.

Each named asset has a standalone embedded-buffer glTF and an OBJ with shared materials.mtl. All mesh coordinates are Y-up and approximate Roblox studs, with ground pivot at Y=0. OBJ and glTF carry authored UV0. glTF carries embedded PBR base colors, not baked texture maps. No external textures are needed for glTF color preview.

Import each glTF in Blender or another verified DCC, confirm material slots and normals, and export as FBX or GLB if Roblox Studio's current importer requires it. Do not assume direct glTF support in Studio. Preserve pivots and inspect in-game silhouette against ART-001/004. Author Studio MeshParts with CanCollide=false; use anchored transparent collision proxies defined in collision_proxies.json, then adjust them manually for gameplay clearance. These proxies are conservative rough volumes, NOT final collision QA.

Test player passage under torii, bamboo traversal and shrine entrance, inspect both mobile and desktop LOD, and do not publish models to Roblox until import, ownership and moderation are confirmed. No Roblox asset IDs have been assigned.

Production gaps: authored texture maps, dedicated LOD1/LOD2, optimized collision and Studio visual QA. Material colors are a first-pass palette only.
