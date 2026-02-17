# Antigravity 사업 기획 도구

> AI한테 한국어로 "시장조사 해줘", "사업계획서 써줘" 하면 아이디어 브레인스토밍부터 사업성 평가, 시장조사, 재무모델링, 사업계획서까지 알아서 만들어주는 도구입니다.

[Google Antigravity](https://antigravity.google)(AI IDE) 위에서 동작하며, `bash setup.sh` 한 줄이면 워크플로우 16개, 전문 스킬 12개, 문서 템플릿 7개가 자동 세팅됩니다. 코딩 없이 자연어만으로 사업 기획 전 과정을 수행할 수 있습니다.

---

## 아이디어가 없어도 시작할 수 있습니다

가장 큰 특징은 "아이디어가 없는 상태"에서 출발할 수 있다는 점입니다. 2단계 인터뷰로 사용자의 업종 경험에서 아이디어를 끌어내고, 역발상 리스크 분석과 다각적 관점 브레인스토밍으로 사각지대를 점검한 뒤, 100점 만점 가중 스코어링과 Impact-Effort 매트릭스로 어떤 아이디어를 먼저 추진할지 우선순위를 잡아줍니다. Go/Pivot/Drop 판정까지 자동으로 내려주기 때문에, 감이 아닌 데이터로 의사결정할 수 있습니다.

- **2단계 인터뷰** — Progressive Profiling (3+2문)으로 자연스러운 아이디어 도출
- **100점 가중 평가** — 5개 항목 × 가중치 = 100점 만점 스코어링
- **4단계 판정** — Go(80+) / Pivot-optimize(66~79) / Pivot-review(48~65) / Drop(~47)
- **Kill Switch** — 개별 항목 3점 미만 시 Critical Warning
- **브레인스토밍 프레임워크** — 역발상 리스크 발견 + 다각적 관점 분석 (Invisible Framework)
- **Impact-Effort 매트릭스** — 아이디어 우선순위를 2x2 사분면으로 시각화
- **조건부 SCAMPER** — 유사 아이디어 감지 시 차별화 아이디어 도출
- **Human-in-the-Loop** — 점수 확정 전 사용자 검토·조정
- **ASCII 시각화** — 레이더 차트 + 한국 R&D 키워드 매핑
- **멀티 아이디어 포트폴리오** — 여러 아이디어를 비교·관리하는 대시보드

---

## 8단계 기획 프로세스가 자동으로 이어집니다

아이디어가 확정되면 8단계를 순서대로 진행합니다. 각 단계의 결과가 다음 단계의 입력이 되는 구조라서, 슬래시 명령어를 하나씩 실행하면 체계적인 사업계획서가 완성됩니다.

```
[Step 0] 아이디어 발굴·검증 (선택)
    ↓
[Step 1] 시장조사 → [Step 2] 경쟁분석(SWOT) → [Step 3] 제품기획
    ↓
[Step 4] 재무모델링 → [Step 5] 운영계획 → [Step 6] 브랜딩
    ↓
[Step 7] 법률검토 → [Step 8] 사업계획서 작성
```

아이디어가 없으면 Step 0부터, 있으면 Step 1부터 시작합니다. 진행률 추적 기능(`/check-progress`)으로 어디까지 했는지, 다음에 뭘 해야 하는지도 자동 안내됩니다.

---

## 비개발자를 위해 설계했습니다

모든 소통은 한국어로 이루어지고, 프레임워크 용어(PESTEL, SCAMPER, PSST 등)는 사용자에게 노출하지 않습니다. AI가 내부적으로 전문 프레임워크를 적용하되, 사용자에게는 자연스러운 질문과 결과만 보여주는 **Invisible Framework** 원칙을 따릅니다.

자연어로 말하면 됩니다:

```
"사업 아이디어를 찾아줘"           → 아이디어 발굴 + 브레인스토밍 + 평가
"카페 시장을 조사해줘"            → 시장 규모, 트렌드, 고객 분석
"경쟁사를 분석해줘"               → SWOT, Porter's Five Forces
"재무 모델을 만들어줘"            → 손익계산, BEP, 3개년 재무제표
"사업계획서를 써줘"               → 전체 분석 결과 통합 문서
"기획 진행률을 확인해줘"          → 8단계 프로세스 완료율 체크
```

결과물은 ASCII 차트로 터미널에서 바로 확인하거나, HTML로 내보내서 PDF 공유도 가능합니다.

---

## 시작하기

### 1. 설치

```bash
git clone https://github.com/quantsquirrel/antigravity-business-planner.git
cd antigravity-business-planner
chmod +x setup.sh && ./setup.sh
```

### 2. Antigravity에서 열기

1. [Google Antigravity](https://antigravity.google)를 실행합니다
2. **File → Open Folder** → `antigravity-business-planner` 폴더 선택
3. 오른쪽 아래 채팅창이 나타나면 준비 완료

> **추천 설정:** Plan 과정에서 **Opus 4.6**을 사용하면 가장 좋은 결과를 얻을 수 있습니다.

### 3. 슬래시 명령어

| 명령어 | 기능 |
|--------|------|
| `/idea-discovery` | 아이디어 발굴 + 평가 |
| `/idea-brainstorm` | 브레인스토밍 프레임워크 |
| `/idea-validation` | 아이디어 심층 검증 |
| `/idea-portfolio` | 아이디어 포트폴리오 관리 |
| `/lean-canvas` | 린캔버스 작성 |
| `/market-research` | 시장 조사 |
| `/competitor-analysis` | 경쟁 분석 |
| `/financial-modeling` | 재무 모델링 |
| `/menu-costing` | 제품 원가 분석 |
| `/operations-plan` | 운영 계획 |
| `/branding-strategy` | 브랜딩 전략 |
| `/legal-checklist` | 법률/인허가 체크리스트 |
| `/business-plan-draft` | 사업계획서 작성 |
| `/check-progress` | 기획 진행률 확인 |
| `/export-documents` | 문서 HTML/PDF 내보내기 |
| `/my-outputs` | 산출물 목록 조회 |

---

## 핵심 구성

| 구성 | 개수 | 설명 |
|------|------|------|
| 워크플로우 | 16개 | `/시장조사`, `/재무모델링` 등 슬래시 명령어 또는 자연어로 실행 |
| 전문 스킬 | 12개 | 리서처, 재무분석, 기회발굴 등 자동 활성화되는 전문 능력 |
| 문서 템플릿 | 7개 | 사업계획서, 재무예측, 린캔버스, 피치덱 등 |
| AI 동작 규칙 | 4개 | 한국어 소통, 비즈니스 문서 스타일, 안전 가이드라인 |

### 전문 스킬

| 스킬 | 설명 |
|------|------|
| opportunity-finder | 아이디어 발굴·검증 (v2.0) |
| business-researcher | 시장조사·경쟁분석 |
| financial-analyst | 재무모델링·손익분석 |
| swot-analyzer | SWOT·경쟁 분석 |
| data-visualizer | 차트·시각화 |
| document-exporter | HTML/PDF 문서 내보내기 |
| report-writer | 보고서 자동 작성 |
| pitch-deck-creator | IR 피치덱 생성 |
| progress-tracker | 기획 진행률 추적 |
| launch-strategy | 런칭 전략 수립 |
| pricing-strategy | 가격 전략 분석 |
| startup-metrics-framework | 스타트업 핵심 지표 |

스킬은 관련 맥락이 감지되면 자동으로 활성화됩니다.

---

## 오픈소스이고, 확장 가능합니다

스킬과 워크플로우를 추가해서 자신만의 기획 프로세스로 커스터마이징할 수 있습니다. MCP 서버를 연동하면 Google Sheets나 Notion과 연결하여 실시간 데이터 기반 분석도 가능합니다.

| MCP 서버 | 용도 |
|----------|------|
| Google Sheets | 재무 모델을 스프레드시트로 관리 |
| Notion | 기획 문서 팀 협업 |
| Perplexity | 최신 시장 데이터 검색 |

설정 방법은 [GUIDE.md](GUIDE.md#5-mcp-서버-연동)를 참고하세요.

### 프로젝트 구조

```
antigravity-business-planner/
├── .agent/
│   ├── rules/           # AI 동작 규칙 (4개)
│   ├── workflows/       # 워크플로우 정의 (16개)
│   └── skills/          # 전문 스킬 (9 core + 3 symlink)
├── .agents/
│   └── skills/          # 확장 스킬 (launch/pricing/metrics)
├── templates/           # 문서 템플릿 (7개)
│   └── themes/          # HTML 내보내기 테마 (3종)
├── output/              # 모든 산출물 저장
├── setup.sh             # 원클릭 세팅 스크립트
├── GUIDE.md             # 상세 사용 가이드
└── mcp-config-template.json  # MCP 서버 설정 템플릿
```

### 요구 사항

- [Google Antigravity](https://antigravity.google) (무료)
- Python 3.8+ (차트 생성, 문서 내보내기용 — `setup.sh`가 자동 설치)

---

## 자세한 사용법

**[GUIDE.md](GUIDE.md)** — 설치부터 프롬프트 작성 팁, FAQ까지 상세 안내

**[프로젝트 분석 리포트](output/reports/Antigravity-Business-Planner.html)** — 전체 구조와 기능을 한눈에 보는 인터랙티브 리포트

---

## 주의사항

- AI가 생성한 재무 수치는 **추정치**입니다. 실제 사업 시 전문 회계사와 상담하세요.
- 법률 정보는 **참고용**입니다. 반드시 전문 법률가와 상담하세요.
- 시장 데이터는 출처를 직접 확인하세요.

---

> *16 workflows · 12 skills · 7 templates*
> *Built for [Google Antigravity](https://antigravity.google)*
