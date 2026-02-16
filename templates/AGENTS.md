<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-16 | Updated: 2026-02-16 -->

# templates

## Purpose
Document templates and HTML export themes. Templates define the standard structure for business planning documents. Themes provide styled HTML layouts for document export (Markdown to HTML/PDF conversion).

## Key Files

| File | Description |
|------|-------------|
| `business-plan-template.md` | 10-section business plan structure with tables and placeholder fields |
| `financial-projection-template.md` | Financial projection template: investment, P&L, BEP, scenarios |
| `market-analysis-template.md` | Market analysis template: TAM/SAM/SOM, trends, customer segments |
| `pitch-deck-outline.md` | 10-15 slide pitch deck structure with speaker notes |
| `idea-evaluation-template.md` | Idea evaluation template: user profile, candidate ideas, 5-point scoring, Go/Pivot/Drop |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `themes/` | HTML theme files for document export styling (see `themes/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Templates are reference structures; do not modify them directly
- Use templates as the basis for generating documents in `output/`
- The report-writer skill references these templates for consistent document structure
- All templates use Korean headers with structured tables and placeholder fields

### Common Patterns
- Templates use Markdown with tables for structured data entry
- Each template includes an Executive Summary section at the top
- Financial templates include scenario analysis (optimistic/base/pessimistic)

<!-- MANUAL: -->
