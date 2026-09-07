# Sectorscanner – Projektstatus

**Status:** Aktiv.  
**Zentrale Regelquelle:** `workflow/PROJECT_CONTROL.md`

## Aktueller Steuerungsstand

**Aktives Versionsziel:** `V1.0.0`.  
**Aktueller Fokus:** `TODO-002 – echte Workshop-ID im veröffentlichten X4-Stand bestätigen`.
**Nächster projektweiter Arbeitsschritt:** veröffentlichten Stand mit `ws_3797178164` in X4 laden und Identität sowie `sync="false"` bestätigen.

---

## Bekannter stabiler Runtime-Ausgangsstand

- Repository: `X4Gooswin/sectorscanner`
- Branch: `main`
- Runtime-Ausgangscommit vor der V3.1.0-Organisationsarbeit: `5c504e27450844834ac09e6b1e1ab082af6fa350`
- Vorheriger erhaltener Split-Basiscommit: `ee4a953b573797ae9cf30c62c54e2c011f3bfb2c`
- Extension-Name: `Sectorscanner`
- Extension-ID vor Veröffentlichung: `sectorscanner`
- Vergebene Workshop-ID: `ws_3797178164`
- Abhängigkeiten laut `content.xml`: SirNukes Mod Support APIs und UI Extensions and HUD.

Die zuvor getestete Kombination aus gesplittetem Veteran Ships und separatem Sectorscanner war erfolgreich. Dieser historische Nachweis wird nicht als neuer Testlauf unter `TEST-001` umetikettiert.

---

## Organisationsstand

**ORGA-001:** Workflow-Bootstrap und zentrale Projektsteuerung wurden ursprünglich für Workflow V2.0.0 eingerichtet.  
**ORGA-002:** Projektworkflow am 07.09.2026 kontrolliert auf V3.1.0 / Commit `698d56838ae71d29e5a09ec95911c82ec9c92337` aktualisiert; Bootstrap-Alleinzuständigkeit, Architektur/Roadmap/Navigationsstruktur und deterministische Debug-Infrastruktur eingerichtet. Bestehende Runtime-Dateien wurden dabei nicht verändert.  
**ORGA-003:** Lokales Arbeitsverzeichnis `C:\Program Files (x86)\Steam\steamapps\common\X4 Foundations\extensions\sectorscanner` am 07.09.2026 aus `X4Gooswin/sectorscanner` hergestellt. Lokaler Branch `main`, lokaler HEAD `7c4bbdcdbed888dc24c0249ea13e3fc8075f86f0` und sauberer Arbeitsbaum wurden verifiziert; keine Runtime-Datei wurde verändert.  
**Fast Path:** nicht projektspezifisch aktiviert; bis zu einer späteren ausdrücklichen Einrichtung gilt der vollständige Startpfad des gepinnten Workflows.

---

## Verbindliche Arbeitsreihenfolge bis V1.0.0

1. `ORGA-003` – abgeschlossen: lokales Arbeitsverzeichnis sauber eingerichtet.
2. `TEST-001` – abgeschlossen: eigenständiger praktischer Modtest bestanden.
3. `TODO-001` – abgeschlossen: Steam-Workshop-Eintrag `3797178164` angelegt.
4. `TODO-002` – aktueller Fokus: `ws_3797178164` im veröffentlichten X4-Stand bestätigen.
5. `ORGA-004` – anschließend den bestätigten Veröffentlichungsstand als unveränderlichen Branch `V1.0.0` ablegen.
Die Reihenfolge ist verbindlich. Ein nachfolgender Punkt beginnt erst, wenn sein Vorgänger abgeschlossen oder ausdrücklich neu entschieden wurde.
