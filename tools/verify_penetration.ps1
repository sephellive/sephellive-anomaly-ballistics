$ErrorActionPreference = 'Stop'

function Get-Distribution([double] $ratio) {
    $penetrated = 1 / (1 + [math]::Exp(-5.5 * ($ratio - 1.0)))
    $stopped = 1 / (1 + [math]::Exp(5.0 * ($ratio - 0.72)))
    $partial = [math]::Max(0.0, 1 - $penetrated - $stopped)
    $total = $penetrated + $partial + $stopped
    [pscustomobject]@{
        Ratio       = $ratio
        Penetrated  = $penetrated / $total
        Partial     = $partial / $total
        Stopped     = $stopped / $total
    }
}

$rows = 0.3, 0.6, 1.0, 1.3, 2.0 | ForEach-Object { Get-Distribution $_ }
if ($rows[0].Stopped -le $rows[0].Penetrated) { throw 'Low ratio must favour STOPPED.' }
if ($rows[-1].Penetrated -le $rows[-1].Stopped) { throw 'High ratio must favour PENETRATED.' }
if ($rows[2].Partial -le 0) { throw 'Parity ratio must retain a PARTIAL band.' }
$rows | Format-Table Ratio,Penetrated,Partial,Stopped -AutoSize
