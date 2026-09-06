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

The next in-game gate is a debug-log capture proving, for a fired MRAA weapon:

1. active weapon section;
2. loaded ammo section selected from the effective `ammo_class`;
3. numeric ammo index and effective bullet speed;
4. actor/NPC bone id and normalized hit zone;
5. armour source/resistance after the armour resolver is added.

No cartridge values are balanced or changed in this probe pass.

The workshop dummy is deliberately non-immortal during this probe. Its former
pre-hit `power = 0` behaviour bypassed the very pipeline being validated. A safe
post-lethal/respawn wrapper may be added only after the callback order is proven.
