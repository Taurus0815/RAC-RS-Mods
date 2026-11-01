# Rift Modern — native Erweiterung / native extension

**Mod-Erweiterung / Mod extension: Taurus0815**

## Deutsch

Für Rift Modern 0.12.0 auf [RAC-RS v0.4.3](https://github.com/AsobiCodes/rac-rs/tree/v0.4.3), Basis-Commit `5b1415469460192f9236e9ad7b075e37223d764a`.

Der Patch ergänzt die native Schulterbewegung, Menüfarben und hochauflösende Mod-Bilder. Das alte Auswahlrad wird ausschließlich beim Zeichnen unterdrückt; dessen Eingaben, Öffnungszeit und Händler-Priorität bleiben erhalten. Der Wurf selbst verwendet die vorhandene Comet-Strike-Routine. Persönliche Optionen und Spielstände sind kein Teil des Patches.

Im unveränderten RAC-RS-0.4.3-Quellordner:

```powershell
git apply --check PFAD/ZU/rift-modern-rac-rs-0.4.3.patch
git apply PFAD/ZU/rift-modern-rac-rs-0.4.3.patch
```

Danach den Player mit der vorhandenen lokalen Toolchain und den generierten Build-Profilen neu bauen und diesen Player starten. Zusätzlich den vollständigen Script-Mod aktivieren. Die ZIP enthält einen Quellpatch, kein fertiges Spielprogramm und keine Disc-Dateien. Ein späteres Player-Update kann die lokale Erweiterung ersetzen; dann den Patch gegen die neue Version prüfen und neu bauen.

## English

For Rift Modern 0.12.0 on [RAC-RS v0.4.3](https://github.com/AsobiCodes/rac-rs/tree/v0.4.3), base commit `5b1415469460192f9236e9ad7b075e37223d764a`.

The patch adds native shoulder locomotion, menu colours and high-resolution mod pictures. It suppresses only drawing of the original quick-select wheel; input, opening timing and vendor priority remain native. The wrench throw uses the existing Comet Strike routine. Personal options and saves are not included in the patch.

From an unchanged RAC-RS 0.4.3 source folder:

```powershell
git apply --check PATH/TO/rift-modern-rac-rs-0.4.3.patch
git apply PATH/TO/rift-modern-rac-rs-0.4.3.patch
```

Rebuild the player using the existing local toolchain and generated build profiles, then launch that player. Also enable the complete script mod. This ZIP contains a source patch, not a complete game executable or disc data. A later player update may replace the local extension; check the patch against that version and rebuild as necessary.

## Lizenz / License

Native Code-Erweiterungen: GPL-3.0 gemäß RAC-RS. Scripts und Spielgrafiken besitzen ihre jeweils angegebenen eigenen Lizenzen bzw. Herkunftsangaben.

Native code extensions: GPL-3.0, following RAC-RS. Scripts and game graphics retain their separate stated licenses or provenance.
