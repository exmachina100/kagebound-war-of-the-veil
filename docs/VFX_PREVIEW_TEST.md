# KAGEBOUND — Studio VFX Preview / Multiplayer Readability QA

## Purpose
A **local-only** Studio VFX preview evaluates four original warrior-style effects and three mythic masks in Kage Dojo without granting an ability, altering player style or damaging characters. This is NOT a new public feature; `src/client/VFXPreview.client.lua` exits outside Studio.

## Preview steps
1. Update local clone using `git pull origin main` and `rojo serve default.project.json`; reconnect Roblox Studio.
2. In Studio Play, at Kage Dojo press **P** to show the VFX toolbar (top-left).
3. Buttons: Shinobi, Ronin, Onmyoji, Oni Disciple, Kitsune, Oni, Tengu, Parry.
4. Click each separately. Previews are local cosmetic effects; real multiplayer damage and the selected WarriorStyle attribute are unchanged.
5. Exit the Kage Dojo safe zone; the debug preview should refuse new effects.
6. Compare each effect to its uploaded concept PNG under `assets/concept-sheets/clan-vfx-v01/` and original ART-001..004.
7. Run `tests/VFXPreview.client.lua` from the Studio CLIENT Command Bar to verify all eight buttons.
8. Run `tests/VFXProfiles.studio.lua`, `tests/VFXTextureCatalog.studio.lua` and `tests/EnemyDamage.studio.lua` from the Studio SERVER Command Bar. These are source contracts, not full gameplay tests.
9. Test with two players: legitimate server-triggered VFX should display for both, but local debug previews must not replicate or damage either player.
10. Test touch/mobile graphics, overdraw and FPS: the geometry renderer has caps of 105 local active parts on touch and 260 desktop; these are not proven production performance budgets.

## Texture stage
- Generated alpha flipbooks are in the verified conversation artifact `KAGEBOUND_VFX_Flipbooks_v01.zip`.
- Upload seven PNGs through Studio Asset Manager and register REAL approved IDs in `src/shared/VFXTextureCatalog.lua`; see `docs/VFX_FLIPBOOK_IMPORT.md`.
- Blank IDs safely keep the local neon-geometry fallback. They should not cause warnings, broken particle textures or gameplay failures.
- Binary atlases are not yet verified on GitHub or as Roblox uploaded assets. Final animation/visual parity is pending.

## Limits
The preview does NOT implement the six conceptual abilities depicted for Ronin, Onmyoji or Oni Disciple. Actual gameplay now also includes one original server-controlled starter active for **each of four styles**, alongside server-validated Shinobi/Veilblade melee, the three mask actives, Shadow Duel and basic Yokai PvE; see [FOUR_WARRIORS_TEST.md](FOUR_WARRIORS_TEST.md). Visual proof is not gameplay feature proof.