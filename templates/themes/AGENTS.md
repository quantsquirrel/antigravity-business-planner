<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-16 | Updated: 2026-02-16 -->

# themes

## Purpose
HTML theme templates used by the document-exporter skill to style Markdown-to-HTML conversions. Each theme provides a complete HTML layout with CSS for Korean business documents, optimized for both screen viewing and print/PDF output.

## Key Files

| File | Description |
|------|-------------|
| `business.html` | Professional/corporate theme with clean, formal styling |
| `cosmic.html` | Creative theme with gradient backgrounds and modern aesthetics |
| `modern.html` | Contemporary minimalist theme with clean typography |

## For AI Agents

### Working In This Directory
- Themes are HTML files with embedded CSS and template placeholders
- The document-exporter's `export_docs.py` script loads these themes
- All themes must support Korean fonts (Noto Sans KR or similar)
- Themes must include print-friendly CSS (`@media print`) for PDF export via Cmd+P
- Preview rendered output in `output/previews/` before deploying theme changes

### Common Patterns
- Themes use template variable placeholders for title, content, and table of contents
- Each theme includes responsive CSS for different screen sizes
- Print styles hide navigation elements and optimize page breaks

<!-- MANUAL: -->
