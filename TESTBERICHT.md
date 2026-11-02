# Pruefung vom 1. November 2026

Referenzinstallation: RAC-RS 0.4.3, PAL SCES-50916 v1.00, OmniLoader 0.1.0, Host-ABI 1.6, Script-API 1.3. Bildpruefungen in 3440x1440. Geprueft wurden der lokal gebaute Player, Rift Modern 0.11.0 und HQ Texture Remake 1.0.0; fuer den lokalen Kompatibilitaetslauf war ausserdem extern bereits Arsenal Mastery 0.3.4 installiert. Diese Drittanbieter-Mod ist kein Bestandteil dieses Repositorys oder der Downloads.

## Ergebnisse

- Ein separater Lauf ohne installierte Arsenal-Mastery-Dateien bestaetigt den eigenstaendigen Betrieb: nur Rift Modern und HQ Texture Remake aktiv, `rift-modern loaded 0.11.0`, `HUD verified in gameplay; health source=game`, keine Script-Fehler. Der Standard und das Rift-Modern-Preset verwenden deshalb die originale Spielgesundheit; bereits gespeicherte lokale Einstellungen bleiben erhalten.
- Der Release-Build des erweiterten Players ist erfolgreich. Der native Quellpatch laesst sich mit `git apply --check` auf die unveraenderten Dateien von RAC-RS v0.4.3 anwenden.
- Der abschliessende Lauf des installierten `rac-rs.exe` mit den tatsaechlich installierten Mods lief bis Feld 2200 durch und endete regulaer. `mods/status.json` meldet beide Script-Mods als `loaded`, ohne ersetzte/kollidierende Hook-Eintraege. Das zugehoerige `player/log.txt` enthaelt keine Mod-Ladefehler oder Luau-Ausfuehrungsfehler.
- Der Texture-Pack-Loader erkennt 70 Ersetzungsnamen, 0 doppelte Namen und 0 uebersprungene Mip-Dumps. In Veldin und Kerwan werden jeweils alle 30 vorgesehenen Grundtexturen ersetzt: `30 replacements ready`, `0 failed`, `0 over ... budget`, `30 upload chains made`, `0 not made`. Die dekodierten Grundketten benoetigen etwa 29.8 MB; die Upload-Ketten einschliesslich Mips etwa 36.7 MB.
- Die Originaltexturzuordnung wurde direkt aus allen 19 Planetendatensaetzen ausgelesen. Die 30 Grundtexturen sind auf diesen Planeten identisch. Jede Ausgabe hat exakt die vierfache Breite und Hoehe des jeweiligen Originals. Mip-Dateinamen entsprechen den PCSX2-Single-/Chain-Hashes. Es gibt keine mehrdeutigen Mip-Zuordnungen. Die groesste Grundtextur waechst von 256x256 auf 1024x1024.
- RGB wurde lokal mit Real-ESRGAN x4plus hochskaliert. Die originale PS2-Alpha-Maske wird getrennt interpoliert und im fuer RAC-RS/PCSX2 erforderlichen Wertebereich 0..128 gespeichert. UV-Inseln, Seitenverhaeltnis, Hash-Zuordnung und Modellgeometrie werden nicht neu angeordnet.
- Zwei kurze Ziel-Tipps schalten die Schulterbewegung ein. Bei seitlicher Bewegung bleibt Ratchets dargestellte Blickrichtung auf dem Kamerawinkel, waehrend das echte Aim-Flag 0 bleibt. Eine normale laengere Ziel-Betaetigung bleibt temporaeres Zielen und schaltet die Verriegelung nicht aus. Zwei weitere kurze Tipps schalten zur normalen Bewegung zurueck. Der Test blieb auf derselben Bodenhoehe; es wurde kein kuenstliches Versetzen fuer die Bewegungssteuerung verwendet.
- Die Pause-Seiten Waffen, Gadgets, Schnellauswahl, Ausruestung, Hilfe, Optionen und Extras wurden ueber den nativen Menuepfad geoeffnet und wieder verlassen. Die korrigierten Optionen wurden in voller Aufloesung visuell geprueft: Beschriftungen, Auswahl, Hilfe-Bild, Hinweise und die neuen Rahmen bleiben sichtbar. Die gemeinsame Darstellung aendert keine Menue-Auswahl oder Speicherfunktion.
- Titel-/Sprachauswahl und der tatsaechlich geoeffnete Gadgetron-Haendler wurden visuell geprueft. Der Haendler wurde mit einem separaten Testspielstand geoeffnet; es wurde kein Kauf im persoenlichen Spielstand vorgenommen. Die nativen 3D-Rahmen und Vorschauen bleiben erhalten, die Farbrollen/Markierungen und die Menue-Umrahmung erhalten den Rift-Stil.
- Die zusaetzliche RAC-RS-Seite Steuerungs-Optionen wurde ueber die native Navigation geoeffnet und visuell geprueft. Eigene Tastenbelegungen sind sichtbar und bedienbar; auch die im PC-Erweiterungsbereich liegenden Menue-Elemente erhalten die neuen Rahmen.
- Nach dem installierten Lauf waren die persoenlichen Mod-Einstellungen, die Player-Optionen, das Launcher-Profil, `card.bin` und die persistente Omni-Slot-Datei bytegleich mit der Sicherung vor der Installation. Die Aktivliste wurde nur um `hq-texture-remake` ergaenzt. Wardrobe liegt in einer lokalen Sicherung ausserhalb der aktiven Mod-Ordner.

