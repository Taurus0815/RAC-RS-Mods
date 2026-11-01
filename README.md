# RAC-RS Mods von Taurus0815

Mods fuer Ratchet & Clank 1 im PC-Port RAC-RS. Aktuell lokal mit RAC-RS 0.4.3, PAL SCES-50916, OmniLoader 0.1.0 / Host-ABI 1.6 / Script-API 1.3 geprueft.

| Mod | Version | Inhalt |
| --- | --- | --- |
| [Rift Modern](mods/rift-modern) | 0.11.0 | Rift-inspiriertes HUD und Menue-Design, reaktionsschnelleres Movement, Doppeltipp-Schultersteuerung, pausiertes natives Auswahlrad, schnellere Schraubschluessel-Aktionen und Aufschlag-Erweiterung |
| [HQ Texture Remake](mods/hq-texture-remake) | 1.0.0 | Originalgetreue lokale 4x-Hochskalierung von Ratchet, Clank und gehaltenen Waffen/Gadgets inklusive Schraubschluessel; passende Transparenz und Mipmaps |

## Installation

Den jeweiligen Unterordner aus `mods` in den `mods`-Ordner der eigenen RAC-RS-Installation kopieren und im Launcher aktivieren. Fertige ZIP-Pakete liegen unter [downloads](downloads). Vorhandene Mod-Ordner vorher sichern. Eigene Einstellungen, Tastenbelegungen, Speicherstaende und Launcher-Profile sind in diesen Paketen nicht enthalten.

Fuer die native Schulterbewegung und den gemeinsamen Menue-Skin von **Rift Modern** ist zusaetzlich die [native Erweiterung fuer RAC-RS 0.4.3](native-patch) erforderlich. Die lokale Referenzinstallation benutzt bereits den damit gebauten Player. Das HUD und die restlichen Script-Funktionen werden durch `omni-mod.json` geladen. Die nativen Aenderungen stehen als Quellpatch bereit; eine komplette RAC-RS-Spielinstallation wird nicht hochgeladen.

Texture Packs werden beim naechsten Planetenladen bzw. Spielstart uebernommen. HQ Texture Remake enthaelt 30 unterschiedliche Grundtexturen und 70 PCSX2-kompatible Ersetzungsdateien; die Zuordnung wurde gegen alle 19 Planetendatensaetze geprueft. Die groessten 256x256-Texturen werden 1024x1024 gross. Es handelt sich um hochskalierte Originalgrafiken, nicht um neue 3D-Modelle. Die Erstellung erfolgte lokal mit [Real-ESRGAN x4plus](https://github.com/xinntao/Real-ESRGAN); Herkunft und Pruefsummen stehen im Paket.

Ersteller von Rift Modern und HQ Texture Remake: **Taurus0815**. Arsenal Mastery wird nicht mitgeliefert. Wardrobe ist entfernt und wird ebenfalls nicht mitgeliefert.

## Pruefung und Lizenzen

Siehe [Testbericht](TESTBERICHT.md). Jede Mod behaelt ihre eigene Lizenz und Herkunftsangabe. Die Texture-Pack-Grafiken sind abgeleitete Spielgrafiken aus der lokalen Disc; die MIT-Lizenzen der Script-Mods gelten nicht fuer diese Grafiken. Es werden keine ISO, Speicherstaende, persoenlichen Konfigurationen, Toolchain-Binaries oder Zugangsdaten mitgeliefert.
