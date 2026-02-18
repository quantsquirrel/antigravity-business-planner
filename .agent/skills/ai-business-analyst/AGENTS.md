<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-18 | Updated: 2026-02-18 -->

# ai-business-analyst

## Purpose
AI 기술 기반 사업 아이디어의 전문 분석 스킬. 8가지 AI 비즈니스 Archetype 자동 분류, 기술 타당성/비용 구조/방어력 평가, AI 경쟁력 보충 스코어링(100점)을 수행합니다. opportunity-finder에서 AI 키워드 감지 시 자동 연동됩니다.

## Key Files

| File | Description |
|------|-------------|
| `SKILL.md` | Skill definition: 8 AI business archetypes, dual scoring (base 100 + AI 100), tech feasibility, cost structure, moat strategy |

## For AI Agents

### Working In This Directory
- AI 키워드 감지 시 opportunity-finder와 연동하여 이중 스코어링 수행
- Invisible Framework 원칙: 내부 Archetype 분류는 사용자에게 노출하지 않음
- AI 변동비(LLM API, GPU, 벡터DB)는 financial-analyst 스킬과 연동
- 출력은 `output/ideas/{id}/ai-analysis.md`에 저장

<!-- MANUAL: -->
