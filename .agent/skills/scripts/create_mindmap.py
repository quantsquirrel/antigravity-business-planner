#!/usr/bin/env python3
"""Idea Mindmap HTML Generator

output/ideas/*/idea.json 파일들을 읽어 아이디어 간 관계를 시각화하는
인터랙티브 HTML 마인드맵을 생성합니다.

Usage:
    python create_mindmap.py --dir output/ideas/
    python create_mindmap.py --dir output/ideas/ --output mindmap.html
    python create_mindmap.py --dir output/ideas/ --ascii  (텍스트 출력)
"""

import argparse
import json
import math
import sys
from datetime import datetime
from pathlib import Path


# -- Data Loading ----------------------------------------------------------

def load_ideas(ideas_dir):
    """output/ideas/*/idea.json 파일들을 로드하여 리스트로 반환합니다."""
    ideas_dir = Path(ideas_dir)
    if not ideas_dir.exists():
        return []

    ideas = []
    for child in sorted(ideas_dir.iterdir()):
        if child.is_dir():
            idea_file = child / "idea.json"
            if idea_file.exists():
                try:
                    with open(idea_file, "r", encoding="utf-8") as f:
                        data = json.load(f)
                    data["dir_path"] = str(child)
                    ideas.append(data)
                except (json.JSONDecodeError, OSError):
                    continue
    return ideas


# -- Keyword Extraction & Relationship Building ----------------------------

def extract_keywords(idea):
    """psst_mapping에서 problem/solution 키워드를 추출합니다."""
    psst = idea.get("psst_mapping", {})
    keywords = set()

    for field in ("problem", "solution"):
        text = psst.get(field, "")
        if text:
            # 공백 기준으로 토큰화, 1글자 이하 제거
            tokens = [t.strip(".,;:!?()[]{}\"'") for t in text.split()]
            keywords.update(t for t in tokens if len(t) > 1)

    return keywords


def build_relationships(ideas):
    """아이디어 간 공유 키워드를 기반으로 관계를 도출합니다.

    Returns:
        idea_keywords: dict[idea_id, set[str]] - 아이디어별 키워드
        edges: list[tuple[idea_id, idea_id, set[str]]] - 공유 키워드가 있는 쌍
    """
    idea_keywords = {}
    for idea in ideas:
        idea_id = idea.get("id", idea.get("name", "unknown"))
        idea_keywords[idea_id] = extract_keywords(idea)

    edges = []
    ids = list(idea_keywords.keys())
    for i in range(len(ids)):
        for j in range(i + 1, len(ids)):
            shared = idea_keywords[ids[i]] & idea_keywords[ids[j]]
            if shared:
                edges.append((ids[i], ids[j], shared))

    return idea_keywords, edges


# -- Status Helpers --------------------------------------------------------

def _status_color_svg(status):
    """SVG용 상태별 색상을 반환합니다."""
    mapping = {
        "go": "#43e97b",
        "pivot": "#f7971e",
        "pivot-optimize": "#f7971e",
        "pivot-review": "#f7971e",
        "drop": "#ff6b9d",
    }
    return mapping.get(status, "#667eea")


def _status_emoji(status):
    """ASCII 출력용 상태 이모지를 반환합니다."""
    mapping = {
        "go": "\U0001f7e2",
        "pivot": "\U0001f7e1",
        "pivot-optimize": "\U0001f7e1",
        "pivot-review": "\U0001f7e1",
        "drop": "\U0001f534",
    }
    return mapping.get(status, "\u26aa")


def _status_label(status):
    """상태 라벨을 반환합니다."""
    mapping = {
        "go": "Go",
        "pivot": "Pivot",
        "pivot-optimize": "Pivot",
        "pivot-review": "Pivot",
        "drop": "Drop",
    }
    return mapping.get(status, status or "N/A")


# -- ASCII Mindmap ---------------------------------------------------------

