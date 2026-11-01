# Rift Modern 0.11.0

Angepasst an RAC-RS 0.4.2/0.4.3, OmniLoader 0.1.0 (Host-ABI 1.6, Script-API 1.3), PAL SCES-50916. Autor: Taurus0815.

- Cyan-/Violett-HUD fuer originale Nanotech-Punkte, Bolts und Munition. Funktioniert eigenstaendig; externe Nanotech-HUDs koennen optional die Gesundheitsanzeige uebernehmen.
- Schnellere Beschleunigung und Bremsen auf dem Boden (Standard 1,6). Keine Positionsspruenge, keine Aenderung von Kollisionen, Sprungtiming und Hoechstgeschwindigkeit.
- Normale Schraubschluessel-Schlaege und Schlag von oben (Sprung + Nahkampf) mit Animationsfaktor 1,6. Native Sprung-/Fallphysik und Schaden pro Treffer bleiben erhalten. Die beiden Tempos lassen sich getrennt einstellen.
- Kompaktes modernes Auswahlrad an Originalposition links (Mitte 128/208, Radius 92 im 512x448-HUD-Raum), ohne grosses Mittelfeld. Die acht Richtungen und die belegten Spiel-Slots bleiben erhalten. Schnellauswahl mit echter Pause: Dreieck/Y halten, mit linkem Stick oder Steuerkreuz auswaehlen, loslassen zum Ausruesten und Fortsetzen. Kreis/B bricht ab. Welt, Gegner und Projektile werden durch die native Spielpause angehalten. Die belegten Slots stammen aus der Schnellauswahl des Spiels. In besonderen Bewegungs-/Fahrzeugzustaenden bleibt die Originalfunktion zustaendig. Pause during Quick Select = Off stellt das Originalrad wieder her.
- Modernes Pausemenue mit der Auswahl und Navigation des Spiels. Die Unterseiten behalten ihre Spielinhalte und bekommen einen passenden Rahmen. U zeigt beim Pausieren die Originalansicht.
- Controller: L2/LT zielt, R2/RT benutzt die Waffe, Quadrat/X ist Nahkampf, Kreuz/A springt, Dreieck/Y oeffnet die Schnellauswahl. Kreis/B geht in Menues zurueck. R1/RB behaelt die originalen Duck-/Sprungaktionen. Phantom Dash, Hoverboots und Rift-Tether sind keine Funktionen von Ratchet 1.
- Startlogos werden mit der vorhandenen Option `intro=skip` uebersprungen. Options/Start kann weiterhin Zwischensequenzen ueberspringen (`skipcut=on`).

Die installierte native Controller-Zuordnung lautet `pad=circle:rt,l2:b,r2:lt`. Das ist eine einmalige Einstellung in player/pc_options.txt und im aktiven Launcher-Profil. Die Mod schreibt sie nicht bei jedem Start zurueck. Sie bleibt unter Pause > Optionen > Steuerung aenderbar. Nach einer Aenderung von "L2" weg von Kreis/B bitte die Mod-Option "Rift controller menu Back" deaktivieren.

J schaltet die Bewegungsreaktion um, K das HUD. Beide Tasten sowie U fuer die Original-Menueansicht sind in den Mod-Optionen frei belegbar. Health source steht standardmaessig auf Original game health. Der externe Modus ist nur fuer eine separat vorhandene, kompatible Nanotech-HUD-Integration gedacht; eine solche Drittanbieter-Mod wird nicht mitgeliefert.

Die Umsehgeschwindigkeit steht auf 80 fuer Controller und Maus (vorher Standard 50). HUD/Menues stehen ausdruecklich auf Sharp. Vollbild uebernimmt die Desktop-Aufloesung des aktuellen Monitors. HUD position=Corners verteilt die Anzeigen ueber dessen volle Breite. RAC-RS schaltet die hohe Menueaufloesung ab etwa 900 Pixel Bildhoehe ein. Alle diese Werte bleiben ueber Launcher und Spieloptionen aenderbar.

