<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-16 | Updated: 2026-02-16 -->

# data-visualizer

## Purpose
Business data visualization skill. Converts data into charts (bar, line, pie, stacked bar, waterfall) using matplotlib via `scripts/create_chart.py`. All charts use Korean labels and proper units.

## Key Files

| File | Description |
|------|-------------|
| `SKILL.md` | Skill definition: supported chart types, usage flow, output rules |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `scripts/` | Python chart generation script (see `scripts/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Execute `scripts/create_chart.py` silently; never show Python commands to users
- Use `.venv/bin/python` if venv exists, otherwise `python3`
- Charts must have Korean titles/labels with clear units (원, %, 명)
- Save PNG output to appropriate `output/` subdirectory

<!-- MANUAL: -->
