# VFX specification

VFX is cosmetic feedback; gameplay damage and collision are validated on the server. Accessible colors and low-quality/mobile alternatives are required. Prioritize clarity over excessive screen-filling effects.

| ID | Effect | Look | Trigger / rule |
| --- | --- | --- | --- |
| FX-001 | Katana slash | short crimson/pink ribbon trail, sparks | predicted attack trail, server-approved combat |
| FX-002 | Hit impact | crisp contact flash, radial streak | server-confirmed hit only |
| FX-003 | Perfect parry | electric blue glint + circle | server checks timing window |
| FX-004 | Ninja dash | translucent afterimage, ground dust | server validates movement |
| FX-005 | Kitsune illusion | pink fox sigil, smoky clone silhouette | clone behavior authoritative |
| FX-006 | Oni burst | crimson shockwave, debris | damage / knockback server computed |
| FX-007 | Tengu gust | pale blue spiral wind, leaf swirl | movement impulses validated |
| FX-008 | Veil warning | sky fissure, purple pulse / countdown | synchronized transition |
| FX-009 | Veil rupture | spirit platforms emerge, portal rings | world collision managed server-side |
| FX-010 | Spawn / defeat | spirit circle / dissolving petals | cosmetic only |
| FX-011 | Ultimate ready | subtle rune halo and HUD pulse | charge server computed |
| FX-012 | Collectible pickup | coin/orb suction + toast | inventory server controlled |

For each FX record: emitter/texture/flipbook source, attachment map, SFX, 60/30 FPS behavior, lifetime, graphics scalability, replication, and performance benchmark on mobile. **Current status:** visuals specified; no Roblox ParticleEmitters or animations created yet.