## Umfang

Die Zuordnung der Texturen ist fuer alle 19 Planeten statisch geprueft; die Laufzeit- und Bildpruefungen betreffen ausgewaehlte Szenen und Menues. Das ist kein vollstaendiger Spieldurchlauf und keine manuelle Kollisionserprobung jedes Levels. Bewegungsphysik, Kollision, Waffeneingaben und Menuefunktionen verwenden weiterhin die vorhandenen nativen Spielpfade.

Die im Texture-Pack-Log als fehlend bezeichneten HUD-/Menue-Texturen sind erwartete Nicht-Treffer: HQ Texture Remake ersetzt ausschliesslich die vorgesehenen Charakter-/Waffen-/Gadget-Texturen. Script-Mods besitzen `omni-mod.json`, kein Texture-Pack-`mod.json`; entsprechende Hinweise des separaten Texture-Pack-Scanners sind keine Script-Ladefehler.

## Rift Modern 0.12.0 — 01.11.2026

- Zielen + Viereck ergänzt nur beim echten gehaltenen Aim die native R1-Belegung. Nativer Comet-Strike-Auswurf im Instrumentierungslauf bei Feld 2755 nachgewiesen. Viereck ohne Aim und Viereck bei lediglich eingerasteter Schulteransicht bleiben Nahkampf. In der Luft gelten die originalen Bedingungen des Hyper Strike. Keine direkte Zustands- oder Positionsmanipulation für den Wurf.
- 19 farbige Waffen-/Gadget-Bilder aus den nativen Modellen gerendert (512 × 512), 136 HUD-/Händler-Texturzuordnungen über alle 19 Planeten geprüft. Das Auswahlrad verwendet 1024 × 1024 große, geglättete Ringflächen. Keine neue Ring-Geometrie pro Bild.
- Die neue native Sperre unterdrückt ausschließlich die beiden Zeichenpfade des originalen Auswahlrads. Alle 37 adressierten Routinen der 19 PAL-Planeten sind durch Hash-Abgleich geschützt. Originale Eingaben, Spiel-Update und Händlerabfrage laufen weiter. Der Lauf zeichnet die unveränderte Fade-Folge 1 bis 8 vor dem eigenen Pausenrad auf; die Sperre ist aktiv. Die Originalansicht lässt sich weiterhin wählen.
- Isolierter Integrationstest mit Kopie eines Testspielstands: Händler geöffnet, Waffenwechsel durch Loslassen bestätigt, Abbruch behält die vorherige Waffe. Zusätzlich Auswahlrad während eines Sprungs geöffnet: Höhe 60.8275 bleibt während der Pause konstant, danach läuft der Sprung weiter. Kein Rückfall zum alten Rad im geprüften Ablauf.
- Vorschaubilder stammen aus echten Spielaufnahmen. Es wurden keine Käufe im persönlichen Spielstand durchgeführt.

### English

