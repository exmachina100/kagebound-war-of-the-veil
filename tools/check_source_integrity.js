// KAGEBOUND lightweight repository integrity gate — no third-party packages.
// Run: node tools/check_source_integrity.js
// Validates committed source layout and design/art references ONLY.
// Never substitutes for Roblox Studio multiplayer execution or Luau typechecking.
const fs=require("fs");
const assert=require("assert");
const path=require("path");
const root=path.resolve(__dirname,"..");

function read(relative) {
    const file=path.join(root,relative);
    assert(fs.existsSync(file),"Missing required file: "+relative);
    const content=fs.readFileSync(file,"utf8");
    assert(content.trim().length>0,"Empty required file: "+relative);
    return content;
}
function present(relative) {
    assert(fs.existsSync(path.join(root,relative)),"Missing reference asset: "+relative);
}
const rojo=JSON.parse(read("default.project.json"));
assert.strictEqual(rojo.tree.ServerScriptService.KageboundServer.$path,"src/server");
assert.strictEqual(rojo.tree.ReplicatedStorage.KageboundShared.$path,"src/shared");
assert.strictEqual(rojo.tree.StarterPlayer.StarterPlayerScripts.KageboundClient.$path,"src/client");
assert.strictEqual(rojo.tree.ServerStorage.KageboundWorldV05.$path,"assets/roblox-ready/world-v05");
for(const name of ["dojo_curved_roof","dojo_offering_pavilion","dojo_ceremonial_court",
    "moonfall_arch_bridge","moonfall_bamboo_canopy","moonfall_ritual_lantern"]) {
    const file=path.join(root,"assets/roblox-ready/world-v05",name+".rbxm");
    assert(fs.existsSync(file),"Missing native art template: "+name);
    assert.strictEqual(fs.readFileSync(file).subarray(0,8).toString(),"<roblox!",
        "Invalid native model header: "+name);
}

const required=[
    "src/client/WeaponHUD.client.lua",
    "src/client/HUDLayout.client.lua",
    "src/server/WorldV05Art.server.lua",
    "docs/GAME_DESIGN.md",
    "docs/GAME_DESIGN_ORIGINAL_338.md",
    "docs/ROADMAP.md",
    "docs/CLASS_VFX_PRODUCTION.md",
    "docs/FOUR_WARRIORS_TEST.md",
    "docs/CLAN_CLASH_TEST.md",
    "src/shared/ClassRules.lua",
    "src/server/ClassService.lua",
    "src/server/ClassLoadout.server.lua",
    "src/client/ClassHUD.client.lua",
    "src/client/ClassVFX.client.lua",
    "src/shared/ClanRules.lua",
    "src/server/ClanClash.server.lua",
    "src/client/ClanClashHUD.client.lua",
    "src/server/QueueRegistry.lua",
    "src/server/DuelService.lua",
    "src/server/ShadowDuel.server.lua",
    "src/server/DuelVeilfall.lua",
    "src/server/Combat.server.lua",
    "src/server/MaskAbilities.server.lua",
    "src/server/YokaiEncounter.server.lua",
    "src/shared/VFXProfiles.lua",
    "src/client/VFXFactory.lua",
    "tests/ClassRules.studio.lua",
    "tests/ClassService.studio.lua",
    "tests/ClanRules.studio.lua",
    "tests/TeamIsolation.studio.lua"
];
for(const file of required) read(file);

const refs=[
    "assets/concept-art/ChatGPT Image Nov 9, 2026, 09_55_15 PM-1.png",
    "assets/concept-art/ChatGPT Image Nov 9, 2026, 09_55_24 PM-2.png",
    "assets/concept-art/ChatGPT Image Nov 9, 2026, 09_55_30 PM-3.png",
    "assets/concept-art/ChatGPT Image Nov 9, 2026, 09_55_36 PM-4.png",
    "assets/concept-sheets/clan-vfx-v01/KGB_VFX_Shinobi_ConceptSheet_v01.png",
    "assets/concept-sheets/clan-vfx-v01/KGB_VFX_Ronin_ConceptSheet_v01.png",
    "assets/concept-sheets/clan-vfx-v01/KGB_VFX_Onmyoji_ConceptSheet_v01.png",
    "assets/concept-sheets/clan-vfx-v01/KGB_VFX_OniDisciple_ConceptSheet_v01.png"
];
for(const file of refs) present(file);

const team=read("src/server/DuelService.lua");
assert(team.includes("x.team~=y.team"),"Clan Clash friendly-fire restriction missing");
assert(team.includes('mode=team and "ClanClash" or "ShadowDuel"'),"Legacy 1v1 compatibility missing");
const queue=read("src/server/QueueRegistry.lua");
assert(queue.includes("if waiting[player] then return false end"),"Exclusive queue guard missing");
const clan=read("src/server/ClanClash.server.lua");
assert(clan.includes("Authority.Assign(p,match.id,team)"),"Server team assignment missing");
assert(clan.includes("Veilfall.new(arena,center,Rules,palette)"),"Clan Veilfall not wired");
const rules=read("src/shared/ClassRules.lua");
for(const name of ["Shinobi","Ronin","Onmyoji","Oni Disciple"]) {
    assert(rules.includes(name),"Missing style definition "+name);
}
const classService=read("src/server/ClassService.lua");
assert(classService.includes("Duel.IsParticipant(player)"),"Class switch match lock missing");
assert(classService.includes("not inHub(root.Position,Rules.SelectionRadius)"),"Dojo selection gate missing");

// Grand World and WorldSky are separate owners: prevent future agent regressions.
const worldSky=read("src/server/WorldSky.server.lua");
const grandWorld=read("src/server/GrandWorld.server.lua");
const skyConfig=read("src/shared/SkyConfig.lua");
const runtimeRegistry=read("src/shared/RuntimeAssetRegistry.lua");
assert(worldSky.includes('WaitForChild("RuntimeAssetRegistry")'),"World sky missing published asset registry");
assert(worldSky.includes('assetRegistry.get("ui.skybox.moonfall.v01."'),"World sky registry key drift");
assert(worldSky.includes('GetAttributeChangedSignal("KageboundVeilfall")'),"Veilfall sky synchronization missing");
assert(runtimeRegistry.includes("function Registry.get("),"Runtime asset registry lookup missing");
for(const face of ["Bk","Dn","Ft","Lf","Rt","Up"]) {
    assert(skyConfig.includes(face+" ="),"Missing skybox face "+face);
}
assert(!/Lighting\\.(ClockTime|Brightness|Ambient|OutdoorAmbient)\\s*=/.test(grandWorld),
    "GrandWorld must not override WorldSky lighting ownership");
assert(!/atmosphere\\.(Density|Haze|Color|Decay|Glare)\\s*=/.test(grandWorld),
    "GrandWorld must not override WorldSky atmosphere ownership");

console.log("KAGEBOUND integrity PASS:",required.length,"text sources,",
    refs.length,"approved concept assets, Rojo paths and server isolation guards.");
console.log("Note: does not compile or execute Luau, Roblox networking, graphics or gameplay.");
