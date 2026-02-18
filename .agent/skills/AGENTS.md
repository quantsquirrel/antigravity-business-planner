<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-16 | Updated: 2026-02-18 -->

# skills

## Purpose
Specialized capability packages that activate based on context. Contains 15 core skills (direct directories) and 3 extended skills (symlinks to `.agents/skills/`). Each skill has a `SKILL.md` defining its role, and some include `scripts/` with Python automation.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `business-researcher/` | Market research, industry analysis, competitor data collection (see `business-researcher/AGENTS.md`) |
| `data-visualizer/` | Chart/graph generation using matplotlib (see `data-visualizer/AGENTS.md`) |
| `document-exporter/` | Markdown to HTML/PDF conversion with themed styling (see `document-exporter/AGENTS.md`) |
| `financial-analyst/` | Financial modeling, cost calculation, BEP, scenario analysis (see `financial-analyst/AGENTS.md`) |
| `pitch-deck-creator/` | Investor pitch deck content and structure (see `pitch-deck-creator/AGENTS.md`) |
| `progress-tracker/` | 8-step planning progress monitoring (see `progress-tracker/AGENTS.md`) |
| `report-writer/` | Business document writing using templates (see `report-writer/AGENTS.md`) |
| `swot-analyzer/` | Strategic framework analysis: SWOT, PESTEL, Porter's, BMC (see `swot-analyzer/AGENTS.md`) |
| `opportunity-finder/` | Business idea discovery from domain expertise (v2.0: 2-step interview, 100-point weighted scoring, 4-tier judgment, Impact-Effort matrix, brainstorm frameworks) (Step 0) |
| `ai-business-analyst/` | AI 비즈니스 전문 분석: AI 사업 유형 8개 분류, 보충 질문, 유형별 수익/리스크/방어력 가이드, AI 경쟁력 보충 스코어링 |
| `tax-guide/` | Tax management guide for sole proprietors (see `tax-guide/AGENTS.md`) |
| `ai-pricing-calculator/` | AI 서비스 토큰 기반 비용 계산, 최적 요금제 설계, 마진 시뮬레이션 |
| `customer-success-designer/` | 고객 성공 및 온보딩 자동화 설계: 셀프서브 온보딩, NPS 조사, CS 워크플로우, SLA 가이드 |
| `nocode-decision-tree/` | 코드 vs 노코드 vs AI 코딩 도구 의사결정 트리, 도구 비교, 전환 비용 예측 |
| `prompt-asset-designer/` | AI 서비스 프롬프트 설계, RAG 파이프라인 명세, Eval 기준, Guardrails 체크리스트 |
| `revenue-diversification/` | 수익 다각화 전략 평가, 2차 수익원 비교, Impact-Effort 매트릭스, 기존 자산 활용 |
| `launch-strategy/` | *Symlink* -> `../../.agents/skills/launch-strategy` — Product launch planning |
| `pricing-strategy/` | *Symlink* -> `../../.agents/skills/pricing-strategy` — Pricing and monetization design |
| `startup-metrics-framework/` | *Symlink* -> `../../.agents/skills/startup-metrics-framework` — KPI and metrics tracking |

## For AI Agents

### Working In This Directory
- Skills are activated by matching `description` field in SKILL.md YAML frontmatter
- Skills with `scripts/` subdirectories run Python automation; use `.venv/bin/python` if available
- Never show Python commands to users; execute scripts silently
- Last 3 entries are symlinks; edit the source files in `.agents/skills/` not here

### Common Patterns
- SKILL.md structure: YAML frontmatter (`name`, `description`) + role definition + process steps + output rules
- Output destination varies by skill type: `output/ideas/`, `output/research/`, `output/financials/`, `output/reports/`, `output/presentations/`
- `opportunity-finder` outputs to `output/ideas/`; `selected-idea.md` bridges Step 0 → Step 1

<!-- MANUAL: -->
