#!/usr/bin/env python3
"""Outputs Dashboard HTML Generator

Scans the entire output/ directory and generates a unified HTML dashboard
at output/dashboard.html showing all deliverables, progress stages, and
category breakdowns.

Usage:
    python create_outputs_dashboard.py [--output-dir OUTPUT_DIR] [--idea IDEA_ID]

Requires Python 3.8+ standard library only (json, os, pathlib, datetime).
"""

import argparse
import json
import os
import sys
from datetime import datetime
from pathlib import Path

STAGES = [
    {"id": 0, "name": "아이디어 발굴", "icon": "&#128161;"},
    {"id": 1, "name": "시장 조사", "icon": "&#128202;"},
    {"id": 2, "name": "경쟁 분석", "icon": "&#128269;"},
    {"id": 3, "name": "제품/원가", "icon": "&#127991;"},
    {"id": 4, "name": "재무 모델", "icon": "&#128176;"},
    {"id": 5, "name": "운영 계획", "icon": "&#9881;"},
    {"id": 6, "name": "브랜딩", "icon": "&#127912;"},
    {"id": 7, "name": "법률/인허가", "icon": "&#9878;"},
    {"id": 8, "name": "사업계획서", "icon": "&#128203;"},
]

TOTAL_STAGES = len(STAGES)  # 9 (0-8)

CATEGORY_META = {
    "ideas": {
        "label": "아이디어",
        "icon": "&#128161;",
        "empty_cmd": "/idea-discovery",
        "empty_msg": "아이디어를 발굴해보세요",
    },
    "research": {
        "label": "시장조사",
        "icon": "&#128202;",
        "empty_cmd": "/market-research",
        "empty_msg": "시장조사를 시작해보세요",
    },
    "financials": {
        "label": "재무분석",
        "icon": "&#128176;",
        "empty_cmd": "/financial-modeling",
        "empty_msg": "재무 모델링을 시작해보세요",
    },
    "reports": {
        "label": "보고서",
        "icon": "&#128203;",
        "empty_cmd": "/business-plan-draft",
        "empty_msg": "사업계획서를 작성해보세요",
    },
    "presentations": {
        "label": "발표자료",
        "icon": "&#127916;",
        "empty_cmd": "/export-documents",
        "empty_msg": "발표자료를 준비해보세요",
    },
}

IGNORED_FILES = {".gitkeep", ".DS_Store", "dashboard.html"}


def find_project_root():
    """Find the project root by traversing up from this script's location.

    Path: scripts/ -> skills/ -> .agent/ -> project root
    """
    script_path = Path(__file__).resolve()
    return script_path.parent.parent.parent.parent


def format_file_size(size_bytes):
    """Format file size in human-readable form."""
    if size_bytes >= 1_048_576:
        return f"{size_bytes / 1_048_576:.1f} MB"
    return f"{size_bytes / 1024:.1f} KB"


def format_mtime(mtime):
    """Format modification time as YYYY-MM-DD HH:MM."""
    return datetime.fromtimestamp(mtime).strftime("%Y-%m-%d %H:%M")


def is_real_file(path):
    """Check if a file is a real deliverable (not .gitkeep, .DS_Store, etc)."""
    return path.is_file() and path.name not in IGNORED_FILES


def scan_directory(dir_path):
    """Scan a directory and return list of file info dicts."""
    dir_path = Path(dir_path)
    if not dir_path.exists():
        return []

    files = []
    for f in sorted(dir_path.rglob("*")):
        if is_real_file(f):
            stat = f.stat()
            files.append({
                "name": f.name,
                "path": str(f),
                "relative": str(f.relative_to(dir_path)),
                "size": stat.st_size,
                "mtime": stat.st_mtime,
                "suffix": f.suffix.lower(),
            })
    return files


