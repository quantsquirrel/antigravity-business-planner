#!/usr/bin/env python3
"""Diagnostic script - writes results to diag_result.txt"""
from pathlib import Path
import sys

output = Path(__file__).parent / "diag_result.txt"
lines = []

lines.append(f"Python: {sys.version}")
lines.append(f"Executable: {sys.executable}")

# Check markdown
try:
    import markdown
    lines.append(f"markdown: OK (v{markdown.__version__})")
except ImportError:
    lines.append("markdown: NOT INSTALLED")

# Check jinja2
try:
    import jinja2
    lines.append(f"jinja2: OK (v{jinja2.__version__})")
except ImportError:
    lines.append("jinja2: NOT INSTALLED")

# Check themes dir
script_dir = Path("/Users/ahnjundaram_g/dev/tools/antigravity-business-planner/.agent/skills/document-exporter/scripts/export_docs.py")
themes_dir = Path("/Users/ahnjundaram_g/dev/tools/antigravity-business-planner/templates/themes")
lines.append(f"Themes dir exists: {themes_dir.exists()}")
if themes_dir.exists():
    for f in themes_dir.iterdir():
        lines.append(f"  Theme: {f.name} ({f.stat().st_size} bytes)")

# Try running the exporter
lines.append("")
lines.append("--- Export Test ---")
try:
    sys.path.insert(0, str(script_dir.parent))
    # Manually simulate what export_docs does
    from string import Template
    import re
    
    template_path = themes_dir / "cosmic.html"
    if template_path.exists():
        lines.append(f"cosmic.html loaded: {template_path.stat().st_size} bytes")
    
    md_path = Path("/Users/ahnjundaram_g/dev/tools/antigravity-business-planner/templates/business-plan-template.md")
    if md_path.exists():
        lines.append(f"Template MD found: {md_path.stat().st_size} bytes")
        
        if 'markdown' in dir():
            md_content = md_path.read_text(encoding='utf-8')
            md_obj = markdown.Markdown(extensions=['toc', 'tables', 'fenced_code'])
            html = md_obj.convert(md_content)
            lines.append(f"Markdown converted: {len(html)} chars")
            lines.append(f"TOC generated: {len(md_obj.toc)} chars")
        else:
            lines.append("Skipping conversion (markdown not available)")
    else:
        lines.append(f"Template MD NOT found at {md_path}")
except Exception as e:
    lines.append(f"Error: {e}")

output.write_text("\n".join(lines), encoding='utf-8')
print(f"Diagnostics written to {output}")
