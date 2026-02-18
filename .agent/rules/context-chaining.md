# Context Chaining

* 워크플로우 시작 시 output/ 디렉토리를 스캔하여 관련 선행 산출물을 확인합니다.
* 선행 산출물이 있으면 핵심 내용을 요약(3-5줄)하여 현재 분석의 컨텍스트로 활용합니다.
* output/ideas/ 하위의 idea.json 메타데이터(score_details, judgment, psst_mapping)를 후속 단계에 자동 전파합니다.
* 과도한 컨텍스트 주입을 방지합니다: 전체 파일이 아닌 요약본만 로드합니다.
* 참조한 선행 산출물의 파일명을 문서 서두에 "참조 문서" 항목으로 명시합니다.

## 단계별 참조 매핑

| 현재 단계 | 참조할 선행 산출물 |
|-----------|-------------------|
| 시장 조사 (/market-research) | output/ideas/*/idea.json, hypothesis.md |
| 경쟁 분석 (/competitor-analysis) | output/research/시장조사*.md |
| 제품/원가 분석 (/menu-costing) | output/ideas/*/idea.json |
| 재무 모델링 (/financial-modeling) | output/research/*.md, output/financials/원가*.md |
| 운영 계획 (/operations-plan) | output/ideas/*/idea.json, output/financials/*.md |
| 브랜딩 전략 (/branding-strategy) | output/ideas/*/hypothesis.md, output/research/*.md |
| 법률 체크리스트 (/legal-checklist) | output/ideas/*/idea.json |
| 사업계획서 (/business-plan-draft) | output/research/*.md, output/financials/*.md, output/reports/*.md |
| AI 분석 (ai-business-analyst) | output/ideas/*/idea.json (ai_business 블록), output/ideas/*/ai-analysis.md |
| AI 재무 모델링 (/financial-modeling + AI) | output/ideas/*/ai-analysis.md, output/financials/원가*.md, templates/ai-business-financial-template.md |
| MVP 정의 (/mvp-definition) | output/ideas/*/idea.json, output/ideas/*/evaluation.md |
| GTM 전략 (/gtm-launch) | output/ideas/*/idea.json, output/research/*.md, output/reports/branding*.md |
| KPI 프레임워크 (/kpi-framework) | output/financials/*.md, output/ideas/*/idea.json |
| 보안 스캔 (/security-scan) | output/**/*.md (전체 스캔) |
| 버전 관리 (/version-history) | output/reports/business-plan*.md, output/reports/CHANGELOG.md |
| TCO 대시보드 (/tco-dashboard) | output/financials/*.md, output/ideas/*/idea.json |

## 요약 생성 규칙

* 선행 산출물이 500자 이하이면 전문을 포함합니다.
* 500자 초과 시 핵심 요약(3-5줄)만 추출합니다: Executive Summary, 핵심 수치, 판정 결과 위주.
* idea.json은 항상 전문을 포함합니다 (구조화된 메타데이터이므로).
