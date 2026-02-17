# idea-discovery

사업 아이디어를 발굴합니다. 도메인 지식은 있지만 구체적인 사업 아이디어가 없는 사용자를 위한 워크플로우입니다.

## 수행 작업
* 2단계 인터뷰로 사용자의 도메인 경험과 역량을 체계적으로 파악합니다 (Implicit Structuring)
* 답변에서 시장 기회 영역을 추출합니다
* 기존 대안/경쟁 상황을 자연스럽게 수집합니다
* 3-5개의 사업 아이디어를 가설 형태(1문단)로 생성합니다
* 각 아이디어를 5점 척도(시장크기, 경쟁강도, 창업자-문제 적합성, 자원, 타이밍)로 평가합니다 (가중 합산 100점 만점)
* Go/Pivot/Drop 판정을 내립니다 (v2.0: 4단계 — Go/Pivot-최적화/Pivot-재검토/Drop)
* 개별 항목 3점 미만 시 Kill Switch 경고를 표시합니다

## 2단계 인터뷰 프로토콜 (v2.0)

> 약 2-3분 소요됩니다.

### Step A: 문제 탐색
AI가 내부적으로 PSST의 **Problem + Scale**에 매핑합니다. 사용자에게는 한국어 자연어 질문만 표시됩니다.

1. **업종/산업**: "어떤 분야에서 일하고 계시나요?" (예: 요식업, IT, 교육, 의료)
2. **문제/불편함**: "그 분야에서 일하면서 가장 불편하거나 비효율적이라고 느낀 점은 무엇인가요?"
3. **기존 해결 방법**: "지금은 이 문제를 어떻게 해결하고 있나요? 다른 사람들은요?"

### Step B: 솔루션/팀 탐색
AI가 내부적으로 PSST의 **Solution + Team**에 매핑합니다.

4. **해결 방안**: "이 문제를 어떻게 해결하려고 하시나요? 어떤 아이디어가 있으신가요?"
5. **적합성**: "왜 당신(또는 팀)이 이 문제를 잘 풀 수 있다고 생각하시나요? (경력, 네트워크, 기술 등)"

### 설계 원칙
* **Implicit Structuring**: PSST/JTBD 용어를 사용자에게 노출하지 않습니다. AI가 내부적으로 매핑합니다
* **Progressive Profiling**: 질문을 2단계로 나누어 인지 부하를 줄입니다
* **한국어 우선**: 모든 질문과 출력은 한국어로 제공합니다
* **레거시 호환**: `--legacy` 모드 시 기존 5질문 일괄 방식으로 동작합니다

<details>
<summary>레거시 모드 (--legacy)</summary>

기존 5질문 일괄 방식을 사용합니다:
1. **업종/산업**: 어떤 분야에서 일하고 계시나요?
2. **경력/경험**: 해당 분야에서 얼마나 오래, 어떤 역할로 일하셨나요?
3. **문제점/불편함**: 일하면서 가장 비효율적이라고 느낀 점은?
4. **가용 자원**: 초기 투자 가능 금액, 활용 가능한 네트워크/자산은?
5. **목표 고객층**: 어떤 고객에게 서비스하고 싶으신가요?

</details>

## 프로세스 흐름 (v2.0)
```
Step A(문제 탐색 3문) → Step B(솔루션/팀 2문) → 키워드 추출 → 아이디어 3-5개 생성 → 5점 척도 평가 → Kill Switch 검사 → Go/Pivot-최적화/Pivot-재검토/Drop
```

### 판정 기준 (v2.0)
- **Go** (80점 이상): 즉시 심층 분석 진행
- **Pivot-최적화** (66-79점): 특정 항목 보완 후 재평가
- **Pivot-재검토** (48-65점): 근본적 재검토 필요, 방향 전환 권고
- **Drop** (47점 이하): 다른 아이디어 탐색

### Kill Switch
- 개별 항목 3점 미만 시 **Critical Warning** 표시
- 총점과 무관하게 해당 항목의 위험 사유를 설명
- 사용자가 `CONTINUE` 확인 또는 `--force` 플래그로 오버라이드 가능

## 아이디어 저장 규칙

Go 판정을 받은 아이디어는 개별 폴더를 생성합니다:

```
output/ideas/{id}-{name}/
├── idea.json               # 메타 정보 (id, name, status, score, workflow_version 등)
├── hypothesis.md           # 아이디어 가설 (1문단)
├── evaluation.md           # Go/Pivot/Drop 평가 결과 (v2.0: Kill Switch 포함)
├── existing-alternatives.md # 기존 대안/경쟁 솔루션 (v2.0 신규)
├── research/               # (빈 디렉토리, 추후 시장조사용)
├── financials/             # (빈 디렉토리, 추후 재무분석용)
└── reports/                # (빈 디렉토리, 추후 보고서용)
```

* ID 형식: `idea-{NNN}` (3자리 제로패딩, 자동 채번)
* 레거시 호환: `output/ideas/selected-idea.md`에도 최신 Go 아이디어 참조 유지

## 다음 단계
* **Go 판정 아이디어가 있으면**: `/idea-validation` 으로 검증 진행
* **Pivot-최적화 판정**: 해당 항목 보완 후 재평가 (최대 2회)
* **Pivot-재검토 판정**: 방향 전환 권고, 새로운 관점에서 재검토
* **모두 Drop이면**: 질문을 보완하여 처음부터 재시도
* **Kill Switch 발동 시**: 경고 확인 후 진행 여부 결정
* **여러 아이디어를 관리하려면**: `/idea-portfolio` 로 포트폴리오 확인

## 시각화 출력 (v2.0)

평가 완료 후 `scripts/create_idea_score_chart.py`를 실행하여 결과를 시각화합니다:

* **기본 (의존성 없음)**: ASCII/유니코드 바 차트 + 한국 R&D 키워드 매핑
* **선택 (--chart)**: Python matplotlib 레이더 차트 PNG 생성

```bash
# 기본: ASCII 차트 (항상 동작)
python3 scripts/create_idea_score_chart.py --name "아이디어명" --scores "4,3,5,4,3"

# 선택: 레이더 차트 (matplotlib 필요)
python3 scripts/create_idea_score_chart.py --name "아이디어명" --scores "4,3,5,4,3" --chart --output output/ideas/{id}-{name}/radar.png

# idea.json에서 자동 로드
python3 scripts/create_idea_score_chart.py --json output/ideas/{id}-{name}/idea.json
```

> matplotlib 미설치 시 "차트 생략" 경고만 표시하고 텍스트 결과는 정상 출력됩니다.

### 한국 R&D 평가 키워드 매핑
| PSST 내부 매핑 | 한국어 출력 | 정부지원사업 키워드 |
|---|---|---|
| Problem + Market | 시장 크기 | 필요성(Necessity) |
| Solution + Alternatives | 경쟁 강도 + 창업자-문제 적합성 | 차별화(Differentiation) |
| Team/Founder | 창업자-문제 적합성 | 팀 역량 |
| Scale | 타이밍 | 성장성/확장성 |

## 출력 형식
* 각 아이디어를 가설 형태(1문단)로 작성합니다
* 평가 결과를 ASCII 차트 또는 표로 시각화합니다
* 한국 R&D 키워드(필요성, 차별화)를 출력에 포함합니다
* Go 판정 아이디어는 `output/ideas/{id}-{name}/` 폴더에 저장합니다
* `output/ideas/selected-idea.md`에도 최신 Go 아이디어 참조를 유지합니다
