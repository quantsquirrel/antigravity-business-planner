<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-16 | Updated: 2026-02-16 -->

# scripts

## Purpose
Python automation for scanning `output/` directory and calculating 8-step business planning completion status.

## Key Files

| File | Description |
|------|-------------|
| `check_progress.py` | Scans output subdirectories for artifacts matching each of 8 planning steps; calculates completion percentage and recommends next steps |

## For AI Agents

### Working In This Directory
- Execute with `.venv/bin/python` if venv exists, otherwise `python3`
- Never show Python commands to users; run silently
- Results displayed directly in chat, not saved to file
- 8 steps tracked: market research, competitor analysis, product planning, financial modeling, operations, branding, legal, business plan

<!-- MANUAL: -->