Aim + Square was verified through the original wrench-release hook. Square without actual held aim, including toggled shoulder walking, remains melee. The native airborne action conditions are preserved. The integration run checked vendor access, the original eight-tick opening timing, weapon commit, cancellation and mid-air world pause. The original wheel is suppressed only at rendering; all supported routines require matching original-code hashes. Nineteen model renders and 136 HUD/vendor texture aliases were checked against all nineteen planets. Native weapon physics and collision are retained.

- Installierter Player: Rift Modern 0.12.0 und die separat vorhandene lokale Integration laden laut `mods/status.json`. `player/log.txt` enthält keinen Mod-Ladefehler. Persönliche Optionen, Launcher-Profil, Mod-Einstellungen und `card.bin` bleiben nach dem Lade-Test bytegleich. Händlerbilder visuell bestätigt; 754 Ersetzungen im geprüften Shop-Lauf, keine abgelehnten Bilder. Die Händler-Panels verwenden weiterhin die originalen Render-Targets, das eigene Auswahlrad zeichnet seine Bilder direkt hochauflösend.


## HQ Texture Remake 2.0.0 — 01.11.2026

4.415 unterschiedliche RGBA-Grundtexturen aus allen 19 Planetendatensätzen plus Titel, globalem HUD, Schiffen und Warp-Bundle. 26.818 eindeutige Ersetzungsnamen einschließlich Mips sowie T8-/T8H-HUD-Varianten. Alle Welt-Tabellen wurden ohne unlesbaren Eintrag erfasst. Drei gemeinsam verwendete Mip-Zuordnungen bevorzugen die direkte Originalquelle. Alle Ausgaben sind exakt 4× so breit und hoch wie das jeweilige Original, Alpha liegt in 0..128. PNG-Prüfsummen stehen in `mods/hq-texture-remake/build-receipt.json`.

RGB: lokales Real-ESRGAN x4plus, 16 Pixel periodischer Rand; Alpha getrennt bilinear interpoliert, Mips aus der HQ-Basis mit Box-Filter. 26.818 installierte Dateihashes wurden nach dem Kopieren geprüft. Das alte installierte Pack ist gesichert.

| Im Player geladener Datensatz | Welt-Ersetzungen bereit | Hauptketten RGBA8 | Fehlgeschlagen | Über Budget |
| --- | ---: | ---: | ---: | ---: |
| Veldin (0) | 402 | 330,8 MB | 0 | 0 |
| Novalis (1) | 616 | 528,8 MB | 0 | 0 |
| Gemlik-Basis (13) | 501 | 511,1 MB | 0 | 0 |
| Letztes Veldin (18) | 605 | 500,6 MB | 0 | 0 |

Novalis, Gemlik und letztes Veldin wurden mit getrennten Testspielständen visuell geprüft. Für Novalis und letztes Veldin meldet der HUD-Pfad keine fehlenden oder abgelehnten Namen; Gemlik hat drei nicht durch statische Quellen abgedeckte Laufzeitnamen, keine abgelehnten Bilder. Bei parallelen Lade-Tests gab es jeweils eine einzelne Script-Zeitwarnung; kein Script wurde gestoppt. Keine Mod-Ladefehler. Das ist kein vollständiger Spieldurchlauf aller Planeten. Dynamische Render-Targets, Videos und vom nativen Player ausgeschlossene Spezial-Slots sind keine ersetzbaren statischen Texturen.

Die zwei eigenständigen ZIP-Teile bilden zusammen ein Pack. Beide CRC-geprüft; SHA-256-Prüfsummen liegen bei. Aufgrund der Größe liegen die PNG-Dateien in den GitHub-Release-Paketen; das Repository enthält Manifest, Dokumentation und vollständige Dateiprüfsummen. Es werden keine Spielstände, Disc-Dateien, Programme oder fremden Mods mitgeliefert.

### English

The 2.0.0 pack contains 4,415 unique base textures and 26,818 replacement PNGs. All readable world tables across 19 planet datasets were exported, alongside named extra, HUD, title, ship and warp sources. Every output has exactly four times the source width and height, with original PS2 alpha preserved separately. Installed file hashes were checked after copying. Native loading of datasets 0, 1, 13 and 18 reported zero failed replacements and zero budget overruns. Novalis, Gemlik and final Veldin captures were inspected. Parallel loading produced isolated script-time warnings without stopping a mod. These mapping and loading checks do not constitute a full playthrough. Both required release ZIP parts passed CRC checks; hashes are included. Runtime-generated images and native special-case exclusions are outside static replacement coverage.

