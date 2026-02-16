<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-16 | Updated: 2026-02-16 -->

# financial-analyst

## Purpose
Financial analysis skill. Calculates initial investment, monthly P&L, break-even point, and 3-year projections with scenario analysis (optimistic/base/pessimistic). Uses `scripts/calculate_costs.py` for complex calculations.

## Key Files

| File | Description |
|------|-------------|
| `SKILL.md` | Skill definition: analysis process (5 steps), calculation tools, output rules |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `scripts/` | Python cost calculation script (see `scripts/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Always present financial data in Markdown tables with clear units
- State assumptions at the top of every financial document
- Include disclaimer: "이 수치는 추정치이며 실제와 다를 수 있습니다"
- Save output to `output/financials/`
- Execute calculation scripts silently

<!-- MANUAL: -->
