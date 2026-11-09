# KAGEBOUND: WAR OF THE VEIL

**Two worlds. One battlefield. Become the legend.**

An original Japanese-mythology-inspired Roblox competitive action game featuring melee combat, mythic masks and **Veilfall**, a mid-match transformation of the battlefield.

## Project status
- Repository foundation: initialized
- Rojo files were reported visible by the user; current runtime verification of combat features remains pending
- Art: four approved PNG concept boards uploaded on main, registered in docs/ASSET_MANIFEST.md
- Gameplay: Moonfall Bamboo + art pass, server-timed Shinobi katana strikes/parry/dash, server-owned stamina, cross-platform inputs, double jump, regional Veilfall and Kitsune decoy plus three Moonfall Lantern Yokai PvE enemies, server-owned session rewards, ART-002 Shinobi appearance, optional animation-track driver, grip fallback, blade Trail and Kage Dojo practice targets coded; **not yet playtested in Roblox Studio**

## Canonical MVP
4 warrior styles (Shinobi, Ronin, Onmyoji, Oni Disciple); 8 main weapons; 3 mythic masks (Kitsune, Oni, Tengu); 2 arenas; 2 PvP modes; 1 dojo lobby.

The first **vertical slice** is Moonfall Bamboo greybox + 2 players + Shinobi katana combo/parry/dash + Kitsune illusion + Veilfall + complete Shadow Duel round.

Studio-only startup smoke checks are included in `src/server/StudioSmoke.server.lua`; no automated Roblox runtime CI is configured.

Read [Dojo training QA](docs/DOJO_TRAINING_TEST.md), [Shinobi animation pipeline](docs/SHINOBI_ANIMATION_PIPELINE.md), [Progression QA](docs/PROGRESSION_01_TEST.md), [Combat 0.3 test](docs/COMBAT_03_TEST.md), [Yokai test](docs/YOKAI_01_TEST.md), [Grand World test](docs/WORLD_TESTING.md), [Visual standards](docs/ART_DIRECTION.md), [Prototype validation](docs/PROTOTYPE_01_TEST.md), [Roadmap](docs/ROADMAP.md), [VFX specification](docs/VFX_SPEC.md), [Asset manifest](docs/ASSET_MANIFEST.md), [Roblox sync](docs/ROBLOX_SYNC.md), and [Art prompts](assets/prompts/OPENART_SEEDANCE_SHOTLIST.md).

## Rojo quick start
1. Clone this GitHub repository to your computer.
2. Install Rojo CLI and the compatible Rojo Roblox Studio plugin.
3. Run `rojo serve` in the repository folder.
4. Open Roblox Studio, create/open the target place, connect using Rojo.
5. Inspect Explorer for KageboundShared, KageboundServer, and KageboundClient.

**Important:** Concept PNGs are illustrative references, not rigged avatars, particle systems or importable 3D gameplay objects. Use Roblox Studio to build/test the actual game.

## New content workflow
All new assets follow [asset workflow](docs/ASSET_CREATION_WORKFLOW.md), [style guide](docs/STYLE_GUIDE.md), and [asset production queue](docs/ASSET_PRODUCTION_QUEUE.md). ART-001..004 are source-of-truth. Veilblade first turnaround is generated in OpenArt and a separate prototype 3D handoff package exists, but **the GLB/OBJ is not imported into Roblox Studio or committed as a GitHub binary**. See issue #24.

## Current mythic mask and VFX production milestone
Original Kitsune decoy, Oni burst, and Tengu wind actives are scripted with server-owned cooldown/damage/movement and Kage Dojo-restricted mask switching. See [mythic mask multiplayer test](docs/MYTHIC_MASKS_TEST.md). Four new GPT-generated high-impact VFX concept images are packaged as a conversation attachment and described in [VFX concept handoff](docs/VFX_CONCEPT_HANDOFF.md); image binaries have **not yet been pushed into this GitHub repo**, and game-ready sprite/particle/mesh creation is still an art-agent task. All features require actual Roblox Studio gameplay and art QA.

## Four-class visual systems and VFX assets
The four warrior classes have original visual profiles tied to the verified VFX sheets in `assets/concept-sheets/clan-vfx-v01/`. See [Class VFX bible](docs/CLASS_VFX_PRODUCTION.md) and [Grid4x4 flipbook handoff](docs/VFX_FLIPBOOK_IMPORT.md). The current game renders layered local geometry and can optionally display uploaded transparent ParticleEmitter flipbooks; actual Roblox texture asset IDs remain blank until publication. Oni now damages Moonfall Yokai server-side, and Kitsune can distract one Lantern Yokai attack. These code changes remain **Studio-unverified**.