def generate_ascii(ideas, idea_keywords, edges):
    """텍스트 기반 마인드맵을 생성합니다."""
    lines = []
    lines.append("")
    lines.append("\u2554" + "\u2550" * 30 + "\u2557")
    lines.append("\u2551     \U0001f4a1 \uc0ac\uc5c5 \uc544\uc774\ub514\uc5b4 \ub9c8\uc778\ub4dc\ub9f5     \u2551")
    lines.append("\u255a" + "\u2550" * 30 + "\u255d")
    lines.append("")

    if not ideas:
        lines.append("(\uc544\uc774\ub514\uc5b4\uac00 \uc5c6\uc2b5\ub2c8\ub2e4)")
        return "\n".join(lines)

    # 공유 키워드로 연결 관계 인덱스 구축
    # idea_id -> list of (other_id, shared_keywords)
    connections = {}
    for id_a, id_b, shared in edges:
        connections.setdefault(id_a, []).append((id_b, shared))
        connections.setdefault(id_b, []).append((id_a, shared))

    lines.append("[\uc0ac\uc5c5 \uc544\uc774\ub514\uc5b4]")

    for idx, idea in enumerate(ideas):
        idea_id = idea.get("id", idea.get("name", "unknown"))
        full_name = idea.get("full_name", idea.get("name", ""))
        status = idea.get("status", "")
        score = idea.get("score", 0) or 0
        emoji = _status_emoji(status)
        label = _status_label(status)
        psst = idea.get("psst_mapping", {})

        is_last_idea = idx == len(ideas) - 1
        branch = "\u2514\u2500\u2500" if is_last_idea else "\u251c\u2500\u2500"
        prefix = "    " if is_last_idea else "\u2502   "

        lines.append(f"{branch} {emoji} {full_name} ({score}\uc810, {label})")

        # problem/solution 표시
        problem = psst.get("problem", "")
        solution = psst.get("solution", "")
        if problem:
            lines.append(f"{prefix}\u251c\u2500\u2500 \ubb38\uc81c: {problem}")
        if solution:
            has_connections = idea_id in connections
            sol_branch = "\u251c\u2500\u2500" if has_connections else "\u2514\u2500\u2500"
            lines.append(f"{prefix}{sol_branch} \uc194\ub8e8\uc158: {solution}")

        # 연결 관계 표시
        if idea_id in connections:
            conns = connections[idea_id]
            for c_idx, (other_id, shared) in enumerate(conns):
                # other_id에 해당하는 이름 찾기
                other_name = other_id
                for other_idea in ideas:
                    if other_idea.get("id") == other_id or other_idea.get("name") == other_id:
                        other_name = other_idea.get("full_name", other_idea.get("name", other_id))
                        break
                shared_str = ", ".join(sorted(list(shared)[:3]))
                is_last_conn = c_idx == len(conns) - 1
                conn_branch = "\u2514\u2500\u2500" if is_last_conn else "\u251c\u2500\u2500"
                lines.append(f"{prefix}{conn_branch} \U0001f517 \"{shared_str}\" \u2190 {other_name}")

    lines.append("")
    return "\n".join(lines)


# -- SVG/HTML Mindmap ------------------------------------------------------

