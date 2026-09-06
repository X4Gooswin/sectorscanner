# Workflow Bootstrap

**Status:** Aktiv.  
**Zweck:** Verbindliche Zuordnung von Sector Overview zu einem exakt gepinnten zentralen Workflow-Stand.

## 1. Projekt

```yaml
project:
  name: "Sector Overview"
  repository: "X4Gooswin/sectorscanner"
  development_branch: "main"
```

## 2. Gepinnter zentraler Workflow

```yaml
workflow:
  repository: "X4Gooswin/x4_modding_workflow"
  version: "V2.0.0"
  commit_sha: "8ba058aef8b0ffe06c3debf0dbb957e658fad43e"
```

`version` und `commit_sha` sind gemeinsam verbindlich. Eine neuere Workflow-Version wird nicht automatisch übernommen.

## 3. Projektspezifische Regeln und Abweichungen

```yaml
project_rules:
  overlay_file: "documentation/PROJECT_RULES.md"
  deviations_declared: false
  automatic_exceptions_declared: true
```

Die automatische Ausnahme ist ausschließlich der in `documentation/PROJECT_RULES.md` eng begrenzte Fehler-Rollback innerhalb einer bereits freigegebenen Änderungseinheit.

## 4. Projektquellen

```yaml
sources:
  project_status: "documentation/PROJECT_STATUS.md"
  todo: "documentation/TODO.md"
  todo_done: "documentation/TODO_DONE.md"
  error_log: "documentation/ERROR_LOG.md"
  measures_history: none
  architecture: none
  roadmap: none
  test_plan: "documentation/TEST_PLAN.md"
  documentation_navigation: none
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
  debug_logs: []
```

Technische Quellen werden nur bei Relevanz für den aktuellen Arbeitspunkt gelesen.

## 6. Quellenhierarchie

1. exakt gepinnter zentraler Workflow,
2. ausdrücklich dokumentierte projektspezifische Ergänzungen/Abweichungen/Ausnahmen,
3. projektspezifische Fach- und Steuerdokumente.

## 7. Validierungsstand

- Workflow-Repository, Version und exakter Commit wurden vor Einrichtung dieses Bootstraps geprüft.
- Projekt-Repository und Branch `main` wurden geprüft.
- Die verpflichtenden Projektquellen werden mit diesem Organisationsstand angelegt.
- Nicht verwendete optionale Einzelquellen sind als `none`, nicht verwendete technische Kategorien als `[]` gekennzeichnet.
