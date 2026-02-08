#!/usr/bin/env python3
"""
Document Export Script for Antigravity Business Planner
Converts Markdown documents to styled HTML with print-friendly formatting
"""

import argparse
import sys
import os
from pathlib import Path
from datetime import datetime

# Check markdown package availability
try:
    import markdown
except ImportError:
    print("❌ Error: 'markdown' package is not installed.")
    print("\n📦 Please install it using:")
    print("   pip install markdown")
    print("\n   or")
    print("   pip3 install markdown")
    sys.exit(1)


HTML_TEMPLATE = """<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title}</title>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}

        body {{
            font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo",
                         "Malgun Gothic", "Noto Sans KR", sans-serif;
            line-height: 1.8;
            color: #222;
            background: #f5f5f5;
            padding: 2rem;
        }}

        .document-container {{
            max-width: 900px;
            margin: 0 auto;
            background: white;
            padding: 3rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
        }}

        .document-header {{
            border-bottom: 3px solid #2c3e50;
            padding-bottom: 1.5rem;
            margin-bottom: 2rem;
        }}

        .document-header h1 {{
            font-size: 2rem;
            color: #2c3e50;
            margin-bottom: 0.5rem;
            font-weight: 700;
        }}

        .document-meta {{
            color: #666;
            font-size: 0.9rem;
        }}

        .document-content h1 {{
            font-size: 1.8rem;
            color: #2c3e50;
            margin: 2rem 0 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #ecf0f1;
        }}

        .document-content h2 {{
            font-size: 1.5rem;
            color: #34495e;
            margin: 1.8rem 0 1rem;
            padding-left: 0.5rem;
            border-left: 4px solid #3498db;
        }}

        .document-content h3 {{
            font-size: 1.3rem;
            color: #34495e;
            margin: 1.5rem 0 0.8rem;
        }}

        .document-content h4 {{
            font-size: 1.1rem;
            color: #555;
            margin: 1.2rem 0 0.6rem;
        }}

        .document-content p {{
            margin-bottom: 1rem;
            text-align: justify;
        }}

        .document-content ul,
        .document-content ol {{
            margin: 1rem 0 1rem 2rem;
        }}

        .document-content li {{
            margin-bottom: 0.5rem;
        }}

        .document-content blockquote {{
            border-left: 4px solid #3498db;
            padding-left: 1.5rem;
            margin: 1.5rem 0;
            color: #555;
            font-style: italic;
            background: #f8f9fa;
            padding: 1rem 1rem 1rem 1.5rem;
        }}

        .document-content code {{
            background: #f4f4f4;
            padding: 0.2rem 0.4rem;
            border-radius: 3px;
            font-family: "Monaco", "Menlo", monospace;
            font-size: 0.9em;
            color: #e74c3c;
        }}

        .document-content pre {{
            background: #2c3e50;
            color: #ecf0f1;
            padding: 1rem;
            border-radius: 5px;
            overflow-x: auto;
            margin: 1rem 0;
        }}

        .document-content pre code {{
            background: none;
            color: inherit;
            padding: 0;
        }}

        .document-content table {{
            width: 100%;
            border-collapse: collapse;
            margin: 1.5rem 0;
            border: 1px solid #ddd;
        }}

        .document-content th {{
            background: #34495e;
            color: white;
            padding: 0.8rem;
            text-align: left;
            font-weight: 600;
        }}

        .document-content td {{
            padding: 0.8rem;
            border: 1px solid #ddd;
        }}

        .document-content tr:nth-child(even) {{
            background: #f8f9fa;
        }}

        .document-content img {{
            max-width: 100%;
            height: auto;
            display: block;
            margin: 1.5rem auto;
            border-radius: 5px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }}

        .document-content hr {{
            border: none;
            border-top: 2px solid #ecf0f1;
            margin: 2rem 0;
        }}

        .document-footer {{
            margin-top: 3rem;
            padding-top: 1.5rem;
            border-top: 2px solid #ecf0f1;
            color: #999;
            font-size: 0.85rem;
            text-align: center;
        }}

        /* Print styles */
        @media print {{
            body {{
                background: white;
                padding: 0;
            }}

            .document-container {{
                max-width: 100%;
                box-shadow: none;
                padding: 1.5cm;
            }}

            .document-header {{
                page-break-after: avoid;
            }}

            .document-content h1,
            .document-content h2,
            .document-content h3 {{
                page-break-after: avoid;
            }}

            .document-content table {{
                page-break-inside: avoid;
            }}

            .document-content pre {{
                page-break-inside: avoid;
                border: 1px solid #ddd;
            }}

            @page {{
                margin: 2cm;
                size: A4;
            }}
        }}
    </style>
</head>
<body>
    <div class="document-container">
        <div class="document-header">
            <h1>{title}</h1>
            <div class="document-meta">생성일: {date}</div>
        </div>

        <div class="document-content">
            {content}
        </div>

        <div class="document-footer">
            본 문서는 AI 기반 사업 기획 도구로 생성되었습니다.
        </div>
    </div>
</body>
</html>
"""


