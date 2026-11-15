param([Parameter(Mandatory=$true)][string]$GamePath)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $GamePath).Path
$exeDir = Join-Path $root 'build\release'
if (-not (Test-Path -LiteralPath (Join-Path $exeDir 'rac-rs.exe'))) { throw 'RAC-RS player not found in build\release.' }
$backup = Join-Path $root ('mod_backups\flight-support-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Path $backup -Force | Out-Null
$utf8 = [System.Text.UTF8Encoding]::new($false)
$target = Join-Path $exeDir 'omni'
New-Item -ItemType Directory -Path $target -Force | Out-Null
foreach ($name in @('rac1.json','rac1_reloc.txt')) {
    $path = Join-Path $target $name
    if (Test-Path -LiteralPath $path) { Copy-Item -LiteralPath $path -Destination $backup }
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot "omni\$name") -Destination $path -Force
}
# Only adjust an existing Arsenal installation; no Arsenal files are included.
$arsenal = Join-Path $root 'mods\arsenal-mastery'
$ammo = Join-Path $arsenal 'ammo.luau'
$manifestPath = Join-Path $arsenal 'omni-mod.json'
if ((Test-Path -LiteralPath $ammo) -and (Test-Path -LiteralPath $manifestPath)) {
    $code = [System.IO.File]::ReadAllText($ammo)
    if (-not $code.Contains('external_ammo_capacity')) {
        if (-not $code.Contains('local function sync_capacity()')) { throw 'Unknown Arsenal ammo module; restore from backup or adapt manually.' }
        Copy-Item -LiteralPath $ammo -Destination $backup
        $code = $code.Replace('local function sync_capacity()', "local function sync_capacity()`n" + '    if omni.setting("external_ammo_capacity") == true then return end')
        [System.IO.File]::WriteAllText($ammo,$code,$utf8)
    }
    Copy-Item -LiteralPath $manifestPath -Destination (Join-Path $backup 'arsenal-manifest.json')
    $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
    if (-not ($manifest.settings | Where-Object key -eq 'external_ammo_capacity')) {
        $manifest.settings += [pscustomobject]@{key='external_ammo_capacity';name='Ammo capacity managed by another mod';type='bool';default=$false}
        [System.IO.File]::WriteAllText($manifestPath,($manifest | ConvertTo-Json -Depth 30),$utf8)
    }
    $settingsPath = Join-Path $root 'mods\settings.json'
    if (Test-Path -LiteralPath $settingsPath) {
        Copy-Item -LiteralPath $settingsPath -Destination $backup
        $settings = Get-Content -Raw -LiteralPath $settingsPath | ConvertFrom-Json
        if ($null -eq $settings.mods.'arsenal-mastery') { $settings.mods | Add-Member -NotePropertyName 'arsenal-mastery' -NotePropertyValue ([pscustomobject]@{}) }
        $settings.mods.'arsenal-mastery' | Add-Member -NotePropertyName 'external_ammo_capacity' -NotePropertyValue $true -Force
        [System.IO.File]::WriteAllText($settingsPath,($settings | ConvertTo-Json -Depth 30),$utf8)
    }
}
Write-Output "Flight support installed. Restart RAC-RS. Backup: $backup"
