# Sectorscanner – Project Rules / Workflow Overlay

**Status:** Aktiv.  
**Bootstrap:** `WORKFLOW_BOOTSTRAP.md`

Diese Datei enthält nur projektspezifische Ergänzungen und ausdrücklich freigegebene automatische Ausnahmen zum gepinnten zentralen Workflow.

## 1. Verbindlicher Workflow-Pin

Für Sectorscanner gilt ausschließlich der Workflow-Pin aus `WORKFLOW_BOOTSTRAP.md`.

Chatübergaben, Starttexte, Gesprächszusammenfassungen, frühere Chats oder ein aktuellerer Stand von `X4Gooswin/x4_modding_workflow` dürfen diesen Pin nicht ersetzen. Ein Workflow-Upgrade erfolgt ausschließlich kontrolliert nach dem gepinnten `workflow/CHATSTART.md`.

## 2. Projektspezifische Ergänzungen

| Zentrale Referenz | Projektspezifische Ergänzung | Begründung |
|---|---|---|
| `workflow/GIT_WORKFLOW.md` / `workflow/PROJECT_CONTROL.md` | Ein zusammengehöriger Arbeitsblock bzw. TODO-Arbeitsrest wird zunächst vollständig bearbeitet und geprüft. Danach erfolgt im Regelfall genau eine gemeinsame Git-Sicherung mit Commit/Push für diesen stabilen Arbeitsstand. Keine Zwischencommits nur wegen einzelner kleiner Dateiänderungen. | Git dient als nachvollziehbares Sicherungsnetz und nicht als Mikroschritt-Protokoll. |
| `workflow/GIT_WORKFLOW.md` | Zusätzliche Checkpoint-Commits sind nur sinnvoll, wenn ein eigenständig stabiler Zwischenstand, ein bewusster Teststand, ein Arbeitsblockwechsel oder eine technisch riskante Folgestufe dies rechtfertigt. | Verhindert unnötige Commit-Flut ohne die Nachvollziehbarkeit zu schwächen. |

## 3. Ausdrückliche Abweichungen

Keine.

## 4. Projektbezogene automatische Ausnahme – Fehler-Rollback

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

## 5. Projektbezogene automatische Ausnahme – Sectorscanner-Debug-Watcher

Der deterministische Debug-Watcher unter `tools/Watch-X4Debug.ps1` ist die zweite und einzige weitere automatische Ausnahme von der allgemeinen Freigabecodepflicht.

| Feld | Inhalt |
|---|---|
| Name der Automatik | Sectorscanner X4-Debug-Watcher |
| Zweck | X4-Debuglogs sicher übernehmen, deterministisch auf Sectorscanner-Bezug filtern, nach der definierten Aufbewahrungsregel verwalten und ausschließlich die vorgesehenen Debugartefakte mit GitHub synchronisieren. |
| Auslöser/Bedingung | Watcher läuft lokal; Debugverarbeitung erfolgt nach seinem implementierten Ablauf bei beendetem X4 und vorhandenen bzw. noch nicht vollständig gefilterten Debuglogs. |
| Erlaubte Dateien/Daten | Debuglog-Quelle unter dem lokalen X4-Dokumentpfad; globale Sectorscanner-Debug-Zwischenablage außerhalb des Repositorys; innerhalb des Repositorys ausschließlich `debug/**`. |
| Erlaubte lokale Zustandsänderungen | Debuglogs kopieren und per SHA256 verifizieren; deterministische Filterdateien erzeugen; Debugartefakte nach der implementierten Aufbewahrungsregel innerhalb `debug/**` verschieben bzw. alte vollständige Testsätze löschen; nach sicherer Übernahme die verarbeitete X4-`debuglog.txt` entfernen; globale Inbox nach erfolgreichem GitHub-Push bereinigen. |
| Erlaubte Git-Aktionen | ausschließlich auf Branch `main`: Branchprüfung; `git pull --rebase --autostash origin main`; ausschließlich `debug/**` stagen; Debug-Commit erzeugen; nach `origin/main` pushen. |
| Abweichendes Commitformat | ausschließlich für diesen Watcher: `debug: ...` |
| Verhalten auf anderen Branches / detached HEAD | lokale Debugverarbeitung zulässig; automatische Git-Aktionen vollständig pausiert. |
| Nicht erlaubt | KI-/API-Analyse; automatisches Staging/Committen anderer Projektdateien; automatische Git-Aktionen auf anderen Branches; Übertragung dieser Ausnahme auf andere Skripte, Dateien, Commits, Pushes oder Projekte. |

Die Filterung über `tools/prepare_debug_analysis.py` ist deterministisch. Der Watcher führt keine OpenAI-API- oder sonstige KI-Analyse aus.

## 6. Projektspezifische Parameter

| Parameter | Wert | Maßgebliche Projektquelle |
|---|---|---|
| Entwicklungsbranch | `main` | `WORKFLOW_BOOTSTRAP.md` |
| Aktives Versionsziel | `V1.0.0` | `documentation/PROJECT_STATUS.md`, `documentation/ROADMAP.md` |
| Extension-ID | `sectorscanner` | `content.xml` |
| Anzeigename | `Sectorscanner` | `content.xml` |
| Save-Relevanz | `save="0"` | `content.xml` |
| Abhängigkeiten | SirNukes Mod Support APIs und UI Extensions and HUD | `content.xml` |

## 7. Konfliktregel und Pflege

Bei Konflikten gilt die Quellenhierarchie aus `WORKFLOW_BOOTSTRAP.md` und `workflow/ERROR_AND_ASSUMPTION_POLICY.md`.

Änderungen an dieser Overlay-Datei benötigen denselben regulären Freigabeprozess wie andere Projektregeln. Die automatischen Ausnahmen übertragen sich nicht auf andere Projekte, andere Skripte oder andere nicht ausdrücklich abgedeckte Änderungen.
