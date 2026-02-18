#!/usr/bin/env python3
"""Idea Portfolio HTML Dashboard Generator

Reads output/ideas/*/idea.json files and generates a visual HTML dashboard
at output/ideas/portfolio-dashboard.html.

Usage:
    python create_portfolio_dashboard.py [--output-dir OUTPUT_DIR]

Requires Python 3.8+ standard library only (json, os, glob, datetime, pathlib).
"""

import argparse
import json
import sys
from datetime import datetime
from pathlib import Path

from _shared import find_project_root, load_ideas, _status_label

STAGES = [
    {"id": 0, "name": "아이디어 발굴", "icon": "\U0001f4a1"},
    {"id": 1, "name": "시장 조사", "icon": "\U0001f4ca"},
    {"id": 2, "name": "경쟁 분석", "icon": "\U0001f50d"},
    {"id": 3, "name": "제품/원가", "icon": "\U0001f3f7\ufe0f"},
    {"id": 4, "name": "재무 모델", "icon": "\U0001f4b0"},
    {"id": 5, "name": "운영 계획", "icon": "\u2699\ufe0f"},
    {"id": 6, "name": "브랜딩", "icon": "\U0001f3a8"},
    {"id": 7, "name": "법률/인허가", "icon": "\u2696\ufe0f"},
    {"id": 8, "name": "사업계획서", "icon": "\U0001f4cb"},
]

TOTAL_STAGES = len(STAGES)  # 9 (0-8)




def check_stage_completion(idea_dir):
    """Check which stages (0-8) are complete for an idea directory.

    Returns a list of booleans, one per stage.
    """
    idea_dir = Path(idea_dir)
    completed = [False] * TOTAL_STAGES

    # Stage 0: hypothesis.md or evaluation.md exists
    if (idea_dir / "hypothesis.md").exists() or (idea_dir / "evaluation.md").exists():
        completed[0] = True

    # Stage 1: research/ has any file
    research_dir = idea_dir / "research"
    if research_dir.exists():
        files = [f for f in research_dir.rglob("*") if f.is_file()]
        if files:
            completed[1] = True

        # Stage 2: research/ has file with keyword
        for f in files:
            fname = f.name.lower()
            if "경쟁" in fname or "competitor" in fname:
                completed[2] = True
                break

    # Stage 3: financials/ has cost/menu file
    financials_dir = idea_dir / "financials"
    if financials_dir.exists():
        for f in financials_dir.rglob("*"):
            if f.is_file():
                fname = f.name.lower()
                if "원가" in fname or "cost" in fname or "menu" in fname:
                    completed[3] = True
                # Stage 4: financials/ has financial/projection file
                if "재무" in fname or "financial" in fname or "projection" in fname:
                    completed[4] = True

    # Stages 5-8: reports/ keyword matching
    reports_dir = idea_dir / "reports"
    if reports_dir.exists():
        for f in reports_dir.rglob("*"):
            if f.is_file():
                fname = f.name.lower()
                if "운영" in fname or "operation" in fname:
                    completed[5] = True
                if "브랜딩" in fname or "brand" in fname:
                    completed[6] = True
                if "법률" in fname or "legal" in fname:
                    completed[7] = True
                if "사업계획" in fname or "business-plan" in fname:
                    completed[8] = True

    return completed


def _status_class(status):
    """Return CSS class name for status badge."""
    if status == "go":
        return "go"
    elif status == "pivot":
        return "pivot"
    elif status == "drop":
        return "drop"
    return ""


