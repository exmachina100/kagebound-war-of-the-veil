# v06 Studio integration handoff
1. In Roblox Studio import each *_lod0.gltf from this directory using 3D Importer.
2. Group imported MeshParts into Models named exactly dojo_fox_emblem_gate, moonfall_moss_rock_arch, dojo_kitsune_shrine_altar, moonfall_spirit_waystone.
3. Check source up-axis, scale and pivot at ground level (Y=0); correct any importer axis conversion in Studio.
4. Move models into ServerStorage/KageboundWorldArt.
5. src/server/WorldArtIntegration.server.lua will place six visuals in Kage Dojo/Moonfall while preserving greybox collision. Missing prefabs are skipped.
6. Review intersections with existing torii and props; remove overlapping greybox *visuals* only after comparing approved ART-001/004.
7. Convert collision_proxies.json volumes to invisible anchored Parts when collision is validated. Do not enable arbitrary mesh collision.
8. Test mobile FPS, camera visibility, navigation and material fidelity. No Roblox asset IDs or Studio QA claimed.
