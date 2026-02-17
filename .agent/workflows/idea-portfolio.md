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
* **Impact-Effort 매트릭스 뷰**: 아이디어가 2개 이상이면 `scripts/create_impact_effort_matrix.py --dir output/ideas/`로 2x2 매트릭스를 생성하여 Quick Wins / Big Bets / Fill-ins / Avoid 사분면에 배치합니다

### 3단계: 사용자 행동 선택지 제시
사용자에게 다음 중 하나를 선택하도록 안내합니다:
1. **특정 아이디어 상세 보기** → `scripts/check_progress.py --idea {id}` 로 해당 아이디어의 진행률 상세 표시
2. **아이디어 비교하기** → 2개 아이디어를 선택하여 점수/진행률을 나란히 비교
3. **Impact-Effort 매트릭스로 우선순위 보기** → `scripts/create_impact_effort_matrix.py --dir output/ideas/`로 전체 아이디어의 Impact-Effort 사분면 배치 확인
4. **새 아이디어 추가하기** → `/idea-discovery` 로 이동
5. **특정 아이디어 다음 단계 진행하기** → 해당 아이디어 컨텍스트로 전환

### 4단계: portfolio.md 갱신
* 워크플로우 실행 시 `output/ideas/portfolio.md`를 자동 갱신합니다
* `<!-- AUTO:START -->` ~ `<!-- AUTO:END -->` 영역만 교체합니다
* 영역 바깥의 사용자 메모는 보존합니다

### Step 5: HTML 대시보드 생성

1. `scripts/create_portfolio_dashboard.py` 실행:
   ```bash
   python .agent/skills/scripts/create_portfolio_dashboard.py
   ```
2. 생성된 대시보드 파일 경로를 안내:
   - "포트폴리오 대시보드가 생성되었습니다: output/ideas/portfolio-dashboard.html"
   - "브라우저에서 열어 아이디어들을 시각적으로 비교해보세요."

## 기능 상세

### 포트폴리오 조회
* 전체 아이디어 목록을 테이블 형식으로 표시합니다
* 컬럼: 아이디어 ID, 이름, 종합 점수, 진행률(%), 판정(Go/Pivot-optimize/Pivot-review/Drop)

### 아이디어 상세
* 특정 아이디어의 5점 척도 평가(시장크기, 경쟁강도, 창업자-문제 적합성, 자원, 타이밍) 표시
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
