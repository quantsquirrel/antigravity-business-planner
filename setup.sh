#!/bin/bash
# ============================================================
# Antigravity 사업 기획 도구 — 원클릭 세팅 스크립트
# ============================================================
# 이 스크립트는 Google Antigravity에서 사업 기획을 위한
# 모든 규칙, 워크플로우, 스킬, 템플릿을 자동으로 설정합니다.
#
# 사용법:
#   chmod +x setup.sh
#   ./setup.sh
#
# 요구사항:
#   - macOS
#   - Python 3.8+
#   - Google Antigravity (antigravity.google)
# ============================================================

# set -e 대신 경고 추적 방식 사용 (비개발자에게 친화적인 오류 처리)
WARNINGS=0
warn() {
    WARNINGS=$((WARNINGS + 1))
    echo -e "  ${YELLOW}⚠${NC} $1"
    echo -e "    💡 $2"
}

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Project root (where this script is located)
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo -e "${BOLD}============================================================${NC}"
echo -e "${BOLD}  Antigravity 사업 기획 도구 — 자동 세팅${NC}"
echo -e "${BOLD}============================================================${NC}"
echo ""

# --- Step 1: Check prerequisites ---
echo -e "${BLUE}[1/10]${NC} 사전 요구사항 확인 중..."

# Check Python 3
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1)
    echo -e "  ${GREEN}✓${NC} $PYTHON_VERSION 설치됨"
else
    echo -e "  ${RED}✗${NC} Python 3이 설치되어 있지 않습니다."
    echo "    설치: brew install python3"
    exit 1
fi

# Check Git
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version 2>&1)
    echo -e "  ${GREEN}✓${NC} $GIT_VERSION 설치됨"
else
    echo -e "  ${YELLOW}!${NC} Git이 설치되어 있지 않습니다."
    echo "    설치: brew install git"
    echo "    (Git 없이도 사용 가능하지만, 버전 관리를 위해 설치를 권장합니다)"
fi

# Check if Antigravity might be installed (just informational)
if [ -d "$HOME/.gemini/antigravity" ]; then
    echo -e "  ${GREEN}✓${NC} Antigravity 설정 디렉토리 발견"
else
    echo -e "  ${YELLOW}!${NC} Antigravity 설정 디렉토리가 없습니다. Antigravity를 먼저 설치해주세요."
    echo "    다운로드: https://antigravity.google"
fi

echo ""

# --- Step 2: Create directory structure ---
echo -e "${BLUE}[2/10]${NC} 디렉토리 구조 생성 중..."

directories=(
    ".agent/rules"
    ".agent/workflows"
    ".agent/skills/business-researcher"
    ".agent/skills/financial-analyst/scripts"
    ".agent/skills/report-writer"
    ".agent/skills/swot-analyzer"
    ".agent/skills/pitch-deck-creator"
    ".agent/skills/data-visualizer/scripts"
    ".agent/skills/progress-tracker/scripts"
    ".agent/skills/document-exporter/scripts"
    ".agent/skills/opportunity-finder"
    ".agent/skills/ai-business-analyst"
    ".agent/skills/niche-validator"
    ".agent/skills/bootstrap-calculator"
    ".agent/skills/tech-stack-recommender"
    ".agent/skills/export-spec"
    ".agent/skills/reality-check"
    ".agent/skills/scripts"
    "templates"
    "output/ideas"
    "output/research"
    "output/reports"
    "output/financials"
    "output/presentations"
    "output/samples/cafe"
    "output/ideas/idea-001-sample-cafe"
    "output/ideas/idea-002-sample-app"
)

for dir in "${directories[@]}"; do
    mkdir -p "$PROJECT_ROOT/$dir"
done

# Create .gitkeep files to preserve empty directories in git
for gitkeep_dir in "output/ideas" "output/research" "output/reports" "output/financials" "output/presentations"; do
    touch "$PROJECT_ROOT/$gitkeep_dir/.gitkeep"
done

echo -e "  ${GREEN}✓${NC} 26개 디렉토리 생성 완료"
echo ""

# --- Step 3: Create Rules ---
echo -e "${BLUE}[3/10]${NC} 에이전트 규칙 (Rules) 생성 중..."

# Rule 1: korean-communication.md
cat << 'RULE1_EOF' > "$PROJECT_ROOT/.agent/rules/korean-communication.md"
# Korean Communication Rules

* 모든 응답은 한국어로 작성합니다.
* 기술 용어를 사용할 때는 영어를 병기합니다. 예: "손익분기점 (Break-Even Point)"
* 비개발자도 이해할 수 있는 쉬운 표현을 사용합니다. 전문 용어는 반드시 풀어서 설명합니다.
* 존댓말을 사용합니다.
* 숫자는 한국식 단위를 사용합니다. 예: 1억 원, 500만 원
* 날짜는 YYYY년 MM월 DD일 형식을 사용합니다.
* 통화는 기본적으로 원(₩)을 사용하되, 해외 시장 분석 시 달러($) 등을 병기합니다.
RULE1_EOF

# Rule 2: business-planning-style.md
cat << 'RULE2_EOF' > "$PROJECT_ROOT/.agent/rules/business-planning-style.md"
# Business Planning Document Style

