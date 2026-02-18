<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-18 | Updated: 2026-02-18 -->

# niche-validator

## Purpose
Micro-SaaS/1인 빌더의 니치 시장 유효성 검증 스킬. 커뮤니티 수요 분석, 기존 솔루션 불만 수집, 지불 의향 시그널 감지를 수행하고 5점 만점 니치 스코어로 Go/Pivot/Drop 판정을 내립니다. business_scale이 "micro" 또는 "small"일 때 자동 활성화됩니다.

## Key Files

| File | Description |
|------|-------------|
| `SKILL.md` | Skill definition: community demand analysis, payment willingness detection, niche score (5-point weighted), Go/Pivot/Drop verdict |

## For AI Agents

### Working In This Directory
- business_scale이 "micro" 또는 "small"일 때만 활성화
- /market-research 워크플로우 실행 시 연동
- 출력은 `output/research/niche-validation.md`에 저장
- 니치 스코어와 판정(Go/Pivot/Drop)을 반드시 포함

<!-- MANUAL: -->