def load_ideas(ideas_dir):
    """Scan output/ideas/*/idea.json and return list of idea dicts."""
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
                    data["dir_name"] = child.name
                    # Count real files in the idea directory
                    file_count = sum(
                        1 for fp in child.rglob("*") if is_real_file(fp)
                    )
                    data["file_count"] = file_count
                    ideas.append(data)
                except (json.JSONDecodeError, OSError):
                    continue
    return ideas


def check_global_stage_completion(output_dir):
    """Check which stages (0-8) are complete at the global output/ level.

    Uses the same logic as check_progress.py's ProgressTracker.
    """
    output_dir = Path(output_dir)
    completed = [False] * TOTAL_STAGES

    # Stage 0: output/ideas/ has files
    ideas_dir = output_dir / "ideas"
    if ideas_dir.exists():
        for child in ideas_dir.iterdir():
            if child.is_dir():
                idea_file = child / "idea.json"
                if idea_file.exists():
                    completed[0] = True
                    break

    # Stage 1: output/research/ has market-related files
    research_dir = output_dir / "research"
    if research_dir.exists():
        for f in research_dir.rglob("*"):
            if is_real_file(f):
                fname = f.name.lower()
                if "시장" in fname or "market" in fname or "tam" in fname:
                    completed[1] = True
                    break
        # Also check inside ideas
        if not completed[1] and ideas_dir.exists():
            for child in ideas_dir.iterdir():
                if child.is_dir():
                    r_dir = child / "research"
                    if r_dir.exists():
                        for f in r_dir.rglob("*"):
                            if is_real_file(f):
                                fname = f.name.lower()
                                if "시장" in fname or "market" in fname:
                                    completed[1] = True
                                    break
                    if completed[1]:
                        break

    # Stage 2: output/research/ has competition-related files
    if research_dir.exists():
        for f in research_dir.rglob("*"):
            if is_real_file(f):
                fname = f.name.lower()
                if "경쟁" in fname or "competitor" in fname:
                    completed[2] = True
                    break
        if not completed[2] and ideas_dir.exists():
            for child in ideas_dir.iterdir():
                if child.is_dir():
                    r_dir = child / "research"
                    if r_dir.exists():
                        for f in r_dir.rglob("*"):
                            if is_real_file(f):
                                fname = f.name.lower()
                                if "경쟁" in fname or "competitor" in fname:
                                    completed[2] = True
                                    break
                    if completed[2]:
                        break

    # Stage 3: output/financials/ has cost-related files
    financials_dir = output_dir / "financials"
    if financials_dir.exists():
        for f in financials_dir.rglob("*"):
            if is_real_file(f):
                fname = f.name.lower()
                if "원가" in fname or "cost" in fname or "menu" in fname:
                    completed[3] = True
                    break
    if not completed[3] and ideas_dir.exists():
        for child in ideas_dir.iterdir():
            if child.is_dir():
                f_dir = child / "financials"
                if f_dir.exists():
                    for f in f_dir.rglob("*"):
                        if is_real_file(f):
                            fname = f.name.lower()
                            if "원가" in fname or "cost" in fname or "menu" in fname:
                                completed[3] = True
                                break
                if completed[3]:
                    break

    # Stage 4: output/financials/ has financial model files
    if financials_dir.exists():
        for f in financials_dir.rglob("*"):
            if is_real_file(f):
                fname = f.name.lower()
                if "재무" in fname or "financial" in fname or "projection" in fname:
                    completed[4] = True
                    break

    # Stages 5-8: output/reports/ keyword matching
    reports_dir = output_dir / "reports"
    if reports_dir.exists():
        for f in reports_dir.rglob("*"):
            if is_real_file(f):
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


def _status_label(status):
    """Return Korean label for status."""
    mapping = {"go": "Go", "pivot": "Pivot", "drop": "Drop"}
    return mapping.get(status, status or "미평가")


def _status_class(status):
    """Return CSS class name for status badge."""
    if status == "go":
        return "badge-go"
    elif status == "pivot":
        return "badge-pivot"
    elif status == "drop":
        return "badge-drop"
    return "badge-default"


