<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-18 | Updated: 2026-02-18 -->

# bootstrap-calculator

## Purpose
부트스트랩(자기 자본) SaaS 재무 계산 스킬. MRR 기반 BEP 계산, SaaS 비용 구조 산출, 구독자 성장 시나리오 시뮬레이션, 가격 민감도 분석을 수행합니다. business_scale이 "micro" 또는 "small"일 때 자동 활성화됩니다.

## Key Files

| File | Description |
|------|-------------|
| `SKILL.md` | Skill definition: MRR-based BEP, SaaS cost structure, subscriber growth scenarios (pessimistic/base/optimistic), price sensitivity analysis |

## For AI Agents

### Working In This Directory
- business_scale이 "micro" 또는 "small"일 때만 활성화
- /financial-modeling 워크플로우 실행 시 연동
- 모든 수치에 "추정치" 면책 표기 필수
- 출력은 `output/financials/bootstrap-projection.md`에 저장

<!-- MANUAL: -->
