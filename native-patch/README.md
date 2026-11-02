# Rift Modern — native Erweiterung / native extension

**Mod-Erweiterung / Mod extension: Taurus0815**

## Deutsch

**0.12.2:** Kamerarichtung für Schüsse gilt auch im eingerasteten Schultermodus. Physisches Zielen wird separat veröffentlicht, damit der Doppeltipp und Zielen + Viereck weiterhin korrekt unterscheiden. Kameraabstand und Schulterversatz sind unabhängig; nur eine länger als das Tap-Fenster gehaltene Zielaktion aktiviert den Zoom. Scripts und Player gemeinsam aktualisieren.

**Korrektur 0.12.1:** Entfernt die falsch als Auswahlrad-Zeichnung erkannten Spielroutinen, darunter `HeroUpdateState` auf Kerwan. Nur die exakt zugeordneten Zeichen-Templates werden registriert. Die Scripts prüfen Schutz-Version 2, bevor sie ihn aktivieren. Für nicht zugeordnete Layouts bleibt der Fade-Ersatzweg aktiv.

Für Rift Modern 0.12.2 auf [RAC-RS v0.4.3](https://github.com/AsobiCodes/rac-rs/tree/v0.4.3), Basis-Commit `5b1415469460192f9236e9ad7b075e37223d764a`.

Der Patch ergänzt die native Schulterbewegung, Menüfarben und hochauflösende Mod-Bilder. Das alte Auswahlrad wird ausschließlich beim Zeichnen unterdrückt; dessen Eingaben, Öffnungszeit und Händler-Priorität bleiben erhalten. Der Wurf selbst verwendet die vorhandene Comet-Strike-Routine. Persönliche Optionen und Spielstände sind kein Teil des Patches.

Im unveränderten RAC-RS-0.4.3-Quellordner:

```powershell
git apply --check PFAD/ZU/rift-modern-rac-rs-0.4.3.patch
git apply PFAD/ZU/rift-modern-rac-rs-0.4.3.patch
```

Danach den Player mit der vorhandenen lokalen Toolchain und den generierten Build-Profilen neu bauen und diesen Player starten. Zusätzlich den vollständigen Script-Mod aktivieren. Die ZIP enthält einen Quellpatch, kein fertiges Spielprogramm und keine Disc-Dateien. Ein späteres Player-Update kann die lokale Erweiterung ersetzen; dann den Patch gegen die neue Version prüfen und neu bauen.

## English

**0.12.2:** Camera-directed firing also applies to latched shoulder walking. Physical aim is exposed separately so double-tapping and aim + melee keep their intended behavior. Camera distance is independent of shoulder framing; only a sustained physical aim hold beyond the tap window starts zoom. Update both scripts and player.

**Fix in 0.12.1:** Removes gameplay routines incorrectly identified as wheel drawing, including Kerwan `HeroUpdateState`. Only exact draw templates are registered. Scripts require guard revision 2 before enabling it; unmatched layouts use the fade fallback.

For Rift Modern 0.12.2 on [RAC-RS v0.4.3](https://github.com/AsobiCodes/rac-rs/tree/v0.4.3), base commit `5b1415469460192f9236e9ad7b075e37223d764a`.

The patch adds native shoulder locomotion, menu colours and high-resolution mod pictures. It suppresses only drawing of the original quick-select wheel; input, opening timing and vendor priority remain native. The wrench throw uses the existing Comet Strike routine. Personal options and saves are not included in the patch.

From an unchanged RAC-RS 0.4.3 source folder:

```powershell
git apply --check PATH/TO/rift-modern-rac-rs-0.4.3.patch
git apply PATH/TO/rift-modern-rac-rs-0.4.3.patch
```

Rebuild the player using the existing local toolchain and generated build profiles, then launch that player. Also enable the complete script mod. This ZIP contains a source patch, not a complete game executable or disc data. A later player update may replace the local extension; check the patch against that version and rebuild as necessary.

Optional vor dem Build / Optional before building:

```powershell
python verify-wheel-guards.py PFAD_ZUR_RAC_RS_INSTALLATION
```

Prüft die Zuordnung gegen die lokal generierten Zeichen-Templates. / Checks the assignments against locally generated drawing templates.

## Lizenz / License

Native Code-Erweiterungen: GPL-3.0 gemäß RAC-RS. Scripts und Spielgrafiken besitzen ihre jeweils angegebenen eigenen Lizenzen bzw. Herkunftsangaben.

Native code extensions: GPL-3.0, following RAC-RS. Scripts and game graphics retain their separate stated licenses or provenance.
