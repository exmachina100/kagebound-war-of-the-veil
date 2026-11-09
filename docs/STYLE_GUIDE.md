# KAGEBOUND — Visual Style Guide v1

The four user-approved PNGs in assets/concept-art/ are the controlling source of truth. Refer to docs/ART_DIRECTION.md for their exact filenames and roles. Written colors below are implementation approximations, not sampled proof of pixel-identical hues.

## Style DNA
- Premium Roblox-scale Japanese mythic action-adventure: blocky-readable body shapes, bold silhouette hierarchy, stylized layered armor, graphic cel-shaded accents, fine detail only where it reads.
- Moonlit indigo-violet environment with localized warm lantern gold. No neon cyberpunk takeover, photorealistic human anatomy, or copied famous anime weapons.
- Japanese spiritual architecture: torii, shrine roof curves, worn stone, lanterns, bamboo, fox motifs, floating Veilfall crossings.
- Clear combat sightlines and low-graphics variants; effects never obscure an entire duel.

## Palette semantics
| Role | Approx. RGB | Application |
| --- | --- | --- |
| Ink charcoal | 32 35 56 | armor, hilt, dark surfaces |
| Vermilion | 154 47 72 | Shinobi, torii, attack accent |
| Fox magenta | 228 92 164 | Kitsune/Veilblade |
| Veil violet | 169 91 228 | rifts, spectral paths |
| Ice blue | 112 204 255 | parry, Ronin defense |
| Lantern gold | 250 182 107 | light and reward highlights |
| Moon ivory | 234 219 231 | ceremonial masks |
| Bamboo green | 45 86 74 | nature |
| Slate stone | 83 86 108 | paths/rocks |

Use hue + shape + timing for color accessibility.

## Character signatures
Shinobi (ART-001/002): ink layered armor, red scarf, angular black hair, tilted ivory fox mask, restrained gold; agile tapered attacks. Ronin (ART-002): precise samurai, cool counter readability. Onmyoji (ART-002): recognizable talisman/ritual silhouette. Oni Disciple (ART-002): wide heavy silhouette and physical red impacts. Never reduce all four to recolored versions of one model.

## Weapon signatures
Veilblade (ART-003): readable dark katana core, crimson/magenta edge, gold tsuba, red tassel, clean taper and hand attachment. Maintain distinct shapes for nodachi, tanto, naginata, yari, kanabo, kusarigama and yumi, not simply separate glows.

## World signatures
Kage Dojo (ART-004): safe social/training environment with warm ceremonial lighting. Moonfall Bamboo (ART-004): stone, bamboo, lanterns, shrine hierarchy, moonlight and raised traversable routes. Shogun's Last City: vertical rooftops. Frozen Shrine: icy blue highlands. Yomi Rift: dark violet fractured spirit terrain.

## VFX and UI
Use docs/VFX_SPEC.md. Katana FX-001 narrow red/magenta, hit FX-002 crisp gold contact, parry FX-003 blue counter, dash FX-004 short spirit afterimage, Kitsune FX-005 illusion/sigil, Veilfall FX-008/009 warning fissures and spectral bridges. Keep durations short and effects scalable. UI should use clean charcoal plates, magenta spirit energy, gold rewards and legible indicators.

## Acceptance
Inspect the actual relevant ART image, compare concept/mesh screenshot at close-up and ordinary gameplay camera distance, review silhouette and material treatment, and test on desktop + low-end/mobile graphics before marking art validated.

## Production contrast and low-poly materials
ART-003 Veilblade priority order: tapered dark silhouette → crimson/magenta edge → gold tsuba → wrapped grip → restrained tassel/fox seal. In game, a glowing edge may never replace the physically readable blade body. ART-004 Dojo target priority: readable striking post with ivory fox-mask target, dark body, crimson/gold accents; do not give decorative meshes collision or server authority. Prototype OBJ material assignments: `Ink`, `Graphite`, `Crimson`, `HotPink`, `Gold`, `Ivory`, `Violet`, `Stone`. Revisit color fidelity against source PNG after importing; numerical values do not prove sampled pixel accuracy.
