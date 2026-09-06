# Ballistics model

The system is cartridge-centric. Weapon sections provide the loaded ammo
section and their effective inherited `bullet_speed` becomes a bounded muzzle
factor against the profile's nominal velocity; terminal values are never
hand-authored per rifle.

## Penetration v2

`ratio = impact_penetration / effective_armor_resistance` feeds two continuous
curves: penetration rises around parity, while stopped outcome dominates below
parity. Remaining probability becomes `PARTIAL`. Each outcome carries a
residual-energy fraction: stopped is zero, partial is bounded low, and
penetrated scales continuously with ratio. Armor degradation remains telemetry
only until a safe engine adapter is validated.

## Projectile archetypes

- FMJ: baseline penetration and tissue effect.
- AP: stronger penetration, lower tissue output.
- Enhanced FMJ/steel-core loads (for example 5.45 EP and 5.56 SS190) sit
  between FMJ and AP rather than borrowing either profile wholesale.
- HP: weaker armor penetration but increased tissue and bleeding after
  successful soft-tissue penetration.
- Buckshot: per-pellet abstraction. One hit event is one pellet; total shell
  mass is never multiplied again by pellet count.
- Slug: high blunt transfer and meaningful penetration.
- Dart: a separate real 12ga section, treated as a light AP projectile rather
  than being incorrectly folded into a slug profile.

Native damage remains active until BHS/NPC sinks are proven end-to-end.
