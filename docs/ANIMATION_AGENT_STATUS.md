# KAGEBOUND — Independent Character Animation Workstream
Status: queued for an independent agent; 2026-11-10.
Automation creation was attempted but blocked by account limit (5/5 active tasks). **No new scheduled agent exists yet.** This file is the assignment/handoff for a future agent, not proof of running production.

## Scope and isolation
Repository: exmachina100/kagebound-war-of-the-veil, branch main.
Own only docs/ANIMATION_AGENT_STATUS.md, assets/animation/, animation-specific tests/specs and safe asset catalog proposals. Do not modify main gameplay combat scripts, unrelated game repositories, or existing weapon/character/environment/VFX asset-agent files. Read docs/CHARACTER_MOVEMENT_RESEARCH_AND_PLAN.md, docs/ART_DIRECTION.md, docs/GAME_DESIGN.md and docs/ASSET_PRODUCTION_QUEUE.md before production.

## Production queue
A1: universal R15 locomotion pack — idle, combat idle, walk forward/back/left/right, sprint, start, stop, pivot, jump, fall, land, dash, parry, stagger. Supply 16 authored clip specifications with key pose silhouettes, loop boundaries, contacts, duration, FPS, Roblox priorities and Studio import/export checks.
A2: class personalities — Shinobi agile compact run, Ronin measured weighted stride, Onmyoji grounded gliding steps, Oni Disciple heavy explosive steps. Maintain a common traversal controller.
A3: weapon upper-body choreography — Katana, Nodachi, Tanto 3-light/heavy/parry, distinct windup and recovery matched to src/shared/WeaponAttackRules.lua. Naginata and Yari after gameplay gates open.
A4: Veilfall transformation, landing, mask activation and hit reaction.
A5: R15 retarget/loop/priority QA, 30/60 FPS and mobile visibility, two-player latency; report Studio-only tests as unexecuted until run.

## Deliverables
Commit original pose/timing sheets, Blender/Studio rig notes, optionally self-authored editable animation sources, and QA checklist in assets/animation/. Do not copy One Piece/Blox Fruits animations or use unlicensed animation IDs. Only add owned published rbxassetid IDs to src/shared/LocomotionAnimationCatalog.lua after verification. Record verified commit SHAs and blockers in this status file.

## Coordination
Main gameplay agent retains weapon authority, combat, matchmaking and server movement. Existing weapon/character agent owns meshes/rig handoff; animation agent owns motion choreography and animation asset authoring. Environment/VFX agent owns effects. Review animation timing against actual combat profiles without changing server damage windows.
