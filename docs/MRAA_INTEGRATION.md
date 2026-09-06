# MRAA integration research

## Scope and inspected installation

This document is the compatibility baseline for Sephellive Ballistics.  Boomsticks
and Sharpsticks (BaS) is explicitly out of scope: no BaS section, mapping, balance
rule, or test case is required by this project.

The local MRAA installation inspected on 2026-09-06 is:

```text
D:\mo2\mods\Оружейная переработка - Mask961
  installationFile = MRAA_v1.4.6.rar
  selected installer option = 00 MAIN - MRAA-v1.4.6 (DLTX)
```

The optional community additions package is also present locally:

```text
D:\mo2\mods\Дополнения и исправления MRAA - BixFeo
  installationFile = MRAA_Community_Additions.8.zip
```

At the time of inspection, the `Sephellive Custom Base` MO2 profile has both MRAA
entries disabled.  The `Default` profile has both enabled.  This is a deployment
state, not a reason to add compatibility for a different weapon pack; before a
playtest the target profile must enable the same MRAA packages and order used for
the test.

## What MRAA changes

MRAA v1.4.6 is an extensive DLTX patch set, principally in
`gamedata/configs/mod_system_mraa_v1_dltx.ltx` (about 7,900 lines), plus upgrade,
scope, parts, and animation scripts.  It patches existing `wpn_*` sections rather
than defining a separate MRAA-prefixed arsenal.  Representative patched families
include:

- 9x19: `wpn_glock`, `wpn_mp5`, `wpn_mp5sd`, `wpn_vityaz`, `wpn_pp2000`;
- 5.45x39: `wpn_ak74`, `wpn_ak74m`, `wpn_aks74`, `wpn_ak12`, `wpn_aek`;
- 5.56x45: `wpn_m4`, `wpn_m4a1`, `wpn_m16`, `wpn_hk416`, `wpn_g36`, `wpn_sig550`;
- 7.62x39: `wpn_ak`, `wpn_akm`, `wpn_ak103`, `wpn_sks`, `wpn_type63`;
- 7.62x51: `wpn_g3`, `wpn_fal`, `wpn_mk14`, `wpn_sr25`, `wpn_scar`;
- 7.62x54R: `wpn_svd`, `wpn_svu`, `wpn_mosin`, `wpn_sv98`, `wpn_pkm`;
- 12 gauge: `wpn_spas12`, `wpn_saiga12s`, `wpn_mp133`, `wpn_mp153`,
  `wpn_remington870`, `wpn_mossberg590`, `wpn_wincheaster1300`.

There are many section variants, especially scope/HUD variants and named variants
such as `*_nimble`, `*_custom`, `*_sk1`, `*_sk2`, `*_sk3`, and `*_sk4`.  These
must not become separate projectile profiles.  Resolve the loaded ammunition at
the firing weapon's effective `ammo_class`; a variant only needs a separate weapon
modifier if its effective ballistic weapon parameters differ after DLTX inheritance.

The BixFeo additions package contains DLTX adjustments to animations, HUD aiming
positions, icons, and a Winchester/TOZ presentation patch.  It contains no ammo
definitions and no ballistic damage-key patch.

## Ammo result

Neither inspected MRAA package defines an `[ammo_*]` section or patches `ammo_class`.
The MRAA weapons consequently use the inherited Anomaly ammo sections.  The
relevant test families resolve through vanilla sections including:

| Family | Vanilla section examples |
| --- | --- |
| 9x19 | `ammo_9x19_fmj`, `ammo_9x19_pbp`, `ammo_9x19_ap` |
| 5.45x39 | `ammo_5.45x39_fmj`, `ammo_5.45x39_ep`, `ammo_5.45x39_ap` |
| 5.56x45 | `ammo_5.56x45_fmj`, `ammo_5.56x45_ss190`, `ammo_5.56x45_ap` |
| 7.62x39 | `ammo_7.62x39_fmj`, `ammo_7.62x39_ap` |
| 7.62x51 | `ammo_7.62x51_fmj`, `ammo_7.62x51_ap` |
| 7.62x54R | `ammo_7.62x54_7h1`, `ammo_7.62x54_7h14`, `ammo_7.62x54_ap` |
| 12 gauge | `ammo_12x70_buck`, `ammo_12x76_zhekan`, `ammo_12x76_dart`, `ammo_12x76_bull` |

