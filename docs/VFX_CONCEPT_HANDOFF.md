# KAGEBOUND — Grand Mythic VFX concept handoff v01

**Status: Four original GPT image-generation boards and four warrior-class boards are verified on GitHub `main`** under `assets/concept-sheets/vfx-v01/` and `assets/concept-sheets/clan-vfx-v01/`. Original authoring packages remain archived in the conversation. The game source references remain approved ART-001 through ART-004 in `assets/concept-art`. No asset should claim to be an imported ParticleEmitter, animation or validated Roblox effect at this stage.

## Generated production references

| Asset ID | PNG name within package | FX role |
| --- | --- | --- |
| `KGB_VFX_FX006_OniBossEruption_CONCEPT_v01` | `KGB_VFX_FX006_OniBossEruption_CONCEPT_v01.png` | Boss-scale spirit eruption / Oni rupture; inspirational escalation, not current Oni 15-damage ability |
| `KGB_VFX_FX008_VeilfallSequence_CONCEPT_v01` | `KGB_VFX_FX008_VeilfallSequence_CONCEPT_v01.png` | Phase sequence: Veil warning to monumental gate and elevated route reveal |
| `KGB_VFX_FX005_KitsuneUltimate_CONCEPT_v01` | `KGB_VFX_FX005_KitsuneUltimate_CONCEPT_v01.png` | Kitsune stylized energy crescent, masks, spirit trail and impact timings |
| `KGB_VFX_MythicMovesShowcase_CONCEPT_v01` | `KGB_VFX_MythicMovesShowcase_CONCEPT_v01.png` | Multi-ability portfolio board / visual direction only; AI-generated labels are **not confirmed game feature names** |

All four are 1672x941 original RGB composite images. Their artwork is **visual storyboards, not game-ready effects**; they have no transparent alpha or independent effect frames. Keep imported source images separate from actual VFX sprite textures.

## Conversion plan / agent handoff

**Art first:** inspect actual ART-001 (hero), ART-002 (warriors), ART-003 (weapons and masks), ART-004 (environments/Veilfall); compare with selected concept board. Use the reference board to *author* isolated transparent FX textures / flipbooks, 3D ribbon meshes, particle emitters, trails, beams and sound cues. Do not simply overlay a full cinematic board in-game.

**Implement in order:**
1. `FX-001` Veilblade slash: heroic broad opening sweep, tight hit-beat, sharp magenta core and dark crimson smoke breakup; regular attack stays fast and optically readable.
2. `FX-003` Parry burst: high-intensity ice-blue star core + circular gold glint, brief and distinct from red offense.
3. `FX-005` Kitsune: patterned foxy smoke/face particles and multiple decoy afterimages, separate from actual AI/target logic.
4. `FX-006` Oni: ground crack / erupting shock ring / crimson spirit debris; ensure server-validated damage remains within gameplay radius, regardless of visual scale.
5. `FX-007` Tengu: cyan wind ribbon / leaf vortices / displacement streak; physical impulse controlled by server.
6. `FX-008` / `FX-009` Veilfall: telegraphed fissures, sky ring, large spiritual gate and bridge reveal, bounded particles; always follow server-owned world collision transitions.

**Production constraints:** Big-game visual impact comes from strong shapes, anticipation and layering, not covering the screen with opaque particles. Author distinct near/far LODs and mobile graphics profiles. Per effect record timing (windup/active/recovery/decay), actual spritesheet PNG with alpha, material/emitter counts, motion curve and camera distance, SFX and latency behavior. Trigger from server-authorized combat/world events, not local damage claims.

## File and QA handoff

The eight reference PNGs are **already committed and verified** at the exact paths above. Do not re-upload duplicates. The next binaries are the seven generated transparent `KAGEBOUND_VFX_Flipbooks_v01.zip` atlases, which are **not yet committed**; see [VFX_FLIPBOOK_IMPORT.md](VFX_FLIPBOOK_IMPORT.md).

Image generation in this chat is complete; isolating and animating individual VFX components into real usable Roblox effects is the *next agent task*. Tests must capture live gameplay screenshots alongside the same original art reference and consider the cost of overdraw on mobile.

## Character sheet integration
All 4 class boards (Shinobi, Ronin, Onmyoji, Oni Disciple) now have distinct **visual-only profiles** in `src/shared/VFXProfiles.lua` and the canonical motion/motif prompts in [CLASS_VFX_PRODUCTION.md](CLASS_VFX_PRODUCTION.md). Runtime effects use `src/client/VFXFactory.lua` and optional ParticleEmitter sprites after real Roblox asset IDs are supplied.
