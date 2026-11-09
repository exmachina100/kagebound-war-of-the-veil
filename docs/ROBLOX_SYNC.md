# GitHub → Rojo → Roblox Studio setup

Repo: https://github.com/exmachina100/kagebound-war-of-the-veil

1. Install Git, the [Rojo CLI and Roblox Studio plugin](https://rojo.space/), and Roblox Studio on your Windows PC.
2. Clone: `git clone https://github.com/exmachina100/kagebound-war-of-the-veil.git`
3. `cd kagebound-war-of-the-veil`
4. Run `rojo serve` in that folder.
5. Open Roblox Studio, create a **Baseplate** experience, and connect the Rojo plugin to the local Rojo server.
6. Explorer should contain `ReplicatedStorage/KageboundShared/GameConfig`, `ServerScriptService/KageboundServer/Boot`, `StarterPlayer/StarterPlayerScripts/KageboundClient/Boot`. Names may depend on Rojo's file mapping.
7. Press Play and inspect Output for [KAGEBOUND] server/client logs.
8. Commit changes to GitHub with `git add . && git commit -m "..." && git push origin main`.

Live Rojo sync copies source files from the local checkout into Studio; GitHub commits **do not directly update an open Studio place**. Geometry, animation, particle emitters and place publishing need their own Roblox Studio or asset pipeline. Source is the GitHub repo, not the Studio session.

**Sync status:** GitHub project setup only. No local Rojo server or Roblox Studio plugin connection was verified.

Roblox official: https://create.roblox.com/docs/projects/external-tools
