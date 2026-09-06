# Technical research

## Local findings

- Base configuration source: `D:\CleanStalkerAnomaly\tools\_unpacked`.
- MRAA target: v1.4.6 DLTX; it patches existing weapon sections but no ammo sections
  or ballistic keys. Details: `MRAA_INTEGRATION.md`.
- Installed BHS: BHS reworked 0.4. It classifies actor hit bones in
  `zzz_player_injuries.actor_on_before_hit` and derives limb damage from actor HP
  in `hit_on_update`. Its available callable integration point is
  `zzz_player_injuries.bhs_dbg_hit(limb, damage)`. This is a debug helper that
  mutates actor health; it is not enabled as a production sink.
- Existing workshop uses Modded Exes callbacks including `npc_on_before_hit` and
  `npc_on_hit_callback`.
- Anomaly's `axr_main.callback_set` stores callbacks in a set, so registered
  handlers do not overwrite each other. In the local runtime, the verified
  reliable NPC source is still `npc_on_hit_callback`; pre-hit telemetry was not
  observed despite registration and therefore is not used to suppress damage.

## Selected design

The core is original Lua code. It resolves ammo to a shared cartridge profile,
calculates continuous velocity/energy retention, applies a logistic penetration
curve, then emits a normalized HitResult. `sep_ballistics_bhs_adapter.script` is
the only module that calls BHS internals. Unknown ammo preserves the native path
and only logs a deduplicated debug warning.

Native damage is never suppressed in the current branch. Player and NPC hits can
be resolved and logged through the same cartridge/impact calculation, but both
BHS and NPC adapters intentionally return to native damage until their runtime
delivery paths are proven. Mutants retain vanilla behaviour.

## References and limits

`ahuyn/anomaly-ballistics` and Arti Ballistics were examined as architecture
references only; no third-party source is included. Their public documentation
confirms the Modded Exes requirement and ammo-to-function approach. Engine APIs do
not expose complete cartridge and armour data uniformly in hit callbacks, so v1
uses conservative fallback behaviour until a runtime ammo resolver/armour adapter
is verified in-game. No medicine, plate geometry, ricochet, or environmental
penetration is implemented.
