# Ballistics model

`ammo section -> profile -> impact state -> armour result -> terminal result -> BHS`.

Profiles in `sep_ballistics_ammo.script` hold mass, nominal velocity, penetration,
drag, retention, tissue, blunt-transfer, pellet count and projectile archetype.
Velocity and penetration decay exponentially with distance. Armour outcomes are
`STOPPED`, `PARTIAL`, or `PENETRATED`; the transition is a logistic probability
curve, not a tier threshold. AP favours penetration and sacrifices tissue effect;
buckshot aggregates pellets and is weak against armour; slugs transfer high blunt
energy.

All tuning values live in the profile registry or shared formula module. No MRAA
weapon receives its own terminal-damage profile.
