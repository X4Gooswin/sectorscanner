# Workflow Bootstrap

**Status:** Aktiv.  
**Zweck:** Verbindliche Zuordnung von Sectorscanner zu einem exakt gepinnten zentralen Workflow-Stand.

## 1. Projekt

```yaml
project:
  name: "Sectorscanner"
  repository: "X4Gooswin/sectorscanner"
  development_branch: "main"
```

## 2. Gepinnter zentraler Workflow

```yaml
workflow:
  repository: "X4Gooswin/x4_modding_workflow"
  version: "V3.1.0"
  commit_sha: "698d56838ae71d29e5a09ec95911c82ec9c92337"
```

`version` und `commit_sha` sind gemeinsam verbindlich. Eine neuere Workflow-Version wird nicht automatisch übernommen.

**Ausschließlich dieser Bootstrap definiert den für Sectorscanner verbindlichen Workflow-Pin.** Chatübergaben, Starttexte, Zusammenfassungen, frühere Gesprächsinhalte oder ein aktuellerer Stand des Workflow-Repositories dürfen Version oder Commit-SHA nicht ersetzen.

## 3. Projektspezifische Regeln und Abweichungen

```yaml
project_rules:
  overlay_file: "documentation/PROJECT_RULES.md"
  deviations_declared: false
  automatic_exceptions_declared: true
```

Die ausdrücklich dokumentierten automatischen Ausnahmen stehen ausschließlich in `documentation/PROJECT_RULES.md`:

- Fehler-Rollback innerhalb einer bereits freigegebenen Änderungseinheit,
- deterministischer Sectorscanner-Debug-Watcher für den dort eng begrenzten Debug-/Git-Ablauf.

## 4. Projektquellen

```yaml
sources:
  project_status: "documentation/PROJECT_STATUS.md"
  todo: "documentation/TODO.md"
  todo_done: "documentation/TODO_DONE.md"
  error_log: "documentation/ERROR_LOG.md"
  measures_history: none
  architecture: "documentation/ARCHITECTURE.md"
  roadmap: "documentation/ROADMAP.md"
  test_plan: "documentation/TEST_PLAN.md"
  documentation_navigation: "documentation/README.md"
```

## 5. Optionale technische Quellen

```yaml
technical_sources:
  config:
    - "content.xml"
    - "ui.xml"
  core_code:
    - "md/sector_scanner_core.xml"
    - "md/sector_scanner_options.xml"
    - "ui/sector_scanner.lua"
  localization:
    - "t/0001-L007.xml"
    - "t/0001-L033.xml"
    - "t/0001-L034.xml"
    - "t/0001-L044.xml"
    - "t/0001-L048.xml"
    - "t/0001-L049.xml"
    - "t/0001-L055.xml"
    - "t/0001-L081.xml"
    - "t/0001-L082.xml"
    - "t/0001-L086.xml"
  debug_logs:
    - "debug/"
```

Technische Quellen werden nur bei Relevanz für den aktuellen Arbeitspunkt gelesen.

## 6. Fast Path

Der zentrale Workflow V3.1.0 stellt einen optionalen Fast Path bereit. Sectorscanner hat mit diesem Organisationsstand **keine projektspezifischen Fast-Path-Artefakte aktiviert**. Solange kein gültiger projektspezifischer Fast Path eingerichtet und verifiziert wurde, gilt der vollständige Startpfad des gepinnten Workflows.

## 7. Quellenhierarchie

1. exakt gepinnter zentraler Workflow,
2. ausdrücklich dokumentierte projektspezifische Ergänzungen/Abweichungen/Ausnahmen,
3. projektspezifische Fach- und Steuerdokumente.

## 8. Validierungsstand

- Workflow-Repository, Version V3.1.0 und exakter Commit `698d56838ae71d29e5a09ec95911c82ec9c92337` wurden vor diesem Upgrade geprüft.
- Projekt-Repository und Branch `main` wurden geprüft.
- Der Runtime-Ausgangsstand `5c504e27450844834ac09e6b1e1ab082af6fa350` wurde als Basis dieser Organisationsarbeit verwendet.
- Die bekannten nächsten Schritte bis zum vorgesehenen V1.0.0-Snapshot sind in Projektstatus, TODO und Roadmap eindeutig gesichert.
