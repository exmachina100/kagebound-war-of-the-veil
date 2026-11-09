# KAGEBOUND — Transparent 4×4 VFX Flipbook Import v01

Seven **original 1024×1024 RGBA** textures (16 frames = 4 columns × 4 rows, 256 px/cell) were generated from approved KAGEBOUND style references, not cropped from full cinematic boards.

**Source:** current conversation package `KAGEBOUND_VFX_Flipbooks_v01.zip`; includes PNGs, manifest, actual editable `generate_flipbooks.py` source and README. **GitHub binary status: pending local upload** to `assets/vfx/flipbooks/v01/`. Roblox Asset Manager import status: pending. Do not replace catalog blanks with fake IDs.

## Actual texture filenames / manifest IDs

| ID in `src/shared/VFXTextureCatalog.lua` | PNG |
| --- | --- |
| Shinobi | KGB_VFX_Shinobi_Flipbook4x4_v01.png |
| Ronin | KGB_VFX_Ronin_Flipbook4x4_v01.png |
| Onmyoji | KGB_VFX_Onmyoji_Flipbook4x4_v01.png |
| Oni | KGB_VFX_Oni_Flipbook4x4_v01.png |
| Kitsune | KGB_VFX_Kitsune_Flipbook4x4_v01.png |
| Tengu | KGB_VFX_Tengu_Flipbook4x4_v01.png |
| Parry | KGB_VFX_Parry_Flipbook4x4_v01.png |

The Ono/Oni original class sheet uses the same red fracture visual family as the Oni mask but should get distinct later editions and actual silhouette tests.

## 1. Copy / commit source assets
Unzip into your local repo under `assets/vfx/flipbooks/v01/` including source and `manifest.json`. In PowerShell:

```powershell
git add assets/vfx/flipbooks/v01
git commit -m "Add original KAGEBOUND 4x4 RGBA VFX texture atlas exports"
git pull --rebase origin main
git push origin main
```

For GitHub to be considered synced, verify the seven PNGs actually appear at that path (same approach as `assets/concept-sheets/`).

## 2. Upload to Roblox Studio
- In your Roblox place, import each PNG using Asset Manager.
- Wait for moderation/processing as needed and confirm the resulting image asset is permitted for the experience.
- Record real numeric IDs from the resulting assets.
- Set these in `src/shared/VFXTextureCatalog.lua` (e.g. `Shinobi="123456789"`). Leave unuploaded slots `""`.
- Reconnect Rojo. The client `VFXSpriteEmitter.lua` uses `ParticleEmitter.FlipbookLayout=Grid4x4` and `FlipbookMode=OneShot` with one particle at a time on accepted Swing/Parry/Mask events.
- No uploaded ID? The `VFXFactory.lua` keeps rendering its geometry-based fallback, and no broken texture is presented.

## 3. Acceptance checks
- Studio Output: no Texture permission / missing asset warnings.
- Screenshot each flipbook at mid-animation in front of a dark part and inspect alpha. Flat opaque backgrounds are a failure.
- Confirm the four classes have distinct palettes/motifs and Shinobi mask VFX matches ART-001..004.
- Desktop + low-end mobile: the expensive particles are distance culled and supplemented by lower segment-count neon geometry; adjust to measured performance, not imagined figures.
- Verify a two-player scenario still computes all damage and hit eligibility solely on the server. SpriteEmitter emits visuals only, no gameplay messages.
- Test fallback with one or all catalog image IDs empty, and verify no infinite yield/errors.
- Run `tests/VFXProfiles.studio.lua` and `tests/VFXTextureCatalog.studio.lua` from the Studio SERVER Command Bar for contract-level checks. These do not constitute full gameplay testing.

## Further quality pass
These first flipbooks are **functional graphic prototypes**, with bright crescents/seals/wind/cracks. They are intentionally much simpler than the grand cinematic storyboard images; refine them with higher-detail alpha sprites, layered 3D energy ribbons, particle debris and class-specific animations rather than calling them final. Priority: Veilblade combo, blue parry, Kitsune effect, Oni shockwave, Tengu wind; then Ronin/Onmyoji/Oni Disciple skill sets as the server abilities are implemented.

## Official API
Roblox `ParticleEmitter` supports `FlipbookLayout=Grid4x4`, `FlipbookMode=OneShot` and animated transparent sprites: https://create.roblox.com/docs/reference/engine/classes/ParticleEmitter
