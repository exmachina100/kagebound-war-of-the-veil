-- KAGEBOUND persistence is intentionally OFF until a published private
-- test place validates version migration, cross-server UpdateAsync semantics,
-- retries, player-leave / server-shutdown recovery and anti-duplication.
return {
    Enabled=false,
    StoreName="Kagebound_PlayerProgress_v1",
    Version=1,
    MaxRetries=3,
    MaxEventsPerCommit=48
}
