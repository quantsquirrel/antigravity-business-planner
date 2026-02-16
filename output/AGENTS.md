<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-16 | Updated: 2026-02-16 -->

# output

## Purpose
All generated artifacts from the business planning process. Organized by output type. Most subdirectories are gitignored (user-generated data) except `.gitkeep` files and selected reference files.

## Key Files

| File | Description |
|------|-------------|
| `check_md.py` | Quick diagnostic to check if Python `markdown` package is installed |
| `diag.py` | Comprehensive diagnostic script: checks Python version, dependencies, themes, and export pipeline |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `ideas/` | Business idea discovery and validation artifacts from Step 0 (gitignored content) |
| `financials/` | Financial models, cost analyses, revenue projections (gitignored content) |
| `presentations/` | Pitch decks and presentation materials (gitignored content) |
| `previews/` | HTML preview files for document themes (see `previews/AGENTS.md`) |
| `reports/` | Business plans, analysis reports, strategy documents (gitignored except reference files) |
| `research/` | Market research, competitor analysis, SWOT results (gitignored content) |

## For AI Agents

### Working In This Directory
- Always save generated files to the correct subdirectory based on content type
- File naming convention: `YYYY-MM-DD_document-type.md` (e.g., `2026-02-16_market-analysis.md`)
- Contents of `ideas/`, `financials/`, `presentations/`, `reports/`, `research/` are gitignored
- Use `diag.py` to troubleshoot document export issues
- The `check_md.py` script verifies markdown package availability

### Common Patterns
- Each subdirectory has a `.gitkeep` to preserve the directory structure in git
- Generated documents are Markdown files that can be exported to HTML via the document-exporter skill
- The planning flow (optional Step 0 + 8 steps) determines which subdirectory receives output
- `ideas/selected-idea.md` bridges Step 0 (idea discovery) to Step 1 (market research)

<!-- MANUAL: -->
