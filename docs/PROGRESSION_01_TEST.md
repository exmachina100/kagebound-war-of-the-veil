# Grand World Progression 0.1 — QA and reward contract

**Code committed; Roblox Studio runtime test NOT yet performed.**
Source of truth: [WORLD_VISION](WORLD_VISION.md), [GAME_DESIGN](GAME_DESIGN.md), [ART_DIRECTION](ART_DIRECTION.md). Original Spirit Shards, weapon mastery, and Moonfall Lantern Yokai; no One Piece assets or mechanics copied.

## Implemented
- `src/shared/RewardPolicy.lua`: fixed server rule table. Whispers quest = 25 Spirit Shards; Lantern Yokai = 6 Spirit Shards + 4 Veilblade Mastery, +1 Yokai defeat.
- `src/server/RewardService.lua`: server-only award API, per-player session record, source:token duplicate guard, attribute mirrors, cleanup on leave. **No DataStore**.
- `src/server/ExplorationQuest.server.lua`: Keeper quest rewards through RewardService once upon completion. Historical `KageboundQuestShards` attribute remains for compatibility but not spendable.
- `src/server/Combat.server.lua`: only successful server-side NPC damage marks LastDamagerUserId and LastDamagedAt.
- `src/server/YokaiEncounter.server.lua`: a valid final hit credits the named player once, then a new spawn has a fresh unique token. NPC attacks can be parried only when facing it. A hit briefly staggers the enemy.
- `src/client/ProgressionHUD.client.lua`: read-only Spirit Shards and Veilblade Mastery display.
- `src/server/ShinobiAppearance.server.lua`: welded ART-001/ART-002 dark Shinobi costume and forehead fox mask, a procedural placeholder—not imported final design.

## Startup / world
1. Local PowerShell inside the KAGEBOUND clone: `git pull origin main` then `rojo serve default.project.json` (stop any existing Rojo process first).
2. Roblox Studio: reconnect Rojo; choose **Test → Start** with two players; check Output.
3. Explorer: verify `ReplicatedStorage/KageboundShared/RewardPolicy`, `ServerScriptService/KageboundServer/RewardService`, `ServerScriptService/KageboundServer/ShinobiAppearance`, `PlayerGui/KageboundProgressionHUD`.
4. All 4 approved concept boards remain in `assets/concept-art` for side-by-side screenshot review.

## Reward and visual acceptance
1. Spawn in Kage Dojo. Spirit Shards, Mastery and Yokai defeat counters begin at 0 for each joining player.
2. Visit the Shrine Keeper at ~ (24,4,15), accept Whispers Across the Veil, go to Moonfall Bamboo at (0,-780) on X/Z, return and turn in. Spirit Shards should become **25** and mastery remain 0.
3. Trigger the Keeper prompt repeatedly: **no additional 25-shard payment**.
4. At Moonfall Bamboo find one of the three Lantern Yokai near (-90,-755), (88,-795), or (10,-888). Reduce health from 110 to 0 with server-authorized katana hits; the last attacker receives **6 shards, 4 mastery and +1 kill**. If you completed the quest first, Shards should read 31.
5. With two players, ensure only the last valid server hitter receives the reward. No client input should send the amount or choose a recipient.
6. Fight the same enemy after respawn ~14 seconds later and confirm a **new unique token** permits exactly one further reward. No second reward for the already defeated model.
7. Check enemy parry facing: F toward the Yokai during the 0.32s server window can cancel its telegraphed attack. Pressing F while facing away must not.
8. Player damage during the Yokai's telegraph should stagger it briefly and can interrupt its strike.
9. Verify the Shinobi has angular dark hair, charcoal armor, vermilion scarf and a tilted ivory fox mask. No cosmetic BasePart should collide, touch or query. Confirm katana is still equipped, no malformed avatar respawn.
10. Rejoin a new Play test: session currency starts at zero. **This is intentional until durable persistence is implemented.** Do not test purchases/trading yet.

## Studio-only scripts (not synchronized through Rojo)
- Run `tests/RewardPolicy.studio.lua` in Studio server command bar.
- Run `tests/ProgressionService.studio.lua` only in a disposable Play test. It grants one artificial 6-shard reward to verify idempotency.
- Existing `tests/CombatRules.studio.lua` tests combo and stamina policy.
These are contracts, not a substitute for verifying attack, client UI and AI behavior in multiplayer.

## Release blockers
- DataStore and UpdateAsync save/version migration, session conflict management, retries and backup restore.
- Secure shop, mastery unlock catalog, inventory, cosmetics purchase and anti-duplication.
- Group rewards and kill-credit arbitration, anti-farming / diminishing returns, multi-server progression.
- True authored R15 models/rigs, animation markers, sound design, full mobile UX and consistent screenshot comparisons.
- NPC pathfinding, collision avoidance, network stress tests, server streaming and quest lifecycle at scale.

**Do not call the game 'complete' before the documented Studio and security checks pass.**
