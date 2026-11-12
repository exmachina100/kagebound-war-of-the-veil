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

## Continuation: weapon selection and lifecycle

- Added WeaponHUD.client.lua: five enabled archetypes, 44px-high selection buttons, server-confirmed selection display and timeout guidance. The UI sends only Select/name, never stats, ownership or damage. Disabled weapons are not offered.
- HUD navigation now includes Weapons (B). Compact viewports show this separately from Journal/Loadout; desktop stacks it under class selection. iPhone landscape: all five buttons measure 161x44, and the panel ends at y=298 within a 750x381 viewport.
- Keyboard activation of the Naginata UI button equipped Naginata with matching confirmed label. Selecting Tanto outside dojo was rejected and showed timeout guidance.
- Joined the real Shadow Duel queue through E at its kiosk; server QueueRegistry confirmed ShadowDuel. A UI Tanto request while queued retained Yari. CancelQueue then retry succeeded and equipped Tanto.
- Forced character respawn preserved selected Yari, created a different character with an equipped issued Yari, and reset stamina to 100. Weapon/navigation HUDs remained present.
- Five raw Light requests, each immediately followed by Heavy, registered exactly one practice hit per weapon: Katana 12, Nodachi 17, Tanto 8, Naginata 13, Yari 11. Session rewards were unchanged. This is one cross-action rejection case per archetype, not a complete latency/combination matrix.
- Updated WeaponEquipment.studio.lua to accept all enabled archetypes, rather than only the original three swords. The forged-tool contract passed separately for Katana, Nodachi, Tanto, Naginata and Yari in normal server Scripts.
- Live client combat requests while unequipped, using a locally forged clone, and after unequipping during windup each produced zero practice hits. Re-equipping the legitimate issued tool restored one hit.
- Asset upload consent received; six existing GLBs passed structural preflight. Roblox blocked the first attempt because the upload directory is not approved. No asset was uploaded. See WORLD_V05_IMPORT_PREFLIGHT.md for exact files and next step. No permission workaround attempted.

## Approved native asset integration

The user subsequently confirmed directory approval. Six model uploads succeeded, all six received Approved moderation, and all six were inserted with their expected 265 MeshParts. IDs and complete API receipts are saved in assets/world/dojo_moonfall/v05/roblox-upload-receipts.json; WORLD_V05_IMPORT_PREFLIGHT.md records the asset table and verification limits.

Native .rbxm templates were exported using Roblox SerializationService and retain all six package links. default.project.json maps them into ServerStorage/KageboundWorldV05, so the templates are source controlled and require no runtime upload/download loader. Vertex colors were visibly preserved in staging; MeshPart.Color remained default grey, so no additional color correction was applied. No embedded/image texture IDs were created.

WorldV05Art.server.lua places the offering pavilion and ritual lantern in Kage Dojo and the bamboo cluster in Moonfall. All 148 placed mesh parts are anchored, noncolliding, untouchable and nonqueryable. The roof, court and bridge remain templates pending placement/traversal review. Existing geometry, collision and hitboxes are retained. StudioSmoke now includes template and placement checks and reports 30 passes in a fresh server. The source integrity check now verifies the native model mapping/headers and 30 required source documents/scripts.

The MCP runtime screenshot showed a white 3D viewport, including with all three imported appearances temporarily removed. The user subsequently confirmed that the world is visible in their actual Studio Play view. This is a capture limitation, not a confirmed game-rendering failure. Staging screenshots render the models and colors. In-world comparison against the approved references and frame-rate budgets remain open; user confirmation of visibility does not establish final concept parity or optimization.

## Two-client harness investigation

StudioTestService launched real server/client child processes. Early fixture attempts exposed readiness/command-delivery timing problems rather than a proven game-code defect. With explicit delivery/observed-event checks, the harness confirmed both clients had server-issued Katana equipment, a server-accepted training Windup/Swing, SafeHub player protection, and no training currency. A subsequent distant-teleport phase timed out receiving client command acknowledgements. The controlled PvP fixture was moved just outside the dojo boundary to separate combat authority from long-distance streaming. Until the complete result passes, PvP parry/guard-break, full match loops and four-client Clan Clash remain unverified. Fixtures are temporary Edit data-model scripts, not mapped production code.

The boundary rerun ended with only one joined/ready client before the bounded readiness timeout. Full two-client PvP did not pass and is not certified. Temporary Edit fixtures were removed. A clean normal Play afterward passed the saved WorldV05Art.studio.lua regression and all 30 smoke checks. The test files remain available for a future controlled multi-client run; no test-only RemoteEvent or fixture is mapped into production source.

GitHub main advanced by four asset-work commits during the batch. They were fetched and merged into dev/studio-qa-20261112 without dropping the closed-polearm drafts, handoff documents or this batch's native imports. No public place version or repaired asset version was published.
