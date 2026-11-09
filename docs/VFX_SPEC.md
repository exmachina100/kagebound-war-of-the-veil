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

For each FX record: emitter/texture/flipbook source, attachment map, SFX, 60/30 FPS behavior, lifetime, graphics scalability, replication, and performance benchmark on mobile. **Current status:** server-triggered procedural neon VFX prototypes exist for combat, masks and Veilfall; authored production ParticleEmitter flipbooks, SFX, final animation assets, mobile QA and user approval remain pending.

## Cinematic intensity levels (original KAGEBOUND design)
- **Level 1 / core combat (0.15–0.45 s):** crisp readable edge, impact spark, counters; never obscure an entire duel.
- **Level 2 / charged active (0.45–1.5 s):** layered ribbons, circular seals, brief debris/shock rings, character silhouette remains visible.
- **Level 3 / mythic ultimate (2–5 s total):** anticipation (readable attack telegraph), overwhelming but bounded signature shape, decisive impact, rapid dispersion; only for committed high-value abilities. Keep damage bounds server-authoritative even when visuals reach far beyond them.
- **Level 4 / world Veilfall (multi-second):** sky-scale ring, shrine/portal silhouette, spectral route apparition with collision warnings and client-side LOD; does not interrupt safe PvP clarity or hide a collision change.

Concept input and source provenance: [VFX_CONCEPT_HANDOFF.md](VFX_CONCEPT_HANDOFF.md). Four source boards are in the conversation handoff ZIP `KAGEBOUND_VFX_ConceptPack_v01.zip`; **not yet in GitHub**. These composite images must be rebuilt into isolated transparent sprite/flipbook, particles, trails, beams and optional low-poly ribbon meshes before Roblox import. The existence of a beautiful concept is not a successful runtime VFX integration.
