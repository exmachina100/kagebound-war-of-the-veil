# KAGEBOUND MCP repair validation — 2026-11-12

Baseline fetched from main: `789592728cf24c838f26a0693705f99a953038b5` (supersedes requested historical HEAD). Clean checkout before this work. Separate Weapon/Character and Environment/VFX agents owned distinct files; only the coordinator wrote production Studio sources.

## Verified changes

- Nodachi/Tanto fallback geometry now scales part lengths, centers and grip together. Naginata/Yari trails use their actual blade parts and attachments inside their blade bounds.
- Imported weapon clones remove executable descendants before entering the Tool.
- Four optional environment loaders use `CosmeticWorldArt.Clone`: code removal and anchored/noncolliding/nontouchable/nonqueryable physics happen while detached; placement occurs before parenting. BasePart roots and Model descendants are covered. Originals remain unchanged.

## Studio MCP evidence

Studio `db6e4052-87a7-4f9f-92f1-0f7688df29f0`, KAGEBOUND place `92077795105213`, universe `10775551787`.

- Edit inventory: 22 existing staged models, 328 MeshParts, 271 textured parts, zero missing MeshIds, executable descendants or unsafe cosmetic parts. These were already imported; this pass does not claim 22 new imports.
- Fresh `InsertService:LoadAsset(75167262671129)` succeeded: 30 MeshParts, zero scripts; temporary detached container destroyed. This checks retrieval of one recorded persistent package, not every package.
- Environment fixture: 12 checks passed, including root parts, nested code removal, unchanged source/pivot/size and invalid templates.
- Weapon fixture: old live source failed `Nodachi size Handle`; edited source passed proportional sword geometry, five trail anchors, cosmetic physics and detached import sanitation. Fixtures destroyed.
- Synced edited source files plus the missing latest-main MoonfallHuntRules module and MoonfallHunt script. Each production source assignment was compared byte-for-byte during synchronization. This is a focused sync, not certification of every Studio source against main.
- Play startup: `30 checks passed, 0 failed`. One player character and Veilblade, generated world, three enemies observed server-side. Five equipped-weapon visual assertions passed.
- Direct MCP execution of WeaponEquipment failed to observe the issued-tool module state. Repeated in an actual temporary server Script: attributes `Completed=true`, `Passed=true`, `Error="nil"`. Do not interpret direct command-context module state as gameplay authority failure. Temporary Script discarded by stopping Play.
- Stopped Play, `save_place` returned `Saved`, `location=TeamCreate`, `version=37`. A later disposable Play test returned to Edit. No publish or close/reopen persistence test performed.

## Offline checks

`node tools/check_source_integrity.js`, `node tools/check_kagebound_obj.js`, `node tools/check_studio_import_batch.js`, and `git diff --check` passed. These do not replace Studio rendering/gameplay checks.

## Remaining limits

Staging weapons/masks remain drafts: Veilblade source height 8.73 studs, no final wield/head fit approval. No promotion into production art folders; optional v07/v09 environment libraries remain absent. Bamboo grove has 125 MeshParts and needs performance review. No two-client combat, mobile, full VFX, animation, visual parity or closed/reopened place test.

Progression persistence remains intentionally disabled (`PersistenceConfig.Enabled=false`); save version 37 verifies place saving, not player DataStore persistence. Console includes existing `cloud_2236283930.Vehicle Sim script:95` syntax errors and `rbxassetid://203785492` asset-type failures; their origin was not repaired or attributed to repository code. Sky IDs are still absent and atmospheric fallback remains active.

Referenced prior chat returned unresolved content-reference markers and no attachments. No external build/generation credits used; no KUMO/Witness repositories touched.
