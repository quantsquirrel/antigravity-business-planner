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
| `idea-evaluation-template.md` | Idea evaluation template (v2.0): user profile, candidate ideas, 100-point weighted scoring, 4-tier judgment (Go/Pivot-optimize/Pivot-review/Drop), Kill Switch |
| `lean-canvas-template.md` | Lean Canvas template: 9-block business model canvas (problem, solution, UVP, channels, revenue, cost, metrics, unfair advantage, customer segments) |
| `portfolio-template.md` | Portfolio dashboard template: multi-idea status overview, stage summary, user notes |
| `ai-business-financial-template.md` | AI 사업 특화 재무 모델: AI 변동비(API/GPU/데이터), 비용 스케일링, Unit Economics, AI 재무 건전성 5개 지표, AI 비용 리스크 |

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