- Abschließender Lauf mit der tatsächlichen Installation und dem persönlichen Spielstand: Kerwan (3), 434 Welt-Ersetzungen / 371,9 MB Hauptketten, 0 fehlgeschlagen und 0 über Budget. Kein Mod-Ladefehler und keine Script-Zeitwarnung in diesem Lauf. `mods/status.json` führt Rift Modern 0.12.0 und die bereits separat installierte lokale Integration als geladen. `player/log.txt` erkennt HQ Texture Remake 2.0.0; die 136 doppelten Textur-Namen werden wie vorgesehen zugunsten von Rift Modern aufgelöst. Spielstand, Mod-Einstellungen, Player-Optionen und Launcher-Profil sind weiterhin bytegleich mit der Sicherung.

Final live-installation check: Kerwan loaded 434 world replacements (371.9 MB main chains), with no failures, no budget overrun and no script-time warning. Personal save and settings remained byte-identical. The 136 shared weapon-picture names correctly prefer Rift Modern.

## Rift Modern 0.12.1 — Laufstillstand / walking freeze (2026-11-02)

- Ursache / Cause: Der native Auswahlrad-Schutz registrierte durch mehrdeutige Texttreffer auch Spielroutinen, insbesondere Kerwans `HeroUpdateState` bei `0x21c1d0`. Bei aktivem Schutz blieb Ratchet in Zustand `0x65`, Laufgeschwindigkeit und Zielgeschwindigkeit blieben null. / Ambiguous address-text matching admitted gameplay routines, including Kerwan `HeroUpdateState`; the guard skipped the update and left the hero in state `0x65` with zero movement.
- Korrektur / Fix: Nur exakte Zeichen-Templates `t_350`/`t_353`, 23 Routinen auf 17 PAL-Layouts; auf den übrigen beiden Layouts bleibt der vorhandene Fade-Ersatzweg aktiv. Leere Zuordnungen melden keine Unterstützung. Die Scripts erfordern Schutz-Version 2; mit älteren Playern wird der alte Schutz ausgeschaltet. / Only exact draw templates are registered; unmatched layouts use the existing fade fallback. Scripts require guard revision 2 and disable the legacy guard on older players.
- Vergleich / Comparison: Identische Kopie des Kerwan-Spielstands, 250 Felder Vorwärtsbewegung. 0.12.0: keine Positionsänderung. 0.12.1: Y von 101,909 auf 129,825, anschließend Stillstand nach Loslassen. Beide Fälle mit denselben gespeicherten Optionen und derselben lokalen externen Integration getestet. / Same Kerwan save copy and input: the old build did not move; the fix moved 27.9 world units and stopped after release.
- Kombination / Combined check: Gehaltenes Zielen mit seitlicher Bewegung; Schultermodus per Doppeltipp ein/aus; originales Auswahlrad-Öffnen nach acht Feldern; Pause-Eintritt; Rückkehr ins Spiel und erneutes Vorwärtslaufen. Im kombinierten Lauf wurden neun originale Zeichenaufrufe unterdrückt, während die Spielfigur weiterhin lief. / Held aim with lateral movement, shoulder double-tap on/off, original eight-field wheel opening, pause entry, resume and subsequent forward movement passed. Nine original draw calls were suppressed without blocking locomotion.
- Zusätzlich / Additionally: Neue Scripts mit altem Player: Laufen wieder möglich, alter Schutz deaktiviert. `verify-wheel-guards.py` prüft jede registrierte Routine gegen die lokal generierten Zeichen-Templates und deren Code-Hash. Nativer Quellpatch lässt sich mit `git apply --check` gegen den unveränderten 0.4.3-Stand prüfen. / New scripts also restore walking with the old player. The source audit checks exact drawing-template membership and hashes.
- Alle dynamischen Prüfungen beziehen sich auf Kerwan PAL v1.00; kein vollständiger Spieldurchlauf. Keine fremde Mod, keine persönlichen Optionen und keine Speicherstände im Paket. / Runtime checks cover Kerwan PAL v1.00, not a full playthrough. No third-party mod, personal options or saves are bundled.