* 모든 문서는 구조화된 형태로 작성합니다 (헤더, 표, 목록 활용).
* 주장이나 분석에는 반드시 숫자/데이터 기반 근거를 제시합니다.
* 시장 데이터, 통계 등을 인용할 때는 출처를 명시합니다.
* 각 섹션 끝에는 실행 가능한 액션 아이템을 포함합니다.
* 한국 시장의 맥락과 규제 환경을 우선 고려합니다.
* 재무 수치는 표 형태로 정리하며, 단위를 명확히 표기합니다.
* 분석에는 적절한 프레임워크를 활용합니다 (SWOT, PESTEL, Porter's Five Forces, Business Model Canvas 등).
* 문서 서두에 핵심 요약 (Executive Summary)을 포함합니다.
* 비교 분석은 매트릭스 또는 표로 시각화합니다.
* 긍정적/부정적 측면을 균형 있게 분석합니다.
RULE2_EOF

# Rule 3: safety-guidelines.md
cat << 'RULE3_EOF' > "$PROJECT_ROOT/.agent/rules/safety-guidelines.md"
# Safety Guidelines

* 재무 예측 수치를 제시할 때는 반드시 "추정치"임을 명시합니다.
* 법률 관련 조언을 할 때는 "전문 법률 자문을 받으시길 권합니다"라는 안내를 포함합니다.
* 개인정보, 사업 기밀 등 민감한 정보는 터미널에 출력하지 않습니다.
* 외부 API를 호출하거나 웹 검색을 수행하기 전에 사용자에게 확인을 요청합니다.
* 투자 수익률, 매출 전망 등은 낙관/기본/비관 시나리오를 함께 제시합니다.
* 의료, 식품 안전 관련 내용은 관련 법규를 참조하되, 최종 확인은 관할 기관에 문의하도록 안내합니다.
* 경쟁사 분석 시 확인되지 않은 정보는 추측임을 명시합니다.
* 생성된 문서는 output/ 폴더에 저장합니다.
RULE3_EOF

# Rule 4: update-check.md
cat << 'RULE4_EOF' > "$PROJECT_ROOT/.agent/rules/update-check.md"
# Update Check

* 사용자가 처음 대화를 시작하면(인사, 질문 등) 업데이트 확인을 **1회** 수행합니다.
* 터미널에서 `git fetch origin main --quiet` 실행 후 `git log HEAD..origin/main --oneline`으로 새 커밋을 확인합니다.
* 새 커밋이 있으면 아래 형식으로 안내합니다:

```
📦 사업 기획 도구 업데이트가 있습니다! (N개 변경사항)
   업데이트하려면: "업데이트해줘" 라고 말씀해주세요.
```

* 사용자가 "업데이트해줘"라고 요청하면 `git pull origin main`을 실행합니다.
* 새 커밋이 없으면 아무 안내도 하지 않습니다 (조용히 넘어갑니다).
* git이 설치되어 있지 않거나 원격 저장소에 접근할 수 없으면 오류를 무시하고 넘어갑니다.
* 업데이트 확인은 세션당 **최초 1회만** 수행합니다. 이후 대화에서 반복하지 않습니다.
RULE4_EOF

# Rule 5: context-chaining.md
cat << 'RULE5_EOF' > "$PROJECT_ROOT/.agent/rules/context-chaining.md"
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
RULE5_EOF

# Rule 6: AI Domain Knowledge
cat << 'RULE6_EOF' > "$PROJECT_ROOT/.agent/rules/ai-domain-knowledge.md"
# AI 도메인 지식 (AI Domain Knowledge)

AI 사업 분석 시 내부 참조용 지식 베이스입니다. Invisible Framework 원칙에 따라 사용자에게 내부 분류 체계를 직접 노출하지 않습니다.

## AI 기술 트렌드

| 기술 | 사용자 표현 | 사업 기회 | 성숙도 |
|------|-----------|----------|--------|
| LLM (대규모 언어 모델) | AI 챗봇, 글쓰기 AI | 고객 상담, 콘텐츠 생성, 문서 처리 | 상용화 |
| RAG (검색 증강 생성) | AI 검색, 지식 기반 AI | 기업 지식 관리, 전문 Q&A | 성장기 |
| AI Agent | AI 비서, 자동화 도우미 | 업무 자동화, 워크플로우 최적화 | 초기 |
| Fine-tuning | 맞춤형 AI | 산업 특화 모델, 브랜드 AI | 성장기 |
| MCP (Model Context Protocol) | AI 도구 연결 | AI-소프트웨어 통합, 플러그인 생태계 | 초기 |
| Multi-modal | 이미지/영상 AI | 디자인, 영상 편집, 시각 분석 | 성장기 |
| Edge AI | 기기 내 AI | IoT, 모바일 AI, 실시간 처리 | 성장기 |
| Embedding | 의미 검색, 추천 | 개인화, 유사도 분석, 분류 | 상용화 |
| Vector DB | AI 메모리 | 대규모 검색, 지식 저장 | 성장기 |
| SLM (소형 언어 모델) | 가벼운 AI | 비용 절감, 특화 작업, 프라이버시 | 초기 |

## AI 비즈니스 모델 패턴

| 패턴 | 수익 모델 | 성공 요인 |
|------|----------|----------|
| API 래퍼 | 구독/사용량 과금 | UX 차별화, 특화 프롬프트 |
| 파인튜닝 특화 | 라이선스/구독 | 데이터 품질, 도메인 전문성 |
| 데이터 플라이휠 | 데이터 판매/구독 | 독점 데이터 확보, 네트워크 효과 |
| 에이전트 마켓 | 수수료/구독 | 생태계 확장, 개발자 커뮤니티 |
| 수직 통합 | SaaS 구독 | 산업 이해, 규제 대응 |
| 하이브리드 서비스 | 서비스 수수료 | 인간+AI 조합, 품질 보증 |

## 한국 AI 시장 특수 사항

* **정부 정책**: AI 신산업 육성 전략, 디지털 뉴딜, AI 바우처 사업
* **한국어 모델 수요**: 한국어 특화 LLM 수요 증가, 한국어 데이터 부족
* **규제 환경**: 개인정보보호법, AI 기본법(추진 중), 의료/금융 AI 규제
* **인력 현황**: AI 개발자 인력 부족, 높은 인건비, 해외 인재 유치 경쟁
* **대기업 생태계**: 네이버/카카오/삼성 등 AI 투자 활발, 스타트업 협업 기회

## AI 비용 참고 데이터 (2025 기준)

| 항목 | 비용 범위 | 비고 |
|------|----------|------|
| GPT-4o API | $2.5-10/1M 토큰 | 입출력 차이 |
| Claude API | $3-15/1M 토큰 | 모델별 차이 |
| 오픈소스 호스팅 | $200-2,000/월 | GPU 인스턴스 |
| 벡터 DB | $0-500/월 | 규모별 차이 |
| 파인튜닝 | $100-10,000/회 | 데이터량·모델 크기 |
| 데이터 라벨링 | $0.01-1/건 | 복잡도별 차이 |

> MCP 도구(Perplexity 등) 연동 시 실시간 가격 데이터로 대체합니다.

## 용어 매핑 (기술 → 비즈니스 한국어)

| 기술 용어 | 비즈니스 표현 |
|----------|-------------|
| Hallucination | AI 오류/부정확한 응답 |
| Token | AI 처리 단위 |
| Inference | AI 실행/추론 |
| Training | AI 학습 |
| Prompt Engineering | AI 명령 최적화 |
| Latency | 응답 시간 |
| Throughput | 처리 용량 |
| Context Window | AI 이해 범위 |
RULE6_EOF

# Rule 7: Quality Gate
cat << 'RULE7_EOF' > "$PROJECT_ROOT/.agent/rules/quality-gate.md"
# 산출물 품질 게이트 (Quality Gate)

모든 워크플로우 산출물을 `output/` 디렉토리에 저장하기 직전에 아래 품질 점검을 수행합니다. 전체 통과 시 저장을 진행하고, 미통과 항목이 있어도 저장하되 보완 제안을 표시합니다.

## 기본 점검 항목

모든 산출물에 공통으로 적용되는 5가지 점검 항목입니다:

1. **핵심 요약 (Executive Summary) 포함 여부** — 문서 상단에 핵심 내용을 요약한 섹션이 있는지 확인합니다.
2. **데이터 출처 명시 여부** — 최소 1개 이상의 데이터 출처가 명시되어 있는지 확인합니다.
3. **추정치 불확실성 표시 여부** — 추정치에 "추정", "예상", "약" 등 불확실성 문구가 포함되어 있는지 확인합니다.
4. **다음 단계 (Next Steps) 안내 포함 여부** — 후속 조치나 다음 단계 안내가 포함되어 있는지 확인합니다.
5. **주요 데이터 표(테이블) 형식 정리 여부** — 핵심 수치 데이터가 표 형식으로 정리되어 있는지 확인합니다.

## 워크플로우별 필수 섹션 및 최소 데이터 포인트

| 워크플로우 | 필수 섹션 | 최소 데이터 포인트 |
|-----------|----------|------------------|
| 시장조사 (/market-research) | TAM/SAM/SOM, 산업 트렌드, 고객 세그먼트 | 5개 |
| 경쟁분석 (/competitor-analysis) | 경쟁사 3개 이상, SWOT, 포지셔닝 맵 | 3개 |
| 재무모델링 (/financial-modeling) | 비용 구조, 매출 예측, BEP, 시나리오 분석 | 10개 |
| 사업계획서 (/business-plan) | 전 섹션 완성 (8개 챕터) | 20개 |
| 제품기획 (/product-planning) | 핵심 기능, 차별화, 로드맵 | 5개 |
| 브랜딩 (/branding-strategy) | 브랜드 컨셉, 네이밍, 포지셔닝 | 3개 |
| MVP 정의 (/mvp-definition) | Must-have 기능, Impact-Effort 매트릭스, 출시 기준 | 5개 |
| GTM 전략 (/gtm-launch) | 타겟 고객, 채널 전략, 5단계 출시 계획 | 5개 |
| KPI 프레임워크 (/kpi-framework) | North Star Metric, 핵심 KPI 5개, 측정 주기 | 5개 |
| TCO 대시보드 (/tco-dashboard) | 비용 카테고리, 월별 TCO, 최적화 제안 | 5개 |

## 점검 결과 출력 형식

```
📋 품질 점검: N개 중 M개 충족
✅ 핵심 요약 포함
✅ 데이터 출처 3개 명시
⚠️ 추정치 불확실성 표시 누락 (2곳)
✅ 다음 단계 안내 포함
❌ 표 형식 미사용 (권장: 비용 데이터를 표로 정리)

💡 보완 제안: 추정치에 "추정" 문구를 추가하고, 비용 데이터를 표 형식으로 변환하세요.
```

* ✅ 충족된 항목
* ⚠️ 부분 충족 (일부 누락)
* ❌ 미충족 항목

## 저장 정책

* 전체 통과: 저장을 진행합니다.
* 미통과 항목 존재: 저장하되, 보완 제안을 산출물 하단에 표시합니다.
RULE7_EOF

# Rule 8: Data Confidence
cat << 'RULE8_EOF' > "$PROJECT_ROOT/.agent/rules/data-confidence.md"
# 데이터 신뢰도 등급 (Data Confidence Rating)

수치 데이터를 제시할 때 출처의 신뢰도에 따라 등급을 태깅합니다. 이를 통해 사용자가 데이터의 근거를 즉시 파악할 수 있습니다.

## 4등급 체계

| 등급 | 표시 | 의미 | 예시 출처 |
|------|------|------|----------|
| A | [A] | 공식 출처 | 정부 통계, 기업 공시, 학술 논문, 공식 보고서 |
| B | [B] | 2차 출처 | 리서치 보고서, 뉴스 기사, 업계 분석, 전문가 인터뷰 |
| C | [C] | AI 추정 | AI가 추론한 수치, 유사 사례 기반 추정, 트렌드 외삽 |
| D | [D] | 사용자 가정 | 사용자가 직접 입력한 가정치, 목표 수치 |

## 표시 방법

수치 옆에 등급 태그를 붙입니다:

* "국내 커피 시장 규모 약 7조원 [A]" — 통계청 데이터 기반
* "배달 시장 성장률 약 15% [B]" — 리서치 보고서 참조
* "타겟 고객 전환율 약 3% [C]" — 유사 업종 평균 기반 AI 추정
* "월 매출 목표 5,000만원 [D]" — 사용자가 설정한 목표

## 경고 규칙

* C/D 등급이 전체 수치의 50% 이상이면:
  ```
  ⚠️ 데이터 신뢰도 주의: 검증이 필요한 데이터(C/D등급)가 전체의 N%입니다. 공식 출처 확인을 권장합니다.
  ```
* D 등급이 30% 이상이면:
  ```
  💡 사용자 가정이 많습니다. 시장조사로 검증하는 것을 추천합니다.
  ```

## MCP 연동

* MCP 도구(Perplexity 등)로 확인한 데이터는 B등급으로 시작합니다.
* 공식 출처(정부, 기업)에서 확인 시 A등급으로 승격합니다.
* MCP 미사용 시 AI 추정은 C등급으로 태깅합니다.

## Context Chaining 연동

* 이전 단계에서 태깅된 등급은 후속 단계로 전파됩니다.
* 후속 단계에서 더 높은 등급으로만 변경 가능합니다 (A→B 불가, C→B 가능).
* idea.json에 포함된 수치는 D등급(사용자 가정)으로 초기화됩니다.

## 산출물 요약 시 등급 분포 표시

산출물 하단에 데이터 신뢰도 분포를 표시합니다:

```
📊 데이터 신뢰도 분포: A 3개(25%) | B 5개(42%) | C 3개(25%) | D 1개(8%)
```
RULE8_EOF

# Rule 9: Mode Handler (Phase 7)
cat << 'RULE9_EOF' > "$PROJECT_ROOT/.agent/rules/mode-handler.md"
# Mode Handler — 규모별 AI 페르소나 전환 규칙

* `business_scale` 지침이 일반 지침보다 우선합니다.
* idea.json의 `business_scale` 값에 따라 AI의 분석 관점, 용어, 평가 기준이 자동으로 전환됩니다.

## business_scale 값 정의

| 값 | 대상 | 월 비용 구조 | 성장 전략 | 핵심 지표 |
|---|---|---|---|---|
| micro | 1인 빌더, Micro-SaaS | $100-500 | 부트스트랩, SEO/커뮤니티 | MRR, Churn, ARPU |
| small | 2-5인 팀 | $500-5K | 부트스트랩+엔젤 | MRR, CAC, LTV |
| startup | 스타트업 | $5K-50K | VC, 스케일업 | ARR, Burn Rate, Runway |
| enterprise | 기존사업 | $50K+ | 전통 확장 | EBIT, OPEX, ROI |

## 페르소나 전환 규칙

### `micro` 페르소나 (1인 빌더 / Micro-SaaS)

* "투자 유치" 대신 "현금 흐름/이익률" 관점으로 분석합니다.
* "채용" 대신 "자동화" 관점으로 운영 계획을 수립합니다.
* "브랜드 인지도" 대신 "직접 전환(SEO/커뮤니티)" 관점으로 마케팅을 설계합니다.
* 재무 모델은 Micro-SaaS 템플릿(MRR 기반)을 사용합니다.
* 운영 계획은 자동화 스택 중심으로 구성합니다.

### `small` 페르소나 (소규모 팀 2-5명)

* 린 운영 + 초기 팀빌딩 관점으로 분석합니다.
* "대규모 조직" 대신 "소규모 팀 효율" 관점으로 운영을 설계합니다.
* 자금 조달은 부트스트랩 + 엔젤 투자 범위에서 검토합니다.
* 채용보다 아웃소싱/파트타임 활용을 우선 고려합니다.

### `startup` 페르소나

* 기존 동작을 유지합니다. 별도 분기 없음.

### `enterprise` 페르소나

* 기존 동작을 유지합니다. 별도 분기 없음.

### `null` (미설정)

* 기존 동작 그대로 진행합니다. 분기 없음.
* business_scale이 설정되지 않은 경우 모든 워크플로우는 기본(startup) 관점으로 동작합니다.
RULE9_EOF

echo -e "  ${GREEN}✓${NC} korean-communication.md"
echo -e "  ${GREEN}✓${NC} business-planning-style.md"
echo -e "  ${GREEN}✓${NC} safety-guidelines.md"
echo -e "  ${GREEN}✓${NC} update-check.md"
echo -e "  ${GREEN}✓${NC} context-chaining.md"
echo -e "  ${GREEN}✓${NC} ai-domain-knowledge.md"
echo -e "  ${GREEN}✓${NC} quality-gate.md"
echo -e "  ${GREEN}✓${NC} data-confidence.md"
echo -e "  ${GREEN}✓${NC} mode-handler.md"
echo ""

# --- Step 4: Create Workflows ---
echo -e "${BLUE}[4/10]${NC} 워크플로우 (Workflows) 생성 중..."

# Workflow 1: market-research.md
cat << 'WF1_EOF' > "$PROJECT_ROOT/.agent/workflows/market-research.md"
# market-research

시장 조사를 체계적으로 수행합니다.

## 조사 항목
* 목표 시장의 전체 규모를 추정합니다 (TAM: Total Addressable Market)
* 실제 접근 가능한 시장 규모를 산출합니다 (SAM: Serviceable Addressable Market)
* 초기 목표 시장 점유율을 설정합니다 (SOM: Serviceable Obtainable Market)
* 최근 3-5년간 산업 트렌드를 분석합니다
* 주요 고객 세그먼트를 정의하고 각 세그먼트의 특성을 파악합니다
* 시장 성장률과 향후 전망을 예측합니다
* 시장 진입 장벽을 분석합니다

## 출력 형식
* 각 항목을 표와 그래프로 정리합니다
* 데이터 출처를 반드시 명시합니다
* output/research/ 폴더에 결과를 저장합니다

## 다음 단계
* 시장조사 완료 → `/competitor-analysis`로 경쟁 분석 진행
* 시장 규모가 불확실하면 → `/idea-brainstorm`으로 관점 확장 후 재분석
* MVP 범위를 먼저 좁히려면 → `/mvp-definition` (선택적 보조 워크플로우)
* 전체 진행률 확인 → `/check-progress`
WF1_EOF

# Workflow 2: competitor-analysis.md
cat << 'WF2_EOF' > "$PROJECT_ROOT/.agent/workflows/competitor-analysis.md"
# competitor-analysis

경쟁사를 체계적으로 분석합니다.

## 분석 항목
* 직접 경쟁사 3-5개를 식별합니다
* 간접 경쟁사 및 대체재를 파악합니다
* Porter's Five Forces 분석을 수행합니다
* 각 경쟁사별 SWOT 매트릭스를 작성합니다
* 경쟁사의 가격 전략, 마케팅 방식, 핵심 강점을 비교합니다
* 시장 내 포지셔닝 맵을 그립니다
* 우리 사업의 차별화 포인트를 도출합니다

## 출력 형식
* 경쟁사 비교표를 작성합니다
* 포지셔닝 맵을 텍스트 기반으로 시각화합니다
* output/research/ 폴더에 결과를 저장합니다

## 다음 단계
* 경쟁 분석 완료 → `/menu-costing`으로 제품 원가 분석 진행
* 경쟁이 치열한 경우 → `/lean-canvas`로 차별화 포인트 재정리
* 전체 진행률 확인 → `/check-progress`
WF2_EOF

# Workflow 3: financial-modeling.md
cat << 'WF3_EOF' > "$PROJECT_ROOT/.agent/workflows/financial-modeling.md"
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

## 출력 형식
* 모든 수치는 표 형태로 정리합니다
* 주요 가정(assumptions)을 명확히 기술합니다
* "이 수치는 추정치이며, 실제와 다를 수 있습니다"를 명시합니다
* output/financials/ 폴더에 결과를 저장합니다

## 다음 단계
* 재무 모델 완료 → `/operations-plan`으로 운영 계획 수립
* 수익성이 낮은 경우 → `/menu-costing`으로 원가 구조 재검토
* KPI를 먼저 정의하려면 → `/kpi-framework` (선택적 보조 워크플로우)
* TCO를 상세 분석하려면 → `/tco-dashboard` (선택적 보조 워크플로우)
* 전체 진행률 확인 → `/check-progress`
WF3_EOF

# Workflow 4: business-plan-draft.md
cat << 'WF4_EOF' > "$PROJECT_ROOT/.agent/workflows/business-plan-draft.md"
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

## 다음 단계
* 사업계획서 완료 → `/export-documents`로 HTML/PDF 변환하여 공유
* 산출물 전체 목록 확인 → `/my-outputs`
* 산출물 보안 점검 → `/security-scan` (선택적 보조 워크플로우)
* 변경 이력 관리 → `/version-history` (선택적 보조 워크플로우)
* 전체 진행률 확인 → `/check-progress`
WF4_EOF

# Workflow 5: branding-strategy.md
cat << 'WF5_EOF' > "$PROJECT_ROOT/.agent/workflows/branding-strategy.md"
# branding-strategy

브랜드 전략을 수립합니다.

## 분석 항목
* 브랜드 포지셔닝을 정의합니다 (가치 제안, 타겟, 차별점)
* 타겟 고객 페르소나 2-3개를 구체적으로 작성합니다 (이름, 나이, 직업, 니즈, 행동 패턴)
* 브랜드 네이밍 아이디어를 5-10개 제안합니다 (한국어/영어)
* 브랜드 톤앤매너를 정의합니다
* 마케팅 채널 전략을 수립합니다 (온라인/오프라인)
* 가격 전략을 결정합니다 (프리미엄/중간/경제적)
* 런칭 마케팅 계획을 작성합니다
* SNS 콘텐츠 전략 방향을 제안합니다

## 출력 형식
* 페르소나는 카드 형태로 정리합니다
* 채널별 예산 배분 비율을 표로 제시합니다
* output/reports/ 폴더에 결과를 저장합니다

## 다음 단계
* 브랜딩 전략 완료 → `/legal-checklist`로 법률/인허가 요건 확인
* 출시 전략을 구체화하려면 → `/gtm-launch` (선택적 보조 워크플로우)
* 전체 진행률 확인 → `/check-progress`
WF5_EOF

# Workflow 6: operations-plan.md
cat << 'WF6_EOF' > "$PROJECT_ROOT/.agent/workflows/operations-plan.md"
# operations-plan

사업 운영 계획을 수립합니다.

## 계획 항목
* 공급망을 설계합니다 (원재료 조달 → 생산 → 유통 → 고객)
* 인력 계획을 수립합니다 (필요 인원, 역할, 채용 일정)
* 조직도를 작성합니다
* 시설 및 설비 요구사항을 정리합니다
* 일일 운영 프로세스를 시간대별로 설계합니다
* 품질 관리 체계를 수립합니다
* 재고 관리 방안을 계획합니다
* IT 시스템 (POS, 주문, 배달 등) 요구사항을 정리합니다
* 비상 대응 계획을 작성합니다

## 출력 형식
* 프로세스는 단계별 플로우로 정리합니다
* 인력 계획은 표로 작성합니다
* output/reports/ 폴더에 결과를 저장합니다

## 다음 단계
* 운영 계획 완료 → `/branding-strategy`로 브랜딩/마케팅 전략 수립
* 인력 계획이 불확실하면 → 운영 계획을 수정하여 단계별 채용 계획 보강
* 전체 진행률 확인 → `/check-progress`
WF6_EOF

# Workflow 7: legal-checklist.md
cat << 'WF7_EOF' > "$PROJECT_ROOT/.agent/workflows/legal-checklist.md"
# legal-checklist

사업에 필요한 법률 및 인허가 사항을 점검합니다.

## 체크리스트 항목
* 사업자 등록 절차 (개인/법인 비교)
* 업종별 필요 인허가 목록
* 위생 및 안전 관련 규정 (식품위생법, 소방법 등)
* 근로기준법 관련 사항 (고용 계약, 4대 보험, 최저임금)
* 세금 관련 사항 (부가세, 종합소득세, 법인세)
* 지적재산권 보호 (상표 등록, 특허)
* 필요 보험 가입 사항
* 임대차 계약 시 주의사항
* 프랜차이즈인 경우 가맹사업법 관련 사항

## 출력 형식
* 체크리스트 형태 (☐ 미완료 / ☑ 완료)로 작성합니다
* 각 항목에 관련 법규명과 관할 기관을 명시합니다
* "법률 전문가의 자문을 받으시길 권합니다"를 반드시 포함합니다
* output/reports/ 폴더에 결과를 저장합니다

## 다음 단계
* 법률 체크리스트 완료 → `/business-plan-draft`로 종합 사업계획서 작성
* 세금/4대보험 상세가 필요하면 → tax-guide 스킬이 자동 연동됩니다
* 보안 점검이 필요하면 → `/security-scan` (선택적 보조 워크플로우)
* 전체 진행률 확인 → `/check-progress`
WF7_EOF

# Workflow 8: menu-costing.md
cat << 'WF8_EOF' > "$PROJECT_ROOT/.agent/workflows/menu-costing.md"
# menu-costing

제품/서비스의 원가를 분석하고 가격을 결정합니다.

## 분석 항목
* 제품/서비스별 직접 원재료비를 산출합니다
* 인건비를 제품별로 배분합니다
* 간접비 (임대료, 유틸리티, 감가상각 등)를 배분합니다
* 제품별 총원가를 계산합니다
* 원가율 (원가/판매가)을 산출합니다
* 목표 마진율에 따른 판매가를 역산합니다
* 경쟁사 가격과 비교 분석합니다
* 가격 민감도 분석을 수행합니다
* 볼륨별 원가 변화 (규모의 경제)를 추정합니다

## 출력 형식
* 모든 수치는 표 형태로 정리합니다
* 원가 구성 비율을 시각화합니다
* output/financials/ 폴더에 결과를 저장합니다

## 다음 단계
* 원가 분석 완료 → `/financial-modeling`으로 재무 모델 수립
* 가격 전략을 더 정교하게 하려면 → pricing-strategy 스킬이 자동 연동됩니다
* 전체 진행률 확인 → `/check-progress`
WF8_EOF

# Workflow 9: check-progress.md
cat << 'WF9_EOF' > "$PROJECT_ROOT/.agent/workflows/check-progress.md"
# check-progress

사업 기획 진행 상황을 확인합니다.

## 수행 작업
* scripts/check_progress.py를 실행하여 현재 진행률을 확인합니다
* 8단계 기획 프로세스 중 완료된 단계와 미완료 단계를 표시합니다
* 다음으로 진행해야 할 단계를 추천합니다
* 각 단계에서 사용할 워크플로우 명령어를 안내합니다

## 출력 형식
* 각 단계를 ✅/⬜ 로 표시합니다
* 전체 진행률을 % 와 프로그레스 바로 보여줍니다
* 추천 다음 액션을 제시합니다

## 다음 단계
* 미완료 단계가 있으면 → 해당 단계의 워크플로우를 실행하세요
* 전체 완료 시 → `/business-plan-draft`로 종합 사업계획서 작성
* 전체 산출물 확인 → `/my-outputs`
WF9_EOF

# Workflow 10: export-documents.md
cat << 'WF10_EOF' > "$PROJECT_ROOT/.agent/workflows/export-documents.md"
# export-documents

사업 기획 문서를 HTML/PDF로 내보냅니다.

## 수행 작업
* output/ 폴더의 Markdown 문서를 HTML로 변환합니다
* 한국어 비즈니스 문서 스타일이 적용된 깔끔한 HTML을 생성합니다
* PDF 저장이 필요한 경우 브라우저에서 Cmd+P로 저장하는 방법을 안내합니다

## 사용 예시
* "시장 조사 보고서를 PDF로 만들어주세요" → 해당 파일을 HTML로 변환 후 PDF 저장 안내
* "모든 보고서를 내보내주세요" → output/ 폴더 전체 일괄 변환

## 출력 형식
* 원본 파일과 같은 폴더에 .html 파일로 저장합니다
* 변환 완료 후 파일 경로와 브라우저에서 열기/PDF 저장 방법을 안내합니다

## 다음 단계
* 문서 내보내기 완료 → 생성된 HTML 파일을 브라우저에서 확인하세요
* 추가 산출물이 필요하면 → `/check-progress`로 미완료 단계 확인
* 전체 산출물 목록 → `/my-outputs`
WF10_EOF

# Workflow 11: idea-discovery.md
cat << 'WF11_EOF' > "$PROJECT_ROOT/.agent/workflows/idea-discovery.md"
# idea-discovery

사업 아이디어를 발굴합니다. 도메인 지식은 있지만 구체적인 사업 아이디어가 없는 사용자를 위한 워크플로우입니다.

## 수행 작업
* 사용자의 도메인 경험과 역량을 구조화된 질문으로 파악합니다
* 답변에서 시장 기회 영역을 추출합니다
* 3-5개의 사업 아이디어를 가설 형태(1문단)로 생성합니다
* 각 아이디어를 5점 척도(시장크기, 경쟁강도, 적합성, 자원, 타이밍)로 평가합니다
* Go/Pivot-optimize/Pivot-review/Drop 판정을 내립니다

## 필수 질문 (5개)
1. **업종/산업**: 어떤 분야에서 일하고 계시나요?
2. **경력/경험**: 해당 분야에서 얼마나 오래, 어떤 역할로 일하셨나요?
3. **문제점/불편함**: 일하면서 가장 비효율적이라고 느낀 점은?
4. **가용 자원**: 초기 투자 가능 금액, 활용 가능한 네트워크/자산은?
5. **목표 고객층**: 어떤 고객에게 서비스하고 싶으신가요?

## 프로세스 흐름
* 질문 5개 수집 → 키워드 추출 → 아이디어 3-5개 생성 → 5점 척도 평가 → Go/Pivot-optimize/Pivot-review/Drop

## 아이디어 저장 규칙

Go 판정을 받은 아이디어는 개별 폴더를 생성합니다:

```
output/ideas/{id}-{name}/
├── idea.json          # 메타 정보 (id, name, status, score 등)
├── hypothesis.md      # 아이디어 가설 (1문단)
├── evaluation.md      # Go/Pivot-optimize/Pivot-review/Drop 평가 결과
├── research/          # (빈 디렉토리, 추후 시장조사용)
├── financials/        # (빈 디렉토리, 추후 재무분석용)
└── reports/           # (빈 디렉토리, 추후 보고서용)
```

* ID 형식: `idea-{NNN}` (3자리 제로패딩, 자동 채번)
* 레거시 호환: `output/ideas/selected-idea.md`에도 최신 Go 아이디어 참조 유지

## 다음 단계
* Go 판정 아이디어가 있으면: /idea-validation 으로 검증 진행
* Pivot 판정만 있으면: 아이디어를 수정하여 재평가 (최대 2회)
* 모두 Drop이면: 질문을 보완하여 처음부터 재시도
* 여러 아이디어를 관리하려면: /idea-portfolio 로 포트폴리오 확인

## 출력 형식
* 각 아이디어를 가설 형태(1문단)로 작성합니다
* 평가 결과를 표로 정리합니다
* Go 판정 아이디어는 output/ideas/{id}-{name}/ 폴더에 저장합니다
* output/ideas/selected-idea.md에도 최신 Go 아이디어 참조를 유지합니다
WF11_EOF

# Workflow 12: idea-validation.md
cat << 'WF12_EOF' > "$PROJECT_ROOT/.agent/workflows/idea-validation.md"
# idea-validation

아이디어 발굴(/idea-discovery)에서 도출된 사업 아이디어를 검증합니다.

## 수행 작업
* Go/Pivot 판정을 받은 아이디어의 실현 가능성을 검증합니다
* 간이 시장 검증 (경쟁자 유무, 유사 서비스 존재 여부)을 수행합니다
* 핵심 가정(Critical Assumptions)을 식별합니다
* 최소 검증 방법(MVP 접근법)을 제안합니다
* 확정된 아이디어를 output/ideas/{id}-{name}/ 폴더에 저장합니다
* 레거시 호환을 위해 output/ideas/selected-idea.md에도 참조를 유지합니다

## 검증 항목
1. 시장 존재 여부: 유사 제품/서비스가 있는가? 차별점은?
2. 고객 수요 신호: 관련 커뮤니티, 검색량, 불만 사항이 있는가?
3. 수익 모델 타당성: 고객이 돈을 지불할 의향이 있는 영역인가?
4. 핵심 가정: 성공하려면 반드시 참이어야 하는 것은?
5. MVP 방안: 최소 비용으로 가정을 검증할 수 있는 방법은?

## 최종 판정
* 확정 (Go): output/ideas/{id}-{name}/ 폴더에 검증 결과 저장 → Step 1 시장 조사로 핸드오프
* 수정 (Pivot): 아이디어를 수정하여 /idea-discovery로 재순환 (최대 2회)
* 포기 (Drop): /idea-discovery에서 새 아이디어 탐색
* 여러 아이디어 관리: /idea-portfolio로 포트폴리오 확인

## 반복 제한
* discovery → validation 순환은 최대 2회까지 허용합니다

## 출력 형식
* 검증 결과를 표로 정리합니다
* 확인된 사실과 추정을 구분하여 표기합니다
* 확정된 아이디어는 output/ideas/{id}-{name}/ 폴더에 저장합니다
* output/ideas/selected-idea.md에도 최신 Go 아이디어 참조를 유지합니다

## 다음 단계
* 아이디어 확정(Go) → `/market-research`로 본격 시장조사 시작
* 수정(Pivot) → `/idea-discovery`로 재순환 (최대 2회)
* 여러 아이디어 비교 → `/idea-portfolio`로 포트폴리오 확인
* 전체 진행률 확인 → `/check-progress`
WF12_EOF

# Workflow 13: idea-portfolio.md
cat << 'WF13_EOF' > "$PROJECT_ROOT/.agent/workflows/idea-portfolio.md"
# idea-portfolio

아이디어 포트폴리오를 관리합니다. 전체 아이디어 현황 조회, 상세 확인, 비교, 컨텍스트 전환을 지원하는 워크플로우입니다.

## 수행 작업
* 전체 아이디어 현황을 요약하여 포트폴리오 뷰로 표시합니다
* 특정 아이디어의 진행률과 상세 정보를 확인합니다
* 2개 아이디어의 점수/진행률을 나란히 비교합니다
* 선택한 아이디어 컨텍스트로 전환하여 다음 단계를 진행합니다
* output/ideas/portfolio.md를 자동 갱신합니다

## 프로세스 흐름
```
output/ideas/ 탐색 → 아이디어 유무 확인 → 포트폴리오 요약 → 사용자 행동 선택
```

### 1단계: 아이디어 탐색
* `output/ideas/` 하위 아이디어 폴더를 탐색합니다
* 아이디어가 없으면 → "아직 아이디어가 없습니다. `/idea-discovery`를 실행하세요." 안내 후 종료

### 2단계: 포트폴리오 요약 표시
* `scripts/check_progress.py --portfolio` 를 활용하여 전체 아이디어 현황을 수집합니다
* 각 아이디어별 이름, 점수, 진행률, Go/Pivot-optimize/Pivot-review/Drop 판정을 표로 정리합니다

### 3단계: 사용자 행동 선택지 제시
사용자에게 다음 중 하나를 선택하도록 안내합니다:
1. **특정 아이디어 상세 보기** → `scripts/check_progress.py --idea {id}` 로 해당 아이디어의 진행률 상세 표시
2. **아이디어 비교하기** → 2개 아이디어를 선택하여 점수/진행률을 나란히 비교
3. **새 아이디어 추가하기** → `/idea-discovery` 로 이동
4. **특정 아이디어 다음 단계 진행하기** → 해당 아이디어 컨텍스트로 전환

### 4단계: portfolio.md 갱신
* 워크플로우 실행 시 `output/ideas/portfolio.md`를 자동 갱신합니다
* `<!-- AUTO:START -->` ~ `<!-- AUTO:END -->` 영역만 교체합니다
* 영역 바깥의 사용자 메모는 보존합니다

## 기능 상세

### 포트폴리오 조회
* 전체 아이디어 목록을 테이블 형식으로 표시합니다
* 컬럼: 아이디어 ID, 이름, 종합 점수, 진행률(%), 판정(Go/Pivot-optimize/Pivot-review/Drop)

### 아이디어 상세
* 특정 아이디어의 5점 척도 평가(시장크기, 경쟁강도, 적합성, 자원, 타이밍) 표시
* 완료된 단계와 미완료 단계를 ✅/⬜ 로 표시
* 다음 추천 액션 제시

### 아이디어 비교
* 2개 아이디어의 점수를 나란히 비교합니다
* 각 평가 항목별 차이를 시각적으로 표시합니다
* 어떤 아이디어가 더 유리한지 요약합니다

### 아이디어 전환
* "카페 아이디어를 진행하겠습니다" 같은 요청 시 해당 아이디어 컨텍스트로 전환합니다
* 전환 후 해당 아이디어의 다음 미완료 단계를 자동으로 안내합니다

## 출력 형식
* 포트폴리오 요약을 표로 정리합니다
* 진행률을 % 와 프로그레스 바로 보여줍니다
* 결과물은 `output/ideas/portfolio.md`에 저장합니다

## 다음 단계
* 아이디어를 선택했으면 → `/idea-validation`으로 선택한 아이디어 검증
* 새 아이디어를 추가하려면 → `/idea-discovery`로 아이디어 발굴
* 아이디어를 더 발산하려면 → `/idea-brainstorm`으로 프레임워크 기반 확장
* 전체 진행률 확인 → `/check-progress`
WF13_EOF

# Workflow 14: lean-canvas.md
cat << 'WF14_EOF' > "$PROJECT_ROOT/.agent/workflows/lean-canvas.md"
# lean-canvas

아이디어의 핵심 가설을 Lean Canvas 1페이지로 정리합니다.
`/idea-validation` 완료 후, `/market-research` 전에 사용합니다.

## 수행 작업
* 확정된 아이디어(Go 판정)의 핵심 요소를 Lean Canvas 9블록으로 정리합니다
* output/ideas/{id}-{name}/ 폴더의 hypothesis.md, evaluation.md를 참조합니다
* 사용자와 대화하며 각 블록을 채워나갑니다
* 완성된 Lean Canvas를 아이디어 폴더에 저장합니다

## 프로세스 흐름
아이디어 폴더 확인 → 가설/평가 참조 → 9블록 순서대로 작성 → 저장

## 출력 규칙
* templates/lean-canvas-template.md 형식을 따릅니다
* output/ideas/{id}-{name}/lean-canvas.md에 저장합니다
* 빈 블록이 있어도 저장하되, "[미작성 - 시장조사 후 보완]"으로 표기합니다

## 다음 단계
* /market-research로 시장 조사 진행
* /competitor-analysis로 경쟁 분석 진행
WF14_EOF

# Workflow 15: idea-brainstorm.md
cat << 'WF15_EOF' > "$PROJECT_ROOT/.agent/workflows/idea-brainstorm.md"
# idea-brainstorm

사업 아이디어를 다각적으로 분석합니다. 역발상으로 숨겨진 리스크를 발견하고, 6가지 관점에서 아이디어를 입체적으로 검토하는 워크플로우입니다.

## 수행 작업
* 역발상을 통해 사업의 숨겨진 리스크를 발견하고 방어 전략으로 전환합니다
* 6가지 관점(사실, 감정, 비판, 긍정, 창의, 종합)에서 아이디어를 입체적으로 분석합니다
* 분석 결과를 구조화된 문서로 저장합니다

## 전제 조건
* 분석할 사업 아이디어가 있어야 합니다 (직접 입력 또는 `/idea-discovery`에서 Go 판정을 받은 아이디어)
* 아이디어가 없으면 `/idea-discovery`부터 진행합니다

## 설계 원칙
* **Invisible Framework**: 내부 프레임워크(역 브레인스토밍, 6 Thinking Hats) 용어를 사용자에게 노출하지 않습니다. AI가 내부적으로 적용하고, 사용자는 자연어 분석 결과만 경험합니다
* **한국어 우선**: 모든 질문과 출력은 한국어로 제공합니다
* **실행 가능한 인사이트**: 추상적 분석이 아닌, 바로 행동할 수 있는 결과를 제공합니다

## 프로세스 흐름
```
아이디어 입력 → Phase 1(역발상 리스크 발견) → Phase 2(다각적 관점 분석) → 종합 보고서 생성
```

### Phase 1: 역발상 리스크 발견

AI가 내부적으로 역 브레인스토밍(Reverse Brainstorming)을 적용합니다. 사용자에게는 "리스크 분석" 결과로만 표시됩니다.

**실행 단계:**
1. AI가 "이 사업이 실패하는 시나리오 5-7가지"를 내부적으로 생성합니다
2. 각 실패 시나리오를 뒤집어 "방어 전략"으로 변환합니다
3. 핵심 리스크 3-5개를 도출하고 우선순위를 매깁니다

**출력 형식 — 리스크-방어전략 테이블:**
| # | 숨겨진 리스크 | 심각도 | 방어 전략 | 실행 난이도 |
|---|-------------|--------|----------|------------|
| 1 | (리스크 설명) | 상/중/하 | (방어 전략) | 상/중/하 |

**사용자에게 보이는 메시지 예시:**
> "아이디어의 잠재적 리스크를 분석했습니다. 아래는 발견된 주요 리스크와 대응 전략입니다."

### Phase 2: 다각적 관점 분석

AI가 내부적으로 6 Thinking Hats를 적용합니다. 사용자에게는 모자 색상이나 프레임워크 이름을 언급하지 않고, "6가지 관점 분석"으로 표시됩니다.

**6가지 관점 (내부 매핑):**
| 내부 매핑 | 사용자에게 보이는 관점명 | 분석 내용 |
|----------|----------------------|----------|
| 흰색 모자 | 사실과 데이터 | 검증 가능한 시장 데이터, 통계, 사실 관계 |
| 빨간색 모자 | 감정과 직관 | 첫인상, 고객의 감정적 반응 예측, 직관적 매력도 |
| 검은색 모자 | 비판과 리스크 | 잠재적 문제점, 법적/규제 리스크, 실패 가능성 |
| 노란색 모자 | 긍정과 기회 | 성장 가능성, 차별화 포인트, 시너지 효과 |
| 초록색 모자 | 창의와 대안 | 새로운 접근법, 피벗 가능성, 확장 아이디어 |
| 파란색 모자 | 종합 정리 | 전체 분석 요약, 핵심 인사이트, 우선 행동 항목 |

**실행 규칙:**
* 각 관점별 2-3개 핵심 포인트를 도출합니다
* 관점 간 상충되는 의견이 있으면 명시적으로 기술합니다
* "종합 정리" 관점에서 최종 액션 아이템 3개를 제시합니다

**사용자에게 보이는 메시지 예시:**
> "아이디어를 6가지 관점에서 분석했습니다. 각 관점의 핵심 인사이트를 확인하세요."

## 출력 형식

### 분석 보고서 구조
```markdown
# 브레인스토밍 분석: {아이디어명}

## 1. 리스크 분석
(리스크-방어전략 테이블)

## 2. 다각적 관점 분석

### 사실과 데이터
- (핵심 포인트 2-3개)

### 감정과 직관
- (핵심 포인트 2-3개)

### 비판과 리스크
- (핵심 포인트 2-3개)

### 긍정과 기회
- (핵심 포인트 2-3개)

### 창의와 대안
- (핵심 포인트 2-3개)

### 종합 정리
- (전체 요약)
- **우선 행동 항목**: 1. / 2. / 3.

## 3. 종합 판단
- 아이디어 강화 포인트
- 즉시 검증이 필요한 가정
- 권장 다음 단계
```

### 저장 위치
* `output/ideas/{id}-{name}/brainstorm-analysis.md`에 저장합니다
* 기존 아이디어 폴더가 있으면 해당 폴더에 추가합니다
* 아이디어 폴더가 없으면 새로 생성합니다 (ID 자동 채번)

## 다음 단계
* **리스크가 관리 가능하면**: `/idea-validation`으로 검증 진행
* **근본적 문제 발견 시**: `/idea-discovery`로 돌아가 아이디어 보완
* **새로운 관점이 나왔으면**: 해당 관점을 반영하여 아이디어 피벗
* **여러 아이디어를 비교하려면**: `/idea-portfolio`로 포트폴리오 확인
WF15_EOF

# Workflow 16: my-outputs.md
cat << 'WF16_EOF' > "$PROJECT_ROOT/.agent/workflows/my-outputs.md"
# my-outputs

모든 사업 기획 산출물을 한눈에 확인하는 통합 대시보드를 생성합니다.

## 수행 작업
* output/ 폴더의 모든 산출물을 스캔합니다
* 진행 단계별 완료/미완료 현황을 시각화합니다
* 카테고리별 (아이디어, 시장조사, 재무, 보고서, 발표자료) 파일 목록을 정리합니다
* 시각적인 HTML 대시보드를 생성합니다

## 실행 방법
* 스크립트를 실행합니다: `.agent/skills/scripts/create_outputs_dashboard.py`
* 가상 환경이 있으면 `.venv/bin/python`을, 없으면 `python3`을 사용합니다
* 특정 아이디어만 보려면 `--idea {아이디어ID}` 옵션을 사용합니다

## 출력
* `output/dashboard.html`에 대시보드가 생성됩니다
* 브라우저에서 열어 확인할 수 있습니다
* 대화창에서 "내 산출물 보여줘", "진행 현황 확인" 등으로 실행할 수 있습니다

## 다음 단계
* 미완료 단계가 있으면 해당 워크플로우 명령어를 안내합니다
* 모든 단계가 완료되면 `/export-documents`로 최종 문서 내보내기를 안내합니다
WF16_EOF

# Workflow 17: auto-plan.md
cat << 'WF17_EOF' > "$PROJECT_ROOT/.agent/workflows/auto-plan.md"
# auto-plan

사업 기획 8단계 전체를 순차적으로 안내합니다. 사용자가 주제만 말하면 각 단계를 자동으로 진행하고, 핵심 의사결정 포인트 3곳에서만 사용자의 확인을 받습니다.

## 사용법

```
/auto-plan 카페 창업
/auto-plan 앱 개발 사업
```

## 수행 작업

* 현재 진행 상황을 `scripts/check_progress.py`로 확인합니다
* 이미 완료된 단계는 건너뛰고 첫 번째 미완료 단계부터 시작합니다
* 각 단계 완료 후 핵심 결과를 1-2줄로 요약하고 다음 단계를 자동으로 제안합니다
* 의사결정 포인트(HITL) 3곳에서 사용자의 확인을 받습니다

## 8단계 프로세스

| Step | 워크플로우 | 핵심 산출물 | HITL |
|------|-----------|-----------|------|
| 0 (선택) | /idea-discovery → /idea-validation | idea.json, evaluation.md | **HITL #1: 아이디어 선택** |
| 1 | /market-research | 시장조사 보고서 | |
| 2 | /competitor-analysis | 경쟁분석 보고서 | |
| 3 | /menu-costing | 원가분석표 | **HITL #2: 제품/가격 확인** |
| 4 | /financial-modeling | 재무모델, 3개년 재무제표 | |
| 5 | /operations-plan | 운영계획서 | |
| 6 | /branding-strategy | 브랜딩/마케팅 전략 | **HITL #3: 브랜드 확정** |
| 7 | /legal-checklist | 법률/인허가 체크리스트 | |
| 8 | /business-plan-draft | 종합 사업계획서 | |

## 의사결정 포인트 (Human-in-the-Loop)

### HITL #1: 아이디어 선택 (Step 0 완료 후)
* Go 판정을 받은 아이디어 목록을 제시합니다
* "어떤 아이디어로 진행하시겠습니까?" 라고 물어봅니다
* 사용자가 선택하면 해당 아이디어의 idea.json을 기준으로 이후 단계를 진행합니다

### HITL #2: 제품/가격 확인 (Step 3 완료 후)
* 원가 분석 결과를 요약하여 보여줍니다 (원가율, 마진율, 예상 판매가)
* "이 가격 구조로 진행하시겠습니까?" 라고 확인합니다
* 수정이 필요하면 대화 모드로 전환합니다

### HITL #3: 브랜드 확정 (Step 6 완료 후)
* 브랜드명 후보, 포지셔닝, 핵심 메시지를 제시합니다
* "이 브랜드 방향으로 확정하시겠습니까?" 라고 확인합니다
* 확정하면 나머지 단계를 자동으로 진행합니다

## 단계 완료 후 자동 안내

각 단계가 완료되면:
1. 해당 단계의 핵심 결과를 1-2줄로 요약합니다
2. 결과 파일 저장 위치를 안내합니다
3. "다음 단계: [Step N: 단계명]을 진행합니다. 계속할까요?" 를 표시합니다
4. 사용자가 확인하면 자동으로 다음 워크플로우를 실행합니다

## Context Chaining 연동

* 각 단계 시작 시 context-chaining 규칙에 따라 선행 산출물을 자동 참조합니다
* idea.json의 메타데이터를 전 과정에 걸쳐 전파합니다
* 이전 단계에서 도출된 핵심 수치(TAM, 원가율, BEP 등)를 다음 단계에 자동 반영합니다

## 출력 규칙

* 진행률을 프로그레스 바로 표시합니다: `[████████░░] 80% (Step 7/8)`
* 각 단계 시작 시 "📋 Step N/8: [단계명] 시작" 을 표시합니다
* 완료된 단계는 ✅, 현재 단계는 🔄, 미완료는 ⬜ 로 표시합니다
* 중간에 중단해도 진행 상황이 output/에 저장되어 있으므로 이어서 진행 가능합니다

## 병렬 실행 안내

* Step 5(운영), 6(브랜딩), 7(법률)은 서로 독립적이므로 병렬 실행 가능합니다
* "Step 5-7은 병렬 실행 가능합니다. 한 번에 진행할까요?" 라고 제안합니다
* 사용자가 동의하면 3개 단계를 동시에 안내합니다
WF17_EOF

# Workflow 18: mvp-definition.md
cat << 'WF18_EOF' > "$PROJECT_ROOT/.agent/workflows/mvp-definition.md"
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
WF18_EOF

# Workflow 19: gtm-launch.md
cat << 'WF19_EOF' > "$PROJECT_ROOT/.agent/workflows/gtm-launch.md"
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
WF19_EOF

# Workflow 20: kpi-framework.md
cat << 'WF20_EOF' > "$PROJECT_ROOT/.agent/workflows/kpi-framework.md"
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
WF20_EOF

# Workflow 21: security-scan.md
cat << 'WF21_EOF' > "$PROJECT_ROOT/.agent/workflows/security-scan.md"
# security-scan

output/ 폴더의 산출물에서 개인정보 및 민감정보를 스캔합니다.

> 사업 기획 과정에서 실제 연락처, 사업 기밀 등이 산출물에 포함될 수 있습니다.
> 이 워크플로우는 산출물 공유 전 민감정보를 점검하는 사후 검증 도구입니다.
> 8단계 사업 기획 프로세스 완료 후 선택적으로 실행하는 보조 워크플로우입니다.

## 수행 작업
* output/ 폴더 내 모든 마크다운(.md) 파일을 스캔합니다
* 아래 스캔 패턴 표에 따라 개인정보 및 민감정보를 감지합니다
* 각 발견 항목의 위험도를 분류합니다 (Critical / Warning / Info)
* 마스킹 제안을 제공합니다 (자동 치환 예시)
* 스캔 결과 요약 리포트를 생성합니다

## 스캔 패턴

### 개인정보 패턴 (Critical)

| 패턴 | 설명 | 정규식 예시 | 마스킹 예시 |
|------|------|-----------|-----------|
| 전화번호 | 한국 휴대폰 | `01[016789]-\d{3,4}-\d{4}` | `010-****-****` |
| 주민등록번호 | 13자리 | `\d{6}-[1-4]\d{6}` | `******-*******` |
| 계좌번호 | 은행 계좌 | `\d{3,4}-\d{2,6}-\d{2,6}` | `***-****-****` |
| 카드번호 | 16자리 | `\d{4}-\d{4}-\d{4}-\d{4}` | `****-****-****-****` |
| 여권번호 | 영문+숫자 | `[A-Z]{1,2}\d{7,8}` | `M*******` |

### 연락처/계정 패턴 (Warning)

| 패턴 | 설명 | 정규식 예시 | 마스킹 예시 |
|------|------|-----------|-----------|
| 이메일 | @ 포함 | `[\w.-]+@[\w.-]+\.\w+` | `u***@domain.com` |
| 주소 | 한국 도로명/지번 | 도로명, 번지 패턴 | `서울시 **구 **동` |
| 사업자등록번호 | 10자리 | `\d{3}-\d{2}-\d{5}` | `***-**-*****` |

### 사업 기밀 패턴 (Warning)

| 패턴 | 설명 | 감지 키워드 |
|------|------|-----------|
| API 키 | 서비스 키 | `sk-`, `key_`, `api_key`, `secret` |
| 비밀번호 | 패스워드 | `password:`, `pw:`, `비밀번호:` |
| 실제 매출 | 내부 수치 | 구체적 금액 + "실제", "확정" 키워드 동시 출현 |

### 참고 패턴 (Info)

| 패턴 | 설명 | 비고 |
|------|------|------|
| 대표자 성명 | 실명 | "대표:", "성명:" 뒤의 한글 2-4자 |
| 상호명 | 사업체명 | "상호:", "회사명:" 뒤 텍스트 |

## 출력 형식

### 스캔 결과 표
| # | 파일 | 라인 | 패턴 | 발견 내용 | 위험도 | 마스킹 제안 |
|---|------|------|------|----------|--------|-----------|
| 1 | financials/projection.md | L23 | 전화번호 | 010-1234-5678 | Critical | 010-****-**** |
| ... | | | | | | |

### 요약 통계
| 위험도 | 발견 수 |
|--------|--------|
| 🔴 Critical | 0건 |
| 🟡 Warning | 0건 |
| 🔵 Info | 0건 |
| **합계** | **0건** |

* output/reports/security-scan-result.md에 결과를 저장합니다

## 스캔 옵션
* `--all`: output/ 전체 스캔 (기본)
* `--idea {id}`: 특정 아이디어 폴더만 스캔
* `--fix`: 마스킹 자동 적용 (사용자 확인 후)

## 주의사항
* 이 스캔은 정규식 기반 패턴 매칭이며, 모든 민감정보를 감지하지 못할 수 있습니다
* 맥락 기반 민감정보 (예: 추정치 vs 실제 수치)는 사용자가 직접 판단해야 합니다
* 스캔 결과가 "0건"이라도 공유 전 육안 확인을 권장합니다

## 다음 단계
* 민감정보 발견 시 → 마스킹 적용 후 `/export-documents`로 문서 내보내기
* 전체 진행률 확인 → `/check-progress`
WF21_EOF

# Workflow 22: version-history.md
cat << 'WF22_EOF' > "$PROJECT_ROOT/.agent/workflows/version-history.md"
# version-history

output/ 산출물의 변경 이력을 관리합니다.

> 사업 기획은 반복적인 프로세스입니다. 시장 데이터 업데이트, 가정 변경, 전략 수정 시
> 이전 버전과의 차이를 기록하면 의사결정 과정을 추적할 수 있습니다.
> 8단계 사업 기획 프로세스 완료 후 선택적으로 실행하는 보조 워크플로우입니다.

## 추적 범위

**주요 산출물만 추적합니다** (전체 output/ 추적 시 노이즈 과다):

| 추적 대상 | 파일 경로 | 변경 빈도 |
|----------|----------|----------|
| 시장조사 보고서 | output/research/market-research.md | 분기 1회 |
| 경쟁 분석 | output/research/competitor-analysis.md | 분기 1회 |
| 재무 모델 | output/financials/*.md | 월 1회 |
| 사업계획서 | output/reports/business-plan.md | 주요 변경 시 |
| MVP 정의 | output/ideas/{id}-{name}/mvp-definition.md | 피벗 시 |

> 위 외의 산출물도 사용자 요청 시 추적 가능합니다.

## 수행 작업
* 추적 대상 산출물의 현재 버전을 확인합니다
* 변경 사항이 있으면 CHANGELOG.md를 생성하거나 업데이트합니다
* 변경 내용, 변경 이유, 영향 범위를 기록합니다
* 이전 버전과의 핵심 차이를 요약합니다
* 버전 넘버링 규칙에 따라 버전을 부여합니다

## 버전 넘버링 규칙

| 변경 유형 | 버전 증가 | 예시 | 설명 |
|----------|----------|------|------|
| 최초 작성 | v1.0 | 최초 시장조사 완료 | 새 산출물 생성 |
| 데이터 업데이트 | v1.x (패치) | 시장 규모 수치 보정 | 수치/데이터 변경 |
| 섹션 추가/수정 | v1.x (마이너) | SWOT에 기회 항목 추가 | 구조 부분 변경 |
| 전면 재작성 | vX.0 (메이저) | 피벗 후 시장조사 재수행 | 전체 내용 변경 |

## CHANGELOG.md 형식

[Keep a Changelog](https://keepachangelog.com/) 기반:

```
# Changelog

## [v1.2] - 2026-02-18
### Changed
- 시장 규모 TAM 15조 → 18조로 수정 (2026년 데이터 반영)
- BEP 기간 6개월 → 5개월로 단축 (원가 재계산)

### Reason
- 한국카페산업협회 2026년 보고서 발표에 따른 업데이트

### Impact
- 재무 모델의 매출 전망 상향 조정 필요
- 사업계획서 Step 1, Step 4 업데이트 필요

## [v1.1] - 2026-02-10
### Added
- 니치 검증 체크리스트 결과 추가

### Reason
- 커뮤니티 조사 완료

## [v1.0] - 2026-02-01
### Added
- 최초 시장조사 보고서 작성
```

## 출력 형식
* CHANGELOG.md 형식으로 기록합니다
* output/ideas/{id}-{name}/CHANGELOG.md에 저장합니다
* 변경 시마다 날짜, 변경 내용, 변경 이유, 영향 범위를 기록합니다

## 다음 단계
* 버전 이력 확인 후 → `/check-progress`로 전체 진행률 확인
* 산출물 업데이트 필요 시 → 해당 워크플로우 재실행 (예: `/market-research`)
* 문서 공유 전 → `/security-scan`으로 민감정보 점검
WF22_EOF

# Workflow 23: tco-dashboard.md
cat << 'WF23_EOF' > "$PROJECT_ROOT/.agent/workflows/tco-dashboard.md"
# tco-dashboard

사업 운영의 총 비용(Total Cost of Ownership)을 추적합니다.

> 이 워크플로우는 기획 단계의 초기 비용 추정과 운영 후 실제 비용 추적 모두에 활용됩니다.
> /financial-modeling이 수익성 분석에 초점을 맞춘다면, /tco-dashboard는 비용 구조의 전체 가시성에 초점을 맞춥니다.
> 8단계 사업 기획 프로세스 완료 후 선택적으로 실행하는 보조 워크플로우입니다.

## 트리거 조건
* /financial-modeling 결과가 존재할 때 실행 권장
* output/financials/ 내 재무 산출물 참조

## 수행 작업
* 월별 TCO를 산출합니다 (고정비 + 변동비 + 숨겨진 비용)
* 비용 카테고리별 분석을 수행합니다 (인프라, 인건비, 마케팅, 법률, 기타)
* 비용 추세를 분석합니다 (3/6/12개월)
* 비용 최적화 제안을 제공합니다
* /financial-modeling 결과와 대비하여 차이를 분석합니다

## 비용 분류 체계

### 고정비 (Fixed Costs)
매출과 무관하게 매월 발생하는 비용

| 항목 | 예시 | 비고 |
|------|------|------|
| 임대료 | 월세, 관리비 | 오프라인 사업 |
| 인건비 | 급여, 4대보험 | 직원 있는 경우 |
| 구독료 | SaaS 도구, 호스팅 | 온라인 사업 |
| 보험 | 사업자 보험, 배상책임 | 업종별 상이 |
| 감가상각 | 장비, 인테리어 | 초기 투자 분할 |

### 변동비 (Variable Costs)
매출이나 사용량에 따라 변하는 비용

| 항목 | 예시 | 비고 |
|------|------|------|
| 원재료 | 식자재, 부품 | 오프라인 |
| API 호출 비용 | LLM, 결제 수수료 | AI/SaaS |
| 마케팅비 | 광고, 프로모션 | 성장 단계 |
| 물류비 | 배송, 포장 | 커머스 |

### 숨겨진 비용 (Hidden Costs)
간과하기 쉬운 비용

| 항목 | 예시 | 추정 방법 |
|------|------|----------|
| 세금 | 부가세, 종합소득세 | 매출의 10-30% |
| 수수료 | 카드결제(1.5-3%), PG(2-3.5%) | 거래 건별 |
| 유지보수 | 장비 수리, 업데이트 | 초기 투자의 5-10%/년 |
| 기회비용 | 대표의 시간 가치 | 시급 환산 |
| 규제 비용 | 인허가 갱신, 교육 수료 | 업종별 상이 |

## 출력 형식

### 월별 TCO 표
| 월 | 고정비 | 변동비 | 숨겨진 비용 | **합계** |
|----|--------|--------|-----------|---------|
| 1월 | 만원 | 만원 | 만원 | 만원 |
| ... | | | | |

### 카테고리별 비율 표
| 카테고리 | 월 비용 | 비율 | 최적화 가능 |
|---------|--------|------|-----------|
| 인프라 | 만원 | % | ⭐⭐ |
| 인건비 | 만원 | % | ⭐ |
| 마케팅 | 만원 | % | ⭐⭐⭐ |
| 법률/세금 | 만원 | % | ⭐ |
| 기타 | 만원 | % | ⭐⭐ |

### 비용 최적화 제안
* 각 카테고리별 절감 방안 제시
* 예상 절감액과 실행 난이도 표기

* output/financials/tco-dashboard.md에 저장합니다

### 데이터 신뢰도 등급
> ⚠️ "비용 추정치는 AI 추정(신뢰도 C)이며, 실제 운영 데이터로 보정이 필요합니다."

## Micro-SaaS TCO (v2.0 Phase 7)

idea.json의 business_scale이 "micro" 또는 "small"인 경우, SaaS 도구별 상세 비용을 분석합니다.

### 트리거 조건
* `output/ideas/{id}-{name}/idea.json`의 `business_scale` 값이 `"micro"` 또는 `"small"`일 때 자동 활성화

### SaaS 도구별 비용 상세

| 카테고리 | 도구 예시 | 무료 티어 한도 | 유료 전환 시점 | 월 비용 |
|---------|----------|-------------|-------------|--------|
| 호스팅 | Vercel | 100GB 대역폭 | 월 100K 방문 | $20 |
| DB | Supabase | 500MB, 50K 요청 | 데이터 1GB+ | $25 |
| 인증 | Clerk | MAU 10K | MAU 10K+ | $25 |
| 이메일 | Resend | 100통/일 | 일 100통+ | $20 |
| 모니터링 | Sentry | 5K 이벤트 | 이벤트 5K+/월 | $26 |
| 분석 | Plausible | - | 가입 즉시 | $9 |
| 결제 | Stripe | - | 거래당 2.9%+30¢ | 거래 기반 |
| AI API | OpenAI | - | 사용량 기반 | $50-500 |
| 도메인 | Namecheap | - | 연 $10-15 | $1/월 |

### "숨겨진 비용" 체크리스트
- [ ] SSL 인증서 (Let's Encrypt 무료, 유료 와일드카드 $50-200/년)
- [ ] 이메일 서비스 (Resend, SendGrid — 무료 한도 초과 시)
- [ ] 에러 모니터링 (Sentry 무료 한도 초과 시)
- [ ] 백업 스토리지 (S3, R2 — 소량 무료)
- [ ] CDN (Cloudflare 무료, 프리미엄 기능 시 유료)
- [ ] 도메인 프라이버시 (WHOIS 보호 $10-15/년)
- [ ] 저작권료 (BGM, 폰트, 아이콘 라이선스)

### BEP 대비 TCO (bootstrap-calculator 연동)
* bootstrap-calculator의 BEP 고객 수와 TCO를 대비합니다
* TCO가 BEP 이후에도 빠르게 증가하는 항목을 식별합니다
* 스케일링 시 비용 급증 항목에 대한 대안을 제시합니다

## 다음 단계
* TCO 분석 후 → `/financial-modeling`로 재무 모델 업데이트
* 비용 관련 KPI 설정 → `/kpi-framework`
* 전체 진행률 확인 → `/check-progress`
WF23_EOF

echo -e "  ${GREEN}✓${NC} market-research.md"
echo -e "  ${GREEN}✓${NC} competitor-analysis.md"
echo -e "  ${GREEN}✓${NC} financial-modeling.md"
echo -e "  ${GREEN}✓${NC} business-plan-draft.md"
echo -e "  ${GREEN}✓${NC} branding-strategy.md"
echo -e "  ${GREEN}✓${NC} operations-plan.md"
echo -e "  ${GREEN}✓${NC} legal-checklist.md"
echo -e "  ${GREEN}✓${NC} menu-costing.md"
echo -e "  ${GREEN}✓${NC} check-progress.md"
echo -e "  ${GREEN}✓${NC} export-documents.md"
echo -e "  ${GREEN}✓${NC} idea-discovery.md"
echo -e "  ${GREEN}✓${NC} idea-validation.md"
echo -e "  ${GREEN}✓${NC} idea-portfolio.md"
echo -e "  ${GREEN}✓${NC} lean-canvas.md"
echo -e "  ${GREEN}✓${NC} idea-brainstorm.md"
echo -e "  ${GREEN}✓${NC} my-outputs.md"
echo -e "  ${GREEN}✓${NC} auto-plan.md"
echo -e "  ${GREEN}✓${NC} mvp-definition.md"
echo -e "  ${GREEN}✓${NC} gtm-launch.md"
echo -e "  ${GREEN}✓${NC} kpi-framework.md"
echo -e "  ${GREEN}✓${NC} security-scan.md"
echo -e "  ${GREEN}✓${NC} version-history.md"
echo -e "  ${GREEN}✓${NC} tco-dashboard.md"
echo -e "  ${GREEN}✓${NC} quick-start.md"
echo -e "  ${GREEN}✓${NC} customer-discovery.md"
echo -e "  ${GREEN}✓${NC} payment-setup.md"
echo -e "  ${GREEN}✓${NC} pmf-measurement.md"
echo -e "  ${GREEN}✓${NC} ai-builder.md"
echo -e "  ${GREEN}✓${NC} deploy-guide.md"
echo -e "  ${GREEN}✓${NC} growth-loop.md"
echo ""

# Workflow 24: quick-start.md
cat << 'WF24_EOF' > "$PROJECT_ROOT/.agent/workflows/quick-start.md"
# quick-start

10분 안에 사업 아이디어를 빠르게 정리하는 경량 워크플로우입니다.
34개 전문 워크플로우의 온보딩 부담 없이, 비개발자도 바로 시작할 수 있습니다.

> "완벽한 계획보다 빠른 첫 걸음이 낫습니다."

## 수행 작업
* 사업 아이디어를 5단계 압축 프로세스로 빠르게 정리합니다
* 각 단계에 시간 제한을 두어 총 10분 안에 완료합니다
* 결과물을 다른 전문 워크플로우의 입력으로 재활용할 수 있도록 구조화합니다
* 처음 시작하는 사용자에게 친절한 가이드를 제공합니다

## 프로세스 흐름

```
아이디어 정리(2분) → 시장 검증(3분) → Lean Canvas(2분) → MVP 스펙(2분) → 런치 플랜(1분)
```

### Step 1. 아이디어 정리 (2분)

사업 아이디어의 핵심을 한 페이지로 정리합니다.

| 항목 | 작성 내용 | 예시 |
|------|----------|------|
| 한 줄 요약 | 이 사업은 무엇인가? | "프리랜서를 위한 자동 세금 계산 도구" |
| 타겟 고객 | 누가 쓰는가? | "월 매출 500만원 이하 1인 프리랜서" |
| 해결할 문제 | 왜 필요한가? | "세금 신고 때마다 3시간씩 소비하는 시간 절약" |

> 팁: "누가, 무엇을, 왜"에 각각 1문장으로 답하세요.

### Step 2. 시장 검증 (3분)

아이디어의 시장성을 빠르게 확인합니다.

| 항목 | 작성 내용 |
|------|----------|
| 경쟁자 3개 | 이미 비슷한 서비스가 있는가? (이름, URL, 가격) |
| TAM 추정 | 전체 시장 규모는? (검색량, 커뮤니티 규모 등으로 추정) |
| 차별점 | 기존 서비스 대비 내가 더 잘할 수 있는 1가지 |

> 팁: Google Trends, 네이버 데이터랩, Reddit/커뮤니티 검색으로 빠르게 확인하세요.

### Step 3. Lean Canvas 간이 작성 (2분)

9블록 Lean Canvas를 핵심만 채웁니다.

| 블록 | 한 줄로 작성 |
|------|-------------|
| 문제 | 해결하려는 핵심 문제 1개 |
| 고객 세그먼트 | 가장 먼저 쓸 고객 1그룹 |
| 고유 가치 제안 | "이것만은 확실히 더 낫다" 1가지 |
| 솔루션 | 핵심 기능 1-2개 |
| 채널 | 고객에게 도달하는 방법 1-2개 |
| 수익원 | 돈을 버는 방법 (구독? 건당?) |
| 비용 구조 | 월 예상 비용 (대략적) |
| 핵심 지표 | 성공을 판단할 숫자 1개 |
| 경쟁 우위 | 쉽게 따라할 수 없는 것 1개 |

> 팁: 빈칸이 있어도 괜찮습니다. "[미정]"으로 남기고 나중에 채우세요.

### Step 4. MVP 스펙 (2분)

최소 기능 제품의 범위를 정합니다.

| 항목 | 작성 내용 |
|------|----------|
| Must-have 기능 3개 | 없으면 안 되는 핵심 기능 |
| 기술 스택 | 사용할 도구/프레임워크 (모르면 "[미정]") |
| 1주 로드맵 | Day 1-2: __, Day 3-5: __, Day 6-7: __ |

> 팁: "이 기능이 없으면 고객이 돈을 안 낸다"를 기준으로 3개만 고르세요.

### Step 5. 런치 플랜 (1분)

출시 전략을 간단히 정합니다.

| 항목 | 작성 내용 |
|------|----------|
| 마케팅 채널 2개 | 어디서 고객을 모을 것인가? |
| 첫 주 목표 | 7일 안에 달성할 구체적 숫자 (예: 가입자 50명) |
| 성공 기준 | 이 사업을 계속할지 판단하는 기준 1개 |

> 팁: 채널은 "돈이 안 드는 것" 1개 + "빠른 것" 1개로 고르세요.

## 출력 규칙
* templates/quick-start-template.md 형식을 따릅니다
* output/ideas/{id}-{name}/quick-start.md에 저장합니다
* 모든 5단계를 하나의 파일에 통합하여 저장합니다
* 미작성 항목은 "[미정 - 추후 보완]"으로 표기합니다

## 다음 단계

Quick Start 결과를 바탕으로 전문 워크플로우에서 심화 작업을 진행할 수 있습니다:

| 심화하고 싶은 영역 | 실행할 워크플로우 |
|-------------------|-----------------|
| 아이디어를 더 깊이 검증하고 싶다 | `/idea-validation` |
| 시장 조사를 체계적으로 하고 싶다 | `/market-research` |
| Lean Canvas를 제대로 작성하고 싶다 | `/lean-canvas` |
| MVP를 구체적으로 정의하고 싶다 | `/mvp-definition` |
| 출시 전략을 세우고 싶다 | `/gtm-launch` |
| 재무 모델링이 필요하다 | `/financial-modeling` |
| 전체 사업 계획서를 만들고 싶다 | `/business-plan-draft` |

> Quick Start의 결과물은 위 워크플로우에서 자동으로 참조됩니다. 같은 내용을 다시 입력할 필요가 없습니다.

## 데이터 신뢰도 등급

Quick Start에서 작성하는 내용은 빠른 직관적 판단이므로 기본 신뢰도가 낮습니다:

| 등급 | 의미 | Quick Start 기본 |
|------|------|-----------------|
| A | 검증됨 — 실제 데이터 기반 | - |
| B | 근거 있는 추정 — AI + 외부 데이터 | - |
| C | AI 추정 / 직관적 판단 — 참고용 | **기본값** |

> Quick Start의 모든 수치는 신뢰도 C(직관적 판단)입니다. 전문 워크플로우를 통해 B, A 등급으로 업그레이드하세요.

## Micro-SaaS / 1인 창업 가이드

business_scale이 "micro" 또는 "small"인 경우, 각 단계에서 아래 관점을 우선합니다:

| 단계 | 일반 사업 | Micro-SaaS / 1인 창업 |
|------|----------|---------------------|
| 아이디어 정리 | 넓은 시장의 문제 | 특정 니치의 구체적 불편 |
| 시장 검증 | 대규모 TAM | 니치 커뮤니티 반응, Reddit/인디해커 검색 |
| Lean Canvas | 다채널, 복수 세그먼트 | ICP 1명, 채널 1-2개, 구독 모델 |
| MVP 스펙 | 기능 10개+, 팀 개발 | 기능 1-3개, 1인 1-2주 개발 |
| 런치 플랜 | 마케팅 캠페인 | Product Hunt, 커뮤니티 론칭, SEO |
WF24_EOF

# Workflow 25: customer-discovery.md
cat << 'WF25_EOF' > "$PROJECT_ROOT/.agent/workflows/customer-discovery.md"
# customer-discovery

실제 고객과의 대화를 통해 사업 아이디어를 검증합니다.
Desk research 편향을 방지하고, 현장의 목소리를 기반으로 의사결정합니다.

> `/idea-validation` 또는 `/lean-canvas` 완료 후 실행을 권장합니다.
> 8단계 사업 기획 프로세스의 보조 워크플로우로, 시장 조사 전/후 언제든 실행할 수 있습니다.

## 트리거 조건
* output/ideas/{id}-{name}/ 폴더 내 hypothesis.md, evaluation.md, 또는 lean-canvas.md가 존재할 때
* 사용자가 `/customer-discovery` 명령어를 실행할 때
* `/idea-validation` 결과에서 "고객 인터뷰 필요" 판정을 받았을 때

## 수행 작업
* Mom Test 원칙에 기반한 고객 인터뷰 가이드를 생성합니다
* 사업 유형에 맞는 인터뷰 스크립트를 작성합니다
* AI 가상 페르소나로 아이디어를 사전 테스트(Red-teaming)합니다
* 인터뷰 결과를 구조화된 피드백 루프로 정리합니다
* 검증 대시보드로 진행 상황을 추적합니다
* 결과를 output/ideas/{id}-{name}/customer-discovery.md에 저장합니다

## 프로세스 흐름
```
아이디어 확인 → Mom Test 원칙 학습 → 인터뷰 스크립트 생성
→ 가상 페르소나 Red-teaming → 실제 인터뷰 수행(사용자)
→ 피드백 루프 정리 → Pivot/Persevere 판정 → 검증 대시보드 업데이트
```

---

## 1. Mom Test 원칙

Rob Fitzpatrick의 "The Mom Test" 핵심 규칙입니다. 고객 인터뷰에서 진짜 인사이트를 얻기 위한 원칙입니다.

### 3대 규칙

| # | 규칙 | 설명 | 나쁜 예 | 좋은 예 |
|---|------|------|---------|---------|
| 1 | 자기 아이디어를 말하지 않기 | 솔루션을 설명하면 상대방은 예의상 긍정합니다 | "이런 앱을 만들건데 어떻게 생각해요?" | "이 문제를 마지막으로 겪은 게 언제예요?" |
| 2 | 과거 행동을 물어보기 | 미래 의향이 아닌, 실제로 한 행동을 확인합니다 | "이런 서비스 나오면 쓸 거예요?" | "지난달에 이 문제를 어떻게 해결했어요?" |
| 3 | 칭찬을 경계하기 | "좋은 아이디어네요"는 데이터가 아닙니다 | 칭찬을 긍정 시그널로 기록 | "구체적으로 어떤 부분이 도움이 될까요?" |

### 추가 원칙
* **구체적 숫자를 얻으세요**: "자주" 대신 "주 몇 회?"
* **감정이 아닌 행동을 추적하세요**: "짜증나요" 대신 "그래서 어떻게 했어요?"
* **지갑을 열었는지 확인하세요**: 기존 해결 방법에 돈/시간을 쓰고 있는가?
* **대화 끝에 커밋먼트를 요청하세요**: 시간, 소개, 사전 주문 등

---

## 2. 인터뷰 스크립트 생성

사업 유형별로 커스터마이징된 인터뷰 스크립트를 생성합니다.
아래는 기본 템플릿이며, idea.json의 business_type과 business_scale에 따라 질문을 조정합니다.

### 오프닝 (라포 형성) — 2분
* 자기소개 (회사/제품 설명 없이)
* "요즘 [관련 도메인]에서 어떤 일을 하고 계세요?"
* "오늘 [관련 문제 영역]에 대해 이야기를 나눠보고 싶어요"

### 문제 탐색 질문 — 10분
1. "[문제 영역]에서 가장 시간이 많이 드는 작업은 무엇인가요?"
2. "이 문제를 마지막으로 겪은 게 언제예요? 그때 상황을 자세히 말씀해주세요."
3. "이 문제 때문에 포기하거나 미룬 적이 있나요?"
4. "이 문제가 해결되지 않으면 어떤 결과가 생기나요?"
5. "이 문제에 대해 동료/친구에게 불평한 적 있나요? 뭐라고 말했어요?"

### 현재 해결 방법 질문 — 5분
1. "지금은 이 문제를 어떻게 해결하고 있나요? (도구, 프로세스, 사람)"
2. "현재 해결 방법에서 가장 불만족스러운 점은 무엇인가요?"
3. "더 나은 해결 방법을 찾기 위해 최근에 뭔가를 시도해본 적 있나요?"

### 지불 의향 질문 — 3분
1. "현재 이 문제를 해결하기 위해 비용(돈/시간)을 얼마나 쓰고 있나요?"
2. "이 문제가 완벽히 해결된다면, 월 얼마까지 지불할 의향이 있으세요?"

### 클로징 (다음 단계) — 2분
* "혹시 이 문제를 겪고 있는 다른 분을 소개해주실 수 있나요?" (커밋먼트)
* "프로토타입이 나오면 피드백을 주실 수 있으세요?" (커밋먼트)
* "오늘 대화에서 제가 놓친 중요한 부분이 있을까요?"

### 인터뷰 메모 템플릿
```markdown
## 인터뷰 #[N]
- 날짜:
- 대상: [역할/특성, 이름 비공개]
- 채널: [대면/화상/전화/채팅]

### 핵심 발언 (직접 인용)
1. "..."
2. "..."

### 관찰된 행동
- 현재 해결 방법:
- 지불 중인 비용:
- 감정 강도 (1-5):

### 시그널 판정
- [ ] 문제 인식 있음
- [ ] 기존 해결 방법에 불만족
- [ ] 지불 의향 있음
- [ ] 다른 사람 소개 가능 (강한 시그널)
```

---

## 3. 가상 페르소나 Red-teaming

실제 인터뷰 전에 AI가 3가지 페르소나를 시뮬레이션하여 아이디어를 사전 테스트합니다.

> **주의**: AI 시뮬레이션은 실제 고객 인터뷰를 대체할 수 없습니다. 인터뷰 준비와 약점 파악 용도로만 사용하세요.

### 페르소나 A: 열성 지지자 (Early Adopter)
* **특성**: 문제를 강하게 인식하고, 새로운 솔루션을 적극적으로 시도하는 사용자
* **역할**: 아이디어의 핵심 가치를 검증하고 확장 가능성 탐색
* **주의점**: 이 페르소나의 긍정적 반응만으로 시장성을 판단하지 마세요

### 페르소나 B: 회의론자 (Skeptic)
* **특성**: 기존 방식에 익숙하고, 변화 비용을 높게 평가하는 사용자
* **역할**: switching cost, 학습 곡선, 신뢰 장벽을 테스트
* **주의점**: 이 페르소나가 설득되지 않는다면 시장 진입 전략을 재검토하세요

### 페르소나 C: 무관심자 (Non-consumer)
* **특성**: 문제를 인식하지 못하거나, 현재 방법에 충분히 만족하는 사용자
* **역할**: "왜 지금?"이라는 질문에 대한 답을 강제로 도출
* **주의점**: 이 페르소나가 다수라면, 시장 크기를 재평가해야 합니다

### Red-teaming 출력 형식
```markdown
## 가상 페르소나 Red-teaming 결과

### 페르소나 A: 열성 지지자
- 반응 요약:
- 가장 관심 있는 기능:
- 추가 요청 사항:
- 예상 지불 의향:

### 페르소나 B: 회의론자
- 주요 반론:
- switching cost 우려:
- 설득 포인트:
- 남은 장벽:

### 페르소나 C: 무관심자
- 문제 인식 수준:
- "왜 지금?" 답변 가능 여부:
- 도달 채널 난이도:

### 종합 평가
- 아이디어 취약점 Top 3:
  1.
  2.
  3.
- 인터뷰 시 반드시 확인할 질문:
  1.
  2.
  3.
```

---

## 4. 피드백 루프

인터뷰 결과를 구조화하여 의사결정에 활용합니다.

### 4-1. 패턴 식별

| 시그널 강도 | 기준 | 의미 |
|------------|------|------|
| **강한 시그널** | 인터뷰 대상 중 60% 이상(3/5명+)이 동일 문제 언급 | 핵심 문제로 확정 |
| **중간 시그널** | 인터뷰 대상 중 40-60%(2-3/5명)이 유사 문제 언급 | 추가 인터뷰로 확인 필요 |
| **약한 시그널** | 인터뷰 대상 중 40% 미만(1-2/5명)만 언급 | 피벗 검토 |

### 4-2. 인사이트 매트릭스

| | 예상했던 것 | 예상 못 했던 것 |
|---|-----------|---------------|
| **확인됨** | 핵심 가설 검증됨 (강화) | 새로운 기회 발견 (탐색) |
| **부정됨** | 가설 무효화 (피벗 검토) | 숨겨진 위험 발견 (대응 필요) |

### 4-3. Pivot / Persevere 의사결정 프레임워크

다음 질문에 순서대로 답하세요:

```
Q1. 핵심 문제가 실제로 존재하는가?
├── Yes → Q2로
└── No → PIVOT (문제 재정의)

Q2. 고객이 현재 해결 방법에 불만족하는가?
├── Yes → Q3로
└── No → PIVOT (차별화 재검토)

Q3. 고객이 비용을 지불할 의향이 있는가?
├── Yes → Q4로
└── No → PIVOT (수익 모델 재설계)

Q4. 우리 솔루션이 기존 방법보다 10배 나은가?
├── Yes → PERSEVERE (진행)
└── No → PIVOT (가치 제안 강화)
```

### 판정 기준

| 판정 | 조건 | 다음 행동 |
|------|------|----------|
| **Persevere** | Q1-Q4 모두 Yes | MVP 개발 진행 → `/mvp-definition` |
| **Pivot (문제)** | Q1에서 No | `/idea-discovery`로 돌아가 문제 재탐색 |
| **Pivot (솔루션)** | Q2-Q3에서 No | 같은 문제, 다른 접근법으로 재설계 |
| **Pivot (시장)** | Q4에서 No | 같은 솔루션, 다른 세그먼트 탐색 |
| **Kill** | 인터뷰 10건 이상 + 강한 시그널 없음 | `/idea-portfolio`에서 다른 아이디어 선택 |

---

## 5. 검증 대시보드

인터뷰 진행 상황과 핵심 인사이트를 한눈에 파악합니다.

```markdown
## Customer Discovery 대시보드

### 진행 현황
| 항목 | 현재 | 목표 | 상태 |
|------|------|------|------|
| 인터뷰 수 | 0 | 5+ | ❌ 미달 |
| 강한 시그널 수 | 0 | 3+ | ❌ 미달 |
| 패턴 식별 | 0 | 2+ | ❌ 미달 |

### 핵심 인사이트 Top 3
1. [인터뷰 후 작성]
2. [인터뷰 후 작성]
3. [인터뷰 후 작성]

### 가설 검증 현황
| 핵심 가설 | 상태 | 근거 |
|----------|------|------|
| [가설 1] | 미검증 | |
| [가설 2] | 미검증 | |
| [가설 3] | 미검증 | |

### 현재 판정: [미결정]
```

---

## 검증 신뢰도 등급

| 등급 | 의미 | 조건 |
|------|------|------|
| A | 검증됨 | 인터뷰 10건+ & 강한 시그널 3개+ & Persevere 판정 |
| B | 근거 있는 추정 | 인터뷰 5건+ & 중간 시그널 이상 2개+ |
| C | AI 추정 | 가상 페르소나 Red-teaming만 수행 (기본값) |

> "AI Red-teaming은 실제 고객 인터뷰를 대체할 수 없습니다. 반드시 실제 인터뷰를 병행하세요."

---

## Micro-SaaS 고객 검증 (business_scale: micro/small)

idea.json의 business_scale이 "micro" 또는 "small"인 경우, 간소화된 고객 검증을 수행합니다.

### 핵심 차이점

| 항목 | 기존 (startup/enterprise) | Micro-SaaS (micro/small) |
|------|-------------------------|------------------------|
| 인터뷰 대상 수 | 10-20명 | 5-10명 |
| 인터뷰 채널 | 대면/화상 우선 | 온라인 커뮤니티, 채팅 가능 |
| 검증 기간 | 2-4주 | 3-7일 |
| 핵심 질문 | 조직 의사결정 프로세스 포함 | 개인 의사결정에 집중 |
| 성공 기준 | PMF 시그널 | "지금 당장 돈 내고 쓸 사람" 존재 여부 |

### Micro-SaaS 빠른 검증 채널
| 채널 | 방법 | 소요 시간 |
|------|------|----------|
| Reddit/해외 커뮤니티 | 관련 서브레딧에서 문제 공감 확인 | 1-2일 |
| 트위터/X | 문제 공유 트윗 → 반응 측정 | 1일 |
| Indie Hackers | 아이디어 공유 → 피드백 수집 | 2-3일 |
| 디스코드/슬랙 커뮤니티 | 니치 커뮤니티에서 직접 대화 | 1-2일 |
| 기존 사용자 (있는 경우) | 이메일/DM으로 직접 인터뷰 | 1일 |

---

## 용어 매핑

| 영어 | 한국어 | 설명 |
|------|--------|------|
| Customer Discovery | 고객 검증 | 잠재 고객과의 대화를 통한 가설 검증 |
| Mom Test | 맘 테스트 | 편향 없는 고객 인터뷰 방법론 |
| Red-teaming | 레드팀 테스트 | 비판적 시각에서의 아이디어 검증 |
| Pivot | 피벗 | 전략 방향 전환 |
| Persevere | 유지/진행 | 현재 방향 지속 |
| Signal | 시그널 | 시장/고객 반응 신호 |
| Early Adopter | 얼리 어답터 | 초기 수용자 |
| Switching Cost | 전환 비용 | 기존 방법에서 새 방법으로 바꾸는 데 드는 비용 |
| Commitment | 커밋먼트 | 시간/소개/사전주문 등 구체적 행동 약속 |
| ICP | 이상적 고객 프로필 | Ideal Customer Profile |

---

## 출력 규칙
* output/ideas/{id}-{name}/customer-discovery.md에 저장합니다
* 가상 Red-teaming 결과와 실제 인터뷰 결과를 명확히 구분하여 표기합니다
* 모든 인사이트에 근거(인터뷰 번호 또는 AI 시뮬레이션)를 명시합니다
* 직접 인용문은 따옴표로 감싸고 인터뷰 번호를 표기합니다

## 다음 단계
* Persevere 판정 시 → `/mvp-definition`으로 MVP 범위 정의
* Pivot (문제) 시 → `/idea-discovery`로 돌아가 재탐색
* Pivot (솔루션/시장) 시 → `/lean-canvas` 수정 후 재검증
* 시장 데이터 보강 필요 시 → `/market-research`로 시장 조사
* 전체 진행률 확인 → `/check-progress`
WF25_EOF

# Workflow 26: payment-setup.md
cat << 'WF26_EOF' > "$PROJECT_ROOT/.agent/workflows/payment-setup.md"
# payment-setup

결제 인프라 구축 가이드를 제공합니다. 1인 SaaS 빌더가 PG 선택부터 프로덕션 결제까지 단계별로 셋업할 수 있도록 안내합니다.

> 이 워크플로우는 tax-guide 스킬과 연동하여 세금계산서 발행을 참조합니다.
> `/mvp-definition` 또는 `/operations-plan` 완료 후 실행을 권장합니다.

## 트리거 조건
* /mvp-definition 또는 /operations-plan 결과가 존재할 때 실행 권장
* output/ideas/{id}-{name}/ 폴더 내 mvp-definition.md 또는 idea.json 참조

## 용어 매핑 (영어 → 한국어)

| 영어 | 한국어 | 설명 |
|------|--------|------|
| PG (Payment Gateway) | 결제 대행사 | 카드사/은행과 가맹점 사이에서 결제를 중개하는 서비스 |
| Recurring Billing | 정기 결제 (구독 결제) | 주기적으로 자동 청구되는 결제 방식 |
| Webhook | 웹훅 | 결제 이벤트 발생 시 서버로 전송되는 HTTP 콜백 |
| Checkout | 결제 페이지 | 사용자가 결제 정보를 입력하는 화면 |
| Dunning | 결제 실패 재시도 | 결제 실패 시 자동 재시도 및 고객 알림 프로세스 |
| Churn | 이탈률 | 구독을 해지하는 고객 비율 |
| MRR | 월간 반복 매출 | Monthly Recurring Revenue |
| ARR | 연간 반복 매출 | Annual Recurring Revenue |
| Proration | 일할 계산 | 요금제 변경 시 남은 기간에 대한 비례 계산 |
| Invoice | 청구서 / 인보이스 | 결제 내역을 기록한 문서 |
| Refund | 환불 | 결제 취소 후 금액 반환 |
| Settlement | 정산 | PG사가 가맹점에 결제 대금을 지급하는 과정 |

## PG 선택 의사결정 트리

아래 질문에 따라 적합한 PG를 선택합니다:

```
해외 고객이 있는가?
├── YES → 해외 결제 필수
│   ├── 구독(정기) 결제인가?
│   │   ├── YES → Stripe Billing
│   │   └── NO → Stripe (단건)
│   └── 한국 + 해외 동시 필요?
│       └── YES → 포트원(PortOne) + Stripe 조합
│
└── NO → 국내 전용
    ├── 구독(정기) 결제인가?
    │   ├── YES → 토스페이먼츠 정기결제 또는 포트원
    │   └── NO → 단건 결제
    │       ├── 간편결제 선호? → 카카오페이 / 네이버페이
    │       └── 카드결제 중심? → 토스페이먼츠 / 나이스페이
    │
    └── 노코드/간편 시작?
        ├── YES → Gumroad / Lemon Squeezy
        └── NO → 토스페이먼츠 API 연동
```

## PG사 비교표

| PG사 | 수수료 | 정산주기 | 해외결제 | 구독지원 | 연동 난이도 | 추천 대상 |
|------|--------|----------|----------|----------|-------------|-----------|
| Stripe | 2.9% + 30¢ (해외) / 3.4% + ₩400 (한국 카드) | 2영업일 (해외), 7영업일 (한국) | ✅ 135+ 통화 | ✅ Stripe Billing | 중간 | 해외 고객 있는 SaaS, 글로벌 서비스 |
| 토스페이먼츠 | 카드 2.5-3.3% | 영업일+1 (D+1) | ❌ | ✅ 정기결제 API | 낮음 | 국내 중심 SaaS, 빠른 정산 필요 |
| 포트원 (PortOne) | PG사 수수료 + 포트원 무료 (v2) | PG사에 따라 상이 | ✅ (연동 PG 의존) | ✅ (연동 PG 의존) | 낮음 | 멀티 PG 통합, PG 교체 유연성 |
| 카카오페이 | 2.5-3.3% | D+1 ~ D+3 | ❌ | ❌ | 낮음 | 간편결제 중심, 소액 결제 |
| 나이스페이 | 카드 2.5-3.0% | D+2 ~ D+5 | ✅ (일부) | ✅ (별도 계약) | 중간 | 대형 커머스, 다양한 결제 수단 |
| Gumroad | 10% + 50¢ | 매주 금요일 | ✅ | ✅ | 매우 낮음 (노코드) | 디지털 제품 판매, 초기 검증 |
| Lemon Squeezy | 5% + 50¢ | 월 2회 | ✅ | ✅ | 매우 낮음 (노코드) | SaaS 구독, MoR(세금 대행) |

> ⚠️ 수수료와 정산주기는 계약 조건, 거래량에 따라 달라집니다. 실제 적용 전 각 PG사 공식 문서를 확인하세요.

### 데이터 신뢰도 등급
모든 수수료/정산 정보에 신뢰도 등급을 표기합니다:
| 등급 | 의미 | 예시 |
|------|------|------|
| A | 검증됨 — 공식 문서 기반 | PG사 공식 요금 페이지 |
| B | 근거 있는 추정 — 업계 평균 | 커뮤니티 공유 데이터, 벤치마크 |
| C | AI 추정 — 참고용 | AI가 생성한 초기 추정치 |

> ⚠️ "이 분석의 수수료 정보는 AI 추정(신뢰도 B-C)이며, 각 PG사 공식 문서에서 최신 요율을 확인하세요."

## 수행 작업

### 1단계: 결제 요구사항 분석
* 사업 모델에 맞는 결제 유형 결정 (구독 / 단건 / 혼합)
* 타겟 고객 지역 확인 (국내 / 해외 / 글로벌)
* 예상 거래량 및 객단가 추정
* idea.json의 business_scale 참조

### 2단계: PG사 선택
* 의사결정 트리에 따라 PG사 선정
* 비교표 기반으로 수수료/정산주기 확인
* 사업자등록증 준비 (국내 PG 필수)

### 3단계: 가격 티어 설계
* 무료(Free) / 기본(Basic) / 프로(Pro) 티어 구성
* 각 티어별 기능 차별화 명시
* 연간 결제 할인율 설정 (보통 20% 할인)
* 가격 앵커링 전략 적용

### 4단계: 구독 결제 설정
* 가격 티어를 PG사에 등록 (Product/Price 생성)
* 무료 체험(Free Trial) 기간 설정 (7일 / 14일 권장)
* 결제 실패 처리(Dunning) 설정
  - 1차 실패: 즉시 재시도
  - 2차 실패: 3일 후 재시도 + 이메일 알림
  - 3차 실패: 7일 후 재시도 + 서비스 제한 경고
  - 최종 실패: 구독 일시 정지 + 복구 안내
* 환불 정책 수립 (14일 이내 전액 환불 권장)
* 세금계산서 연동 (tax-guide 스킬 참조)

### 5단계: 결제 테스트
* 테스트 모드 설정 및 검증
* 프로덕션 전환 체크리스트 확인

## 프로세스 흐름

```
요구사항 분석 → PG 선택 → 가격 티어 설계
    ↓
구독 설정 → Webhook 연동 → 테스트
    ↓
프로덕션 전환 → 모니터링 시작
```

## 결제 테스트 가이드

### 테스트 모드 설정

| PG사 | 테스트 환경 | 설정 방법 |
|------|-------------|-----------|
| Stripe | Test Mode 토글 | Dashboard에서 "Test mode" 활성화, `sk_test_` 키 사용 |
| 토스페이먼츠 | 테스트 API 키 | 개발자 센터에서 테스트용 클라이언트 키 발급 |
| 포트원 | 테스트 모드 | 관리자 콘솔에서 테스트 채널 설정 |

### 테스트 카드 번호

| 용도 | Stripe 테스트 카드 | 설명 |
|------|-------------------|------|
| 성공 | 4242 4242 4242 4242 | 정상 결제 |
| 실패 (카드 거절) | 4000 0000 0000 0002 | 카드 거절 시나리오 |
| 인증 필요 (3D Secure) | 4000 0025 0000 3155 | 3DS 인증 테스트 |
| 잔액 부족 | 4000 0000 0000 9995 | 잔액 부족 시나리오 |

> 토스페이먼츠/포트원은 각 공식 문서에서 테스트 카드 정보를 확인하세요.

### Webhook 테스트

* **Stripe**: Stripe CLI로 로컬 Webhook 테스트
  ```
  stripe listen --forward-to localhost:3000/api/webhooks/stripe
  stripe trigger payment_intent.succeeded
  ```
* **토스페이먼츠**: 테스트 결제 진행 시 자동으로 Webhook 발송
* **공통 확인 사항**:
  - [ ] 결제 성공 이벤트 수신 확인
  - [ ] 결제 실패 이벤트 수신 확인
  - [ ] 구독 생성/갱신/해지 이벤트 수신 확인
  - [ ] 환불 이벤트 수신 확인
  - [ ] Webhook 서명 검증 구현 확인
  - [ ] 중복 이벤트 처리 (멱등성) 확인

### 프로덕션 전환 체크리스트

- [ ] 라이브 API 키로 교체 완료
- [ ] Webhook URL을 프로덕션 엔드포인트로 변경
- [ ] 결제 성공/실패 알림 이메일 설정 완료
- [ ] 에러 모니터링 설정 (Sentry 등)
- [ ] 결제 관련 법적 고지 페이지 작성 (이용약관, 환불 정책)
- [ ] SSL/HTTPS 적용 확인
- [ ] PCI DSS 준수 확인 (PG사 결제창 사용 시 PG사가 처리)
- [ ] 첫 실제 결제 테스트 완료 (소액 자체 결제)

## Micro-SaaS 결제 (business_scale micro/small)

idea.json의 business_scale이 "micro" 또는 "small"인 경우, 최소 비용으로 결제를 시작하는 전략을 제공합니다.

### 트리거 조건
* output/ideas/{id}-{name}/idea.json의 business_scale 값이 "micro" 또는 "small"일 때 자동 활성화

### 간편 결제 링크 (코딩 최소화)

| 방법 | 비용 | 구독 지원 | 설정 시간 | 추천 단계 |
|------|------|-----------|-----------|-----------|
| Stripe Payment Links | 무료 (수수료만) | ✅ | 5분 | MVP 검증 |
| 토스 결제 링크 | 무료 (수수료만) | ❌ | 5분 | 국내 단건 판매 |
| Gumroad | 10% 수수료 | ✅ | 10분 | 디지털 제품 초기 판매 |
| Lemon Squeezy | 5% 수수료 | ✅ | 15분 | SaaS 구독 (세금 대행 포함) |

### 노코드 결제 시작 가이드

#### Stripe Payment Links (해외 고객)
1. Stripe 계정 생성 → Dashboard 접속
2. Products에서 상품/가격 생성
3. Payment Links에서 결제 링크 생성
4. 랜딩 페이지에 링크 삽입
5. 월 비용: $0 (수수료만)

#### Lemon Squeezy (세금 걱정 없이)
1. Lemon Squeezy 계정 생성
2. Store에서 상품 등록
3. Checkout 링크 복사
4. 랜딩 페이지에 삽입
5. 월 비용: $0 (수수료만, MoR로 세금 자동 처리)

#### 토스 결제 링크 (국내 고객)
1. 토스페이먼츠 가입 + 사업자 인증
2. 결제 링크 생성 메뉴에서 상품 등록
3. 생성된 링크를 고객에게 공유
4. 월 비용: $0 (수수료만)

### 월 $0-10 비용으로 시작하는 결제 스택

| 거래 규모 | 추천 스택 | 월 고정비 | 변동비 |
|-----------|-----------|-----------|--------|
| 0-10건/월 | Stripe Payment Links | $0 | 건당 수수료 |
| 10-50건/월 | Stripe Checkout (코드 연동) | $0 | 건당 수수료 |
| 50-200건/월 | Stripe Billing (구독 자동화) | $0 | 건당 수수료 |
| 국내 전용 | 토스페이먼츠 | $0 | 건당 수수료 |

### 핵심 차이점

| 항목 | 기존 (startup/enterprise) | Micro-SaaS (micro/small) |
|------|-------------------------|------------------------|
| PG 연동 | API 직접 연동 | 결제 링크 / 노코드 우선 |
| 가격 티어 | 3-5개 복잡한 플랜 | 1-2개 단순 플랜 |
| 결제 수단 | 카드 + 계좌이체 + 간편결제 | 카드 결제 중심 |
| 세금 처리 | 자체 세금계산서 발행 | MoR 서비스 활용 또는 tax-guide 참조 |
| 초기 투자 | 개발 2-4주 | 1-2시간 설정 |

## 출력 규칙
* output/reports/payment-setup.md에 저장합니다
* 결제 요구사항, PG 선택 근거, 가격 티어, 테스트 결과를 포함합니다
* 모든 수수료에 신뢰도 등급을 표기합니다

> ⚠️ 결제 수수료와 정책은 수시로 변경됩니다. 실제 적용 전 각 PG사 공식 문서를 확인하세요.

## 다음 단계
* 결제 설정 완료 후 → `/kpi-framework`로 매출 지표(MRR, Churn Rate) 추적 설정
* 세금/법적 사항 확인 → `/legal-checklist`로 사업자 등록 및 법적 요건 확인
* 세금계산서 연동 필요 시 → tax-guide 스킬 참조
* 전체 진행률 확인 → `/check-progress`
WF26_EOF

# Workflow 27: pmf-measurement.md
cat << 'WF27_EOF' > "$PROJECT_ROOT/.agent/workflows/pmf-measurement.md"
# pmf-measurement

Product-Market Fit(PMF) 도달 여부를 체계적으로 측정하고 판정합니다.

> 이 워크플로우는 런칭 후 PMF를 정량적으로 측정하는 루프를 제공합니다.
> NPS 단독으로는 PMF 판정이 불충분하므로, Sean Ellis Survey + 코호트 리텐션 + 자연 성장률을 종합 분석합니다.
> `/gtm-launch` 또는 `/kpi-framework` 완료 후 실행을 권장합니다.

## 용어 매핑 (영어 → 한국어)

| 영어 | 한국어 | 설명 |
|------|--------|------|
| PMF | 제품-시장 적합성 | Product-Market Fit |
| Sean Ellis Survey | 션 엘리스 설문 | PMF 판정용 핵심 설문 (40% 룰) |
| Cohort | 코호트 | 동일 시기 가입 고객 그룹 |
| Retention | 리텐션 (잔존율) | 일정 기간 후 잔류 사용자 비율 |
| Activation | 활성화 | 사용자가 핵심 가치를 경험하는 순간 |
| Aha Moment | 아하 모먼트 | 제품 가치를 체감하는 결정적 순간 |
| NPS | 순추천지수 | Net Promoter Score |
| Churn Rate | 이탈률 | 월간 구독 취소 비율 |
| Organic Growth | 자연 성장 | 유료 광고 없이 발생하는 사용자 유입 |
| Smile Curve | 스마일 커브 | 리텐션 커브가 하락 후 반등하는 패턴 |
| Habit Loop | 습관 루프 | 트리거-행동-보상으로 구성된 반복 사용 패턴 |

## 트리거 조건
* `/gtm-launch` 또는 `/kpi-framework` 결과가 존재할 때 실행 권장
* 런칭 후 최소 2주 이상 운영 데이터가 축적되었을 때
* output/reports/ 내 기존 산출물 참조

## 수행 작업
* Sean Ellis Survey를 설계하고 PMF 40% 룰 판정을 수행합니다
* 코호트별 리텐션 테이블을 작성하고 커브 패턴을 분석합니다
* Day 1 / Day 7 / Day 30 리텐션을 추적하고 이탈 원인을 분석합니다
* 핵심 4대 지표 기반 PMF 대시보드를 구성합니다
* Pre-PMF / Post-PMF 행동 가이드를 제공합니다

## 프로세스 흐름

### Step 1: Sean Ellis Survey 실시

#### 설문 설계
* **핵심 질문**: "이 제품을 더 이상 사용할 수 없다면 어떻게 느끼시겠습니까?"
* **선택지**:
  - 매우 실망할 것이다 (Very disappointed)
  - 다소 실망할 것이다 (Somewhat disappointed)
  - 별로 상관없다 (Not disappointed)
  - 해당 없음 — 더 이상 사용하지 않음 (N/A — No longer use)

#### 실시 조건
| 항목 | 기준 |
|------|------|
| 대상 | 최근 2주 이내 2회 이상 사용한 활성 사용자 |
| 최소 응답 수 | 40명 이상 (통계적 유의미성 확보) |
| 실시 시점 | 가입 후 최소 2주, 핵심 기능 1회 이상 사용 후 |
| 반복 주기 | 월 1회 또는 주요 기능 업데이트 직후 |

#### 판정 기준
| "매우 실망" 비율 | 판정 | 행동 |
|-----------------|------|------|
| 40% 이상 | **PMF 도달** | 성장에 투자, 스케일 준비 |
| 25-39% | **PMF 근접** | 핵심 가치 강화, "다소 실망" 응답자 전환 |
| 25% 미만 | **PMF 미달** | 피벗 또는 핵심 가치 재정의 필요 |

#### 후속 질문 (선택)
* "이 제품의 주요 장점은 무엇인가요?" — 핵심 가치 파악
* "어떤 유형의 사람에게 이 제품을 추천하겠습니까?" — 타겟 고객 재정의
* "이 제품을 개선할 수 있는 방법은 무엇인가요?" — 개선 우선순위

### Step 2: 코호트 분석

#### 주간 코호트 리텐션 테이블 (템플릿)

| 코호트 | 가입자 수 | Week 1 | Week 2 | Week 3 | Week 4 | Week 8 | Week 12 |
|--------|----------|--------|--------|--------|--------|--------|---------|
| 1월 1주 | 50 | 60% | 45% | 35% | 30% | 22% | 18% |
| 1월 2주 | 65 | 62% | 48% | 38% | 32% | 25% | 20% |
| 1월 3주 | 45 | 58% | 42% | 33% | 28% | 20% | 16% |
| (실제 데이터로 교체) | — | — | — | — | — | — | — |

> 위 수치는 예시(신뢰도 C)이며, 실제 운영 데이터로 교체해야 합니다.

#### 코호트 리텐션 커브 해석

| 커브 패턴 | 형태 | 의미 | 행동 |
|----------|------|------|------|
| **스마일 커브** | 하락 후 반등 ↘↗ | PMF 신호 강함 | 활성화 퍼널 최적화 |
| **평탄 커브** | 하락 후 안정 ↘→ | PMF 가능성 있음 | 리텐션 안정 구간 강화 |
| **하락 커브** | 지속 하락 ↘↘ | PMF 미달 | 핵심 가치 재점검, 이탈 원인 분석 |
| **절벽 커브** | 급격 하락 ↓ | 심각한 문제 | 온보딩 및 첫 경험 전면 재설계 |

#### 건강한 리텐션 벤치마크

| 제품 유형 | Week 1 | Week 4 | Week 8 | Week 12 |
|----------|--------|--------|--------|---------|
| SaaS (B2B) | 70%+ | 50%+ | 30%+ | 25%+ |
| SaaS (B2C) | 50%+ | 30%+ | 20%+ | 15%+ |
| 모바일 앱 | 40%+ | 20%+ | 15%+ | 10%+ |
| 마켓플레이스 | 35%+ | 20%+ | 12%+ | 8%+ |

> 벤치마크는 업계 보고(신뢰도 B)이며, 분야별 편차가 큽니다.

### Step 3: 리텐션 추적

#### 핵심 리텐션 지표

| 지표 | 정의 | 목표 (SaaS) | 측정 방법 |
|------|------|------------|----------|
| Day 1 리텐션 | 가입 다음날 재방문 비율 | 40%+ | 이벤트 트래킹 |
| Day 7 리텐션 | 가입 7일 후 재방문 비율 | 25%+ | 이벤트 트래킹 |
| Day 30 리텐션 | 가입 30일 후 재방문 비율 | 15%+ | 이벤트 트래킹 |
| Activation Rate | Aha Moment 도달 비율 | 60%+ | 핵심 이벤트 완료율 |

#### Activation Rate 정의

Activation은 사용자가 제품의 핵심 가치를 처음 경험하는 순간입니다.

**설정 방법**:
1. 핵심 가치 행동 정의 (예: 첫 프로젝트 생성, 첫 리포트 조회)
2. "활성화된 사용자"가 그렇지 않은 사용자 대비 리텐션이 유의미하게 높은지 확인
3. 활성화 행동까지의 평균 소요 시간 측정
4. 온보딩 플로우를 활성화 행동으로 유도하도록 설계

```
Activation Rate = (핵심 행동 완료 사용자 수 / 가입자 수) × 100
목표: 60% 이상 → 온보딩 최적화 완료
```

#### 이탈 분석

| 분석 방법 | 설명 | 도구 |
|----------|------|------|
| **Exit Survey** | 이탈 시점에 짧은 설문 (1-2문항) | Typeform, 자체 모달 |
| **5 Why 분석** | 이탈 원인을 5단계로 파고듬 | 수동 분석 |
| **코호트 비교** | 잔류 vs 이탈 사용자 행동 패턴 비교 | Mixpanel, Amplitude |
| **세션 리플레이** | 이탈 전 마지막 세션 행동 관찰 | Hotjar, FullStory |

#### 리텐션 개선 레버

| 레버 | 설명 | 기대 효과 |
|------|------|----------|
| **온보딩 최적화** | 핵심 가치까지의 단계 축소 | Day 1 리텐션 10-20% 향상 |
| **Aha Moment 가속** | 가입 후 5분 내 핵심 가치 경험 | Activation Rate 향상 |
| **습관 루프 설계** | 트리거→행동→보상 사이클 구축 | Day 7+ 리텐션 향상 |
| **이탈 예방 알림** | 비활성 사용자 리인게이지먼트 | 월간 이탈률 감소 |
| **핵심 기능 강화** | "매우 실망" 응답자가 사랑하는 기능 강화 | Sean Ellis % 향상 |

### Step 4: PMF 대시보드

#### 핵심 4대 지표

| 지표 | 측정 방법 | PMF 기준 | 현재값 |
|------|----------|---------|--------|
| Sean Ellis "매우 실망" % | 설문 조사 | 40% 이상 | ___ % |
| 리텐션 커브 패턴 | 코호트 분석 | 스마일 또는 평탄 커브 | ___ |
| NPS | 추천 의향 설문 | 50 이상 | ___ |
| 자연 성장률 | 유기적 유입 비율 | 전체 가입의 30%+ | ___ % |

#### PMF 도달 종합 판정 기준표

| 등급 | 조건 | 판정 |
|------|------|------|
| **Strong PMF** | 4개 지표 모두 기준 충족 | 공격적 성장 투자 |
| **PMF 도달** | 3개 지표 기준 충족 (Sean Ellis 필수) | 성장 투자 + 미충족 지표 개선 |
| **PMF 근접** | 1-2개 지표 기준 충족 | 핵심 가치 강화 집중 |
| **PMF 미달** | 0개 지표 충족 | 피벗 검토 또는 타겟 고객 재정의 |

#### Pre-PMF vs Post-PMF 행동 가이드

| 항목 | Pre-PMF (PMF 미달/근접) | Post-PMF (PMF 도달/Strong) |
|------|------------------------|--------------------------|
| **최우선 과제** | 핵심 가치 발견 및 검증 | 성장 엔진 구축 |
| **팀 구성** | 제품 + 고객 대화 중심 | 성장 + 마케팅 팀 확대 |
| **지출 기준** | 최소 지출, 학습 극대화 | CAC < LTV/3 범위 내 지출 확대 |
| **기능 개발** | 소수 핵심 기능 깊이 강화 | 기능 확장 + 경쟁 방어 |
| **고객 확보** | 수동 확보 (1:1 영업, 커뮤니티) | 자동화된 채널 확보 |
| **측정 주기** | 주 1회 지표 리뷰 | 실시간 대시보드 모니터링 |
| **피벗 허용** | 적극적으로 피벗 검토 | 피벗 지양, 최적화 집중 |

### Step 5: PMF 측정 루프 (반복 실행)

```
[Sean Ellis Survey 실시] → [코호트 리텐션 분석] → [이탈 원인 파악]
        ↑                                                    ↓
   [지표 리뷰]  ←  [개선 실행]  ←  [개선 가설 수립]
```

**루프 주기**: 월 1회 (Pre-PMF) / 분기 1회 (Post-PMF)

## Micro-SaaS PMF (business_scale: micro/small)

idea.json의 business_scale이 "micro" 또는 "small"인 경우, 간이 PMF 측정을 수행합니다.

### 트리거 조건
* output/ideas/{id}-{name}/idea.json의 business_scale 값이 "micro" 또는 "small"일 때 자동 활성화

### 간이 PMF 판정 기준

대규모 설문이 어려운 Micro-SaaS 환경을 위한 실용적 판정 기준입니다.

| 지표 | PMF 기준 | 측정 방법 |
|------|---------|----------|
| 유료 고객 수 | 10명 이상 (자발적 결제) | Stripe Dashboard |
| 월간 이탈률 | 5% 이하 | 월초 대비 월말 구독자 |
| 자연 유입 | 존재 (광고 없이 신규 가입 발생) | Plausible, Google Analytics |
| 고객 피드백 | "없으면 곤란하다" 반응 3건+ | 이메일, 고객 대화 |

#### 간이 PMF 체크리스트
- [ ] 유료 고객 10명 이상 확보
- [ ] 최근 3개월 이탈률 5% 이하 유지
- [ ] 유료 광고 없이 자연 유입 발생
- [ ] 고객이 먼저 추천/공유한 사례 존재
- [ ] 핵심 기능에 대한 긍정적 피드백 3건 이상

**판정**: 5개 중 4개 이상 충족 시 Micro-SaaS PMF 도달로 판정

### 1인 운영 가능한 측정 도구

| 도구 | 비용 | 용도 | 설정 난이도 |
|------|------|------|-----------|
| Google Sheets | 무료 | 코호트 리텐션 추적, PMF 대시보드 | 쉬움 |
| Plausible | $9/월 | 웹 트래픽, 유입 경로 분석 | 쉬움 |
| Stripe Dashboard | 무료 | MRR, 이탈률, 유료 고객 수 | 없음 |
| Tally | 무료 | Sean Ellis Survey 실시 | 쉬움 |
| Notion | 무료 | 고객 피드백 수집, 이탈 사유 기록 | 쉬움 |

### Micro-SaaS 측정 루프 (간소화)

```
[월 1회 고객 피드백 수집] → [Stripe 이탈률 확인] → [자연 유입 추이 확인]
            ↑                                              ↓
     [다음 달 실행]  ←  [개선 1가지 실행]  ←  [핵심 문제 1개 선정]
```

## 출력 규칙
* output/reports/pmf-measurement.md에 저장합니다
* 데이터 신뢰도 등급을 명시합니다 (A 검증됨 / B 근거있는 추정 / C AI 추정)
* 실제 운영 데이터가 없는 경우 템플릿과 벤치마크(신뢰도 B/C)를 제공합니다

### 데이터 신뢰도 등급
(A 검증됨, B 근거있는 추정, C AI 추정)
> ⚠️ "PMF 판정은 정량적 지표와 정성적 피드백을 종합적으로 고려해야 합니다. 단일 지표만으로 판정하지 마세요."

## 다음 단계
* PMF 도달 판정 후 → `/kpi-framework`로 성장 지표 체계 수립
* PMF 미달 시 → `/mvp-definition`로 핵심 가치 재설계
* 고객 피드백 심화 필요 시 → NPS 설문 템플릿 활용
* 전체 진행률 확인 → `/check-progress`
* 운영 비용 추적 필요 시 → `/tco-dashboard`로 TCO 분석
WF27_EOF

# Workflow 28: ai-builder.md
cat << 'WF28_EOF' > "$PROJECT_ROOT/.agent/workflows/ai-builder.md"
# ai-builder

AI 코딩 도구(Cursor, Bolt, v0, Lovable 등)를 활용하여 MVP를 직접 구현하는 가이드를 제공합니다.

> 이 워크플로우는 ABP 산출물(MVP 정의, Lean Canvas, 페르소나)을 AI 코딩 도구의 입력으로 변환합니다.
> /mvp-definition 또는 /lean-canvas 완료 후 실행을 권장합니다.

## 트리거 조건
* /mvp-definition 또는 /lean-canvas 결과가 존재할 때 실행 권장
* output/ideas/{id}-{name}/ 내 산출물 참조

## 용어 매핑 (영어 → 한국어)

| 영어 | 한국어 | 설명 |
|------|--------|------|
| AI Coding Tool | AI 코딩 도구 | 자연어로 코드를 생성하는 도구 (Cursor, Bolt 등) |
| Prompt Engineering | 프롬프트 엔지니어링 | AI에게 정확한 지시를 내리는 기술 |
| Scaffold | 스캐폴드 | 프로젝트 초기 구조/뼈대 |
| Tech Stack | 기술 스택 | 프로젝트에 사용하는 기술 조합 |
| Boilerplate | 보일러플레이트 | 반복적으로 사용하는 기본 코드 템플릿 |
| Component | 컴포넌트 | 재사용 가능한 UI 구성 요소 |
| Deployment | 배포 | 코드를 서버에 올려 서비스하는 과정 |
| Version Control | 버전 관리 | 코드 변경 이력을 추적하는 시스템 (Git) |

## 수행 작업
* ABP 산출물에서 AI 코딩 도구 입력용 프롬프트를 생성합니다
* 기술 스택 추천 및 프로젝트 구조를 설계합니다
* AI 코딩 도구별 최적 워크플로우를 안내합니다
* MVP 핵심 기능별 구현 순서를 제안합니다
* 코드 품질 체크리스트를 제공합니다

## 출력 규칙
* output/reports/ai-builder.md에 저장합니다

### 데이터 신뢰도 등급
(A 검증됨, B 근거있는 추정, C AI 추정)
> ⚠️ "AI 코딩 도구의 기능과 가격은 빠르게 변동됩니다. 공식 사이트에서 최신 정보를 확인하세요."

## 다음 단계
* MVP 구현 완료 후 → \`/deploy-guide\`로 배포
* 스펙 변환 필요 시 → export-spec 스킬 활용
* 전체 진행률 확인 → \`/check-progress\`
WF28_EOF

# Workflow 29: deploy-guide.md
cat << 'WF29_EOF' > "$PROJECT_ROOT/.agent/workflows/deploy-guide.md"
# deploy-guide

1인 빌더를 위한 첫 배포부터 운영까지 안내하는 배포 가이드입니다.

> 이 워크플로우는 MVP를 실제 서비스로 배포하고, CI/CD 파이프라인과 비용 관리까지 한 번에 설정합니다.
> /ai-builder 또는 /mvp-definition 완료 후 실행을 권장합니다.

## 트리거 조건
* /ai-builder 또는 /mvp-definition 결과가 존재할 때 실행 권장
* 배포 가능한 코드가 준비되었을 때

## 용어 매핑 (영어 → 한국어)

| 영어 | 한국어 | 설명 |
|------|--------|------|
| CI/CD | 지속적 통합/배포 | Continuous Integration / Continuous Deployment |
| PaaS | 플랫폼 서비스 | Platform as a Service (Vercel, Railway 등) |
| Container | 컨테이너 | 앱을 격리된 환경에서 실행하는 기술 (Docker) |
| CDN | 콘텐츠 전송 네트워크 | 전 세계에 콘텐츠를 빠르게 전달하는 네트워크 |
| SSL | 보안 인증서 | 웹사이트 HTTPS 암호화 |
| DNS | 도메인 네임 시스템 | 도메인 주소를 IP로 변환하는 시스템 |
| Uptime | 가동률 | 서비스가 정상 작동하는 시간 비율 |
| Rollback | 롤백 | 문제 발생 시 이전 버전으로 되돌리기 |

## 수행 작업
* 호스팅 플랫폼 선택 트리를 제공합니다
* CI/CD 파이프라인 설정을 안내합니다
* 도메인 및 SSL 설정을 안내합니다
* 월간 비용 예측 및 최적화를 제안합니다
* 배포 체크리스트를 제공합니다

## 출력 규칙
* output/reports/deploy-guide.md에 저장합니다

### 데이터 신뢰도 등급
(A 검증됨, B 근거있는 추정, C AI 추정)
> ⚠️ "호스팅 비용은 사용량에 따라 변동됩니다. 무료 티어 한도를 반드시 확인하세요."

## 다음 단계
* 배포 완료 후 → \`/growth-loop\`로 성장 루프 구축
* GTM 전략 필요 시 → \`/gtm-launch\`
* 전체 진행률 확인 → \`/check-progress\`
WF29_EOF

# Workflow 30: growth-loop.md
cat << 'WF30_EOF' > "$PROJECT_ROOT/.agent/workflows/growth-loop.md"
# growth-loop

출시 후 성장 루프(텔레메트리 + 피드백 + KPI)를 구축하여 데이터 기반 제품 개선 사이클을 운영합니다.

> 이 워크플로우는 런칭 후 사용자 행동 데이터를 수집·분석하고, 피드백을 체계화하여 지속적 성장을 이끄는 루프를 설계합니다.
> /gtm-launch 또는 /deploy-guide 완료 후 실행을 권장합니다.

> **안전 면책**: 분석 도구 설치 시 개인정보보호법을 준수해야 합니다. 사용자 동의 없는 데이터 수집은 법적 문제를 야기할 수 있습니다.

## 트리거 조건
* /gtm-launch 또는 /deploy-guide 완료 후 실행 권장
* output/reports/ 내 기존 산출물 참조

## 용어 매핑 (영어 → 한국어)

| 영어 | 한국어 | 설명 |
|------|--------|------|
| Telemetry | 텔레메트리 | 제품 사용 데이터를 자동 수집·전송하는 체계 |
| Event Schema | 이벤트 스키마 | 사용자 행동 데이터의 구조 정의 |
| Funnel | 퍼널 | 사용자가 목표 행동까지 거치는 단계별 흐름 |
| A/B Test | A/B 테스트 | 두 가지 변형을 비교하여 더 나은 성과를 찾는 실험 |
| NPS | 순추천지수 | Net Promoter Score |
| DAU/WAU/MAU | 일간/주간/월간 활성 사용자 | Daily/Weekly/Monthly Active Users |
| Cohort | 코호트 | 동일 시기 가입 고객 그룹 |
| Feature Flag | 기능 플래그 | 코드 변경 없이 기능을 켜고 끌 수 있는 토글 |
| Session Replay | 세션 리플레이 | 사용자의 실제 사용 과정을 영상처럼 재현 |
| Heatmap | 히트맵 | 사용자 상호작용을 시각화한 지도 |
| GDPR | 일반 데이터 보호 규정 | EU 개인정보보호 규정 |
| Cookie Consent | 쿠키 동의 | 쿠키 사용에 대한 사전 동의 절차 |

## 수행 작업
* 분석 도구를 선택하고 설치합니다 (PostHog, Amplitude, GA4, Plausible, Mixpanel)
* 이벤트 스키마를 설계합니다
* 피드백 수집 체계를 구축합니다 (NPS, Tally/Typeform)
* KPI 대시보드를 연동합니다 (/kpi-framework, /pmf-measurement)
* 성장 루프를 운영하고 반복합니다

## 출력 규칙
* output/reports/growth-loop.md에 저장합니다

### 데이터 신뢰도 등급
(A 검증됨, B 근거있는 추정, C AI 추정)
> ⚠️ "분석 도구 비교 정보는 2024-2025 기준(신뢰도 B)이며, 최신 가격/기능은 공식 사이트에서 확인하세요."

## 다음 단계
* 리텐션 심화 분석 → \`/pmf-measurement\`
* 성과 지표 체계 → \`/kpi-framework\`
* 1인 운영 지속가능성 → \`/solo-sustainability\`
* 전체 진행률 확인 → \`/check-progress\`
WF30_EOF

# --- Step 5: Create Skills ---
echo -e "${BLUE}[5/10]${NC} 스킬 (Skills) 생성 중..."

# Skill 1: business-researcher/SKILL.md
cat << 'SK1_EOF' > "$PROJECT_ROOT/.agent/skills/business-researcher/SKILL.md"
---
name: business-researcher
description: 시장 조사, 산업 분석, 경쟁사 조사를 수행합니다. 사업 기획에 필요한 데이터를 웹에서 수집하고 구조화된 보고서로 정리합니다.
---

# Business Researcher Skill

당신은 전문 비즈니스 리서처입니다. 사업 기획에 필요한 시장 데이터를 체계적으로 조사합니다.

## 역할
- 시장 규모, 성장률, 트렌드를 조사합니다
- 경쟁사 정보를 수집하고 분석합니다
- 고객 세그먼트를 파악합니다
- 산업 보고서와 통계를 검색합니다

## 조사 프로세스
1. 사용자의 사업 아이디어와 목표 시장을 파악합니다
2. 브라우저를 활용하여 관련 데이터를 수집합니다
3. 한국 시장 데이터를 우선으로 검색합니다 (통계청, KOSIS, 산업연구원 등)
4. 데이터를 분석하고 인사이트를 도출합니다
5. 구조화된 보고서를 작성합니다

## 출력 규칙
- 모든 데이터에 출처를 명시합니다
- 데이터 수집 날짜를 기록합니다
- 검증되지 않은 정보는 "추정" 또는 "미확인"으로 표기합니다
- 결과물은 `output/research/` 폴더에 저장합니다

## 참고 데이터 소스
- 통계청 (kostat.go.kr)
- KOSIS 국가통계포털
- 한국산업연구원
- 중소벤처기업부
- 소상공인시장진흥공단
- 업종별 협회/단체
SK1_EOF

# Skill 2: financial-analyst/SKILL.md
cat << 'SK2_EOF' > "$PROJECT_ROOT/.agent/skills/financial-analyst/SKILL.md"
---
name: financial-analyst
description: 재무 분석, 원가 계산, 손익 예측을 수행합니다. 스프레드시트 형태의 재무 모델을 생성하고, 시나리오별 분석을 제공합니다.
---

# Financial Analyst Skill

당신은 전문 재무 분석가입니다. 사업의 재무적 타당성을 분석합니다.

## 역할
- 초기 투자 비용을 산출합니다
- 매출/비용 예측 모델을 만듭니다
- 손익분기점을 계산합니다
- 시나리오별 재무 분석을 수행합니다

## 분석 프로세스
1. 사업의 비용 구조를 파악합니다 (고정비/변동비)
2. 매출 가정(assumptions)을 설정합니다
3. 월별 손익계산서를 작성합니다
4. 3개년 추정 재무제표를 작성합니다
5. 낙관/기본/비관 시나리오를 분석합니다

## 계산 도구
- 복잡한 계산은 `scripts/calculate_costs.py`를 먼저 `--help`로 확인 후 활용합니다
- 표 형식으로 깔끔하게 정리합니다

## 출력 규칙
- 모든 수치는 마크다운 표로 정리합니다
- 단위(원, %, 개)를 명확히 표기합니다
- 가정(assumptions)을 문서 상단에 명시합니다
- "이 수치는 추정치이며 실제와 다를 수 있습니다"를 포함합니다
- 결과물은 `output/financials/` 폴더에 저장합니다
SK2_EOF

# Skill 2 script: financial-analyst/scripts/calculate_costs.py
cat << 'SK2PY_EOF' > "$PROJECT_ROOT/.agent/skills/financial-analyst/scripts/calculate_costs.py"
#!/usr/bin/env python3
"""
Business Financial Calculator

Usage:
    python calculate_costs.py --help
    python calculate_costs.py bep --fixed 5000000 --price 15000 --variable 8000
    python calculate_costs.py margin --cost 8000 --price 15000
    python calculate_costs.py monthly --revenue 30000000 --fixed 15000000 --variable-rate 0.45
"""

import argparse
import json
import sys


def calculate_bep(fixed_costs: float, price: float, variable_cost: float) -> dict:
    """Calculate Break-Even Point"""
    contribution_margin = price - variable_cost
    if contribution_margin <= 0:
        return {"error": "Variable cost exceeds or equals price"}
    bep_units = fixed_costs / contribution_margin
    bep_revenue = bep_units * price
    return {
        "fixed_costs": fixed_costs,
        "price_per_unit": price,
        "variable_cost_per_unit": variable_cost,
        "contribution_margin": contribution_margin,
        "bep_units": round(bep_units, 1),
        "bep_revenue": round(bep_revenue, 0),
        "margin_ratio": round(contribution_margin / price * 100, 1),
    }


def calculate_margin(cost: float, price: float) -> dict:
    """Calculate profit margins"""
    gross_profit = price - cost
    margin_pct = (gross_profit / price) * 100
    markup_pct = (gross_profit / cost) * 100
    return {
        "cost": cost,
        "price": price,
        "gross_profit": gross_profit,
        "margin_percent": round(margin_pct, 1),
        "markup_percent": round(markup_pct, 1),
        "cost_ratio": round((cost / price) * 100, 1),
    }


def calculate_monthly_pl(revenue: float, fixed: float, variable_rate: float) -> dict:
    """Calculate monthly P&L"""
    variable = revenue * variable_rate
    gross_profit = revenue - variable
    operating_profit = gross_profit - fixed
    return {
        "revenue": revenue,
        "variable_costs": round(variable, 0),
        "gross_profit": round(gross_profit, 0),
        "gross_margin": round((gross_profit / revenue) * 100, 1) if revenue > 0 else 0,
        "fixed_costs": fixed,
        "operating_profit": round(operating_profit, 0),
        "operating_margin": round((operating_profit / revenue) * 100, 1) if revenue > 0 else 0,
        "status": "profit" if operating_profit > 0 else "loss",
    }


def main():
    parser = argparse.ArgumentParser(description="Business Financial Calculator")
    subparsers = parser.add_subparsers(dest="command", help="Available calculations")

    bep_parser = subparsers.add_parser("bep", help="Break-Even Point calculation")
    bep_parser.add_argument("--fixed", type=float, required=True, help="Monthly fixed costs (KRW)")
    bep_parser.add_argument("--price", type=float, required=True, help="Price per unit (KRW)")
    bep_parser.add_argument("--variable", type=float, required=True, help="Variable cost per unit (KRW)")

    margin_parser = subparsers.add_parser("margin", help="Profit margin calculation")
    margin_parser.add_argument("--cost", type=float, required=True, help="Cost per unit (KRW)")
    margin_parser.add_argument("--price", type=float, required=True, help="Selling price (KRW)")

    monthly_parser = subparsers.add_parser("monthly", help="Monthly P&L calculation")
    monthly_parser.add_argument("--revenue", type=float, required=True, help="Monthly revenue (KRW)")
    monthly_parser.add_argument("--fixed", type=float, required=True, help="Monthly fixed costs (KRW)")
    monthly_parser.add_argument("--variable-rate", type=float, required=True, help="Variable cost ratio (0-1)")

    args = parser.parse_args()

    if args.command == "bep":
        result = calculate_bep(args.fixed, args.price, args.variable)
    elif args.command == "margin":
        result = calculate_margin(args.cost, args.price)
    elif args.command == "monthly":
        result = calculate_monthly_pl(args.revenue, args.fixed, args.variable_rate)
    else:
        parser.print_help()
        sys.exit(0)

    print(json.dumps(result, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
SK2PY_EOF
chmod +x "$PROJECT_ROOT/.agent/skills/financial-analyst/scripts/calculate_costs.py"

# Skill 3: report-writer/SKILL.md
cat << 'SK3_EOF' > "$PROJECT_ROOT/.agent/skills/report-writer/SKILL.md"
---
name: report-writer
description: 사업계획서, 제안서, 보고서를 전문적인 한국어로 작성합니다. 템플릿 기반으로 구조화된 비즈니스 문서를 생성합니다.
---

# Report Writer Skill

당신은 전문 비즈니스 문서 작성자입니다. 한국 비즈니스 관행에 맞는 격식 있는 문서를 작성합니다.

## 역할
- 사업계획서, 투자 제안서, 분석 보고서를 작성합니다
- 기존 분석 결과를 통합하여 종합 문서를 만듭니다
- templates/ 폴더의 템플릿을 참고하여 일관된 형식을 유지합니다

## 작성 원칙
1. 문서 시작에 핵심 요약 (Executive Summary)을 반드시 포함합니다
2. 각 섹션은 명확한 헤더와 논리적 흐름을 갖습니다
3. 데이터와 분석 결과는 표, 목록으로 시각화합니다
4. 전문적이되 읽기 쉬운 한국어를 사용합니다
5. 실행 가능한 다음 단계(Next Steps)를 항상 포함합니다

## 문서 유형별 가이드
- **사업계획서**: templates/business-plan-template.md 참조
- **재무 보고서**: templates/financial-projection-template.md 참조
- **시장 분석**: templates/market-analysis-template.md 참조
- **피치덱**: templates/pitch-deck-outline.md 참조

## 기존 자료 활용
- output/research/ — 시장 조사 결과
- output/financials/ — 재무 분석 결과
- output/reports/ — 기존 보고서

## 출력 규칙
- 결과물은 `output/reports/` 폴더에 저장합니다
- 파일명은 날짜_문서유형.md 형식 (예: 2026-02-08_사업계획서.md)
SK3_EOF

# Skill 4: pitch-deck-creator/SKILL.md
cat << 'SK4_EOF' > "$PROJECT_ROOT/.agent/skills/pitch-deck-creator/SKILL.md"
---
name: pitch-deck-creator
description: 투자자용 피치덱(발표자료)의 구조, 내용, 스피커 노트를 생성합니다. 10-15 슬라이드 구성으로 핵심 메시지를 전달합니다.
---

# Pitch Deck Creator Skill

당신은 스타트업 피치덱 전문가입니다. 투자자를 설득할 수 있는 발표 자료의 내용을 구성합니다.

## 표준 슬라이드 구성 (10-15장)

1. **표지** — 사업명, 한 줄 설명, 로고
2. **문제 정의** — 해결하려는 문제/페인포인트
3. **솔루션** — 우리의 해결 방법
4. **시장 기회** — TAM/SAM/SOM, 시장 규모
5. **비즈니스 모델** — 수익 구조, 가격 전략
6. **경쟁 우위** — 차별화 포인트, 진입 장벽
7. **트랙션** — 현재까지의 성과, 검증 데이터
8. **마케팅 전략** — 고객 확보 전략, 채널
9. **재무 계획** — 3개년 매출/이익 전망, BEP
10. **팀 소개** — 핵심 멤버, 경험, 역량
11. **로드맵** — 향후 12-18개월 계획
12. **투자 요청** — 필요 금액, 사용 계획, 기대 성과

## 작성 원칙
- 각 슬라이드의 **핵심 메시지**를 한 문장으로 정리합니다
- **데이터와 수치**를 적극 활용합니다
- **스피커 노트**를 각 슬라이드에 포함합니다
- 스토리텔링 흐름을 유지합니다 (문제 → 솔루션 → 증거 → 미래)

## 기존 자료 활용
- output/research/ — 시장 데이터
- output/financials/ — 재무 수치

## 출력 규칙
- 슬라이드별 제목, 내용, 스피커 노트를 구분하여 작성합니다
- 결과물은 `output/presentations/` 폴더에 저장합니다
SK4_EOF

# Skill 5: swot-analyzer/SKILL.md
cat << 'SK5_EOF' > "$PROJECT_ROOT/.agent/skills/swot-analyzer/SKILL.md"
---
name: swot-analyzer
description: SWOT 분석, PESTEL 분석, Porter's Five Forces 등 전략 프레임워크를 활용한 체계적 분석을 수행합니다.
---

# SWOT Analyzer Skill

당신은 전략 분석 전문가입니다. 다양한 비즈니스 프레임워크를 활용하여 체계적인 분석을 수행합니다.

## 지원 프레임워크

### 1. SWOT 분석
| | 유리한 요소 | 불리한 요소 |
|---|---|---|
| **내부** | 강점 (Strengths) | 약점 (Weaknesses) |
| **외부** | 기회 (Opportunities) | 위협 (Threats) |

### 2. PESTEL 분석
- **P**olitical (정치적) — 정부 정책, 규제
- **E**conomic (경제적) — 경기, 환율, 금리
- **S**ocial (사회적) — 인구 트렌드, 문화
- **T**echnological (기술적) — 기술 변화, 혁신
- **E**nvironmental (환경적) — 환경 규제, 지속가능성
- **L**egal (법률적) — 법규, 규제 변화

### 3. Porter's Five Forces
- 기존 경쟁자 간 경쟁 강도
- 새로운 진입자의 위협
- 대체재의 위협
- 공급자의 교섭력
- 구매자의 교섭력

### 4. Business Model Canvas
- 핵심 파트너, 핵심 활동, 핵심 자원
- 가치 제안
- 고객 관계, 채널, 고객 세그먼트
- 비용 구조, 수익원

## 분석 프로세스
1. 사용자의 사업/아이디어를 파악합니다
2. 적합한 프레임워크를 선택하거나 추천합니다
3. 각 요소를 체계적으로 분석합니다
4. 전략적 시사점을 도출합니다
5. 구체적인 액션 아이템을 제안합니다

## 출력 규칙
- 프레임워크 형태(표, 매트릭스)로 시각화합니다
- 각 항목에 구체적인 근거를 제시합니다
- 결과물은 `output/research/` 폴더에 저장합니다
SK5_EOF

# Skill 6: data-visualizer/SKILL.md
cat << 'SK6_EOF' > "$PROJECT_ROOT/.agent/skills/data-visualizer/SKILL.md"
---
name: data-visualizer
description: 사업 데이터를 차트와 그래프로 시각화합니다. 매출 추이, 시장 점유율, 비용 구조, 성장 전망 등을 시각적으로 표현합니다.
---

# Data Visualizer Skill

당신은 비즈니스 데이터 시각화 전문가입니다. 복잡한 데이터를 이해하기 쉬운 차트로 변환합니다.

## 지원 차트 유형
- **막대 차트** — 항목 비교 (경쟁사 비교, 카테고리별 매출)
- **선 차트** — 시간별 추이 (월별 매출, 성장률)
- **파이 차트** — 구성 비율 (비용 구조, 시장 점유율)
- **스택 바** — 항목별 구성 (원가 구성, 매출 구성)
- **워터폴** — 증감 분석 (손익 분석)

## 사용 방법
1. 시각화할 데이터를 파악합니다
2. 적합한 차트 유형을 선택합니다
3. `scripts/create_chart.py`를 `--help`로 확인합니다
4. 차트를 생성하고 저장합니다

## 출력 규칙
- 차트에 한국어 제목과 레이블을 사용합니다
- 단위(원, %, 명 등)를 명확히 표기합니다
- PNG 형식으로 `output/` 하위 폴더에 저장합니다
- 차트 아래에 핵심 인사이트를 텍스트로 요약합니다
SK6_EOF

# Skill 6 script: data-visualizer/scripts/create_chart.py
cat << 'SK6PY_EOF' > "$PROJECT_ROOT/.agent/skills/data-visualizer/scripts/create_chart.py"
#!/usr/bin/env python3
"""
Business Data Chart Generator

Usage:
    python create_chart.py --help
    python create_chart.py bar --title "월별 매출" --labels "1월,2월,3월" --values "1000,1500,2000" --output chart.png
    python create_chart.py pie --title "비용 구조" --labels "인건비,재료비,임대료,기타" --values "40,30,20,10" --output costs.png
    python create_chart.py line --title "매출 추이" --labels "1월,2월,3월,4월" --values "1000,1200,1800,2500" --output trend.png
"""

import argparse
import sys

try:
    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt
    import matplotlib.font_manager as fm
except ImportError:
    print("Error: matplotlib is required. Install with: pip install matplotlib")
    sys.exit(1)


# Configure Korean font support
def setup_korean_font():
    """Try to set up Korean font"""
    korean_fonts = ['AppleGothic', 'NanumGothic', 'Malgun Gothic', 'NanumBarunGothic']
    for font_name in korean_fonts:
        try:
            fm.findfont(font_name, fallback_to_default=False)
            plt.rcParams['font.family'] = font_name
            plt.rcParams['axes.unicode_minus'] = False
            return
        except Exception:
            continue
    print("Warning: Korean font not found. Text may not display correctly.")


def create_bar_chart(title, labels, values, output, ylabel="금액 (만원)"):
    setup_korean_font()
    fig, ax = plt.subplots(figsize=(10, 6))
    colors = ['#4285F4', '#EA4335', '#FBBC05', '#34A853', '#FF6D01', '#46BDC6']
    bars = ax.bar(labels, values, color=colors[:len(labels)])
    ax.set_title(title, fontsize=16, fontweight='bold', pad=20)
    ax.set_ylabel(ylabel)
    for bar, val in zip(bars, values):
        ax.text(bar.get_x() + bar.get_width()/2., bar.get_height(),
                f'{val:,.0f}', ha='center', va='bottom', fontweight='bold')
    plt.tight_layout()
    plt.savefig(output, dpi=150, bbox_inches='tight')
    print(f"Chart saved: {output}")


def create_pie_chart(title, labels, values, output):
    setup_korean_font()
    fig, ax = plt.subplots(figsize=(8, 8))
    colors = ['#4285F4', '#EA4335', '#FBBC05', '#34A853', '#FF6D01', '#46BDC6']
    ax.pie(values, labels=labels, autopct='%1.1f%%', startangle=90,
           colors=colors[:len(labels)], textprops={'fontsize': 12})
    ax.set_title(title, fontsize=16, fontweight='bold', pad=20)
    plt.tight_layout()
    plt.savefig(output, dpi=150, bbox_inches='tight')
    print(f"Chart saved: {output}")


def create_line_chart(title, labels, values, output, ylabel="금액 (만원)"):
    setup_korean_font()
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.plot(labels, values, 'o-', color='#4285F4', linewidth=2, markersize=8)
    ax.fill_between(range(len(labels)), values, alpha=0.1, color='#4285F4')
    ax.set_title(title, fontsize=16, fontweight='bold', pad=20)
    ax.set_ylabel(ylabel)
    ax.grid(True, alpha=0.3)
    for i, val in enumerate(values):
        ax.annotate(f'{val:,.0f}', (i, val), textcoords="offset points",
                    xytext=(0, 10), ha='center', fontweight='bold')
    plt.tight_layout()
    plt.savefig(output, dpi=150, bbox_inches='tight')
    print(f"Chart saved: {output}")


def main():
    parser = argparse.ArgumentParser(description="Business Data Chart Generator")
    subparsers = parser.add_subparsers(dest="chart_type", help="Chart type")

    for chart_type in ["bar", "pie", "line"]:
        sub = subparsers.add_parser(chart_type, help=f"{chart_type} chart")
        sub.add_argument("--title", required=True, help="Chart title")
        sub.add_argument("--labels", required=True, help="Comma-separated labels")
        sub.add_argument("--values", required=True, help="Comma-separated values")
        sub.add_argument("--output", required=True, help="Output file path")
        if chart_type != "pie":
            sub.add_argument("--ylabel", default="금액 (만원)", help="Y-axis label")

    args = parser.parse_args()
    if not args.chart_type:
        parser.print_help()
        sys.exit(0)

    labels = [l.strip() for l in args.labels.split(",")]
    values = [float(v.strip()) for v in args.values.split(",")]

    if args.chart_type == "bar":
        create_bar_chart(args.title, labels, values, args.output, getattr(args, 'ylabel', '금액 (만원)'))
    elif args.chart_type == "pie":
        create_pie_chart(args.title, labels, values, args.output)
    elif args.chart_type == "line":
        create_line_chart(args.title, labels, values, args.output, getattr(args, 'ylabel', '금액 (만원)'))


if __name__ == "__main__":
    main()
SK6PY_EOF
chmod +x "$PROJECT_ROOT/.agent/skills/data-visualizer/scripts/create_chart.py"

# Skill 7: progress-tracker/SKILL.md
cat << 'SK7_EOF' > "$PROJECT_ROOT/.agent/skills/progress-tracker/SKILL.md"
---
name: progress-tracker
description: 사업 기획 진행률을 확인합니다. 8단계 기획 프로세스의 각 단계별 완료 여부와 전체 진행률을 표시합니다.
---

# Progress Tracker Skill

당신은 사업 기획 진행률 관리자입니다. 사용자의 기획 진행 상황을 추적하고 보고합니다.

## 역할
- output/ 폴더를 스캔하여 각 단계별 산출물 존재 여부를 확인합니다
- 8단계 기획 프로세스 기준으로 완료율을 계산합니다
- 다음 단계를 안내합니다

## 추적 기준
1. 시장 조사 — output/research/ 내 시장 관련 파일
2. 경쟁 분석 — output/research/ 내 경쟁 관련 파일
3. 제품/서비스 기획 — output/financials/ 내 원가 관련 파일
4. 재무 모델링 — output/financials/ 내 재무 관련 파일
5. 운영 계획 — output/reports/ 내 운영 관련 파일
6. 브랜딩 전략 — output/reports/ 내 브랜딩 관련 파일
7. 법률 체크리스트 — output/reports/ 내 법률 관련 파일
8. 사업계획서 — output/reports/ 내 사업계획서 파일

## 사용 방법
- scripts/check_progress.py를 먼저 --help로 확인 후 실행합니다
- 결과를 사용자에게 보기 좋게 정리하여 안내합니다

## 출력 규칙
- 완료된 단계는 ✅, 미완료는 ⬜ 로 표시합니다
- 전체 진행률을 % 로 표시합니다
- 다음으로 진행해야 할 단계를 추천합니다
SK7_EOF

# Skill 7 script: progress-tracker/scripts/check_progress.py
cat << 'SK7PY_EOF' > "$PROJECT_ROOT/.agent/skills/progress-tracker/scripts/check_progress.py"
#!/usr/bin/env python3
"""
사업 기획 진행률 추적 스크립트

8단계 기획 프로세스의 진행 상황을 output/ 디렉토리를 기반으로 추적합니다.
멀티 아이디어 포트폴리오 모드를 지원합니다.
"""

import argparse
import json
import os
import re
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Tuple


class ProgressTracker:
    """사업 기획 진행률 추적기"""

    # Stage 0 (조건부) + 8단계 기획 프로세스 정의
    STAGE_0 = {
        "id": 0,
        "name": "아이디어 발굴",
        "directory": "output/ideas",
        "keywords": ["idea", "아이디어", "selected"],
    }

    STAGES = [
        {
            "id": 1,
            "name": "시장 조사",
            "directory": "output/research",
            "keywords": ["시장", "market"],
        },
        {
            "id": 2,
            "name": "경쟁 분석",
            "directory": "output/research",
            "keywords": ["경쟁", "competitor"],
        },
        {
            "id": 3,
            "name": "제품/원가",
            "directory": "output/financials",
            "keywords": ["원가", "menu", "costing"],
        },
        {
            "id": 4,
            "name": "재무 모델",
            "directory": "output/financials",
            "keywords": ["재무", "financial", "손익"],
        },
        {
            "id": 5,
            "name": "운영 계획",
            "directory": "output/reports",
            "keywords": ["운영", "operation"],
        },
        {
            "id": 6,
            "name": "브랜딩",
            "directory": "output/reports",
            "keywords": ["브랜딩", "brand", "마케팅"],
        },
        {
            "id": 7,
            "name": "법률/인허가",
            "directory": "output/reports",
            "keywords": ["법률", "legal", "인허가"],
        },
        {
            "id": 8,
            "name": "사업계획서",
            "directory": "output/reports",
            "keywords": ["사업계획", "business-plan"],
        },
    ]

    # Idea-local stage definitions (directory relative to idea folder)
    IDEA_STAGE_0_FILES = ["hypothesis.md", "evaluation.md"]

    IDEA_STAGES = [
        {
            "id": 1,
            "name": "시장 조사",
            "directory": "research",
            "keywords": ["시장", "market"],
        },
        {
            "id": 2,
            "name": "경쟁 분석",
            "directory": "research",
            "keywords": ["경쟁", "competitor"],
        },
        {
            "id": 3,
            "name": "제품/원가",
            "directory": "financials",
            "keywords": ["원가", "menu", "costing"],
        },
        {
            "id": 4,
            "name": "재무 모델",
            "directory": "financials",
            "keywords": ["재무", "financial", "손익"],
        },
        {
            "id": 5,
            "name": "운영 계획",
            "directory": "reports",
            "keywords": ["운영", "operation"],
        },
        {
            "id": 6,
            "name": "브랜딩",
            "directory": "reports",
            "keywords": ["브랜딩", "brand", "마케팅"],
        },
        {
            "id": 7,
            "name": "법률/인허가",
            "directory": "reports",
            "keywords": ["법률", "legal", "인허가"],
        },
        {
            "id": 8,
            "name": "사업계획서",
            "directory": "reports",
            "keywords": ["사업계획", "business-plan"],
        },
    ]

    def __init__(self, project_dir: str):
        """
        Args:
            project_dir: 프로젝트 루트 디렉토리 경로
        """
        self.project_dir = Path(project_dir).resolve()

    def check_stage(self, stage: Dict) -> Tuple[bool, List[str]]:
        """
        특정 단계의 완료 여부를 확인합니다.

        Args:
            stage: 단계 정의 딕셔너리

        Returns:
            (완료 여부, 발견된 파일 리스트)
        """
        directory = self.project_dir / stage["directory"]

        if not directory.exists():
            return False, []

        found_files = []
        keywords = stage["keywords"]

        # 디렉토리 내 모든 파일 검색
        for file_path in directory.rglob("*"):
            if file_path.is_file():
                filename_lower = file_path.name.lower()
                # 키워드 매칭
                if any(keyword.lower() in filename_lower for keyword in keywords):
                    found_files.append(str(file_path.relative_to(self.project_dir)))

        return len(found_files) > 0, found_files

    def has_ideas(self) -> bool:
        """
        output/ideas/ 디렉토리에 .gitkeep 외 파일이 있는지 확인합니다.

        Returns:
            아이디어 파일 존재 여부
        """
        ideas_dir = self.project_dir / "output" / "ideas"
        if not ideas_dir.exists():
            return False
        for file_path in ideas_dir.rglob("*"):
            if file_path.is_file() and file_path.name != ".gitkeep":
                return True
        return False

    def check_all_stages(self) -> Dict:
        """
        모든 단계의 진행 상황을 확인합니다.
        output/ideas/에 파일이 있으면 Stage 0을 포함합니다.

        Returns:
            진행률 정보를 담은 딕셔너리
        """
        results = []
        completed_count = 0
        include_stage_0 = self.has_ideas()

        # Stage 0: 조건부 표시 (output/ideas/에 파일이 있을 때만)
        if include_stage_0:
            is_completed, files = self.check_stage(self.STAGE_0)
            if is_completed:
                completed_count += 1
            results.append({
                "id": self.STAGE_0["id"],
                "name": self.STAGE_0["name"],
                "completed": is_completed,
                "files": files,
            })

        for stage in self.STAGES:
            is_completed, files = self.check_stage(stage)

            if is_completed:
                completed_count += 1

            results.append({
                "id": stage["id"],
                "name": stage["name"],
                "completed": is_completed,
                "files": files,
            })

        total_stages = len(self.STAGES) + (1 if include_stage_0 else 0)
        percentage = (completed_count / total_stages * 100) if total_stages > 0 else 0

        return {
            "total_stages": total_stages,
            "completed_stages": completed_count,
            "percentage": round(percentage, 1),
            "stages": results,
            "includes_stage_0": include_stage_0,
        }

    def get_next_stage(self, progress: Dict) -> Dict | None:
        """
        다음으로 진행해야 할 단계를 추천합니다.

        Args:
            progress: check_all_stages()의 반환값

        Returns:
            다음 단계 정보 또는 None (모두 완료된 경우)
        """
        for stage in progress["stages"]:
            if not stage["completed"]:
                return stage
        return None

    def print_progress_bar(self, percentage: float, width: int = 40) -> str:
        """
        텍스트 기반 프로그레스 바를 생성합니다.

        Args:
            percentage: 진행률 (0-100)
            width: 바의 너비

        Returns:
            프로그레스 바 문자열
        """
        filled = int(width * percentage / 100)
        bar = "█" * filled + "░" * (width - filled)
        return f"[{bar}] {percentage:.1f}%"

    def print_text_report(self, progress: Dict):
        """
        텍스트 형식으로 진행 상황을 출력합니다.

        Args:
            progress: check_all_stages()의 반환값
        """
        print("\n" + "=" * 60)
        print("📊 사업 기획 진행률 리포트")
        print("=" * 60 + "\n")

        # 전체 진행률
        print(f"전체 진행률: {progress['completed_stages']}/{progress['total_stages']} 단계 완료")
        print(self.print_progress_bar(progress["percentage"]))
        print()

        # 각 단계별 상태
        print("단계별 현황:")
        print("-" * 60)

        for stage in progress["stages"]:
            status = "✅" if stage["completed"] else "⬜"
            print(f"{status} {stage['id']}. {stage['name']}")

            if stage["completed"] and stage["files"]:
                print(f"   📁 발견된 파일: {len(stage['files'])}개")
                for file in stage["files"][:3]:  # 최대 3개까지만 표시
                    print(f"      - {file}")
                if len(stage["files"]) > 3:
                    print(f"      ... 외 {len(stage['files']) - 3}개")
            print()

        # 다음 단계 추천
        print("-" * 60)
        next_stage = self.get_next_stage(progress)

        if next_stage:
            stage_id = next_stage['id']
            if stage_id == 0:
                print(f"💡 다음 단계: {stage_id}. {next_stage['name']}")
                print(f"   /idea-discovery 또는 /idea-validation 을 실행하세요.")
            else:
                all_stages = [self.STAGE_0] + self.STAGES if progress.get("includes_stage_0") else self.STAGES
                stage_def = next((s for s in all_stages if s["id"] == stage_id), None)
                directory = stage_def["directory"] if stage_def else "output/"
                print(f"💡 다음 단계: {stage_id}. {next_stage['name']}")
                print(f"   해당 단계의 산출물을 {directory}에 생성하세요.")
        else:
            print("🎉 축하합니다! 모든 단계가 완료되었습니다!")

        print("=" * 60 + "\n")

    # ------------------------------------------------------------------
    # Multi-idea portfolio methods
    # ------------------------------------------------------------------

    def is_multi_mode(self) -> bool:
        """
        output/ideas/ 하위에 idea.json을 포함한 아이디어 폴더가 있는지 확인합니다.

        Returns:
            멀티 아이디어 모드 여부
        """
        return len(self.discover_ideas()) > 0

    def discover_ideas(self) -> List[Path]:
        """
        output/ideas/ 하위 폴더를 Shallow Scan하여 idea.json이 있는 폴더 목록을 반환합니다.

        Returns:
            idea.json이 존재하는 디렉토리 Path 리스트 (이름순 정렬)
        """
        ideas_root = self.project_dir / "output" / "ideas"
        if not ideas_root.exists():
            return []

        idea_dirs = []
        for child in sorted(ideas_root.iterdir()):
            if child.is_dir() and (child / "idea.json").exists():
                idea_dirs.append(child)
        return idea_dirs

    def _load_idea_meta(self, idea_dir: Path) -> Dict:
        """
        idea.json을 읽어 메타 정보를 반환합니다.
        파싱 실패 시 기본값을 반환합니다.
        """
        meta_path = idea_dir / "idea.json"
        defaults = {
            "id": idea_dir.name,
            "name": idea_dir.name,
            "created": "",
            "status": "",
            "score": None,
        }
        try:
            with open(meta_path, "r", encoding="utf-8") as f:
                data = json.load(f)
            for key in defaults:
                if key not in data:
                    data[key] = defaults[key]
            return data
        except (json.JSONDecodeError, OSError):
            return defaults

    def _check_idea_stage_local(
        self, idea_dir: Path, stage: Dict
    ) -> Tuple[bool, List[str]]:
        """
        아이디어 폴더 내부에서 특정 단계의 완료 여부를 확인합니다.
        """
        directory = idea_dir / stage["directory"]
        if not directory.exists():
            return False, []

        found_files = []
        keywords = stage["keywords"]
        for file_path in directory.rglob("*"):
            if file_path.is_file():
                filename_lower = file_path.name.lower()
                if any(kw.lower() in filename_lower for kw in keywords):
                    found_files.append(
                        str(file_path.relative_to(self.project_dir))
                    )
        return len(found_files) > 0, found_files

    def check_idea_stages(self, idea_dir: Path) -> Dict:
        """
        특정 아이디어 폴더 내에서 Stage 0-8 진행률을 계산합니다.

        Args:
            idea_dir: 아이디어 폴더 경로 (absolute)

        Returns:
            아이디어 진행률 딕셔너리
        """
        meta = self._load_idea_meta(idea_dir)
        stages: List[Dict] = []
        completed_count = 0

        # Stage 0: hypothesis.md or evaluation.md
        stage0_files = []
        for fname in self.IDEA_STAGE_0_FILES:
            fpath = idea_dir / fname
            if fpath.exists():
                stage0_files.append(str(fpath.relative_to(self.project_dir)))
        stage0_done = len(stage0_files) > 0
        if stage0_done:
            completed_count += 1
        stages.append({
            "id": 0,
            "name": "아이디어 발굴",
            "completed": stage0_done,
            "files": stage0_files,
        })

        # Stages 1-8
        for stage_def in self.IDEA_STAGES:
            is_done, files = self._check_idea_stage_local(idea_dir, stage_def)
            if is_done:
                completed_count += 1
            stages.append({
                "id": stage_def["id"],
                "name": stage_def["name"],
                "completed": is_done,
                "files": files,
            })

        total = 9  # Stage 0 + 8 stages
        percentage = (completed_count / total * 100) if total > 0 else 0

        return {
            "idea_dir": str(idea_dir.relative_to(self.project_dir)),
            "meta": meta,
            "total_stages": total,
            "completed_stages": completed_count,
            "percentage": round(percentage, 1),
            "stages": stages,
        }

    def check_portfolio(self) -> Dict:
        """
        모든 아이디어의 요약 정보를 반환합니다.

        Returns:
            포트폴리오 딕셔너리
        """
        idea_dirs = self.discover_ideas()
        ideas = []
        status_counts: Dict[str, int] = {}

        for idea_dir in idea_dirs:
            idea_progress = self.check_idea_stages(idea_dir)
            ideas.append(idea_progress)
            status = idea_progress["meta"].get("status") or "미평가"
            status_counts[status] = status_counts.get(status, 0) + 1

        return {
            "total_ideas": len(ideas),
            "status_counts": status_counts,
            "ideas": ideas,
        }

    def _find_idea_dir(self, idea_id_or_path: str) -> Optional[Path]:
        """
        --idea 인수로부터 아이디어 폴더를 찾습니다.
        idea_id_or_path가 절대/상대 경로이거나, idea id prefix일 수 있습니다.
        """
        # Try as a direct path
        candidate = Path(idea_id_or_path)
        if candidate.is_absolute() and candidate.is_dir() and (candidate / "idea.json").exists():
            return candidate
        # Try relative to project_dir
        candidate = self.project_dir / idea_id_or_path
        if candidate.is_dir() and (candidate / "idea.json").exists():
            return candidate
        # Try matching under output/ideas/
        ideas_root = self.project_dir / "output" / "ideas"
        if ideas_root.exists():
            for child in sorted(ideas_root.iterdir()):
                if child.is_dir() and (child / "idea.json").exists():
                    # Match by folder name or id prefix
                    if child.name == idea_id_or_path or child.name.startswith(idea_id_or_path):
                        return child
        return None

    def _current_stage_name(self, idea_progress: Dict) -> str:
        """
        아이디어의 현재 진행 중인 단계(마지막 완료 단계 다음) 이름을 반환합니다.
        """
        last_completed_id = -1
        for stage in idea_progress["stages"]:
            if stage["completed"]:
                last_completed_id = stage["id"]
        # Find the next incomplete stage name
        for stage in idea_progress["stages"]:
            if not stage["completed"]:
                return stage["name"]
        return "완료"

    def print_idea_report(self, idea_progress: Dict):
        """
        특정 아이디어의 진행률 리포트를 텍스트로 출력합니다.
        """
        meta = idea_progress["meta"]
        name = meta.get("name", idea_progress["idea_dir"])
        status = meta.get("status") or "미평가"
        score = meta.get("score")
        score_str = f"{score}점" if score is not None else "미평가"

        print("\n" + "=" * 60)
        print(f"📊 아이디어 진행률: {name}")
        print("=" * 60 + "\n")
        print(f"  상태: {status}  |  점수: {score_str}")
        print(f"  전체 진행률: {idea_progress['completed_stages']}/{idea_progress['total_stages']} 단계 완료")
        print(f"  {self.print_progress_bar(idea_progress['percentage'])}")
        print()

        print("단계별 현황:")
        print("-" * 60)
        for stage in idea_progress["stages"]:
            icon = "✅" if stage["completed"] else "⬜"
            print(f"  {icon} {stage['id']}. {stage['name']}")
            if stage["completed"] and stage["files"]:
                for file in stage["files"][:3]:
                    print(f"      - {file}")
                if len(stage["files"]) > 3:
                    print(f"      ... 외 {len(stage['files']) - 3}개")
        print("=" * 60 + "\n")

    def print_portfolio_report(self, portfolio: Dict):
        """
        포트폴리오 모드 텍스트 리포트를 출력합니다.
        """
        ideas = portfolio["ideas"]
        total = portfolio["total_ideas"]
        counts = portfolio["status_counts"]

        go = counts.get("Go", 0)
        pivot = counts.get("Pivot", 0)
        drop = counts.get("Drop", 0)
        unrated = total - go - pivot - drop

        print("\n" + "=" * 60)
        print("📊 사업 아이디어 포트폴리오")
        print("=" * 60 + "\n")
        print(f"총 아이디어: {total}개 | Go: {go} | Pivot: {pivot} | Drop: {drop} | 미평가: {unrated}")
        print()

        for idx, idea in enumerate(ideas, 1):
            meta = idea["meta"]
            name = meta.get("name", "")
            status = meta.get("status") or "미평가"
            score = meta.get("score")
            completed = idea["completed_stages"]
            # Stage 0 is not counted in 1-8 progress display
            stages_1_8_done = sum(
                1 for s in idea["stages"] if s["id"] > 0 and s["completed"]
            )
            total_1_8 = 8
            pct_1_8 = stages_1_8_done / total_1_8 * 100 if total_1_8 > 0 else 0

            if score is not None:
                label = f"{status} {score}점"
            else:
                label = "미평가"

            bar_width = 10
            filled = int(bar_width * pct_1_8 / 100)
            bar = "█" * filled + "░" * (bar_width - filled)

            current_stage = self._current_stage_name(idea)
            print(
                f"  {idx}. {name} [{label}] {bar} {pct_1_8:.1f}% ({stages_1_8_done}/{total_1_8})"
            )

        print("\n" + "=" * 60 + "\n")

    def generate_portfolio_md(self, portfolio: Dict):
        """
        output/ideas/portfolio.md를 생성/업데이트합니다.
        기존 파일이 있으면 AUTO:START~AUTO:END 영역만 교체합니다.
        """
        portfolio_path = self.project_dir / "output" / "ideas" / "portfolio.md"
        ideas = portfolio["ideas"]

        # Build the auto-generated table
        lines = []
        lines.append("| # | 아이디어 | 상태 | 점수 | 진행 단계 | 생성일 |")
        lines.append("|---|----------|------|------|-----------|--------|")
        for idx, idea in enumerate(ideas, 1):
            meta = idea["meta"]
            name = meta.get("name", "")
            status = meta.get("status") or "미평가"
            score = meta.get("score")
            score_str = f"{score}/25" if score is not None else "-"
            stages_1_8_done = sum(
                1 for s in idea["stages"] if s["id"] > 0 and s["completed"]
            )
            current_stage = self._current_stage_name(idea)
            created = meta.get("created", "")
            lines.append(
                f"| {idx} | {name} | {status} | {score_str} | {stages_1_8_done}/8 ({current_stage}) | {created} |"
            )

        auto_content = "\n".join(lines)
        auto_block = f"<!-- AUTO:START - 이 영역은 자동 생성됩니다. 편집하지 마세요. -->\n{auto_content}\n<!-- AUTO:END -->"

        if portfolio_path.exists():
            existing = portfolio_path.read_text(encoding="utf-8")
            # Replace AUTO:START~AUTO:END block
            pattern = r"<!-- AUTO:START.*?-->.*?<!-- AUTO:END -->"
            if re.search(pattern, existing, re.DOTALL):
                new_content = re.sub(pattern, auto_block, existing, flags=re.DOTALL)
            else:
                # No auto block found, prepend after first heading or at top
                new_content = existing + "\n\n" + auto_block + "\n"
        else:
            # Create new file
            portfolio_path.parent.mkdir(parents=True, exist_ok=True)
            new_content = f"""# 사업 아이디어 포트폴리오

{auto_block}

## 나의 메모
(이 영역은 자유롭게 편집하세요)
"""

        portfolio_path.write_text(new_content, encoding="utf-8")
        return str(portfolio_path.relative_to(self.project_dir))


def main():
    """메인 함수"""
    parser = argparse.ArgumentParser(
        description="사업 기획 진행률을 확인합니다.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
사용 예시:
  %(prog)s                    # 현재 디렉토리 기준으로 진행률 확인
  %(prog)s --json             # JSON 형식으로 출력
  %(prog)s --dir /path/to/project  # 특정 디렉토리의 진행률 확인
  %(prog)s --idea idea-001    # 특정 아이디어의 진행률 확인
  %(prog)s --portfolio        # 전체 포트폴리오 대시보드
        """,
    )

    parser.add_argument(
        "--dir",
        "-d",
        default=None,
        help="프로젝트 디렉토리 경로 (기본값: 스크립트의 4단계 상위 디렉토리)",
    )

    parser.add_argument(
        "--json",
        "-j",
        action="store_true",
        help="JSON 형식으로 출력",
    )

    parser.add_argument(
        "--idea",
        default=None,
        help="특정 아이디어의 진행률만 표시 (아이디어 ID 또는 경로)",
    )

    parser.add_argument(
        "--portfolio",
        action="store_true",
        help="전체 아이디어 요약 대시보드 + portfolio.md 자동생성",
    )

    args = parser.parse_args()

    # 프로젝트 디렉토리 결정
    if args.dir:
        project_dir = args.dir
    else:
        # 스크립트의 4단계 상위 디렉토리 (../../../.. from scripts/)
        # scripts/ → progress-tracker/ → skills/ → .agent/ → project root
        script_path = Path(__file__).resolve()
        project_dir = script_path.parent.parent.parent.parent.parent

    tracker = ProgressTracker(project_dir)

    # --idea: 특정 아이디어 모드
    if args.idea:
        idea_dir = tracker._find_idea_dir(args.idea)
        if idea_dir is None:
            print(f"오류: 아이디어를 찾을 수 없습니다: {args.idea}", file=sys.stderr)
            sys.exit(2)
        idea_progress = tracker.check_idea_stages(idea_dir)
        if args.json:
            print(json.dumps(idea_progress, ensure_ascii=False, indent=2))
        else:
            tracker.print_idea_report(idea_progress)
        sys.exit(0 if idea_progress["percentage"] == 100.0 else 1)

    # --portfolio: 포트폴리오 모드
    if args.portfolio:
        portfolio = tracker.check_portfolio()
        if portfolio["total_ideas"] == 0:
            print("아이디어 폴더가 없습니다. output/ideas/ 하위에 idea.json을 포함한 폴더를 생성하세요.", file=sys.stderr)
            sys.exit(2)
        md_path = tracker.generate_portfolio_md(portfolio)
        if args.json:
            portfolio["portfolio_md"] = md_path
            print(json.dumps(portfolio, ensure_ascii=False, indent=2))
        else:
            tracker.print_portfolio_report(portfolio)
            print(f"  📄 portfolio.md 생성: {md_path}\n")
        sys.exit(0)

    # 인수 없이 실행: 자동 모드 전환
    if tracker.is_multi_mode():
        # 멀티 모드 -> 포트폴리오 표시
        portfolio = tracker.check_portfolio()
        md_path = tracker.generate_portfolio_md(portfolio)
        if args.json:
            portfolio["portfolio_md"] = md_path
            print(json.dumps(portfolio, ensure_ascii=False, indent=2))
        else:
            tracker.print_portfolio_report(portfolio)
            print(f"  📄 portfolio.md 생성: {md_path}\n")
        sys.exit(0)
    else:
        # 레거시 모드 -> 기존 동작
        progress = tracker.check_all_stages()
        if args.json:
            print(json.dumps(progress, ensure_ascii=False, indent=2))
        else:
            tracker.print_text_report(progress)
        sys.exit(0 if progress["percentage"] == 100.0 else 1)


if __name__ == "__main__":
    main()
SK7PY_EOF
chmod +x "$PROJECT_ROOT/.agent/skills/progress-tracker/scripts/check_progress.py"

# Skill 8: document-exporter/SKILL.md
cat << 'SK8_EOF' > "$PROJECT_ROOT/.agent/skills/document-exporter/SKILL.md"
---
name: document-exporter
description: Markdown 문서를 HTML/PDF로 변환합니다. output/ 폴더의 분석 보고서를 공유 가능한 형태로 내보냅니다.
---

# Document Exporter Skill

당신은 문서 변환 전문가입니다. Markdown으로 작성된 사업 기획 문서를 공유 가능한 형식으로 변환합니다.

## 역할
- output/ 폴더의 Markdown 문서를 HTML로 변환합니다
- 변환된 HTML은 한국어 비즈니스 문서 스타일이 적용됩니다
- 브라우저에서 PDF로 저장할 수 있도록 인쇄 친화적 스타일을 포함합니다

## 변환 프로세스
1. 대상 Markdown 파일을 선택합니다
2. scripts/export_docs.py를 먼저 --help로 확인 후 실행합니다
3. HTML 파일이 같은 디렉토리에 생성됩니다
4. PDF가 필요한 경우 브라우저에서 Cmd+P로 저장을 안내합니다

## 출력 규칙
- 변환된 파일은 원본과 같은 폴더에 .html 확장자로 저장합니다
- 한국어 폰트와 비즈니스 문서 스타일을 적용합니다
- 인쇄 시 깔끔하게 출력되는 레이아웃을 보장합니다
SK8_EOF

# Skill 8 script: document-exporter/scripts/export_docs.py
cat << 'SK8PY_EOF' > "$PROJECT_ROOT/.agent/skills/document-exporter/scripts/export_docs.py"
#!/usr/bin/env python3
"""
Document Export Script for Antigravity Business Planner
Converts Markdown documents to styled HTML with print-friendly formatting
"""

import argparse
import sys
import os
from pathlib import Path
from datetime import datetime

# Check markdown package availability
try:
    import markdown
except ImportError:
    print("❌ Error: 'markdown' package is not installed.")
    print("\n📦 Please install it using:")
    print("   pip install markdown")
    print("\n   or")
    print("   pip3 install markdown")
    sys.exit(1)


HTML_TEMPLATE = """<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title}</title>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}

        body {{
            font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo",
                         "Malgun Gothic", "Noto Sans KR", sans-serif;
            line-height: 1.8;
            color: #222;
            background: #f5f5f5;
            padding: 2rem;
        }}

        .document-container {{
            max-width: 900px;
            margin: 0 auto;
            background: white;
            padding: 3rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
        }}

        .document-header {{
            border-bottom: 3px solid #2c3e50;
            padding-bottom: 1.5rem;
            margin-bottom: 2rem;
        }}

        .document-header h1 {{
            font-size: 2rem;
            color: #2c3e50;
            margin-bottom: 0.5rem;
            font-weight: 700;
        }}

        .document-meta {{
            color: #666;
            font-size: 0.9rem;
        }}

        .document-content h1 {{
            font-size: 1.8rem;
            color: #2c3e50;
            margin: 2rem 0 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #ecf0f1;
        }}

        .document-content h2 {{
            font-size: 1.5rem;
            color: #34495e;
            margin: 1.8rem 0 1rem;
            padding-left: 0.5rem;
            border-left: 4px solid #3498db;
        }}

        .document-content h3 {{
            font-size: 1.3rem;
            color: #34495e;
            margin: 1.5rem 0 0.8rem;
        }}

        .document-content h4 {{
            font-size: 1.1rem;
            color: #555;
            margin: 1.2rem 0 0.6rem;
        }}

        .document-content p {{
            margin-bottom: 1rem;
            text-align: justify;
        }}

        .document-content ul,
        .document-content ol {{
            margin: 1rem 0 1rem 2rem;
        }}

        .document-content li {{
            margin-bottom: 0.5rem;
        }}

        .document-content blockquote {{
            border-left: 4px solid #3498db;
            padding-left: 1.5rem;
            margin: 1.5rem 0;
            color: #555;
            font-style: italic;
            background: #f8f9fa;
            padding: 1rem 1rem 1rem 1.5rem;
        }}

        .document-content code {{
            background: #f4f4f4;
            padding: 0.2rem 0.4rem;
            border-radius: 3px;
            font-family: "Monaco", "Menlo", monospace;
            font-size: 0.9em;
            color: #e74c3c;
        }}

        .document-content pre {{
            background: #2c3e50;
            color: #ecf0f1;
            padding: 1rem;
            border-radius: 5px;
            overflow-x: auto;
            margin: 1rem 0;
        }}

        .document-content pre code {{
            background: none;
            color: inherit;
            padding: 0;
        }}

        .document-content table {{
            width: 100%;
            border-collapse: collapse;
            margin: 1.5rem 0;
            border: 1px solid #ddd;
        }}

        .document-content th {{
            background: #34495e;
            color: white;
            padding: 0.8rem;
            text-align: left;
            font-weight: 600;
        }}

        .document-content td {{
            padding: 0.8rem;
            border: 1px solid #ddd;
        }}

        .document-content tr:nth-child(even) {{
            background: #f8f9fa;
        }}

        .document-content img {{
            max-width: 100%;
            height: auto;
            display: block;
            margin: 1.5rem auto;
            border-radius: 5px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }}

        .document-content hr {{
            border: none;
            border-top: 2px solid #ecf0f1;
            margin: 2rem 0;
        }}

        .document-footer {{
            margin-top: 3rem;
            padding-top: 1.5rem;
            border-top: 2px solid #ecf0f1;
            color: #999;
            font-size: 0.85rem;
            text-align: center;
        }}

        /* Print styles */
        @media print {{
            body {{
                background: white;
                padding: 0;
            }}

            .document-container {{
                max-width: 100%;
                box-shadow: none;
                padding: 1.5cm;
            }}

            .document-header {{
                page-break-after: avoid;
            }}

            .document-content h1,
            .document-content h2,
            .document-content h3 {{
                page-break-after: avoid;
            }}

            .document-content table {{
                page-break-inside: avoid;
            }}

            .document-content pre {{
                page-break-inside: avoid;
                border: 1px solid #ddd;
            }}

            @page {{
                margin: 2cm;
                size: A4;
            }}
        }}
    </style>
</head>
<body>
    <div class="document-container">
        <div class="document-header">
            <h1>{title}</h1>
            <div class="document-meta">생성일: {date}</div>
        </div>

        <div class="document-content">
            {content}
        </div>

        <div class="document-footer">
            본 문서는 AI 기반 사업 기획 도구로 생성되었습니다.
        </div>
    </div>
</body>
</html>
"""


def extract_title_from_markdown(content):
    """Extract first h1 heading from markdown content"""
    for line in content.split('\n'):
        line = line.strip()
        if line.startswith('# '):
            return line[2:].strip()
    return "문서"


def convert_markdown_to_html(input_path, output_path=None):
    """Convert a single Markdown file to styled HTML"""
    input_file = Path(input_path)

    if not input_file.exists():
        print(f"❌ Error: File not found: {input_path}")
        return False

    if not input_file.suffix.lower() in ['.md', '.markdown']:
        print(f"⚠️  Warning: File doesn't appear to be Markdown: {input_path}")

    try:
        # Read markdown content
        with open(input_file, 'r', encoding='utf-8') as f:
            md_content = f.read()

        # Extract title
        title = extract_title_from_markdown(md_content)

        # Get file modification date
        mod_time = datetime.fromtimestamp(input_file.stat().st_mtime)
        date_str = mod_time.strftime("%Y년 %m월 %d일")

        # Convert markdown to HTML
        html_content = markdown.markdown(
            md_content,
            extensions=['tables', 'fenced_code', 'codehilite']
        )

        # Generate final HTML
        final_html = HTML_TEMPLATE.format(
            title=title,
            date=date_str,
            content=html_content
        )

        # Determine output path
        if output_path:
            output_file = Path(output_path)
        else:
            output_file = input_file.with_suffix('.html')

        # Write HTML file
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(final_html)

        print(f"✅ Converted: {input_file.name} → {output_file.name}")
        print(f"   📄 Output: {output_file.absolute()}")
        return True

    except UnicodeDecodeError:
        print(f"❌ Error: Unable to read file (encoding issue): {input_path}")
        print("   Please ensure the file is UTF-8 encoded.")
        return False
    except Exception as e:
        print(f"❌ Error converting {input_path}: {str(e)}")
        return False


def batch_convert(directory, recursive=False):
    """Convert all Markdown files in a directory"""
    dir_path = Path(directory)

    if not dir_path.exists():
        print(f"❌ Error: Directory not found: {directory}")
        return False

    if not dir_path.is_dir():
        print(f"❌ Error: Not a directory: {directory}")
        return False

    # Find markdown files
    if recursive:
        md_files = list(dir_path.rglob('*.md')) + list(dir_path.rglob('*.markdown'))
    else:
        md_files = list(dir_path.glob('*.md')) + list(dir_path.glob('*.markdown'))

    if not md_files:
        print(f"⚠️  No Markdown files found in: {directory}")
        return False

    print(f"📁 Found {len(md_files)} Markdown file(s)\n")

    success_count = 0
    for md_file in md_files:
        if convert_markdown_to_html(md_file):
            success_count += 1
        print()  # Empty line between files

    print(f"{'='*60}")
    print(f"✨ Completed: {success_count}/{len(md_files)} files converted successfully")

    return success_count > 0


def main():
    parser = argparse.ArgumentParser(
        description='Convert Markdown documents to styled HTML',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Convert single file
  %(prog)s report.md

  # Convert with custom output path
  %(prog)s report.md --output output.html

  # Batch convert all .md files in a directory
  %(prog)s --batch ./output

  # Batch convert including subdirectories
  %(prog)s --batch ./output --recursive

PDF Export:
  After generating HTML, open it in a browser and use:
  - macOS: Cmd+P → Save as PDF
  - Windows/Linux: Ctrl+P → Save as PDF
        """
    )

    parser.add_argument(
        'input',
        nargs='?',
        help='Input Markdown file to convert'
    )

    parser.add_argument(
        '-o', '--output',
        help='Output HTML file path (default: same name as input with .html extension)'
    )

    parser.add_argument(
        '-b', '--batch',
        metavar='DIR',
        help='Batch convert all Markdown files in directory'
    )

    parser.add_argument(
        '-r', '--recursive',
        action='store_true',
        help='Include subdirectories in batch mode'
    )

    args = parser.parse_args()

    # Validate arguments
    if not args.input and not args.batch:
        parser.print_help()
        print("\n❌ Error: Please provide either an input file or use --batch mode")
        sys.exit(1)

    if args.input and args.batch:
        print("❌ Error: Cannot use both single file and batch mode simultaneously")
        sys.exit(1)

    if args.recursive and not args.batch:
        print("❌ Error: --recursive can only be used with --batch mode")
        sys.exit(1)

    # Execute conversion
    if args.batch:
        success = batch_convert(args.batch, args.recursive)
    else:
        success = convert_markdown_to_html(args.input, args.output)
        if success and not args.output:
            output_file = Path(args.input).with_suffix('.html')
            print(f"\n💡 To save as PDF:")
            print(f"   1. Open {output_file.name} in a browser")
            print(f"   2. Press Cmd+P (macOS) or Ctrl+P (Windows/Linux)")
            print(f"   3. Select 'Save as PDF'")

    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
