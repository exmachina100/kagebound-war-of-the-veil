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
