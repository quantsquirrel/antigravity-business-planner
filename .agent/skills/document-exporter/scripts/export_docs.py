#!/usr/bin/env python3
"""
Business Planner Document Exporter
Converts Markdown analysis reports into styled HTML/PDF business documents.
Supports multiple high-quality design themes (Cosmic, Business, Modern).

Dependencies: markdown (pip install markdown)
No Jinja2 required - uses Python's built-in string.Template for portability.
"""

import sys
import argparse
from pathlib import Path
from datetime import datetime
from string import Template

try:
    import markdown
except ImportError:
    print("❌ Error: 'markdown' package not found.")
    print("   Please run: pip install markdown")
    sys.exit(1)

# Configuration
THEMES_DIR = Path(__file__).resolve().parent.parent.parent.parent.parent / "templates" / "themes"
DEFAULT_THEME = "cosmic"


def extract_title(md_content):
    """Extract the first H1 heading to use as title."""
    for line in md_content.split('\n'):
        if line.strip().startswith('# '):
            return line.strip()[2:].strip()
    return "Business Report"


def extract_metadata(md_content):
    """Extract metadata from blockquote lines (> Key: Value)."""
    metadata = {}
    for line in md_content.split('\n')[:20]:
        if line.strip().startswith('> '):
            parts = line.strip()[2:].split(':', 1)
            if len(parts) == 2:
                metadata[parts[0].strip().lower()] = parts[1].strip()
    return metadata


def load_theme(theme_name):
    """Load an HTML theme template from templates/themes/."""
    theme_file = THEMES_DIR / f"{theme_name}.html"
    if not theme_file.exists():
        print(f"⚠️  Theme '{theme_name}' not found at {theme_file}")
        print(f"   Available themes: {', '.join(t.stem for t in THEMES_DIR.glob('*.html'))}")
        print(f"   Falling back to default theme: {DEFAULT_THEME}")
        theme_file = THEMES_DIR / f"{DEFAULT_THEME}.html"
        if not theme_file.exists():
            return None
    with open(theme_file, 'r', encoding='utf-8') as f:
        return f.read()


def render_template(template_str, context):
    """Render a template string using simple placeholder replacement.
    
    Supports:
      - {{ variable }} and {{ variable | safe }}
      - {% if var %} content {% else %} alternative {% endif %}
    """
    import re
    
    # 1. Handle {% if var %} ... {% else %} ... {% endif %} blocks
    def process_if_blocks(text, ctx):
        # Pattern to find {% if var %} ... {% endif %} including optional {% else %}
        # This uses a simple non-nested approach (sufficient for current templates)
        pattern = r'\{%\s*if\s+(\w+)\s*%\}(.*?)\{%\s*endif\s*%\}'
        
        def replacement(match):
            var_name = match.group(1).strip()
            full_content = match.group(2)
            
            # Split by {% else %} if it exists
            parts = re.split(r'\{%\s*else\s*%\}', full_content, maxsplit=1)
            if_content = parts[0]
            else_content = parts[1] if len(parts) > 1 else ""
            
            if ctx.get(var_name):
                return if_content
            return else_content

        # Apply recursively or once? Our templates are simple, once is enough for top-level.
        return re.sub(pattern, replacement, text, flags=re.DOTALL)

    # Apply if-block processing
    template_str = process_if_blocks(template_str, context)
    
    # 2. Convert Jinja2 {{ var }} and {{ var | safe }} to ${var} for string.Template
    template_str = re.sub(r'\{\{\s*(\w+)\s*\|\s*safe\s*\}\}', r'${\1}', template_str)
    template_str = re.sub(r'\{\{\s*(\w+)\s*\}\}', r'${\1}', template_str)
    
    # 3. Use Template for safe substitution (missing keys become empty)
    t = Template(template_str)
    return t.safe_substitute(context)


