# KAGEBOUND — VFX CONCEPT PACK v01

Four original GPT-created cinematic concept PNGs for the ART-001..004 production language.

## Status and provenance
These are **concept/reference boards, not game-ready particle textures, flipbooks, animations or Roblox VFX assets**. Images were created during the current KAGEBOUND design turn and include generated labels in some boards; treat those labels as provisional ideas, not authoritative game mechanics. The exact approved source files ART-001..004 remain the visual authority for all derived production work.

## Workflow handoff
1. Inspect the relevant approved ART image alongside the chosen generated board.
2. Select one effect at a time (FX-001 narrow magenta Veilblade slash, FX-003 blue parry, FX-005 Kitsune fox sigil, FX-006 Oni rupture, FX-007 Tengu wind, FX-008 warning, FX-009 Veilfall reveal).
3. Create **new isolated transparent sprite texture sequences** and, if helpful, geometry/ribbon meshes; don't upload the composite presentation board as an in-game ParticleEmitter texture.
4. For extravagant boss-scale attacks, retain strong anticipation, at-impact shape and dissipation, but cap long-lived glow, smoke overdraw, debris and camera shake; implement mobile-tier variants.
5. Let the existing server-authoritative remote event trigger visuals; never calculate hit damage or cooldown based on image frames or local particles.
6. Log sprite dimensions, actual Roblox asset IDs, emission count, lifetime, draw budget, mobile gameplay screenshot and source paths in docs/ASSET_MANIFEST.md.
7. Only after visual/gameplay QA in Studio, mark imported/validated. These PNGs remain concept-draft until then.

## How to upload to GitHub
Extract this ZIP into `assets/concept-sheets/vfx-v01/` within your KAGEBOUND clone and run:
```powershell
git add assets/concept-sheets/vfx-v01/
git commit -m "Add original KAGEBOUND high-impact VFX concept pack v01"
git push origin main
```
Only claim the PNGs are in GitHub once the push is verified.
