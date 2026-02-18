#!/usr/bin/env python3
"""
Impact-Effort Matrix Visualization (v1.0)

Default: ASCII 2x2 matrix (no dependencies)
Optional: Scatter plot PNG via matplotlib (--chart flag)

Usage:
    python create_impact_effort_matrix.py --name "AI 재고관리" --scores "4.2,3.1"
    python create_impact_effort_matrix.py --json idea.json
    python create_impact_effort_matrix.py --dir output/ideas/
    python create_impact_effort_matrix.py --dir output/ideas/ --chart --output matrix.png
"""

import argparse
import json
import sys
from pathlib import Path

# Quadrant definitions (Impact high/low x Effort high/low)
QUADRANTS = {
    "quick_win":      {"label": "Quick Win",      "desc": "즉시 실행",   "icon": "★"},
    "major_project":  {"label": "Major Project",  "desc": "장기 과제",   "icon": "◆"},
    "fill_in":        {"label": "Fill-in",        "desc": "자투리 과제", "icon": "○"},
    "thankless_task": {"label": "Thankless Task", "desc": "비효율 과제", "icon": "✕"},
}

# Midpoint threshold for quadrant classification (1-5 scale)
MID = 2.5


def calc_impact(score_details):
    """Calculate impact from score_details: (market_size * 5 + timing * 3) / 8."""
    market_size = score_details.get("market_size", 3)
    timing = score_details.get("timing", 3)
    return (market_size * 5 + timing * 3) / 8


def calc_effort(score_details):
    """Calculate effort from score_details: 6 - (resources * 3 + founder_fit * 5) / 8.
    Higher value = harder to execute."""
    resources = score_details.get("resources", 3)
    founder_fit = score_details.get("founder_fit", score_details.get("fit", 3))
    return 6 - (resources * 3 + founder_fit * 5) / 8


def classify_quadrant(impact, effort):
    """Classify into quadrant based on impact and effort values."""
    if impact >= MID and effort < MID:
        return "quick_win"
    elif impact >= MID and effort >= MID:
        return "major_project"
    elif impact < MID and effort < MID:
        return "fill_in"
    else:
        return "thankless_task"


def load_from_json(json_path):
    """Load a single idea from idea.json file."""
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    details = data.get("score_details", {})
    name = data.get("full_name", data.get("name", "Unknown"))
    impact = calc_impact(details)
    effort = calc_effort(details)
    return {"name": name, "impact": impact, "effort": effort}


def load_from_dir(dir_path):
    """Scan directory for idea.json files and load all."""
    ideas = []
    for json_path in sorted(Path(dir_path).glob("*/idea.json")):
        try:
            idea = load_from_json(str(json_path))
            ideas.append(idea)
        except (json.JSONDecodeError, KeyError) as e:
            print(f"  경고: {json_path} 로드 실패 — {e}", file=sys.stderr)
    return ideas


