# Sector Overview – Project Rules / Workflow Overlay

**Status:** Aktiv.  
**Bootstrap:** `WORKFLOW_BOOTSTRAP.md`

Diese Datei enthält nur projektspezifische Ergänzungen und die ausdrücklich freigegebene automatische Ausnahme zum gepinnten zentralen Workflow.

## 1. Projektspezifische Ergänzungen

| Zentrale Referenz | Projektspezifische Ergänzung | Begründung |
|---|---|---|
| `workflow/GIT_WORKFLOW.md` / `workflow/PROJECT_CONTROL.md` | Ein zusammengehöriger Arbeitsblock bzw. TODO-Arbeitsrest wird zunächst vollständig bearbeitet und geprüft. Danach erfolgt im Regelfall genau eine gemeinsame Git-Sicherung mit Commit/Push für diesen stabilen Arbeitsstand. Keine Zwischencommits nur wegen einzelner kleiner Dateiänderungen. | Git dient als nachvollziehbares Sicherungsnetz und nicht als Mikroschritt-Protokoll. |
| `workflow/GIT_WORKFLOW.md` | Zusätzliche Checkpoint-Commits sind nur sinnvoll, wenn ein eigenständig stabiler Zwischenstand, ein bewusster Teststand, ein Arbeitsblockwechsel oder eine technisch riskante Folgestufe dies rechtfertigt. | Verhindert unnötige Commit-Flut ohne die Nachvollziehbarkeit zu schwächen. |

## 2. Ausdrückliche Abweichungen

Keine.

## 3. Projektbezogene automatische Ausnahme

| Feld | Inhalt |
|---|---|
| Name der Automatik | Fehler-Rollback innerhalb einer freigegebenen Änderungseinheit |
| Zweck | Einen technisch fehlgeschlagenen oder nur teilweise ausgeführten Schreibvorgang ohne zusätzliche Freigaberunde exakt auf den vor der Ausführung dokumentierten Ausgangszustand zurückführen. |
| Auslöser/Bedingung | Nur wenn während der Ausführung einer bereits gültig freigegebenen Änderungseinheit ein technischer Fehler oder ein eindeutig nur teilweise ausgeführter Zustand festgestellt wird. |
| Erlaubte Dateien/Daten | Ausschließlich Dateien, Git-Refs oder andere Zustände, die durch genau diese freigegebene Änderungseinheit verändert wurden. |
| Erlaubte Zustandsänderungen | Nur das Rückgängigmachen der fehlgeschlagenen/teilweisen Änderung bis zum zuvor eindeutig dokumentierten Ausgangszustand. |
| Erlaubte Git-Aktionen | Leseprüfung sowie die für die exakte Wiederherstellung notwendigen Git-Aktionen. Ein Ref-Rollback ist nur zulässig, wenn Ausgangs-SHA und aktueller betroffener Zustand eindeutig feststehen und keine unabhängigen fremden Änderungen überschrieben werden können. |
| Abweichendes Commitformat | keines |
| Nicht erlaubt | Neue Fachänderungen, Scope-Erweiterungen, Änderungen an unbeteiligten Branches/Repositories, Änderungen lokaler X4-Dateien, geratenes Zurücksetzen auf einen unsicheren Zustand oder Überschreiben zwischenzeitlich unabhängiger Änderungen. |

Wenn der exakte Ausgangszustand oder die sichere Begrenzung nicht eindeutig feststeht, greift die Automatik nicht. Dann wird gestoppt und eine neue Entscheidung/Freigabe eingeholt.

## 4. Projektspezifische Parameter

| Parameter | Wert | Maßgebliche Projektquelle |
|---|---|---|
| Projektpriorität | Sector Overview ist derzeit gegenüber Veteran Ships sekundär. | `documentation/PROJECT_STATUS.md` |
| Extension-ID | `gooswin_sector_overview` | `content.xml` |
| Anzeigename | `Sector Overview` | `content.xml` |
| Save-Relevanz | `save="0"` | `content.xml` |

## 5. Konfliktregel und Pflege

Bei Konflikten gilt die Quellenhierarchie aus `WORKFLOW_BOOTSTRAP.md` und `workflow/ERROR_AND_ASSUMPTION_POLICY.md`.

Änderungen an dieser Overlay-Datei benötigen denselben regulären Freigabeprozess wie andere Projektregeln. Die automatische Ausnahme überträgt sich nicht auf andere Projekte oder andere, nicht bereits freigegebene Änderungen.