def extract_title_from_markdown(content):
    """Extract first h1 heading from markdown content"""
    for line in content.split('\n'):
        line = line.strip()
        if line.startswith('# '):
            return line[2:].strip()
    return "문서"


def convert_markdown_to_html(input_path, output_path=None):
    """Convert a single Markdown file to styled HTML"""
    input_file = Path(input_path)

    if not input_file.exists():
        print(f"❌ Error: File not found: {input_path}")
        return False

    if not input_file.suffix.lower() in ['.md', '.markdown']:
        print(f"⚠️  Warning: File doesn't appear to be Markdown: {input_path}")

    try:
        # Read markdown content
        with open(input_file, 'r', encoding='utf-8') as f:
            md_content = f.read()

        # Extract title
        title = extract_title_from_markdown(md_content)

        # Get file modification date
        mod_time = datetime.fromtimestamp(input_file.stat().st_mtime)
        date_str = mod_time.strftime("%Y년 %m월 %d일")

        # Convert markdown to HTML
        html_content = markdown.markdown(
            md_content,
            extensions=['tables', 'fenced_code', 'codehilite']
        )

        # Generate final HTML
        final_html = HTML_TEMPLATE.format(
            title=title,
            date=date_str,
            content=html_content
        )

        # Determine output path
        if output_path:
            output_file = Path(output_path)
        else:
            output_file = input_file.with_suffix('.html')

        # Write HTML file
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(final_html)

        print(f"✅ Converted: {input_file.name} → {output_file.name}")
        print(f"   📄 Output: {output_file.absolute()}")
        return True

    except UnicodeDecodeError:
        print(f"❌ Error: Unable to read file (encoding issue): {input_path}")
        print("   Please ensure the file is UTF-8 encoded.")
        return False
    except Exception as e:
        print(f"❌ Error converting {input_path}: {str(e)}")
        return False


def batch_convert(directory, recursive=False):
    """Convert all Markdown files in a directory"""
    dir_path = Path(directory)

    if not dir_path.exists():
        print(f"❌ Error: Directory not found: {directory}")
        return False

    if not dir_path.is_dir():
        print(f"❌ Error: Not a directory: {directory}")
        return False

    # Find markdown files
    if recursive:
        md_files = list(dir_path.rglob('*.md')) + list(dir_path.rglob('*.markdown'))
    else:
        md_files = list(dir_path.glob('*.md')) + list(dir_path.glob('*.markdown'))

    if not md_files:
        print(f"⚠️  No Markdown files found in: {directory}")
        return False

    print(f"📁 Found {len(md_files)} Markdown file(s)\n")

    success_count = 0
    for md_file in md_files:
        if convert_markdown_to_html(md_file):
            success_count += 1
        print()  # Empty line between files

    print(f"{'='*60}")
    print(f"✨ Completed: {success_count}/{len(md_files)} files converted successfully")

    return success_count > 0


def main():
    parser = argparse.ArgumentParser(
        description='Convert Markdown documents to styled HTML',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Convert single file
  %(prog)s report.md

  # Convert with custom output path
  %(prog)s report.md --output output.html

  # Batch convert all .md files in a directory
  %(prog)s --batch ./output

  # Batch convert including subdirectories
  %(prog)s --batch ./output --recursive

PDF Export:
  After generating HTML, open it in a browser and use:
  - macOS: Cmd+P → Save as PDF
  - Windows/Linux: Ctrl+P → Save as PDF
        """
    )

    parser.add_argument(
        'input',
        nargs='?',
        help='Input Markdown file to convert'
    )

    parser.add_argument(
        '-o', '--output',
        help='Output HTML file path (default: same name as input with .html extension)'
    )

    parser.add_argument(
        '-b', '--batch',
        metavar='DIR',
        help='Batch convert all Markdown files in directory'
    )

    parser.add_argument(
        '-r', '--recursive',
        action='store_true',
        help='Include subdirectories in batch mode'
    )

    args = parser.parse_args()

    # Validate arguments
    if not args.input and not args.batch:
        parser.print_help()
        print("\n❌ Error: Please provide either an input file or use --batch mode")
        sys.exit(1)

    if args.input and args.batch:
        print("❌ Error: Cannot use both single file and batch mode simultaneously")
        sys.exit(1)

    if args.recursive and not args.batch:
        print("❌ Error: --recursive can only be used with --batch mode")
        sys.exit(1)

    # Execute conversion
    if args.batch:
        success = batch_convert(args.batch, args.recursive)
    else:
        success = convert_markdown_to_html(args.input, args.output)
        if success and not args.output:
            output_file = Path(args.input).with_suffix('.html')
            print(f"\n💡 To save as PDF:")
            print(f"   1. Open {output_file.name} in a browser")
            print(f"   2. Press Cmd+P (macOS) or Ctrl+P (Windows/Linux)")
            print(f"   3. Select 'Save as PDF'")

    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
