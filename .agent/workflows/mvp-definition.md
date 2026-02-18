# mvp-definition

MVP(최소 기능 제품) 범위를 정의하고 출시 기준을 수립합니다.

> 이 워크플로우는 tech-stack-recommender 스킬과 연동하여 기술 스택을 참조합니다.
> 8단계 사업 기획 프로세스 완료 후 선택적으로 실행하는 보조 워크플로우입니다.

## 트리거 조건
* /idea-validation 또는 /lean-canvas 결과가 존재할 때 실행 권장
* output/ideas/{id}-{name}/ 폴더 내 hypothesis.md 또는 evaluation.md 참조

## 수행 작업
* 사업 아이디어의 핵심 기능을 Must-have / Nice-to-have / Out-of-scope로 분류합니다
* 기능 우선순위 매트릭스 (Impact vs Effort)를 작성합니다
* 출시 기준(Launch Criteria) 체크리스트를 정의합니다
* MVP 타임라인을 주 단위로 설계합니다
* 기술적 의존성 맵을 작성합니다
* MVP 예상 비용을 추정합니다

## 출력 형식
* 기능 분류표 (Must/Nice/Out) — 마크다운 표
* Impact-Effort 매트릭스 — 마크다운 표 (Impact: High/Medium/Low × Effort: High/Medium/Low)
* 출시 기준 체크리스트 — 체크박스 형식
* MVP 타임라인 — 주 단위 표
* output/ideas/{id}-{name}/mvp-definition.md에 저장합니다

### 데이터 신뢰도 등급
모든 추정치에 신뢰도 등급을 표기합니다:
| 등급 | 의미 | 예시 |
|------|------|------|
| A | 검증됨 — 실제 데이터 기반 | 고객 인터뷰, 실측 데이터 |
| B | 근거 있는 추정 — AI + 외부 데이터 | 벤치마크, 업계 평균 |
| C | AI 추정 — 참고용 | AI가 생성한 초기 추정치 |

> ⚠️ "이 분석의 수치는 AI 추정(신뢰도 C)이며, 실제 검증이 필요합니다."

## Micro-SaaS MVP (v2.0 Phase 7)

idea.json의 business_scale이 "micro" 또는 "small"인 경우, Micro-SaaS 전용 MVP 정의를 수행합니다.

### 트리거 조건
* output/ideas/{id}-{name}/idea.json의 business_scale 값이 "micro" 또는 "small"일 때 자동 활성화

### 핵심 차이점

| 항목 | 기존 (startup/enterprise) | Micro-SaaS (micro/small) |
|------|-------------------------|------------------------|
| 기능 범위 | 10+ 기능 | 1-3개 핵심 기능 |
| 개발 기간 | 2-6개월 | 1-2주 ("1주 MVP" 원칙) |
| 출시 형태 | 베타 → 정식 | 랜딩 페이지 + 핵심 기능 1개 |
| 검증 방법 | 사용자 테스트, QA | Waitlist/Pre-order 검증 |
| 기술 스택 | 팀 기반 선정 | 1인 운영 가능한 도구 |

### Micro-SaaS MVP 체크리스트
- [ ] 핵심 문제 1개가 명확히 정의됨
- [ ] 해결 방법이 1줄로 설명 가능
- [ ] 1-2주 내 만들 수 있는 범위
- [ ] 랜딩 페이지로 수요 검증 가능
- [ ] 월 $29-99 가격대에 지불 의향 확인

### Waitlist/Pre-order 검증
* 랜딩 페이지 제작 도구: Carrd, Framer, Notion
* 이메일 수집: Buttondown, ConvertKit (무료 티어)
* 결제 사전 검증: Gumroad, Stripe Payment Links
* 목표: 100명 대기자 또는 10건 사전 주문

## 다음 단계
* MVP 정의 완료 후 → `/gtm-launch`로 출시 전략 수립
* MVP 비용 산출 필요 시 → `/financial-modeling`으로 재무 모델링
* 전체 진행률 확인 → `/check-progress`
