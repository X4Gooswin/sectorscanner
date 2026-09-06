# Sectorscanner – TODO

**Status:** Aktiv.  
**Zentrale Regelquelle:** `workflow/PROJECT_CONTROL.md`

Diese Datei enthält ausschließlich die noch offene Arbeit bis zum aktiven Versionsziel `V1.0.0`.

## TEST-001 – Sectorscanner als eigenständige Mod praktisch testen

**Status:** Test erforderlich  
**Priorität:** hoch  
**Abhängigkeit:** ORGA-003 abgeschlossen.

- Eigenständige Extension in X4 laden.
- Erkennung, Abhängigkeiten, UI/MD/Lua und Debuglog prüfen.
- Filter, Sortierung, Paging und Targeting praktisch prüfen.
- Extension-only-/Workshop-only-Konformität bestätigen.
- Ergebnis dauerhaft in `documentation/TEST_PLAN.md` nachführen.

## TODO-001 – Sectorscanner veröffentlichen

**Status:** offen  
**Priorität:** hoch  
**Abhängigkeit:** TEST-001 bestanden.

- Erst nach bestandenem eigenständigem Modtest veröffentlichen.
- Veröffentlichungsdaten und resultierenden stabilen Stand dokumentieren.

## TODO-002 – Echte Workshop-ID übernehmen

**Status:** offen  
**Priorität:** hoch  
**Abhängigkeit:** TODO-001 abgeschlossen.

- Nach Veröffentlichung die tatsächlich vergebene Steam-Workshop-ID als `ws_ZAHL` übernehmen.
- Die zu ändernde Projektdatei wird anhand des tatsächlichen Veröffentlichungs-/X4-Stands bestimmt; sie wird nicht vorab angenommen.
- Danach den resultierenden Stand erneut prüfen.

## ORGA-004 – V1.0.0 als unveränderlichen Branch sichern

**Status:** offen  
**Priorität:** hoch  
**Abhängigkeit:** TODO-002 abgeschlossen und veröffentlichter Stand bestätigt.

- Den bestätigten Stand als Branch `V1.0.0` sichern.
- Der Branch ist als unveränderlicher Versionssnapshot vorgesehen.
- Die tatsächliche Branch-Erstellung unterliegt dem dann gültigen Freigabeprozess.
