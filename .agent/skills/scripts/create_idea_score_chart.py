#!/usr/bin/env python3
"""
Idea Score Visualization (v2.0)

Default: ASCII/Unicode bar chart (no dependencies)
Optional: Radar chart PNG via matplotlib (--chart flag)

Usage:
    python create_idea_score_chart.py --name "AI 재고관리" --scores "4,3,5,4,3"
    python create_idea_score_chart.py --name "AI 재고관리" --scores "4,3,5,4,3" --chart --output radar.png
    python create_idea_score_chart.py --json idea.json
"""

import argparse
import json
import sys

# Evaluation items with weights and Korean R&D keyword mapping
ITEMS = [
    {"key": "market_size",  "label": "시장 크기",           "weight": 5, "rnd_keyword": "필요성(Necessity)"},
    {"key": "competition",  "label": "경쟁 강도",           "weight": 4, "rnd_keyword": ""},
    {"key": "founder_fit",  "label": "창업자-문제 적합성",   "weight": 5, "rnd_keyword": "팀 역량"},
    {"key": "resources",    "label": "자원 요건",           "weight": 3, "rnd_keyword": ""},
    {"key": "timing",       "label": "타이밍",              "weight": 3, "rnd_keyword": "성장성/확장성"},
]

# R&D composite mappings
RND_COMPOSITES = [
    {"keyword": "필요성(Necessity)",    "sources": ["market_size"],             "desc": "Problem + Market Context"},
    {"keyword": "차별화(Differentiation)", "sources": ["competition", "founder_fit"], "desc": "Solution + Existing Alternatives"},
]

VERDICT_RANGES = [
    (80, 100, "Go",          "즉시 심층 분석 진행"),
    (66,  79, "Pivot-최적화", "특정 항목 보완 후 재평가"),
    (48,  65, "Pivot-재검토", "근본적 재검토 필요"),
    (20,  47, "Drop",        "다른 아이디어 탐색"),
]

KILL_SWITCH_THRESHOLD = 3


def get_verdict(score):
    for low, high, label, desc in VERDICT_RANGES:
        if low <= score <= high:
            return label, desc
    return "Unknown", ""


def check_kill_switch(scores):
    warnings = []
    for item, score in zip(ITEMS, scores):
        if score < KILL_SWITCH_THRESHOLD:
            warnings.append(
                f"  {item['label']} = {score}점 (임계값 {KILL_SWITCH_THRESHOLD}점 미만)"
            )
    return warnings


def calc_total(scores):
    total = sum(s * item["weight"] for s, item in zip(scores, ITEMS))
    return total


def render_ascii(name, scores):
    """Render ASCII/Unicode bar chart — zero dependencies."""
    total = calc_total(scores)
    verdict, verdict_desc = get_verdict(total)
    kill_warnings = check_kill_switch(scores)

    bar_full = "\u2588"  # █
    bar_empty = "\u2591"  # ░
    max_bar = 10

    lines = []
    lines.append(f"\n{'='*60}")
    lines.append(f"  아이디어 평가 결과: {name}")
    lines.append(f"{'='*60}")
    lines.append("")
    lines.append(f"{'  평가 항목':<20} {'점수':>4}  {'':10}  {'가중':>4}  {'R&D 키워드'}")
    lines.append(f"  {'─'*56}")

    for item, score in zip(ITEMS, scores):
        filled = int(score / 5 * max_bar)
        bar = bar_full * filled + bar_empty * (max_bar - filled)
        weighted = score * item["weight"]
        rnd = item["rnd_keyword"]
        warn = " ⚠️" if score < KILL_SWITCH_THRESHOLD else ""
        lines.append(
            f"  {item['label']:<16} {score:>2}/5  {bar}  {weighted:>3}/{item['weight']*5}  {rnd}{warn}"
        )

    lines.append(f"  {'─'*56}")
    lines.append(f"  {'총점':<16} {total:>3}/100")
    lines.append(f"  {'판정':<16} {verdict} — {verdict_desc}")
    lines.append("")

    # R&D keyword composite scores
    lines.append("  [한국 R&D 평가 키워드 매핑]")
    score_map = {item["key"]: s for item, s in zip(ITEMS, scores)}
    for comp in RND_COMPOSITES:
        avg = sum(score_map[k] for k in comp["sources"]) / len(comp["sources"])
        lines.append(f"  · {comp['keyword']}: {avg:.1f}/5 ({comp['desc']})")
    lines.append("")

    # Kill Switch warnings
    if kill_warnings:
        lines.append("  ⚠️  Kill Switch 경고:")
        for w in kill_warnings:
            lines.append(w)
        lines.append("  → 총점과 무관하게 해당 항목의 보완이 권고됩니다.")
        lines.append("  → 진행하려면 CONTINUE를 입력하세요. (자동화: --force)")
        lines.append("")

    lines.append(f"{'='*60}")
    lines.append("  평가 버전: v2.0 | Kill Switch: 개별 항목 3점 미만 경고")
    lines.append(f"{'='*60}\n")

    return "\n".join(lines)


