# KAGEBOUND character locomotion and game dynamics — research and roadmap
2026-11-10. Research/design only; no third-party game files or animation IDs imported.

## Verified public references
- Roblox official animation authoring: https://github.com/Roblox/creator-docs/blob/main/content/en-us/tutorials/use-case-tutorials/animation/create-an-animation.md — create original four-pose walk cycles, authored keyframes and owned published animations.
- Roblox Character Controller Library: https://github.com/Roblox/creator-docs/blob/main/content/en-us/characters/character-controller-library/index.md — future ability-driven architecture; do not replace existing Humanoid controller mid-combat integration.
- place1-movement-system: https://github.com/alexkkork/place1-movement-system — MIT; sprint, procedural motion, mantle, wall hops, slides. First-person only and no touch support: reference, not drop-in.
- roblox-precision-framework: https://github.com/lukas-mikalainis/roblox-precision-framework — MIT; server-validated parkour and combat. Reference server-authoritative traversal checks.
- Flow-Engine: https://github.com/tristan10027/Flow-Engine — wall run, vault, ledge and roll concepts; audit LICENSE before any code reuse.
- movement-system: https://github.com/jorgzk84-ui/movement-system — directional start/stop/pivot animations and dash state machine. Confirm license before reuse.
- huzv/MovementSystem: https://github.com/huzv/MovementSystem — camera-relative direction and smooth animation crossfades. Confirm license before reuse.
- Uncopylocked archives are not automatically licensed: some openly acknowledge exploited/dumped games. No verified permissively licensed One Piece Roblox game movement code was found in this pass. Never import franchise animation IDs, assets, scripts, maps or copied moves. Use original Japanese-mythology choreography and anime-scale readability.

## Core third-person R15 animation grammar
Universal states: combat idle, relaxed idle, directional walk forward/back/left/right, jog, sprint, accelerate, stop, pivot-90/180, jump, double jump, fall, land, dash, parry, stagger, guard break, three light strikes, heavy strike, Veilfall transformation. Start with Roblox default fallbacks, publish custom animation assets under the game's owner and register only verified IDs.

Four style signatures: Shinobi compact fast forward lean and aerial tuck; Ronin deliberate weighted stride and sword follow-through; Onmyoji restrained grounded glide with cloth motion; Oni Disciple wide stance, heavy foot plants and explosive dash. Do not use a recognizable copyrighted running cycle.

## Dynamics and player agency
- Camera-relative 8-way locomotion with velocity-driven blend and 0.1–0.2 s footplant transitions; maintain readable silhouettes at mobile scale.
- Sprint to close distance, stamina-gated dash to evade, deliberate parry versus telegraphed heavy guard break. No instant cancel from a committed heavy into sprint/dash.
- Katana balanced neutral, Nodachi long-range commitment, Tanto close-range pressure; class and mask abilities remain orthogonal.
- Traversal progression: sprint and directional stops -> roll/slide -> wall kick -> mantle -> class movement flourish. Server checks surface geometry, speed, cooldown and energy.
- PvE Yokai tells use same dodge/guard vocabulary; dojo tutorial teaches it before Shadow Duel and Clan Clash.

## Implementation phases
P0: Studio multiplayer QA for Katana/Nodachi/Tanto, tool authority, respawn, queue isolation, spoofing and parry; keep persistence disabled.
P1: pure shared LocomotionRules and owned AnimationCatalog with no invented IDs; AnimationDirector.client for cached layered tracks, blend/priority and respawn cleanup.
P2: server LocomotionService validates sprint, directional stop, slide/roll requests; client camera-relative input and camera response; avoid fighting existing Combat Dash.
P3: wall-kick and mantle server raycasts with slope/height constraints; Moonfall traversal QA.
P4: four class-specific silhouettes, weapon upper-body layers and Veilfall transformation.
P5: mobile touch/gamepad controls, 30/60 FPS profiling, 2-player lag and 4-player Clan tests.

## Production acceptance
First animation batch: 16 universal authored R15 clips (idle, combat idle, walk F/B/L/R, sprint, start, stop, pivot, jump, fall, land, dash, parry, stagger). Next: four class signatures and sword combos. Third: traversal and transformation. Each must have approved pose sheet, animation asset ownership, correct looping/priority, fallback, multiplayer Studio QA and performance review. No visual-only milestone is considered complete.