Condition variants ending in `_bad` and `_verybad` are distinct game sections but
should normally alias the corresponding cartridge archetype; their condition
behaviour belongs in an explicit, small override, not a duplicate profile.

## Required resolver contract

The ballistic registry must remain cartridge-centric:

```text
MRAA weapon -> effective weapon modifiers -> loaded ammo section
          -> Sephellive ammo profile -> projectile / armour / terminal result -> BHS
```

Use one central `ammo_section -> ballistic_profile` mapping.  The existing vanilla
sections above should map directly to the same profiles used by every weapon pack;
MRAA requires no dedicated ammo mapping in the inspected version.  Weapon data may
contribute a justified muzzle-velocity modifier or engine-exposed spread behaviour,
but must not provide arbitrary per-rifle terminal-damage multipliers.

The resolver must always return a valid profile.  For an unknown section it must
return a conservative vanilla-compatible fallback and, in debug mode, emit one
deduplicated warning containing the ammo section and weapon section.  An unknown
MRAA section must never crash Lua.

## Ballistic parameters and conflict surface

For the inspected MRAA DLTX, searches found no overrides of `ammo_class`,
`hit_power`, `bullet_speed`, `fire_distance`, `air_resistance`,
`fire_dispersion_base`, `fire_dispersion_condition_factor`, or `bullet_count`.
It does adjust a small number of `rpm` values and extensively changes sounds,
HUD/animation data, reload behaviour, scopes, upgrades, and magazine-related
scripts.  These systems are not projectile profiles, but reload/jam and magazine
scripts make the final loaded-ammo resolver more important than an inventory-only
lookup.

The engine-facing fields to inspect in the final merged configuration are:

- weapon: `ammo_class`, `hit_power`, `bullet_speed`, `fire_distance`,
  `air_resistance`, `fire_dispersion_base`, and condition dispersion;
- ammo: projectile/damage fields and pellet count for shotgun ammunition;
- inherited or variant sections after all DLTX patches, rather than source files in
  isolation.

## MRAA test matrix

Run this matrix only with the target configuration: Anomaly 1.5.3, required Modded
Exes hooks, MRAA v1.4.6, current BHS and BHS HUD, and the Sephellive debug workshop.
BaS is not part of that matrix.

| Family | Representative MRAA weapon | Representative ammo |
| --- | --- | --- |
| 9x19 | `wpn_mp5` | `ammo_9x19_fmj` |
| 5.45x39 | `wpn_ak74` | `ammo_5.45x39_fmj` |
| 5.56x45 | `wpn_m4a1` | `ammo_5.56x45_fmj` |
| 7.62x39 | `wpn_akm` | `ammo_7.62x39_fmj` |
| 7.62x51 | `wpn_g3` | `ammo_7.62x51_fmj` |
| 7.62x54R | `wpn_svd` | `ammo_7.62x54_7h1` |
| 12 gauge | `wpn_spas12` | `ammo_12x70_buck` |

For every scenario record weapon section, ammo section, distance, target armour,
hit zone, impact state, penetration result, terminal result, and BHS result.
Include at least an unarmoured target, a soft-armour target, and a plate target;
repeat at short, intermediate, and long practical distances.  Add AP/expanding or
slug ammunition per family after the baseline FMJ/buckshot test passes.

## Follow-up when MRAA changes

Re-run this inspection after an MRAA update or a new MRAA compatibility add-on.
Diff the effective merged sections, not only the new mod's files.  Any newly added
ammo section is a registry addition; any new weapon section using a known cartridge
should work without a new terminal-damage profile.
