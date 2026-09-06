$ErrorActionPreference = 'Stop'

$path = Join-Path $PSScriptRoot '..\gamedata\scripts\sep_ballistics_ammo.script'
$text = Get-Content -LiteralPath $path -Raw

foreach ($profile in '9x19_hp', '45_hp', '545_ep', '556_ss190', '12_buck', '12_slug', '12_dart') {
    if ($text -notmatch ('\["' + [regex]::Escape($profile) + '"\]')) {
        throw "Missing cartridge profile: $profile"
    }
}

foreach ($section in 'ammo_9x19_pbp', 'ammo_11.43x23_hydro', 'ammo_5.45x39_ep', 'ammo_5.56x45_ss190', 'ammo_12x76_dart') {
    if ($text -notmatch ('\["' + [regex]::Escape($section) + '"\]')) {
        throw "Missing ammo mapping: $section"
    }
}

Write-Output 'Registry coverage checks passed.'
