# kpi-framework

KPI 체계를 수립하고 성과 추적 기준을 설정합니다.

> 이 워크플로우는 startup-metrics-framework 스킬의 지표 체계를 한국어로 요약하고 8단계 프로세스에 연계합니다.
> 8단계 사업 기획 프로세스 완료 후 선택적으로 실행하는 보조 워크플로우입니다.

## 용어 매핑 (영어 → 한국어)

| 영어 | 한국어 | 설명 |
|------|--------|------|
| KPI | 핵심 성과 지표 | Key Performance Indicator |
| North Star Metric | 북극성 지표 | 사업 핵심 가치를 대표하는 단일 지표 |
| MRR | 월간 반복 매출 | Monthly Recurring Revenue |
| ARR | 연간 반복 매출 | Annual Recurring Revenue |
| Churn Rate | 이탈률 | 월간 구독 취소 비율 |
| LTV | 고객 생애 가치 | Lifetime Value |
| CAC | 고객 획득 비용 | Customer Acquisition Cost |
| ARPU | 사용자당 평균 매출 | Average Revenue Per User |
| NDR | 순수익 유지율 | Net Dollar Retention |
| Unit Economics | 단위 경제학 | 고객 1명당 수익성 |
| Cohort | 코호트 | 동일 시기 가입 고객 그룹 |

## 트리거 조건
* /financial-modeling 또는 /gtm-launch 결과가 존재할 때 실행 권장
* output/financials/ 또는 output/reports/ 내 산출물 참조

## 수행 작업
* 사업 단계별 핵심 지표를 정의합니다 (Pre-launch / Launch / Growth / Scale)
* North Star Metric(북극성 지표)을 설정합니다
* KPI 대시보드 구조를 설계합니다
* 지표별 목표값, 측정 주기, 측정 도구를 정합니다
* 지표 간 인과관계 맵을 작성합니다
* 벤치마크 대비 현재 위치를 평가합니다

## 출력 형식
* 사업 단계별 KPI 표 — 마크다운 표 (단계 / 핵심 지표 / 목표값 / 측정 주기 / 도구)
* North Star Metric + 보조 지표 구조 — 트리 형태
* 인과관계 맵 — 마크다운 목록 (A → B → C 형태)
* output/reports/kpi-framework.md에 저장합니다

### 데이터 신뢰도 등급
(A 검증됨, B 근거있는 추정, C AI 추정)
> ⚠️ "목표값은 AI 추정(신뢰도 C)이며, 실제 운영 데이터로 보정이 필요합니다."

## 사업 단계별 KPI 체계

### Pre-launch 단계
| 지표 | 목표 예시 | 측정 도구 |
|------|----------|----------|
| 대기자 수 (Waitlist) | 100-500명 | Carrd, ConvertKit |
| 랜딩 페이지 전환율 | 5-15% | Google Analytics |
| 고객 인터뷰 수 | 20건+ | Notion, Google Docs |

### Launch 단계
| 지표 | 목표 예시 | 측정 도구 |
|------|----------|----------|
| 가입자 수 | 100명 (1개월) | 자체 대시보드 |
| 활성 사용자 (DAU/WAU) | 30%+ 가입 대비 | Plausible, Mixpanel |
| 첫 결제 전환율 | 5-10% | Stripe Dashboard |

### Growth 단계
| 지표 | 목표 예시 | 측정 도구 |
|------|----------|----------|
| MRR 성장률 | 15-20%/월 | Stripe, Baremetrics |
| Churn Rate | 5% 이하 | 자체 집계 |
| LTV/CAC | 3배 이상 | 계산 |

### Scale 단계
| 지표 | 목표 예시 | 측정 도구 |
|------|----------|----------|
| ARR | $100K+ | Stripe |
| NDR | 110%+ | 코호트 분석 |
| Rule of 40 | 40% 이상 | 성장률 + 이익률 |

## North Star Metric 설정 가이드

### 유형별 추천 NSM
| 사업 유형 | 추천 NSM | 이유 |
|----------|---------|------|
| SaaS (B2B) | 주간 활성 팀 수 | 팀 단위 가치 반영 |
| SaaS (B2C) | 주간 활성 사용자 | 개인 가치 반영 |
| 마켓플레이스 | 주간 거래 완료 수 | 양면 가치 반영 |
| 콘텐츠 | 주간 콘텐츠 소비 시간 | 참여도 반영 |
| 커머스 | 월간 반복 구매 고객 수 | 충성도 반영 |

## Micro-SaaS KPI (v2.0 Phase 7)

idea.json의 business_scale이 "micro" 또는 "small"인 경우, SaaS 핵심 5대 지표에 집중합니다.

### 트리거 조건
* output/ideas/{id}-{name}/idea.json의 business_scale 값이 "micro" 또는 "small"일 때 자동 활성화

### SaaS 핵심 5대 지표 (startup-metrics-framework 스킬 연동)

| 지표 | 정의 | 건강 기준 | 위험 신호 |
|------|------|----------|----------|
| MRR | 월간 반복 매출 | 매월 10-20% 성장 | 3개월 연속 정체 |
| Churn Rate | 월간 이탈률 | 5% 이하 | 10% 이상 |
| LTV | 고객 생애 가치 | ARPU / Churn | LTV < 3×CAC |
| CAC | 고객 획득 비용 | 1개월 매출 이하 | LTV/CAC < 3 |
| ARPU | 사용자당 평균 매출 | 가격 티어 가중 평균 | 하락 추세 |

### 간단한 측정 도구 (1인 운영)
| 도구 | 비용 | 용도 |
|------|------|------|
| Plausible | $9/월 | 웹 트래픽 분석 |
| Stripe Dashboard | 무료 | 매출, MRR, Churn |
| Simple Analytics | $9/월 | 프라이버시 친화 분석 |
| Google Sheets | 무료 | 커스텀 대시보드 |
| Notion | 무료 | KPI 추적 템플릿 |

### Unit Economics 계산
```
LTV = ARPU × (1 / Churn Rate)
CAC = 총 마케팅비 / 신규 고객 수
LTV/CAC > 3 → 건강한 비즈니스
CAC 회수 기간 = CAC / ARPU → 3개월 이내 권장
```

## 다음 단계
* KPI 체계 수립 후 → `/financial-modeling`로 재무 지표 연계
* 전체 진행률 확인 → `/check-progress`
* 운영 비용 추적 필요 시 → `/tco-dashboard`로 TCO 분석
