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
| `idea-portfolio.md` | `/idea-portfolio` — Multi-idea portfolio dashboard: view, compare, and switch between ideas |
| `lean-canvas.md` | `/lean-canvas` — Lean Canvas 1페이지 가설 정리 (아이디어 확정 후, 시장조사 전) |
| `idea-brainstorm.md` | `/idea-brainstorm` — 역발상 리스크 발견 + 다각적 관점 분석 (Invisible Framework) |
| `my-outputs.md` | `/my-outputs` — output/ 전체 산출물 통합 대시보드 생성 |
| `auto-plan.md` | `/auto-plan` — 사업 기획 8단계 전체 자동 순차 진행, HITL 3곳에서 의사결정 확인 |
| `mvp-definition.md` | `/mvp-definition` — MVP 범위 정의, Impact-Effort 매트릭스, 출시 기준 체크리스트 |
| `gtm-launch.md` | `/gtm-launch` — Go-To-Market 전략, 5단계 출시 계획, Product Hunt 가이드 |
| `kpi-framework.md` | `/kpi-framework` — North Star Metric, SaaS 5대 지표, KPI 대시보드 |
| `security-scan.md` | `/security-scan` — output/ 산출물 개인정보/민감정보 스캔 및 마스킹 |
| `version-history.md` | `/version-history` — 사업계획서 변경 이력 관리, CHANGELOG 생성 |
| `tco-dashboard.md` | `/tco-dashboard` — 총 소유 비용(TCO) 추적, 비용 최적화 제안 |

## For AI Agents

### Working In This Directory
- Step 0 (idea-discovery, idea-validation, idea-portfolio) is optional for users who already have a business idea
- Workflows follow the recommended planning sequence: optional Step 0 → 8-step flow (see GUIDE.md Section 4)
- Steps 5-7 (operations, branding, legal) can run in parallel
- `/business-plan-draft` should be used last as it integrates all prior outputs
- `/idea-portfolio` manages multiple ideas with independent progress tracking per idea
- Each workflow specifies its output destination in `output/`

### Common Patterns
- Workflow files use imperative instructions describing what the agent should do
- Results from earlier workflows feed into later ones (cascading data flow)

<!-- MANUAL: -->
