# deploy-guide

1인 빌더를 위한 첫 배포부터 운영까지 안내하는 배포 가이드입니다.

> 이 워크플로우는 MVP를 실제 서비스로 배포하고, CI/CD 파이프라인과 비용 관리까지 한 번에 설정합니다.
> /ai-builder 또는 /mvp-definition 완료 후 선택적으로 실행하는 보조 워크플로우입니다.

## 트리거 조건
* /ai-builder 또는 /mvp-definition 결과가 존재할 때 실행 권장
* output/ideas/{id}-{name}/ 폴더 내 mvp-definition.md 또는 ai-builder.md 참조

## 용어 매핑 (영어 → 한국어)

| 영어 | 한국어 | 설명 |
|------|--------|------|
| PaaS | 서비스형 플랫폼 | 인프라 관리 없이 앱 배포 가능한 클라우드 서비스 |
| CI/CD | 지속적 통합/배포 | 코드 변경 시 자동 빌드·테스트·배포 파이프라인 |
| Cold Start | 콜드 스타트 | 서버리스 함수가 비활성 후 첫 요청 시 지연 발생 |
| Edge Function | 엣지 함수 | 사용자와 가까운 서버에서 실행되는 경량 함수 |
| Serverless | 서버리스 | 서버 관리 없이 함수 단위로 실행되는 컴퓨팅 모델 |
| Container | 컨테이너 | 앱과 의존성을 패키징한 격리된 실행 환경 |
| Blue-Green Deploy | 블루-그린 배포 | 구버전(블루)과 신버전(그린)을 병렬 운영 후 전환 |
| Rollback | 롤백 | 배포 실패 시 이전 안정 버전으로 되돌리기 |
| Environment Variable | 환경 변수 | API 키, DB 연결 등 코드 외부에 저장하는 설정값 |
| CDN | 콘텐츠 전송 네트워크 | 전 세계 엣지 서버에 정적 파일을 캐싱하여 빠르게 전달 |
| SSL/TLS | 보안 소켓 계층 | HTTPS를 위한 암호화 프로토콜 |
| Uptime | 가동률 | 서비스가 정상 동작하는 시간의 비율 (99.9% = 월 43분 다운) |

## PaaS 선택 의사결정 트리

아래 흐름을 따라 프로젝트에 맞는 PaaS를 선택하세요:

```
[앱 유형은?]
├── 정적 사이트 (HTML/CSS/JS, SSG)
│   ├── 글로벌 트래픽 필요? → Yes → Vercel / Netlify (Edge CDN)
│   └── 국내 트래픽 위주? → Netlify / Vercel (무료 티어 충분)
│
└── 동적 앱 (SSR, API, WebSocket)
    ├── DB 필요?
    │   ├── Yes
    │   │   ├── 예산 $0 (무료만)?
    │   │   │   ├── Railway (무료 $5 크레딧/월) — 소규모 사이드 프로젝트
    │   │   │   └── Render (무료 PostgreSQL 90일) — 프로토타입
    │   │   ├── 예산 $5-20/월?
    │   │   │   ├── 아시아 리전 필요? → Fly.io (Tokyo 리전)
    │   │   │   └── 리전 무관? → Railway ($5 Hobby) / Render ($7 Starter)
    │   │   └── 예산 $20+/월?
    │   │       └── Fly.io (다중 리전) / Railway (Pro)
    │   └── No (외부 DB 사용 — Supabase, PlanetScale 등)
    │       ├── Next.js/Nuxt? → Vercel (최적화됨) / Netlify
    │       └── 커스텀 서버? → Railway / Fly.io / Render
```

## PaaS 비교표