def _build_idea_card(idea, stages_completed):
    """Build HTML for a single idea card."""
    full_name = idea.get("full_name", idea.get("name", ""))
    status = idea.get("status", "")
    raw_score = idea.get("score", 0) or 0
    score = raw_score * 4 if raw_score <= 25 else raw_score
    score_details = idea.get("score_details", {})
    created = idea.get("created", "")

    completed_count = sum(stages_completed)
    percentage = round(completed_count / TOTAL_STAGES * 100)

    # Find current and next stage
    current_stage_name = "완료"
    next_stage_name = "-"
    for i, done in enumerate(stages_completed):
        if not done:
            current_stage_name = STAGES[i]["name"]
            next_idx = i + 1
            if next_idx < TOTAL_STAGES:
                next_stage_name = STAGES[next_idx]["name"]
            else:
                next_stage_name = "-"
            break

    # Score bars
    score_items = [
        ("시장 크기", score_details.get("market_size", 0)),
        ("경쟁 강도", score_details.get("competition", 0)),
        ("적합성", score_details.get("fit", 0)),
        ("자원 요건", score_details.get("resources", 0)),
        ("타이밍", score_details.get("timing", 0)),
    ]

    score_bars_html = ""
    for label, value in score_items:
        width = (value or 0) * 20
        score_bars_html += f"""
                        <div class="score-bar-item">
                            <span class="score-label">{label}</span>
                            <div class="score-bar"><div class="score-fill" style="width:{width}%"></div></div>
                            <span class="score-value">{value}</span>
                        </div>"""

    badge_class = _status_class(status)
    badge_label = _status_label(status)

    return f"""
                <div class="idea-card">
                    <div class="idea-header">
                        <h3>{full_name}</h3>
                        <span class="badge {badge_class}">{badge_label}</span>
                    </div>
                    <div class="score-section">
                        <div class="total-score">{score}<span class="score-max">/100</span></div>
                        <div class="score-bars">{score_bars_html}
                        </div>
                    </div>
                    <div class="progress-section">
                        <div class="progress-label">진행률 {percentage}%</div>
                        <div class="progress-track"><div class="progress-fill" style="width:{percentage}%"></div></div>
                        <div class="current-stage">현재: {current_stage_name} &rarr; 다음: {next_stage_name}</div>
                    </div>
                    <div class="idea-meta">생성일: {created}</div>
                </div>"""


def _build_comparison_row(idea, stages_completed):
    """Build a <tr> for the comparison table."""
    full_name = idea.get("full_name", idea.get("name", ""))
    status = idea.get("status", "")
    score_details = idea.get("score_details", {})
    raw_score = idea.get("score", 0) or 0
    score = raw_score * 4 if raw_score <= 25 else raw_score
    completed_count = sum(stages_completed)
    percentage = round(completed_count / TOTAL_STAGES * 100)

    badge_class = _status_class(status)
    badge_label = _status_label(status)

    return f"""
                        <tr>
                            <td>{full_name}</td>
                            <td><span class="badge {badge_class}">{badge_label}</span></td>
                            <td>{score_details.get("market_size", "-")}</td>
                            <td>{score_details.get("competition", "-")}</td>
                            <td>{score_details.get("fit", "-")}</td>
                            <td>{score_details.get("resources", "-")}</td>
                            <td>{score_details.get("timing", "-")}</td>
                            <td><strong>{score}</strong></td>
                            <td>{percentage}%</td>
                        </tr>"""


