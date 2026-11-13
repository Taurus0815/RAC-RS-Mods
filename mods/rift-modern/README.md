# Rift Modern 0.15.0

**Ersteller / Author: Taurus0815**

## Deutsch

**Neu in 0.15.0:** Das Standard-HUD und die Originalmenüs bleiben aktiv; das Rift-HUD ist standardmäßig aus. Zweimal kurz die vom Launcher zugewiesene Aim-Taste drücken, um das Anvisieren ein- oder auszuschalten. Gedrückt halten bleibt temporäres Zielen. Das pausierte Schnellrad zeigt die beigefügten hochauflösenden 3D-Waffenbilder. Dafür ist der native RAC-RS-0.5.1-Patch aus diesem Repository erforderlich; ohne Patch erscheinen die originalen Spielbilder.

- Das Schnellrad pausiert weiterhin das Spiel und übernimmt die Auswahl beim Loslassen.
- Originale Controller-Belegung des Launchers und andere Menüs bleiben unangetastet.
- Bewegung, Schraubenschlüssel, Aufschlag und Bolt-Anziehung bleiben einstellbar.
- Das Rift-HUD kann in den Mod-Einstellungen ausdrücklich eingeschaltet werden; im Preset „Rift Modern“ bleibt es aus.

RAC-RS 0.5.1, OmniLoader 0.1.0, Host-ABI 1.6 und Script-API 1.3. Die hochauflösenden 3D-Waffenbilder benötigen den nativen Patch `native-patch/rift-modern-rac-rs-0.5.1.patch` aus diesem Repository; ohne Patch nutzt das Rad die Spielgrafik. Geprüft auf PAL SCES-50916 v1.00.

### Installation

Den vollständigen Ordner `rift-modern` mit `main.luau`, `omni-mod.json`, `mod.json`, `images` und `textures` nach `mods` kopieren und die Mod im Launcher aktivieren. Vorhandene Dateien vorher sichern. Mit HQ Texture Remake zusammen Rift Modern in der Aktivliste davor setzen.

## English

**New in 0.15.0:** The standard HUD and original menus remain active. Rift Modern's own HUD is off by default. Double-tap the Aim button to toggle aiming; holding it remains temporary aim. The paused wheel now displays the included high-resolution weapon portraits, with the game's Quick Select artwork as fallback.

- The Quick Select wheel still pauses the game and commits the selection on release.
- Launcher controller bindings and other menus remain untouched.
- Movement, wrench, overhead impact and bolt attraction remain configurable.
- The Rift HUD can be explicitly enabled in mod settings; it stays off in the “Rift Modern” preset.

RAC-RS 0.5.1, OmniLoader 0.1.0, host ABI 1.6 and script API 1.3. The high-resolution 3D weapon portraits require the native `native-patch/rift-modern-rac-rs-0.5.1.patch` in this repository; without it, the wheel falls back to the game artwork. Checked on PAL SCES-50916 v1.00.

### Installation

Copy the complete `rift-modern` folder, including `main.luau`, `omni-mod.json`, `mod.json`, `images` and `textures`, to `mods`, then enable it in the launcher. Back up existing files first. When used with HQ Texture Remake, place Rift Modern above it in the active list.

## Downloads / Downloads

[ZIP and previews](https://github.com/Taurus0815/RAC-RS-Mods)

## License

Scripts use the included MIT license. Weapon picture provenance and checksums are in `picture-receipt.json`.
