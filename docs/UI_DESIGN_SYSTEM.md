# KAGEBOUND — Veilbound Interface: HUD & UI design plan v1.0

**Status:** Design proposal; implementation and Roblox Studio validation pending.
**Source of truth:** `docs/ART_DIRECTION.md`, `docs/STYLE_GUIDE.md`, ART-001–004 in `assets/concept-art/`, `docs/WORLD_VISION.md`, `docs/VFX_SPEC.md`.
**Product priority:** Grand World adventure first; Shadow Duel / Clan Clash secondary. Preserve existing functional HUDs and migrate incrementally.

## Design principles
1. **Playable first:** Combat center stays clear. Effects are brief and telegraphed. Never cover a target, hit indicator or escape route.
2. **Mythic, not generic neon:** Japanese lacquer, ink, ivory, restrained shrine gold, ceremonial linework and circular spirit seals. No photorealism, cyberpunk panels or gratuitous gradients.
3. **Three UI intensities:** minimal combat HUD; exploratory map/journal/inventory; ceremonial mythic masks, boss events and Veilfall.
4. **One consistent system:** all screens share spacing, icons, typography, component behaviors and responsive safe areas.
5. **Accessible:** icon + label + shape, never color alone; scalable text, high contrast, reduced motion, gamepad focus, touch targets and low-graphics mode.
6. **Trust boundary:** client UI displays server-validated state; never calculates authoritative currency, damage, trades, quest completion or inventory.

## Theme tokens (design targets, approximate; compare with ART boards)
| Token | Hex | Use |
| --- | --- | --- |
| ink | #202338 | panels, HUD foundations |
| inkDeep | #19182B | modal backdrop |
| ivory | #F4E5F4 | primary text |
| muted | #B9ABC8 | secondary text |
| veil | #A95BE4 | spirit magic, focus, Veilfall |
| fox | #E84B86 | Shinobi / Kitsune / weapon attacks |
| ronin | #93D0F3 | defense / parry |
| gold | #FAB66B | rewards, legends, shrine highlights |
| danger | #D94C65 | danger warning (with icon/text) |

**Typography:** clean readable sans-serif for game-state data, selective brush-calligraphic title artwork for ceremonial headers only; never use ornate fonts for numbers, health, objectives or input labels.
**Shape:** 8–12 px panel radii, thin 1 px strokes, dark translucent fills, rare shrine-corner motifs; reserve large circular seals for ultimates and rituals.
**Spacing:** 4 px baseline, 8/12/16/24 px steps; target minimum 44 px touch actions, configurable UI scale.
**Motion:** panel 150–220 ms, short focus tracer, ability activation ring, optional cinematic Veilfall; reduced-motion disables nonessential motion.

## Screen inventory and priority
| Priority | Surface | Essential elements |
| --- | --- | --- |
| P1 | Combat HUD | health, stamina, ability cooldowns, weapon, mask, target health, combat cues |
| P1 | Exploration HUD | current region, quest tracker, waypoint distance, optional compass/map access |
| P1 | Enemy/Boss | name, health, phase, telegraph and threat cue |
| P2 | World map | five regions, discovered states, objectives, safe routes, landmarks |
| P2 | Quest journal / NPC dialog | tracked objectives, rewards, readable dialog, accept/decline |
| P3 | Inventory/equipment | weapon/mask cards, filters, equip state, clear stats |
| P3 | Character/mastery | style, skills, mastery progress, unlock criteria |
| P3 | Mask shrine | Kitsune/Oni/Tengu ceremonial selection, ability preview |
| P4 | Clans / PvP | social roster, matchmaking, results and clan activity |
| P4 | Shop / trading | server-backed item IDs, inspect, confirm, cancel, anti-duplication |
| P5 | Settings/accessibility | keybinds, graphics, audio, UI scale, color alternatives, reduced motion |

## Layout specifications
### Combat / desktop
- Top-left: region name and tracked quest, compact and dismissible.
- Top-center: target/boss health only when relevant; no permanent ornamental header.
- Bottom-left: player name/style, health and stamina with numbers and distinct bar patterns.
- Bottom-center or bottom-right: 4–5 action slots, icon + keyboard/controller hint + cooldown state.
- Right: equipped mythic mask, ability meter and compact minimap access.
- Center: reticle/interaction prompt only; protect central combat sightline.

### Combat / touch
- Respect Roblox safe area and virtual joystick zones.
- Keep thumb-action cluster on right, mobility on left; allow position/scale adjustments.
- Hide nonessential quests while in combat. Never overlap native Roblox system UI.
- Use UIAspectRatioConstraint, UISizeConstraint, UIScale, AnchorPoint, safe-area insets and layout objects.

### World map
- Main panel: illustrated but accurate region geometry; labels and icon keys remain readable.
- Left: region/quest filter; right or bottom: selected landmark details and waypoint action.
- Show discovered vs undiscovered without disclosing hidden quest spoilers.
- All waypoints and fast travel permissions validated by server.

### Inventory
- Grid of equipment icons, distinct weapon silhouettes and rarity treatments.
- Detail panel: original name, weapon type, verified stats, equip status, mask compatibility.
- No counterfeit 'legendary' claims or fake rarity; read from authoritative catalog.

## Reusable Roblox modules
- `src/shared/UITheme.lua`: color, spacing, motion and type scale tokens (no game logic).
- `src/client/ui/UIComponents.lua`: panel, bars, button, tooltip, cooldown ring, notification.
- `src/client/ui/UIState.lua`: single client presentation state for combat/exploration/modal modes.
- Existing HUD scripts remain until migrated with screenshot parity and no duplicate ScreenGuis.
- Use server-owned attributes/remotes for authoritative world, inventory, reward and combat updates.

## Delivery and acceptance gates
**P0 — foundation:** audit existing ScreenGui names and controller/mobile overlaps; establish tokens, layout rules and a component inventory.
**P1 — functional HUD:** health/stamina/cooldowns/target + region/quest displays. Confirm keyboard, controller, mobile and 2-player combat.
**P2 — exploration:** map, quest journal, NPC interaction and waypoint workflow. Verify zone transitions, safe-hub, streaming.
**P3 — collection:** inventory, equipment, mastery, masks and rewards, integrated with real server data.
**P4 — social/economy:** clan, shop, duel, trading only after secure authoritative backends.
**P5 — polish:** accessibility, graphics scaling, localization readiness, animation/audio, device QA.

### Acceptance checklist
- No overlapping or duplicated HUD layers; center target visible in ordinary third-person combat.
- Text and cooldowns readable at mobile landscape resolution and on desktop/controller.
- Colorblind distinguishability by shapes, icons and labels; reduced motion works.
- VFX and HUD remain legible during Veilfall, Yokai attacks and parries.
- Server state cannot be forged by changing client HUD.
- Compare screenshots with ART-001–004 and test Studio clients; no claims of completion before validation.

## Immediate integration
Current `src/client/WorldRegionDiscoveryHUD.client.lua` is a prototype to migrate into shared components. Keep its server-driven region data and banner timing. Audit existing combat and duel HUDs before replacing them. Do not modify gameplay authority during visual refactoring.