def _build_idea_card(idea):
    """Build HTML for a single idea card in the ideas category."""
    full_name = idea.get("full_name", idea.get("name", ""))
    status = idea.get("status", "")
    raw_score = idea.get("score", 0) or 0
    score = raw_score * 4 if raw_score <= 25 else raw_score
    file_count = idea.get("file_count", 0)
    badge_class = _status_class(status)
    badge_label = _status_label(status)

    # List sub-files
    dir_path = Path(idea.get("dir_path", ""))
    sub_files = []
    if dir_path.exists():
        for f in sorted(dir_path.rglob("*")):
            if is_real_file(f) and f.name != "idea.json":
                sub_files.append(f.relative_to(dir_path))

    sub_files_html = ""
    for sf in sub_files:
        sub_files_html += f'<li class="sub-file">{sf}</li>'

    if sub_files_html:
        sub_files_html = f'<ul class="sub-file-list">{sub_files_html}</ul>'
    else:
        sub_files_html = '<p class="empty-hint">아직 하위 파일이 없습니다</p>'

    return f"""
                    <div class="file-card idea-card">
                        <div class="file-card-header">
                            <h4>{full_name}</h4>
                            <span class="badge {badge_class}">{badge_label}</span>
                        </div>
                        <div class="idea-meta-row">
                            <span class="idea-score">{score}<span class="score-unit">/100</span></span>
                            <span class="idea-files">{file_count} files</span>
                        </div>
                        {sub_files_html}
                    </div>"""


def _build_file_card(file_info, output_dir):
    """Build HTML for a single file card."""
    name = file_info["name"]
    size = format_file_size(file_info["size"])
    mtime = format_mtime(file_info["mtime"])
    suffix = file_info["suffix"]

    link_html = ""
    if suffix == ".html":
        rel_path = file_info["relative"]
        link_html = f'<a class="open-link" href="{rel_path}" target="_blank">&#x1f517; 브라우저에서 열기</a>'

    return f"""
                    <div class="file-card">
                        <div class="file-card-header">
                            <h4 class="file-name">{name}</h4>
                        </div>
                        <div class="file-meta">
                            <span>{mtime}</span>
                            <span>{size}</span>
                        </div>
                        {link_html}
                    </div>"""


def _build_empty_category(meta):
    """Build HTML for an empty category placeholder."""
    return f"""
                    <div class="empty-category">
                        <p>아직 산출물이 없습니다</p>
                        <p class="empty-cmd"><code>{meta['empty_cmd']}</code> 로 {meta['empty_msg']}</p>
                    </div>"""


