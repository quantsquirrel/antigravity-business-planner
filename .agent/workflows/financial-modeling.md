# financial-modeling

재무 모델을 수립하고 수익성을 분석합니다.

## 분석 항목
* 초기 투자 비용 (시설, 장비, 인테리어, 보증금 등)을 산출합니다
* 월별 고정비 (임대료, 인건비, 보험, 감가상각 등)를 정리합니다
* 월별 변동비 (원재료, 유틸리티, 마케팅 등)를 추정합니다
* 제품/서비스별 예상 매출을 산정합니다
* 월별 손익계산서를 작성합니다 (12개월)
* 손익분기점 (BEP)을 계산합니다
* 3개년 재무제표 (손익계산서, 현금흐름표)를 추정합니다
* 시나리오 분석: 낙관적 / 기본 / 비관적 케이스를 제시합니다
* 핵심 재무비율 5개를 산출합니다 (매출총이익률, 영업이익률, BEP 도달 개월, 초기투자 대비 매출 배수, 월 고정비 커버리지)

## 출력 형식
* 모든 수치는 표 형태로 정리합니다
* 주요 가정(assumptions)을 명확히 기술합니다
* "이 수치는 추정치이며, 실제와 다를 수 있습니다"를 명시합니다
* output/financials/ 폴더에 결과를 저장합니다

## AI 사업 재무 모델링 (v2.0 Phase 6)

idea.json에 `ai_business.detected: true`가 설정된 경우, AI 특화 재무 모델을 추가로 수행합니다.

### 트리거 조건
* `output/ideas/{id}-{name}/idea.json`의 `ai_business.detected` 값이 `true`일 때 자동 활성화

### 사용 템플릿
* 기본 재무 템플릿 대신 `templates/ai-business-financial-template.md` 양식을 사용합니다
* 기존 `templates/financial-projection-template.md`의 항목도 병행 분석할 수 있습니다

### 추가 분석 항목
* **AI 변동비 분석**: LLM API 호출 비용(원/1K토큰), GPU 컴퓨팅, 임베딩/벡터 검색, 데이터 저장/전송 비용을 항목별로 산출합니다
* **비용 스케일링 시뮬레이션**: MAU 100 / 1,000 / 10,000 / 100,000 구간별 비용 곡선을 작성합니다
* **Unit Economics**: ARPU, AI 마진(>60% 양호), CAC, LTV, LTV/CAC(>3배 양호)를 계산합니다
* **AI 재무 건전성 지표 5개**: AI 마진, LTV/CAC, BEP 도달, AI 비용 비중, R&D 비율을 평가합니다
* **AI 비용 리스크**: API 가격 인상, 오픈소스 대체재, AI 규제, 데이터 저작권 리스크를 분석합니다

### 출력 형식
* 기존 재무 모델과 동일하게 마크다운 표 형식으로 정리합니다
* AI 비용은 고정비/변동비를 명확히 분리하여 표기합니다
* output/financials/ 폴더에 결과를 저장합니다

## Micro-SaaS 재무 모델링 (v2.0 Phase 7)

idea.json의 `business_scale`이 `"micro"` 또는 `"small"`인 경우, Micro-SaaS 전용 재무 모델을 수행합니다.

### 트리거 조건
* `output/ideas/{id}-{name}/idea.json`의 `business_scale` 값이 `"micro"` 또는 `"small"`일 때 자동 활성화
* AI 사업인 경우(`ai_business.detected: true`) Phase 6 AI 재무 분석도 병행 가능

### 사용 템플릿
* 기존 재무 템플릿 대신 `templates/micro-saas-financial-template.md` 양식을 사용합니다
* 기존 `templates/financial-projection-template.md`의 항목 중 해당되는 부분도 병행 참조합니다

### 핵심 차이점 (기존 대비)

| 항목 | 기존 (startup/enterprise) | Micro-SaaS (micro/small) |
|------|-------------------------|------------------------|
| 초기 투자 | 시설, 장비, 인테리어, 보증금 | 도메인, 호스팅, SaaS 도구 ($100-500) |
| 월 고정비 | 임대료, 인건비, 보험 | SaaS 구독, API, 호스팅 ($50-500) |
| 월 변동비 | 원재료, 유틸리티 | API 호출, 결제 수수료, 대역폭 |
| 수익 모델 | 다양 (판매, 서비스, 구독) | 구독 (MRR) 중심 |
| BEP 기준 | 월 매출 > 월 비용 | MRR > 월 고정비 |
| 핵심 지표 | 매출총이익률, 영업이익률, BEP | MRR, Churn, LTV/CAC, ARPU |

### 추가 분석 항목
* **비용 스케일링**: 유료 고객 50/100/500/1,000명 구간별 비용 곡선
* **가격 민감도**: 가격 x1.5, x0.7 시 전환율 변화 시뮬레이션
* **도구 비용 최적화**: 무료 티어 -> 유료 전환 시점 분석

### 출력 형식
* `templates/micro-saas-financial-template.md` 양식에 맞춰 작성
* output/financials/ 폴더에 결과를 저장합니다

## 다음 단계
* 재무 모델 완료 → `/operations-plan`으로 운영 계획 수립
* 수익성이 낮은 경우 → `/menu-costing`으로 원가 구조 재검토
* KPI를 먼저 정의하려면 → `/kpi-framework` (선택적 보조 워크플로우)
* TCO를 상세 분석하려면 → `/tco-dashboard` (선택적 보조 워크플로우)
* 전체 진행률 확인 → `/check-progress`
