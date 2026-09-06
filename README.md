# Sephellive Anomaly Ballistics

Cartridge-centric ballistic module for S.T.A.L.K.E.R. Anomaly 1.5.3. It resolves
ammunition, distance, armour interaction, and hit zone into a normalized result
with live telemetry. The BHS/NPC damage sinks are deliberately not enabled until
their runtime delivery paths are proven.

## Requirements

- S.T.A.L.K.E.R. Anomaly 1.5.3
- [Anomaly Modded Exes](https://github.com/themrdemonized/xray-monolith)
- BHS reworked 0.4 (the locally supported BHS adapter)
- MRAA v1.4.6 for the target weapon configuration

BaS is not a dependency or compatibility target.

## Installation

Download the ZIP from the latest GitHub Release and extract it directly into the S.T.A.L.K.E.R. Anomaly directory. The archive starts with `gamedata/`; it has no extra wrapper directory.

For a local checkout, run:

```powershell
./tools/install.ps1 -GamePath "D:\Stalker\Anomaly-Test"
```

The installer copies and updates this addon's files. It does not delete the game's existing `gamedata` or files belonging to other addons.

To download and install the latest GitHub Release instead of the local files:

```powershell
./tools/install.ps1 -GamePath "D:\Stalker\Anomaly-Test" -Latest
```

`-Latest` derives the repository from the `origin` remote. Public releases need no token. For a private repository, set `GH_TOKEN` or `GITHUB_TOKEN` to a token that can read the repository. Local installation never uses the GitHub API.

## Architecture

```text
ammo -> impact state -> armour -> terminal result -> safe damage sink
```

All shipped addon files are under `gamedata/`; this repository contains no MO2
packages or unrelated content modules. See `docs/` for MRAA, BHS, model, research,
and test-matrix details.

Current runtime evidence proves active weapon, loaded ammo, distance, NPC bone
and the unarmoured armour path. A positive armour-resistance regression test and
end-to-end BHS/NPC delivery remain open; native damage is retained as fail-safe.

## Branching

- `master` is stable and releasable.
- `feature/*` is for development and testing.

## Releases

Every push or merge to `master` runs GitHub Actions. The workflow packages `gamedata/`, creates version `v0.0.<run number>`, creates the matching Git tag and GitHub Release with generated notes, and uploads `<repository>-<version>.zip`.

Rerunning the same workflow keeps the same version and replaces the release asset instead of creating a conflicting tag.

## Git LFS

The template tracks common binary game assets (`.dds`, `.ogf`, `.object`, `.ogg`, `.wav`, `.tga`, and `.png`) with Git LFS. Install Git LFS before adding those files and ensure CI has access to the LFS objects. Text files such as LTX, Lua scripts, Markdown, YAML, and PowerShell remain in normal Git history.

## License

No license is selected by this template. Replace `LICENSE` with the license appropriate for your original work before publishing. Do not grant rights to game assets or third-party material you do not own.
