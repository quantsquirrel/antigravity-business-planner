<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-16 | Updated: 2026-02-16 -->

# .agent

## Purpose
Primary agent configuration directory for Google Antigravity. Contains rules (behavioral guidelines), workflows (slash-command task instructions), and skills (specialized capability packages) that define how the AI agent operates in business planning context.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `rules/` | Behavioral rules automatically applied to all agent responses (see `rules/AGENTS.md`) |
| `skills/` | 9 core skills + 3 symlinked extended skills for specialized tasks (see `skills/AGENTS.md`) |
| `workflows/` | 16 slash-command workflow definitions for structured business planning steps (see `workflows/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Rules are auto-loaded and always active; do not override them
- Skills activate based on context matching from their SKILL.md `description` field
- Workflows are triggered by user slash commands (`/workflow-name`)
- Symlinks in `skills/` (launch-strategy, pricing-strategy, startup-metrics-framework) point to `../.agents/skills/`

### Common Patterns
- Each skill has a `SKILL.md` with YAML frontmatter (`name`, `description`) and detailed instructions
- Skills with Python automation have a `scripts/` subdirectory
- Workflow files are Markdown documents with structured task instructions

<!-- MANUAL: -->