SK8PY_EOF
chmod +x "$PROJECT_ROOT/.agent/skills/document-exporter/scripts/export_docs.py"

# Skill 9: opportunity-finder/SKILL.md
cat << 'SK9_EOF' > "$PROJECT_ROOT/.agent/skills/opportunity-finder/SKILL.md"
---
name: opportunity-finder
description: 도메인 지식은 있지만 사업 아이디어가 없는 사용자를 위해, 구조화된 질문을 통해 사업 기회를 발굴하고 가설 수준의 아이디어를 생성합니다.
---

# Opportunity Finder Skill

당신은 사업 기회 발굴 전문가입니다. 사용자의 도메인 경험에서 사업 아이디어를 도출합니다.

## 역할
- 사용자의 업종 경험과 도메인 지식을 구조화합니다
- 시장 기회를 가설 수준(1문단)으로 빠르게 도출합니다
- 여러 아이디어를 비교 가능한 형태로 정리합니다
- Go/Pivot-optimize/Pivot-review/Drop 판단을 위한 정량 평가를 수행합니다

## 깊이 경계
- **이 스킬**: 가설 수준의 아이디어 도출 (1문단 요약)
- **business-researcher**: 선택된 아이디어의 심층 시장 분석

## 구조화 입력 — 필수 질문 5개