def convert_markdown_to_html(input_path, output_path=None, theme_name=DEFAULT_THEME):
    """Convert a single Markdown file to styled HTML."""
    input_file = Path(input_path)
    
    if not input_file.exists():
        print(f"❌ Error: File not found: {input_path}")
        return False

    try:
        # Read Markdown
        with open(input_file, 'r', encoding='utf-8') as f:
            md_content = f.read()

        # Extract metadata
        title = extract_title(md_content)
        metadata = extract_metadata(md_content)
        
        # Convert Markdown to HTML with TOC
        md = markdown.Markdown(extensions=['toc', 'tables', 'fenced_code', 'codehilite'])
        html_content = md.convert(md_content)
        toc_html = md.toc if hasattr(md, 'toc') else ''
        
        # Load theme template
        template_str = load_theme(theme_name)
        if template_str is None:
            print(f"❌ Error: No theme template available.")
            return False
        
        # Build context
        context = {
            'title': title,
            'content': html_content,
            'toc': toc_html,
            'date': metadata.get('작성일', datetime.now().strftime("%Y년 %m월 %d일")),
            'author': metadata.get('작성자', ''),
            'version': metadata.get('버전', ''),
        }
        
        # Render
        final_html = render_template(template_str, context)

        # Output
        if output_path:
            output_file = Path(output_path)
        else:
            output_file = input_file.with_suffix('.html')
        
        output_file.parent.mkdir(parents=True, exist_ok=True)
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(final_html)

        print(f"✅ Converted: {input_file.name} → {output_file.name} (Theme: {theme_name})")
        print(f"   📄 Output: {output_file.absolute()}")
        return True

    except UnicodeDecodeError:
        print(f"❌ Error: Encoding issue with {input_path}. Ensure UTF-8.")
        return False
    except Exception as e:
        print(f"❌ Error converting {input_path}: {str(e)}")
        import traceback
        traceback.print_exc()
        return False


def batch_convert(directory, theme=DEFAULT_THEME, recursive=False):
    """Convert all Markdown files in a directory."""
    dir_path = Path(directory)

    if not dir_path.exists():
        print(f"❌ Error: Directory not found: {directory}")
        return False

    pattern = '**/*.md' if recursive else '*.md'
    md_files = list(dir_path.glob(pattern))

    if not md_files:
        print(f"⚠️  No Markdown files found in: {directory}")
        return False

    print(f"📁 Found {len(md_files)} Markdown file(s)")
    print(f"🎨 Theme: {theme}\n")

    success_count = 0
    for md_file in md_files:
        if convert_markdown_to_html(md_file, theme_name=theme):
            success_count += 1

    print(f"\n{'='*60}")
    print(f"✨ Completed: {success_count}/{len(md_files)} files converted")
    return success_count > 0


def main():
    parser = argparse.ArgumentParser(
        description='Convert Markdown to styled HTML business reports.',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Themes:
  cosmic   : Deep Space theme with glassmorphism (Default)
  business : Formal Print-ready A4 style with Serif fonts
  modern   : Clean Notion-style layout for digital reading

Examples:
  %(prog)s report.md                         # Default (cosmic)
  %(prog)s report.md --theme business        # Business theme  
  %(prog)s --batch ./output --theme modern   # Batch convert
        """
    )

    parser.add_argument('input', nargs='?', help='Input Markdown file')
    parser.add_argument('-o', '--output', help='Output HTML file path')
    parser.add_argument('-b', '--batch', metavar='DIR', help='Batch convert directory')
    parser.add_argument('-r', '--recursive', action='store_true', help='Recursive batch')
    parser.add_argument('-t', '--theme', default=DEFAULT_THEME,
                        help=f'Design theme (default: {DEFAULT_THEME})')

    args = parser.parse_args()

    if not args.input and not args.batch:
        parser.print_help()
        sys.exit(1)

    if args.input:
        convert_markdown_to_html(args.input, args.output, theme_name=args.theme)
    elif args.batch:
        batch_convert(args.batch, theme=args.theme, recursive=args.recursive)


if __name__ == '__main__':
    main()