Strafe-Aiming-Stil und Controller-Zuordnung stammen weiterhin aus den Launcher-/Spieloptionen. Kein Dreh-, Kamera-, Kollisions- oder Tastatur-Uebernahme-Hook wird installiert. Die Schulteransicht beim normalen Laufen wird seit 0.9.0 separat angefordert und benutzt die native Kamera samt Wandpruefung. Der Mod-Status muss fuer beide Mods `loaded` und `replaces: []` zeigen.


Vor jedem Installationsstand wurde unter mod_backups gesichert. Die Tests laufen mit getrennten Spielstands- und Mod-Kopien. Beim Zuruecksetzen von Darstellung/Einstellungen keine Spielstaende zurueckkopieren.

## Ergaenzungen 0.11.0

Die lokale Kameraerweiterung wurde nach dem Spielupdate auf die aktuellen 0.4.3-Quellen uebertragen. Der normale Spielstart bleibt auf 0.4.3; die alte Star-Wars-Spielversion wird dadurch nicht ersetzt. Launcher-Optionen und Controller-Zuordnung bleiben erhalten.

- Ein neuer Dreieck-Druck erreicht immer zuerst das Originalspiel. Haendler, Schiff und andere Interaktionen behalten Vorrang. Das pausierte Auswahlrad uebernimmt erst, wenn das originale Rad seinen vollstaendigen Oeffnungswert 8 erreicht hat (PAL: acht Schritte, etwa 0,16 s). Kurze Druecke werden nicht in eine Pause umgewandelt. Der native Ausblendwert wird bei der Uebernahme beendet, damit beim Fortsetzen kein alter Waffenwunsch nachkommt.
- Zweimal kurz Zielen antippen schaltet die Schulteransicht beim normalen Laufen ein; erneut zweimal schaltet sie aus. Pro Tipp maximal 0,25 s, maximal 0,35 s Pause zwischen den Tipps. Ein normales laengeres Zielen schaltet den Laufmodus nicht um. Der Mod-Schalter heisst jetzt `Double-tap aim for shoulder camera`; bei Spielstart ist der Laufmodus aus. Maus und Controller verwenden denselben nativen Zielzustand; keine Eingaben oder Launcher-Zuordnungen werden umgeschrieben.

## Ergaenzungen 0.9.0

- Der Schlag von oben behaelt beim Fallen seine Schlagpose, statt die Animation bei hohem Tempo schon in der Luft zu beenden. Ausholen und Ausklang laufen mit dem eingestellten Faktor; die Animation wartet waehrend des Fallens auf den Bodenkontakt. Gravitation und Kollision laufen im Original weiter.
- Seit 0.9.0 verwendet die Schulteransicht die vorhandene native Seiten-/Wand-/Deckenpruefung und veraendert weder die Zieltaste noch Schussrichtung, Koerperdrehung oder Controller-Belegung. Beim tatsaechlichen Zielen gilt weiterhin der gewaehlte Launcher-Stil. Seit 0.11.0 wird die Laufansicht per doppeltem Antippen der Zieltaste geschaltet.
- Die Kamera benoetigt die zugehoerige lokale Spielversion. Native Erweiterung: das benannte Byte `omni.rift.shoulder_walk` in der unbenutzten alten PC-Kameratabelle (0xB0040). Frischer RAM bedeutet Orbit, die aktive Mod fordert die Schulteransicht an. Ohne das neue Feld wird nur die Kameraerweiterung ausgelassen und ein Hinweis protokolliert.

## Ergaenzungen 0.8.0

- Die Zusatzwelle wartet jetzt auf den tatsaechlichen Bodenaufprall. Ein kurzer nativer Bodentest bestaetigt den Kontakt der Fuesse mit einer begehbaren Flaeche. Das fruehe Erstellen einer Trefferbeschreibung beim Ausholen und das Ende der Animation in der Luft loesen keine Welle aus; bei hohem Tempo wird noch das anschliessende Fallen abgewartet. Ein normaler Sprung erzeugt keine Zusatzwelle; Schaden-/Schwimm-/andere Unterbrechungszustaende verwerfen sie.
- Kistenradius bleibt 6 Spieleinheiten. Gegner in unmittelbarer Naehe (Standard 2,5) erhalten beim selben Aufprall einen nativen Schraubschluessel-Treffer; separat vorhandene Schaden-/XP-Mods koennen den nativen Treffer weiterverarbeiten. `slam_enemy_radius=0` deaktiviert diesen Zusatzschaden. Pro Schlag erfolgt nur eine Zusatzwelle.
- Einstellbereiche: Beschleunigen/Bremsen jetzt 1,0 bis 8,8; normale Schlaege und Schlag von oben jeweils 1,0 bis 4,0. Manifest und Laufzeitbegrenzungen stimmen ueberein. Gewaehlte Werte werden dadurch nicht automatisch erhoeht; das installierte Profil behaelt Bewegungsreaktion 4,4 und die beiden zuletzt gewaehlten Schlagtempos.

