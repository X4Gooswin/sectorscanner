# Sectorscanner – Dokumentationsnavigation

**Status:** Aktiv

Der verbindliche Einstieg in einen neuen Arbeitschat ist immer `../WORKFLOW_BOOTSTRAP.md`.

## Projektsteuerung

| Datei | Rolle |
|---|---|
| `PROJECT_RULES.md` | projektspezifisches Overlay und automatische Ausnahmen |
| `PROJECT_STATUS.md` | aktueller Fokus, Versionsziel und Arbeitsreihenfolge |
| `TODO.md` | ausschließlich offene Arbeit bis V1.0.0 |
| `TODO_DONE.md` | abgeschlossene Arbeits- und Organisationshistorie |
| `ID_REGISTER.md` | höchste offiziell vergebene stabile IDs |
| `ERROR_LOG.md` | dauerhaftes Fehlerprotokoll |

## Fach- und Planungsquellen

| Datei | Rolle |
|---|---|
| `ARCHITECTURE.md` | technische Projektgrenze, Runtime- und Debugstruktur |
| `ROADMAP.md` | verbindliche Reihenfolge bis V1.0.0 |
| `TEST_PLAN.md` | allgemeine Testbasis und `TEST-001` |

## Runtime-Referenzen

- `../content.xml`
- `../ui.xml`
- `../md/sector_scanner_core.xml`
- `../md/sector_scanner_options.xml`
- `../ui/sector_scanner.lua`
- `../t/0001-L###.xml`

## Debug-Infrastruktur

- `../debug/`
- `../tools/Start-X4DebugWatcher.cmd`
- `../tools/Watch-X4Debug.ps1`
- `../tools/prepare_debug_analysis.py`

Der optionale Fast Path aus Workflow V3.1.0 ist derzeit nicht projektspezifisch aktiviert. Bis zu einer späteren ausdrücklichen Einrichtung gilt der vollständige Startpfad des gepinnten Workflows.