| 항목 | Vercel | Railway | Fly.io | Render | Netlify |
|------|--------|---------|--------|--------|---------|
| **무료 티어** | 100GB 대역폭, 100시간 Edge | $5 크레딧/월 | 3 shared-cpu VMs | 750시간/월 (웹), 무료 정적 | 100GB 대역폭, 300분 빌드 |
| **유료 시작가** | $20/월 (Pro) | $5/월 (Hobby) | ~$3/월 (shared-1x) | $7/월 (Starter) | $19/월 (Pro) |
| **콜드 스타트** | ~250ms (Serverless) | 없음 (Always-on) | 없음 (Machine keep-alive) | ~30s (무료 Spin-down) | ~200ms (Serverless) |
| **리전** | 글로벌 Edge | US-West (기본) | 35+ 리전 (Tokyo 포함) | Oregon/Frankfurt | 글로벌 Edge |
| **DB 지원** | Postgres (Neon), KV, Blob | PostgreSQL, MySQL, Redis | Postgres (Fly Postgres) | PostgreSQL, Redis | 없음 (외부 연동) |
| **커스텀 도메인** | 무료 (자동 SSL) | 무료 (자동 SSL) | 무료 (자동 SSL) | 무료 (자동 SSL) | 무료 (자동 SSL) |
| **추천 유형** | Next.js/프론트엔드, 정적 사이트 | 풀스택, 백엔드 API, 사이드 프로젝트 | 글로벌 배포, 컨테이너 앱 | 풀스택, 장기 실행 서비스 | 정적 사이트, Jamstack |

> ⚠️ 클라우드 서비스의 요금 정책은 수시로 변경됩니다. 배포 전 반드시 각 서비스의 최신 가격 페이지를 확인하세요.

## GitHub Actions CI/CD 레시피

아래는 빌드 → 테스트 → SCA 스캔 → 배포까지 자동화하는 GitHub Actions YAML 예시입니다:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  NODE_VERSION: '20'

jobs:
  # 1단계: 빌드 & 테스트
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint

      - name: Type check
        run: npm run type-check

      - name: Run tests
        run: npm run test -- --coverage

      - name: Upload coverage
        uses: actions/upload-artifact@v4
        with:
          name: coverage
          path: coverage/

  # 2단계: 보안 스캔 (SCA - Software Composition Analysis)
  security-scan:
    runs-on: ubuntu-latest
    needs: build-and-test
    steps:
      - uses: actions/checkout@v4

      - name: Run npm audit
        run: npm audit --audit-level=high

      - name: Run Snyk security scan
        uses: snyk/actions/node@master
        continue-on-error: true  # 첫 설정 시 warning만
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}

  # 3단계: 배포 (Vercel 예시)
  deploy:
    runs-on: ubuntu-latest
    needs: [build-and-test, security-scan]
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    steps:
      - uses: actions/checkout@v4

      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
```

### PaaS별 배포 스텝 변형

**Railway:**
```yaml
      - name: Deploy to Railway
        uses: bervProject/railway-deploy@main
        with:
          railway_token: ${{ secrets.RAILWAY_TOKEN }}
          service: ${{ secrets.RAILWAY_SERVICE_ID }}
```

**Fly.io:**
```yaml
      - name: Deploy to Fly.io
        uses: superfly/flyctl-actions/setup-flyctl@master
      - run: flyctl deploy --remote-only
        env:
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}
```

## 비용 가드레일

예상치 못한 요금 폭탄을 방지하기 위한 알림 설정법입니다.

### Railway ($5 소프트캡)
* Settings → Usage → **Usage Limit** 설정
* Hobby 플랜: 기본 $5/월 크레딧 (초과 시 서비스 중단)
* Pro 플랜: **Spending Limit** 설정 가능 → $20, $50 등 상한 지정
* 알림: Settings → Notifications → Email 알림 활성화

### Vercel
* Settings → Billing → **Spend Management** 활성화
* Budget Alert: $5 / $20 / $50 단위로 이메일 알림 설정
* **Spend Cap**: 활성화 시 예산 초과 시 서비스 일시 중단 (DDoS 방어)
* Hobby → Pro 전환 시점: 월 100GB 대역폭 초과 또는 팀 협업 필요 시

### Fly.io
* `fly orgs billing` 명령으로 현재 사용량 확인
* Dashboard → Billing → **Spending Limit** 설정
* 월 $5 / $20 / $50 알림: 이메일 기반 Billing Alert 설정
* 추가 팁: `fly scale count 0` 으로 비활동 시 머신 종료

### 공통 권장 사항
- [ ] 모든 PaaS에 비용 알림 이메일 설정
- [ ] 월 1회 비용 리뷰 캘린더 등록
- [ ] 미사용 프로젝트/서비스 분기별 정리

## 롤백 가이드

배포 후 문제 발생 시 신속하게 이전 버전으로 복구하는 방법입니다.

### 방법 1: Git Revert + 재배포
```bash
# 문제 커밋 확인
git log --oneline -5