1. **업종/산업**: 어떤 분야에서 일하고 계시나요?
2. **경력/경험**: 해당 분야에서 얼마나 오래 일하셨나요?
3. **문제점/불편함**: 일하면서 가장 비효율적이라고 느낀 점은?
4. **가용 자원**: 초기 투자 가능 금액, 활용 가능한 네트워크/자산은?
5. **목표 고객층**: 어떤 고객에게 서비스하고 싶으신가요?

## Go/Pivot-optimize/Pivot-review/Drop 평가 기준 (5점 척도)

| 평가 항목 | 1점 (매우 불리) | 3점 (보통) | 5점 (매우 유리) |
|-----------|----------------|-----------|----------------|
| 시장 크기 | 연 100억 미만 | 연 1,000억 내외 | 연 1조 이상 |
| 경쟁 강도 | 대기업 독점 | 중소 경쟁자 다수 | 경쟁자 부재/소수 |
| 창업자-문제 적합성 | 경험 무관 | 일부 관련 | 핵심 역량 일치 |
| 자원 요건 | 10억 이상 필요 | 1-5억 필요 | 5천만 이하 가능 |
| 타이밍 | 이미 포화 | 성장기 | 초기 시장 |

**판정:** Go (20+) / Pivot (12-19) / Drop (11-)