## Ergaenzung 0.7.1

Das installierte Profil nutzt `movement_response=4.4` statt zuvor 2.2: doppelte Beschleunigungs- und Bremsrate beim normalen Laufen, ungefaehr halbierte Reaktionszeit. In 0.7.1 wurde die Obergrenze auf 4.4 angehoben (0.8.0: 8.8). Hoechstgeschwindigkeit, Sprung-/Fallphysik, Kollision und Launcher-Steuerung bleiben unveraendert. Die allgemeinen Presets behalten ihre bisherigen Werte.

## Ergaenzungen 0.7.0

- `wrench_speed=1.6`: normale Schlaege; `slam_speed=1.6`: Schlag von oben. Beide 1,0 bis 2,0.
- `slam_crate_radius=6`: einmal pro Schlag von oben eine zusaetzliche Kistenwelle mit 6 m Radius, ueber den originalen Trefferpfad. Gegner bekommen keinen zusaetzlichen Flaechenschaden. 0 deaktiviert die Zusatzwelle. Im Test wurde die Kiste bei 4,5 m zerstoert, die bei 8 m blieb intakt.
- `bolt_radius=2`: verdoppelt die originalen Anziehungswerte nach dem abschliessenden HeroItemsAttach. Bei normalem Ratchet sind es 6 statt 3 m und 3,5 statt 1,75 m Hoehenabstand. Native Anziehung, Wert der Bolts und Sammelgeraeusch bleiben erhalten.
- Schnellauswahl: feinere Ringkanten (1 statt 2 HUD-Zeilen), farbige HUD-Waffenbilder statt der violetten Inventar-Silhouetten, weniger vergroesserte Symbole. Die beste Darstellung braucht HUD=Sharp und mindestens 896 Pixel Fensterhoehe. Die urspruenglichen Spielgrafiken haben weiterhin eine begrenzte Aufloesung.
- HUD position=Corners verteilt Waffen-/XP-Anzeige und Bolts ueber die gesamte Bildschirmbreite; Nanotech bleibt oben mittig. Vollbild ist randlos auf dem aktuellen Monitor und uebernimmt dessen Desktop-Aufloesung (hier 3440 x 1440). Diese ausdruecklich gewuenschten Optionen wurden in player/pc_options.txt und profiles/default/pc_options.txt gesetzt; Strafe Aiming und Controller-Zuordnung bleiben erhalten.


Version 0.11.0: Die per zweifachem kurzen Tippen auf Zielen ein-/ausschaltbare Schulteransicht nutzt nun auch die native Strafe-Bewegung: Ratchet schaut zur Kamera-Blickrichtung und laeuft seitlich/rueckwaerts wie beim Zielen. Kein dauerhaftes kuenstliches Zielen; Waffen und Zielhilfe folgen weiterhin dem echten Zielknopf. Ohne Schultermodus gilt das normale Laufen. Die Launcher-Option Strafe aiming bleibt massgeblich.

Das Menue-Design umfasst jetzt auch Start/Laden, Optionen, alle Pause-Unterseiten, Haendler und Bestaetigungen. Die gemeinsamen nativen Menue-Rahmen und Schriftfarben erhalten dunkle Flaechen, Cyan-Markierungen und violette Akzente. Texte, Symbole, 3D-Vorschauen, Auswahl, Tastenzuordnung und Speicherfunktionen laufen weiter nativ. U (oder die frei belegte Menue-Taste) stellt die Originalansicht wieder her. Die installierte Rift-EXE ist fuer den gemeinsamen nativen Menue-Skin und die Schulterbewegung erforderlich.