# 문제 커밋 되돌리기 (새 커밋 생성, 히스토리 보존)
git revert <commit-hash>

# main에 푸시 → CI/CD 자동 재배포
git push origin main
```

### 방법 2: Vercel Instant Rollback
* Vercel Dashboard → Deployments → 이전 배포 선택 → **"Promote to Production"** 클릭
* 수 초 내 이전 버전으로 전환 (DNS 변경 없이 라우팅만 전환)
* CLI: `vercel rollback` (가장 최근 성공 배포로 복원)

### 방법 3: PaaS별 롤백
| PaaS | 롤백 방법 | 소요 시간 |
|------|----------|----------|
| Vercel | Dashboard → Promote to Production | ~5초 |
| Railway | Dashboard → Deployments → Rollback | ~30초 |
| Fly.io | `fly releases` → `fly deploy --image <이전 이미지>` | ~1분 |
| Render | Dashboard → Manual Deploy → 이전 커밋 선택 | ~2분 |

### 롤백 체크리스트
- [ ] 롤백 후 핵심 기능 동작 확인 (로그인, 결제, API)
- [ ] DB 마이그레이션이 있었다면 down migration 필요 여부 확인
- [ ] 사용자 공지 여부 결정 (상태 페이지 업데이트)
- [ ] 근본 원인 분석(RCA) 후 수정 커밋 준비

## 도메인 + SSL 설정 체크리스트

### 도메인 구매 & DNS 설정
- [ ] 도메인 등록 (Namecheap, Cloudflare, Google Domains)
- [ ] 네임서버(NS) 설정: PaaS 제공 NS 또는 Cloudflare NS로 변경
- [ ] A 레코드 또는 CNAME 레코드 설정 (PaaS 대시보드에서 값 확인)
- [ ] www → apex 리다이렉트 설정 (또는 반대)
- [ ] DNS 전파 확인 (보통 5분~48시간, `dig` 또는 whatsmydns.net으로 확인)

### SSL/TLS 인증서
- [ ] PaaS 자동 SSL 활성화 확인 (Vercel/Railway/Fly.io/Render 모두 Let's Encrypt 자동)
- [ ] HTTPS 강제 리다이렉트 활성화 (HTTP → HTTPS)
- [ ] Mixed Content 경고 없는지 확인 (브라우저 개발자 도구 → Console)
- [ ] HSTS 헤더 설정 검토 (`Strict-Transport-Security`)

### 검증
- [ ] `https://yourdomain.com` 정상 접속 확인
- [ ] SSL Labs 테스트 통과 (A 등급 이상)
- [ ] 모바일에서 접속 테스트
- [ ] 서브도메인 필요 시 추가 설정 (api.yourdomain.com 등)

## 수행 작업

아래 5단계를 순서대로 진행합니다:

1. **PaaS 선택**: 의사결정 트리와 비교표를 기반으로 프로젝트에 최적인 PaaS를 선택합니다
2. **첫 배포 실행**: 선택한 PaaS에 프로젝트를 연결하고 첫 배포를 완료합니다
3. **CI/CD 파이프라인 구성**: GitHub Actions 레시피를 프로젝트에 맞게 설정합니다
4. **도메인 + SSL 설정**: 커스텀 도메인을 연결하고 HTTPS를 활성화합니다
5. **비용 가드레일 설정**: 예산 알림과 지출 한도를 설정합니다

## 프로세스 흐름

