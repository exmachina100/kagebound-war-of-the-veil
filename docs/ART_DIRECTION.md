# KAGEBOUND — APPROVED VISUAL LANGUAGE (MANDATORY)

**Status: DESIGN LOCK — apply to all future game visuals, Roblox props, models, animations, character skins, VFX, UI, cinematics and marketing renders.**

## Canonical reference hierarchy

Always open and inspect these **user-approved generated concept images** before producing a visual:
1. **Key art** (`assets/concept-art/ChatGPT Image Nov 9, 2026, 09_55_15 PM-1.png` (ART-001)) — overall world style, silhouettes, atmosphere and palette.
2. **Warrior style board** (`assets/concept-art/ChatGPT Image Nov 9, 2026, 09_55_24 PM-2.png` (ART-002)) — Shinobi, Ronin, Onmyoji, Oni Disciple and their proportions.
3. **Weapons and masks board** (`assets/concept-art/ChatGPT Image Nov 9, 2026, 09_55_30 PM-3.png` (ART-003)) — katana geometry, Kitsune / Oni / Tengu mask identity and material treatment.
4. **Environment / Veilfall board** (`assets/concept-art/ChatGPT Image Nov 9, 2026, 09_55_36 PM-4.png` (ART-004)) — Moonfall Bamboo arena, torii and shrine kits, Kage Dojo and sky-rift states.
5. **Gameplay VFX board** (`gameplay-vfx-abilities.png` planned) — attack trails, impact/parry effects, spirit attacks.
6. **Modular props / UI board** (`modular-assets-game-ui.png` planned) — reusable architecture and interaction UI.

The four approved PNGs ART-001..004 are uploaded on main under `assets/concept-art/` and recorded in `ASSET_MANIFEST.md`. Use them as visual anchors for every production pass. Supplementary VFX/UI reference boards remain pending; do not substitute generic assets.

## Style rules
- **Roblox-stylized, not photoreal:** recognizable blocky Roblox avatar proportions; layered low-poly or stylized sculpted armor and clothes; readable silhouettes at in-game camera distance.
- **High-fidelity anime-fantasy within Roblox constraints:** clean surfaces, strong material hierarchy, graphic cel-shaded accents, bold signature shapes and disciplined detail.
- **Japanese mythological identity:** shrines, torii, bamboo, stone pathways, lanterns, fox emblems, ceremonial ribbons, masks and spectral Veilfall architecture.
- **Color semantics:** ink charcoal base; crimson/pink for Shinobi attacks and Kitsune; slate/icy-blue for Ronin precision and parries; amethyst/violet for spirit magic and Veilfall; warm amber gold for lantern/world lighting; ivory for ritual/contrast.
- **Lighting:** moonlit indigo-purple ambience balanced with warm localized lanterns; clear separation between playable geometry and background atmosphere.
- **Animation + VFX:** energetic anime impact with readable silhouettes, narrow weapon arcs and short contact flashes; show collision timing correctly. Avoid full-screen effects obscuring PvP.
- **Environment:** layered vertical routes, torii gates and rocks, but maintain sightlines and consistent collision. During Veilfall, spectral paths appear with clear telegraphing.
- **UI:** clean legible fantasy game HUD with the same palette, avoid decorative overload and generic sci-fi controls.

## Asset creation workflow
1. Pick the relevant approved board(s) by explicit filename.
2. Identify the signature silhouette, color, materials, effects and scale from the image.
3. Write an asset-specific brief naming those anchor references.
4. Build concept -> Roblox importable mesh/texture or Luau/particle recipe -> place in Studio -> capture in-game screenshot.
5. Compare in-game screenshot **side by side** with the original reference; log deviations and fix before declaring polished.
6. Check silhouette clarity, animation timing, hitbox/collision, replication, mobile performance and low-fidelity graphics mode.
7. Record source, version, Roblox asset ID and verification results in the asset manifest.

## Current combat prototype
`src/server/MoonfallArena.server.lua` is the **greybox collision layout**. `src/server/MoonfallArt.server.lua` adds a first stylized pass based on ART-001 and ART-004; this remains procedural art, not final approved importable meshes.
`src/client/CombatVFX.client.lua` contains ART-003-inspired combat arcs, rings and Yokai feedback. `src/server/ShinobiAppearance.server.lua` is the ART-002 cosmetic placeholder. Neither VFX nor avatar model is final production art.
Do not treat working geometry or placeholder neon spheres as art approval.

## Review gates
- **Gameplay gate:** playable, server-validated mechanics, working Rojo tests.
- **Visual gate:** approved concept references directly consulted, coherent style, match screenshot reviewed.
Both must pass before marking a content asset **final**.

## OpenArt / Seedance video consistency
Use approved reference images as explicit image inputs (not just a textual style description). Keep character identity, outfit, mask design, scale, arena layout, and VFX color semantics consistent across every frame/shot. Videos are visual prototypes, not direct Roblox animations.
