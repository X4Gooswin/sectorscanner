# Sector Overview – Testplan

**Status:** Aktiv.  
**Zentrale Regelquelle:** `workflow/TEST_STANDARD.md`

## 1. Projektbezogene Testbasis

**Projekt:** Sector Overview  
**Deklarierter Entwicklungsbranch:** `main`  
**Aktives Versionsziel:** keines  
**Relevante X4-Version:** technisch unbestätigt

### Fundament-/Basistests

- [ ] Extension wird im aktuellen Zielstand technisch erkannt.
- [ ] `content.xml`, MD-Dateien, `ui.xml` und Lua sind für den getesteten Stand strukturell/technisch gültig.
- [ ] X4 startet mit aktivierter Extension und den erforderlichen Abhängigkeiten.
- [ ] Keine projektverursachten relevanten MD-/Lua-/UI-Fehler im Debuglog.
- [ ] Filter, Sortierung, Paging und Targeting der Cockpit-Sektorübersicht funktionieren im vorgesehenen Teststand.
- [ ] Extension-only-/Workshop-only-Konformität ist für den getesteten Stand bestätigt.

Historischer Hinweis: Die Kombination aus gesplittetem Veteran Ships und separat installierter Sector Overview wurde vor Einrichtung dieses Testregisters erfolgreich getestet. Dieser Alt-Nachweis erhält rückwirkend keine neue TEST-ID.

---

## 2. Verzeichnis der Featuretests

Aktuell ist keine TEST-ID vergeben.

---

## 3. Verzeichnis der Versionstests

Aktuell ist kein neuer Versionstest unter dem zentralen Testregister offen.

---

## 4. Mindeststandard je neuem Modul oder relevanter Änderung

Vor Implementierung bzw. Abschluss werden mindestens geprüft:

| Prüfbereich | Projektspezifischer Test / Referenz |
|---|---|
| Sollverhalten und Grenzfälle | konkrete Testakte des Arbeitspunkts |
| Persistenz über Speichern/Laden | wegen `save="0"` nur soweit die Änderung dennoch spielstandsrelevantes Verhalten berührt |
| relevante Ziel-/Sektor-/UI-Wechsel | konkrete Testakte |
| Performance | UI-Aktualisierung, Listenaufbau und relevante MD-Abfragen |
| optionale Integrationen | SirNukes Mod Support APIs; UI Extensions and HUD |
| Vanilla-/Mod-/DLC-Kompatibilität | konkrete Testakte |
| Extension-only-/Workshop-only-Nachweis | konkrete Testakte |

---

## 5. Testlauf-Vorlage

### TEST-### – <Testgegenstand> – Lauf <Nr.>

**Getesteter Commit:** <SHA>  
**Versionsziel:** <Ziel oder keines>  
**Datum/Projektreferenz:** <Datum/Referenz>  
**X4-Version:** <Version>  
**Modkombination:** <relevante Kombination>

#### Testbedingungen / Schritte

1. <Schritt>
2. <Schritt>
3. <Schritt>

#### Erwartetes Ergebnis

<erwartetes Verhalten>

#### Beobachtetes Ergebnis

<tatsächlich beobachtetes Verhalten>

#### Ergebnis

<bestanden / nicht bestanden / teilweise bestanden>

#### Offene Fehler

- <FEHLER-ID oder keine>

#### Offene TODOs / Folgeprüfungen

- <ID oder keine>

#### Extension-only-/Workshop-only-Konformität

<bestätigt / nicht bestätigt / Test nicht bestanden>

---

## 6. Offene projektweite Testpflichten

Aktuell keine. Neue Testpflichten werden mit stabiler TEST-ID eröffnet.
