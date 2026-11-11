# KAGEBOUND asset continuation audit — 2026-11-12

## Evidence and review limits

Repository baseline: `ad0a4958853f0ec0b8f7667a36b6c7c9e6069218` on main.
Read canonical game, world, art, style, manifest, creation/import workflow,
weapon parity, production queue and character-lane documents. No AGENTS.md
was found in this checkout. Opened all four original ART-001..004 PNGs locally.
The references show blocky layered armor, pointed hair, a red scarf, ivory fox
mask, dark tapered blades with crimson/magenta edges and gold fittings; the
world uses warm lanterns against moonlit violet shrines. Opening these images
is reference review, not final mesh appearance approval.

`read_thread` for conversation `6af29819-bdf8-83ee-83de-8ef4839b6d12`
returned three turns, no older cursor and no attachments. Several assistant
replies are unresolved `chatgpt-content-reference` markers. Two full replies
describe the three-weapon and six-asset ZIP batches. The entire original
conversation and every archive could **not** be reviewed through that response.
Chat `sandbox:/mnt/data/...` links are not local filesystem paths here.

Local Downloads contains two identical starter archives (19 entries each):
`KAGEBOUND_Repo_Starter.zip` and `KAGEBOUND_Repo_Starter (1).zip`, SHA-256
`1b10ec9ca44ca4a45b44b8ccfc3dca04f68be1fe9eb1bfb9fc1b434a9c84daf1`.
Inventoried both: docs, seven concept PNGs and starter scripts; no 3D models.
No KAGEBOUND ZIP was found under the local Documents/ChatGPT tree.

Still unavailable for content/hash/geometry inspection:

- KAGEBOUND_Veilblade_v01_3D_Prototype.zip
- KAGEBOUND_Shinobi_Blockout_v01.zip
- KAGEBOUND_Shinobi_UV_Blockout_v02.zip
- KAGEBOUND_Weapon_Batch_Naginata_Yari_Kanabo_v01.zip
- KAGEBOUND_Asset_Batch_Kusarigama_Yumi_Masks_Yokai_20261111.zip
- KAGEBOUND_Nine_Asset_UV_Drafts_v02.zip
- KAGEBOUND_GrandWorld_Three_Guide_NPCs_v01.zip
- KAGEBOUND_VFX_ConceptPack_v01.zip and KAGEBOUND_VFX_Flipbooks_v01.zip

These names are prior queue records, not newly verified deliverables. Recover
the actual archives from the originating chat before importing or replacing
their Shinobi, masks, Yokai or guide assets. Preserve every earlier version.

## Live Studio observations

Connected instance: `c05fc032-97b5-4e1b-aa40-f3e5188bd4ad`, named KAGEBOUND,
place ID `92077795105213`. Observed Play mode, Client and Server models.
Read-only server inspection found ServerStorage empty; KageboundServer had
36 descendants, KageboundShared 22, KageboundWorld 507, Guides 15, Enemies 33.
These are runtime observations, not an audit of the underlying Edit model.
Captured viewport `KAGEBOUND_before_asset_work`: dark procedural dojo/torii,
warm block lanterns and overlapping HUD panels. No new imported mesh observed.

MCP provides execute/inspect, screen capture, play control, mesh/procedural/avatar
generation and avatar setup. No dedicated local-file import tool was exposed.
`StudioService.Import3D` and `Import3DAsync` both reported invalid members.
Desktop importer fallback initialization failed with
`Cannot read package config \\?\C:\package.json: operation not permitted`,
including retry after a JavaScript-kernel reset. No Windows UI input occurred.
Target confirmation to stop Play and modify this specific place was requested
because the Studio listing tool requires target confirmation before modifying
a game; no target-changing action was taken during this audit.

**Studio import count this pass: 0.** No edit-mode model creation, gameplay script
change, save/publish, new MeshId, fitted mask, rig or pivot/scale verification.
No two-client, mobile or final visual QA. Paid generation spend: zero.

## Source geometry repair batch

Expanded `tools/check_kagebound_obj.js` from two to all existing weapon drafts
plus two new closed versions and the original practice post. Basic finite,
index, triangle-area, material and budget checks pass. Those basic checks alone
do not detect open surfaces.

Direct edge inspection found Naginata v01 has 67 boundary edges and Yari v01
96. These repository variants have 71 and 96 triangles respectively; they are
**not** the unavailable chat ZIP's reported 212/180-triangle variants.

`tools/close_polearm_drafts.py` preserves v01 and deterministically closes the
planar convex boundary loops, separates connected solids and corrects winding.
No original vertex positions, material palette, bounds or source origin changed.

| New draft | Vertices | Triangles | Closed components | Bounds X / Y / Z |
| --- | ---: | ---: | ---: | --- |
| KGB_WPN_Naginata_CLOSED_DRAFT_v02.obj | 70 | 120 | 5 | -0.23..0.47 / -3.3..5.6 / -0.23..0.23 |
| KGB_WPN_Yari_CLOSED_DRAFT_v02.obj | 96 | 168 | 6 | -0.32..0.32 / -3.3..5.9 / -0.32..0.32 |

Both have matching MTL files and hashes/component volumes in
`assets/roblox-ready/weapons/POLEARMS_v02_validation.json`. Every component has
two incident faces per edge, paired opposite directed edges and positive signed
volume; independent OBJ checker finds no degenerate triangles. Components still
overlap; not Boolean-unioned, UV textured, rigged, artist-approved or imported.
The Naginata retains the simplified straight triangular v01 profile, which
needs silhouette refinement against ART-003's curved blade. Yari is a simplified
spear, missing the board's elaborate blade, ribbons and edge treatment.

## Next import batch and gates

1. Confirm the connected target, stop Play, inspect Edit and baseline gameplay
   script source before mutation. Recover a working desktop importer or another
   supported local-mesh ingestion route.
2. Import available Veilblade/Nodachi/Tanto and closed polearm drafts into an
   isolated staging folder. Preserve cosmetic fallback and all gameplay sources.
   Keep drafts out of `ServerStorage/KageboundArt` until grip/scale review:
   existing equipment scripts automatically activate exact template names there.
3. Verify actual MeshParts/IDs, materials, source-space origin, +Y blade direction,
   measured studs, pivots and wielding. Current source heights range from Tanto
   1.94 to Yari 9.2 units; source units are not verified Studio studs.
4. Recover archived Shinobi/masks/NPC source, compare to ART-001/002/003, then
   import separate batches and verify R15 head/limb fit, rig weights if present,
   NPC ground pivots and both gameplay-distance and close-up screenshots.
5. Record Edit and two-client evidence, device/graphics checks, save state and
   actual uploaded IDs before advancing to imported/gameplay-qa/visual-qa.

All assets remain drafts. Gameplay code, approved PNGs and v01 geometry unchanged.
