<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-16 | Updated: 2026-02-16 -->

# progress-tracker

## Purpose
Planning progress monitoring skill. Scans `output/` subdirectories to determine completion status of the 8-step business planning process. Displays progress bar and recommends next steps.

## Key Files

| File | Description |
|------|-------------|
| `SKILL.md` | Skill definition: 8 tracking criteria, script usage, output format (checkmarks) |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `scripts/` | Python progress checking script (see `scripts/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Execute `scripts/check_progress.py` silently to scan output folders
- Display completed steps with ✅ and incomplete with ⬜
- Show overall percentage and recommend the next workflow to run
- Output is displayed directly in the chat (not saved to file)

<!-- MANUAL: -->
