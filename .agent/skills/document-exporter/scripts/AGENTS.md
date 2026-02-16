<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-16 | Updated: 2026-02-16 -->

# scripts

## Purpose
Python automation for Markdown to styled HTML document conversion.

## Key Files

| File | Description |
|------|-------------|
| `export_docs.py` | Converts Markdown files to HTML using theme templates from `templates/themes/`, with TOC generation and print-friendly CSS |

## For AI Agents

### Working In This Directory
- Execute with `.venv/bin/python` if venv exists, otherwise `python3`
- Never show Python commands to users; run silently
- Requires `markdown` (with toc, tables, fenced_code extensions) and `jinja2` packages
- Loads theme HTML from `templates/themes/` directory
- Output HTML is saved alongside the source Markdown file

<!-- MANUAL: -->
