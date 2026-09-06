# Runtime pipeline probe

Second pass begins in **probe mode**. The addon does not suppress native damage,
modify NPC hit power, or call the BHS adapter until a live test proves the input
chain. This avoids a zero-native/zero-custom damage state.

`sep_ballistics_weapon_resolver` obtains the active weapon, reads its effective
`ammo_class` via Anomaly's `parse_list(ini_sys, section, "ammo_class")`, and maps
the zero-based `weapon:get_ammo_type()` to `ammo_class[ammo_index + 1]`. It returns
the weapon section, real ammo section, index, and effective `bullet_speed` for
telemetry. Lists are cached by weapon section.

Local source research confirms that vanilla NPC loadout code uses the same
`ammo_type + 1` convention. The Modded Exes `npc_on_before_hit` callback provides
`(npc, SHit, bone_id, flags)`; therefore the probe forwards its actual `bone_id`
rather than inventing a torso zone.

The original in-game gate was a debug-log capture proving:

1. active weapon section;
2. loaded ammo section selected from the effective `ammo_class`;
3. numeric ammo index and effective bullet speed;
4. actor/NPC bone id and normalized hit zone;
5. armour source/resistance after the armour resolver is added.

Executed 2026-09-06 with the Workshop AK-74: telemetry resolved
`wpn_ak74` / `ammo_5.45x39_fmj`, index 0, actual distances 6.9 m and 5.6 m,
and NPC bones 12 (TORSO) and 15 (HEAD). The unarmoured source was `none` with
resistance 0.000. A positive armour-resistance regression case remains open.

Cartridge profiles and penetration v2 are now calculation-only; native damage
remains active until a sink is proven.

The workshop dummy is deliberately non-immortal during this probe. Its former
pre-hit `power = 0` behaviour bypassed the very pipeline being validated. A safe
post-lethal/respawn wrapper may be added only after the callback order is proven.

`sep_ballistics_armor` is read-only. It reads the target's outfit slot (7), helmet
slot (12), current item condition and `GetBoneArmor(bone_id)` from the engine
objects. The raw engine resistance is emitted unchanged with its source and bone;
no durability/degradation or armour coefficient is applied in the probe.

## Bone mapping source

The zone map is aligned with the installed BHS Reworked 0.4 `hitboxes` table:
bones 14–19 map to HEAD and bones 2, 11–13, 20 and 33 map to TORSO. The executed
Workshop hits confirmed bone 12 as TORSO and bone 15 as HEAD. Unknown bone ids
now emit one warning and deliberately fall back to TORSO rather than silently
claiming precise limb data.
