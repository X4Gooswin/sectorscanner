# Sectorscanner – Testplan

**Status:** Aktiv.  
**Zentrale Regelquelle:** `workflow/TEST_STANDARD.md`

## 1. Projektbezogene Testbasis

**Projekt:** Sectorscanner  
**Deklarierter Entwicklungsbranch:** `main`  
**Aktives Versionsziel:** `V1.0.0`  
**Relevante X4-Version:** 9.00 (611726)

### Fundament-/Basistests

- [x] Extension wird im aktuellen Zielstand technisch erkannt.
- [x] `content.xml`, MD-Dateien, `ui.xml` und Lua sind für den getesteten Stand strukturell/technisch gültig.
- [x] X4 startet mit aktivierter Extension und den erforderlichen Abhängigkeiten.
- [x] Keine projektverursachten relevanten MD-/Lua-/UI-Fehler im Debuglog.
- [x] Filter, Sortierung, Paging und Targeting der Cockpit-Sektorübersicht funktionieren im vorgesehenen Teststand.
- [x] Extension-only-/Workshop-only-Konformität ist für den getesteten Stand bestätigt.

Historischer Hinweis: Die Kombination aus gesplittetem Veteran Ships und separat installiertem Sectorscanner wurde vor Einrichtung dieses Testregisters erfolgreich getestet. Dieser Alt-Nachweis erhält rückwirkend keine neue TEST-ID und ersetzt `TEST-001` nicht.

---

## 2. TEST-001 – Eigenständiger Sectorscanner-Modtest

**Status:** bestanden
**Abhängigkeit:** `ORGA-003` abgeschlossen.  
**Testgegenstand:** Der eigenständige Sectorscanner-Stand auf `main` als Vorbereitung auf Veröffentlichung und V1.0.0.

### Verbindliche Testbereiche

1. **Laden und Abhängigkeiten**
   - Extension wird genau einmal erkannt.
   - SirNukes Mod Support APIs und UI Extensions and HUD sind aktiv.
   - Kein relevanter Ladefehler aus `content.xml`, `ui.xml`, MD oder Lua.

2. **Cockpit-Sektorübersicht**
   - Liste sichtbarer relevanter Schiffe erscheint im vorgesehenen HUD-Kontext.
   - Filter funktionieren.
   - Sortierung nach vorgesehenen Kriterien funktioniert.
   - Paging/Navigation funktioniert.
   - Klick/Targeting funktioniert.

3. **Zustandswechsel**
   - Zielwechsel und Sektorwechsel erzeugen keine relevante UI-/Lua-Regression.
   - Öffnen/Schließen bzw. Aktivieren/Deaktivieren der Anzeige bleibt stabil.

4. **Debuglog**
   - Debuglog auf Sectorscanner-bezogene XML-/MD-/Lua-/UI-Fehler prüfen.
   - Der deterministische Projekt-Watcher darf zur Übernahme/Filterung genutzt werden; er ersetzt nicht die praktische Bewertung.

5. **Extension-only / Workshop-only**
   - Keine Basisspieldatei wird verändert.
   - Runtime funktioniert aus der eigenen Extension heraus.
   - Keine unzulässige Vanilla-Ersetzung.

### Testlauf – TEST-001

**Getesteter Funktionscommit:** `51b2e557acc04957d112f123ea851816ef099525`
**Datum:** 07.09.2026
**X4-Version:** `9.00 (611726)`
**Abhängigkeiten:** SirNukes Mod Support APIs und UI Extensions and HUD aktiv

#### Ausgeführte Prüfung

1. Eigenständige Extension geladen und technische Erkennung geprüft.
2. Filter, Sortierung, Paging und Navigation praktisch geprüft.
3. Klick/Targeting praktisch geprüft.
4. Aktivieren/Deaktivieren sowie Ziel- und Sektorwechsel geprüft.
5. Debuglog auf Sectorscanner-bezogene XML-/MD-/Lua-/UI-Fehler geprüft.
6. Extension-only-/Workshop-only-Konformität geprüft.

#### Ergebnis

Alle vorgesehenen Funktionen arbeiteten wie vorgesehen. Im geprüften Debuglog wurden keine bestätigten Sectorscanner-bezogenen XML-/MD-/Lua-/UI-Fehler festgestellt.

Der spätere Commit `b34ddecfa93a55d7c3fefafe832fcaf25c7f65e5` änderte ausschließlich die Extension-Identität und keine MD-/Lua-/UI-Funktionslogik.

**Teststatus:** `bestanden`

**Offene Fehler:** keine

**Folgearbeit:** `TODO-001` Veröffentlichung; anschließend `TODO-002` Workshop-ID-Prüfung.

**Extension-only-/Workshop-only-Konformität:** bestätigt

---

## 3. Mindeststandard je neuer relevanter Änderung

| Prüfbereich | Projektspezifischer Test / Referenz |
|---|---|
| Sollverhalten und Grenzfälle | konkrete Testakte des Arbeitspunkts |
| Persistenz über Speichern/Laden | wegen `save="0"` nur soweit die Änderung dennoch spielstandsrelevantes Verhalten berührt |
| relevante Ziel-/Sektor-/UI-Wechsel | konkrete Testakte |
| Performance | UI-Aktualisierung, Listenaufbau und relevante MD-Abfragen |
| optionale Integrationen | SirNukes Mod Support APIs; UI Extensions and HUD |
| Vanilla-/Mod-/DLC-Kompatibilität | konkrete Testakte |
| Extension-only-/Workshop-only-Nachweis | konkrete Testakte |

Ein technischer Commit ist keine praktische X4-Bestätigung. `TEST-001` bleibt offen, bis der eigenständige Modtest tatsächlich durchgeführt und dokumentiert wurde.
