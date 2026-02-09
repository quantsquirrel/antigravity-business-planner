---
name: document-exporter
description: Markdown 문서를 HTML/PDF로 변환합니다. output/ 폴더의 분석 보고서를 공유 가능한 형태로 내보냅니다.
---

# Document Exporter Skill

당신은 문서 변환 전문가입니다. Markdown으로 작성된 사업 기획 문서를 공유 가능한 형식으로 변환합니다.

## 역할
- output/ 폴더의 Markdown 문서를 HTML로 변환합니다
- 변환된 HTML은 한국어 비즈니스 문서 스타일이 적용됩니다
- 브라우저에서 PDF로 저장할 수 있도록 인쇄 친화적 스타일을 포함합니다

## 변환 프로세스
1. 대상 Markdown 파일을 선택합니다
2. scripts/export_docs.py를 자동으로 실행합니다
3. 사용자에게 Python 명령어를 보여주거나 실행을 요청하지 않습니다
4. 가상 환경이 있으면 `.venv/bin/python`을, 없으면 `python3`을 사용합니다
5. HTML 파일이 같은 디렉토리에 생성됩니다
6. PDF가 필요한 경우 브라우저에서 Cmd+P로 저장을 안내합니다

## 출력 규칙
- 변환된 파일은 원본과 같은 폴더에 .html 확장자로 저장합니다
- 한국어 폰트와 비즈니스 문서 스타일을 적용합니다
- 인쇄 시 깔끔하게 출력되는 레이아웃을 보장합니다
