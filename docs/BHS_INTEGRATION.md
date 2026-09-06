# BHS integration

Installed target: BHS Reworked 0.4 (`zzz_player_injuries.script`). Its runtime
flow chooses a limb in `actor_on_before_hit`, then derives damage from the
change in actor health during `actor_on_update`. The only discovered direct
mutation entry point is `bhs_dbg_hit(limb, dmg)`, which sets internal state and
directly changes actor health.

That function is a debug helper, not a documented production API. Sephellive
therefore builds a structured BHS payload but intentionally does **not** call
the helper or suppress native damage. This prevents the forbidden state where
native damage is zeroed but custom BHS delivery fails.

The NPC adapter follows the same rule: it receives a `HitResult` contract but
does not alter engine hit power until a safe callback chain is proven.

`sep_ballistics_sink.script` is the only delivery dispatcher. It routes actor
results to the BHS adapter and NPC results to the NPC adapter, then returns a
named sink mode. Both current adapters return `native_fallback`; this makes the
fallback visible in telemetry and prevents a later caller from accidentally
zeroing native damage before custom delivery is guaranteed.

The installed callback dispatcher supports multiple registrations, but the
current in-game proof is `npc_on_hit_callback` after the native hit. That is
appropriate for telemetry but too late to replace engine damage, so NPC custom
damage remains deliberately disabled.
