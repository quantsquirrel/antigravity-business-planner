<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-16 | Updated: 2026-02-16 -->

# workflows

## Purpose
Slash-command workflow definitions for structured business planning steps. Users invoke these via `/workflow-name` in the agent chat. Each workflow is a Markdown file containing task instructions for the agent.

## Key Files

| File | Description |
|------|-------------|
| `market-research.md` | `/market-research` — TAM/SAM/SOM estimation, industry trends, customer segments |
| `competitor-analysis.md` | `/competitor-analysis` — Direct/indirect competitors, Porter's Five Forces, differentiation |
| `financial-modeling.md` | `/financial-modeling` — P&L statements, BEP calculation, 3-year projections, scenarios |
| `business-plan-draft.md` | `/business-plan-draft` — Integrates all prior analyses into a 10-section business plan |
| `branding-strategy.md` | `/branding-strategy` — Brand positioning, personas, naming, marketing channels |
| `operations-plan.md` | `/operations-plan` — Daily operations, staffing, process design |
| `legal-checklist.md` | `/legal-checklist` — Permits, licenses, regulatory requirements checklist |
| `menu-costing.md` | `/menu-costing` — Product cost analysis, target margin calculation |
| `check-progress.md` | `/check-progress` — Scans output/ to show completion status (conditional Stage 0 + 8 steps) |
| `export-documents.md` | `/export-documents` — Markdown to styled HTML conversion for sharing/printing |
| `idea-discovery.md` | `/idea-discovery` — Structured questions to discover business ideas from domain expertise |
| `idea-validation.md` | `/idea-validation` — Validate discovered ideas with market checks, assumptions, MVP proposals |

## For AI Agents

### Working In This Directory
- Step 0 (idea-discovery, idea-validation) is optional for users who already have a business idea
- Workflows follow the recommended planning sequence: optional Step 0 → 8-step flow (see GUIDE.md Section 4)
- Steps 5-7 (operations, branding, legal) can run in parallel
- `/business-plan-draft` should be used last as it integrates all prior outputs
- Each workflow specifies its output destination in `output/`

### Common Patterns
- Workflow files use imperative instructions describing what the agent should do
- Results from earlier workflows feed into later ones (cascading data flow)

<!-- MANUAL: -->