## 반복 제한
- discovery → validation 순환은 최대 2회까지

## 출력 규칙
- 아이디어는 가설 형태(1문단)로 간결하게 작성합니다
- 평가 결과는 표 형식으로 시각화합니다
- 결과물은 output/ideas/ 폴더에 저장합니다
SK9_EOF

# Skill 10: AI Business Analyst
cat << 'SK10_EOF' > "$PROJECT_ROOT/.agent/skills/ai-business-analyst/SKILL.md"
---
name: ai-business-analyst
description: AI 기술을 활용한 사업 아이디어를 전문적으로 분석합니다
---

# 역할

* AI 기술 기반 사업 아이디어의 유형을 분류하고 전문 분석을 수행합니다
* AI 사업의 기술적 타당성, 데이터 전략, 경쟁 방어력을 평가합니다
* 유형별 수익 모델, 핵심 리스크, 비용 구조를 안내합니다
* opportunity-finder 스킬과 연동하여 AI 사업 보충 분석을 제공합니다

# AI 사업 유형 분류

사용자의 아이디어에서 AI 관련 키워드가 감지되면 아래 유형 중 가장 적합한 것을 내부적으로 분류합니다. 사용자에게는 "사용자 표현" 컬럼의 이름으로 안내합니다.

| 사용자 표현 | 설명 | 대표 사례 |
|-----------|------|----------|
| AI 대행 서비스 | AI가 사람의 업무를 대행 | AI 고객 상담, AI 세무 대행 |
| AI 기능 탑재 소프트웨어 | 기존 SaaS에 AI 핵심 기능 추가 | AI 마케팅 툴, AI 디자인 도구 |
| AI 중개 플랫폼 | AI 모델/서비스/데이터 중개 | 모델 마켓플레이스, AI 프리랜서 |
| 데이터 사업 | 데이터 수집/가공/판매 | 학습 데이터, 산업 데이터 분석 |
| AI 도입 컨설팅 | 기업 AI 전환 자문/구축 | AI 전략 수립, PoC 개발 |
| AI 인프라/도구 | MLOps, 벡터DB 등 개발자 도구 | 모델 배포, 파이프라인 관리 |
| AI 콘텐츠 생성 | AI를 활용한 콘텐츠 제작 | AI 영상/디자인/음악 |
| 산업 특화 AI | 특정 산업에 최적화된 AI 솔루션 | 의료 AI, 법률 AI, 농업 AI |

# 보충 질문 (AI 감지 시에만)

AI 키워드가 감지되면 opportunity-finder의 기본 질문에 아래 3개를 추가합니다:

1. **기술 활용 방식**: "AI 기술을 어떻게 활용할 계획인가요? (예: 기존 AI API 활용, 자체 모델 개발, 데이터 수집/가공)"
2. **데이터 확보 계획**: "AI 학습이나 서비스에 필요한 데이터를 어떻게 확보할 계획인가요?"
3. **기존 해결 방식**: "현재 이 문제를 AI 없이 어떻게 해결하고 있나요?"

# 유형별 가이드

각 유형별로 아래 항목을 안내합니다:

* **수익 모델**: 해당 유형에 적합한 수익 구조 (구독, 사용량, 수수료 등)
* **핵심 리스크**: 가장 주의해야 할 위험 요소
* **방어력 전략**: 경쟁자 대비 차별화 방법
* **비용 구조 참조**: `templates/ai-business-financial-template.md` 활용 안내

# 출력

* idea.json에 `ai_business` 블록 추가:
  ```json
  "ai_business": {
    "detected": true,
    "type_label": "AI 기능 탑재 소프트웨어",
    "data_strategy": "사용자 응답 요약",
    "tech_approach": "사용자 응답 요약"
  }
  ```
* `output/ideas/{id}/ai-analysis.md` — AI 사업 분석 상세 문서 생성
SK10_EOF

# Skill 11: Niche Validator (Phase 7)
cat << 'SK11_EOF' > "$PROJECT_ROOT/.agent/skills/niche-validator/SKILL.md"
---
name: niche-validator
description: 니치 시장의 유효성을 검증합니다. Micro-SaaS/1인 빌더가 타겟하는 니치 시장이 실제로 수익 가능한지 판단합니다.
---

# niche-validator

니치 시장의 유효성을 검증합니다. Micro-SaaS/1인 빌더가 타겟하는 니치 시장이 실제로 수익 가능한지 판단합니다.

## 활성화 조건
* business_scale이 "micro" 또는 "small"일 때 자동 활성화
* /market-research 워크플로우 실행 시 연동

## 수행 작업

### 커뮤니티 수요 분석
* 타겟 니치의 온라인 커뮤니티를 식별합니다 (Reddit, 디스코드, 네이버 카페, 포럼)
* 커뮤니티 규모 (멤버 수, 월간 활성 게시물)를 추정합니다
* 반복되는 불만/요청 패턴을 수집합니다 (상위 5개)

### 기존 솔루션 불만 수집
* 경쟁 제품의 리뷰/평점을 분석합니다
* 부정적 리뷰에서 공통 패턴을 추출합니다
* "이 기능만 있으면", "왜 이게 안 돼" 같은 미충족 수요 시그널을 수집합니다

### 지불 의향 시그널 감지
* "I'd pay for...", "Take my money", "무료면 좋겠다" 등 지불 시그널을 검색합니다
* 크라우드펀딩/얼리버드 성공 사례를 참고합니다
* 유사 니치의 유료 제품 존재 여부를 확인합니다

### 니치 스코어 산출

| 항목 | 가중치 | 점수 (1-5) | 가중 점수 |
|------|--------|-----------|----------|
| 커뮤니티 규모 | 20% | | |
| 불만 강도 | 25% | | |
| 지불 의향 | 25% | | |
| 경쟁 공백 | 20% | | |
| 성장 추세 | 10% | | |
| **합계** | **100%** | | **/5.0** |

* 4.0+ : 유효한 니치 (Go)
* 3.0-3.9 : 보완 필요 (Pivot)
* 3.0 미만 : 재검토 필요 (Drop)

## 출력 형식
* 마크다운 표와 목록으로 정리합니다
* output/research/niche-validation.md에 저장합니다
* 니치 스코어와 판정(Go/Pivot/Drop)을 반드시 포함합니다
SK11_EOF

# Skill 12: Bootstrap Calculator (Phase 7)
cat << 'SK12_EOF' > "$PROJECT_ROOT/.agent/skills/bootstrap-calculator/SKILL.md"
---
name: bootstrap-calculator
description: 부트스트랩(자기 자본) 방식의 SaaS 사업 재무를 계산합니다. 투자 없이 구독 수익만으로 자립하는 모델을 설계합니다.
---

# bootstrap-calculator

부트스트랩(자기 자본) 방식의 SaaS 사업 재무를 계산합니다. 투자 없이 구독 수익만으로 자립하는 모델을 설계합니다.

## 활성화 조건
* business_scale이 "micro" 또는 "small"일 때 자동 활성화
* /financial-modeling 워크플로우 실행 시 연동

## 수행 작업

### MRR 기반 BEP 계산
* 월 고정비 산출: SaaS 도구, 호스팅, API, 도메인 등
* ARPU 설정: 가격 티어별 가중 평균
* BEP 고객 수 = 월 고정비 / ARPU
* BEP 도달 예상 시점 계산 (성장률 기반)

### SaaS 비용 구조 산출
* 고정비: 도메인, 호스팅, DB, 이메일, 모니터링
* 변동비: API 호출, 결제 수수료, 대역폭
* 스케일링 곡선: 고객 50/100/500/1,000명별 총비용

### 구독자 성장 시나리오 시뮬레이션

| 시나리오 | 월 성장률 | 월 이탈률 | 3개월 후 | 6개월 후 | 12개월 후 |
|---------|----------|----------|---------|---------|---------|
| 비관적 | 5% | 8% | 명 | 명 | 명 |
| 기본 | 10% | 5% | 명 | 명 | 명 |
| 낙관적 | 20% | 3% | 명 | 명 | 명 |

### 가격 민감도 분석
* 현재 가격의 +-30% 범위에서 전환율 변화 추정
* 최적 가격점 제안 (수익 최대화 vs 성장 최대화)

## 출력 형식
* 모든 수치는 표 형태로 정리합니다
* "이 수치는 추정치이며, 실제와 다를 수 있습니다"를 명시합니다
* output/financials/bootstrap-projection.md에 저장합니다
SK12_EOF

# Skill 13: Tech Stack Recommender (Phase 7)
cat << 'SK13_EOF' > "$PROJECT_ROOT/.agent/skills/tech-stack-recommender/SKILL.md"
---
name: tech-stack-recommender
description: 1인/소규모 빌더를 위한 기술 스택과 자동화 도구를 추천합니다.
---

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
SK13_EOF

echo -e "  ${GREEN}✓${NC} ai-business-analyst/SKILL.md"
echo -e "  ${GREEN}✓${NC} niche-validator/SKILL.md"
echo -e "  ${GREEN}✓${NC} bootstrap-calculator/SKILL.md"
echo -e "  ${GREEN}✓${NC} tech-stack-recommender/SKILL.md"
echo -e "  ${GREEN}✓${NC} business-researcher/SKILL.md"
echo -e "  ${GREEN}✓${NC} financial-analyst/SKILL.md"
echo -e "  ${GREEN}✓${NC} financial-analyst/scripts/calculate_costs.py"
echo -e "  ${GREEN}✓${NC} report-writer/SKILL.md"
echo -e "  ${GREEN}✓${NC} pitch-deck-creator/SKILL.md"
echo -e "  ${GREEN}✓${NC} swot-analyzer/SKILL.md"
echo -e "  ${GREEN}✓${NC} data-visualizer/SKILL.md"
echo -e "  ${GREEN}✓${NC} data-visualizer/scripts/create_chart.py"
echo -e "  ${GREEN}✓${NC} progress-tracker/SKILL.md"
echo -e "  ${GREEN}✓${NC} progress-tracker/scripts/check_progress.py"
echo -e "  ${GREEN}✓${NC} document-exporter/SKILL.md"
echo -e "  ${GREEN}✓${NC} document-exporter/scripts/export_docs.py"
echo -e "  ${GREEN}✓${NC} opportunity-finder/SKILL.md"
echo -e "  ${GREEN}✓${NC} export-spec/SKILL.md"
echo -e "  ${GREEN}✓${NC} reality-check/SKILL.md"
echo ""

# ── 공유 스크립트 (Shared Scripts) ──
echo -e "${BLUE}  → 공유 스크립트 생성 중...${NC}"

# Shared Script 1: create_idea_score_chart.py
cat << 'SHARED1_EOF' > "$PROJECT_ROOT/.agent/skills/scripts/create_idea_score_chart.py"
#!/usr/bin/env python3
"""
Idea Score Visualization (v2.0)

Default: ASCII/Unicode bar chart (no dependencies)
Optional: Radar chart PNG via matplotlib (--chart flag)

Usage:
    python create_idea_score_chart.py --name "AI 재고관리" --scores "4,3,5,4,3"
    python create_idea_score_chart.py --name "AI 재고관리" --scores "4,3,5,4,3" --chart --output radar.png
    python create_idea_score_chart.py --json idea.json
"""