def render_ascii(ideas):
    """Render ASCII 2x2 impact-effort matrix — zero dependencies."""
    # Classify ideas into quadrants
    buckets = {"quick_win": [], "major_project": [], "fill_in": [], "thankless_task": []}
    for idea in ideas:
        q = classify_quadrant(idea["impact"], idea["effort"])
        buckets[q].append(idea)

    lines = []
    lines.append(f"\n{'='*64}")
    lines.append("  Impact-Effort 매트릭스")
    lines.append(f"{'='*64}")
    lines.append("")

    # Axis labels
    lines.append(f"  Impact (높음)")
    lines.append(f"  {'│':>4}")

    # Top row: Quick Win (left) | Major Project (right)
    qw_items = buckets["quick_win"]
    mp_items = buckets["major_project"]
    # Bottom row: Fill-in (left) | Thankless Task (right)
    fi_items = buckets["fill_in"]
    tt_items = buckets["thankless_task"]

    col_w = 28

    def format_cell(items, qkey):
        """Format items for a quadrant cell."""
        q = QUADRANTS[qkey]
        cell_lines = []
        cell_lines.append(f"{q['icon']} {q['label']}")
        cell_lines.append(f"  ({q['desc']})")
        if items:
            for idea in items:
                cell_lines.append(f"  · {idea['name'][:18]}")
                cell_lines.append(f"    I={idea['impact']:.1f} E={idea['effort']:.1f}")
        else:
            cell_lines.append("  (없음)")
        return cell_lines

    qw_cell = format_cell(qw_items, "quick_win")
    mp_cell = format_cell(mp_items, "major_project")
    fi_cell = format_cell(fi_items, "fill_in")
    tt_cell = format_cell(tt_items, "thankless_task")

    # Render top row
    max_top = max(len(qw_cell), len(mp_cell))
    lines.append(f"  {'│':>4}  {'─' * (col_w * 2 + 3)}")
    for i in range(max_top):
        left = qw_cell[i] if i < len(qw_cell) else ""
        right = mp_cell[i] if i < len(mp_cell) else ""
        lines.append(f"  {'│':>4}  │ {left:<{col_w}} │ {right:<{col_w}} │")
    lines.append(f"  {'│':>4}  {'─' * (col_w * 2 + 3)}")

    # Render bottom row
    max_bot = max(len(fi_cell), len(tt_cell))
    for i in range(max_bot):
        left = fi_cell[i] if i < len(fi_cell) else ""
        right = tt_cell[i] if i < len(tt_cell) else ""
        lines.append(f"  {'│':>4}  │ {left:<{col_w}} │ {right:<{col_w}} │")
    lines.append(f"  {'│':>4}  {'─' * (col_w * 2 + 3)}")

    lines.append(f"  Impact (낮음)")
    lines.append(f"  {'':>4}  Effort (낮음) ──────────── Effort (높음)")
    lines.append("")

    # Detail table
    lines.append(f"  {'아이디어':<20} {'Impact':>7} {'Effort':>7}  {'사분면'}")
    lines.append(f"  {'─'*58}")
    for idea in ideas:
        q = classify_quadrant(idea["impact"], idea["effort"])
        qinfo = QUADRANTS[q]
        lines.append(
            f"  {idea['name'][:18]:<20} {idea['impact']:>5.2f}  {idea['effort']:>5.2f}   "
            f"{qinfo['icon']} {qinfo['label']} ({qinfo['desc']})"
        )
    lines.append(f"  {'─'*58}")
    lines.append("")

    # Action summary
    lines.append("  [권장 액션]")
    if buckets["quick_win"]:
        names = ", ".join(i["name"][:15] for i in buckets["quick_win"])
        lines.append(f"  ★ Quick Win → 즉시 실행: {names}")
    if buckets["major_project"]:
        names = ", ".join(i["name"][:15] for i in buckets["major_project"])
        lines.append(f"  ◆ Major Project → 로드맵 수립: {names}")
    if buckets["fill_in"]:
        names = ", ".join(i["name"][:15] for i in buckets["fill_in"])
        lines.append(f"  ○ Fill-in → 여유 시간 활용: {names}")
    if buckets["thankless_task"]:
        names = ", ".join(i["name"][:15] for i in buckets["thankless_task"])
        lines.append(f"  ✕ Thankless Task → 재검토 또는 보류: {names}")
    lines.append("")

    lines.append(f"{'='*64}")
    lines.append("  매핑: Impact=(market_size*5+timing*3)/8, Effort=6-(resources*3+fit*5)/8")
    lines.append(f"{'='*64}\n")

    return "\n".join(lines)


