#!/usr/bin/env python3
"""
Business Data Chart Generator

Usage:
    python create_chart.py --help
    python create_chart.py bar --title "월별 매출" --labels "1월,2월,3월" --values "1000,1500,2000" --output chart.png
    python create_chart.py pie --title "비용 구조" --labels "인건비,재료비,임대료,기타" --values "40,30,20,10" --output costs.png
    python create_chart.py line --title "매출 추이" --labels "1월,2월,3월,4월" --values "1000,1200,1800,2500" --output trend.png
"""

import argparse
import sys

try:
    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt
    import matplotlib.font_manager as fm
except ImportError:
    print("Error: matplotlib is required. Install with: pip install matplotlib")
    sys.exit(1)


# Configure Korean font support
def setup_korean_font():
    """Try to set up Korean font"""
    korean_fonts = ['AppleGothic', 'NanumGothic', 'Malgun Gothic', 'NanumBarunGothic']
    for font_name in korean_fonts:
        try:
            fm.findfont(font_name, fallback_to_default=False)
            plt.rcParams['font.family'] = font_name
            plt.rcParams['axes.unicode_minus'] = False
            return
        except Exception as e:
            import warnings
            warnings.warn(f"Font setup failed: {e}")
            continue
    print("Warning: Korean font not found. Text may not display correctly.")


def create_bar_chart(title, labels, values, output, ylabel="금액 (만원)"):
    setup_korean_font()
    fig, ax = plt.subplots(figsize=(10, 6))
    colors = ['#4285F4', '#EA4335', '#FBBC05', '#34A853', '#FF6D01', '#46BDC6']
    bars = ax.bar(labels, values, color=colors[:len(labels)])
    ax.set_title(title, fontsize=16, fontweight='bold', pad=20)
    ax.set_ylabel(ylabel)
    for bar, val in zip(bars, values):
        ax.text(bar.get_x() + bar.get_width()/2., bar.get_height(),
                f'{val:,.0f}', ha='center', va='bottom', fontweight='bold')
    plt.tight_layout()
    plt.savefig(output, dpi=150, bbox_inches='tight')
    print(f"Chart saved: {output}")


def create_pie_chart(title, labels, values, output):
    setup_korean_font()
    fig, ax = plt.subplots(figsize=(8, 8))
    colors = ['#4285F4', '#EA4335', '#FBBC05', '#34A853', '#FF6D01', '#46BDC6']
    ax.pie(values, labels=labels, autopct='%1.1f%%', startangle=90,
           colors=colors[:len(labels)], textprops={'fontsize': 12})
    ax.set_title(title, fontsize=16, fontweight='bold', pad=20)
    plt.tight_layout()
    plt.savefig(output, dpi=150, bbox_inches='tight')
    print(f"Chart saved: {output}")


def create_line_chart(title, labels, values, output, ylabel="금액 (만원)"):
    setup_korean_font()
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.plot(labels, values, 'o-', color='#4285F4', linewidth=2, markersize=8)
    ax.fill_between(range(len(labels)), values, alpha=0.1, color='#4285F4')
    ax.set_title(title, fontsize=16, fontweight='bold', pad=20)
    ax.set_ylabel(ylabel)
    ax.grid(True, alpha=0.3)
    for i, val in enumerate(values):
        ax.annotate(f'{val:,.0f}', (i, val), textcoords="offset points",
                    xytext=(0, 10), ha='center', fontweight='bold')
    plt.tight_layout()
    plt.savefig(output, dpi=150, bbox_inches='tight')
    print(f"Chart saved: {output}")


def main():
    parser = argparse.ArgumentParser(description="Business Data Chart Generator")
    subparsers = parser.add_subparsers(dest="chart_type", help="Chart type")

    for chart_type in ["bar", "pie", "line"]:
        sub = subparsers.add_parser(chart_type, help=f"{chart_type} chart")
        sub.add_argument("--title", required=True, help="Chart title")
        sub.add_argument("--labels", required=True, help="Comma-separated labels")
        sub.add_argument("--values", required=True, help="Comma-separated values")
        sub.add_argument("--output", required=True, help="Output file path")
        if chart_type != "pie":
            sub.add_argument("--ylabel", default="금액 (만원)", help="Y-axis label")

    args = parser.parse_args()
    if not args.chart_type:
        parser.print_help()
        sys.exit(0)

    labels = [l.strip() for l in args.labels.split(",")]
    values = [float(v.strip()) for v in args.values.split(",")]

    if args.chart_type == "bar":
        create_bar_chart(args.title, labels, values, args.output, getattr(args, 'ylabel', '금액 (만원)'))
    elif args.chart_type == "pie":
        create_pie_chart(args.title, labels, values, args.output)
    elif args.chart_type == "line":
        create_line_chart(args.title, labels, values, args.output, getattr(args, 'ylabel', '금액 (만원)'))


if __name__ == "__main__":
    main()
