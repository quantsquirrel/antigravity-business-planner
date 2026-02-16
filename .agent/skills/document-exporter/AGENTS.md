<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-16 | Updated: 2026-02-16 -->

# document-exporter

## Purpose
Document conversion skill. Transforms Markdown business documents into styled HTML using theme templates from `templates/themes/`. Supports print-friendly PDF output via browser Cmd+P.

## Key Files

| File | Description |
|------|-------------|
| `SKILL.md` | Skill definition: conversion process, output rules, venv usage |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `scripts/` | Python export script `export_docs.py` (see `scripts/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Execute `scripts/export_docs.py` silently; never show Python commands to users
- Requires `markdown` and `jinja2` Python packages
- Output HTML is saved alongside the source Markdown file with `.html` extension
- Available themes: business, cosmic, modern (in `templates/themes/`)

<!-- MANUAL: -->