def render_radar(name, scores, output_path):
    """Render radar chart PNG via matplotlib — optional dependency."""
    try:
        import matplotlib
        matplotlib.use('Agg')
        import matplotlib.pyplot as plt
        import matplotlib.font_manager as fm
        import numpy as np
    except ImportError:
        print("⚠️  matplotlib 미설치 — 차트를 생략하고 텍스트 결과만 표시합니다.")
        print("    설치: pip install matplotlib numpy")
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

    labels = [item["label"] for item in ITEMS]
    N = len(labels)
    angles = np.linspace(0, 2 * np.pi, N, endpoint=False).tolist()
    angles += angles[:1]
    values = scores + scores[:1]

    fig, ax = plt.subplots(figsize=(8, 8), subplot_kw=dict(polar=True))
    ax.fill(angles, values, color='#4285F4', alpha=0.25)
    ax.plot(angles, values, 'o-', color='#4285F4', linewidth=2)

    ax.set_xticks(angles[:-1])
    ax.set_xticklabels(labels, fontsize=12)
    ax.set_ylim(0, 5)
    ax.set_yticks([1, 2, 3, 4, 5])
    ax.set_yticklabels(['1', '2', '3', '4', '5'], fontsize=9, color='gray')

    # Mark kill switch threshold
    threshold_values = [KILL_SWITCH_THRESHOLD] * (N + 1)
    ax.plot(angles, threshold_values, '--', color='#EA4335', linewidth=1, alpha=0.5, label='Kill Switch (3점)')
    ax.legend(loc='upper right', bbox_to_anchor=(1.15, 1.1))

    total = calc_total(scores)
    verdict, _ = get_verdict(total)
    ax.set_title(f"{name}\n총점: {total}/100 — {verdict}", fontsize=14, fontweight='bold', pad=20)

    plt.tight_layout()
    plt.savefig(output_path, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"✅ 레이더 차트 저장: {output_path}")
    return True


def load_from_json(json_path):
    """Load scores from idea.json file."""
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    details = data.get("score_details", {})
    name = data.get("full_name", data.get("name", "Unknown"))
    scores = [
        details.get("market_size", 3),
        details.get("competition", 3),
        details.get("founder_fit", details.get("fit", 3)),
        details.get("resources", 3),
        details.get("timing", 3),
    ]
    return name, scores


def main():
    parser = argparse.ArgumentParser(description="Idea Score Visualization (v2.0)")
    parser.add_argument("--name", help="Idea name")
    parser.add_argument("--scores", help="Comma-separated scores (5 items, 1-5 each)")
    parser.add_argument("--json", help="Load from idea.json file")
    parser.add_argument("--chart", action="store_true", help="Generate radar chart PNG (requires matplotlib)")
    parser.add_argument("--output", default="idea-radar.png", help="Radar chart output path")
    args = parser.parse_args()

    if args.json:
        name, scores = load_from_json(args.json)
    elif args.name and args.scores:
        name = args.name
        scores = [int(v.strip()) for v in args.scores.split(",")]
    else:
        parser.print_help()
        sys.exit(1)

    if len(scores) != 5:
        print(f"Error: 5개 항목 점수가 필요합니다 (입력: {len(scores)}개)")
        sys.exit(1)

    # Always print ASCII chart
    print(render_ascii(name, scores))

    # Optionally generate radar chart
    if args.chart:
        render_radar(name, scores, args.output)


if __name__ == "__main__":
    main()
