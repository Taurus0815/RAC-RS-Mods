# Native Erweiterung fuer Rift Modern 0.11.0

Lokale Mod-Erweiterung von Taurus0815.

Basis: [AsobiCodes/rac-rs v0.4.3](https://github.com/AsobiCodes/rac-rs/tree/v0.4.3), Commit `5b1415469460192f9236e9ad7b075e37223d764a`.

Der Patch ergaenzt den benannten PC-Speicherbereich `omni.rift.shoulder_walk` und `omni.rift.menu_style`. Der Schultermodus verwendet die vorhandene native Strafe-Bewegung, ohne die echten Ziel- oder Waffenflags zu setzen. Der Menue-Skin aendert Rahmen und Schriftrollen vor dem CPU-/Sharp-GPU-Raster; er ersetzt keine Auswahl-, Speicher- oder Eingabelogik.

Im unveraenderten RAC-RS-0.4.3-Quellordner anwenden:

```powershell
git apply --check PFAD/ZU/rift-modern-rac-rs-0.4.3.patch
git apply PFAD/ZU/rift-modern-rac-rs-0.4.3.patch
```

Anschliessend RAC-RS mit seiner bestehenden lokalen Toolchain und den generierten Build-Profilen neu bauen. Der Patch enthaelt weder die generierte Spielrekompilierung noch Disc-Dateien. Den neu gebauten Spiel-Player verwenden und den Script-Mod im Launcher aktivieren. Ein spaeteres Player-Update kann diese lokale native Erweiterung ersetzen; dann den Patch gegen die passende neue Version pruefen und neu bauen.

Die Script-Dateien allein installieren kein neues Player-Programm. Ohne native Erweiterung melden die entsprechenden Funktionen ihre fehlende Unterstuetzung; die uebrigen Script-Funktionen bleiben verfuegbar. Launcher-Optionen, eigene Tastenzuordnungen und Speicherstaende sind nicht Teil des Patches.

Lizenz der nativen Aenderungen: GPL-3.0 gemaess RAC-RS. Die Script-Mods besitzen ihre jeweiligen eigenen Lizenzen.
