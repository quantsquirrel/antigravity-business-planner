<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-17 | Updated: 2026-02-17 -->

# opportunity-finder

## Purpose
Business opportunity discovery skill for users who have domain knowledge but no concrete business idea. Guides users through 5 structured questions, generates 3-5 hypothesis-level ideas, and evaluates them with a Go/Pivot/Drop scoring system (25-point scale).

## Key Files

| File | Description |
|------|-------------|
| `SKILL.md` | Skill definition: role, 5 structured questions, idea generation process, Go/Pivot/Drop evaluation criteria (5-point scale x 5 items) |

## For AI Agents

### Working In This Directory
- Ask all 5 structured questions before generating ideas
- Ideas must be hypothesis-level (1 paragraph each), not deep analysis
- Use the 25-point Go/Pivot/Drop scoring system for evaluation
- Save selected idea to `output/ideas/selected-idea.md` for handoff to Step 1
- Discovery-validation cycle is limited to 2 iterations max
- Deep market analysis belongs to `business-researcher`, not this skill

<!-- MANUAL: -->
