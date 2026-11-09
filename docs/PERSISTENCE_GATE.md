# KAGEBOUND — Safe Persistence Gate (future P5 milestone)

**Current status:** source infrastructure only. KAGEBOUND's live `RewardService.lua` is **still session-only**. New `src/shared/ProfileSchema.lua`, `src/shared/PersistenceConfig.lua` and `src/server/ProfileStore.lua` are committed, but `PersistenceConfig.Enabled=false` and ProfileStore is not connected to live rewards or player joins.

## New infrastructure
- Versioned schema v1 for Spirit Shards, Veilblade Mastery, Yokai defeat count and permanent Whispers quest completion.
- Deterministic, pure `Schema.Apply(previous, source, token)` — repeats of old quest/encounter tokens cannot award twice.
- Bounded 128 recent Yokai receipts, sanitized counters and fail-closed unknown future schema versions.
- Server-only `ProfileStore.Load` and `ProfileStore.SaveEvents`, using Roblox GetAsync / UpdateAsync, bounded retries with jitter and metadata preservation.
- Feature flag OFF by default. No client RemoteEvent can call this adapter. No paid backend.

## Why it is disabled
- Roblox Studio API access is disabled by default, and enabling it against a live place could change production records.
- DataStore saves can have ambiguous failure outcomes and multiple servers can attempt the same key. Rewards will be saved as replay-safe events, not as blind absolute counter overwrites.
- `UpdateAsync` callbacks must not yield. Concurrent writes to a key need ordering and a lifecycle design.
- Do not enable without private published-place tests of save/reload, migration, disconnect, player-leave, session conflict, retries and failure UX.

## Ordered implementation gates
1. Run `tests/ProfileSchema.studio.lua` for pure migration/duplicate award policies in the SERVER Command Bar.
2. Run `tests/ProfileStore.studio.lua`; verify the disabled adapter never requests live DataStores.
3. Connect ProfileStore to RewardService behind a per-player loaded/failed status and prohibit rewards on load failures. This must first be developed in a separate private test place.
4. Add ordered per-player reward event queues and bounded retries with ambiguous outcome reconciliation, autosave and BindToClose logic.
5. Enable the feature flag ONLY in a private test environment and store namespace; verify actual saves and cross-server concurrent loads.
6. Confirm one-time quest completion, Yokai respawn and repeated tokens never generate duplicated currency.
7. Test crash/disconnect/data migration and failure UI before considering a production rollout.

## Explicitly not implemented
No live durable saves, queue/lease/session lock, inventory, purchases, cosmetics, secure trading, or automatically migrated records. No claim of Roblox Studio execution.

## Official Roblox references
- https://create.roblox.com/docs/cloud-services/data-stores
- https://create.roblox.com/docs/reference/engine/classes/GlobalDataStore
- https://create.roblox.com/docs/cloud-services/data-stores/best-practices