import argparse
import json
import sys
import os

# Evaluation items with weights and Korean R&D keyword mapping
ITEMS = [
    {"key": "market_size",  "label": "시장 크기",           "weight": 5, "rnd_keyword": "필요성(Necessity)"},
    {"key": "competition",  "label": "경쟁 강도",           "weight": 4, "rnd_keyword": ""},
    {"key": "founder_fit",  "label": "창업자-문제 적합성",   "weight": 5, "rnd_keyword": "팀 역량"},
    {"key": "resources",    "label": "자원 요건",           "weight": 3, "rnd_keyword": ""},
    {"key": "timing",       "label": "타이밍",              "weight": 3, "rnd_keyword": "성장성/확장성"},
]

# R&D composite mappings
RND_COMPOSITES = [
    {"keyword": "필요성(Necessity)",    "sources": ["market_size"],             "desc": "Problem + Market Context"},
    {"keyword": "차별화(Differentiation)", "sources": ["competition", "founder_fit"], "desc": "Solution + Existing Alternatives"},
]

VERDICT_RANGES = [
    (80, 100, "Go",          "즉시 심층 분석 진행"),
    (66,  79, "Pivot-최적화", "특정 항목 보완 후 재평가"),
    (48,  65, "Pivot-재검토", "근본적 재검토 필요"),
    (20,  47, "Drop",        "다른 아이디어 탐색"),
]

KILL_SWITCH_THRESHOLD = 3


def get_verdict(score):
    for low, high, label, desc in VERDICT_RANGES:
        if low <= score <= high:
            return label, desc
    return "Unknown", ""


def check_kill_switch(scores):
    warnings = []
    for item, score in zip(ITEMS, scores):
        if score < KILL_SWITCH_THRESHOLD:
            warnings.append(
                f"  {item['label']} = {score}점 (임계값 {KILL_SWITCH_THRESHOLD}점 미만)"
            )
    return warnings


def calc_total(scores):
    total = sum(s * item["weight"] for s, item in zip(scores, ITEMS))
    return total


def render_ascii(name, scores):
    """Render ASCII/Unicode bar chart — zero dependencies."""
    total = calc_total(scores)
    verdict, verdict_desc = get_verdict(total)
    kill_warnings = check_kill_switch(scores)

    bar_full = "\u2588"  # █
    bar_empty = "\u2591"  # ░
    max_bar = 10

    lines = []
    lines.append(f"\n{'='*60}")
    lines.append(f"  아이디어 평가 결과: {name}")
    lines.append(f"{'='*60}")
    lines.append("")
    lines.append(f"{'  평가 항목':<20} {'점수':>4}  {'':10}  {'가중':>4}  {'R&D 키워드'}")
    lines.append(f"  {'─'*56}")

    for item, score in zip(ITEMS, scores):
        filled = int(score / 5 * max_bar)
        bar = bar_full * filled + bar_empty * (max_bar - filled)
        weighted = score * item["weight"]
        rnd = item["rnd_keyword"]
        warn = " ⚠️" if score < KILL_SWITCH_THRESHOLD else ""
        lines.append(
            f"  {item['label']:<16} {score:>2}/5  {bar}  {weighted:>3}/{item['weight']*5}  {rnd}{warn}"
        )

    lines.append(f"  {'─'*56}")
    lines.append(f"  {'총점':<16} {total:>3}/100")
    lines.append(f"  {'판정':<16} {verdict} — {verdict_desc}")
    lines.append("")

    # R&D keyword composite scores
    lines.append("  [한국 R&D 평가 키워드 매핑]")
    score_map = {item["key"]: s for item, s in zip(ITEMS, scores)}
    for comp in RND_COMPOSITES:
        avg = sum(score_map[k] for k in comp["sources"]) / len(comp["sources"])
        lines.append(f"  · {comp['keyword']}: {avg:.1f}/5 ({comp['desc']})")
    lines.append("")

    # Kill Switch warnings
    if kill_warnings:
        lines.append("  ⚠️  Kill Switch 경고:")
        for w in kill_warnings:
            lines.append(w)
        lines.append("  → 총점과 무관하게 해당 항목의 보완이 권고됩니다.")
        lines.append("  → 진행하려면 CONTINUE를 입력하세요. (자동화: --force)")
        lines.append("")

    lines.append(f"{'='*60}")
    lines.append("  평가 버전: v2.0 | Kill Switch: 개별 항목 3점 미만 경고")
    lines.append(f"{'='*60}\n")

    return "\n".join(lines)


def render_radar(name, scores, output_path):
    """Render radar chart PNG via matplotlib — optional dependency."""
    try:
        import matplotlib
        matplotlib.use('Agg')
        import matplotlib.pyplot as plt
        import matplotlib.font_manager as fm
        import numpy as np
    except ImportError:
        print("⚠️  matplotlib 미설치 — 차트를 생략하고 텍스트 결과만 표시합니다.")
        print("    설치: pip install matplotlib numpy")
        return False

    # Korean font setup
    for font_name in ['AppleGothic', 'NanumGothic', 'Malgun Gothic']:
        try:
            fm.findfont(font_name, fallback_to_default=False)
            plt.rcParams['font.family'] = font_name
            plt.rcParams['axes.unicode_minus'] = False
            break
        except Exception:
            continue

    labels = [item["label"] for item in ITEMS]
    N = len(labels)
    angles = np.linspace(0, 2 * np.pi, N, endpoint=False).tolist()
    angles += angles[:1]
    values = scores + scores[:1]

    fig, ax = plt.subplots(figsize=(8, 8), subplot_kw=dict(polar=True))
    ax.fill(angles, values, color='#4285F4', alpha=0.25)
    ax.plot(angles, values, 'o-', color='#4285F4', linewidth=2)

    ax.set_xticks(angles[:-1])
    ax.set_xticklabels(labels, fontsize=12)
    ax.set_ylim(0, 5)
    ax.set_yticks([1, 2, 3, 4, 5])
    ax.set_yticklabels(['1', '2', '3', '4', '5'], fontsize=9, color='gray')

    # Mark kill switch threshold
    threshold_values = [KILL_SWITCH_THRESHOLD] * (N + 1)
    ax.plot(angles, threshold_values, '--', color='#EA4335', linewidth=1, alpha=0.5, label='Kill Switch (3점)')
    ax.legend(loc='upper right', bbox_to_anchor=(1.15, 1.1))

    total = calc_total(scores)
    verdict, _ = get_verdict(total)
    ax.set_title(f"{name}\n총점: {total}/100 — {verdict}", fontsize=14, fontweight='bold', pad=20)

    plt.tight_layout()
    plt.savefig(output_path, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"✅ 레이더 차트 저장: {output_path}")
    return True


def load_from_json(json_path):
    """Load scores from idea.json file."""
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    details = data.get("score_details", {})
    name = data.get("full_name", data.get("name", "Unknown"))
    scores = [
        details.get("market_size", 3),
        details.get("competition", 3),
        details.get("founder_fit", details.get("fit", 3)),
        details.get("resources", 3),
        details.get("timing", 3),
    ]
    return name, scores


def main():
    parser = argparse.ArgumentParser(description="Idea Score Visualization (v2.0)")
    parser.add_argument("--name", help="Idea name")
    parser.add_argument("--scores", help="Comma-separated scores (5 items, 1-5 each)")
    parser.add_argument("--json", help="Load from idea.json file")
    parser.add_argument("--chart", action="store_true", help="Generate radar chart PNG (requires matplotlib)")
    parser.add_argument("--output", default="idea-radar.png", help="Radar chart output path")
    args = parser.parse_args()

    if args.json:
        name, scores = load_from_json(args.json)
    elif args.name and args.scores:
        name = args.name
        scores = [int(v.strip()) for v in args.scores.split(",")]
    else:
        parser.print_help()
        sys.exit(1)

    if len(scores) != 5:
        print(f"Error: 5개 항목 점수가 필요합니다 (입력: {len(scores)}개)")
        sys.exit(1)

    # Always print ASCII chart
    print(render_ascii(name, scores))

    # Optionally generate radar chart
    if args.chart:
        render_radar(name, scores, args.output)


if __name__ == "__main__":
    main()
SHARED1_EOF
chmod +x "$PROJECT_ROOT/.agent/skills/scripts/create_idea_score_chart.py"

echo -e "  ${GREEN}✓${NC} scripts/create_idea_score_chart.py"

# Shared Script 2: create_impact_effort_matrix.py
cat << 'SHARED2_EOF' > "$PROJECT_ROOT/.agent/skills/scripts/create_impact_effort_matrix.py"
#!/usr/bin/env python3
"""
Impact-Effort Matrix Visualization (v1.0)

Default: ASCII 2x2 matrix (no dependencies)
Optional: Scatter plot PNG via matplotlib (--chart flag)

Usage:
    python create_impact_effort_matrix.py --name "AI 재고관리" --scores "4.2,3.1"
    python create_impact_effort_matrix.py --json idea.json
    python create_impact_effort_matrix.py --dir output/ideas/
    python create_impact_effort_matrix.py --dir output/ideas/ --chart --output matrix.png
"""

import argparse
import json
import sys
import os
import glob

# Quadrant definitions (Impact high/low x Effort high/low)
QUADRANTS = {
    "quick_win":      {"label": "Quick Win",      "desc": "즉시 실행",   "icon": "★"},
    "major_project":  {"label": "Major Project",  "desc": "장기 과제",   "icon": "◆"},
    "fill_in":        {"label": "Fill-in",        "desc": "자투리 과제", "icon": "○"},
    "thankless_task": {"label": "Thankless Task", "desc": "비효율 과제", "icon": "✕"},
}

# Midpoint threshold for quadrant classification (1-5 scale)
MID = 2.5


def calc_impact(score_details):
    """Calculate impact from score_details: (market_size * 5 + timing * 3) / 8."""
    market_size = score_details.get("market_size", 3)
    timing = score_details.get("timing", 3)
    return (market_size * 5 + timing * 3) / 8


def calc_effort(score_details):
    """Calculate effort from score_details: 6 - (resources * 3 + founder_fit * 5) / 8.
    Higher value = harder to execute."""
    resources = score_details.get("resources", 3)
    founder_fit = score_details.get("founder_fit", score_details.get("fit", 3))
    return 6 - (resources * 3 + founder_fit * 5) / 8


def classify_quadrant(impact, effort):
    """Classify into quadrant based on impact and effort values."""
    if impact >= MID and effort < MID:
        return "quick_win"
    elif impact >= MID and effort >= MID:
        return "major_project"
    elif impact < MID and effort < MID:
        return "fill_in"
    else:
        return "thankless_task"


def load_from_json(json_path):
    """Load a single idea from idea.json file."""
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    details = data.get("score_details", {})
    name = data.get("full_name", data.get("name", "Unknown"))
    impact = calc_impact(details)
    effort = calc_effort(details)
    return {"name": name, "impact": impact, "effort": effort}


def load_from_dir(dir_path):
    """Scan directory for idea.json files and load all."""
    ideas = []
    pattern = os.path.join(dir_path, "*/idea.json")
    for json_path in sorted(glob.glob(pattern)):
        try:
            idea = load_from_json(json_path)
            ideas.append(idea)
        except (json.JSONDecodeError, KeyError) as e:
            print(f"  경고: {json_path} 로드 실패 — {e}", file=sys.stderr)
    return ideas


def render_ascii(ideas):
    """Render ASCII 2x2 impact-effort matrix — zero dependencies."""
    # Classify ideas into quadrants
    buckets = {"quick_win": [], "major_project": [], "fill_in": [], "thankless_task": []}
    for idea in ideas:
        q = classify_quadrant(idea["impact"], idea["effort"])
        buckets[q].append(idea)

    lines = []
    lines.append(f"\n{'='*64}")
    lines.append("  Impact-Effort 매트릭스")
    lines.append(f"{'='*64}")
    lines.append("")

    # Axis labels
    lines.append(f"  Impact (높음)")
    lines.append(f"  {'│':>4}")

    # Top row: Quick Win (left) | Major Project (right)
    qw_items = buckets["quick_win"]
    mp_items = buckets["major_project"]
    # Bottom row: Fill-in (left) | Thankless Task (right)
    fi_items = buckets["fill_in"]
    tt_items = buckets["thankless_task"]

    col_w = 28

    def format_cell(items, qkey):
        """Format items for a quadrant cell."""
        q = QUADRANTS[qkey]
        cell_lines = []
        cell_lines.append(f"{q['icon']} {q['label']}")
        cell_lines.append(f"  ({q['desc']})")
        if items:
            for idea in items:
                cell_lines.append(f"  · {idea['name'][:18]}")
                cell_lines.append(f"    I={idea['impact']:.1f} E={idea['effort']:.1f}")
        else:
            cell_lines.append("  (없음)")
        return cell_lines

    qw_cell = format_cell(qw_items, "quick_win")
    mp_cell = format_cell(mp_items, "major_project")
    fi_cell = format_cell(fi_items, "fill_in")
    tt_cell = format_cell(tt_items, "thankless_task")

    # Render top row
    max_top = max(len(qw_cell), len(mp_cell))
    lines.append(f"  {'│':>4}  {'─' * (col_w * 2 + 3)}")
    for i in range(max_top):
        left = qw_cell[i] if i < len(qw_cell) else ""
        right = mp_cell[i] if i < len(mp_cell) else ""
        lines.append(f"  {'│':>4}  │ {left:<{col_w}} │ {right:<{col_w}} │")
    lines.append(f"  {'│':>4}  {'─' * (col_w * 2 + 3)}")

    # Render bottom row
    max_bot = max(len(fi_cell), len(tt_cell))
    for i in range(max_bot):
        left = fi_cell[i] if i < len(fi_cell) else ""
        right = tt_cell[i] if i < len(tt_cell) else ""
        lines.append(f"  {'│':>4}  │ {left:<{col_w}} │ {right:<{col_w}} │")
    lines.append(f"  {'│':>4}  {'─' * (col_w * 2 + 3)}")

    lines.append(f"  Impact (낮음)")
    lines.append(f"  {'':>4}  Effort (낮음) ──────────── Effort (높음)")
    lines.append("")

    # Detail table
    lines.append(f"  {'아이디어':<20} {'Impact':>7} {'Effort':>7}  {'사분면'}")
    lines.append(f"  {'─'*58}")
    for idea in ideas:
        q = classify_quadrant(idea["impact"], idea["effort"])
        qinfo = QUADRANTS[q]
        lines.append(
            f"  {idea['name'][:18]:<20} {idea['impact']:>5.2f}  {idea['effort']:>5.2f}   "
            f"{qinfo['icon']} {qinfo['label']} ({qinfo['desc']})"
        )
    lines.append(f"  {'─'*58}")
    lines.append("")

    # Action summary
    lines.append("  [권장 액션]")
    if buckets["quick_win"]:
        names = ", ".join(i["name"][:15] for i in buckets["quick_win"])
        lines.append(f"  ★ Quick Win → 즉시 실행: {names}")
    if buckets["major_project"]:
        names = ", ".join(i["name"][:15] for i in buckets["major_project"])
        lines.append(f"  ◆ Major Project → 로드맵 수립: {names}")
    if buckets["fill_in"]:
        names = ", ".join(i["name"][:15] for i in buckets["fill_in"])
        lines.append(f"  ○ Fill-in → 여유 시간 활용: {names}")
    if buckets["thankless_task"]:
        names = ", ".join(i["name"][:15] for i in buckets["thankless_task"])
        lines.append(f"  ✕ Thankless Task → 재검토 또는 보류: {names}")
    lines.append("")

    lines.append(f"{'='*64}")
    lines.append("  매핑: Impact=(market_size*5+timing*3)/8, Effort=6-(resources*3+fit*5)/8")
    lines.append(f"{'='*64}\n")

    return "\n".join(lines)


def render_chart(ideas, output_path):
    """Render scatter plot PNG via matplotlib — optional dependency."""
    try:
        import matplotlib
        matplotlib.use('Agg')
        import matplotlib.pyplot as plt
        import matplotlib.font_manager as fm
    except ImportError:
        print("  matplotlib 미설치 — 차트를 생략하고 텍스트 결과만 표시합니다.")
        print("    설치: pip install matplotlib")
        return False

    # Korean font setup
    for font_name in ['AppleGothic', 'NanumGothic', 'Malgun Gothic']:
        try:
            fm.findfont(font_name, fallback_to_default=False)
            plt.rcParams['font.family'] = font_name
            plt.rcParams['axes.unicode_minus'] = False
            break
        except Exception:
            continue

    fig, ax = plt.subplots(figsize=(10, 8))

    # Quadrant background colors
    ax.axhspan(MID, 5.5, xmin=0, xmax=0.5, alpha=0.10, color='#34A853', label='Quick Win')
    ax.axhspan(MID, 5.5, xmin=0.5, xmax=1.0, alpha=0.10, color='#4285F4', label='Major Project')
    ax.axhspan(0, MID, xmin=0, xmax=0.5, alpha=0.10, color='#FBBC04', label='Fill-in')
    ax.axhspan(0, MID, xmin=0.5, xmax=1.0, alpha=0.10, color='#EA4335', label='Thankless Task')

    # Quadrant divider lines
    ax.axhline(y=MID, color='gray', linestyle='--', linewidth=0.8, alpha=0.5)
    ax.axvline(x=MID, color='gray', linestyle='--', linewidth=0.8, alpha=0.5)

    # Quadrant labels
    ax.text(1.25, 4.5, 'Quick Win\n(즉시 실행)', ha='center', va='center',
            fontsize=10, color='#34A853', alpha=0.6, fontweight='bold')
    ax.text(3.75, 4.5, 'Major Project\n(장기 과제)', ha='center', va='center',
            fontsize=10, color='#4285F4', alpha=0.6, fontweight='bold')
    ax.text(1.25, 1.0, 'Fill-in\n(자투리 과제)', ha='center', va='center',
            fontsize=10, color='#FBBC04', alpha=0.6, fontweight='bold')
    ax.text(3.75, 1.0, 'Thankless Task\n(비효율 과제)', ha='center', va='center',
            fontsize=10, color='#EA4335', alpha=0.6, fontweight='bold')

    # Plot ideas
    colors = {'quick_win': '#34A853', 'major_project': '#4285F4',
              'fill_in': '#FBBC04', 'thankless_task': '#EA4335'}
    for idea in ideas:
        q = classify_quadrant(idea["impact"], idea["effort"])
        ax.scatter(idea["effort"], idea["impact"], s=200, c=colors[q],
                   edgecolors='white', linewidth=1.5, zorder=5)
        ax.annotate(idea["name"][:15], (idea["effort"], idea["impact"]),
                    textcoords="offset points", xytext=(8, 8),
                    fontsize=9, fontweight='bold')

    ax.set_xlabel("Effort (높을수록 어려움) →", fontsize=12)
    ax.set_ylabel("Impact (높을수록 효과적) →", fontsize=12)
    ax.set_xlim(0.5, 5.5)
    ax.set_ylim(0.5, 5.5)
    ax.set_xticks([1, 2, 3, 4, 5])
    ax.set_yticks([1, 2, 3, 4, 5])
    ax.set_title("Impact-Effort 매트릭스", fontsize=14, fontweight='bold', pad=15)
    ax.legend(loc='upper left', fontsize=9, framealpha=0.8)
    ax.grid(True, alpha=0.2)

    plt.tight_layout()
    plt.savefig(output_path, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"  매트릭스 차트 저장: {output_path}")
    return True


def main():
    parser = argparse.ArgumentParser(description="Impact-Effort Matrix Visualization (v1.0)")
    parser.add_argument("--name", help="Idea name (used with --scores)")
    parser.add_argument("--scores", help="Comma-separated impact,effort (e.g. '3.5,2.1')")
    parser.add_argument("--json", help="Load from idea.json file")
    parser.add_argument("--dir", help="Scan directory for idea.json files")
    parser.add_argument("--chart", action="store_true", help="Generate scatter plot PNG (requires matplotlib)")
    parser.add_argument("--output", default="impact-effort-matrix.png", help="Chart output path")
    args = parser.parse_args()

    ideas = []

    if args.dir:
        ideas = load_from_dir(args.dir)
        if not ideas:
            print(f"  오류: {args.dir} 에서 idea.json 파일을 찾을 수 없습니다.")
            sys.exit(1)
    elif args.json:
        ideas = [load_from_json(args.json)]
    elif args.name and args.scores:
        parts = [float(v.strip()) for v in args.scores.split(",")]
        if len(parts) != 2:
            print("  오류: --scores는 impact,effort 2개 값이 필요합니다 (예: '3.5,2.1')")
            sys.exit(1)
        ideas = [{"name": args.name, "impact": parts[0], "effort": parts[1]}]
    else:
        parser.print_help()
        sys.exit(1)

    # Always print ASCII matrix
    print(render_ascii(ideas))

    # Optionally generate scatter chart
    if args.chart:
        render_chart(ideas, args.output)


if __name__ == "__main__":
    main()
SHARED2_EOF
chmod +x "$PROJECT_ROOT/.agent/skills/scripts/create_impact_effort_matrix.py"

echo -e "  ${GREEN}✓${NC} scripts/create_impact_effort_matrix.py"

# Shared Script 3: create_portfolio_dashboard.py
python3 -c "
import shutil, os
src = os.path.join('$PROJECT_ROOT', '.agent', 'skills', 'scripts', 'create_portfolio_dashboard.py')
" 2>/dev/null

cat << 'SHARED3_EOF' > "$PROJECT_ROOT/.agent/skills/scripts/create_portfolio_dashboard.py"
#!/usr/bin/env python3
"""Idea Portfolio HTML Dashboard Generator

Reads output/ideas/*/idea.json files and generates a visual HTML dashboard
at output/ideas/portfolio-dashboard.html.

Usage:
    python create_portfolio_dashboard.py [--output-dir OUTPUT_DIR]

Requires Python 3.8+ standard library only (json, os, glob, datetime, pathlib).
"""

import argparse
import json
import os
import sys
from datetime import datetime
from pathlib import Path

STAGES = [
    {"id": 0, "name": "아이디어 발굴", "icon": "\U0001f4a1"},
    {"id": 1, "name": "시장 조사", "icon": "\U0001f4ca"},
    {"id": 2, "name": "경쟁 분석", "icon": "\U0001f50d"},
    {"id": 3, "name": "제품/원가", "icon": "\U0001f3f7\ufe0f"},
    {"id": 4, "name": "재무 모델", "icon": "\U0001f4b0"},
    {"id": 5, "name": "운영 계획", "icon": "\u2699\ufe0f"},
    {"id": 6, "name": "브랜딩", "icon": "\U0001f3a8"},
    {"id": 7, "name": "법률/인허가", "icon": "\u2696\ufe0f"},
    {"id": 8, "name": "사업계획서", "icon": "\U0001f4cb"},
]

TOTAL_STAGES = len(STAGES)  # 9 (0-8)


def find_project_root():
    script_path = Path(__file__).resolve()
    return script_path.parent.parent.parent.parent


def load_ideas(ideas_dir):
    ideas_dir = Path(ideas_dir)
    if not ideas_dir.exists():
        return []

    ideas = []
    for child in sorted(ideas_dir.iterdir()):
        if child.is_dir():
            idea_file = child / "idea.json"
            if idea_file.exists():
                try:
                    with open(idea_file, "r", encoding="utf-8") as f:
                        data = json.load(f)
                    data["dir_path"] = str(child)
                    ideas.append(data)
                except (json.JSONDecodeError, OSError):
                    continue
    return ideas


def check_stage_completion(idea_dir):
    idea_dir = Path(idea_dir)
    completed = [False] * TOTAL_STAGES

    if (idea_dir / "hypothesis.md").exists() or (idea_dir / "evaluation.md").exists():
        completed[0] = True

    research_dir = idea_dir / "research"
    if research_dir.exists():
        files = [f for f in research_dir.rglob("*") if f.is_file()]
        if files:
            completed[1] = True
        for f in files:
            fname = f.name.lower()
            if "경쟁" in fname or "competitor" in fname:
                completed[2] = True
                break

    financials_dir = idea_dir / "financials"
    if financials_dir.exists():
        for f in financials_dir.rglob("*"):
            if f.is_file():
                fname = f.name.lower()
                if "원가" in fname or "cost" in fname or "menu" in fname:
                    completed[3] = True
                if "재무" in fname or "financial" in fname or "projection" in fname:
                    completed[4] = True

    reports_dir = idea_dir / "reports"
    if reports_dir.exists():
        for f in reports_dir.rglob("*"):
            if f.is_file():
                fname = f.name.lower()
                if "운영" in fname or "operation" in fname:
                    completed[5] = True
                if "브랜딩" in fname or "brand" in fname:
                    completed[6] = True
                if "법률" in fname or "legal" in fname:
                    completed[7] = True
                if "사업계획" in fname or "business-plan" in fname:
                    completed[8] = True

    return completed


def _status_label(status):
    mapping = {"go": "Go", "pivot": "Pivot", "drop": "Drop"}
    return mapping.get(status, status or "미평가")


def _status_class(status):
    if status == "go":
        return "go"
    elif status == "pivot":
        return "pivot"
    elif status == "drop":
        return "drop"
    return ""


def _build_idea_card(idea, stages_completed):
    full_name = idea.get("full_name", idea.get("name", ""))
    status = idea.get("status", "")
    raw_score = idea.get("score", 0) or 0
    score = raw_score * 4 if raw_score <= 25 else raw_score
    score_details = idea.get("score_details", {})
    created = idea.get("created", "")
    completed_count = sum(stages_completed)
    percentage = round(completed_count / TOTAL_STAGES * 100)
    current_stage_name = "완료"
    next_stage_name = "-"
    for i, done in enumerate(stages_completed):
        if not done:
            current_stage_name = STAGES[i]["name"]
            next_idx = i + 1
            if next_idx < TOTAL_STAGES:
                next_stage_name = STAGES[next_idx]["name"]
            else:
                next_stage_name = "-"
            break
    score_items = [
        ("시장 크기", score_details.get("market_size", 0)),
        ("경쟁 강도", score_details.get("competition", 0)),
        ("적합성", score_details.get("fit", 0)),
        ("자원 요건", score_details.get("resources", 0)),
        ("타이밍", score_details.get("timing", 0)),
    ]
    score_bars_html = ""
    for label, value in score_items:
        width = (value or 0) * 20
        score_bars_html += f"""
                        <div class="score-bar-item">
                            <span class="score-label">{label}</span>
                            <div class="score-bar"><div class="score-fill" style="width:{width}%"></div></div>
                            <span class="score-value">{value}</span>
                        </div>"""
    badge_class = _status_class(status)
    badge_label = _status_label(status)
    return f"""
                <div class="idea-card">
                    <div class="idea-header">
                        <h3>{full_name}</h3>
                        <span class="badge {badge_class}">{badge_label}</span>
                    </div>
                    <div class="score-section">
                        <div class="total-score">{score}<span class="score-max">/100</span></div>
                        <div class="score-bars">{score_bars_html}
                        </div>
                    </div>
                    <div class="progress-section">
                        <div class="progress-label">진행률 {percentage}%</div>
                        <div class="progress-track"><div class="progress-fill" style="width:{percentage}%"></div></div>
                        <div class="current-stage">현재: {current_stage_name} &rarr; 다음: {next_stage_name}</div>
                    </div>
                    <div class="idea-meta">생성일: {created}</div>
                </div>"""


def _build_comparison_row(idea, stages_completed):
    full_name = idea.get("full_name", idea.get("name", ""))
    status = idea.get("status", "")
    score_details = idea.get("score_details", {})
    raw_score = idea.get("score", 0) or 0
    score = raw_score * 4 if raw_score <= 25 else raw_score
    completed_count = sum(stages_completed)
    percentage = round(completed_count / TOTAL_STAGES * 100)
    badge_class = _status_class(status)
    badge_label = _status_label(status)
    return f"""
                        <tr>
                            <td>{full_name}</td>
                            <td><span class="badge {badge_class}">{badge_label}</span></td>
                            <td>{score_details.get("market_size", "-")}</td>
                            <td>{score_details.get("competition", "-")}</td>
                            <td>{score_details.get("fit", "-")}</td>
                            <td>{score_details.get("resources", "-")}</td>
                            <td>{score_details.get("timing", "-")}</td>
                            <td><strong>{score}</strong></td>
                            <td>{percentage}%</td>
                        </tr>"""


def generate_html(ideas, output_path):
    enriched = []
    for idea in ideas:
        stages_completed = check_stage_completion(idea["dir_path"])
        enriched.append((idea, stages_completed))
    total = len(ideas)
    go_count = sum(1 for i in ideas if i.get("status") == "go")
    pivot_count = sum(1 for i in ideas if i.get("status") == "pivot")
    drop_count = sum(1 for i in ideas if i.get("status") == "drop")
    generated_at = datetime.now().strftime("%Y-%m-%d %H:%M")
    if total == 0:
        body_content = """
            <div class="empty-state">
                <h2>아직 아이디어가 없습니다</h2>
                <p>Antigravity 대화창에서 아래와 같이 말해보세요:</p>
                <div class="cmd-block"><pre>사업 아이디어를 찾아보고 싶어요</pre></div>
            </div>"""
    else:
        hero_html = f"""
            <div class="hero">
                <h1>아이디어 포트폴리오</h1>
                <p class="hero-subtitle">내 사업 아이디어를 한눈에 관리하세요</p>
                <div class="stats-grid">
                    <div class="stat-card"><div class="stat-number">{total}</div><div class="stat-label">전체 아이디어</div></div>
                    <div class="stat-card" style="border-top-color: var(--accent-green)"><div class="stat-number">{go_count}</div><div class="stat-label">Go (진행)</div></div>
                    <div class="stat-card" style="border-top-color: #f7971e"><div class="stat-number">{pivot_count}</div><div class="stat-label">Pivot (수정)</div></div>
                    <div class="stat-card" style="border-top-color: #ff6b9d"><div class="stat-number">{drop_count}</div><div class="stat-label">Drop (보류)</div></div>
                </div>
            </div>"""
        cards_html = ""
        for idea, stages_completed in enriched:
            cards_html += _build_idea_card(idea, stages_completed)
        grid_html = f"""
            <section class="cards-section">
                <div class="highlight-grid">{cards_html}
                </div>
            </section>"""
        rows_html = ""
        for idea, stages_completed in enriched:
            rows_html += _build_comparison_row(idea, stages_completed)
        comparison_html = f"""
            <section class="comparison">
                <h2>아이디어 비교</h2>
                <div class="table-wrapper">
                <table>
                    <thead><tr><th>아이디어</th><th>상태</th><th>시장</th><th>경쟁</th><th>적합</th><th>자원</th><th>타이밍</th><th>총점</th><th>진행률</th></tr></thead>
                    <tbody>{rows_html}
                    </tbody>
                </table>
                </div>
            </section>"""
        body_content = hero_html + f"""
            <div class="dashboard-body">
{grid_html}
{comparison_html}
            </div>"""
    html = f"""<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디어 포트폴리오 | Antigravity Business Planner</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;400;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css">
    <style>
        :root {{--bg-deep:#0a0e27;--bg-card:rgba(15,20,40,0.8);--text-primary:#e8edf5;--text-secondary:#8892b0;--text-muted:#5a6785;--accent-gold:#ffd700;--accent-blue:#667eea;--accent-cyan:#00d2ff;--accent-green:#43e97b;--border-glass:rgba(255,255,255,0.08);--border-glass-hover:rgba(255,255,255,0.15);--glass-standard:rgba(15,20,40,0.7);--blur-subtle:blur(8px);--blur-standard:blur(16px);--space-xs:8px;--space-sm:16px;--space-md:24px;--radius-sm:8px;--radius-md:16px;--font-mono:'JetBrains Mono','SF Mono','Monaco','Fira Code',monospace;--rainbow:linear-gradient(135deg,#667eea,#00d2ff,#43e97b,#f7971e,#ff6b9d,#c471ed);}}
        *,*::before,*::after{{box-sizing:border-box;margin:0;padding:0;}}
        body{{font-family:'Pretendard',-apple-system,BlinkMacSystemFont,"Apple SD Gothic Neo",sans-serif;background:var(--bg-deep);color:var(--text-primary);line-height:1.3;height:100dvh;overflow:hidden;font-size:clamp(0.7rem,1.2vh,0.95rem);}}
        h1,h2,h3{{font-family:'Outfit',sans-serif;}}
        .container{{max-width:1200px;margin:0 auto;padding:1vh 2vw 0.5vh;height:100dvh;display:grid;grid-template-rows:auto 1fr auto;}}
        .hero{{text-align:center;padding:0.5vh 0;}}.hero h1{{font-size:1.5rem;font-weight:600;background:var(--rainbow);background-size:200% auto;-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;margin-bottom:2px;}}.hero-subtitle{{color:var(--text-secondary);font-size:0.85rem;margin-bottom:var(--space-sm);}}
        .stats-grid{{display:grid;grid-template-columns:repeat(4,1fr);gap:var(--space-xs);max-width:500px;margin:0 auto;}}.stat-card{{background:var(--glass-standard);backdrop-filter:var(--blur-subtle);border:1px solid var(--border-glass);border-top:2px solid var(--accent-blue);border-radius:var(--radius-sm);padding:8px 10px;text-align:center;}}.stat-number{{font-family:'Outfit',sans-serif;font-size:1.3rem;font-weight:600;}}.stat-label{{font-size:0.72rem;color:var(--text-secondary);margin-top:2px;}}
        .dashboard-body{{display:grid;grid-template-columns:1fr 1fr;gap:1vw;min-height:0;overflow:hidden;}}.cards-section{{display:contents;}}.highlight-grid{{display:flex;flex-direction:column;gap:1vh;min-height:0;}}
        .idea-card{{flex:1;min-height:0;max-height:280px;display:flex;flex-direction:column;justify-content:center;background:var(--glass-standard);backdrop-filter:var(--blur-standard);border:1px solid var(--border-glass);border-radius:var(--radius-sm);padding:1.2vh 1vw;transition:all 0.2s ease;}}.idea-card:hover{{border-color:var(--border-glass-hover);box-shadow:0 4px 20px rgba(0,0,0,0.2);}}.idea-header{{display:flex;justify-content:space-between;align-items:center;margin-bottom:0.5vh;gap:6px;}}.idea-header h3{{font-size:0.95em;font-weight:600;line-height:1.2;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}}
        .badge{{display:inline-block;padding:4px 14px;border-radius:20px;font-size:0.78rem;font-weight:500;white-space:nowrap;flex-shrink:0;}}.badge.go{{background:rgba(67,233,123,0.15);color:var(--accent-green);border:1px solid rgba(67,233,123,0.3);}}.badge.pivot{{background:rgba(247,151,30,0.15);color:#f7971e;border:1px solid rgba(247,151,30,0.3);}}.badge.drop{{background:rgba(255,107,157,0.15);color:#ff6b9d;border:1px solid rgba(255,107,157,0.3);}}
        .score-section{{display:flex;align-items:flex-start;gap:0.5vw;margin-bottom:0.3vh;}}.total-score{{font-family:'Outfit',sans-serif;font-size:1.3rem;font-weight:600;color:var(--accent-cyan);white-space:nowrap;flex-shrink:0;}}.score-max{{font-size:0.75rem;color:var(--text-muted);font-weight:400;}}.score-bars{{flex:1;display:flex;flex-direction:column;gap:0.2vh;}}.score-bar-item{{display:flex;align-items:center;font-size:0.7rem;}}.score-label{{width:52px;color:var(--text-secondary);flex-shrink:0;}}.score-bar{{height:4px;background:rgba(255,255,255,0.1);border-radius:2px;flex:1;margin:0 6px;}}.score-fill{{height:100%;border-radius:2px;background:var(--rainbow);background-size:200% 100%;}}.score-value{{width:14px;text-align:right;color:var(--text-muted);flex-shrink:0;}}
        .progress-section{{margin-bottom:0.3vh;}}.progress-label{{font-size:0.72rem;color:var(--text-secondary);margin-bottom:3px;}}.progress-track{{height:5px;background:rgba(255,255,255,0.08);border-radius:3px;overflow:hidden;}}.progress-fill{{height:100%;border-radius:3px;background:linear-gradient(90deg,var(--accent-blue),var(--accent-cyan),var(--accent-green));}}.current-stage{{font-size:0.7rem;color:var(--text-muted);margin-top:3px;}}
        .idea-meta{{font-size:0.68em;color:var(--text-muted);padding-top:0.3vh;border-top:1px solid var(--border-glass);}}
        .comparison{{margin-top:0;display:flex;flex-direction:column;min-height:0;}}.comparison h2{{font-size:1rem;font-weight:600;margin-bottom:8px;}}.table-wrapper{{overflow-x:auto;}}.comparison table{{width:100%;border-collapse:collapse;font-size:0.78em;display:flex;flex-direction:column;flex:1;min-height:0;}}.comparison thead{{flex:0 0 auto;}}.comparison tbody{{flex:1;display:flex;flex-direction:column;min-height:0;}}.comparison tr{{flex:1;display:flex;align-items:center;}}.comparison th{{flex:1;text-align:left;padding:0.5vh 0.4vw;color:var(--text-secondary);font-weight:500;border-bottom:1px solid var(--border-glass-hover);white-space:nowrap;}}.comparison td{{flex:1;padding:0.5vh 0.4vw;border-bottom:1px solid var(--border-glass);color:var(--text-primary);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}}.comparison tr:hover td{{background:rgba(15,20,40,0.4);}}
        .empty-state{{text-align:center;padding:80px var(--space-md);}}.empty-state h2{{font-size:1.6rem;margin-bottom:var(--space-sm);color:var(--text-secondary);}}.cmd-block{{display:inline-block;background:var(--glass-standard);border:1px solid var(--border-glass);border-radius:var(--radius-sm);padding:var(--space-sm) var(--space-md);}}.cmd-block pre{{font-family:var(--font-mono);font-size:0.95rem;color:var(--accent-cyan);}}
        .footer{{text-align:center;padding-top:0.5vh;border-top:1px solid var(--border-glass);font-size:0.68em;color:var(--text-muted);}}
        @media(max-width:900px){{.dashboard-body{{grid-template-columns:1fr;overflow:auto;}}.stats-grid{{grid-template-columns:repeat(2,1fr);}}.score-section{{flex-direction:column;}}}}
    </style>
</head>
<body>
    <div class="container">
{body_content}
        <div class="footer">Antigravity Business Planner &mdash; Generated {generated_at}</div>
    </div>
</body>
</html>"""
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(html, encoding="utf-8")
    return str(output_path)


def main():
    parser = argparse.ArgumentParser(description="Idea Portfolio HTML Dashboard Generator")
    parser.add_argument("--output-dir", default=None, help="Output directory (default: output/ideas/)")
    args = parser.parse_args()
    project_root = find_project_root()
    if args.output_dir:
        output_dir = Path(args.output_dir)
    else:
        output_dir = project_root / "output" / "ideas"
    ideas_dir = project_root / "output" / "ideas"
    ideas = load_ideas(ideas_dir)
    output_path = output_dir / "portfolio-dashboard.html"
    try:
        result_path = generate_html(ideas, output_path)
        print(result_path)
        sys.exit(0)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
SHARED3_EOF
chmod +x "$PROJECT_ROOT/.agent/skills/scripts/create_portfolio_dashboard.py"

echo -e "  ${GREEN}✓${NC} scripts/create_portfolio_dashboard.py"

