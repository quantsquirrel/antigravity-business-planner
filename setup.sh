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
    "templates"
    "output/ideas"
    "output/research"
    "output/reports"
    "output/financials"
    "output/presentations"
    "output/samples/cafe"
)

for dir in "${directories[@]}"; do
    mkdir -p "$PROJECT_ROOT/$dir"
done

# Create .gitkeep files to preserve empty directories in git
for gitkeep_dir in "output/ideas" "output/research" "output/reports" "output/financials" "output/presentations"; do
    touch "$PROJECT_ROOT/$gitkeep_dir/.gitkeep"
done

echo -e "  ${GREEN}✓${NC} 18개 디렉토리 생성 완료"
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

echo -e "  ${GREEN}✓${NC} korean-communication.md"
echo -e "  ${GREEN}✓${NC} business-planning-style.md"
echo -e "  ${GREEN}✓${NC} safety-guidelines.md"
echo -e "  ${GREEN}✓${NC} update-check.md"
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
* Go/Pivot/Drop 판정을 내립니다

## 필수 질문 (5개)
1. **업종/산업**: 어떤 분야에서 일하고 계시나요?
2. **경력/경험**: 해당 분야에서 얼마나 오래, 어떤 역할로 일하셨나요?
3. **문제점/불편함**: 일하면서 가장 비효율적이라고 느낀 점은?
4. **가용 자원**: 초기 투자 가능 금액, 활용 가능한 네트워크/자산은?
5. **목표 고객층**: 어떤 고객에게 서비스하고 싶으신가요?

## 프로세스 흐름
* 질문 5개 수집 → 키워드 추출 → 아이디어 3-5개 생성 → 5점 척도 평가 → Go/Pivot/Drop

## 아이디어 저장 규칙

Go 판정을 받은 아이디어는 개별 폴더를 생성합니다:

```
output/ideas/{id}-{name}/
├── idea.json          # 메타 정보 (id, name, status, score 등)
├── hypothesis.md      # 아이디어 가설 (1문단)
├── evaluation.md      # Go/Pivot/Drop 평가 결과
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
* 각 아이디어별 이름, 점수, 진행률, Go/Pivot/Drop 판정을 표로 정리합니다

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
* 컬럼: 아이디어 ID, 이름, 종합 점수, 진행률(%), 판정(Go/Pivot/Drop)

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
WF13_EOF

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
echo ""

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
- Go/Pivot/Drop 판단을 위한 정량 평가를 수행합니다

## 깊이 경계
- **이 스킬**: 가설 수준의 아이디어 도출 (1문단 요약)
- **business-researcher**: 선택된 아이디어의 심층 시장 분석

## 구조화 입력 — 필수 질문 5개

1. **업종/산업**: 어떤 분야에서 일하고 계시나요?
2. **경력/경험**: 해당 분야에서 얼마나 오래 일하셨나요?
3. **문제점/불편함**: 일하면서 가장 비효율적이라고 느낀 점은?
4. **가용 자원**: 초기 투자 가능 금액, 활용 가능한 네트워크/자산은?
5. **목표 고객층**: 어떤 고객에게 서비스하고 싶으신가요?

## Go/Pivot/Drop 평가 기준 (5점 척도)

| 평가 항목 | 1점 (매우 불리) | 3점 (보통) | 5점 (매우 유리) |
|-----------|----------------|-----------|----------------|
| 시장 크기 | 연 100억 미만 | 연 1,000억 내외 | 연 1조 이상 |
| 경쟁 강도 | 대기업 독점 | 중소 경쟁자 다수 | 경쟁자 부재/소수 |
| 적합성 | 경험 무관 | 일부 관련 | 핵심 역량 일치 |
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
| **판정** | Go/Pivot/Drop | Go/Pivot/Drop | Go/Pivot/Drop |

**판정 기준:** Go (20+) / Pivot (12-19) / Drop (11-)

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
echo -e "    ${GREEN}•${NC} 작동 원칙: 3개 (한국어 소통, 문서 스타일, 안전 가이드라인)"
echo -e "    ${GREEN}•${NC} 기획 단계: 13개 (아이디어 발굴부터 사업계획서까지)"
echo -e "    ${GREEN}•${NC} 전문 분석 도구: 11개 (재무, 경쟁, SWOT 등)"
echo -e "    ${GREEN}•${NC} 문서 양식: 6개 (사업계획서, 재무예측, 포트폴리오 등)"
echo -e "    ${GREEN}•${NC} 외부 도구 연동 설정: 1개"
echo -e "    ${GREEN}•${NC} 샘플 데이터: 카페 사업 4건"
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
echo -e "    ${YELLOW}/check-progress${NC}        — 기획 진행률 확인"
echo -e "    ${YELLOW}/export-documents${NC}      — 문서 PDF 내보내기"
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
