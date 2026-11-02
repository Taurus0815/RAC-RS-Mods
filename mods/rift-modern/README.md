# Rift Modern 0.12.1

**Ersteller / Author: Taurus0815**

## Deutsch

**Korrektur 0.12.1:** Behebt Laufen auf der Stelle. Die Ausblendung des alten Auswahlrads darf nur geprüfte Zeichenroutinen überspringen. Ältere native Player verwenden mit diesen Scripts den Fade-Ersatzweg; für den korrigierten nativen Schutz den aktuellen Quellpatch anwenden und neu bauen.

Rift-Apart-inspiriertes HUD, Menüdesign und reaktionsschnellere Steuerung für RAC-RS 0.4.3. Benötigt OmniLoader 0.1.0, Host-ABI 1.6 und Script-API 1.3. Geprüft auf PAL SCES-50916 v1.00.

- Originale Kollision, Bodenphysik und Waffenabläufe bleiben erhalten.
- Zweimal kurz Zielen antippen: Schulteransicht mit seitlicher/rückwärtiger Bewegung ein-/ausschalten. Normales Halten bleibt temporäres Zielen.
- Zielen halten + Viereck/X: nativer Schraubschlüsselwurf (Comet Strike, mit den ursprünglichen Aktionsbedingungen). Viereck allein bleibt normaler Nahkampf; Sprung-/Aufschlagaktionen laufen weiter nativ.
- Kompaktes pausiertes Auswahlrad mit farbigen Bildern aus den Waffen-/Gadget-Modellen. Ein hochauflösender Ring ersetzt die vielen kleinen Zeichenstreifen.
- Das originale Rad wird bei eingeschaltetem Pause-Rad ausgeblendet. Die originale Haltezeit und die erste Dreieck-Eingabe bleiben für Händler und andere Interaktionen erhalten.
- Waffenbilder auch im HUD und beim Händler. Geschwindigkeit, Aufschlag-Radien und Bolt-Anziehung sind in den Mod-Optionen regelbar.

### Installation

Den vollständigen Ordner `rift-modern` mit `main.luau`, `omni-mod.json`, `mod.json`, `images` und `textures` nach `mods` kopieren. Vorher vorhandene Dateien sichern und die Mod im Launcher aktivieren.

Für Schulterbewegung, gemeinsamen nativen Menü-Skin, hochauflösende Bilder im eigenen Rad und die reine Zeichenunterdrückung des alten Rads zusätzlich den [nativen Quellpatch für RAC-RS 0.4.3](../../native-patch/README.md) anwenden und den Player neu bauen. Die Bilder sind Teil dieser Mod; die ZIP installiert keinen neuen Player. Mit HQ Texture Remake zusammen muss Rift Modern in der Aktivliste davor stehen.

J schaltet die Bewegungsreaktion um, K das HUD und U die Original-Menüansicht. Diese Tasten sind frei belegbar. Die neue Wurfkombination folgt den eingestellten Ziel- und Nahkampf-Aktionen; sie schreibt keine Launcher-Belegung um. Die Option `Aim + melee: wrench throw` kann separat ausgeschaltet werden.

Die Gesundheitsanzeige verwendet standardmäßig die originale Spielgesundheit. Ein optionaler externer Modus ist für eine separat vorhandene, kompatible Nanotech-HUD-Integration gedacht. Arsenal Mastery wird nicht mitgeliefert. Bereits gespeicherte persönliche Werte bleiben erhalten.

## English

**Fix in 0.12.1:** Restores walking. Hiding the original wheel may skip only verified drawing routines. These scripts use the fade fallback on older native players; apply the current source patch and rebuild for the corrected native guard.

Rift Apart-inspired HUD, menu styling and more responsive controls for RAC-RS 0.4.3. Requires OmniLoader 0.1.0, host ABI 1.6 and script API 1.3. Checked on PAL SCES-50916 v1.00.

- Native collision, ground physics and weapon routines are retained.
- Double-tap aim to toggle shoulder framing with sideways/backward movement. Holding aim normally remains temporary aiming.
- Hold aim + press Square/X for the native Comet Strike wrench throw, subject to the original action conditions. Melee alone remains normal melee; jumping and ground impacts keep their native paths.
- Compact paused quick-select wheel with full-colour pictures rendered from the weapon/gadget models. A high-resolution ring replaces the many small drawing strips.
- The original wheel is hidden when the paused wheel is enabled. The original hold delay and initial Triangle input remain available for vendors and other interactions.
- Weapon pictures also appear in the HUD and at vendors. Animation speeds, impact radii and bolt attraction are adjustable in the mod settings.

### Installation

Copy the complete `rift-modern` folder, including `main.luau`, `omni-mod.json`, `mod.json`, `images` and `textures`, into `mods`. Back up existing files and enable the mod in the launcher.

Shoulder locomotion, the shared native menu skin, high-resolution pictures in the custom wheel and render-only suppression of the original wheel additionally require the [RAC-RS 0.4.3 native source patch](../../native-patch/README.md) and a rebuilt player. The pictures are included in this mod; the ZIP does not install a new player. When used with HQ Texture Remake, place Rift Modern above it in the active list.

J toggles movement response, K toggles the HUD and U toggles the original menu view. These keys are configurable. The wrench combo follows the configured aim and melee actions and does not overwrite launcher bindings. `Aim + melee: wrench throw` can be disabled separately.

Health rendering defaults to the original game's health. An optional external mode is intended for a separately installed compatible Nanotech HUD integration. Arsenal Mastery is not bundled. Existing personal settings are preserved.

## Downloads und Bilder / Downloads and pictures

[ZIP-Pakete und Vorschauen / ZIP packages and previews](https://github.com/Taurus0815/RAC-RS-Mods)

## Lizenz / License

Die Script-Dateien stehen unter der beiliegenden MIT-Lizenz. Waffenbilder sind aus der lokalen Disc gerenderte Spielgrafiken; die MIT-Lizenz der Scripts gilt nicht für diese Grafiken. Verarbeitung und Prüfsummen: `picture-receipt.json`.

Scripts use the included MIT license. Weapon pictures are game graphics rendered from the local disc; the script license does not apply to those graphics. Processing details and checksums: `picture-receipt.json`.
