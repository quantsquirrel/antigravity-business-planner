# Antigravity 사업 기획 도구

> AI한테 한국어로 "시장조사 해줘", "사업계획서 써줘" 하면 아이디어 브레인스토밍부터 사업성 평가, 시장조사, 재무모델링, 사업계획서까지 알아서 만들어주는 도구입니다.

[Google Antigravity](https://antigravity.google)(AI IDE) 위에서 동작하며, `bash setup.sh` 한 줄이면 워크플로우 23개, 전문 스킬 17개, 문서 템플릿 13개가 자동 세팅됩니다. 코딩 없이 자연어만으로 사업 기획 전 과정을 수행할 수 있습니다.

---

## 아이디어가 없어도 시작할 수 있습니다

가장 큰 특징은 "아이디어가 없는 상태"에서 출발할 수 있다는 점입니다. 2단계 인터뷰(Progressive Profiling)로 사용자의 업종 경험에서 아이디어 3~5개를 끌어내고, 역발상 리스크 분석과 6가지 관점 브레인스토밍으로 사각지대를 점검합니다. 100점 만점 가중 스코어링과 Impact-Effort 매트릭스로 우선순위를 잡고, Go/Pivot/Drop 4단계 판정과 Kill Switch(치명적 리스크 경고)까지 자동으로 내려줍니다. 여러 아이디어를 동시에 관리하고 싶다면 멀티 아이디어 포트폴리오 대시보드로 비교/전환할 수 있습니다.

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
- **AI 사업 자동 감지** — AI 키워드 감지 시 8가지 사업 유형 분류 + 보충 분석 + 이중 스코어링

---

## AI 사업이라면 한 단계 더 깊이 분석합니다

"AI로 뭔가 해보고 싶다"고 입력하면 AI 사업 유형 8가지를 자동 분류하고, 기본 평가(100점)에 AI 경쟁력 보충 평가(100점)를 더한 이중 스코어링으로 기술 타당성, 데이터 경쟁력, 방어력까지 정밀 분석합니다. 재무 모델링에서도 API 호출 비용, MAU 구간별 스케일링 같은 AI 특화 변동비를 자동 반영합니다.

- **8가지 AI 사업 유형 자동 분류** — AI 대행 서비스, AI 소프트웨어, AI 중개 플랫폼, 데이터 사업, AI 컨설팅, AI 인프라, AI 콘텐츠, 산업 특화 AI
- **AI 경쟁력 이중 스코어링** — 기본 100점 + AI 경쟁력 100점 (데이터 경쟁력, 기술 차별화, 외부 의존 리스크, 기술 방어력)
- **AI 특화 재무 모델** — LLM API, GPU, 벡터DB 등 AI 변동비 + MAU별 스케일링 + Unit Economics + 건전성 5지표
- **AI 트렌드 지식 베이스** — LLM, RAG, Agent 등 10개 기술 트렌드 + 6개 비즈니스 모델 패턴 + 한국 AI 시장 참조 데이터

---

## 8단계 기획 프로세스가 자동으로 이어집니다

아이디어가 확정되면 8단계를 순서대로 진행합니다. 각 단계의 결과(TAM 수치, 원가율, BEP 등)가 다음 단계의 입력이 되는 체이닝 구조이고, 슬래시 명령어를 하나씩 실행하면 체계적인 사업계획서가 완성됩니다. 전 과정을 한번에 돌리고 싶다면 `/auto-plan`으로 자동 오케스트레이션도 가능합니다(중요 의사결정 3곳에서만 사용자 확인).

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

## 1인 빌더와 Micro-SaaS에도 맞춰집니다

처음에 사업 규모(micro/small/startup/enterprise)를 선택하면, 이후 모든 워크플로우가 규모에 맞게 자동 전환됩니다. Micro-SaaS를 선택하면 TAM/SAM/SOM 대신 니치 시장 검증, P&L 대신 MRR 중심 재무모델, 대규모 운영계획 대신 1인 자동화 스택과 주간 시간 배분이 나옵니다.

- **규모별 자동 전환** — micro(1인)/small(2-5인)/startup/enterprise 4단계, 선택에 따라 분석 관점이 자동 조정
- **니치 시장 검증** — TAM/SAM/SOM 대신 커뮤니티 수요, 지불 의향, 니치 스코어로 시장 유효성 판단
- **MRR 중심 재무 모델** — SaaS 도구비 기반 비용 구조, Unit Economics (ARPU/Churn/LTV/CAC), 구독자 성장 시나리오
- **자동화 스택 운영 계획** — 공급망/인력/시설 대신 1인 자동화 도구 스택 + 주간 시간 배분
- **부트스트랩 성장 전략** — 광고 대신 SEO/커뮤니티/Product Hunt 런칭 + 레퍼럴 프로그램
- **기술 스택 추천** — 사업 유형별 프론트/백/DB/배포 추천 + 무료 티어 활용 전략

---

## 산출물 품질을 자동으로 검증합니다

모든 산출물에 품질 게이트가 적용되어, 핵심 요약·데이터 출처·추정치 불확실성 표시 등을 자동 점검합니다. 수치 데이터에는 4등급 신뢰도가 자동 태깅되어, 감이 아닌 데이터로 의사결정하되 그 데이터가 얼마나 믿을 만한지까지 투명하게 보여줍니다.

- **품질 게이트** — 저장 전 필수 항목 5가지 자동 점검 + 워크플로우별 기준
- **데이터 신뢰도 4등급** — 모든 수치에 출처 등급 태깅: A(공식 출처) / B(2차 출처) / C(AI 추정) / D(사용자 가정)
- **자동 경고** — C/D 등급 50% 이상 시 경고, D 30% 이상 시 추가 시장조사 권고

---

## 프레임워크는 감추고, 결과만 보여줍니다

모든 소통은 한국어로 이루어지고, 내부적으로 사용하는 전문 프레임워크(PESTEL, SCAMPER, Porter's Five Forces, PSST 등)는 사용자에게 노출하지 않습니다. AI가 프레임워크를 적용하되 사용자에게는 자연스러운 질문과 결과만 보여주는 **Invisible Framework** 원칙을 따릅니다.

자연어로 말하면 됩니다:

```
"사업 아이디어를 찾아줘"           → 아이디어 발굴 + 브레인스토밍 + 평가
"카페 시장을 조사해줘"            → 시장 규모, 트렌드, 고객 분석
"경쟁사를 분석해줘"               → SWOT, Porter's Five Forces
"재무 모델을 만들어줘"            → 손익계산, BEP, 3개년 재무제표
"AI 법률 검토 서비스를 분석해줘"  → AI 사업 유형 분류 + 경쟁력 평가
"혼자 SaaS 만들고 싶어"          → 니치 검증 + MRR 재무 + 자동화 스택
"사업계획서를 써줘"               → 전체 분석 결과 통합 문서
"기획 진행률을 확인해줘"          → 8단계 프로세스 완료율 체크
```

결과물은 ASCII 차트, 레이더 차트, 마인드맵 등으로 터미널에서 바로 확인하거나, 3종 HTML 테마(modern/business/cosmic)로 내보내서 PDF 공유도 가능합니다.

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
| `/auto-plan` | 전 과정 자동 오케스트레이션 |
| `/check-progress` | 기획 진행률 확인 |
| `/export-documents` | 문서 HTML/PDF 내보내기 |
| `/my-outputs` | 산출물 목록 조회 |
| `/mvp-definition` | MVP 범위 정의 |
| `/gtm-launch` | Go-To-Market 전략 |
| `/kpi-framework` | KPI 프레임워크 |
| `/security-scan` | 산출물 보안 스캔 |
| `/version-history` | 변경 이력 관리 |
| `/tco-dashboard` | TCO 대시보드 |

---

## 핵심 구성

| 구성 | 개수 | 설명 |
|------|------|------|
| 워크플로우 | 23개 | `/시장조사`, `/재무모델링` 등 슬래시 명령어 또는 자연어로 실행 |
| 전문 스킬 | 17개 | 리서처, 재무분석, 기회발굴, AI 사업 분석, 니치 검증, 부트스트랩 계산, 기술 스택 추천 등 자동 활성화 |
| 문서 템플릿 | 13개 | 사업계획서, 재무예측, AI 재무, Micro-SaaS 재무, 부트스트랩 성장, 린캔버스, 피치덱 등 |
| AI 동작 규칙 | 9개 | 한국어 소통, 문서 스타일, 안전 가이드라인, AI 도메인 지식, 품질 게이트, 데이터 신뢰도, 규모별 모드 전환 등 |

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
| ai-business-analyst | AI 사업 유형 분류·경쟁력 평가 |
| niche-validator | 니치 시장 검증 (커뮤니티 수요, 지불 의향, 니치 스코어) |
| bootstrap-calculator | 부트스트랩 재무 계산 (MRR BEP, SaaS 비용, 성장 시나리오) |
| tech-stack-recommender | 1인 빌더 기술 스택 추천 (사업 유형별 스택, 자동화 도구, 비용 최적화) |

스킬은 관련 맥락이 감지되면 자동으로 활성화됩니다.

---

## 오픈소스이고, 확장 가능합니다

스킬과 워크플로우를 추가해서 자신만의 기획 프로세스로 커스터마이징할 수 있습니다. MCP 서버를 연동하면 외부 서비스와 연결하여 실시간 데이터 기반 분석도 가능합니다.

| MCP 서버 | 용도 |
|----------|------|
| Google Sheets | 재무 모델을 스프레드시트로 관리 |
| Notion | 기획 문서 팀 협업 |
| Perplexity | 최신 시장 데이터 검색 |
| Tavily | 심층 웹 검색 (경쟁사·산업 통계) |
| Sequential Thinking | 구조화된 단계별 분석 |

설정 방법은 [GUIDE.md](GUIDE.md#5-mcp-서버-연동)를 참고하세요.

### 프로젝트 구조

```
antigravity-business-planner/
├── .agent/
│   ├── rules/           # AI 동작 규칙 (9개)
│   ├── workflows/       # 워크플로우 정의 (23개)
│   └── skills/          # 전문 스킬 (14 core + 3 symlink)
├── .agents/
│   └── skills/          # 확장 스킬 (launch/pricing/metrics)
├── templates/           # 문서 템플릿 (13개)
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
- 시장 데이터는 출처를 직접 확인하세요. 데이터 신뢰도 등급([A]~[D])을 참고하세요.

---

> *23 workflows · 17 skills · 13 templates*
> *Built for [Google Antigravity](https://antigravity.google)*
