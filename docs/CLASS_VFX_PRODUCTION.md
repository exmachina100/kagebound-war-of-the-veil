# KAGEBOUND — Four-Warrior VFX Production Bible v0.5

**Canonical images:** ART-001/002/003/004 and the *eight uploaded image files* in `assets/concept-sheets/vfx-v01/` and `assets/concept-sheets/clan-vfx-v01/`. These image paths are verified GitHub sources. Combat/server rules in `docs/GAME_DESIGN.md`, `docs/ROADMAP.md` and `docs/VFX_SPEC.md` override any AI-drawn labels on images.

## Mandatory production prompt, reused across every class
> KAGEBOUND: WAR OF THE VEIL, original premium Roblox anime-mythic action-adventure VFX, large-scale cinematic spectacle with graphic readability, under moonlit Japanese shrine lanterns, torii, bamboo and floating spirit architecture, exact character identity and weapon silhouette from approved ART-001..004 and the named uploaded class sheet. Deliver a coherent four-beat VFX storyboard: anticipation/charge, release/strike, impact, rapid dispersion. A strong luminous signature silhouette with layered edge/ribbon/sigil/particle details, readable hitbox telegraph and mobile LOD. Keep the actual damage radius separate from apparent visual reach. Produce isolated alpha-friendly component artwork for sprite flipbooks and low-poly ribbons/meshes; no trademarked anime imagery, no direct copying, no giant opaque screen cover, no UI text on individual texture assets.

**Production stage:** concepts are uploaded, geometric VFX renderer and seven separate 4×4 transparent texture prototypes are prepared, actual Roblox PNG upload IDs and finished animation rigs are pending. Six move labels per character are art concepts; **do not claim they are six implemented player abilities**. The current playable combat prototype is primarily Shinobi plus three mythic-mask actives.

## SHINOBI — shadow assassin / fox veil
- Exact source: `assets/concept-sheets/clan-vfx-v01/KGB_VFX_Shinobi_ConceptSheet_v01.png`
- Hero: angled ivory Kitsune forehead mask, dark charcoal layers, crimson scarf, ink sword and fox-pink energized edge.
- Colors: dark ink, crimson-magenta attack core, violet spirit, ice-blue defensive spark, minimal gold.
- Six panels / art cue: **Veil Slash** (multi-hit pink crescent chain); **Shadow Dash** (speed afterimages and smoky fox ribbons); **Parry Burst** (ice-blue precise counter flash); **Fox Veil Illusion** (independent spiritual fox masks/clone silhouettes); **Cross-Cut** (decisive X-shaped finishing sweep); **Veil Release** (large fox-spirit / world-scale sigil).
- Sprite motifs: crescent slash, crosscut, impact star, smoke ribbon, fox mask shards, petals, talisman ring and short afterimages.
- Regular attack frames should resolve quickly (roughly 0.12 s active; server governs exact damage). The cinematic release panel is **future ultimate art** only.

## RONIN — wandering swordmaster / precision moon
- Exact source: `assets/concept-sheets/clan-vfx-v01/KGB_VFX_Ronin_ConceptSheet_v01.png`
- Hero: distinct ronin long blade, layered fur/robe silhouette, restrained disciplined fighting stance.
- Colors: moon blue, cold ice blue, silver white and violet residual traces; not a pink Shinobi recolor.
- Six panels: **Crescent Draw** (precision multi-hit iai crescents); **Wind Step** (blue wind ribbons and ghosted movement); **Moon Guard** (circular ice-blue parry ring and bright contact star); **Rising Tide Cut** (rising slash/wave crest); **Cross Moon** (paired moon crescents cross finisher); **Full Moon Execution** (large lunar seal, interlocking crescent barrage and crisp finishing strike).
- Isolated sprites: crescent slash, layered slash, moon-ring, parry star, ice shards, wave mist, wind ribbon, speed afterimage, circle glyph.
- Ability names and combat functions remain **concept targets** until Ronin server abilities and animations are committed/tested.

## ONMYOJI — Veil art channeler / ceremonial control
- Exact source: `assets/concept-sheets/clan-vfx-v01/KGB_VFX_Onmyoji_ConceptSheet_v01.png`
- Hero: ritual cap/hat, pale layered robes, floating ofuda/talisman focus and controlled spiritual aura.
- Colors: indigo, violet, lavender/lilac, moon ivory and warm ceremonial gold.
- Six panels: **Ofuda Barrage** (glowing paper wards in arcing volleys); **Spirit Step** (violet smoke and talisman trails); **Barrier Ward** (protective seal-ring and transparent dome); **Seal Prison** (upright rune rings/cages); **Divine Exorcism** (descending judgement seals and concentrated purge); **Veil Liturgy** (ritual circle, talisman storm and giant spirit fox).
- Isolated assets: paper ofuda projectile, seal/sigils, ward dome/ring, smoke curls, fox spirit, descending seals, pale gold contact sparks.
- Actual barrier/cage gameplay requires separate server hit eligibility/CC limits; **none is implemented merely by this VFX bible**.

