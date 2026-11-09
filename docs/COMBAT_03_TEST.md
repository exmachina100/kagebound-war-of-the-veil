# KAGEBOUND — Combat 0.3 / Grand World functional test

**Current status: code committed to GitHub main; Roblox Studio execution is NOT verified.**
Design authority: [GAME_DESIGN](GAME_DESIGN.md), [WORLD_VISION](WORLD_VISION.md), [ART_DIRECTION](ART_DIRECTION.md), [ASSET_MANIFEST](ASSET_MANIFEST.md). Approved visual sources ART-001 to ART-004.

## Preparation
1. Stop an existing Rojo server if it is running, then in the local repository run:
   ```powershell
   git pull origin main
   rojo serve default.project.json
   ```
2. Reconnect the Rojo plugin in Roblox Studio. In Explorer, confirm `KageboundShared/CombatRules`, `KageboundServer/Combat`, `KageboundServer/Veilblade`, `KageboundServer/RegionalVeilfall`, `KageboundClient/Combat`, `KageboundClient/CombatVFX`.
3. Use Studio Test with **2 players**, preferably R15 avatars. Repeat with R6 before release. Open Output and Explorer.
4. Grand World is active by default (`WorldConfig.Enabled=true`); **do not expect** the legacy `KageboundArena` folder. The script `RegionalVeilfall.server.lua` handles the open-world transition.

## Main controls
| Action | Keyboard / mouse | Gamepad | Touch |
| --- | --- | --- | --- |
| Light 3-hit katana | Mouse1 | R2 | SLASH |
| Heavy guard breaker | R | X | HEAVY |
| Perfect parry | F | L2 | PARRY |
| Directional dash | Q | B | DASH |
| Kitsune decoy | G | Y | FOX |
| Double jump | Space twice (release between taps) | A twice | Roblox jump twice |
Auto-created touch buttons use Roblox ContextActionService; their exact device layout is not yet visually reviewed.

## Critical test: the Kage Dojo safe hub
- Join near world coordinates (0, 0, 0). Swing and heavy should not harm another player and should not spend stamina if blocked due to the safe zone.
- Dash and double-jump traversal are allowed; they are not attacks.
- Combat should work once players have left the safe hub radius (~290 studs).

## Critical test: Moonfall Bamboo PvP
- Walk north from Dojo to Moonfall at approximately **X=0, Z=-780**. For a faster test, use the server-side Studio Command Bar **while Play is running**:
  ```lua
  for i,p in ipairs(game.Players:GetPlayers()) do
      local root = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
      if root then root.CFrame = CFrame.new((i-1)*6,8,-780) end
  end
  ```
- Check both avatars equip an approximately katana-shaped `Veilblade` tool; it is **procedural placeholder art**, not the approved final model.
- Press Mouse1. The server sends `Windup` immediately and `Swing` ~0.12 seconds afterward; damage should occur only during ~0.12 seconds of active overlap sweeps. Observe blade arcs and hit reactions.
- Press R. Heavy windup is ~0.35s, active ~0.16s; it should break an opponent's timed parry (F). Light attacks should instead be negated by a correctly oriented parry, with a visible blue counter ring.
- Verify each swing damages a given target **at most once**, even if the player stays inside the hitbox for all 3 samples.
- Attack from behind a solid wall, outside range, or facing away; damage must be rejected.
- Check `KageboundStamina` is written by the server: Light 7, Heavy 23, Parry 14, Dash 22, DoubleJump 12. Recovery is 16 stamina/second.
- Press jump twice with a release between taps. Second jump should be available only while airborne, once per airtime; repeated remote spam should not produce extra midair jumps.
- Test by rapidly firing combat remotes from a local test client; cooldowns, stamina, action lock, safe-zone logic and parry still must hold. Do not assess input security by visual FX alone.

## Regional Veilfall in Grand World
- Near Moonfall, after ~55 seconds from initial server script startup expect a **6-second warning**.
- A temporary elevated bridge near (0, 5, -742) activates for 40 seconds. First 34 seconds are ordinary active time; next 6 seconds show `Closing`.
- Check the bridge has collision only when visible and a player on it is moved safely to underlying ground before it closes.
- Rift sky-ring and bridge magenta/violet accent should reference ART-004. The open world and roads must remain connected while the feature cycles.
- Only players near the Moonfall region should receive warnings in this prototype. Later, the world event scheduler should use regional match/quest states.

## Automated contract check to run in Studio
Paste the source of `tests/CombatRules.studio.lua` into Studio's Command Bar in a live test session and confirm all assertions print PASS. This does not replace the 2-player test.

## Expected console messages
- `[KAGEBOUND] Combat v0.3: server-timed active windows / box sweeps / safe hub`
- `[KAGEBOUND] Cross-platform combat input ready (server-timed strikes)`
- `[KAGEBOUND] Reference-driven combat VFX 0.3 initialized`
- `[KAGEBOUND] Veilblade prototype equipment ready (ART-003)`
- `[KAGEBOUND] Grand World Moonfall regional Veilfall enabled (ART-004)`

## Remaining production work
- Authored, uploaded Roblox katana and character animations with timing markers, sound effects, true skin/weapon meshes, mobile touch layout polish and real camera movement. **Do not claim uploaded animation-marker sync exists yet.** Server timing is a temporary trustworthy source.
- More complex world bosses/quest fights and 4 style loadouts. PvE NPCs are not yet included in the combat sweep.
- Studio runtime test + high-ping combat evaluation + low-end mobile profile + screenshot matching ART-001..004.
- Combat sweeps currently target other players only; later introduce damageable NPCs with role/faction filter and server-owned health.

**Pass gate:** 2 players can fight outside the safe hub without duplicate hits or remote exploits; attack timings, parry/guardbreak, stamina, movement, weapon attachment, regional Veilfall and safe-zone behavior are confirmed in Studio.
