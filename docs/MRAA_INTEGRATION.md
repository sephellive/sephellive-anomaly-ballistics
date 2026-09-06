# MRAA integration

Research target: the locally installed `Оружейная переработка - Mask961`,
whose `meta.ini` identifies the archive as **MRAA v1.4.6**.

## Findings

- The addon is a DLTX/HUD, animation, sound and upgrade patch. Its main file is
  `configs/mod_system_mraa_v1_dltx.ltx`.
- It patches existing weapon sections (including HUD variants), but declares no
  `ammo_class`, `bullet_speed`, `hit_power`, `fire_distance` or
  `air_resistance` values in that file.
- It adds no ammo sections. MRAA weapons therefore inherit the effective
  Anomaly ammo sections and ballistic fields from their resolved weapon bases.
- The only directly found dispersion-related override is camera dispersion;
  it is not a cartridge profile and is intentionally outside Sephellive's
  terminal-ballistics model.
- MRAA-specific mechanisms found in the installed files are animations,
  sounds, HUD sections, scopes and upgrades. No custom projectile or ammo
  mechanic was found.

## Compatibility rule

`MRAA weapon -> effective ammo_class -> loaded ammo section -> Sephellive
profile` is the sole compatibility path. The weapon resolver reads the final
effective `ammo_class` and maps `get_ammo_type() + 1` to its loaded section.
This keeps the system cartridge-centric: two MRAA weapons using one cartridge
share one projectile profile; weapon `bullet_speed` is telemetry/a future
muzzle modifier, never a per-weapon damage profile.

No BaS compatibility code is present or planned.

## Runtime validation still required

Run one representative MRAA weapon for each cartridge family actually present
in the installed version and record the telemetry fields in `TEST_MATRIX.md`.
Unknown sections use the existing fallback profile and produce a deduplicated
debug warning instead of a Lua crash.