## ONI DISCIPLE — cursed brute / explosive impact
- Exact source: `assets/concept-sheets/clan-vfx-v01/KGB_VFX_OniDisciple_ConceptSheet_v01.png`
- Hero: broad horned armor silhouette, thick prayer beads, chains, dark gauntlets; heaviest movement rhythm.
- Colors: fierce crimson, vermilion, black-red smoke, violet fracture, pale ember accents.
- Six panels: **Hell Cleave** (thick savage crimson multi-hit arc); **Rage Charge** (forward shock smoke and ground rupture); **Oni Guard Break** (spiked counter burst); **Chain Reaver** (curved chain strike and impact cracks); **Demon Breaker** (pillar-like downward slam); **Wrath of the Veil** (towering horned spirit, crimson-violet energy eruption).
- Isolated sprites: heavy slash, eruption star, chain sparks, demonic smoke, horn glyph, ground cracks, ember fragments, cursed radial shock ring.
- The existing **Oni mask** has a 12-stud radius with 15 HP damage and knockback, as implemented in `MaskRules.lua`; the boss-scale eruption art is visual direction only and cannot silently expand this damage radius.

## Mythic mask VFX and world events
- **Kitsune (FX-005)**: fox illusion/decoy, ritual mask fragments, tails of spectral ribbon; see `vfx-v01/KGB_VFX_FX005_KitsuneUltimate_CONCEPT_v01.png`. Game decoy presently diverts Lantern Yokai once; huge fox ultimate remains future.
- **Oni (FX-006)**: vermilion ground fissure, horn ring, dark smoke and staged inward shock-to-outward eruption; see `vfx-v01/KGB_VFX_FX006_OniBossEruption_CONCEPT_v01.png`. Current mask damage is server bounded.
- **Tengu (FX-007)**: cyan/ice wind ribbon, feathers, rising spirals and mobility afterimage; see `KGB_VFX_MythicMovesShowcase_CONCEPT_v01.png`; no invented branded mask from other games.
- **Veilfall (FX-008/009)**: 6-second warning, atmospheric crack/sigil in sky, monumental purple ring and traversable spectral pathways, always keeping actual server collision rules/closing warning. Source `vfx-v01/KGB_VFX_FX008_VeilfallSequence_CONCEPT_v01.png`.

## Four-beat animation template
| Beat | Standard shape | Functional guard |
| --- | --- | --- |
| Anticipation | compact glyph/ribbon growing at weapon or ground origin | never untelegraphed PvP damage |
| Release | decisive 0.15–0.5s moving silhouette, high-intensity core | server authorizes impact window |
| Impact | localized bright contact and a capped radial shock ring | visual size does not determine damage |
| Dispersion | dissolving particles/petals/ribbons, fading residual seal | culled by distance and low graphics profile |

For a legendary/world ultimate, extend to 2–5 seconds with anticipation and a single impressive impact, but avoid screen-opacity and performance spikes. Aesthetic is grand; technical rendering is bounded.

## Runtime code and actual texture assets
- `src/shared/VFXProfiles.lua`: distinct per-class/ability motif and palette.
- `src/client/VFXFactory.lua`: local neon geometry, arc, ring, sigil, fracture/wind forms with mobile budgets.
- `src/client/CombatVFX.client.lua`, `MaskVFX.client.lua`, `Kitsune.client.lua`: triggered by server-confirmed events.
- `src/shared/VFXTextureCatalog.lua` and `src/client/VFXSpriteEmitter.lua`: optional real Roblox Grid4x4 ParticleEmitter texture animation; intentionally blank Roblox image IDs.
- `KAGEBOUND_VFX_Flipbooks_v01.zip` (conversation artifact): seven **original RGBA** 1024×1024 4×4 flipbooks and reproducible Pillow generator, destined for `assets/vfx/flipbooks/v01/`; GitHub binary upload and Studio imports remain pending.

## Acceptance
Inspect the exact uploaded concept board, render a local camera combat clip, check alpha texture sheets and flipbook frames, compare silhouette and class differentiation, test 2 players and mobile graphics/overdraw, record exact imported image IDs, and update `docs/ASSET_MANIFEST.md`. No asset enters validated state solely because the concept looks impressive.
