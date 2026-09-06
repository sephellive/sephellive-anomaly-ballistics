# Test matrix

Run with Anomaly 1.5.3, Modded Exes, MRAA v1.4.6, BHS reworked 0.4, BHS HUD, and
the Sephellive workshop. BaS is excluded.

| Cartridge | Representative weapon | Ranges | Armour |
| --- | --- | --- | --- |
| 9x19 FMJ/AP | `wpn_mp5` | 10/50/100 m | none/light/plate |
| 5.45 FMJ/AP | `wpn_ak74` | 10/100/250 m | none/light/plate |
| 5.56 FMJ/AP | `wpn_m4a1` | 10/100/250 m | none/light/plate |
| 7.62x39 FMJ/AP | `wpn_akm` | 10/100/250 m | none/light/plate |
| 7.62x51 FMJ/AP | `wpn_g3` | 10/150/350 m | none/light/plate |
| 7.62x54R | `wpn_svd` | 10/150/350 m | none/light/plate |
| 12ga buck/slug | `wpn_spas12` | 5/25/75 m | none/light/plate |

The Workshop provisions these exact representative sections with the matching
vanilla ammo sections on Fake Start. They are referenced by the installed MRAA
v1.4.6 DLTX, so the test exercises the active MRAA configuration without adding
per-weapon ballistic profiles.

For each row record weapon section, ammo section, distance, target armour, hit
zone, impact velocity/energy, penetration state, terminal result, and BHS limb
result. Results are intentionally not fabricated.

## Executed P0 evidence — 2026-09-06

Configuration: Anomaly 1.5.3 + Modded Exes + MRAA v1.4.6 + BHS Reworked 0.4 +
Sephellive Workshop. The local Workshop spawned `wpn_ak74` loaded with
`ammo_5.45x39_fmj`; the real NPC hit callback produced the following telemetry:

| Weapon | Ammo | Distance | Bone / zone | Armour | Result |
| --- | --- | ---: | --- | --- | --- |
| `wpn_ak74` | `ammo_5.45x39_fmj` | 6.9 m | 12 / TORSO | none / 0.000 | PENETRATED |
| `wpn_ak74` | `ammo_5.45x39_fmj` | 5.6 m | 15 / HEAD | none / 0.000 | PENETRATED |

This proves the active-weapon, loaded-ammo, distance, NPC bone and unarmoured
resolver paths. A positive armour-resistance case remains required before a
damage sink can be enabled.
