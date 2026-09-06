# Sectorscanner – Architektur

**Status:** Aktiv

## 1. Ziel und Projektgrenze

Sectorscanner ist eine eigenständige X4-Extension für eine Cockpit-Sektorübersicht mit Filterung, Sortierung, Paging und Targeting.

Die Runtime bleibt vollständig innerhalb des eigenen Extension-Verzeichnisses. Basisspieldateien werden nicht direkt verändert oder ersetzt.

## 2. Technische Identität

- Repository: `X4Gooswin/sectorscanner`
- Entwicklungsbranch: `main`
- Extension-ID: `sectorscanner`
- Anzeigename: `Sectorscanner`
- `save="0"` laut `content.xml`
- Abhängigkeiten laut `content.xml`:
  - SirNukes Mod Support APIs — `ws_2042901274`
  - UI Extensions and HUD — `ws_3477279743`

Eine reale Steam-Workshop-ID für Sectorscanner ist im aktuellen Planungsstand noch nicht verbindlich eingetragen. Sie wird erst nach der tatsächlichen Veröffentlichung übernommen (`TODO-002`).

## 3. Runtime-Verantwortung

| Pfad | Verantwortung |
|---|---|
| `content.xml` | Extension-Metadaten und deklarierte Abhängigkeiten |
| `ui.xml` | UI-Registrierung/Anbindung der Extension |
| `md/sector_scanner_core.xml` | MD-Kernlogik von Sectorscanner |
| `md/sector_scanner_options.xml` | MD-seitige Optionen/Zustände von Sectorscanner |
| `ui/sector_scanner.lua` | Cockpit-HUD-/Listenlogik |
| `t/0001-L###.xml` | lokalisierte Texte in den vorhandenen zehn Sprachdateien |

Die bestehende Runtime wird durch die Organisationsarbeit ORGA-002 nicht verändert.

## 4. Entwicklungs- und Debug-Infrastruktur

| Pfad | Verantwortung |
|---|---|
| `documentation/` | Projektsteuerung, Architektur, Roadmap und Testdokumentation |
| `debug/` | aktuelle projektbezogene Debug-Testartefakte |
| `debug/archive/` | ältere projektbezogene Debug-Testartefakte innerhalb der Retention |
| `tools/Start-X4DebugWatcher.cmd` | Starthelfer für den lokalen deterministischen Debug-Watcher |
| `tools/Watch-X4Debug.ps1` | sichere Logübernahme, Retention und eng begrenzte Git-Synchronisierung von `debug/**` |
| `tools/prepare_debug_analysis.py` | deterministische, lokale Filterung von X4-Debuglogs auf Sectorscanner-Bezug |

Die Debug-Infrastruktur führt keine KI-/API-Analyse aus.

## 5. Debug-Datenfluss

1. X4 schreibt `debuglog.txt` unter dem lokalen Egosoft-X4-Dokumentbereich.
2. Der Watcher übernimmt das Log nach beendetem X4 zunächst in eine globale Zwischenablage außerhalb des Repositorys.
3. SHA256-Prüfungen sichern die unveränderte Übernahme.
4. Das vollständige Rohlog wird als `debug_###.txt` im Projekt abgelegt.
5. `prepare_debug_analysis.py` erzeugt deterministisch `debug_filter_###.txt`.
6. Die drei neuesten vollständigen Testsätze bleiben in `debug/`.
7. Die folgenden zehn Testsätze liegen in `debug/archive/`.
8. Ältere vollständige Testsätze werden entfernt.
9. Automatische Git-Aktionen sind ausschließlich auf `main` und ausschließlich für `debug/**` zulässig.

Die globale Zwischenablage liegt unter `Dokumente/Egosoft/X4/SectorOverviewDebug/` und gehört nicht zum Repository.

## 6. Extension-only-Grenze

- keine direkte Änderung von X4-Basisspieldateien,
- keine `subst_*.cat/.dat`-Ersetzung,
- bestehende X4-/UI-Schnittstellen und Extensionmechanismen verwenden,
- Runtime-Dateien bleiben im eigenen Extension-Verzeichnis,
- Entwicklungswerkzeuge unter `tools/` sind keine Runtime-Abhängigkeit.

## 7. Save- und Versionsgrenze

`content.xml` deklariert `save="0"`. Daraus wird keine weitergehende technische Aussage über einzelne UI-Zustände erfunden. Spielstands- oder Zustandsverhalten wird bei Änderungen nur dann als bestätigt behandelt, wenn es praktisch geprüft wurde.

Das aktive Projektziel ist `V1.0.0`. Der unveränderliche Branch `V1.0.0` wird erst nach Veröffentlichung, Übernahme der realen Workshop-ID und bestätigtem Zielstand angelegt.
