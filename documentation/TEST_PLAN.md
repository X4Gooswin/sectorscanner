# Sectorscanner – Testplan

**Status:** Aktiv.  
**Zentrale Regelquelle:** `workflow/TEST_STANDARD.md`

## 1. Projektbezogene Testbasis

**Projekt:** Sectorscanner  
**Deklarierter Entwicklungsbranch:** `main`  
**Aktives Versionsziel:** `V1.0.0`  
**Relevante X4-Version:** technisch unbestätigt

### Fundament-/Basistests

- [ ] Extension wird im aktuellen Zielstand technisch erkannt.
- [ ] `content.xml`, MD-Dateien, `ui.xml` und Lua sind für den getesteten Stand strukturell/technisch gültig.
- [ ] X4 startet mit aktivierter Extension und den erforderlichen Abhängigkeiten.
- [ ] Keine projektverursachten relevanten MD-/Lua-/UI-Fehler im Debuglog.
- [ ] Filter, Sortierung, Paging und Targeting der Cockpit-Sektorübersicht funktionieren im vorgesehenen Teststand.
- [ ] Extension-only-/Workshop-only-Konformität ist für den getesteten Stand bestätigt.

Historischer Hinweis: Die Kombination aus gesplittetem Veteran Ships und separat installiertem Sectorscanner wurde vor Einrichtung dieses Testregisters erfolgreich getestet. Dieser Alt-Nachweis erhält rückwirkend keine neue TEST-ID und ersetzt `TEST-001` nicht.

---

## 2. TEST-001 – Eigenständiger Sectorscanner-Modtest

**Status:** Test erforderlich  
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

### Testlauf-Vorlage

**Getesteter Commit:** `<SHA>`  
**Datum/Projektreferenz:** `<Datum/Referenz>`  
**X4-Version:** `<Version oder technisch unbestätigt>`  
**Modkombination/Abhängigkeiten:** `<Stand>`

#### Ausgeführte Schritte

1. `<Schritt>`
2. `<Schritt>`
3. `<Schritt>`

#### Beobachtetes Ergebnis

`<Ergebnis>`

#### Teststatus

`<bestanden / nicht bestanden / teilweise bestanden>`

#### Offene Fehler

- `<FEHLER-ID oder keine>`

#### Offene Folgearbeit

- `<ID oder keine>`

#### Extension-only-/Workshop-only-Konformität

`<bestätigt / nicht bestätigt>`

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
