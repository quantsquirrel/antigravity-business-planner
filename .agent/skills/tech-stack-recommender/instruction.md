# tech-stack-recommender

1인/소규모 빌더를 위한 기술 스택과 자동화 도구를 추천합니다.

## 활성화 조건
* business_scale이 "micro" 또는 "small"일 때 자동 활성화
* /operations-plan 워크플로우 실행 시 연동

## 수행 작업

### 사업 유형별 추천 스택

| 사업 유형 | 프론트엔드 | 백엔드 | DB | 결제 | 배포 |
|----------|----------|--------|-----|------|------|
| SaaS (웹앱) | Next.js / Remix | Supabase / Firebase | PostgreSQL | Stripe / Paddle | Vercel / Railway |
| API 서비스 | - | FastAPI / Hono | PostgreSQL | Stripe | Fly.io / Railway |
| 마켓플레이스 | Next.js | Supabase | PostgreSQL | Stripe Connect | Vercel |
| 콘텐츠/커뮤니티 | Ghost / WordPress | - | MySQL | Stripe | 자체 호스팅 |
| 모바일 앱 | React Native / Flutter | Supabase | PostgreSQL | App Store IAP | Expo / Firebase |

### 자동화 도구 스택

| 영역 | 추천 도구 | 무료 티어 | 유료 시작 | 역할 |
|------|----------|----------|----------|------|
| 결제 | Stripe / Paddle | 수수료만 | 수수료만 | 구독 관리 |
| 이메일 | Resend / Postmark | 100/일 | $20/월 | 트랜잭션 이메일 |
| 분석 | Plausible / Umami | 셀프호스팅 | $9/월 | 웹 분석 |
| 고객지원 | Crisp / Intercom | 제한적 | $25/월 | 라이브챗 |
| 모니터링 | Sentry / BetterStack | 5K 이벤트 | $26/월 | 에러 추적 |
| 자동화 | n8n / Make | 셀프호스팅 | $9/월 | 워크플로우 자동화 |
| CI/CD | GitHub Actions | 2,000분 | 포함 | 빌드/배포 |

### 비용 최적화 전략
* Phase 1 (0-100 고객): 모든 무료 티어 활용, 월 $10-50
* Phase 2 (100-1,000): 핵심 도구만 유료 전환, 월 $50-200
* Phase 3 (1,000+): 스케일 대응, 월 $200-500
* 스케일링 트리거: "이 지표에 도달하면 이 도구를 유료로 전환"

### "두 번째 사람" 고용 판단 기준
* 고객 지원 주 10시간+ → 파트타임 CS
* 기능 요청 백로그 3개월분+ → 파트타임 개발자
* MRR $5K+ 안정적 → 풀타임 고려 가능
* 본인 번아웃 시그널 → 즉시 외주/자동화 검토

## 출력 형식
* 추천 스택을 표 형태로 정리합니다
* 월 예상 비용을 단계별로 산출합니다
* output/reports/tech-stack.md에 저장합니다