def generate_html(output_dir, idea_filter=None):
    """Generate the unified outputs dashboard HTML."""
    output_dir = Path(output_dir)
    generated_at = datetime.now().strftime("%Y-%m-%d %H:%M")

    # Scan all categories
    ideas = load_ideas(output_dir / "ideas")
    research_files = scan_directory(output_dir / "research")
    financials_files = scan_directory(output_dir / "financials")
    reports_files = scan_directory(output_dir / "reports")
    presentations_files = scan_directory(output_dir / "presentations")

    # If idea filter is set, only show that idea
    if idea_filter and ideas:
        ideas = [i for i in ideas if i.get("dir_name", "") == idea_filter]

    # Compute global stats
    total_files = (
        sum(i.get("file_count", 0) for i in ideas)
        + len(research_files)
        + len(financials_files)
        + len(reports_files)
        + len(presentations_files)
    )

    stages_completed = check_global_stage_completion(output_dir)
    completed_count = sum(stages_completed)

    # Find most recently modified file
    all_files = research_files + financials_files + reports_files + presentations_files
    # Add idea files
    for idea in ideas:
        idea_dir = Path(idea.get("dir_path", ""))
        if idea_dir.exists():
            for f in idea_dir.rglob("*"):
                if is_real_file(f):
                    stat = f.stat()
                    all_files.append({
                        "name": f.name,
                        "mtime": stat.st_mtime,
                    })

    if all_files:
        most_recent = max(all_files, key=lambda x: x["mtime"])
        recent_name = most_recent["name"]
    else:
        recent_name = "-"

    categories_with_files = 0
    if ideas:
        categories_with_files += 1
    if research_files:
        categories_with_files += 1
    if financials_files:
        categories_with_files += 1
    if reports_files:
        categories_with_files += 1
    if presentations_files:
        categories_with_files += 1

    # --- Build HTML sections ---

    # A. Hero section
    hero_html = f"""
        <header class="hero">
            <h1>내 사업 기획 현황</h1>
            <p class="hero-sub">마지막 업데이트: {generated_at}</p>
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-num">{total_files}</div>
                    <div class="stat-lbl">전체 파일</div>
                </div>
                <div class="stat-card stat-progress">
                    <div class="stat-num">{completed_count}<span class="stat-denom">/{TOTAL_STAGES}</span></div>
                    <div class="stat-lbl">완료 단계</div>
                </div>
                <div class="stat-card stat-recent">
                    <div class="stat-num stat-filename">{recent_name}</div>
                    <div class="stat-lbl">최근 수정</div>
                </div>
                <div class="stat-card stat-cat">
                    <div class="stat-num">{categories_with_files}</div>
                    <div class="stat-lbl">카테고리</div>
                </div>
            </div>
        </header>"""

    # B. Progress section
    stages_html = ""
    for i, stage in enumerate(STAGES):
        done = stages_completed[i]
        cls = "stage-done" if done else "stage-pending"
        check = "&#10003;" if done else str(stage["id"])
        stages_html += f"""
                <div class="stage-item {cls}">
                    <div class="stage-icon">{stage['icon']}</div>
                    <div class="stage-check">{check}</div>
                    <div class="stage-name">{stage['name']}</div>
                </div>"""

    progress_pct = round(completed_count / TOTAL_STAGES * 100)
    progress_html = f"""
        <section class="progress-section">
            <div class="section-header">
                <h2>진행 단계</h2>
                <span class="progress-pct">{progress_pct}%</span>
            </div>
            <div class="progress-track">
                <div class="progress-fill" style="width:{progress_pct}%"></div>
            </div>
            <div class="stages-grid">{stages_html}
            </div>
        </section>"""

    # C. Category sections
    categories_html = ""

    # C1. Ideas
    ideas_meta = CATEGORY_META["ideas"]
    if ideas:
        idea_cards = ""
        for idea in ideas:
            idea_cards += _build_idea_card(idea)
        ideas_content = f'<div class="cards-grid">{idea_cards}\n                </div>'
    else:
        ideas_content = _build_empty_category(ideas_meta)

    categories_html += f"""
        <section class="category-section">
            <h2>{ideas_meta['icon']} {ideas_meta['label']}</h2>
            <div class="category-body">
                {ideas_content}
            </div>
        </section>"""

    # C2-C5. File-based categories
    file_categories = [
        ("research", research_files),
        ("financials", financials_files),
        ("reports", reports_files),
        ("presentations", presentations_files),
    ]

    for cat_key, files in file_categories:
        meta = CATEGORY_META[cat_key]
        if files:
            file_cards = ""
            for fi in files:
                file_cards += _build_file_card(fi, output_dir)
            content = f'<div class="cards-grid">{file_cards}\n                </div>'
        else:
            content = _build_empty_category(meta)

        categories_html += f"""
        <section class="category-section">
            <h2>{meta['icon']} {meta['label']}</h2>
            <div class="category-body">
                {content}
            </div>
        </section>"""

    # D. Quick start guide (shown when any category is empty)
    empty_cats = []
    if not ideas:
        empty_cats.append(CATEGORY_META["ideas"])
    if not research_files:
        empty_cats.append(CATEGORY_META["research"])
    if not financials_files:
        empty_cats.append(CATEGORY_META["financials"])
    if not reports_files:
        empty_cats.append(CATEGORY_META["reports"])

    quickstart_html = ""
    if empty_cats:
        guide_items = ""
        for meta in empty_cats:
            guide_items += f"""
                    <div class="guide-item">
                        <code>{meta['empty_cmd']}</code>
                        <span>{meta['empty_msg']}</span>
                    </div>"""
        quickstart_html = f"""
        <section class="quickstart-section">
            <h2>&#128640; 빠른 시작 가이드</h2>
            <p class="quickstart-desc">아래 명령어를 대화창에 입력해보세요</p>
            <div class="guide-grid">{guide_items}
            </div>
        </section>"""

    # E. Footer
    footer_html = f"""
        <footer class="footer">
            Antigravity Business Planner &mdash; Generated {generated_at}
        </footer>"""

    # Assemble full HTML
    html = _build_full_html(
        hero_html + progress_html + categories_html + quickstart_html + footer_html,
        generated_at,
    )

    return html


