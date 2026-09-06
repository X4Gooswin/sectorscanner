# Changelog

## 2026-09-07 – ORGA-002

- upgraded `WORKFLOW_BOOTSTRAP.md` to central workflow V3.1.0 at `698d56838ae71d29e5a09ec95911c82ec9c92337`
- made the project bootstrap the explicit sole source of the Sector Overview workflow pin
- added architecture, roadmap and documentation navigation for the standalone mod
- replaced the obsolete empty-project TODO state with the known ordered work through the planned V1.0.0 snapshot
- registered ORGA-003, TEST-001, TODO-001, TODO-002 and ORGA-004 as the remaining ordered work
- added deterministic local debug log filtering, retention and narrowly scoped automatic `debug/**` synchronization on `main`
- no AI/API analysis is part of the debug workflow
- no existing runtime file was changed by ORGA-002

## 2026-09-06 – ORGA-001

- established `WORKFLOW_BOOTSTRAP.md` pinned to central workflow V2.0.0 at `8ba058aef8b0ffe06c3debf0dbb957e658fad43e`
- added central project status, TODO control, TODO history, error log, stable ID register and project test plan
- documented Sector Overview as secondary to Veteran Ships for the current project phase
- established the project rule to prepare and verify a coherent work block before normally committing/pushing it once
- added the narrowly scoped automatic rollback exception for restoring the documented pre-change state after a technical failure inside an already approved change unit

### Preserved runtime baseline

- previous `main` commit: `ee4a953b573797ae9cf30c62c54e2c011f3bfb2c`
- previous commit message: `SECTOR-001 – preserve exact staged HUD runtime`
- no runtime file was changed by ORGA-001; this organizational commit adds only workflow/project-control documentation
