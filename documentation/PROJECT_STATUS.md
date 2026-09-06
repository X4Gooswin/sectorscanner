# Sectorscanner – Projektstatus

**Status:** Aktiv.  
**Zentrale Regelquelle:** `workflow/PROJECT_CONTROL.md`

## Aktueller Steuerungsstand

**Aktives Versionsziel:** `V1.0.0`.  
**Aktueller Fokus:** `TEST-001 – Sectorscanner als eigenständige Mod praktisch testen`.  
**Nächster projektweiter Arbeitsschritt:** Eigenständige Extension in X4 laden und den vorgesehenen praktischen Modtest durchführen; Veröffentlichung erst nach bestandenem `TEST-001`.

---

## Bekannter stabiler Runtime-Ausgangsstand

- Repository: `X4Gooswin/sectorscanner`
- Branch: `main`
- Runtime-Ausgangscommit vor der V3.1.0-Organisationsarbeit: `5c504e27450844834ac09e6b1e1ab082af6fa350`
- Vorheriger erhaltener Split-Basiscommit: `ee4a953b573797ae9cf30c62c54e2c011f3bfb2c`
- Extension-Name: `Sectorscanner`
- Extension-ID: `sectorscanner`
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
2. `TEST-001` – aktueller Fokus: Sectorscanner als eigenständige Mod praktisch testen.
3. `TODO-001` – Sectorscanner veröffentlichen.
4. `TODO-002` – nach Veröffentlichung die reale `ws_ZAHL` in der dann tatsächlich zuständigen Projektdatei eintragen; die zuständige Datei wird nicht vorab geraten.
5. `ORGA-004` – den bestätigten Veröffentlichungsstand als unveränderlichen Branch `V1.0.0` ablegen.

Die Reihenfolge ist verbindlich. Ein nachfolgender Punkt beginnt erst, wenn sein Vorgänger abgeschlossen oder ausdrücklich neu entschieden wurde.
