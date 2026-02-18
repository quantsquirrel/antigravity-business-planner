<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-16 | Updated: 2026-02-19 (Phase G) -->

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
| `automation-blueprint.md` | `/automation-blueprint` — AI 자동화 파이프라인 설계: 자동화 기회 발굴, 워크플로우 명세, ROI 계산 |
| `exit-strategy.md` | `/exit-strategy` — 사업 매각/Exit 준비 감사: Due Diligence, ARR Multiple, 매각 플랫폼, 6개월 타임라인 |
| `global-expansion.md` | `/global-expansion` — 해외 진출 실행 가이드: i18n, 결제 인프라, 국가별 규제, 글로벌 마케팅 |
| `solo-sustainability.md` | `/solo-sustainability` — 1인 사업자 장기 지속가능성: 에너지 관리, CS 자동화, 번아웃 진단, 고용 의사결정 |
| `quick-start.md` | `/quick-start` — 10분 비즈니스 플랜: 5단계 압축 프로세스로 빠른 온보딩 |
| `customer-discovery.md` | `/customer-discovery` — 고객 검증: Mom Test, 인터뷰 스크립트, Red-teaming, Pivot/Persevere |
| `payment-setup.md` | `/payment-setup` — 결제 인프라 구축: PG 선택 트리, 구독 설정, 테스트 가이드 |
| `pmf-measurement.md` | `/pmf-measurement` — PMF 측정 루프: Sean Ellis 40%, 코호트 리텐션, PMF 대시보드 |
| `ai-builder.md` | `/ai-builder` — AI 코딩 도구(Cursor, Bolt, v0, Lovable) 활용 MVP 구현 가이드 |
| `deploy-guide.md` | `/deploy-guide` — 1인 빌더 배포 가이드: CI/CD, 호스팅, 비용 관리 |
| `growth-loop.md` | `/growth-loop` — 출시 후 성장 루프: 텔레메트리, 피드백, KPI 연동 |

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
