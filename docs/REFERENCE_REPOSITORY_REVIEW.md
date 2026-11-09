# Engineering reference review — One Piece Roblox repositories

Date: 2026-11-09. Purpose: learn from system architecture, not copy copyrighted One Piece content, assets, names, animations, characters, or third-party code.

## Sources inspected
1. https://github.com/TTsosik1235/one-piece-legendary-roblox-toolkit (README; tree contains only README at review time)
2. https://github.com/MuhammadxonSharifxojayev/One-PIece-Roblox-Game (README, player progression, economy, client combat; source tree)
3. https://github.com/zscyn8tyb9-create/roblox-one-piece-game (README, shared CombatConfig, ComboSystem, CombatHandler, CombatClient; source tree)

## Findings and critical appraisal
| Reference | Reusable engineering insight | KAGEBOUND adaptation | Concern |
| --- | --- | --- | --- |
| Legendary toolkit | README suggests adaptive UI and automation | No integration | No substantive game code in inspected tree. Advertised anti-detection / farming is unrelated to legitimate game development. |
| One-PIece-Roblox-Game | Separate economy, progression, character, boss, enemy AI and world modules | Dedicated independent progression/warrior/mask/quest services in later milestones | In inspected progression code a module-ending infinite loop prevents `require` completion; server state and UI are intertwined. Do not import verbatim. |
| One-PIece-Roblox-Game | Two currencies, item purchase validation, inventory roles | Spirit Shards (earnable cosmetic resource), dojo shop, weapon mastery | Requires durable persistence, idempotent purchase transactions, secure trading and anti-dupe logic. No pay-to-win. |
| roblox-one-piece-game | Central combat configuration and combo policy, thin client/server request split | Original KAGEBOUND CombatRules module to define cooldowns, costs, combo reset, parry and dash policy | Source combat passes client LookVector to server, and client regenerates stamina attribute; do not trust client for authoritative values. |
| roblox-one-piece-game | NPCs, bosses, local HUD, procedural world builder | Later Yokai Hunt boss behavior, dojo NPCs and role-appropriate HUD | Avoid generic One Piece data, owner cheat commands, magical auto damage multipliers and client gameplay authority. |

## Integration decisions
### P1 — Combat first
- Define one central combat rules module, with explicit stamina use, attack cadence and combo rules.
- Server owns stamina regeneration, action costs, hit/damage/parry validation. Client only requests actions and renders HUD.
- Maintain server directional checks and line-of-sight checks. Later add animation-marker hit windows, anti-speed validation and hitbox sweeps.
- VFX are client-rendered notifications from server-confirmed actions, keyed to FX-001..FX-004 and ART-001..ART-004.
- Mobile actions and camera lock are a future accessibility gate.

### P2 — Mask system
- Original kitsune clone, Oni disruption, Tengu aerial control. Server determines target eligibility, masks/loadouts, cooldowns, resistance and game-state permissions.
- Never copy 'devil fruit', 'Haki', characters, islands or related IP.

### P3 — PvP and PvE
- Shadow Duel best-of-five first; Clan Clash second. Match manager owns state and stops input outside active rounds.
- Yokai Hunt later: distinct NPC AI service (states patrol/chase/telegraph/attack/stagger/retreat), boss attack markers and bounded rewards.

### P4-P5 — Progression / economy / trading
- Weapon mastery, cosmetics and earned masks; a validated Dojo inventory and explicit shop catalog. DataStore persistence through schema versioning and UpdateAsync, failure handling, no client authority.
- Trading as its own atomic, consent-based transaction with item lock/dupe protection—not a copy of crews/pirate economy.

## Originality, rights and test requirements
- No source code or art copied from these three repositories. This document records only engineering observations and original implementation decisions. The inspected repository file trees did not include LICENSE files; do not assume blanket reuse permission.
- The approved four KAGEBOUND PNGs and docs/GAME_DESIGN.md and docs/ART_DIRECTION.md remain canonical.
- Code commits are **not** equal to passing Roblox Studio tests. Validate two players, reconnects, remote spam, low performance, and damage security before marking done.
