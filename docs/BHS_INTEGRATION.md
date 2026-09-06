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
