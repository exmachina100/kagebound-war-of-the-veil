# Grand World v0.1 — Roblox Studio test checklist

This is a code-delivered but **untested** prototype. References: WORLD_VISION.md, GAME_DESIGN.md, ART_DIRECTION.md (ART-001..004).

## Setup
In your local clone, stop running Rojo with Ctrl+C (if running); run `git pull origin main`; run `rojo serve default.project.json`; connect Studio plugin. Enable Explorer + Output.

Important: delete or disable the default Baseplate `SpawnLocation` if it competes with KageboundWorldSpawn. Studio place configuration is not synchronized by these Rojo source files. Do not delete the game's custom spawn.

## Expected
- Workspace/KageboundWorld/GrandWorldBase
- Workspace/KageboundWorld/KageDojo/KageboundWorldSpawn
- Workspace/KageboundWorld/MoonfallBamboo
- Workspace/KageboundWorld/ShogunLastCity
- Workspace/KageboundWorld/FrozenShrine
- Workspace/KageboundWorld/YomiRift
- Workspace/KageboundWorld/TravelRoutes
- Workspace/KageboundWorld/KageDojo/ShrineKeeper_QuestGiver
- PlayerGui/KageboundWorldHUD and KageboundQuestHUD

Output should include `[KAGEBOUND] Grand World generated: 5 connected regions` and `[KAGEBOUND] World exploration quest initialized`.

## Yokai prototype
Moonfall Bamboo now has a three-enemy Lantern Yokai encounter under `Workspace/KageboundEnemies`. Run [YOKAI_01_TEST.md](YOKAI_01_TEST.md) separately for server-owned hitboxes, parry/telegraphs and respawn. Lantern Yokai now grant session-only Spirit Shards and Veilblade Mastery to the last server-verified attacker; no boss quest reward or persistent inventory yet. See [PROGRESSION_01_TEST.md](PROGRESSION_01_TEST.md).

## Kage Dojo practice lane (unverified)
A safe 3-target training lane is scripted at X 64, Z 65, with posts at Z 76. Only these posts are damageable by equipped Veilblade within the practice circle; player health remains protected across the hub. Run the [DOJO_TRAINING_TEST.md](DOJO_TRAINING_TEST.md) checklist before considering this safe. Outside the ring in the dojo, ordinary sword attacks remain disabled.

## Walkthrough
1. Press Play. Spawn at Kage Dojo, see explorable houses, torii, lanterns and world HUD.
2. Walk toward the Keeper NPC close to (24, 4, 15). Use **E** on the proximity prompt to accept "Whispers Across the Veil".
3. Travel the north road to Moonfall Bamboo (near X 0, Z -780). Reach within 90 studs of the zone center.
4. Confirm the journal says Moonfall discovered. Return along the road to the Keeper and complete the quest.
5. Confirm Player attribute `KageboundQuestShards` becomes 25. The quest now also credits the central session-only Spirit Shards account via server-only RewardService; no inventory persistence or real currency economy exists yet.
6. Continue exploring the Shogun city, Frozen Shrine and Yomi Rift. Look for road gaps, buildings blocking routes, performance spikes, disconnected terrain or stuck character collisions.
7. Test 2 players, including joining after the first player's quest is active. Quest stages should be isolated.
8. Confirm the legacy KageboundArena is not generated when WorldConfig.Enabled=true; this keeps world exploration free of boxed-in arena walls.
9. Run mobile emulator / low graphics pass and capture screenshots against ART-001..ART-004. This blockout is **not** visually polished.

## Grand World combat + regional Veilfall
In Grand World mode, the old arena Veilfall script is intentionally disabled; the new `RegionalVeilfall.server.lua` supplies Moonfall bridge phases and the client HUD RemoteEvent. See [COMBAT_03_TEST.md](COMBAT_03_TEST.md) for the two-player combat, safe-zone and bridge tests.

## Scope and known limitations
- World is a continuous 2700x2700-stud **flat ground blockout with five themed districts**. It has NOT reached the density, terrain complexity, travel diversity, map scale or world interactions of a mature action RPG.
- No world streaming, quest persistence, multi-server travel, advanced encounter spawning, dungeons, full regional world-event orchestration or navigation map yet. One static 3-Yokai encounter and one prototype regional Veilfall cycle are scripted but remain untested. One prototype regional Veilfall cycle is now scripted for Moonfall Bamboo but untested.
- Combat.server.lua now checks the Kage Dojo SafeHub against attackers and targets before PvP damage; validation in a two-client Studio session remains mandatory. Gameplay safety beyond the defined hub requires future design.
- Do not mistake a cosmetic counter named QuestShards for a secure inventory.
- Road connections and world geo must be stress-tested and reworked to look like canonical art, not left as square platforms.

## Two opt-in match kiosks at Kage Dojo
- Shadow Duel 1v1 queue kiosk: approximately X=-45, Z=45.
- Clan Clash 2v2 queue kiosk: approximately X=45, Z=45.
- One active match per mode per Roblox server. Joining one waiting queue blocks the other. Both matches use isolated arena layouts and return players to Kage Dojo afterward.
- **Clan Clash code remains Studio-unverified.** See [CLAN_CLASH_TEST.md](CLAN_CLASH_TEST.md) and issue #30. The current 2v2 is a prototype, not a genuine clan account/roster/ranked system.
