<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-16 | Updated: 2026-02-18 -->

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
| `terms-of-service-template.md` | 이용약관 템플릿: 서비스 이용 조건, 면책 조항, 분쟁 해결, 개인사업자/법인 대응 |
| `privacy-policy-template.md` | 개인정보처리방침 템플릿: 수집 항목, 이용 목적, 보유 기간, 제3자 제공, 파기 절차 |
| `service-agreement-template.md` | 서비스 계약서 템플릿: 계약 조건, SLA, 대금 지급, 지식재산권, 해지 조건 |
| `blueprint-for-cursor.md` | AI 코딩 에이전트용 명세서: 프로젝트 개요, 기술 스택 추천 조합, 파일 구조, 기능 명세, 데이터 스키마, API, UI/UX |
| `exit-due-diligence.md` | 사업 매각 데이터룸 체크리스트: 재무/고객/기술/법률/운영 5개 영역, 매각 준비도 자가 점검 100점 |
| `n8n-workflow-spec.json` | 자동화 워크플로우 설계 명세 (JSON): 트리거, 단계별 노드, 에러 처리, 변수, 테스트 체크리스트, 비용 산정 |
| `nps-survey.md` | NPS 순추천지수 조사 템플릿: 설문 양식 (한/영), 이메일 템플릿, 인앱 모달 가이드, 결과 해석, 운영 가이드 |
| `sla-lite.md` | 1인 SaaS 서비스 수준 약속: 가용률, 응답 시간, 백업, 환불, 변경 고지, 면책 조항 (한/영 병기) |

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
