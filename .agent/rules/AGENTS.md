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

## For AI Agents

### Working In This Directory
- All three rules are loaded automatically; agents cannot selectively disable them
- When adding new rules, use concise bullet-point format consistent with existing files
- The term mapping table in `korean-communication.md` is critical: always use business terms (e.g., "전문 분석 도구" instead of "Skill") when communicating with users

<!-- MANUAL: -->
