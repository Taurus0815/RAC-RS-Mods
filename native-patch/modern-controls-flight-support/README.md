# Modern Controls flight support — RAC-RS 0.5.1

## Deutsch

Ergänzung für Modern Controls 0.3.1. Der Ordner `omni` gehört neben `rac-rs.exe`, üblicherweise nach `Ratchet & Clank/build/release/omni`. Die beiden Dateien erweitern die vorhandene Script-Schnittstelle um `rac1.player.apply_vertical_motion`. Kein Player-Neubau nötig. Diese Schnittstellendateien sind für RAC-RS 0.5.1 bestimmt.

Alternativ führt `Install.ps1 -GamePath "C:\Pfad\zu\Ratchet & Clank"` die Installation mit Sicherung durch. Wenn Arsenal Mastery bereits installiert ist, ergänzt das Installationsskript dort einen Schalter, der nur dessen Munitionsgrenzen-Veränderung ausschaltet. Modern Controls verwaltet danach die festen 3×-Originalgrenzen. Arsenal Mastery selbst ist nicht enthalten. Nach einer Aktualisierung von Arsenal Mastery muss diese Anpassung gegebenenfalls erneut ausgeführt werden.

Im Schwebemodus mit getragenem Düsenpack dreimal kurz R1 drücken. 3× R1 schaltet den Flugmodus auch wieder aus. Stick: waagerechter Flug; X halten: steigen; L1 halten: sinken; ohne Richtungseingabe: schweben. Landen, Levelwechsel und andere Spielzustände beenden den Flugmodus. Normale Kollision, Schaden und die Spielwelt bleiben aktiv.

Prüfung: genau eine passende Bewegungsfunktion pro Level auf allen 19 PAL-Overlays der lokalen Disc. Zusätzlich wurden die Script-Callbacks für Umschalten, Steigen, Sinken, Landen und Pausieren mit einer Lua-Testumgebung ausgeführt. Diese Prüfungen ersetzen keinen praktischen Flugtest in allen Leveln. Die NTSC-Fassung wurde nicht gegen eine US-Disc geprüft; ein nicht passender Funktionshash wird vom Loader übersprungen.

## English

Companion for Modern Controls 0.3.1. Copy `omni` next to `rac-rs.exe`, normally into `Ratchet & Clank/build/release/omni`. The files expose `rac1.player.apply_vertical_motion` through the existing scripting interface. No player rebuild is needed. These bindings target RAC-RS 0.5.1.

Alternatively, run `Install.ps1 -GamePath "C:\path\to\Ratchet & Clank"` to install with backups. If Arsenal Mastery is already installed, the installer adds a switch disabling only its ammo-capacity writer, leaving Modern Controls in charge of the fixed 3× original limits. Arsenal Mastery is not included. Reapply this adjustment after an Arsenal update if necessary.

While gliding with the worn Thruster-Pack, triple-tap R1 to toggle flight. Stick: horizontal flight; hold Jump: ascend; hold L1: descend; no direction: hover. Landing, level changes and other gameplay states cancel flight. Native collision, damage and world updates remain active.

Validation: exactly one matching helper in each of the 19 local PAL overlays; Lua callback checks for toggling, ascent, descent, landing and pause. These checks do not replace practical flight testing across the game. NTSC was not checked against a US disc; unmatched code hashes are skipped by the loader.

Interface files follow RAC-RS's GPL-3.0 license (included). No executable, disc data or game textures are included.
