# gtm-launch

Go-to-Market(GTM) 런칭 전략을 수립합니다.

> 이 워크플로우는 launch-strategy 스킬의 분석 결과를 한국어로 요약하고 8단계 프로세스에 연계합니다.
> 8단계 사업 기획 프로세스 완료 후 선택적으로 실행하는 보조 워크플로우입니다.

## 용어 매핑 (영어 → 한국어)

| 영어 | 한국어 | 설명 |
|------|--------|------|
| ORB Framework | 채널 전략 프레임워크 | Owned/Rented/Borrowed 채널 분류 |
| Owned Channels | 소유 채널 | 직접 통제 가능 (이메일, 블로그, 커뮤니티) |
| Rented Channels | 임대 채널 | 플랫폼 의존 (SNS, 앱스토어) |
| Borrowed Channels | 차용 채널 | 타인 청중 활용 (게스트 포스팅, 인플루언서) |
| GTM | 시장 진입 전략 | Go-to-Market |
| Product Hunt | 프로덕트 헌트 | 제품 런칭 플랫폼 |
| Traction | 초기 견인 | 초기 사용자 확보 |

## 트리거 조건
* /mvp-definition 또는 /market-research 결과가 존재할 때 실행 권장
* output/research/ 또는 output/ideas/{id}-{name}/ 내 산출물 참조

## 수행 작업
* 타겟 고객 세그먼트별 진입 전략을 수립합니다
* 채널 전략을 ORB Framework 기반으로 설계합니다
  - 소유 채널(Owned): 이메일, 블로그, 자체 커뮤니티
  - 임대 채널(Rented): SNS, 앱스토어, 마켓플레이스
  - 차용 채널(Borrowed): 게스트 콘텐츠, 인플루언서, 제휴
* 런칭 타임라인을 5단계로 설계합니다 (Internal → Alpha → Beta → Early Access → Full Launch)
* 초기 견인(Traction) 목표를 설정합니다 (1/3/6개월)
* 런칭 체크리스트를 작성합니다

## 출력 형식
* 채널별 전략 표 — 마크다운 표 (채널명 / 유형(O/R/B) / 전략 / 우선순위 / 예상 비용)
* 5단계 런칭 타임라인 표 — 마크다운 표 (단계 / 기간 / 목표 / 핵심 활동 / 성공 기준)
* 런칭 체크리스트 — 체크박스 형식 (Pre-launch / Launch Day / Post-launch)
* output/reports/gtm-launch.md에 저장합니다

### 데이터 신뢰도 등급
(동일 패턴: A 검증됨, B 근거있는 추정, C AI 추정)
> ⚠️ "이 분석의 수치는 AI 추정(신뢰도 C)이며, 실제 검증이 필요합니다."

## Product Hunt 런칭 전략

### 준비 사항 (launch-strategy 스킬 참조)
* 런칭 전: 영향력 있는 지지자와 관계 구축, 리스팅 최적화 (태그라인, 비주얼, 데모 영상)
* 런칭 당일: 전일 이벤트로 진행, 모든 댓글에 실시간 응답, 기존 오디언스 참여 유도
* 런칭 후: 참여자 후속 연락, 트래픽을 소유 채널로 전환 (이메일 등록)

## Micro-SaaS GTM (v2.0 Phase 7)

idea.json의 business_scale이 "micro" 또는 "small"인 경우, 1인 운영 가능한 GTM 전략을 수행합니다.

### 트리거 조건
* output/ideas/{id}-{name}/idea.json의 business_scale 값이 "micro" 또는 "small"일 때 자동 활성화

### 핵심 차이점

| 항목 | 기존 (startup/enterprise) | Micro-SaaS (micro/small) |
|------|-------------------------|------------------------|
| 채널 수 | 5-10개 동시 운영 | 1-2개 집중 |
| 마케팅 예산 | 월 100만원+ | 월 0-10만원 |
| 핵심 전략 | 유료 광고 + PR | SEO + 커뮤니티 + Building in Public |
| Product Hunt | 팀 단위 준비 | 1인 준비 가능한 범위 |
| 초기 목표 | DAU 1,000+ | 유료 고객 10명 |

### 1인 GTM 채널 전략
| 채널 | 비용 | 효과 (1인 기준) | 우선순위 |
|------|------|----------------|---------|
| SEO/블로그 | 무료 | 장기적 높음 | ⭐⭐⭐ |
| 커뮤니티 (Reddit, IndieHackers) | 무료 | 즉각적 중간 | ⭐⭐⭐ |
| Building in Public (Twitter/X) | 무료 | 중간 | ⭐⭐ |
| Product Hunt | 무료 | 일시적 높음 | ⭐⭐ |
| 유료 광고 | 높음 | CAC 민감 | ⭐ |

### Building in Public 가이드
* 매주 진행 상황 공유 (MRR, 사용자 수, 배운 점)
* 실패도 공유 — 진정성이 관심을 유발
* Twitter/X, IndieHackers, Reddit r/SaaS 활용
* 해시태그: #buildinpublic #indiehackers #microsaas

## 다음 단계
* 런칭 전략 수립 후 → `/kpi-framework`로 성과 지표 설정
* 브랜딩 연계 필요 시 → `/branding-strategy`로 브랜드 전략
* 전체 진행률 확인 → `/check-progress`
