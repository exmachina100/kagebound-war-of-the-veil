# Closed polearm drafts v02 — not Studio imported

Source: the repository's original Naginata/Yari v01 OBJ files, not the missing
chat ZIP variants. ART-003 was opened for review on 2026-11-12. These simplified
silhouettes still need artist refinement; Naginata's blade is not yet the
reference's sweeping curved form.

Rebuild from repo root: `python tools/close_polearm_drafts.py`.
Check: `node tools/check_kagebound_obj.js`.
Per-component closure, winding, volume, source and output hashes are recorded
in `POLEARMS_v02_validation.json`. Five Naginata solids / 120 triangles; six
Yari solids / 168 triangles. No new UVs, textures, rig, animation or union.

Both models retain source origin (0,0,0) at the shaft grip, +Y blade axis;
Naginata source height is 8.9 units and Yari 9.2 units. These are **not verified
Studio stud sizes**. Keep each matching MTL beside its OBJ for import.

Import to a separate staging folder first. Inspect real MeshParts, material
transfer, face visibility, scale beside an R15 hand/body, pivot at source origin,
and first/third person wielding. Keep decorations noncolliding, massless and
nonqueryable when mounted. Do not change authoritative hitboxes to match art.

Only after successful grip/scale checks use `NaginataVisual` / `YariVisual`
under `ServerStorage/KageboundArt`; existing scripts automatically consume these
names. Two-client combat, animation, screenshot comparison to ART-003 and mobile
checks remain outstanding. Original v01 files and gameplay sources are preserved.
