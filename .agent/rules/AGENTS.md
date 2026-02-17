<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-16 | Updated: 2026-02-16 -->

# rules

## Purpose
Behavioral rules automatically applied to all agent responses. These are always active and define how the agent communicates, formats documents, and handles sensitive information.

## Key Files

| File | Description |
|------|-------------|
| `business-planning-style.md` | Document formatting: structured headers, data-backed claims, frameworks (SWOT, PESTEL, Porter's), executive summaries, balanced analysis |
| `korean-communication.md` | Korean language rules: honorifics, Korean units (억/만원), date format, technical-to-business term mapping table |
| `safety-guidelines.md` | Safety disclaimers: financial estimates marked as estimates, legal advice requires professional consultation, scenario analysis required for projections |
| `update-check.md` | Update check rule: periodic update verification and notification |
| `context-chaining.md` | Context chaining: 워크플로우 간 선행 산출물 자동 참조, 요약 주입, idea.json 메타데이터 전파 규칙 |
| `ai-domain-knowledge.md` | AI 도메인 지식: AI 기술 트렌드 10개, 비즈니스 모델 패턴 6개, 한국 AI 시장 특수 사항, AI 비용 참고 데이터, 용어 매핑 |
| `quality-gate.md` | 산출물 품질 게이트: 저장 전 필수 항목 5가지 자동 점검, 워크플로우별 필수 섹션 및 최소 데이터 포인트 정의 |
| `data-confidence.md` | 데이터 신뢰도 등급: 수치 데이터 4등급(A/B/C/D) 태깅, 경고 규칙, MCP 연동, Context Chaining 연동 |

## For AI Agents

### Working In This Directory
- All three rules are loaded automatically; agents cannot selectively disable them
- When adding new rules, use concise bullet-point format consistent with existing files
- The term mapping table in `korean-communication.md` is critical: always use business terms (e.g., "전문 분석 도구" instead of "Skill") when communicating with users

<!-- MANUAL: -->