def generate_html(ideas, output_path):
    """Generate the HTML dashboard file."""
    # Prepare enriched data
    enriched = []
    for idea in ideas:
        stages_completed = check_stage_completion(idea["dir_path"])
        enriched.append((idea, stages_completed))

    # Count statuses
    total = len(ideas)
    go_count = sum(1 for i in ideas if i.get("status") == "go")
    pivot_count = sum(1 for i in ideas if i.get("status") == "pivot")
    drop_count = sum(1 for i in ideas if i.get("status") == "drop")

    generated_at = datetime.now().strftime("%Y-%m-%d %H:%M")

    # Build body content
    if total == 0:
        body_content = """
            <div class="empty-state">
                <h2>아직 아이디어가 없습니다</h2>
                <p>Antigravity 대화창에서 아래와 같이 말해보세요:</p>
                <div class="cmd-block"><pre>사업 아이디어를 찾아보고 싶어요</pre></div>
            </div>"""
    else:
        # Hero stats
        hero_html = f"""
            <div class="hero">
                <h1>아이디어 포트폴리오</h1>
                <p class="hero-subtitle">내 사업 아이디어를 한눈에 관리하세요</p>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number">{total}</div>
                        <div class="stat-label">전체 아이디어</div>
                    </div>
                    <div class="stat-card" style="border-top-color: var(--accent-green)">
                        <div class="stat-number">{go_count}</div>
                        <div class="stat-label">Go (진행)</div>
                    </div>
                    <div class="stat-card" style="border-top-color: #f7971e">
                        <div class="stat-number">{pivot_count}</div>
                        <div class="stat-label">Pivot (수정)</div>
                    </div>
                    <div class="stat-card" style="border-top-color: #ff6b9d">
                        <div class="stat-number">{drop_count}</div>
                        <div class="stat-label">Drop (보류)</div>
                    </div>
                </div>
            </div>"""

        # Idea cards
        cards_html = ""
        for idea, stages_completed in enriched:
            cards_html += _build_idea_card(idea, stages_completed)

        grid_html = f"""
            <section class="cards-section">
                <div class="highlight-grid">{cards_html}
                </div>
            </section>"""

        # Comparison table
        rows_html = ""
        for idea, stages_completed in enriched:
            rows_html += _build_comparison_row(idea, stages_completed)

        comparison_html = f"""
            <section class="comparison">
                <h2>아이디어 비교</h2>
                <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>아이디어</th>
                            <th>상태</th>
                            <th>시장</th>
                            <th>경쟁</th>
                            <th>적합</th>
                            <th>자원</th>
                            <th>타이밍</th>
                            <th>총점</th>
                            <th>진행률</th>
                        </tr>
                    </thead>
                    <tbody>{rows_html}
                    </tbody>
                </table>
                </div>
            </section>"""

        body_content = hero_html + f"""
            <div class="dashboard-body">
{grid_html}
{comparison_html}
            </div>"""

    html = f"""<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디어 포트폴리오 | Antigravity Business Planner</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;400;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css">
    <style>
        :root {{
            --bg-deep: #0a0e27;
            --bg-space: #0d1117;
            --bg-card: rgba(15, 20, 40, 0.8);
            --bg-card-hover: rgba(20, 30, 60, 0.9);
            --text-primary: #e8edf5;
            --text-secondary: #8892b0;
            --text-muted: #5a6785;
            --accent-gold: #ffd700;
            --accent-blue: #667eea;
            --accent-cyan: #00d2ff;
            --accent-green: #43e97b;
            --border-glass: rgba(255, 255, 255, 0.08);
            --border-glass-hover: rgba(255, 255, 255, 0.15);
            --glass-subtle: rgba(15, 20, 40, 0.4);
            --glass-standard: rgba(15, 20, 40, 0.7);
            --glass-elevated: rgba(20, 28, 58, 0.85);
            --blur-subtle: blur(8px);
            --blur-standard: blur(16px);
            --blur-elevated: blur(24px);
            --space-xs: 8px;
            --space-sm: 16px;
            --space-md: 24px;
            --space-lg: 32px;
            --space-xl: 48px;
            --radius-sm: 8px;
            --radius-md: 16px;
            --font-mono: 'JetBrains Mono', 'SF Mono', 'Monaco', 'Fira Code', monospace;
            --rainbow: linear-gradient(135deg, #667eea, #00d2ff, #43e97b, #f7971e, #ff6b9d, #c471ed);
        }}

        *, *::before, *::after {{ box-sizing: border-box; margin: 0; padding: 0; }}

        body {{
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", sans-serif;
            background: var(--bg-deep);
            color: var(--text-primary);
            line-height: 1.3;
            height: 100dvh;
            overflow: hidden;
            font-size: clamp(0.7rem, 1.2vh, 0.95rem);
        }}

        h1, h2, h3 {{
            font-family: 'Outfit', sans-serif;
        }}

        .container {{
            max-width: 1200px;
            margin: 0 auto;
            padding: 1vh 2vw 0.5vh;
            height: 100dvh;
            display: grid;
            grid-template-rows: auto 1fr auto;
        }}

        /* Hero */
        .hero {{
            text-align: center;
            padding: 0.5vh 0;
        }}
        .hero h1 {{
            font-size: 1.5rem;
            font-weight: 600;
            background: var(--rainbow);
            background-size: 200% auto;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 2px;
        }}
        .hero-subtitle {{
            color: var(--text-secondary);
            font-size: 0.85rem;
            margin-bottom: var(--space-sm);
        }}

        /* Stats grid */
        .stats-grid {{
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: var(--space-xs);
            max-width: 500px;
            margin: 0 auto;
        }}
        .stat-card {{
            background: var(--glass-standard);
            backdrop-filter: var(--blur-subtle);
            border: 1px solid var(--border-glass);
            border-top: 2px solid var(--accent-blue);
            border-radius: var(--radius-sm);
            padding: 8px 10px;
            text-align: center;
        }}
        .stat-number {{
            font-family: 'Outfit', sans-serif;
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--text-primary);
        }}
        .stat-label {{
            font-size: 0.72rem;
            color: var(--text-secondary);
            margin-top: 2px;
        }}

        /* Cards + Comparison wrapper */
        .dashboard-body {{
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1vw;
            min-height: 0;
            overflow: hidden;
        }}
        .cards-section {{
            display: contents;
        }}
        .highlight-grid {{
            display: flex;
            flex-direction: column;
            gap: 1vh;
            min-height: 0;
        }}

        /* Idea card */
        .idea-card {{
            flex: 1;
            min-height: 0;
            max-height: 280px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: var(--glass-standard);
            backdrop-filter: var(--blur-standard);
            border: 1px solid var(--border-glass);
            border-radius: var(--radius-sm);
            padding: 1.2vh 1vw;
            transition: all 0.2s ease;
        }}
        .idea-card:hover {{
            border-color: var(--border-glass-hover);
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        }}
        .idea-header {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5vh;
            gap: 6px;
        }}
        .idea-header h3 {{
            font-size: 0.95em;
            font-weight: 600;
            line-height: 1.2;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }}

        /* Badge */
        .badge {{
            display: inline-block;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 0.78rem;
            font-weight: 500;
            white-space: nowrap;
            flex-shrink: 0;
        }}
        .badge.go {{
            background: rgba(67,233,123,0.15);
            color: var(--accent-green);
            border: 1px solid rgba(67,233,123,0.3);
        }}
        .badge.pivot {{
            background: rgba(247,151,30,0.15);
            color: #f7971e;
            border: 1px solid rgba(247,151,30,0.3);
        }}
        .badge.drop {{
            background: rgba(255,107,157,0.15);
            color: #ff6b9d;
            border: 1px solid rgba(255,107,157,0.3);
        }}

        /* Score section */
        .score-section {{
            display: flex;
            align-items: flex-start;
            gap: 0.5vw;
            margin-bottom: 0.3vh;
        }}
        .total-score {{
            font-family: 'Outfit', sans-serif;
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--accent-cyan);
            white-space: nowrap;
            flex-shrink: 0;
        }}
        .score-max {{
            font-size: 0.75rem;
            color: var(--text-muted);
            font-weight: 400;
        }}
        .score-bars {{
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 0.2vh;
        }}
        .score-bar-item {{
            display: flex;
            align-items: center;
            font-size: 0.7rem;
        }}
        .score-label {{
            width: 52px;
            color: var(--text-secondary);
            flex-shrink: 0;
        }}
        .score-bar {{
            height: 4px;
            background: rgba(255,255,255,0.1);
            border-radius: 2px;
            flex: 1;
            margin: 0 6px;
        }}
        .score-fill {{
            height: 100%;
            border-radius: 2px;
            background: var(--rainbow);
            background-size: 200% 100%;
        }}
        .score-value {{
            width: 14px;
            text-align: right;
            color: var(--text-muted);
            flex-shrink: 0;
        }}

        /* Progress section */
        .progress-section {{
            margin-bottom: 0.3vh;
        }}
        .progress-label {{
            font-size: 0.72rem;
            color: var(--text-secondary);
            margin-bottom: 3px;
        }}
        .progress-track {{
            height: 5px;
            background: rgba(255,255,255,0.08);
            border-radius: 3px;
            overflow: hidden;
        }}
        .progress-fill {{
            height: 100%;
            border-radius: 3px;
            background: linear-gradient(90deg, var(--accent-blue), var(--accent-cyan), var(--accent-green));
        }}
        .current-stage {{
            font-size: 0.7rem;
            color: var(--text-muted);
            margin-top: 3px;
        }}

        /* Meta */
        .idea-meta {{
            font-size: 0.68em;
            color: var(--text-muted);
            padding-top: 0.3vh;
            border-top: 1px solid var(--border-glass);
        }}

        /* Comparison table */
        .comparison {{
            margin-top: 0;
            display: flex;
            flex-direction: column;
            min-height: 0;
        }}
        .comparison h2 {{
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 8px;
        }}
        .table-wrapper {{
            overflow-x: auto;
        }}
        .comparison table {{
            width: 100%;
            border-collapse: collapse;
            font-size: 0.78em;
            display: flex;
            flex-direction: column;
            flex: 1;
            min-height: 0;
        }}
        .comparison thead {{
            flex: 0 0 auto;
        }}
        .comparison tbody {{
            flex: 1;
            display: flex;
            flex-direction: column;
            min-height: 0;
        }}
        .comparison tr {{
            flex: 1;
            display: flex;
            align-items: center;
        }}
        .comparison th {{
            flex: 1;
            text-align: left;
            padding: 0.5vh 0.4vw;
            color: var(--text-secondary);
            font-weight: 500;
            border-bottom: 1px solid var(--border-glass-hover);
            white-space: nowrap;
        }}
        .comparison td {{
            flex: 1;
            padding: 0.5vh 0.4vw;
            border-bottom: 1px solid var(--border-glass);
            color: var(--text-primary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }}
        .comparison tr:hover td {{
            background: var(--glass-subtle);
        }}

        /* Empty state */
        .empty-state {{
            text-align: center;
            padding: 80px var(--space-md);
        }}
        .empty-state h2 {{
            font-size: 1.6rem;
            margin-bottom: var(--space-sm);
            color: var(--text-secondary);
        }}
        .empty-state p {{
            color: var(--text-muted);
            margin-bottom: var(--space-md);
        }}
        .cmd-block {{
            display: inline-block;
            background: var(--glass-standard);
            border: 1px solid var(--border-glass);
            border-radius: var(--radius-sm);
            padding: var(--space-sm) var(--space-md);
        }}
        .cmd-block pre {{
            font-family: var(--font-mono);
            font-size: 0.95rem;
            color: var(--accent-cyan);
        }}

        /* Footer */
        .footer {{
            text-align: center;
            padding-top: 0.5vh;
            border-top: 1px solid var(--border-glass);
            font-size: 0.68em;
            color: var(--text-muted);
        }}

        /* Responsive */
        @media (max-width: 900px) {{
            .dashboard-body {{
                grid-template-columns: 1fr;
                overflow: auto;
            }}
            .stats-grid {{
                grid-template-columns: repeat(2, 1fr);
            }}
            .score-section {{
                flex-direction: column;
            }}
        }}
    </style>
</head>
<body>
    <div class="container">
{body_content}

        <div class="footer">
            Antigravity Business Planner &mdash; Generated {generated_at}
        </div>
    </div>
</body>
</html>"""

    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(html, encoding="utf-8")
    return str(output_path)


def main():
    parser = argparse.ArgumentParser(
        description="Idea Portfolio HTML Dashboard Generator"
    )
    parser.add_argument(
        "--output-dir",
        default=None,
        help="Output directory (default: output/ideas/)",
    )
    args = parser.parse_args()

    project_root = find_project_root()

    if args.output_dir:
        output_dir = Path(args.output_dir)
    else:
        output_dir = project_root / "output" / "ideas"

    ideas_dir = project_root / "output" / "ideas"
    ideas = load_ideas(ideas_dir)

    output_path = output_dir / "portfolio-dashboard.html"

    try:
        result_path = generate_html(ideas, output_path)
        print(result_path)
        sys.exit(0)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
