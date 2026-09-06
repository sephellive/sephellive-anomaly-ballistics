# BHS integration

The adapter targets the locally installed BHS reworked 0.4. `HitResult.hit_zone`
is normalized to `head`, `torso`, `leftarm`, `rightarm`, `leftleg`, or `rightleg`
and passed through `zzz_player_injuries.bhs_dbg_hit`. This makes the existing BHS
HUD update through its native update flow; Ballistics creates no body HUD.

If BHS is unavailable, Ballistics does not suppress native player damage. The
adapter is deliberately isolated because this BHS exposes no stable public API.