def _build_full_html(body_content, generated_at):
    """Wrap body content in full HTML document with styles."""
    return f"""<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 사업 기획 현황 | Antigravity Business Planner</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;400;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
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
            line-height: 1.6;
            min-height: 100dvh;
            overflow-y: auto;
        }}

        h1, h2, h3, h4 {{
            font-family: 'Outfit', sans-serif;
        }}

        .container {{
            max-width: 1100px;
            margin: 0 auto;
            padding: var(--space-md) var(--space-md) var(--space-lg);
        }}

        /* ── Hero ── */
        .hero {{
            text-align: center;
            padding: var(--space-xl) 0 var(--space-lg);
        }}
        .hero h1 {{
            font-size: 2rem;
            font-weight: 700;
            background: var(--rainbow);
            background-size: 200% auto;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 4px;
            animation: shimmer 4s linear infinite;
        }}
        @keyframes shimmer {{
            0% {{ background-position: 0% center; }}
            100% {{ background-position: 200% center; }}
        }}
        .hero-sub {{
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin-bottom: var(--space-md);
        }}

        .stats-row {{
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: var(--space-sm);
            max-width: 700px;
            margin: 0 auto;
        }}
        .stat-card {{
            background: var(--glass-standard);
            backdrop-filter: var(--blur-subtle);
            border: 1px solid var(--border-glass);
            border-top: 2px solid var(--accent-blue);
            border-radius: var(--radius-sm);
            padding: var(--space-sm);
            text-align: center;
            transition: border-color 0.2s;
        }}
        .stat-card:hover {{
            border-color: var(--border-glass-hover);
        }}
        .stat-progress {{ border-top-color: var(--accent-green); }}
        .stat-recent {{ border-top-color: var(--accent-cyan); }}
        .stat-cat {{ border-top-color: var(--accent-gold); }}

        .stat-num {{
            font-family: 'Outfit', sans-serif;
            font-size: 1.6rem;
            font-weight: 600;
            color: var(--text-primary);
        }}
        .stat-filename {{
            font-size: 0.85rem;
            font-family: var(--font-mono);
            word-break: break-all;
        }}
        .stat-denom {{
            font-size: 0.85rem;
            color: var(--text-muted);
            font-weight: 400;
        }}
        .stat-lbl {{
            font-size: 0.78rem;
            color: var(--text-secondary);
            margin-top: 4px;
        }}

        /* ── Progress Section ── */
        .progress-section {{
            margin: var(--space-lg) 0;
        }}
        .section-header {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-sm);
        }}
        .section-header h2 {{
            font-size: 1.2rem;
            font-weight: 600;
        }}
        .progress-pct {{
            font-family: 'Outfit', sans-serif;
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--accent-cyan);
        }}
        .progress-track {{
            height: 6px;
            background: rgba(255,255,255,0.08);
            border-radius: 3px;
            overflow: hidden;
            margin-bottom: var(--space-md);
        }}
        .progress-fill {{
            height: 100%;
            border-radius: 3px;
            background: linear-gradient(90deg, var(--accent-blue), var(--accent-cyan), var(--accent-green));
            transition: width 0.4s ease;
        }}

        .stages-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
            gap: var(--space-xs);
        }}
        .stage-item {{
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 4px;
            padding: var(--space-sm) var(--space-xs);
            background: var(--glass-standard);
            border: 1px solid var(--border-glass);
            border-radius: var(--radius-sm);
            text-align: center;
            transition: all 0.2s;
        }}
        .stage-done {{
            border-color: rgba(67, 233, 123, 0.3);
            background: rgba(67, 233, 123, 0.06);
        }}
        .stage-pending {{
            opacity: 0.5;
        }}
        .stage-icon {{
            font-size: 1.3rem;
        }}
        .stage-check {{
            width: 22px;
            height: 22px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 600;
        }}
        .stage-done .stage-check {{
            background: var(--accent-green);
            color: var(--bg-deep);
        }}
        .stage-pending .stage-check {{
            background: rgba(255,255,255,0.1);
            color: var(--text-muted);
        }}
        .stage-name {{
            font-size: 0.72rem;
            color: var(--text-secondary);
            line-height: 1.3;
        }}
        .stage-done .stage-name {{
            color: var(--text-primary);
        }}

        /* ── Category Sections ── */
        .category-section {{
            margin: var(--space-lg) 0;
        }}
        .category-section h2 {{
            font-size: 1.15rem;
            font-weight: 600;
            margin-bottom: var(--space-sm);
            padding-bottom: var(--space-xs);
            border-bottom: 1px solid var(--border-glass);
        }}

        .cards-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: var(--space-sm);
        }}

        .file-card {{
            background: var(--glass-standard);
            backdrop-filter: var(--blur-subtle);
            border: 1px solid var(--border-glass);
            border-radius: var(--radius-sm);
            padding: var(--space-sm);
            transition: all 0.2s ease;
        }}
        .file-card:hover {{
            border-color: var(--border-glass-hover);
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        }}
        .file-card-header {{
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 8px;
            margin-bottom: 8px;
        }}
        .file-card-header h4 {{
            font-size: 0.9rem;
            font-weight: 600;
            line-height: 1.3;
            word-break: break-word;
        }}
        .file-name {{
            font-family: var(--font-mono);
            font-size: 0.82rem;
        }}
        .file-meta {{
            display: flex;
            justify-content: space-between;
            font-size: 0.75rem;
            color: var(--text-muted);
        }}

        .open-link {{
            display: inline-block;
            margin-top: 8px;
            font-size: 0.78rem;
            color: var(--accent-cyan);
            text-decoration: none;
            transition: color 0.2s;
        }}
        .open-link:hover {{
            color: var(--accent-blue);
        }}

        /* Idea card specifics */
        .idea-card {{ }}
        .idea-meta-row {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }}
        .idea-score {{
            font-family: 'Outfit', sans-serif;
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--accent-cyan);
        }}
        .score-unit {{
            font-size: 0.75rem;
            color: var(--text-muted);
            font-weight: 400;
        }}
        .idea-files {{
            font-size: 0.75rem;
            color: var(--text-muted);
        }}

        .sub-file-list {{
            list-style: none;
            padding: 0;
            margin: 0;
        }}
        .sub-file {{
            font-size: 0.75rem;
            font-family: var(--font-mono);
            color: var(--text-secondary);
            padding: 3px 0;
            border-top: 1px solid var(--border-glass);
        }}

        /* Badge */
        .badge {{
            display: inline-block;
            padding: 3px 12px;
            border-radius: 20px;
            font-size: 0.72rem;
            font-weight: 500;
            white-space: nowrap;
            flex-shrink: 0;
        }}
        .badge-go {{
            background: rgba(67,233,123,0.15);
            color: var(--accent-green);
            border: 1px solid rgba(67,233,123,0.3);
        }}
        .badge-pivot {{
            background: rgba(247,151,30,0.15);
            color: #f7971e;
            border: 1px solid rgba(247,151,30,0.3);
        }}
        .badge-drop {{
            background: rgba(255,107,157,0.15);
            color: #ff6b9d;
            border: 1px solid rgba(255,107,157,0.3);
        }}
        .badge-default {{
            background: rgba(255,255,255,0.08);
            color: var(--text-muted);
            border: 1px solid var(--border-glass);
        }}

        /* Empty state */
        .empty-category {{
            text-align: center;
            padding: var(--space-lg) var(--space-md);
            color: var(--text-muted);
        }}
        .empty-category p {{
            margin-bottom: 6px;
        }}
        .empty-cmd code {{
            font-family: var(--font-mono);
            color: var(--accent-cyan);
            font-size: 0.9rem;
        }}
        .empty-hint {{
            font-size: 0.75rem;
            color: var(--text-muted);
            padding-top: 4px;
        }}

        /* ── Quick Start ── */
        .quickstart-section {{
            margin: var(--space-xl) 0 var(--space-lg);
            padding: var(--space-md);
            background: var(--glass-standard);
            border: 1px solid var(--border-glass);
            border-radius: var(--radius-md);
        }}
        .quickstart-section h2 {{
            font-size: 1.1rem;
            margin-bottom: 4px;
        }}
        .quickstart-desc {{
            font-size: 0.82rem;
            color: var(--text-secondary);
            margin-bottom: var(--space-sm);
        }}
        .guide-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: var(--space-sm);
        }}
        .guide-item {{
            display: flex;
            align-items: center;
            gap: var(--space-xs);
            padding: var(--space-xs) var(--space-sm);
            background: var(--glass-subtle);
            border: 1px solid var(--border-glass);
            border-radius: var(--radius-sm);
        }}
        .guide-item code {{
            font-family: var(--font-mono);
            color: var(--accent-cyan);
            font-size: 0.85rem;
            white-space: nowrap;
        }}
        .guide-item span {{
            font-size: 0.8rem;
            color: var(--text-secondary);
        }}

        /* ── Footer ── */
        .footer {{
            text-align: center;
            padding: var(--space-md) 0;
            margin-top: var(--space-lg);
            border-top: 1px solid var(--border-glass);
            font-size: 0.75rem;
            color: var(--text-muted);
        }}

        /* ── Responsive ── */
        @media (max-width: 700px) {{
            .stats-row {{
                grid-template-columns: repeat(2, 1fr);
            }}
            .stages-grid {{
                grid-template-columns: repeat(3, 1fr);
            }}
            .cards-grid {{
                grid-template-columns: 1fr;
            }}
            .guide-grid {{
                grid-template-columns: 1fr;
            }}
            .hero h1 {{
                font-size: 1.5rem;
            }}
        }}
    </style>
</head>
<body>
    <div class="container">
{body_content}
    </div>
</body>
</html>"""


def main():
    parser = argparse.ArgumentParser(
        description="Outputs Dashboard HTML Generator"
    )
    parser.add_argument(
        "--output-dir",
        default=None,
        help="Output directory (default: output/)",
    )
    parser.add_argument(
        "--idea",
        default=None,
        help="Show only a specific idea's deliverables (idea folder name)",
    )
    args = parser.parse_args()

    project_root = find_project_root()

    if args.output_dir:
        output_dir = Path(args.output_dir)
    else:
        output_dir = project_root / "output"

    html = generate_html(output_dir, idea_filter=args.idea)

    dashboard_path = output_dir / "dashboard.html"
    dashboard_path.parent.mkdir(parents=True, exist_ok=True)
    dashboard_path.write_text(html, encoding="utf-8")

    print(str(dashboard_path))
    sys.exit(0)


if __name__ == "__main__":
    main()
