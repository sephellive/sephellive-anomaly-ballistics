$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path (Join-Path $root 'gamedata'))) { throw 'Missing gamedata root.' }
if (Test-Path (Join-Path $root 'packages')) { throw 'Obsolete packages directory present.' }

$forbidden = rg -n -i 'boomsticks|sharpsticks|\bbas\b' (Join-Path $root 'gamedata')
if ($LASTEXITCODE -eq 0) {
    $forbidden
    throw 'BaS-specific text found in tracked source.'
}
if ($LASTEXITCODE -gt 1) { throw 'Repository text scan failed.' }

Write-Output 'Repository scope checks passed.'