```
/mvp-definition 또는 /ai-builder
    ↓
[1] PaaS 선택 (의사결정 트리)
    ↓
[2] 첫 배포 (5분 가이드)
    ↓
[3] CI/CD 파이프라인
    ↓
[4] 도메인 + SSL
    ↓
[5] 비용 가드레일
    ↓
→ /growth-loop (성장 루프) 또는 /tco-dashboard (비용 추적)
```

## 출력 규칙
* output/reports/deploy-guide.md에 저장합니다
* 선택한 PaaS, CI/CD 설정, 도메인 설정 결과를 포함합니다

### 데이터 신뢰도 등급
모든 비용/성능 수치에 신뢰도 등급을 표기합니다:
| 등급 | 의미 | 예시 |
|------|------|------|
| A | 검증됨 — 공식 문서 기반 | 각 PaaS 가격 페이지 직접 확인 |
| B | 근거 있는 추정 — 커뮤니티 데이터 | 벤치마크, 사용자 후기 |
| C | AI 추정 — 참고용 | AI가 생성한 초기 추정치 |

> ⚠️ "이 가이드의 가격 및 성능 수치는 AI 추정(신뢰도 B-C)이며, 배포 전 반드시 각 서비스의 최신 가격 페이지를 확인하세요."

## Micro-SaaS 배포 (v2.0 Phase 7)

idea.json의 business_scale이 "micro" 또는 "small"인 경우, 1인 빌더 최적화 배포 전략을 수행합니다.

### 트리거 조건
* `output/ideas/{id}-{name}/idea.json`의 `business_scale` 값이 `"micro"` 또는 `"small"`일 때 자동 활성화

### Vercel Hobby → Pro 전환 타이밍
| 지표 | Hobby 한도 | Pro 전환 시점 | Pro 가격 |
|------|-----------|-------------|---------|
| 대역폭 | 100GB/월 | 월 80GB 이상 사용 시 | $20/월 |
| 빌드 시간 | 6,000분/월 | CI가 자주 타임아웃 시 | $20/월 |
| Serverless 실행 | 100시간/월 | API 호출 증가 시 | $20/월 |
| 팀 멤버 | 1명 | 협업 필요 시 | $20/월/멤버 |

### Railway $5 소프트캡 운영법
* Hobby 플랜은 월 $5 크레딧 제공 (초과 시 서비스 중지)
* **최적화 팁**:
  - 불필요한 서비스 정리 (`railway service list`)
  - Sleep 모드 활용 (비활동 시 자동 중단)
  - DB는 Supabase/Neon 외부 무료 티어 활용으로 Railway 크레딧 절약
* Pro 전환 시점: $5로 부족하거나 SLA가 필요할 때 ($20/월)

### 첫 배포 5분 가이드

**Vercel (Next.js 기준):**
```bash
# 1. Vercel CLI 설치 (30초)
npm i -g vercel

# 2. 프로젝트 연결 & 배포 (2분)
vercel

# 3. 프로덕션 배포 (1분)
vercel --prod

# 4. 커스텀 도메인 연결 (1분)
vercel domains add yourdomain.com

# 완료! https://yourdomain.com 에서 확인
```

**Railway (Node.js 기준):**
```bash
# 1. Railway CLI 설치 (30초)
npm i -g @railway/cli

# 2. 로그인 & 프로젝트 생성 (1분)
railway login
railway init

# 3. 배포 (2분)
railway up

# 4. 도메인 설정 (1분)
railway domain

# 완료! Railway가 제공한 URL에서 확인
```

**Fly.io (Docker 기준):**
```bash
# 1. flyctl 설치 (30초)
curl -L https://fly.io/install.sh | sh

# 2. 로그인 & 앱 생성 (1분)
fly auth login
fly launch

# 3. 배포 (2분)
fly deploy

# 4. 도메인 설정 (1분)
fly certs create yourdomain.com

# 완료! https://yourdomain.com 에서 확인
```

## 다음 단계
* 배포 완료 후 → `/growth-loop`로 사용자 획득 루프 설계
* 운영 비용 추적 → `/tco-dashboard`로 TCO 모니터링
* 전체 진행률 확인 → `/check-progress`