def render_chart(ideas, output_path):
    """Render scatter plot PNG via matplotlib — optional dependency."""
    try:
        import matplotlib
        matplotlib.use('Agg')
        import matplotlib.pyplot as plt
        import matplotlib.font_manager as fm
    except ImportError:
        print("  matplotlib 미설치 — 차트를 생략하고 텍스트 결과만 표시합니다.")
        print("    설치: pip install matplotlib")
        return False

    # Korean font setup
    for font_name in ['AppleGothic', 'NanumGothic', 'Malgun Gothic']:
        try:
            fm.findfont(font_name, fallback_to_default=False)
            plt.rcParams['font.family'] = font_name
            plt.rcParams['axes.unicode_minus'] = False
            break
        except Exception as e:
            import warnings
            warnings.warn(f"Font setup failed: {e}")
            continue

    fig, ax = plt.subplots(figsize=(10, 8))

    # Quadrant background colors
    ax.axhspan(MID, 5.5, xmin=0, xmax=0.5, alpha=0.10, color='#34A853', label='Quick Win')
    ax.axhspan(MID, 5.5, xmin=0.5, xmax=1.0, alpha=0.10, color='#4285F4', label='Major Project')
    ax.axhspan(0, MID, xmin=0, xmax=0.5, alpha=0.10, color='#FBBC04', label='Fill-in')
    ax.axhspan(0, MID, xmin=0.5, xmax=1.0, alpha=0.10, color='#EA4335', label='Thankless Task')

    # Quadrant divider lines
    ax.axhline(y=MID, color='gray', linestyle='--', linewidth=0.8, alpha=0.5)
    ax.axvline(x=MID, color='gray', linestyle='--', linewidth=0.8, alpha=0.5)

    # Quadrant labels
    ax.text(1.25, 4.5, 'Quick Win\n(즉시 실행)', ha='center', va='center',
            fontsize=10, color='#34A853', alpha=0.6, fontweight='bold')
    ax.text(3.75, 4.5, 'Major Project\n(장기 과제)', ha='center', va='center',
            fontsize=10, color='#4285F4', alpha=0.6, fontweight='bold')
    ax.text(1.25, 1.0, 'Fill-in\n(자투리 과제)', ha='center', va='center',
            fontsize=10, color='#FBBC04', alpha=0.6, fontweight='bold')
    ax.text(3.75, 1.0, 'Thankless Task\n(비효율 과제)', ha='center', va='center',
            fontsize=10, color='#EA4335', alpha=0.6, fontweight='bold')

    # Plot ideas
    colors = {'quick_win': '#34A853', 'major_project': '#4285F4',
              'fill_in': '#FBBC04', 'thankless_task': '#EA4335'}
    for idea in ideas:
        q = classify_quadrant(idea["impact"], idea["effort"])
        ax.scatter(idea["effort"], idea["impact"], s=200, c=colors[q],
                   edgecolors='white', linewidth=1.5, zorder=5)
        ax.annotate(idea["name"][:15], (idea["effort"], idea["impact"]),
                    textcoords="offset points", xytext=(8, 8),
                    fontsize=9, fontweight='bold')

    ax.set_xlabel("Effort (높을수록 어려움) →", fontsize=12)
    ax.set_ylabel("Impact (높을수록 효과적) →", fontsize=12)
    ax.set_xlim(0.5, 5.5)
    ax.set_ylim(0.5, 5.5)
    ax.set_xticks([1, 2, 3, 4, 5])
    ax.set_yticks([1, 2, 3, 4, 5])
    ax.set_title("Impact-Effort 매트릭스", fontsize=14, fontweight='bold', pad=15)
    ax.legend(loc='upper left', fontsize=9, framealpha=0.8)
    ax.grid(True, alpha=0.2)

    plt.tight_layout()
    plt.savefig(output_path, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"  매트릭스 차트 저장: {output_path}")
    return True


def main():
    parser = argparse.ArgumentParser(description="Impact-Effort Matrix Visualization (v1.0)")
    parser.add_argument("--name", help="Idea name (used with --scores)")
    parser.add_argument("--scores", help="Comma-separated impact,effort (e.g. '3.5,2.1')")
    parser.add_argument("--json", help="Load from idea.json file")
    parser.add_argument("--dir", help="Scan directory for idea.json files")
    parser.add_argument("--chart", action="store_true", help="Generate scatter plot PNG (requires matplotlib)")
    parser.add_argument("--output", default="impact-effort-matrix.png", help="Chart output path")
    args = parser.parse_args()

    ideas = []

    if args.dir:
        ideas = load_from_dir(args.dir)
        if not ideas:
            print(f"  오류: {args.dir} 에서 idea.json 파일을 찾을 수 없습니다.")
            sys.exit(1)
    elif args.json:
        ideas = [load_from_json(args.json)]
    elif args.name and args.scores:
        parts = [float(v.strip()) for v in args.scores.split(",")]
        if len(parts) != 2:
            print("  오류: --scores는 impact,effort 2개 값이 필요합니다 (예: '3.5,2.1')")
            sys.exit(1)
        ideas = [{"name": args.name, "impact": parts[0], "effort": parts[1]}]
    else:
        parser.print_help()
        sys.exit(1)

    # Always print ASCII matrix
    print(render_ascii(ideas))

    # Optionally generate scatter chart
    if args.chart:
        render_chart(ideas, args.output)


if __name__ == "__main__":
    main()