def generate_html(ideas, idea_keywords, edges):
    """인터랙티브 SVG 기반 HTML 마인드맵을 생성합니다."""
    generated_at = datetime.now().strftime("%Y-%m-%d %H:%M")

    if not ideas:
        empty_html = f"""<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아이디어 마인드맵 | Antigravity Business Planner</title>
</head>
<body style="background:#0a0e27;color:#e8edf5;font-family:sans-serif;text-align:center;padding:80px;">
    <h2>아직 아이디어가 없습니다</h2>
    <p style="color:#8892b0;">아이디어를 먼저 생성해주세요.</p>
    <p style="color:#5a6785;font-size:0.8rem;">Generated {generated_at}</p>
</body>
</html>"""
        return empty_html

    # SVG 레이아웃 계산
    # 중심 노드 + 아이디어 노드를 원형으로 배치
    cx, cy = 600, 400  # 중심 좌표
    radius = 250  # 아이디어 노드 배치 반경
    svg_w, svg_h = 1200, 800

    # 아이디어 노드 위치 계산 (원형 배치)
    node_positions = {}  # idea_id -> (x, y)
    n = len(ideas)
    for i, idea in enumerate(ideas):
        idea_id = idea.get("id", idea.get("name", f"idea-{i}"))
        angle = (2 * math.pi * i / n) - math.pi / 2  # 12시 방향부터 시작
        x = cx + radius * math.cos(angle)
        y = cy + radius * math.sin(angle)
        node_positions[idea_id] = (x, y)

    # 키워드 노드 위치 계산 (공유 키워드만, 관련 아이디어들 중간 지점)
    keyword_nodes = {}  # keyword -> (x, y)
    keyword_radius = 160
    shared_keywords_all = set()
    for _, _, shared in edges:
        shared_keywords_all.update(list(shared)[:2])  # 쌍당 최대 2개

    kw_list = sorted(shared_keywords_all)
    for ki, kw in enumerate(kw_list):
        # 관련 아이디어 위치의 평균 + 약간 안쪽
        related_positions = []
        for id_a, id_b, shared in edges:
            if kw in shared:
                if id_a in node_positions:
                    related_positions.append(node_positions[id_a])
                if id_b in node_positions:
                    related_positions.append(node_positions[id_b])
        if related_positions:
            avg_x = sum(p[0] for p in related_positions) / len(related_positions)
            avg_y = sum(p[1] for p in related_positions) / len(related_positions)
            # 중심 방향으로 약간 이동
            dx, dy = avg_x - cx, avg_y - cy
            dist = math.sqrt(dx * dx + dy * dy) or 1
            factor = keyword_radius / dist
            kx = cx + dx * factor
            ky = cy + dy * factor
        else:
            angle = (2 * math.pi * ki / max(len(kw_list), 1))
            kx = cx + keyword_radius * math.cos(angle)
            ky = cy + keyword_radius * math.sin(angle)
        keyword_nodes[kw] = (kx, ky)

    # SVG 요소 생성
    svg_elements = []

    # 배경 그래디언트
    svg_elements.append("""
    <defs>
        <radialGradient id="bgGrad" cx="50%" cy="50%" r="60%">
            <stop offset="0%" style="stop-color:#131a3a;stop-opacity:1"/>
            <stop offset="100%" style="stop-color:#0a0e27;stop-opacity:1"/>
        </radialGradient>
        <filter id="glow">
            <feGaussianBlur stdDeviation="3" result="coloredBlur"/>
            <feMerge><feMergeNode in="coloredBlur"/><feMergeNode in="SourceGraphic"/></feMerge>
        </filter>
        <filter id="softglow">
            <feGaussianBlur stdDeviation="1.5" result="coloredBlur"/>
            <feMerge><feMergeNode in="coloredBlur"/><feMergeNode in="SourceGraphic"/></feMerge>
        </filter>
    </defs>
    <rect width="100%" height="100%" fill="url(#bgGrad)"/>""")

    # 연결선: 중심 -> 아이디어
    for idea_id, (x, y) in node_positions.items():
        svg_elements.append(
            f'    <line x1="{cx}" y1="{cy}" x2="{x}" y2="{y}" '
            f'stroke="rgba(102,126,234,0.3)" stroke-width="1.5" stroke-dasharray="6,4"/>'
        )

    # 연결선: 아이디어 -> 키워드 (공유 관계)
    for id_a, id_b, shared in edges:
        if id_a in node_positions and id_b in node_positions:
            ax, ay = node_positions[id_a]
            bx, by = node_positions[id_b]
            for kw in list(shared)[:2]:
                if kw in keyword_nodes:
                    kx, ky = keyword_nodes[kw]
                    svg_elements.append(
                        f'    <line x1="{ax}" y1="{ay}" x2="{kx}" y2="{ky}" '
                        f'stroke="rgba(0,210,255,0.2)" stroke-width="1"/>'
                    )
                    svg_elements.append(
                        f'    <line x1="{bx}" y1="{by}" x2="{kx}" y2="{ky}" '
                        f'stroke="rgba(0,210,255,0.2)" stroke-width="1"/>'
                    )

    # 키워드 노드 (작은 원 + 텍스트)
    for kw, (kx, ky) in keyword_nodes.items():
        svg_elements.append(
            f'    <circle cx="{kx}" cy="{ky}" r="22" '
            f'fill="rgba(15,20,40,0.7)" stroke="rgba(0,210,255,0.4)" stroke-width="1" filter="url(#softglow)"/>'
        )
        # 긴 키워드 truncate
        display_kw = kw[:6] + ".." if len(kw) > 8 else kw
        svg_elements.append(
            f'    <text x="{kx}" y="{ky + 4}" text-anchor="middle" '
            f'fill="#8892b0" font-size="10" font-family="Pretendard,sans-serif">{display_kw}</text>'
        )

    # 중심 노드
    svg_elements.append(
        f'    <circle cx="{cx}" cy="{cy}" r="45" '
        f'fill="rgba(15,20,40,0.85)" stroke="url(#centerGradStroke)" stroke-width="2" filter="url(#glow)"/>'
    )
    # 중심 그래디언트 stroke 대체 (단색 fallback)
    svg_elements.append(
        f'    <circle cx="{cx}" cy="{cy}" r="45" '
        f'fill="rgba(15,20,40,0.85)" stroke="#667eea" stroke-width="2" filter="url(#glow)"/>'
    )
    svg_elements.append(
        f'    <text x="{cx}" y="{cy - 6}" text-anchor="middle" '
        f'fill="#ffd700" font-size="14" font-weight="600" font-family="Outfit,sans-serif">사업</text>'
    )
    svg_elements.append(
        f'    <text x="{cx}" y="{cy + 12}" text-anchor="middle" '
        f'fill="#ffd700" font-size="14" font-weight="600" font-family="Outfit,sans-serif">아이디어</text>'
    )

    # 아이디어 노드
    for idea in ideas:
        idea_id = idea.get("id", idea.get("name", "unknown"))
        full_name = idea.get("full_name", idea.get("name", ""))
        status = idea.get("status", "")
        score = idea.get("score", 0) or 0
        color = _status_color_svg(status)
        label = _status_label(status)

        if idea_id not in node_positions:
            continue
        x, y = node_positions[idea_id]

        # 점수에 따라 노드 크기 변화 (30~50)
        node_r = 30 + (score / 100) * 20

        svg_elements.append(
            f'    <circle cx="{x}" cy="{y}" r="{node_r}" '
            f'fill="rgba(15,20,40,0.8)" stroke="{color}" stroke-width="2" '
            f'filter="url(#glow)" class="idea-node" data-id="{idea_id}"/>'
        )

        # 이름 (truncate)
        display_name = full_name[:8] + ".." if len(full_name) > 10 else full_name
        svg_elements.append(
            f'    <text x="{x}" y="{y - 4}" text-anchor="middle" '
            f'fill="#e8edf5" font-size="11" font-weight="600" font-family="Pretendard,sans-serif">'
            f'{display_name}</text>'
        )
        svg_elements.append(
            f'    <text x="{x}" y="{y + 12}" text-anchor="middle" '
            f'fill="{color}" font-size="10" font-family="Pretendard,sans-serif">'
            f'{score}점 {label}</text>'
        )

    svg_content = "\n".join(svg_elements)

    # 사이드 패널: 아이디어 목록
    panel_items = ""
    for idea in ideas:
        full_name = idea.get("full_name", idea.get("name", ""))
        status = idea.get("status", "")
        score = idea.get("score", 0) or 0
        color = _status_color_svg(status)
        label = _status_label(status)
        psst = idea.get("psst_mapping", {})
        problem = psst.get("problem", "-")
        solution = psst.get("solution", "-")
        panel_items += f"""
                <div class="panel-item" style="border-left:3px solid {color};">
                    <div class="panel-name">{full_name}</div>
                    <div class="panel-score" style="color:{color};">{score}점 · {label}</div>
                    <div class="panel-detail">문제: {problem}</div>
                    <div class="panel-detail">솔루션: {solution}</div>
                </div>"""

    html = f"""<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디어 마인드맵 | Antigravity Business Planner</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css">
    <style>
        :root {{
            --bg-deep: #0a0e27;
            --bg-card: rgba(15, 20, 40, 0.8);
            --text-primary: #e8edf5;
            --text-secondary: #8892b0;
            --text-muted: #5a6785;
            --border-glass: rgba(255, 255, 255, 0.08);
            --accent-gold: #ffd700;
        }}
        *, *::before, *::after {{ box-sizing: border-box; margin: 0; padding: 0; }}
        body {{
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg-deep);
            color: var(--text-primary);
            height: 100dvh;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }}
        .header {{
            text-align: center;
            padding: 12px 0 8px;
            border-bottom: 1px solid var(--border-glass);
        }}
        .header h1 {{
            font-family: 'Outfit', sans-serif;
            font-size: 1.3rem;
            font-weight: 600;
            background: linear-gradient(135deg, #667eea, #00d2ff, #43e97b, #f7971e);
            background-size: 200% auto;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }}
        .header p {{
            font-size: 0.78rem;
            color: var(--text-secondary);
            margin-top: 2px;
        }}
        .main {{
            flex: 1;
            display: flex;
            min-height: 0;
        }}
        .svg-container {{
            flex: 1;
            min-width: 0;
            overflow: hidden;
        }}
        .svg-container svg {{
            width: 100%;
            height: 100%;
        }}
        .idea-node {{
            cursor: pointer;
            transition: opacity 0.2s;
        }}
        .idea-node:hover {{
            opacity: 0.8;
        }}
        .side-panel {{
            width: 280px;
            flex-shrink: 0;
            background: var(--bg-card);
            border-left: 1px solid var(--border-glass);
            overflow-y: auto;
            padding: 12px;
        }}
        .side-panel h2 {{
            font-family: 'Outfit', sans-serif;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 10px;
        }}
        .panel-item {{
            padding: 8px 10px;
            margin-bottom: 8px;
            background: rgba(15, 20, 40, 0.5);
            border-radius: 8px;
        }}
        .panel-name {{
            font-weight: 600;
            font-size: 0.85rem;
            margin-bottom: 2px;
        }}
        .panel-score {{
            font-size: 0.78rem;
            font-weight: 500;
            margin-bottom: 4px;
        }}
        .panel-detail {{
            font-size: 0.72rem;
            color: var(--text-muted);
            line-height: 1.4;
        }}
        .footer {{
            text-align: center;
            padding: 6px 0;
            border-top: 1px solid var(--border-glass);
            font-size: 0.68rem;
            color: var(--text-muted);
        }}
        .legend {{
            display: flex;
            gap: 14px;
            justify-content: center;
            padding: 6px 0;
            font-size: 0.72rem;
            color: var(--text-secondary);
        }}
        .legend-dot {{
            display: inline-block;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            margin-right: 4px;
            vertical-align: middle;
        }}
        @media (max-width: 768px) {{
            .side-panel {{ display: none; }}
        }}
    </style>
</head>
<body>
    <div class="header">
        <h1>아이디어 마인드맵</h1>
        <p>아이디어 간 관계를 시각적으로 탐색하세요</p>
        <div class="legend">
            <span><span class="legend-dot" style="background:#43e97b;"></span>Go</span>
            <span><span class="legend-dot" style="background:#f7971e;"></span>Pivot</span>
            <span><span class="legend-dot" style="background:#ff6b9d;"></span>Drop</span>
            <span><span class="legend-dot" style="background:#00d2ff;"></span>공유 키워드</span>
        </div>
    </div>
    <div class="main">
        <div class="svg-container">
            <svg viewBox="0 0 {svg_w} {svg_h}" xmlns="http://www.w3.org/2000/svg">
{svg_content}
            </svg>
        </div>
        <div class="side-panel">
            <h2>아이디어 목록</h2>
{panel_items}
        </div>
    </div>
    <div class="footer">
        Antigravity Business Planner &mdash; Mindmap Generated {generated_at}
    </div>
</body>
</html>"""
    return html


# -- Main ------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="Idea Mindmap HTML Generator - 아이디어 간 관계를 시각화하는 마인드맵을 생성합니다."
    )
    parser.add_argument(
        "--dir",
        required=True,
        help="아이디어 디렉토리 경로 (예: output/ideas/)",
    )
    parser.add_argument(
        "--output",
        default=None,
        help="출력 HTML 파일 경로 (기본: {dir}/mindmap.html)",
    )
    parser.add_argument(
        "--ascii",
        action="store_true",
        help="HTML 대신 텍스트 기반 마인드맵을 stdout에 출력합니다",
    )
    args = parser.parse_args()

    ideas_dir = Path(args.dir)
    ideas = load_ideas(ideas_dir)
    idea_keywords, edges = build_relationships(ideas)

    if args.ascii:
        # ASCII 모드: stdout에 텍스트 마인드맵 출력
        print(generate_ascii(ideas, idea_keywords, edges))
        sys.exit(0)

    # HTML 모드
    output_path = Path(args.output) if args.output else ideas_dir / "mindmap.html"
    html = generate_html(ideas, idea_keywords, edges)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(html, encoding="utf-8")
    print(str(output_path))
    sys.exit(0)


if __name__ == "__main__":
    main()
