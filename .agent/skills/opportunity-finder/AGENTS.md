<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-17 | Updated: 2026-02-17 -->

# opportunity-finder

## Purpose
Business opportunity discovery skill (v2.0) for users who have domain knowledge but no concrete business idea. Guides users through a 2-step Progressive Profiling interview (3+2 questions mapped to PSST framework), generates 3-5 hypothesis-level ideas, and evaluates them with a 100-point weighted scoring system and 4-tier judgment (Go/Pivot-optimize/Pivot-review/Drop).

## Key Files

| File | Description |
|------|-------------|
| `SKILL.md` | Skill definition (v2.0): 2-step interview protocol, PSST implicit structuring, 100-point weighted scoring (5 items x weight), 4-tier judgment, Kill Switch, conditional SCAMPER, Human-in-the-Loop, ASCII visualization, R&D keyword mapping |

## For AI Agents

### Working In This Directory
- Use the 2-step interview protocol: Step A (Problem+Scale: 3 questions) → Step B (Solution+Team: 2 questions)
- PSST/JTBD terms are never shown to users (Implicit Structuring principle)
- Ideas must be hypothesis-level (1 paragraph each), not deep analysis
- Use 100-point weighted scoring: market size(x5) + competition(x4) + founder-problem fit(x5) + resources(x3) + timing(x3)
- Apply 4-tier judgment: Go(80+) / Pivot-optimize(66-79) / Pivot-review(48-65) / Drop(47-)
- Check Kill Switch: any individual item scoring <3 triggers a Critical Warning regardless of total score
- Apply conditional SCAMPER when idea diversity is low (similarity >0.85)
- Run Human-in-the-Loop confirmation before scoring (user reviews/edits idea list)
- Generate ASCII visualization + R&D keyword mapping via `scripts/create_idea_score_chart.py`
- Save confirmed ideas to `output/ideas/{id}-{name}/` with idea.json (v2.0 schema)
- Maintain `output/ideas/selected-idea.md` for legacy compatibility
- Discovery-validation cycle is limited to 2 iterations max
- Deep market analysis belongs to `business-researcher`, not this skill

### idea.json v2.0 Schema Fields
`id`, `name`, `full_name`, `created`, `status`, `judgment` (go|pivot-optimize|pivot-review|drop), `score`, `score_details` (market_size, competition, founder_fit, resources, timing), `current_alternatives`, `founder_fit_reason`, `psst_mapping` (problem, solution, scale, team), `kill_switch` (triggered, items), `workflow_version`

### Common Patterns
- v1.0 → v2.0 field changes: `fit` → `founder_fit`, added `judgment`, `kill_switch`, and `workflow_version`
- `--legacy` flag reverts to v1.0 five-question batch interview
- `--scamper` flag enables SCAMPER in batch/unattended mode
- `--force` flag bypasses Kill Switch user confirmation
- `--chart` flag generates matplotlib radar chart PNG (optional)

<!-- MANUAL: -->