# 대용량 공유 스크립트 — git 저장소에 포함되어 있으므로 존재 확인만 수행
for script in create_outputs_dashboard.py create_mindmap.py; do
    if [ -f "$PROJECT_ROOT/.agent/skills/scripts/$script" ]; then
        echo -e "  ${GREEN}✓${NC} scripts/$script"
    else
        echo -e "  ${YELLOW}!${NC} scripts/$script (git 저장소에서 누락됨 — 기능 제한 없음)"
    fi
done

echo ""

# 외부 스킬 설치 (npx skills)
echo -e "${CYAN}  → 외부 스킬 설치 중 (launch-strategy, pricing-strategy, startup-metrics-framework)...${NC}"
if command -v npx &> /dev/null; then
    npx -y skills add sickn33/antigravity-awesome-skills --skill launch-strategy --skill pricing-strategy --skill startup-metrics-framework -a antigravity -y 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "  ${GREEN}✓${NC} 외부 스킬 3개 설치 완료"
        echo -e "  ${GREEN}✓${NC} launch-strategy"
        echo -e "  ${GREEN}✓${NC} pricing-strategy"
        echo -e "  ${GREEN}✓${NC} startup-metrics-framework"
    else
        warn "외부 스킬 설치 실패" "핵심 기능은 모두 사용 가능합니다. 이 스킬은 나중에 별도 설치할 수 있습니다"
    fi
else
    echo -e "  ${YELLOW}!${NC} npx를 찾을 수 없습니다. 외부 스킬 설치를 건너뜁니다."
    echo -e "  ${YELLOW}    Node.js 설치 후 수동 실행: npx skills add sickn33/antigravity-awesome-skills --skill launch-strategy --skill pricing-strategy --skill startup-metrics-framework -a antigravity -y${NC}"
fi

# Symlink fallback: ensure .agent/skills/ symlinks exist for extended skills
for ext_skill in launch-strategy pricing-strategy startup-metrics-framework; do
    if [ -d "$PROJECT_ROOT/.agents/skills/$ext_skill" ] && [ ! -L "$PROJECT_ROOT/.agent/skills/$ext_skill" ]; then
        ln -s "../../.agents/skills/$ext_skill" "$PROJECT_ROOT/.agent/skills/$ext_skill"
        echo -e "  ${GREEN}✓${NC} symlink: $ext_skill"
    fi
done
echo ""

# --- Step 6: Create Templates ---
echo -e "${BLUE}[6/10]${NC} 문서 템플릿 생성 중..."

# Template 1: business-plan-template.md
cat << 'TPL1_EOF' > "$PROJECT_ROOT/templates/business-plan-template.md"
# [사업명] 사업계획서

> 작성일: YYYY년 MM월 DD일
> 작성자: [이름]
> 버전: 1.0

---

## 1. Executive Summary (핵심 요약)

| 항목 | 내용 |
|------|------|
| 사업명 | |
| 사업 분야 | |
| 목표 시장 | |
| 핵심 가치 제안 | |
| 필요 투자금 | |
| 예상 BEP 도달 시점 | |
| 예상 1년차 매출 | |

### 사업 개요 (3-5문장)

[사업의 핵심을 간결하게 설명]

---

## 2. 사업 개요

### 2.1 비전 & 미션
- **비전**: [장기적으로 이루고자 하는 모습]
- **미션**: [고객에게 제공하는 핵심 가치]

### 2.2 핵심 가치
1.
2.
3.

### 2.3 사업 형태
- 사업자 유형: 개인 / 법인
- 업종:
- 소재지:

---

## 3. 제품/서비스

### 3.1 제품/서비스 설명
| 제품/서비스명 | 설명 | 가격대 | 타겟 고객 |
|--------------|------|--------|----------|
| | | | |

### 3.2 차별화 요소
1.
2.
3.

---

## 4. 시장 분석

### 4.1 시장 규모
| 구분 | 규모 | 근거 |
|------|------|------|
| TAM | | |
| SAM | | |
| SOM | | |

### 4.2 시장 트렌드
1.
2.
3.

### 4.3 타겟 고객
| 세그먼트 | 특성 | 규모 | 니즈 |
|----------|------|------|------|
| | | | |

---

## 5. 경쟁 분석

### 5.1 경쟁사 비교
| 항목 | 우리 | 경쟁사 A | 경쟁사 B | 경쟁사 C |
|------|------|---------|---------|---------|
| 가격 | | | | |
| 품질 | | | | |
| 서비스 | | | | |
| 접근성 | | | | |

### 5.2 경쟁 우위
1.
2.

---

## 6. 마케팅 전략

### 6.1 4P 전략
| 요소 | 전략 |
|------|------|
| Product (제품) | |
| Price (가격) | |
| Place (유통) | |
| Promotion (홍보) | |

### 6.2 고객 확보 전략
-

### 6.3 마케팅 예산
| 채널 | 월 예산 | 비중 |
|------|---------|------|
| | | |

---

## 7. 운영 계획

### 7.1 조직도
-

### 7.2 인력 계획
| 직무 | 인원 | 급여 | 채용 시기 |
|------|------|------|----------|
| | | | |

### 7.3 핵심 프로세스
1.
2.
3.

---

## 8. 재무 계획

### 8.1 초기 투자
| 항목 | 금액 |
|------|------|
| | |
| **합계** | |

### 8.2 월별 손익 (1년차)
| 월 | 매출 | 변동비 | 고정비 | 영업이익 |
|----|------|--------|--------|---------|
| 1월 | | | | |
| ... | | | | |

### 8.3 손익분기점
- BEP 매출:
- BEP 도달 예상:

---

## 9. 리스크 분석

| 리스크 | 확률 | 영향도 | 대응 방안 |
|--------|------|--------|----------|
| | 높/중/낮 | 높/중/낮 | |

---

## 10. 실행 로드맵

| 시기 | 마일스톤 | 핵심 활동 |
|------|---------|----------|
| 1-2개월 | | |
| 3-4개월 | | |
| 5-6개월 | | |
| 7-12개월 | | |

---

## 부록
- 상세 재무 모델
- 시장 조사 데이터
- 참고 자료
TPL1_EOF

# Template 2: financial-projection-template.md
cat << 'TPL2_EOF' > "$PROJECT_ROOT/templates/financial-projection-template.md"
# 재무 예측 모델

> 작성일: YYYY년 MM월 DD일
> ⚠️ 본 문서의 수치는 추정치이며, 실제 결과와 다를 수 있습니다.

---

## 핵심 가정 (Assumptions)

| 항목 | 가정값 | 근거 |
|------|--------|------|
| 월 영업일수 | 일 | |
| 일 평균 고객수 | 명 | |
| 객단가 | 원 | |
| 원가율 | % | |
| 월 매출 성장률 | % | |

---

## 1. 초기 투자 비용

| 구분 | 항목 | 금액 (만원) | 비고 |
|------|------|------------|------|
| 시설 | 보증금 | | |
| | 인테리어 | | |
| | 설비/장비 | | |
| 운영 | 초도 재고 | | |
| | 마케팅 (런칭) | | |
| | 인허가 비용 | | |
| 기타 | 예비비 (10%) | | |
| | **합계** | | |

---

## 2. 월별 고정비

| 항목 | 금액 (만원) | 비고 |
|------|------------|------|
| 임대료 | | |
| 인건비 | | |
| 보험료 | | |
| 통신/IT | | |
| 감가상각 | | |
| 기타 | | |
| **합계** | | |

---

## 3. 변동비 구조

| 항목 | 매출 대비 비율 | 비고 |
|------|---------------|------|
| 원재료비 | % | |
| 포장/소모품 | % | |
| 배송비 | % | |
| 카드수수료 | % | |
| **합계** | % | |

---

## 4. 월별 손익계산서 (1년차)

| 항목 | 1월 | 2월 | 3월 | ... | 12월 | 합계 |
|------|-----|-----|-----|-----|------|------|
| 매출 | | | | | | |
| 변동비 | | | | | | |
| **매출총이익** | | | | | | |
| 고정비 | | | | | | |
| **영업이익** | | | | | | |
| 영업이익률 | | | | | | |

---

## 5. 손익분기점 (BEP) 분석

| 항목 | 수치 |
|------|------|
| 월 고정비 | 만원 |
| 공헌이익률 | % |
| **BEP 월매출** | 만원 |
| **BEP 일매출** | 만원 |
| **BEP 일고객수** | 명 |
| 예상 BEP 도달 | 개월 후 |

---

## 6. 시나리오 분석

| 항목 | 비관적 | 기본 | 낙관적 |
|------|--------|------|--------|
| 월 매출 | | | |
| 원가율 | | | |
| 고정비 | | | |
| 월 영업이익 | | | |
| BEP 도달 | | | |
| 1년차 누적 이익 | | | |

---

## 7. 3개년 요약

| 항목 | 1년차 | 2년차 | 3년차 |
|------|-------|-------|-------|
| 매출 | | | |
| 매출원가 | | | |
| 매출총이익 | | | |
| 판매관리비 | | | |
| 영업이익 | | | |
| 영업이익률 | | | |
TPL2_EOF

# Template 3: market-analysis-template.md
cat << 'TPL3_EOF' > "$PROJECT_ROOT/templates/market-analysis-template.md"
# 시장 분석 보고서

> 작성일: YYYY년 MM월 DD일
> 대상 시장: [시장명]

---

## 핵심 요약

[시장 분석의 주요 발견사항을 3-5문장으로 요약]

---

## 1. 시장 규모

### 1.1 TAM / SAM / SOM

| 구분 | 정의 | 규모 | 산출 근거 |
|------|------|------|----------|
| TAM (전체 시장) | | 억원 | |
| SAM (접근 가능 시장) | | 억원 | |
| SOM (목표 시장) | | 억원 | |

### 1.2 시장 성장률
| 연도 | 시장 규모 | 성장률 |
|------|----------|--------|
| | | |

---

## 2. 산업 트렌드

### 2.1 주요 트렌드
1. **[트렌드 1]**: 설명
2. **[트렌드 2]**: 설명
3. **[트렌드 3]**: 설명

### 2.2 기술/혁신 트렌드
-

### 2.3 소비자 행동 변화
-

---

## 3. 고객 세그먼트

### 세그먼트 A: [이름]
| 항목 | 내용 |
|------|------|
| 연령대 | |
| 소득 수준 | |
| 주요 니즈 | |
| 구매 행동 | |
| 예상 규모 | |

### 세그먼트 B: [이름]
| 항목 | 내용 |
|------|------|
| 연령대 | |
| 소득 수준 | |
| 주요 니즈 | |
| 구매 행동 | |
| 예상 규모 | |

---

## 4. 경쟁 환경

### 4.1 Porter's Five Forces
| 요인 | 강도 | 분석 |
|------|------|------|
| 기존 경쟁자 | 높/중/낮 | |
| 신규 진입자 위협 | 높/중/낮 | |
| 대체재 위협 | 높/중/낮 | |
| 공급자 교섭력 | 높/중/낮 | |
| 구매자 교섭력 | 높/중/낮 | |

### 4.2 주요 경쟁사
| 경쟁사 | 시장점유율 | 강점 | 약점 |
|--------|----------|------|------|
| | | | |

---

## 5. 진입 장벽

| 장벽 유형 | 수준 | 설명 | 대응 전략 |
|----------|------|------|----------|
| 자본 요건 | | | |
| 기술 요건 | | | |
| 규제 요건 | | | |
| 브랜드 충성도 | | | |

---

## 6. 기회와 위협

### 기회
1.
2.
3.

### 위협
1.
2.
3.

---

## 7. 시사점 및 권장사항

### 핵심 시사점
1.
2.
3.

### 권장 액션 아이템
- [ ]
- [ ]
- [ ]

---

## 데이터 출처
1.
2.
3.
TPL3_EOF

# Template 4: pitch-deck-outline.md
cat << 'TPL4_EOF' > "$PROJECT_ROOT/templates/pitch-deck-outline.md"
# 피치덱 구성안

> 작성일: YYYY년 MM월 DD일
> 발표 대상: [투자자 / 파트너 / 내부]
> 예상 발표 시간: 10-15분

---

## 슬라이드 1: 표지
- **사업명**:
- **한 줄 설명**:
- **발표자**:
- **날짜**:

> 스피커 노트: 간결한 자기소개와 발표 목적을 30초 내로 전달

---

## 슬라이드 2: 문제 정의
- **핵심 문제**:
- **현재 상황**:
- **영향 받는 사람들**:
- **수치로 본 문제의 크기**:

> 스피커 노트: 청중이 공감할 수 있는 구체적인 사례로 시작

---

## 슬라이드 3: 솔루션
- **우리의 해결책**:
- **작동 방식**:
- **핵심 가치**:

> 스피커 노트: "우리는 [문제]를 [방법]으로 해결합니다" 공식 활용

---

## 슬라이드 4: 시장 기회
- **TAM**:
- **SAM**:
- **SOM**:
- **성장률**:

> 스피커 노트: Bottom-up 방식으로 시장 규모 산출 과정 설명

---

## 슬라이드 5: 비즈니스 모델
- **수익 구조**:
- **가격 전략**:
- **고객 생애 가치 (LTV)**:
- **고객 획득 비용 (CAC)**:

> 스피커 노트: 단위 경제성(Unit Economics)을 명확히 설명

---

## 슬라이드 6: 경쟁 우위
- **경쟁사 대비 포지셔닝**:
- **핵심 차별점**:
- **진입 장벽/해자(Moat)**:

> 스피커 노트: 2x2 매트릭스로 포지셔닝 시각화

---

## 슬라이드 7: 트랙션 / 검증
- **현재까지 성과**:
- **핵심 지표**:
- **고객 반응**:

> 스피커 노트: 수치와 그래프로 성장세 강조

---

## 슬라이드 8: 마케팅 전략
- **고객 확보 채널**:
- **성장 전략**:
- **파트너십**:

> 스피커 노트: 구체적인 채널별 CAC와 전환율 제시

---

## 슬라이드 9: 재무 계획
- **1년차 예상 매출**:
- **3개년 매출 전망**:
- **주요 비용 구조**:
- **손익분기점**:

> 스피커 노트: 핵심 가정과 시나리오별 차이 설명

---

## 슬라이드 10: 팀
- **대표**: [이름] - [경력/강점]
- **핵심 멤버**:
- **자문단/멘토**:

> 스피커 노트: "왜 우리 팀이 이 문제를 풀 수 있는가" 강조

---

## 슬라이드 11: 로드맵
| 시기 | 목표 | 핵심 지표 |
|------|------|----------|
| ~3개월 | | |
| ~6개월 | | |
| ~12개월 | | |
| ~18개월 | | |

> 스피커 노트: 현실적이고 측정 가능한 마일스톤 제시

---

## 슬라이드 12: 투자 요청 (Ask)
- **필요 투자금**:
- **투자금 사용 계획**:
  - 제품 개발: %
  - 마케팅: %
  - 운영: %
  - 인력: %
- **기대 성과**:

> 스피커 노트: 투자금이 어떻게 다음 마일스톤 달성에 연결되는지 설명

---

## Q&A 대비 예상 질문
1.
2.
3.
4.
5.
TPL4_EOF

# Template 5: idea-evaluation-template.md
cat << 'TPL5_EOF' > "$PROJECT_ROOT/templates/idea-evaluation-template.md"
# 아이디어 평가서

> 작성일: YYYY년 MM월 DD일
> 평가 대상: [아이디어명]

---

## 핵심 요약

[아이디어를 1문단으로 요약]

---

## 1. 사용자 프로필

| 항목 | 내용 |
|------|------|
| 업종/산업 | |
| 경력/경험 | |
| 핵심 역량 | |
| 가용 자원 | |
| 목표 고객층 | |

---

## 2. 아이디어 후보

### 아이디어 A: [이름]
[1문단 요약]

### 아이디어 B: [이름]
[1문단 요약]

### 아이디어 C: [이름]
[1문단 요약]

---

## 3. 정량 평가 (5점 척도)

| 평가 항목 | 아이디어 A | 아이디어 B | 아이디어 C |
|-----------|-----------|-----------|-----------|
| 시장 크기 | /5 | /5 | /5 |
| 경쟁 강도 | /5 | /5 | /5 |
| 적합성 | /5 | /5 | /5 |
| 자원 요건 | /5 | /5 | /5 |
| 타이밍 | /5 | /5 | /5 |
| **총점** | **/25** | **/25** | **/25** |
| **판정** | Go/Pivot-optimize/Pivot-review/Drop | Go/Pivot-optimize/Pivot-review/Drop | Go/Pivot-optimize/Pivot-review/Drop |

**판정 기준:** Go (80+) / Pivot-optimize (66-79) / Pivot-review (48-65) / Drop (47-)

---

## 4. 검증 결과 (Go/Pivot 아이디어만)

### 4.1 시장 존재 여부
| 항목 | 내용 |
|------|------|
| 유사 서비스 | |
| 차별점 | |
| 고객 수요 신호 | |

### 4.2 핵심 가정
1.
2.
3.

### 4.3 수익 모델
| 항목 | 내용 |
|------|------|
| 수익 구조 | |
| 예상 객단가 | |
| 지불 의향 근거 | |

### 4.4 MVP 검증 방안
| 항목 | 내용 |
|------|------|
| 검증 방법 | |
| 예상 비용 | |
| 소요 기간 | |
| 성공 기준 | |

---

## 5. 최종 판정

| 항목 | 내용 |
|------|------|
| 선택 아이디어 | |
| 판정 | Go / Pivot / Drop |
| 총점 | /25 |
| 핵심 사유 | |

---

## 6. 다음 단계

- [ ] Step 1: 시장 조사 (/market-research)
- [ ] Step 1-1: 경쟁 분석 (/competitor-analysis)
- [ ] Step 2: SWOT 분석

---

## 참고 사항
- 평가 점수는 추정치이며, 실제 시장 조사 후 재평가가 필요합니다
- 전문 법률/재무 자문은 별도로 받으시길 권합니다
TPL5_EOF

echo -e "  ${GREEN}✓${NC} idea-evaluation-template.md"

# Template 6: portfolio-template.md
cat << 'TPL6_EOF' > "$PROJECT_ROOT/templates/portfolio-template.md"
---
name: 포트폴리오 대시보드
description: 여러 사업 아이디어의 진행 현황을 한눈에 비교하는 대시보드 템플릿
---

# 사업 아이디어 포트폴리오

> 마지막 업데이트: {update_date}
> 총 아이디어: {total_ideas}개 | Go: {go_count} | Pivot: {pivot_count} | Drop: {drop_count} | 미평가: {unrated_count}

<!-- AUTO:START - 이 영역은 자동 생성됩니다. 편집하지 마세요. -->

## 아이디어 현황

| # | 아이디어 | 상태 | 점수 | 진행 단계 | 진행률 | 생성일 |
|---|----------|------|------|-----------|--------|--------|
{idea_rows}

## 단계별 요약

| 단계 | 설명 | 완료 아이디어 |
|------|------|---------------|
| 0 | 아이디어 발굴 | {stage_0_complete} |
| 1 | 시장 조사 | {stage_1_complete} |
| 2 | 경쟁 분석 | {stage_2_complete} |
| 3 | 제품/원가 | {stage_3_complete} |
| 4 | 재무 모델 | {stage_4_complete} |
| 5 | 운영 계획 | {stage_5_complete} |
| 6 | 브랜딩 | {stage_6_complete} |
| 7 | 법률/인허가 | {stage_7_complete} |
| 8 | 사업계획서 | {stage_8_complete} |

<!-- AUTO:END -->

## 나의 메모

> 이 영역은 자유롭게 편집할 수 있습니다. 자동 업데이트 시에도 이 영역은 보존됩니다.

### 우선순위
-

### 다음 할 일
-

### 비교 메모
-
TPL6_EOF

echo -e "  ${GREEN}✓${NC} portfolio-template.md"

# Template 7: Lean Canvas
cat << 'TPL7_EOF' > "$PROJECT_ROOT/templates/lean-canvas-template.md"
# Lean Canvas

## 1. 문제 (Problem)
| 순위 | 핵심 문제 |
|------|----------|
| 1 | |
| 2 | |
| 3 | |

**기존 대안:** (현재 이 문제를 어떻게 해결하고 있는가?)

## 2. 고객 세그먼트 (Customer Segments)
| 세그먼트 | 특성 | 규모 |
|---------|------|------|
| 얼리어답터 | | |
| 주요 타겟 | | |

## 3. 고유 가치 제안 (Unique Value Proposition)
**한 문장 정의:**

**High-level 컨셉:**

## 4. 솔루션 (Solution)
| 문제 | 핵심 기능 |
|------|----------|
| 문제 1 | |
| 문제 2 | |
| 문제 3 | |

## 5. 채널 (Channels)
* 인바운드:
* 아웃바운드:

## 6. 수익원 (Revenue Streams)
| 수익 모델 | 가격 | 예상 매출 |
|----------|------|----------|
| | | |

## 7. 비용 구조 (Cost Structure)
| 항목 | 월 비용 | 비고 |
|------|--------|------|
| 고정비 | | |
| 변동비 | | |

## 8. 핵심 지표 (Key Metrics)
| 지표 | 현재 | 목표 |
|------|------|------|
| | | |

## 9. 경쟁 우위 (Unfair Advantage)
* (쉽게 복제하거나 구매할 수 없는 것)
TPL7_EOF

echo -e "  ${GREEN}✓${NC} lean-canvas-template.md"

# Template 8: AI Business Financial Template
cat << 'TPL8_EOF' > "$PROJECT_ROOT/templates/ai-business-financial-template.md"
# AI 사업 재무 모델

## 핵심 요약 (Executive Summary)
* 사업명:
* AI 사업 유형:
* 예상 BEP:
* AI 마진 목표:

## 1. 초기 투자 비용

| 항목 | 금액 (만원) | 비고 |
|------|-----------|------|
| 모델 학습/파인튜닝 | | |
| 학습 데이터 구매/수집 | | |
| AI 인프라 설정 (GPU/클라우드) | | |
| MVP 개발 | | |
| **합계** | | |

## 2. 고정비 (월)

| 항목 | 금액 (만원) | 비고 |
|------|-----------|------|
| AI 개발 인건비 | | |
| 클라우드 기본 인프라 | | |
| SaaS 구독 (모니터링, MLOps 등) | | |
| **합계** | | |

## 3. AI 변동비 (월, MAU 기준)

| 항목 | 단가 | MAU 100 | MAU 1,000 | MAU 10,000 | MAU 100,000 |
|------|------|---------|-----------|------------|-------------|
| LLM API 호출 (원/1K토큰) | | | | | |
| 임베딩/벡터 검색 | | | | | |
| GPU 컴퓨팅 (추론) | | | | | |
| GPU 컴퓨팅 (학습) | | | | | |
| 데이터 저장/전송 | | | | | |
| **변동비 합계** | | | | | |

## 4. 비용 스케일링 모델

| MAU | 고정비 | 변동비 | 총 비용 | 인당 비용 |
|-----|-------|--------|--------|----------|
| 100 | | | | |
| 1,000 | | | | |
| 10,000 | | | | |
| 100,000 | | | | |

## 5. 단위 경제학 (Unit Economics)

| 지표 | 수치 | 판정 |
|------|------|------|
| ARPU (인당 월 매출) | | |
| AI 마진 (매출-AI변동비)/매출 | | >60% 양호 |
| CAC (고객획득비용) | | |
| LTV (고객생애가치) | | |
| LTV/CAC | | >3배 양호 |

## 6. AI 재무 건전성 지표

| 지표 | 수치 | 양호 | 주의 | 위험 |
|------|------|------|------|------|
| AI 마진 | | >60% | 40-60% | <40% |
| LTV/CAC | | >3배 | 2-3배 | <2배 |
| BEP 도달 | | <18개월 | 18-24개월 | >24개월 |
| AI 비용 비중 (총비용 대비) | | <40% | 40-60% | >60% |
| R&D 비율 (매출 대비) | | 20-40% | 10-20% | <10% 또는 >50% |

## 7. AI 비용 리스크

| 리스크 | 영향 | 대응 방안 |
|--------|------|----------|
| API 가격 인상 | | |
| 오픈소스 대체재 출현 | | |
| AI 규제 비용 | | |
| 데이터 저작권 이슈 | | |

## 8. 3개년 AI 재무 전망

| 항목 | 1년차 | 2년차 | 3년차 |
|------|-------|-------|-------|
| MAU | | | |
| 매출 | | | |
| AI 변동비 | | | |
| 고정비 | | | |
| 영업이익 | | | |
| AI 마진 | | | |

## 다음 단계
* [ ] 실제 API 비용 테스트 (소규모 PoC)
* [ ] 경쟁사 AI 비용 구조 조사
* [ ] 사용량 기반 가격 모델 시뮬레이션
TPL8_EOF

echo -e "  ${GREEN}✓${NC} ai-business-financial-template.md"

# Template 9: Micro-SaaS Financial Template (Phase 7)
cat << 'TPL9_EOF' > "$PROJECT_ROOT/templates/micro-saas-financial-template.md"
# Micro-SaaS 재무 모델 템플릿

> 이 템플릿은 1인/소규모 SaaS 사업의 재무 모델링에 사용됩니다.
> business_scale이 "micro" 또는 "small"일 때 자동으로 이 템플릿이 적용됩니다.

## 1. 비용 구조

### 고정비 (월간)

| 항목 | 예상 비용 | 비고 |
|------|----------|------|
| 도메인 | $1/월 ($12/년) | .com 기준 |
| 호스팅/서버 | $5-50/월 | Vercel, Railway, Fly.io 등 |
| 데이터베이스 | $0-25/월 | Supabase 무료~Pro |
| 이메일 서비스 | $0-20/월 | Resend, Postmark |
| 분석 도구 | $0-10/월 | Plausible, Umami |
| 에러 모니터링 | $0-15/월 | Sentry 무료 티어 |
| **소계** | **$6-121/월** | |

### 변동비 (사용량 비례)

| 항목 | 단가 | 월 100명 | 월 1,000명 | 월 10,000명 |
|------|------|---------|-----------|------------|
| API 호출 (AI) | $X/1K req | | | |
| 결제 수수료 | 2.9% + $0.30 | | | |
| CDN/대역폭 | $X/GB | | | |
| 고객 지원 도구 | $0-50/월 | | | |

### 1인 빌더 시간 비용 (선택 산출)

| 활동 | 주간 시간 | 시간당 가치 | 월 환산 |
|------|----------|-----------|--------|
| 개발 | h | $/h | $ |
| 마케팅/콘텐츠 | h | $/h | $ |
| 고객 지원 | h | $/h | $ |
| 운영/관리 | h | $/h | $ |

> "이 수치는 기회비용 추정이며, 실제 현금 지출은 아닙니다"

## 2. 수익 모델

### 가격 티어 설계

| 티어 | 월 가격 | 연 가격 (할인) | 예상 비율 |
|------|--------|--------------|----------|
| Free | $0 | - | 70-80% |
| Pro | $X/월 | $X/년 (20% 할인) | 15-25% |
| Team | $X/월/석 | $X/년/석 | 5-10% |

### MRR 예측

| 월 | 신규 유료 고객 | 이탈 | 순증 | 누적 유료 | MRR | 비용 | 손익 |
|----|-------------|------|------|----------|-----|------|------|
| 1 | | | | | $ | $ | $ |
| ... | | | | | | | |
| 12 | | | | | $ | $ | $ |

## 3. Unit Economics

| 지표 | 산식 | 목표값 | 실제값 |
|------|------|--------|--------|
| ARPU | 총 MRR / 유료 고객 수 | | |
| Monthly Churn Rate | 이탈 고객 / 전월 고객 | <5% | |
| LTV | ARPU / Churn Rate | | |
| CAC | 마케팅 비용 / 신규 유료 고객 | | |
| LTV/CAC | LTV / CAC | >3x | |
| Payback Period | CAC / ARPU | <6개월 | |

## 4. 손익분기점 (BEP)

* **월 고정비**: $___
* **ARPU**: $___
* **BEP 고객 수**: 고정비 / ARPU = ___ 명
* **예상 BEP 도달**: ___개월차

## 5. 시나리오 분석

| 시나리오 | 월 성장률 | 12개월 후 MRR | BEP 도달 |
|---------|----------|-------------|---------|
| 비관적 | 5% | $ | 개월 |
| 기본 | 10% | $ | 개월 |
| 낙관적 | 20% | $ | 개월 |

## 6. 핵심 재무 건전성 지표 (Micro-SaaS 5개)

| 지표 | 산식 | 양호 기준 | 판정 |
|------|------|----------|------|
| MRR 성장률 | (이번달 MRR - 지난달) / 지난달 | >10%/월 | |
| 이익률 | (MRR - 총비용) / MRR | >80% | |
| LTV/CAC | LTV / CAC | >3x | |
| Churn Rate | 월 이탈률 | <5% | |
| 현금 활주로 | 잔여 자금 / 월 순손실 | >6개월 | |

> "이 수치는 추정치이며, 실제와 다를 수 있습니다"
TPL9_EOF

echo -e "  ${GREEN}✓${NC} micro-saas-financial-template.md"

# Template 10: Bootstrap Growth Template (Phase 7)
cat << 'TPL10_EOF' > "$PROJECT_ROOT/templates/bootstrap-growth-template.md"
# 부트스트랩 성장 전략 템플릿

> 이 템플릿은 투자 없이 자체 수익으로 성장하는 사업의 마케팅/성장 전략에 사용됩니다.

## 1. 성장 로드맵

### Phase 1: 씨앗 (0-3개월) — 첫 10명 유료 고객

| 주차 | 목표 | 핵심 활동 | KPI |
|------|------|----------|-----|
| 1-2 | MVP 출시 | 랜딩페이지 + 핵심 기능 1개 | 가입 수 |
| 3-4 | 첫 고객 | 타겟 커뮤니티 직접 아웃리치 | 유료 전환 |
| 5-8 | 피드백 루프 | 고객 인터뷰, 기능 개선 | NPS, Churn |
| 9-12 | PMF 신호 | 유기적 유입 시작 | 월 성장률 |

### Phase 2: 뿌리 (3-6개월) — MRR $1K

| 채널 | 활동 | 예상 비용 | 예상 효과 |
|------|------|----------|----------|
| SEO | 비교 페이지, 사용법 글 10개 | $0 (시간) | 월 500 방문 |
| 커뮤니티 | Reddit/IndieHackers 주 2회 참여 | $0 (시간) | 월 100 방문 |
| Product Hunt | 런칭 1회 | $0 | 1일 1,000+ 방문 |
| 레퍼럴 | 기존 고객 추천 프로그램 | 20% 할인 | 월 5명 |

### Phase 3: 성장 (6-12개월) — MRR $5K

| 채널 | 활동 | 예상 비용 | 예상 효과 |
|------|------|----------|----------|
| SEO | 롱테일 키워드 50개 타겟 | $0-100 (도구) | 월 2,000 방문 |
| 콘텐츠 | 뉴스레터, 가이드 | $0 (시간) | 구독자 500+ |
| 유료 광고 (선택) | Google/Twitter 소액 테스트 | $100-500/월 | CAC 측정 |
| 파트너십 | 보완 제품과 교차 프로모션 | $0 | 상호 트래픽 |

## 2. 채널별 ROI 추정

| 채널 | 월 투자 (시간/비용) | 예상 신규 고객 | CAC | ROI |
|------|-------------------|-------------|-----|-----|
| SEO/블로그 | h + $ | 명 | $ | |
| 커뮤니티 | h | 명 | $ | |
| Product Hunt | h (1회) | 명 | $ | |
| 유료 광고 | $ | 명 | $ | |
| 레퍼럴 | 할인 비용 | 명 | $ | |

## 3. Product Hunt 런칭 체크리스트

- [ ] 랜딩페이지 최적화 (영어)
- [ ] 태그라인 작성 (60자 이내)
- [ ] 스크린샷/데모 영상 준비
- [ ] 메이커 코멘트 작성
- [ ] 서포터 네트워크 사전 알림 (50명+)
- [ ] 런칭일 선택 (화-목 추천)
- [ ] 첫 시간 반응 모니터링 계획

## 4. 주간/월간 성장 지표 추적

### 주간 추적

| 주차 | 방문자 | 가입 | 유료 전환 | MRR | Churn |
|------|--------|------|----------|-----|-------|
| W1 | | | | $ | |
| ... | | | | | |

### 월간 코호트 분석

| 가입 월 | 1개월 잔존 | 3개월 잔존 | 6개월 잔존 | 12개월 잔존 |
|---------|----------|----------|----------|-----------|
| | % | % | % | % |

## 5. 가격 전략

### 프리미엄 모델 설계

| 요소 | Free | Pro | Team |
|------|------|-----|------|
| 핵심 기능 | 제한적 | 전체 | 전체 |
| 사용량 | 제한 | 확장 | 무제한 |
| 지원 | 커뮤니티 | 이메일 | 우선 지원 |
| 가격 | $0 | $X/월 | $X/석/월 |

### 연간 할인
* 연간 결제 시 ___% 할인 (일반적 기준: 16-20%)
* 목표: 연간 결제 비율 30%+ (현금 흐름 안정화)
TPL10_EOF

echo -e "  ${GREEN}✓${NC} bootstrap-growth-template.md"

# MCP Config Template
cat << 'MCP_EOF' > "$PROJECT_ROOT/mcp-config-template.json"
{
  "_comment": "Google Antigravity MCP Server Configuration Template for Business Planning",
  "_instructions": "Copy relevant sections to ~/.gemini/antigravity/mcp_config.json",

  "mcpServers": {
    "_google-sheets": {
      "_comment": "Google Sheets - for financial modeling and data management",
      "_setup": "1. Enable Google Sheets API in GCP Console, 2. Create OAuth 2.0 credentials, 3. Download credentials JSON",
      "command": "uv",
      "args": [
        "--directory", "/path/to/sheets-mcp-server",
        "run", "sheets",
        "--creds-file-path", "/path/to/credentials.json",
        "--token-path", "/path/to/tokens.json"
      ]
    },
    "_notion": {
      "_comment": "Notion - for document management and collaboration",
      "_setup": "1. Create Notion integration at notion.so/my-integrations, 2. Get API key, 3. Share pages with integration",
      "command": "npx",
      "args": ["-y", "@notionhq/notion-mcp-server"],
      "env": {
        "OPENAPI_MCP_HEADERS": "{\"Authorization\": \"Bearer YOUR_NOTION_API_KEY\", \"Notion-Version\": \"2022-06-28\"}"
      }
    },
    "_perplexity": {
      "_comment": "Perplexity Ask - for real-time market research",
      "_setup": "Available directly in Antigravity MCP Store. Search 'Perplexity' and click Install.",
      "note": "Install from MCP Store - no manual config needed"
    },
    "_sequential-thinking": {
      "_comment": "Sequential Thinking - for structured analysis",
      "_setup": "Available directly in Antigravity MCP Store. Search 'Sequential Thinking' and click Install.",
      "note": "Install from MCP Store - no manual config needed"
    }
  }
}
MCP_EOF

echo -e "  ${GREEN}✓${NC} business-plan-template.md"
echo -e "  ${GREEN}✓${NC} financial-projection-template.md"
echo -e "  ${GREEN}✓${NC} market-analysis-template.md"
echo -e "  ${GREEN}✓${NC} pitch-deck-outline.md"
echo -e "  ${GREEN}✓${NC} mcp-config-template.json"
echo ""

# --- Step 7: Create Sample Data ---
echo -e "${BLUE}[7/10]${NC} 샘플 데이터 생성 중..."

# Sample 1: 01-시장조사.md
cat << 'SAMPLE1_EOF' > "$PROJECT_ROOT/output/samples/cafe/01-시장조사.md"
# 시장 조사 보고서
## 스페셜티 카페 사업 시장 분석

⚠️ **본 문서의 수치는 샘플 데이터이며 실제와 다를 수 있습니다.**

---

## Executive Summary

한국 커피 시장은 2025년 기준 약 8조원 규모로, 연평균 8-12% 성장세를 보이고 있습니다. 서울 강남 지역의 스페셜티 커피 시장은 프리미엄 소비 트렌드와 함께 지속적으로 확대되고 있으며, 특히 25-40세 오피스 워커들의 '카페 경험' 중심 소비가 두드러집니다. 초기 진입 장벽은 높지만, 차별화된 경험과 품질로 시장 진입이 가능한 환경입니다.

---

## 시장 규모 분석 (TAM-SAM-SOM)

| 구분 | 시장 규모 | 설명 |
|------|-----------|------|
| **TAM** (Total Addressable Market) | 약 8조원 | 2025년 한국 전체 커피 시장 (프랜차이즈, 개인카페, 편의점 포함) |
| **SAM** (Serviceable Available Market) | 약 4,500억원 | 서울 지역 스페셜티 커피 시장 (프리미엄 세그먼트) |
| **SOM** (Serviceable Obtainable Market) | 약 120억원 | 강남 지역 프리미엄 카페 목표 시장 (1-2년 내 달성 가능) |

### 시장 성장률
- **2023-2025**: 연평균 8-12% 성장
- **스페셜티 세그먼트**: 연평균 15-18% 고성장
- **온라인/구독 모델**: 연평균 20%+ 급성장

---

## 주요 시장 트렌드

### 1. 스페셜티 커피 수요 확대
- **싱글 오리진**, **핸드드립** 등 프리미엄 커피 선호도 증가
- 소비자들의 커피 리터러시 향상
- 제3의 물결 커피 문화 정착

### 2. 카페 경험 중심 소비
- '인스타그래머블' 공간 설계 중요도 상승
- 장시간 체류형 카페 선호 (업무, 모임 공간)
- 브랜드 스토리텔링과 가치 소비

### 3. 건강 및 다양성 트렌드
- 디카페인, 식물성 우유 옵션 수요 증가
- 저당, 무설탕 음료 선호
- 알레르기 프리 메뉴 확대

### 4. 구독 및 멤버십 모델
- 월정액 구독 서비스 (무제한 또는 할인)
- 앱 기반 주문 및 포인트 적립
- 커뮤니티 기반 로열티 프로그램

---

## 고객 세그먼트 분석

### 세그먼트 1: 직장인 프리미엄 소비자

| 항목 | 내용 |
|------|------|
| **연령대** | 28-40세 |
| **직업** | 대기업/외국계 회사원, 스타트업 직원 |
| **소득 수준** | 연 5,000만원 이상 |
| **방문 빈도** | 주 4-5회 |
| **객단가** | ₩9,000-12,000 |
| **주요 니즈** | - 업무 공간으로서의 카페<br>- 빠른 주문/픽업<br>- 고품질 커피와 조용한 환경 |

### 세그먼트 2: 라이프스타일 중시 MZ세대

| 항목 | 내용 |
|------|------|
| **연령대** | 25-32세 |
| **직업** | 프리랜서, 크리에이터, 중소기업 직원 |
| **소득 수준** | 연 3,500만원 이상 |
| **방문 빈도** | 주 2-3회 |
| **객단가** | ₩7,000-10,000 |
| **주요 니즈** | - SNS 공유 가능한 비주얼<br>- 독특한 메뉴와 경험<br>- 브랜드 가치 공유 |

---

## 시장 진입 장벽 분석

| 진입 장벽 | 수준 | 설명 |
|-----------|------|------|
| **초기 투자 비용** | 높음 | 강남 지역 임대료 및 인테리어 비용 상당 (최소 5,000-7,000만원) |
| **입지 경쟁** | 매우 높음 | 프리미엄 상권 내 공실률 낮음, 권리금 부담 |
| **브랜드 인지도** | 높음 | 대형 프랜차이즈와의 경쟁, 초기 마케팅 비용 필요 |
| **운영 노하우** | 중간 | 바리스타 인력 확보, 원두 소싱 네트워크 구축 필요 |
| **규제** | 낮음 | 식품위생법, 영업신고 등 일반적 규제 수준 |

