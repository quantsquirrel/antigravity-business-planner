<!-- Generated: 2026-02-16 | Updated: 2026-02-16 -->

# antigravity-business-planner

## Purpose
Google Antigravity(AI IDE) 기반의 사업 기획 도구. 비개발자도 자연어(한국어)로 시장조사, 경쟁분석, 재무모델링, 사업계획서 작성 등 사업 기획 전 과정을 수행할 수 있도록 Rules, Workflows, Skills, Templates를 패키징한 프로젝트.

## Key Files

| File | Description |
|------|-------------|
| `GUIDE.md` | End-user guide covering installation, workflows, prompts, and FAQ |
| `setup.sh` | One-click setup script that creates all directories, rules, workflows, skills, templates, and Python venv |
| `mcp-config-template.json` | MCP server configuration template (Google Sheets, Notion, Perplexity) |
| `.gitignore` | Ignores user-generated output, Python artifacts, IDE files, OMC state |
| `theme_viewer.html` | HTML preview tool for document export themes |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `.agent/` | Primary agent configuration: rules, workflows, and 9 core skills (see `.agent/AGENTS.md`) |
| `.agents/` | Extended skills: launch-strategy, pricing-strategy, startup-metrics-framework (see `.agents/AGENTS.md`) |
| `output/` | All generated artifacts: ideas, research, financials, reports, presentations (see `output/AGENTS.md`) |
| `templates/` | Document templates and HTML themes for export (see `templates/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- All communication must be in Korean (see `.agent/rules/korean-communication.md`)
- Follow business document style guidelines (see `.agent/rules/business-planning-style.md`)
- Observe safety guidelines for financial/legal disclaimers (see `.agent/rules/safety-guidelines.md`)
- Use technical-to-business term mapping from `korean-communication.md` when addressing users
- Python scripts use `.venv/bin/python` if venv exists, otherwise `python3`

### Testing Requirements
- Verify generated output files exist in correct `output/` subdirectory
- Check document export produces valid HTML with proper Korean fonts
- Run `scripts/check_progress.py` to validate the planning process (conditional Stage 0 + 8 steps)

### Common Patterns
- Workflows are invoked via `/workflow-name` slash commands in the agent chat
- Skills activate automatically when relevant context is detected
- Output follows the planning flow: (optional) idea discovery -> market research -> SWOT -> product planning -> financial modeling -> operations -> branding -> legal -> business plan
- Step 0 (idea discovery/validation) is optional; `output/ideas/selected-idea.md` bridges to Step 1
- Templates in `templates/` provide standardized document structure
- Symlinks in `.agent/skills/` point to `.agents/skills/` for newer skills

## Dependencies

### External
- Python 3.8+ (for chart generation, financial calculations, document export, progress tracking)
- `markdown` and `jinja2` Python packages (installed in `.venv/` by `setup.sh`)
- Google Antigravity IDE (antigravity.google)

<!-- MANUAL: -->
