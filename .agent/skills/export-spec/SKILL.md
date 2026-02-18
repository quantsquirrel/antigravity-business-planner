---
name: export-spec
description: MVP 스펙을 AI 코딩 도구(.cursorrules, ai-instructions.md)로 변환합니다.
---

# export-spec

MVP 스펙을 AI 코딩 도구용 포맷으로 자동 변환하여, Cursor / Bolt / v0 등에서 바로 사용할 수 있는 프로젝트 설정 파일을 생성합니다.

## 활성화 조건

* /mvp-definition 워크플로우 실행 완료 후 자동 연동
* /ai-builder 워크플로우 실행 시 자동 연동
* 사용자가 "스펙 내보내기" 또는 "export spec" 요청 시 수동 활성화

## 수행 작업

### Lean Canvas → 시스템 프롬프트 변환 로직

Lean Canvas의 각 필드를 AI 코딩 도구가 이해할 수 있는 기술 명세로 변환합니다:

| Lean Canvas 필드 | 변환 대상 | 변환 예시 |
|-----------------|----------|----------|
| 문제 (Problem) | 해결해야 할 핵심 기능 | "사용자가 X를 할 수 없다" → CRUD API + UI |
| 고객 세그먼트 (Customer) | 타겟 사용자 페르소나 | "프리랜서 개발자" → 간결한 UI, CLI 지원 |
| 고유 가치 제안 (UVP) | 앱 핵심 UX 원칙 | "10분 안에 완료" → 최소 클릭, 자동 저장 |
| 솔루션 (Solution) | MVP 기능 목록 | 기능별 API 엔드포인트 매핑 |
| 수익원 (Revenue) | 결제 모델 설계 | "월 구독" → Stripe Subscription API |
| 채널 (Channels) | SEO/마케팅 기술 요구사항 | "검색 유입" → SSR, 메타태그, 사이트맵 |
| 비용 구조 (Cost) | 인프라 예산 제약 | "월 $50 이하" → Serverless 아키텍처 |

### .cursorrules 생성 템플릿

```
# Project: {프로젝트명}

## Description
{Lean Canvas 고유 가치 제안 요약}

## Tech Stack
{tech-stack-recommender 결과 기반}
- Frontend: {프론트엔드 프레임워크}
- Backend: {백엔드 프레임워크}
- Database: {데이터베이스}
- Deployment: {배포 플랫폼}

## Coding Rules
- TypeScript strict mode 필수
- ESLint + Prettier 적용
- 컴포넌트: 함수형 컴포넌트 + hooks 패턴
- API: RESTful 또는 tRPC (프로젝트 규모에 따라)
- 테스트: 핵심 비즈니스 로직 단위 테스트 필수
- {추가 규칙: tech-stack-recommender 결과에 따라 동적 삽입}

## Data Schema
{MVP 데이터 모델}
- 주요 엔티티 및 관계
- 필수 필드와 타입 명시
- 인덱스 전략

## API Endpoints
{솔루션 필드 기반 자동 생성}
- CRUD 엔드포인트 목록
- 인증 필요 여부
- Rate limiting 정책

## UI Guidelines
{고객 페르소나 기반}
- 디자인 시스템: {Tailwind CSS / shadcn/ui 등}
- 반응형 기준: Mobile-first
- 접근성: WCAG 2.1 AA 준수
- {페르소나 특화 UX 지침}

## Security
- OWASP Top 10 준수 (아래 체크리스트 참조)
- 인증: {JWT / Session 기반}
- 환경변수로 시크릿 관리 (.env.local)
- HTTPS 필수

## File Structure
{프로젝트 디렉토리 구조 가이드}
```

### ai-instructions.md 생성 템플릿 (Bolt/v0용)

자연어 기반 지시서로, AI 코딩 도구가 프로젝트를 처음부터 생성할 수 있도록 안내합니다:

```markdown
# {프로젝트명} - AI Builder Instructions

## 프로젝트 개요
{Lean Canvas UVP를 자연어로 풀어쓴 설명}

## 타겟 사용자
{고객 세그먼트 기반 페르소나 설명}
- 주요 특성: {특성 나열}
- 핵심 니즈: {문제 필드 기반}
- 기대하는 경험: {UVP 기반}

## 핵심 기능 (우선순위순)
{솔루션 필드 → 기능 목록 변환}
1. {기능 1}: {설명} — 필수
2. {기능 2}: {설명} — 필수
3. {기능 3}: {설명} — 선택

## 기술 요구사항
- 프레임워크: {tech-stack-recommender 결과}
- 데이터베이스: {DB 선택}
- 인증: {인증 방식}
- 결제: {수익원 → 결제 연동 방식}

## 디자인 방향
- 스타일: {페르소나 기반 디자인 톤}
- 레이아웃: {주요 페이지 구성}
- 컬러: {브랜드 톤에 맞는 컬러 가이드}

## 데이터 모델
{엔티티-관계 자연어 설명}

## 페이지 구성
1. 랜딩 페이지: {UVP 강조, CTA}
2. 대시보드: {핵심 기능 접근}
3. 설정: {사용자 프로필, 결제}
4. {추가 페이지}

## 배포
- 플랫폼: {배포 대상}
- 환경변수: {필요한 환경변수 목록}
- CI/CD: GitHub Actions 기본 설정
```

### 보안 규칙 자동 삽입

모든 내보내기 파일에 OWASP Top 10 체크리스트를 자동 포함합니다:

| # | 취약점 | 적용 규칙 | 자동 삽입 위치 |
|---|--------|----------|--------------|
| A01 | Broken Access Control | 모든 API에 인증/인가 미들웨어 적용 | API Endpoints 섹션 |
| A02 | Cryptographic Failures | 비밀번호 bcrypt 해싱, TLS 필수 | Security 섹션 |
| A03 | Injection | Parameterized query 사용, ORM 필수 | Data Schema 섹션 |
| A04 | Insecure Design | 위협 모델링 기반 설계 검증 | UI Guidelines 섹션 |
| A05 | Security Misconfiguration | 프로덕션 기본값 하드닝 체크리스트 | Deployment 섹션 |
| A06 | Vulnerable Components | 의존성 감사 (npm audit / pip audit) | Coding Rules 섹션 |
| A07 | Auth Failures | Rate limiting, 계정 잠금, MFA 권장 | Security 섹션 |
| A08 | Data Integrity Failures | CI/CD 파이프라인 무결성 검증 | Deployment 섹션 |
| A09 | Logging Failures | 보안 이벤트 로깅, PII 마스킹 | Security 섹션 |
| A10 | SSRF | 외부 URL 화이트리스트, 내부망 차단 | API Endpoints 섹션 |

### 라이선스 스캔 규칙

의존성 패키지의 라이선스를 검사하여 법적 리스크를 사전에 방지합니다:

| 라이선스 | 등급 | 조치 |
|---------|------|------|
| MIT | 안전 | 자유 사용 가능 |
| Apache 2.0 | 안전 | 자유 사용 가능 (NOTICE 파일 유지) |
| BSD (2/3-Clause) | 안전 | 자유 사용 가능 |
| ISC | 안전 | 자유 사용 가능 |
| GPL v2/v3 | 경고 | 프로젝트 전체가 GPL 적용됨 — 상업적 SaaS 부적합 |
| AGPL v3 | 위험 | 네트워크 사용만으로 소스 공개 의무 — SaaS 사용 금지 |
| SSPL | 위험 | MongoDB 라이선스 — 클라우드 서비스 제공 시 전체 공개 |
| Unlicense / CC0 | 주의 | 법적 보호 불명확 — 확인 후 사용 |

자동 삽입 규칙:
* .cursorrules의 Coding Rules 섹션에 `npm audit` / `license-checker` 실행 명령 포함
* GPL/AGPL 의존성 감지 시 경고 메시지를 ai-instructions.md에 삽입
* 권장 대안 패키지 자동 제안 (예: MySQL GPL → PostgreSQL)

## 출력 형식

* `.cursorrules` 파일을 프로젝트 루트에 생성합니다
* `ai-instructions.md` 파일을 프로젝트 루트에 생성합니다
* output/reports/export-spec.md에 변환 결과 요약을 저장합니다