---

## 데이터 출처

- 한국농수산식품유통공사 (aT) - 2024 식품산업 통계
- 통계청 - 서비스업 동향 조사 (2023-2024)
- 한국외식산업연구원 - 커피 전문점 시장 분석 보고서
- 서울시 빅데이터 캠퍼스 - 강남구 상권 분석 데이터
- SCA Korea (한국스페셜티커피협회) - 2025 트렌드 리포트

---

**작성일**: 2025년 2월
**작성자**: Antigravity Business Planner (Sample)
SAMPLE1_EOF
echo -e "  ${GREEN}✓${NC} 01-시장조사.md"

# Sample 2: 02-경쟁분석.md
cat << 'SAMPLE2_EOF' > "$PROJECT_ROOT/output/samples/cafe/02-경쟁분석.md"
# 경쟁 분석 보고서
## 스페셜티 카페 경쟁 환경 분석

⚠️ **본 문서의 수치는 샘플 데이터이며 실제와 다를 수 있습니다.**

---

## 경쟁사 분류

### 직접 경쟁사 (Direct Competitors)

| 경쟁사 | 포지셔닝 | 강점 | 약점 |
|--------|----------|------|------|
| **스타벅스 리저브** | 프리미엄 대형 프랜차이즈 | - 강력한 브랜드 인지도<br>- 안정적 품질<br>- 넓은 공간 | - 획일화된 경험<br>- 높은 가격<br>- 개성 부족 |
| **블루보틀** | 스페셜티 글로벌 브랜드 | - 프리미엄 이미지<br>- 고품질 원두<br>- 미니멀 디자인 | - 제한적 접근성<br>- 긴 대기 시간<br>- 좌석 부족 |
| **로컬 스페셜티 카페** | 독립 운영 개인 카페 | - 독특한 개성<br>- 유연한 운영<br>- 로컬 커뮤니티 | - 낮은 인지도<br>- 일관성 부족<br>- 규모의 경제 한계 |
| **탐앤탐스/투썸플레이스** | 중가형 프랜차이즈 카페 | - 넓은 매장망<br>- 디저트 결합<br>- 합리적 가격 | - 커피 품질 평가 낮음<br>- 차별화 부족 |

### 간접 경쟁사 (Indirect Competitors)

- **편의점 커피** (GS25 카페25, CU 아메리카노): 가격 경쟁력, 접근성
- **배달 커피** (메가커피 배달, 빽다방 퀵): 편리성, 프로모션
- **사무실 커피머신**: 무료/저비용, 즉시성
- **홈카페 시장**: 원두 구독, 가정용 머신 확산

---

## Porter's Five Forces 분석

| 경쟁 요인 | 강도 | 분석 |
|-----------|------|------|
| **기존 경쟁자 간 경쟁** | ★★★★☆ (높음) | - 강남 지역 카페 밀집도 매우 높음<br>- 프랜차이즈와 개인 카페 간 경쟁 치열<br>- 가격, 품질, 경험 모든 측면에서 차별화 필요 |
| **신규 진입자의 위협** | ★★★☆☆ (중간) | - 높은 초기 비용이 진입 장벽<br>- 그러나 소자본 창업 지원 증가<br>- 로스팅 카페, 복합 공간 등 새로운 형태 등장 |
| **대체재의 위협** | ★★★★☆ (높음) | - 편의점/배달 커피의 품질 향상<br>- 홈카페 시장 급성장<br>- 에너지 드링크, 차(tea) 시장 확대 |
| **공급자 교섭력** | ★★☆☆☆ (낮음) | - 다양한 원두 공급처 존재<br>- 직거래, 로스터리 협업 가능<br>- 장비 구매 옵션 다양 |
| **구매자 교섭력** | ★★★☆☆ (중간) | - 선택지가 많아 전환 비용 낮음<br>- 가격 민감도는 세그먼트별 차이<br>- 품질/경험 중시 고객은 충성도 높음 |

**종합 평가**: 경쟁 강도가 높은 시장이나, 차별화된 가치 제안으로 틈새 확보 가능

---

## 주요 경쟁사 SWOT 분석

### 스타벅스 리저브

| | |
|---|---|
| **Strengths (강점)** | **Weaknesses (약점)** |
| - 압도적 브랜드 파워<br>- 안정적 운영 시스템<br>- 충성 고객층 보유 | - 획일화된 매뉴얼<br>- 높은 가격대<br>- 개인화 경험 제한 |
| **Opportunities (기회)** | **Threats (위협)** |
| - 프리미엄 라인 확장<br>- 리저브 전용 상품 개발 | - 독립 카페의 차별화 전략<br>- 글로벌 브랜드 진입 (블루보틀 등) |

### 로컬 스페셜티 카페

| | |
|---|---|
| **Strengths (강점)** | **Weaknesses (약점)** |
| - 독창적 브랜드 아이덴티티<br>- 유연한 메뉴 운영<br>- 로컬 커뮤니티 기반 | - 제한적 마케팅 예산<br>- 인력 의존도 높음<br>- 확장성 부족 |
| **Opportunities (기회)** | **Threats (위협)** |
| - 로컬 소비 트렌드 부상<br>- SNS 바이럴 마케팅 | - 대형 프랜차이즈의 압박<br>- 임대료 상승 부담 |

---

## 포지셔닝 맵 (가격 x 경험 품질)

```
고가격
    │
    │     [블루보틀]
    │
    │  [스타벅스 리저브]
    │                     [목표 포지션]
    │                     - 스페셜티 품질
    │                     - 합리적 프리미엄
    │  [로컬 카페들]
    │
    │     [투썸/탐앤탐스]
    │
    │          [편의점 커피]
저가격───────────────────────────── 경험품질 (낮음 → 높음)
```

---

## 차별화 포인트

### 1. 제품 차별화
- **직접 로스팅** 또는 **로스터리 협업**으로 신선도 보장
- **시즈널 싱글 오리진** 메뉴 정기 변경
- **커핑 노트 제공**으로 교육적 경험 강화

### 2. 공간 차별화
- **하이브리드 공간**: 조용한 업무 존 + 소셜 라운지 구분
- **감각적 인테리어**: 자연 소재 활용, 밝은 채광
- **전문 장비 가시화**: 오픈 바, 커피 추출 과정 관람 가능

### 3. 서비스 차별화
- **구독 모델**: 월 ₩99,000 무제한 아메리카노 플랜
- **커피 클래스**: 주말 핸드드립/라떼아트 클래스 운영
- **앱 기반 주문**: 대기 시간 최소화, 개인화 추천

### 4. 가격 차별화
- **중가 프리미엄**: 블루보틀 대비 10-15% 저렴, 스타벅스 대비 유사
- **가치 중심 가격**: 품질 대비 합리적 가격 정책
- **구독 할인**: 충성 고객 확보 전략

---

## 경쟁 우위 확보 전략

| 전략 | 실행 방안 |
|------|-----------|
| **품질 리더십** | - 바리스타 SCA 자격증 보유 의무화<br>- 월 1회 커핑 세션으로 품질 관리 |
| **경험 디자인** | - 고객 여정 맵 기반 터치포인트 최적화<br>- 인테리어-음악-조명 통합 설계 |
| **커뮤니티 빌딩** | - 월간 커피 토크 이벤트<br>- 단골 고객 VIP 프로그램 |
| **디지털 전환** | - 자체 앱 개발 (주문, 구독, 커뮤니티)<br>- 인스타그램 마이크로 인플루언서 협업 |

---

## 결론 및 권장 사항

1. **직접 경쟁사보다 '경험'에서 차별화**하되, 가격은 접근 가능한 프리미엄 유지
2. **간접 경쟁사(편의점/홈카페)는 타겟이 다름**을 인식하고, '장소로서의 카페' 가치 강조
3. **로컬 커뮤니티 중심 마케팅**으로 대형 프랜차이즈와 차별화
4. **지속적인 품질 관리와 메뉴 혁신**으로 재방문율 극대화

---

**작성일**: 2025년 2월
**작성자**: Antigravity Business Planner (Sample)
SAMPLE2_EOF
echo -e "  ${GREEN}✓${NC} 02-경쟁분석.md"

# Sample 3: 03-재무모델.md
cat << 'SAMPLE3_EOF' > "$PROJECT_ROOT/output/samples/cafe/03-재무모델.md"
# 재무 모델
## 스페셜티 카페 재무 계획 및 손익 예측

⚠️ **본 문서의 수치는 샘플 데이터이며 실제와 다를 수 있습니다.**

---

## 기본 가정 (Assumptions)

| 항목 | 내용 |
|------|------|
| **매장 규모** | 25평 (약 82.5㎡) |
| **위치** | 서울 강남역 도보 5분 거리 |
| **좌석 수** | 30석 (테이블 10개) |
| **운영 시간** | 평일 07:00-22:00 (15시간), 주말 09:00-22:00 (13시간) |
| **일 평균 고객** | 평일 90명, 주말 70명 (평균 80명) |
| **객단가** | ₩8,500 |
| **월 매출일** | 30일 |
| **변동비율** | 35% (원두, 우유, 일회용품 등) |

---

## 초기 투자금 (Initial Investment)

| 항목 | 금액 (만원) | 비고 |
|------|-------------|------|
| **보증금** | 3,000 | 월세 ₩500만원 (보증금 6개월분) |
| **권리금** | 500 | 상권 프리미엄 |
| **인테리어** | 2,000 | - 기본 시공: 1,200<br>- 가구/조명: 500<br>- 간판/사인: 300 |
| **주방/바 장비** | 1,500 | - 에스프레소 머신: 800<br>- 그라인더: 300<br>- 냉장고/제빙기: 250<br>- 기타 소도구: 150 |
| **초도 재고** | 300 | 원두, 우유, 소모품 |
| **라이센스/법무** | 100 | 사업자등록, 식품위생 |
| **마케팅 (오픈)** | 200 | SNS 광고, 오픈 이벤트 |
| **예비비** | 400 | 10% 예비 비용 |
| **총 투자금** | **7,000** | |

---

## 월 고정비용 (Monthly Fixed Costs)

| 항목 | 금액 (만원) | 비고 |
|------|-------------|------|
| **임대료** | 500 | 보증금 3,000만원 / 월세 500만원 |
| **인건비** | 500 | - 바리스타 2명: 350 (각 175)<br>- 아르바이트 1명: 150 |
| **공과금** | 120 | 전기, 수도, 가스, 인터넷 |
| **마케팅** | 50 | SNS 광고, 이벤트 |
| **기타 관리비** | 30 | 회계, 소모품, 유지보수 |
| **총 고정비** | **1,200** | |

---

## 월별 손익계산서 (P&L) - 12개월

| 월 | 매출 (만원) | 변동비 (35%) | 고정비 | 영업이익 | 누적이익 |
|----|-------------|--------------|--------|----------|----------|
| 1월 | 1,530 | 536 | 1,200 | -206 | -206 |
| 2월 | 1,800 | 630 | 1,200 | -30 | -236 |
| 3월 | 2,040 | 714 | 1,200 | 126 | -110 |
| 4월 | 2,210 | 774 | 1,200 | 236 | 126 |
| 5월 | 2,380 | 833 | 1,200 | 347 | 473 |
| 6월 | 2,450 | 858 | 1,200 | 392 | 865 |
| 7월 | 2,520 | 882 | 1,200 | 438 | 1,303 |
| 8월 | 2,380 | 833 | 1,200 | 347 | 1,650 |
| 9월 | 2,550 | 893 | 1,200 | 457 | 2,107 |
| 10월 | 2,620 | 917 | 1,200 | 503 | 2,610 |
| 11월 | 2,550 | 893 | 1,200 | 457 | 3,067 |
| 12월 | 2,720 | 952 | 1,200 | 568 | 3,635 |
| **연간 합계** | **27,750** | **9,713** | **14,400** | **3,637** | - |

### 주요 지표
- **연간 매출**: ₩2억 7,750만원
- **연간 영업이익**: ₩3,637만원
- **영업이익률**: 13.1%
- **손익분기점 도달**: 4월 (4개월차)

---

## 손익분기점 (BEP) 계산

### 월 손익분기점
```
월 고정비: ₩1,200만원
기여이익률: 65% (100% - 35%)

BEP 매출 = 월 고정비 ÷ 기여이익률
         = ₩1,200만원 ÷ 0.65
         = ₩1,846만원

BEP 일 매출 = ₩1,846만원 ÷ 30일 = ₩61.5만원
BEP 일 고객 수 = ₩61.5만원 ÷ ₩8,500 = 73명
```

**결론**: 하루 평균 **73명 이상** 방문 시 흑자 전환

---

## 시나리오 분석 (3 Scenarios)

### 낙관적 시나리오 (Optimistic)
- **일 평균 고객**: 100명
- **객단가**: ₩9,000
- **월 매출**: ₩2,700만원
- **연간 영업이익**: ₩6,780만원 (25.1%)

### 기본 시나리오 (Base)
- **일 평균 고객**: 80명
- **객단가**: ₩8,500
- **월 매출**: ₩2,040만원
- **연간 영업이익**: ₩3,637만원 (13.1%)

### 비관적 시나리오 (Pessimistic)
- **일 평균 고객**: 60명
- **객단가**: ₩8,000
- **월 매출**: ₩1,440만원
- **연간 영업이익**: -₩1,128만원 (-7.8%) **→ 적자**

**리스크 관리**: 비관 시나리오 발생 시 3개월 내 마케팅 강화 및 비용 절감 필요

---

## 3개년 사업 전망 (3-Year Projection)

| 연도 | 매출 (억원) | 영업이익 (만원) | 영업이익률 | 누적 현금흐름 |
|------|-------------|-----------------|------------|---------------|
| **1년차** | 2.78 | 3,637 | 13.1% | -3,363 (초기투자 회수 중) |
| **2년차** | 3.20 | 5,200 | 16.3% | +1,837 (흑자 전환) |
| **3년차** | 3.52 | 6,240 | 17.7% | +8,077 |

### 성장 가정
- 1년차: 브랜드 정착, 기본 고객층 확보
- 2년차: 단골 고객 증가 (15% 성장), 구독 서비스 활성화
- 3년차: 안정적 운영 (10% 성장), 2호점 검토 가능

### 투자 회수 기간 (Payback Period)
- **초기 투자 7,000만원** 기준
- 1년차 영업이익: 3,637만원
- 2년차 영업이익: 5,200만원
- **예상 회수 기간**: 약 **2년 2개월**

---

## 현금흐름 관리 포인트

| 시기 | 주의사항 |
|------|----------|
| **오픈 1-3개월** | - 초기 고객 유치 집중 (오픈 이벤트, 무료 샘플링)<br>- 현금 소진 예상, 예비 자금 ₩500만원 확보 |
| **4-6개월** | - BEP 도달 목표<br>- 메뉴 최적화 (인기/비인기 메뉴 분석) |
| **7-12개월** | - 고정 고객층 확보 (구독 전환 유도)<br>- 흑자 안정화, 재투자 검토 |

---

## 재무 건전성 체크리스트

- [ ] 초기 투자 외 **운영 자금 ₩500만원** 추가 확보
- [ ] 월 고정비 대비 **현금 보유고 최소 2개월분** 유지
- [ ] 매월 **손익 리뷰** 및 변동비율 모니터링
- [ ] **분기별 재무제표** 작성 및 목표 대비 실적 분석
- [ ] 예상 손익분기 미달 시 **3개월 내 대응 계획** 수립

---

**작성일**: 2025년 2월
**작성자**: Antigravity Business Planner (Sample)
SAMPLE3_EOF
echo -e "  ${GREEN}✓${NC} 03-재무모델.md"

# Sample 4: 04-사업계획서-요약.md
cat << 'SAMPLE4_EOF' > "$PROJECT_ROOT/output/samples/cafe/04-사업계획서-요약.md"
# 사업계획서 요약
## 강남 스페셜티 카페 "Brew Lab" 사업계획서 (Executive Summary)

⚠️ **본 문서의 수치는 샘플 데이터이며 실제와 다를 수 있습니다.**

---

## 핵심 요약

| 항목 | 내용 |
|------|------|
| **사업명** | Brew Lab (브루랩) |
| **사업 분야** | 스페셜티 커피 전문점 |
| **위치** | 서울 강남구 역삼동 (강남역 도보 5분) |
| **사업 형태** | 개인사업자 (법인 전환 검토: 2년차) |
| **핵심 가치 제안** | 프리미엄 스페셜티 커피 + 하이브리드 공간 경험 |
| **초기 투자금** | 7,000만원 |
| **예상 BEP** | 오픈 후 4개월 |
| **1년차 예상 매출** | 2억 7,750만원 |
| **1년차 영업이익률** | 13.1% |

---

## 사업 개요

**Brew Lab**은 강남 직장인과 MZ세대를 타겟으로 한 스페셜티 카페입니다. '커피 실험실'이라는 콘셉트로, 시즈널 싱글 오리진 커피와 하이브리드 공간(업무 존 + 소셜 라운지)을 제공합니다. 구독 모델과 커피 클래스를 통해 충성 고객을 확보하고, 로컬 커뮤니티 중심의 브랜딩으로 대형 프랜차이즈와 차별화합니다.

---

## 시장 기회

- **한국 커피 시장**: 약 8조원 (2025), 연 8-12% 성장
- **스페셜티 세그먼트**: 연 15-18% 고성장
- **타겟 시장 (SOM)**: 강남 프리미엄 카페 시장 약 120억원
- **핵심 트렌드**: 스페셜티 수요 확대, 카페 경험 중심 소비, 구독 모델

---

## 경쟁 우위

| 차별점 | 설명 |
|--------|------|
| **제품** | 시즈널 싱글 오리진, 커핑 노트 제공, 직접 로스팅 협업 |
| **공간** | 업무 존 + 소셜 라운지 하이브리드 설계 |
| **서비스** | 월 ₩99,000 구독 플랜, 주말 커피 클래스 |
| **가격** | 블루보틀 대비 10-15% 저렴한 중가 프리미엄 |

---

## 재무 요약

| 항목 | 1년차 | 2년차 | 3년차 |
|------|-------|-------|-------|
| **매출** | 2.78억 | 3.20억 | 3.52억 |
| **영업이익** | 3,637만 | 5,200만 | 6,240만 |
| **영업이익률** | 13.1% | 16.3% | 17.7% |

- **초기 투자**: 7,000만원
- **투자 회수**: 약 2년 2개월
- **월 BEP 매출**: 1,846만원 (일 73명)

---

## 실행 로드맵

| 시기 | 마일스톤 |
|------|---------|
| **1-2개월** | 입지 확보, 인테리어, 인허가, 인력 채용 |
| **3개월** | 그랜드 오픈, 런칭 마케팅 캠페인 |
| **4-6개월** | BEP 달성, 구독 서비스 런칭, 메뉴 최적화 |
| **7-12개월** | 흑자 안정화, 커피 클래스 정례화, 커뮤니티 구축 |
| **2년차** | 매출 15% 성장, 법인 전환 검토, 2호점 리서치 |

---

## 리스크 및 대응

| 리스크 | 대응 방안 |
|--------|-----------|
| 초기 고객 부족 | 오픈 3개월 집중 마케팅 (예산 200만원), 인플루언서 협업 |
| 임대료 상승 | 장기 계약 (3년) 체결, 매출 연동 조항 협상 |
| 인력 이탈 | 바리스타 성장 프로그램, SCA 자격증 지원 |
| 비관 시나리오 | 3개월 내 비용 절감 + 마케팅 전략 전환 |

---

## 다음 단계

1. [ ] 입지 최종 확정 및 임대차 계약
2. [ ] 인테리어 업체 선정 및 시공
3. [ ] 에스프레소 머신/장비 발주
4. [ ] 바리스타 채용 (2명)
5. [ ] 사업자등록 및 식품위생 신고
6. [ ] 런칭 마케팅 계획 수립

---

**작성일**: 2025년 2월
**작성자**: Antigravity Business Planner (Sample)
SAMPLE4_EOF
echo -e "  ${GREEN}✓${NC} 04-사업계획서-요약.md"

echo -e "  ${GREEN}✓${NC} 카페 사업 기획 샘플 데이터 4건 생성 완료"

# Complete Sample 1: 카페 완성 샘플
cat << 'CSAMPLE1_EOF' > "$PROJECT_ROOT/output/ideas/idea-001-sample-cafe/complete-sample.md"
# 완성 샘플: 동네 스페셜티 카페 ☕

> ⚠️ **면책 고지**: 이 샘플은 시연용이며, 실제 데이터가 아닙니다. 모든 수치는 AI 추정(신뢰도 C)입니다. 실제 창업 시 반드시 현장 조사와 전문가 상담을 병행하세요.

## 사업 개요
- **사업명**: 로스팅 하우스
- **업종**: 스페셜티 카페 (오프라인)
- **사업 규모**: small (소규모 창업)
- **예상 투자금**: 5,000만원
- **목표**: 6개월 내 BEP 달성

---

## Step 0: 아이디어 발견 & 검증

### 가설 (hypothesis.md 요약)
- 핵심 가설: "직장인 밀집 지역에 합리적 가격의 스페셜티 커피를 제공하면 충성 고객을 확보할 수 있다"
- 타겟: 25-40세 직장인, 커피 품질에 관심 있으나 프랜차이즈에 불만

### 검증 결과 (evaluation.md 요약)
| 항목 | 점수 | 판정 |
|------|------|------|
| 시장 수요 | 4.2/5 [C] | ✅ Pass |
| 차별화 가능성 | 3.8/5 [C] | ✅ Pass |
| 실행 가능성 | 3.5/5 [C] | ⚠️ Moderate |
| 수익성 | 3.3/5 [C] | ⚠️ Moderate |
| **종합** | **74점** [C] | **진행 권장** |

---

## Step 1: 시장조사 (market-research 요약)

### TAM/SAM/SOM [C]
| 시장 | 규모 |
|------|------|
| TAM (국내 카페 시장) | 약 15조원 [C] |
| SAM (서울 스페셜티 카페) | 약 5,000억원 [C] |
| SOM (목표 상권 3km 반경) | 약 2억원/년 [C] |

### 핵심 트렌드 [C]
- 스페셜티 커피 시장 연 15% 성장
- 소비자 60%가 "커피 맛"을 카페 선택 1순위로 꼽음
- 1인 카페/소형 카페 창업 증가 추세

---

## Step 2: 경쟁분석 (competitor-analysis 요약)

| 경쟁사 | 유형 | 강점 | 약점 | 가격대 |
|--------|------|------|------|--------|
| 스타벅스 | 프랜차이즈 | 브랜드, 접근성 | 획일적 맛 | 5,000-7,000원 |
| 블루보틀 | 프리미엄 | 품질, 경험 | 높은 가격 | 6,000-8,000원 |
| 동네 카페 A | 개인 | 친근함 | 품질 불균일 | 3,500-5,000원 |

### 차별화 전략 [C]
- 가격: 프리미엄 대비 20% 저렴 (4,500-5,500원)
- 품질: 직접 로스팅으로 신선도 보장
- 경험: 로스팅 과정 공개, 커피 교육 프로그램

---

## Step 3: SWOT 분석 요약

| | 긍정 | 부정 |
|---|------|------|
| **내부** | S: 직접 로스팅 기술, 낮은 원가 | W: 브랜드 인지도 제로, 1인 운영 한계 |
| **외부** | O: 스페셜티 시장 성장, 건강 트렌드 | T: 프랜차이즈 확장, 임대료 상승 |

---

## Step 4: 재무모델링 (financial-modeling 요약)

### 초기 투자 [C]
| 항목 | 금액 |
|------|------|
| 보증금 | 1,500만원 |
| 인테리어 | 1,500만원 |
| 장비 (에스프레소 머신, 로스터) | 1,200만원 |
| 초기 재료비 | 300만원 |
| 기타 (인허가, 마케팅) | 500만원 |
| **합계** | **5,000만원** |

### 월 손익 예상 [C]
| 항목 | 금액 |
|------|------|
| 매출 (일 80잔 × 5,000원 × 25일) | 1,000만원 |
| 원재료비 (30%) | -300만원 |
| 임대료 | -200만원 |
| 인건비 (본인 + 파트타임 1명) | -250만원 |
| 기타 (수도광열, 소모품) | -100만원 |
| **월 영업이익** | **150만원** |

### BEP: **약 5.5개월** [C]

---

## Step 5: 운영계획 (operations-plan 요약)
- 영업시간: 07:00-21:00 (주 6일)
- 인력: 오전 본인, 오후 파트타임 1명
- 원두 로스팅: 주 2회 (화, 금)
- 재고 관리: 주 1회 발주

## Step 6: 브랜딩 (branding-strategy 요약)
- 브랜드명: 로스팅 하우스
- 슬로건: "매일 볶는 신선함"
- 톤앤매너: 따뜻하고 전문적인
- SNS: 인스타그램 (로스팅 과정 릴스)

## Step 7: 법률/규제 (legal-checklist 요약)
- [x] 사업자등록 (간이과세자, 연 매출 1억 미만)
- [x] 식품제조가공업 등록
- [x] 위생교육 수료
- [ ] 옥외광고물 허가
- [ ] 음악 저작권료 (BGM)

## Step 8: 사업계획서
→ 전체 사업계획서는 output/reports/business-plan.md에서 확인

---

> 📌 이 샘플은 `/auto-plan`으로 8단계를 순차 실행하면 생성되는 산출물의 축약 버전입니다.
> 실제 사용 시 각 단계에서 더 상세한 분석이 수행됩니다.
CSAMPLE1_EOF

# Complete Sample 2: AI SaaS 완성 샘플
cat << 'CSAMPLE2_EOF' > "$PROJECT_ROOT/output/ideas/idea-002-sample-app/complete-sample.md"
# 완성 샘플: AI 회의록 요약 SaaS 🤖

> ⚠️ **면책 고지**: 이 샘플은 시연용이며, 실제 데이터가 아닙니다. 모든 수치는 AI 추정(신뢰도 C)입니다. 실제 창업 시 반드시 시장 검증과 사용자 테스트를 병행하세요.

## 사업 개요
- **사업명**: MeetNote AI
- **업종**: AI SaaS (온라인)
- **사업 규모**: micro (Micro-SaaS, 1인 빌더)
- **예상 초기 비용**: $200/월
- **목표**: 6개월 내 MRR $1,000 달성

---

## Step 0: 아이디어 발견 & 검증

### 가설 (hypothesis.md 요약)
- 핵심 가설: "원격 근무 팀의 회의록 작성 부담을 AI로 해결하면 월 $19-49에 구독할 것이다"
- 타겟: 원격 근무 스타트업, 5-20명 규모 팀

### 검증 결과 [C]
| 항목 | 점수 | 판정 |
|------|------|------|
| 시장 수요 | 4.5/5 [C] | ✅ Pass |
| 차별화 가능성 | 3.2/5 [C] | ⚠️ Moderate |
| 실행 가능성 | 4.0/5 [C] | ✅ Pass |
| 수익성 | 3.8/5 [C] | ✅ Pass |
| **종합** | **78점** [C] | **진행 권장** |

---

## Step 1: 시장조사 (니치 시장 분석)

### 니치 검증 체크리스트 [C]
| 항목 | 결과 | 판정 |
|------|------|------|
| 커뮤니티 규모 | Reddit r/RemoteWork 2.1M, r/SaaS 50K | ✅ Pass |
| 불만 시그널 | Otter.ai 리뷰 3.2/5, "정확도 낮다" 반복 | ✅ Pass |
| 지불 의향 | "I'd pay for better transcription" 20건+ | ✅ Pass |
| 경쟁사 수 | 직접 경쟁 4개 (과포화 아님) | ✅ Pass |
| 키워드 검색량 | "AI meeting notes" 12,100/월 | ✅ Pass |
| **판정** | **5/5 Pass** | **니치 유효** ✅ |

---

## Step 2: 경쟁분석

| 경쟁사 | 가격 | 강점 | 약점 |
|--------|------|------|------|
| Otter.ai | $16.99/월 | 인지도 | 비영어 정확도 낮음 |
| Fireflies.ai | $18/월 | 통합 | 한국어 미지원 |
| Clova Note | 무료 | 한국어 | 팀 기능 부재 |

### 차별화: 한국어+영어 하이브리드, 팀 협업 기능

---

## Step 3: SWOT 분석 요약

| | 긍정 | 부정 |
|---|------|------|
| **내부** | S: AI/개발 역량, 1인 린 운영 | W: 마케팅 리소스 부족, 브랜드 없음 |
| **외부** | O: 원격근무 확산, AI 비용 하락 | T: 빅테크 진입(Zoom AI), API 가격 변동 |

---

## Step 4: 재무모델링 (Micro-SaaS)

### 월 비용 구조 [C]
| 항목 | 비용 |
|------|------|
| Vercel (호스팅) | $20 |
| OpenAI API | $50-200 (사용량 연동) |
| Supabase (DB) | $25 |
| 도메인 | $1 |
| 기타 (이메일, 모니터링) | $10 |
| **합계** | **$106-256/월** |

### SaaS 핵심 지표 목표 [C]
| 지표 | 6개월 목표 | 12개월 목표 |
|------|-----------|-----------|
| MRR | $1,000 | $5,000 |
| 유료 고객 | 30명 | 100명 |
| Churn | 5% 이하 | 3% 이하 |
| LTV/CAC | 3x | 5x |
| ARPU | $35 | $50 |

### BEP: **유료 고객 8명** (월 고정비 $256 / ARPU $35) [C]

---

## Step 5: 운영계획
- 개발: 주 30시간 (기능 개발 + 버그 수정)
- 고객 지원: 주 5시간 (이메일 + 인터콤)
- 마케팅: 주 5시간 (블로그 + 커뮤니티)
- 배포: CI/CD 자동화 (Vercel + GitHub Actions)

## Step 6: 브랜딩
- 브랜드: MeetNote AI
- 슬로건: "Your meetings, automatically noted"
- 채널: Twitter (Building in Public), Product Hunt

## Step 7: 법률/규제
- [x] 사업자등록 (간이과세자)
- [x] 이용약관 (templates/terms-of-service-template.md 참고)
- [x] 개인정보처리방침 (templates/privacy-policy-template.md 참고)
- [ ] AI 기본법 대응 (고위험 AI 해당 여부 검토)
- [ ] 해외 결제 설정 (Stripe)

## Step 8: 사업계획서
→ 전체 사업계획서는 output/reports/business-plan.md에서 확인

---

> 📌 이 샘플은 `/auto-plan`으로 8단계를 순차 실행하면 생성되는 산출물의 축약 버전입니다.
> Micro-SaaS(business_scale: micro) 설정 시 각 단계에서 소규모 사업 전용 분석이 자동 활성화됩니다.
CSAMPLE2_EOF

echo -e "  ${GREEN}✓${NC} 완성 샘플 2종 (카페/AI SaaS) 생성 완료"
echo ""

# --- Step 8: Python environment setup ---
echo -e "${BLUE}[8/10]${NC} Python 환경 세팅 중..."

# Create virtual environment if it doesn't exist
if [ ! -d "$PROJECT_ROOT/.venv" ]; then
    python3 -m venv "$PROJECT_ROOT/.venv" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "  ${GREEN}✓${NC} 가상 환경 생성 완료 (.venv)"
    else
        warn "가상 환경 생성 실패 (Python venv 모듈이 필요합니다)" "해결 방법: brew install python3 실행 후 setup.sh를 다시 실행하세요"
        echo "    또는 Antigravity에서 에이전트에게 '환경 설정 도와줘'라고 요청하세요"
    fi
else
    echo -e "  ${GREEN}✓${NC} 가상 환경이 이미 존재합니다 (.venv)"
fi

# Activate venv and install packages
if [ -d "$PROJECT_ROOT/.venv" ]; then
    source "$PROJECT_ROOT/.venv/bin/activate"

    pip install --quiet matplotlib 2>/dev/null && \
        echo -e "  ${GREEN}✓${NC} matplotlib 설치 완료" || \
        warn "matplotlib 설치 실패 (차트 기능이 제한될 수 있습니다)" "차트 없이도 사업 기획은 정상 진행됩니다. 나중에 pip install matplotlib로 설치 가능합니다"

    pip install --quiet markdown 2>/dev/null && \
        echo -e "  ${GREEN}✓${NC} markdown 설치 완료" || \
        warn "markdown 설치 실패 (문서 내보내기 기능이 제한될 수 있습니다)" "문서 내보내기 없이도 사업 기획은 정상 진행됩니다. 나중에 pip install markdown으로 설치 가능합니다"

    deactivate
else
    # Fallback: install globally
    pip3 install --quiet matplotlib 2>/dev/null && \
        echo -e "  ${GREEN}✓${NC} matplotlib 설치 완료 (전역)" || \
        warn "matplotlib 설치 실패" "차트 없이도 사업 기획은 정상 진행됩니다"

    pip3 install --quiet markdown 2>/dev/null && \
        echo -e "  ${GREEN}✓${NC} markdown 설치 완료 (전역)" || \
        warn "markdown 설치 실패" "문서 내보내기 없이도 사업 기획은 정상 진행됩니다"
fi

echo ""

# --- Step 9: Git initialization ---
echo -e "${BLUE}[9/10]${NC} Git 초기화 중..."

if command -v git &> /dev/null; then
    if [ ! -d "$PROJECT_ROOT/.git" ]; then
        cd "$PROJECT_ROOT"
        git init --quiet
        git add -A
        git commit -m "Initial commit: Antigravity 사업 기획 도구 세팅" --quiet
        echo -e "  ${GREEN}✓${NC} Git 저장소 초기화 및 초기 커밋 완료"
    else
        echo -e "  ${GREEN}✓${NC} Git 저장소가 이미 초기화되어 있습니다"
    fi
else
    echo -e "  ${YELLOW}!${NC} Git이 설치되어 있지 않아 건너뜁니다"
fi

echo ""

# --- Step 10: Completion ---
echo -e "${BOLD}============================================================${NC}"
echo -e "${GREEN}${BOLD}  ✓ 세팅 완료!${NC}"
echo -e "${BOLD}============================================================${NC}"
echo ""
echo "  생성된 항목:"
echo -e "    ${GREEN}•${NC} 작동 원칙: 9개 (한국어 소통, 문서 스타일, 안전 가이드라인, 업데이트 체크, 컨텍스트 체이닝, AI 도메인 지식, 품질 게이트, 데이터 신뢰도, 규모별 모드 전환)"
echo -e "    ${GREEN}•${NC} 기획 단계: 30개 (아이디어 발굴부터 성장 루프까지)"
echo -e "    ${GREEN}•${NC} 전문 분석 도구: 18개 (재무, 경쟁, SWOT, AI 비즈니스, 니치 검증, 부트스트랩 계산, 기술 스택 추천, 스펙 변환, AI 추정 검증 등 + 5개 공유 스크립트)"
echo -e "    ${GREEN}•${NC} 문서 양식: 10개 (사업계획서, 재무예측, AI 재무, Micro-SaaS 재무, 부트스트랩 성장, 린캔버스, 포트폴리오 등)"
echo -e "    ${GREEN}•${NC} 외부 도구 연동 설정: 1개"
echo -e "    ${GREEN}•${NC} 샘플 데이터: 카페 사업 4건 + 완성 샘플 2종 (카페/AI SaaS)"
echo ""
echo "  다음 단계:"
echo -e "    1. ${BOLD}Antigravity${NC}를 실행합니다"
echo -e "    2. ${BOLD}File → Open Folder${NC}에서 이 폴더를 엽니다:"
echo -e "       ${BLUE}$PROJECT_ROOT${NC}"
echo -e "    3. 에이전트에게 말합니다: ${BOLD}\"사업 기획을 시작하겠습니다\"${NC}"
echo ""
echo "  사용 가능한 기획 단계 (명령어 또는 자연어로 실행):"
echo -e "    ${YELLOW}/market-research${NC}      — 시장 조사"
echo -e "    ${YELLOW}/competitor-analysis${NC}   — 경쟁 분석"
echo -e "    ${YELLOW}/financial-modeling${NC}    — 재무 모델링"
echo -e "    ${YELLOW}/business-plan-draft${NC}   — 사업계획서 초안"
echo -e "    ${YELLOW}/branding-strategy${NC}     — 브랜딩 전략"
echo -e "    ${YELLOW}/operations-plan${NC}       — 운영 계획"
echo -e "    ${YELLOW}/legal-checklist${NC}       — 법률/인허가"
echo -e "    ${YELLOW}/menu-costing${NC}          — 제품 원가 분석"
echo -e "    ${YELLOW}/idea-discovery${NC}        — 아이디어 발굴"
echo -e "    ${YELLOW}/idea-validation${NC}       — 아이디어 검증"
echo -e "    ${YELLOW}/idea-portfolio${NC}        — 아이디어 포트폴리오"
echo -e "    ${YELLOW}/idea-brainstorm${NC}       — 브레인스토밍 프레임워크"
echo -e "    ${YELLOW}/lean-canvas${NC}            — Lean Canvas 작성"
echo -e "    ${YELLOW}/my-outputs${NC}             — 산출물 대시보드"
echo -e "    ${YELLOW}/auto-plan${NC}              — 전체 기획 자동 진행"
echo -e "    ${YELLOW}/check-progress${NC}        — 기획 진행률 확인"
echo -e "    ${YELLOW}/export-documents${NC}      — 문서 PDF 내보내기"
echo -e "    ${YELLOW}/mvp-definition${NC}       — MVP 범위 정의"
echo -e "    ${YELLOW}/gtm-launch${NC}           — GTM 런칭 전략"
echo -e "    ${YELLOW}/kpi-framework${NC}        — KPI 체계 수립"
echo -e "    ${YELLOW}/security-scan${NC}        — 민감정보 스캔"
echo -e "    ${YELLOW}/version-history${NC}      — 버전 이력 관리"
echo -e "    ${YELLOW}/tco-dashboard${NC}        — TCO 비용 추적"
echo -e "    ${YELLOW}/quick-start${NC}           — 10분 비즈니스 플랜"
echo -e "    ${YELLOW}/customer-discovery${NC}    — 고객 검증"
echo -e "    ${YELLOW}/payment-setup${NC}         — 결제 인프라 셋업"
echo -e "    ${YELLOW}/pmf-measurement${NC}       — PMF 측정 루프"
echo -e "    ${YELLOW}/ai-builder${NC}            — AI 코딩 도구 MVP 구현"
echo -e "    ${YELLOW}/deploy-guide${NC}          — 배포 가이드"
echo -e "    ${YELLOW}/growth-loop${NC}           — 성장 루프"
echo ""
echo -e "  💡 명령어를 외울 필요 없습니다!"
echo -e "     '시장 조사해줘', '재무 분석 부탁해' 처럼 자연어로 요청하면 됩니다."
echo ""
echo "  샘플 데이터:"
echo -e "    ${BLUE}output/samples/cafe/${NC} 에서 카페 사업 기획 예시를 확인하세요"
echo ""
if [ $WARNINGS -gt 0 ]; then
    echo -e "  ${YELLOW}━━━ 문제 해결 안내 ━━━${NC}"
    echo -e "  설치 중 ${YELLOW}${WARNINGS}개의 경고${NC}가 있었습니다."
    echo -e "  핵심 기능은 모두 정상 작동하며, 일부 부가 기능만 제한될 수 있습니다."
    echo ""
    echo -e "  문제가 있다면:"
    echo -e "    1. Antigravity에서 에이전트에게 ${BOLD}\"설치 문제 도와줘\"${NC} 라고 요청하세요"
    echo -e "    2. 또는 setup.sh를 다시 실행해보세요: ${BLUE}./setup.sh${NC}"
    echo ""
fi
echo -e "  ${BOLD}GUIDE.md${NC} 파일에서 상세 사용법을 확인하세요."
echo -e "${BOLD}============================================================${NC}"
