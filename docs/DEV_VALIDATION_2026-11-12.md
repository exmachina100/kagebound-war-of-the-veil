# Development validation — 12 November 2026

## Source update

Documents checkout fast-forwarded 316 commits from a9c813c to ad0a495 (GitHub main at fetch). Existing local place and concept files preserved under local-backups/before-main-sync-20261112. Original untracked concept folder moved there to allow tracked upstream concept files to install. Live Studio source synchronization observed, including local fixes below. No GitHub push or Roblox publication performed.

## Fixes implemented locally and synchronized to Studio

- StudioSmoke waits up to 35 seconds for MoonfallBamboo after the world folder appears, removing the reproduced early false failure.
- RegionRules requires WorldConfig before reading its Zones and Routes, fixing runtime exceptions in discovery and guide spawning.
- MoonfallHunt replaces accidentally embedded literal newline escapes in code/comments with actual newlines. This restores script compilation, progress calculation, acceptance and disconnect cleanup.
- WorldConfig adds the MoonfallBamboo–ShogunLastCity road required by Scout Hana's existing journey. The existing topology regression test exposed this missing edge.

## Checks performed

- Repository source-integrity check: PASS (27 required text sources and 8 approved concept assets; this is not a Luau compiler).
- Repository OBJ/MTL checks: PASS for Veilblade and practice-post exports.
- git diff --check: PASS.
- Fresh Studio startup: 28 smoke checks pass, zero fail.
- Three guide NPCs and Moonfall hunt notice spawn after fixes.
- RegionRules, WorldGuideRules, WorldTravelQuest, WeaponRules, WeaponAttackRules, CombatRules, RewardPolicy, DojoTraining and WeaponEquipment: all nine existing scripts PASS in a temporary normal server Script; runner removed afterward.
- Initial equipment assertion from MCP's command execution context failed to see private issued-tool state. Repeating the existing test in a normal server Script passed, including forged-tool rejection and restoring the legitimate tool. No production authority change was made based on that command-context result.
- Live client Select requests equip Katana, Nodachi, Tanto, Naginata and Yari with matching selected and tool visual attributes. Yumi request rejected; Yari remained selected. Restored Katana afterward.
- With the player positioned by the server at PracticePost_1, a client Light request changes health 120 to 108 and HitCount 0 to 1. Spirit Shards and Veilblade Mastery remain zero. This confirms one practice hit, not multiplayer safety or the complete combat timing suite.
- New class, Clan Clash, quest, region and other HUD ScreenGuis present on client.
- Post-fix inspected error logs show external cloud Vehicle Sim plugin syntax errors; earlier RegionRules and MoonfallHunt failures absent. No claim that unrelated plugin errors are fixed.

## Outstanding acceptance

Two/four-client combat and match testing; guide prompt acceptance and physical travel completion/reward replay; hunt kills and reward receipt behavior; five-weapon damage/reach/latency tests; respawn lifecycle; mobile/controller and visual inspection. Imported environment libraries are absent, so loaders retain procedural fallback. Persistence remains disabled.

Studio left running the updated local build with Katana selected. Source fixes are uncommitted local changes; backups must not be included in a future commit.

## Continuation: travel, hunt and HUD

- Accepted Elder Kaito's DojoGuide prompt with the normal E interaction, navigated the character from dojo to Moonfall using Studio's navigation tool (10x speed), and observed completed journeys=1, cleared destination and exactly 10 session shards. This is one navigated route, not a complete world traversal or normal-speed performance test.
- Accepted CityArchivist with E, used server-controlled repositioning to its Yomi destination, and observed one completion and +10 shards. Returning to the guide and pressing E again left the quest empty and rewards unchanged. This was a controlled destination check, not a walking test of that route.
- Accepted the Moonfall hunt with E. Controlled server EnemyDamage hits defeated three original Lantern Yokai. Final totals from a zero baseline: 3 defeats, 43 shards (18 enemy + 25 bounty) and 12 mastery; hunt status Completed and progress 3. Repeating the bounty receipt returned false and changed no totals. This does not certify sword input, combat balance or multiplayer last-hitter behavior.
- Added tests/MoonfallHunt.studio.lua to reproduce the isolated active-hunt integration check using a normal server Script. Test deliberately changes disposable session rewards and returns the player to their original position.
- Added HUDLayout.client.lua to coordinate existing HUD positions. Wide viewports use separate journal/loadout columns and smaller control hints; compact viewports offer mutually exclusive Journal and Loadout overlays. J/L shortcuts and keyboard activation of a selected Journal button were verified live. Pointer click through the MCP tool did not reliably activate UI; pointer/touch device interaction remains pending.
- iPhone 17 Pro landscape simulation: viewport 750x381. Initial journal overflow was fixed by omitting its duplicate travel heading on short viewports. Region journal ends at y=212 and quest card at y=334, both within the viewport. No text scaling was needed for these cards. The game allows Sensor orientation; portrait was not tested.
- HD 1080 simulation: viewport 1919x1079. All nine managed visible base HUD panels had zero pairwise rectangle intersections. Default viewport screenshot visually confirmed readable stacked journal cards with unobstructed loadout/quest areas. Match, transient notification and touch action overlays still need their own acceptance pass.
- Device simulation stopped and Studio reset to default viewport. Final fresh startup still reports 28 smoke passes, zero failures. External cloud Vehicle Sim syntax errors remain.
- Windows computer-use initialization failed with a package-resolution permission error. Used Studio MCP keyboard interaction, GUI rectangle measurements, device simulation and screenshot review instead; no Windows app controls were changed.
