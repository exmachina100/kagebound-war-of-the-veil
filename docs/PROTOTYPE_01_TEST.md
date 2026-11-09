# Combat Prototype 0.1 — Studio validation

## Included
- Server-generated Moonfall Bamboo greybox (stone platform, boundaries, torii, bamboo, lanterns, two spawn pads).
- Server-authoritative light combo (3 hits: 12/14/18 damage), heavy (27 damage), narrow-angle parry window (0.32 seconds), directional dash and cooldowns.
- Local HUD and temporary neon pulse effects. These **are not** final katana models, animations, particle art or audio.
- All gameplay scripts synchronized by Rojo; no manual map-building required for this prototype.

## After GitHub commit
On Windows, in cloned local repo:
```powershell
git pull origin main
rojo serve default.project.json
```
Reconnect Rojo in Studio if needed. Do not run two Rojo servers on the same port.

## Play test
1. Studio → Test → **Start** with 2 players (test client/server sessions; exact control location depends on Studio version).
2. Find `Workspace/KageboundArena`, `ReplicatedStorage/KageboundCombat`, `ServerScriptService/KageboundServer/Combat`, `StarterPlayer/StarterPlayerScripts/KageboundClient/Combat`.
3. Confirm Output: `[KAGEBOUND] Moonfall Bamboo greybox loaded`, `[KAGEBOUND] Shinobi combat server ready`, `[KAGEBOUND] Shinobi combat controls ready`.
4. Move close to opponent and face them. Mouse1 rapidly to advance 3-hit combo; R heavy; F parry just before the opponent's strike; Q dash in movement direction (or facing direction when stationary).
5. Confirm health decreases only when in range and facing the opponent, parry negates a timed strike, cooldowns prevent spam, and shots do not hit through solid cover.
6. Stop then Play again: arena regenerates without duplicating geometry.

## Known limitations and next work
- Combat is a first pass, **not yet verified by an actual Roblox Studio session**. Test physics and input with two live Studio clients.
- Attack hit tests are instantaneous (no animation wind-up). One attack may hit multiple opponents in a cone. Replace with animation marker-driven hit windows.
- Dash uses replicated root velocity; tune force and anti-speed-exploit monitoring for production.
- No team ownership, match timer, spawn selection, energy meter, camera lock, mobile controls, persistence, final VFX/animations or Veilfall yet.
- Decorative bamboo is non-colliding on purpose. Geometry and lighting are greybox approximations.

## 0.2 art / Veilfall / Kitsune test pass (not yet executed)
**Reference gates:** ART-001 hero mood, ART-002 blocky character proportions, ART-003 mask/katana design, ART-004 Moonfall world and Veilfall layout.

- New environment script: `src/server/MoonfallArt.server.lua`. Confirm shrine tiers, torii, distant moon, violet center sigil, cliff routes, lamp accents and atmosphere without obstructing combat.
- New cosmetic VFX: `src/client/CombatVFX.client.lua`. Swing produces narrow magenta sword arc, parry blue circular ring, hit gold glint, dash purple foot ring.
- Veilfall server: `src/server/Veilfall.server.lua`. Approximately 35 s after server start: 6 s warning, then 40 s spectral platforms enabled, with 6 s closing notice before deactivation. Confirm colliders only exist while visible. Validate safe relocation of players atop a platform on closure. Timing is temporary and not integrated with match state.
- Kitsune mask prototype: press **G**. Server spawns a brief block-figure magenta illusion that moves ahead and vanishes after 3.5 s. Cooldown 14 s; never deals damage. It is a visual decoy **not yet a genuine target for combat logic**.
- Test with 2 Studio players; test on mobile device emulation and low graphics before marking an art pass polished.
- Log any errors from the `[KAGEBOUND]` startup messages and capture a screenshot for comparison with approved concept references.

**Remaining acceptance gap:** no proper katana mesh/rig/animation, no finished VFX, no best-of-five match loop or dojo return, no 3-mask or multi-arena MVP. No scripted assets have been verified in a running Roblox Studio session here.

## Server-owned stamina regression (unverified)
1. Use two-player test after `git pull origin main` and a Rojo reconnect.
2. Confirm `ReplicatedStorage/KageboundShared/CombatRules` and `StarterPlayerScripts/KageboundClient/StaminaHUD`.
3. Press **Mouse1**: subtract 7 spirit stamina per accepted attack. Press **R**: 23; **F**: 14; **Q**: 22. Passive recovery is 16 per second up to 100.
4. Rapidly spam attacks: once stamina drops below cost, the server should reject the action and should not broadcast Swing/Hit or parry/dash FX.
5. With two players, attack from outside range or behind a wall: no damage. Parry from the correct facing direction in the timing window: no damage.
6. Client controls never set `KageboundStamina`; only the server writes it.
7. Desktop HUD may still show placeholder visual artifacts; document screenshot mismatches against ART-001 to ART-004.

Security caveat: This is a prototype with server authority for combat decisions and stamina costs, not a certified anti-exploit system. Test remote event spam and movement exploits in Studio.
