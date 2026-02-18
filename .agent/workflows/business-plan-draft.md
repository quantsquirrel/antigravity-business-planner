# business-plan-draft

종합 사업계획서 초안을 작성합니다.

## 문서 구조
1. **Executive Summary** — 사업 개요를 1-2페이지로 요약
2. **사업 개요** — 비전, 미션, 핵심 가치
3. **제품/서비스** — 상세 설명, 특장점, 차별화 요소
4. **시장 분석** — 시장 규모, 트렌드, 고객 세그먼트 (기존 조사 결과 통합)
5. **경쟁 분석** — 경쟁 현황, 포지셔닝 (기존 분석 결과 통합)
6. **마케팅 전략** — 4P (Product, Price, Place, Promotion)
7. **운영 계획** — 조직, 프로세스, 공급망
8. **재무 계획** — 투자, 매출 예측, BEP (기존 모델링 결과 통합)
9. **팀 구성** — 핵심 인력, 역할, 채용 계획
10. **리스크 분석** — 주요 리스크와 대응 방안
11. **실행 로드맵** — 월별/분기별 마일스톤

## 작성 원칙
* output/research/ 와 output/financials/ 에 있는 기존 분석 결과를 최대한 활용합니다
* 각 섹션에 핵심 수치와 데이터를 포함합니다
* output/reports/ 폴더에 결과를 저장합니다
* 완성 후 `templates/business-plan-template.md`의 "BP 품질 자가 점검표"로 완성도를 확인합니다

## Micro-SaaS 사업계획서 (v2.0 Phase 7)

idea.json의 `business_scale`이 `"micro"` 또는 `"small"`인 경우, 문서 구조를 아래와 같이 조정합니다.

### 트리거 조건
* `output/ideas/{id}-{name}/idea.json`의 `business_scale` 값이 `"micro"` 또는 `"small"`일 때 자동 활성화

### 구조 조정

| 기존 섹션 (startup/enterprise) | micro/small 대체 |
|-------------------------------|-----------------|
| 9. 팀 구성 — 핵심 인력, 역할, 채용 계획 | 개인 역량 + 자동화 스택 (operations-plan 참조) |
| 7. 운영 계획 — 조직, 프로세스, 공급망 | 도구 기반 운영 모델 (operations-plan 참조) |
| 8. 재무 계획 — 투자, 매출 예측, BEP | MRR 중심 재무 모델 (micro-saas-financial-template 참조) |
| 6. 마케팅 전략 — 4P | 부트스트랩 성장 전략 (bootstrap-growth-template 참조) |

### Micro-SaaS 문서 구조 (8챕터)

1. **Executive Summary** — 1인/소규모 SaaS 사업 개요 (1페이지)
2. **사업 개요** — 비전, 미션, 핵심 가치
3. **제품/서비스** — MVP 핵심 기능, 기술 스택, 차별화 포인트
4. **시장 분석** — 니치 시장 규모, ICP, 커뮤니티 검증 (기존 조사 결과 통합)
5. **경쟁 분석** — 가격-기능 매트릭스, 1인 운영 가능성 (기존 분석 결과 통합)
6. **성장 전략** — 부트스트랩 마케팅, SEO/커뮤니티, 가격 전략 (bootstrap-growth-template 참조)
7. **운영 모델** — 자동화 스택, 주간 루틴, 확장 트리거 (operations-plan 참조)
8. **재무 계획** — MRR 모델, Unit Economics, BEP, 시나리오 (micro-saas-financial-template 참조)

> 기존 11챕터에서 "팀 구성", "리스크 분석", "실행 로드맵"을 운영 모델과 재무 계획에 통합하여 8챕터로 간소화

## 다음 단계
* 사업계획서 완료 → `/export-documents`로 HTML/PDF 변환하여 공유
* 산출물 전체 목록 확인 → `/my-outputs`
* 산출물 보안 점검 → `/security-scan` (선택적 보조 워크플로우)
* 변경 이력 관리 → `/version-history` (선택적 보조 워크플로우)
* 전체 진행률 확인 → `/check-progress`
