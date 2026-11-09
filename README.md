# KAGEBOUND: WAR OF THE VEIL

**Two worlds. One battlefield. Become the legend.**

An original Japanese-mythology-inspired Roblox competitive action game featuring melee combat, mythic masks and **Veilfall**, a mid-match transformation of the battlefield.

## Project status
- Repository foundation: initialized
- Rojo files were reported visible by the user; current runtime verification of combat features remains pending
- Art: four approved PNG concept boards uploaded on main, registered in docs/ASSET_MANIFEST.md
- Gameplay: Moonfall Bamboo + art pass, server-timed Shinobi katana strikes/parry/dash, server-owned stamina, cross-platform inputs, double jump, regional Veilfall and Kitsune decoy plus three Moonfall Lantern Yokai PvE enemies, server-owned session rewards and ART-002 Shinobi starter appearance coded; **not yet playtested in Roblox Studio**

## Canonical MVP
4 warrior styles (Shinobi, Ronin, Onmyoji, Oni Disciple); 8 main weapons; 3 mythic masks (Kitsune, Oni, Tengu); 2 arenas; 2 PvP modes; 1 dojo lobby.

The first **vertical slice** is Moonfall Bamboo greybox + 2 players + Shinobi katana combo/parry/dash + Kitsune illusion + Veilfall + complete Shadow Duel round.

Studio-only startup smoke checks are included in `src/server/StudioSmoke.server.lua`; no automated Roblox runtime CI is configured.

Read [Progression QA](docs/PROGRESSION_01_TEST.md), [Combat 0.3 test](docs/COMBAT_03_TEST.md), [Yokai test](docs/YOKAI_01_TEST.md), [Grand World test](docs/WORLD_TESTING.md), [Visual standards](docs/ART_DIRECTION.md), [Prototype validation](docs/PROTOTYPE_01_TEST.md), [Roadmap](docs/ROADMAP.md), [VFX specification](docs/VFX_SPEC.md), [Asset manifest](docs/ASSET_MANIFEST.md), [Roblox sync](docs/ROBLOX_SYNC.md), and [Art prompts](assets/prompts/OPENART_SEEDANCE_SHOTLIST.md).

## Rojo quick start
1. Clone this GitHub repository to your computer.
2. Install Rojo CLI and the compatible Rojo Roblox Studio plugin.
3. Run `rojo serve` in the repository folder.
4. Open Roblox Studio, create/open the target place, connect using Rojo.
5. Inspect Explorer for KageboundShared, KageboundServer, and KageboundClient.

**Important:** Concept PNGs are illustrative references, not rigged avatars, particle systems or importable 3D gameplay objects. Use Roblox Studio to build/test the actual game.
