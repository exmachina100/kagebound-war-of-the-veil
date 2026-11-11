# KAGEBOUND UI Asset Production — v01

**Design source:** [UI_DESIGN_SYSTEM.md](UI_DESIGN_SYSTEM.md), [ART_DIRECTION.md](ART_DIRECTION.md), ART-001..004 user-approved concept images.

## Connected production services (verified 2026-11-11)
- **OpenArt:** connected and operational. Image job submitted successfully using Seedream 5.5, text2image.
- **Kie API:** not exposed as a directly callable connected service in this ChatGPT session; do not infer that the KUMO Kei gateway is available to this game.
- **Higgsfield API:** not exposed as a directly callable connected service in this ChatGPT session.

## First UI icon atlas (generation pending)
- Provider: OpenArt
- Model: Seedream 5.5
- Job history ID: `h94vQpljCt8y26uabGhw`
- Job request: 1024 square / 1K / transparent background / one image / 4x4 icon atlas
- Quoted cost: 12 credits, subject to final OpenArt billing.
- Status: **submitted; not yet validated, downloaded, or committed as a binary PNG**.
- Art direction: premium Roblox-scale Japanese mythic UI, ink / ivory / veil violet / fox magenta / Ronin blue / lantern gold, flat 2.5D readability, transparent gutters, no labels.

### Atlas tile index (row-major)
| Row | Col 1 | Col 2 | Col 3 | Col 4 |
| --- | --- | --- | --- | --- |
| 1 | Slash | Parry | Dash | Veilfall |
| 2 | Kitsune | Oni | Tengu | Ofuda |
| 3 | World Map | Quest Scroll | Inventory | Weapon |
| 4 | Spirit Shard | Dojo | Clan | Settings |

### Review and implementation gates
1. Retrieve finished OpenArt image; check transparency, exact 4x4 cell separation, no stray text, silhouette and style match against ART-001..004.
2. Slice into 16 independent RGBA PNGs, trim/center each within a fixed transparent 256px tile; preserve original atlas too.
3. Commit original atlas, individual icon PNGs, and machine-readable atlas manifest to `assets/ui/icons/v01/`.
4. Import to Roblox Studio, assign actual asset IDs. Do not fabricate IDs or declare assets game-ready before import.
5. Integrate with reusable UI components, and test 64/48/32px readability, mobile touch, controller focus, low graphics and combat overlap.
6. If generative icon spacing is inconsistent, recreate icons individually or use authored vector paths; do not blindly slice malformed artwork.

### Next production queue
- P0: 16-icon functional atlas (above).
- P1: 9-slice dark lacquer panel and ornate corner variants; health/stamina/mask bar skins; focus and cooldown rings.
- P2: rarity frames and equipment card decorations; map pins, quest markers, NPC dialog header, Veilfall alert.
- P3: clan crests, legendary mask cards, boss bar variants, trading confirmation states.
- P4: animated icon state frames and accessibility/low-graphics variants.

### Roblox runtime specification
Use `ImageLabel.ImageRectOffset` / `ImageRectSize` for atlas sprites, or individual `ImageLabel.Image` IDs for cropped files. `ScaleType.Slice` + `SliceCenter` for resizable 9-slice frames. Native Roblox Frames and text remain authoritative for responsive controls; generated graphics are decorative only. See Roblox Creator Hub ImageLabel reference.

**Do not confuse an OpenArt image-generation request with a validated in-game asset.**
