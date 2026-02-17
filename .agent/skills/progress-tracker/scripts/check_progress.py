#!/usr/bin/env python3
"""
사업 기획 진행률 추적 스크립트

8단계 기획 프로세스의 진행 상황을 output/ 디렉토리를 기반으로 추적합니다.
멀티 아이디어 포트폴리오 모드를 지원합니다.
"""

import argparse
import json
import os
import re
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Tuple


class ProgressTracker:
    """사업 기획 진행률 추적기"""

    # Stage 0 (조건부) + 8단계 기획 프로세스 정의
    STAGE_0 = {
        "id": 0,
        "name": "아이디어 발굴",
        "directory": "output/ideas",
        "keywords": ["idea", "아이디어", "selected"],
    }

    STAGES = [
        {
            "id": 1,
            "name": "시장 조사",
            "directory": "output/research",
            "keywords": ["시장", "market"],
        },
        {
            "id": 2,
            "name": "경쟁 분석",
            "directory": "output/research",
            "keywords": ["경쟁", "competitor"],
        },
        {
            "id": 3,
            "name": "제품/원가",
            "directory": "output/financials",
            "keywords": ["원가", "menu", "costing"],
        },
        {
            "id": 4,
            "name": "재무 모델",
            "directory": "output/financials",
            "keywords": ["재무", "financial", "손익"],
        },
        {
            "id": 5,
            "name": "운영 계획",
            "directory": "output/reports",
            "keywords": ["운영", "operation"],
        },
        {
            "id": 6,
            "name": "브랜딩",
            "directory": "output/reports",
            "keywords": ["브랜딩", "brand", "마케팅"],
        },
        {
            "id": 7,
            "name": "법률/인허가",
            "directory": "output/reports",
            "keywords": ["법률", "legal", "인허가"],
        },
        {
            "id": 8,
            "name": "사업계획서",
            "directory": "output/reports",
            "keywords": ["사업계획", "business-plan"],
        },
    ]

    # Idea-local stage definitions (directory relative to idea folder)
    IDEA_STAGE_0_FILES = ["hypothesis.md", "evaluation.md", "existing-alternatives.md"]

    IDEA_STAGES = [
        {
            "id": 1,
            "name": "시장 조사",
            "directory": "research",
            "keywords": ["시장", "market"],
        },
        {
            "id": 2,
            "name": "경쟁 분석",
            "directory": "research",
            "keywords": ["경쟁", "competitor"],
        },
        {
            "id": 3,
            "name": "제품/원가",
            "directory": "financials",
            "keywords": ["원가", "menu", "costing"],
        },
        {
            "id": 4,
            "name": "재무 모델",
            "directory": "financials",
            "keywords": ["재무", "financial", "손익"],
        },
        {
            "id": 5,
            "name": "운영 계획",
            "directory": "reports",
            "keywords": ["운영", "operation"],
        },
        {
            "id": 6,
            "name": "브랜딩",
            "directory": "reports",
            "keywords": ["브랜딩", "brand", "마케팅"],
        },
        {
            "id": 7,
            "name": "법률/인허가",
            "directory": "reports",
            "keywords": ["법률", "legal", "인허가"],
        },
        {
            "id": 8,
            "name": "사업계획서",
            "directory": "reports",
            "keywords": ["사업계획", "business-plan"],
        },
    ]

    def __init__(self, project_dir: str):
        """
        Args:
            project_dir: 프로젝트 루트 디렉토리 경로
        """
        self.project_dir = Path(project_dir).resolve()

    def check_stage(self, stage: Dict) -> Tuple[bool, List[str]]:
        """
        특정 단계의 완료 여부를 확인합니다.

        Args:
            stage: 단계 정의 딕셔너리

        Returns:
            (완료 여부, 발견된 파일 리스트)
        """
        directory = self.project_dir / stage["directory"]

        if not directory.exists():
            return False, []

        found_files = []
        keywords = stage["keywords"]

        # 디렉토리 내 모든 파일 검색
        for file_path in directory.rglob("*"):
            if file_path.is_file():
                filename_lower = file_path.name.lower()
                # 키워드 매칭
                if any(keyword.lower() in filename_lower for keyword in keywords):
                    found_files.append(str(file_path.relative_to(self.project_dir)))

        return len(found_files) > 0, found_files

    def has_ideas(self) -> bool:
        """
        output/ideas/ 디렉토리에 .gitkeep 외 파일이 있는지 확인합니다.

        Returns:
            아이디어 파일 존재 여부
        """
        ideas_dir = self.project_dir / "output" / "ideas"
        if not ideas_dir.exists():
            return False
        for file_path in ideas_dir.rglob("*"):
            if file_path.is_file() and file_path.name != ".gitkeep":
                return True
        return False

    def check_all_stages(self) -> Dict:
        """
        모든 단계의 진행 상황을 확인합니다.
        output/ideas/에 파일이 있으면 Stage 0을 포함합니다.

        Returns:
            진행률 정보를 담은 딕셔너리
        """
        results = []
        completed_count = 0
        include_stage_0 = self.has_ideas()

        # Stage 0: 조건부 표시 (output/ideas/에 파일이 있을 때만)
        if include_stage_0:
            is_completed, files = self.check_stage(self.STAGE_0)
            if is_completed:
                completed_count += 1
            results.append({
                "id": self.STAGE_0["id"],
                "name": self.STAGE_0["name"],
                "completed": is_completed,
                "files": files,
            })

        for stage in self.STAGES:
            is_completed, files = self.check_stage(stage)

            if is_completed:
                completed_count += 1

            results.append({
                "id": stage["id"],
                "name": stage["name"],
                "completed": is_completed,
                "files": files,
            })

        total_stages = len(self.STAGES) + (1 if include_stage_0 else 0)
        percentage = (completed_count / total_stages * 100) if total_stages > 0 else 0

        return {
            "total_stages": total_stages,
            "completed_stages": completed_count,
            "percentage": round(percentage, 1),
            "stages": results,
            "includes_stage_0": include_stage_0,
        }

    def get_next_stage(self, progress: Dict) -> Dict | None:
        """
        다음으로 진행해야 할 단계를 추천합니다.

        Args:
            progress: check_all_stages()의 반환값

        Returns:
            다음 단계 정보 또는 None (모두 완료된 경우)
        """
        for stage in progress["stages"]:
            if not stage["completed"]:
                return stage
        return None

    def print_progress_bar(self, percentage: float, width: int = 40) -> str:
        """
        텍스트 기반 프로그레스 바를 생성합니다.

        Args:
            percentage: 진행률 (0-100)
            width: 바의 너비

        Returns:
            프로그레스 바 문자열
        """
        filled = int(width * percentage / 100)
        bar = "█" * filled + "░" * (width - filled)
        return f"[{bar}] {percentage:.1f}%"

    def print_text_report(self, progress: Dict):
        """
        텍스트 형식으로 진행 상황을 출력합니다.

        Args:
            progress: check_all_stages()의 반환값
        """
        print("\n" + "=" * 60)
        print("📊 사업 기획 진행률 리포트")
        print("=" * 60 + "\n")

        # 전체 진행률
        print(f"전체 진행률: {progress['completed_stages']}/{progress['total_stages']} 단계 완료")
        print(self.print_progress_bar(progress["percentage"]))
        print()

        # 각 단계별 상태
        print("단계별 현황:")
        print("-" * 60)

        for stage in progress["stages"]:
            status = "✅" if stage["completed"] else "⬜"
            print(f"{status} {stage['id']}. {stage['name']}")

            if stage["completed"] and stage["files"]:
                print(f"   📁 발견된 파일: {len(stage['files'])}개")
                for file in stage["files"][:3]:  # 최대 3개까지만 표시
                    print(f"      - {file}")
                if len(stage["files"]) > 3:
                    print(f"      ... 외 {len(stage['files']) - 3}개")
            print()

        # 다음 단계 추천
        print("-" * 60)
        next_stage = self.get_next_stage(progress)

        if next_stage:
            stage_id = next_stage['id']
            if stage_id == 0:
                print(f"💡 다음 단계: {stage_id}. {next_stage['name']}")
                print(f"   /idea-discovery 또는 /idea-validation 을 실행하세요.")
            else:
                all_stages = [self.STAGE_0] + self.STAGES if progress.get("includes_stage_0") else self.STAGES
                stage_def = next((s for s in all_stages if s["id"] == stage_id), None)
                directory = stage_def["directory"] if stage_def else "output/"
                print(f"💡 다음 단계: {stage_id}. {next_stage['name']}")
                print(f"   해당 단계의 산출물을 {directory}에 생성하세요.")
        else:
            print("🎉 축하합니다! 모든 단계가 완료되었습니다!")

        print("=" * 60 + "\n")

    # ------------------------------------------------------------------
    # Multi-idea portfolio methods
    # ------------------------------------------------------------------

    def is_multi_mode(self) -> bool:
        """
        output/ideas/ 하위에 idea.json을 포함한 아이디어 폴더가 있는지 확인합니다.

        Returns:
            멀티 아이디어 모드 여부
        """
        return len(self.discover_ideas()) > 0

    def discover_ideas(self) -> List[Path]:
        """
        output/ideas/ 하위 폴더를 Shallow Scan하여 idea.json이 있는 폴더 목록을 반환합니다.

        Returns:
            idea.json이 존재하는 디렉토리 Path 리스트 (이름순 정렬)
        """
        ideas_root = self.project_dir / "output" / "ideas"
        if not ideas_root.exists():
            return []

        idea_dirs = []
        for child in sorted(ideas_root.iterdir()):
            if child.is_dir() and (child / "idea.json").exists():
                idea_dirs.append(child)
        return idea_dirs

    # v2.0 judgment badge mapping
    JUDGMENT_BADGES = {
        "go": "✅ Go",
        "pivot-optimize": "🔧 Pivot(최적화)",
        "pivot-review": "🔍 Pivot(재검토)",
        "drop": "❌ Drop",
        # v1.0 legacy
        "pivot": "🔄 Pivot",
    }

    def _load_idea_meta(self, idea_dir: Path) -> Dict:
        """
        idea.json을 읽어 메타 정보를 반환합니다.
        파싱 실패 시 기본값을 반환합니다.
        v2.0 필드가 있으면 검증하고 없는 필드는 경고만 출력합니다.
        """
        meta_path = idea_dir / "idea.json"
        defaults = {
            "id": idea_dir.name,
            "name": idea_dir.name,
            "created": "",
            "status": "",
            "score": None,
        }
        try:
            with open(meta_path, "r", encoding="utf-8") as f:
                data = json.load(f)
            for key in defaults:
                if key not in data:
                    data[key] = defaults[key]
            # v2.0 field validation
            if data.get("workflow_version") == "2.0":
                v2_fields = ["kill_switch", "psst_mapping", "founder_fit_reason", "current_alternatives"]
                for field in v2_fields:
                    if field not in data:
                        print(f"⚠️  v2.0 필드 누락 ({idea_dir.name}): {field}", file=sys.stderr)
            return data
        except (json.JSONDecodeError, OSError):
            return defaults

    def _check_idea_stage_local(
        self, idea_dir: Path, stage: Dict
    ) -> Tuple[bool, List[str]]:
        """
        아이디어 폴더 내부에서 특정 단계의 완료 여부를 확인합니다.
        """
        directory = idea_dir / stage["directory"]
        if not directory.exists():
            return False, []

        found_files = []
        keywords = stage["keywords"]
        for file_path in directory.rglob("*"):
            if file_path.is_file():
                filename_lower = file_path.name.lower()
                if any(kw.lower() in filename_lower for kw in keywords):
                    found_files.append(
                        str(file_path.relative_to(self.project_dir))
                    )
        return len(found_files) > 0, found_files

    def check_idea_stages(self, idea_dir: Path) -> Dict:
        """
        특정 아이디어 폴더 내에서 Stage 0-8 진행률을 계산합니다.

        Args:
            idea_dir: 아이디어 폴더 경로 (absolute)

        Returns:
            아이디어 진행률 딕셔너리
        """
        meta = self._load_idea_meta(idea_dir)
        stages: List[Dict] = []
        completed_count = 0

        # Stage 0: hypothesis.md or evaluation.md
        stage0_files = []
        for fname in self.IDEA_STAGE_0_FILES:
            fpath = idea_dir / fname
            if fpath.exists():
                stage0_files.append(str(fpath.relative_to(self.project_dir)))
        stage0_done = len(stage0_files) > 0
        if stage0_done:
            completed_count += 1
        stages.append({
            "id": 0,
            "name": "아이디어 발굴",
            "completed": stage0_done,
            "files": stage0_files,
        })

        # Stages 1-8
        for stage_def in self.IDEA_STAGES:
            is_done, files = self._check_idea_stage_local(idea_dir, stage_def)
            if is_done:
                completed_count += 1
            stages.append({
                "id": stage_def["id"],
                "name": stage_def["name"],
                "completed": is_done,
                "files": files,
            })

        total = 9  # Stage 0 + 8 stages
        percentage = (completed_count / total * 100) if total > 0 else 0

        return {
            "idea_dir": str(idea_dir.relative_to(self.project_dir)),
            "meta": meta,
            "total_stages": total,
            "completed_stages": completed_count,
            "percentage": round(percentage, 1),
            "stages": stages,
        }

    def check_portfolio(self) -> Dict:
        """
        모든 아이디어의 요약 정보를 반환합니다.

        Returns:
            포트폴리오 딕셔너리
        """
        idea_dirs = self.discover_ideas()
        ideas = []
        status_counts: Dict[str, int] = {}

        for idea_dir in idea_dirs:
            idea_progress = self.check_idea_stages(idea_dir)
            ideas.append(idea_progress)
            # v2.0: prefer judgment field; fall back to status for v1.0 compat
            judgment = idea_progress["meta"].get("judgment") or idea_progress["meta"].get("status") or ""
            status_key = judgment.lower() if judgment else "미평가"
            status_counts[status_key] = status_counts.get(status_key, 0) + 1

        return {
            "total_ideas": len(ideas),
            "status_counts": status_counts,
            "ideas": ideas,
        }

    def _find_idea_dir(self, idea_id_or_path: str) -> Optional[Path]:
        """
        --idea 인수로부터 아이디어 폴더를 찾습니다.
        idea_id_or_path가 절대/상대 경로이거나, idea id prefix일 수 있습니다.
        """
        # Try as a direct path
        candidate = Path(idea_id_or_path)
        if candidate.is_absolute() and candidate.is_dir() and (candidate / "idea.json").exists():
            return candidate
        # Try relative to project_dir
        candidate = self.project_dir / idea_id_or_path
        if candidate.is_dir() and (candidate / "idea.json").exists():
            return candidate
        # Try matching under output/ideas/
        ideas_root = self.project_dir / "output" / "ideas"
        if ideas_root.exists():
            for child in sorted(ideas_root.iterdir()):
                if child.is_dir() and (child / "idea.json").exists():
                    # Match by folder name or id prefix
                    if child.name == idea_id_or_path or child.name.startswith(idea_id_or_path):
                        return child
        return None

    def _current_stage_name(self, idea_progress: Dict) -> str:
        """
        아이디어의 현재 진행 중인 단계(마지막 완료 단계 다음) 이름을 반환합니다.
        """
        last_completed_id = -1
        for stage in idea_progress["stages"]:
            if stage["completed"]:
                last_completed_id = stage["id"]
        # Find the next incomplete stage name
        for stage in idea_progress["stages"]:
            if not stage["completed"]:
                return stage["name"]
        return "완료"

    def _judgment_badge(self, status: str) -> str:
        """
        judgment/status 값에 대응하는 배지 문자열을 반환합니다.
        """
        return self.JUDGMENT_BADGES.get(status.lower(), status) if status else "미평가"

    def print_idea_report(self, idea_progress: Dict):
        """
        특정 아이디어의 진행률 리포트를 텍스트로 출력합니다.
        """
        meta = idea_progress["meta"]
        name = meta.get("name", idea_progress["idea_dir"])
        judgment = meta.get("judgment") or meta.get("status") or ""
        status = self._judgment_badge(judgment) if judgment else "미평가"
        score = meta.get("score")
        if score is not None:
            display_score = score * 4 if score <= 25 else score
            score_str = f"{display_score}/100"
        else:
            score_str = "미평가"

        print("\n" + "=" * 60)
        print(f"📊 아이디어 진행률: {name}")
        print("=" * 60 + "\n")
        print(f"  상태: {status}  |  점수: {score_str}")
        print(f"  전체 진행률: {idea_progress['completed_stages']}/{idea_progress['total_stages']} 단계 완료")
        print(f"  {self.print_progress_bar(idea_progress['percentage'])}")
        print()

        print("단계별 현황:")
        print("-" * 60)
        for stage in idea_progress["stages"]:
            icon = "✅" if stage["completed"] else "⬜"
            print(f"  {icon} {stage['id']}. {stage['name']}")
            if stage["completed"] and stage["files"]:
                for file in stage["files"][:3]:
                    print(f"      - {file}")
                if len(stage["files"]) > 3:
                    print(f"      ... 외 {len(stage['files']) - 3}개")
        print("=" * 60 + "\n")

    def print_portfolio_report(self, portfolio: Dict):
        """
        포트폴리오 모드 텍스트 리포트를 출력합니다.
        """
        ideas = portfolio["ideas"]
        total = portfolio["total_ideas"]
        counts = portfolio["status_counts"]

        go = counts.get("go", 0)
        pivot_opt = counts.get("pivot-optimize", 0)
        pivot_rev = counts.get("pivot-review", 0)
        pivot_legacy = counts.get("pivot", 0)
        drop = counts.get("drop", 0)
        rated = go + pivot_opt + pivot_rev + pivot_legacy + drop
        unrated = total - rated

        print("\n" + "=" * 60)
        print("📊 사업 아이디어 포트폴리오")
        print("=" * 60 + "\n")
        summary_parts = [f"총 아이디어: {total}개", f"Go: {go}"]
        if pivot_opt > 0:
            summary_parts.append(f"Pivot(최적화): {pivot_opt}")
        if pivot_rev > 0:
            summary_parts.append(f"Pivot(재검토): {pivot_rev}")
        if pivot_legacy > 0:
            summary_parts.append(f"Pivot: {pivot_legacy}")
        summary_parts.append(f"Drop: {drop}")
        if unrated > 0:
            summary_parts.append(f"미평가: {unrated}")
        print(" | ".join(summary_parts))
        print()

        for idx, idea in enumerate(ideas, 1):
            meta = idea["meta"]
            name = meta.get("name", "")
            judgment = meta.get("judgment") or meta.get("status") or ""
            badge = self._judgment_badge(judgment) if judgment else "미평가"
            score = meta.get("score")
            completed = idea["completed_stages"]
            # Stage 0 is not counted in 1-8 progress display
            stages_1_8_done = sum(
                1 for s in idea["stages"] if s["id"] > 0 and s["completed"]
            )
            total_1_8 = 8
            pct_1_8 = stages_1_8_done / total_1_8 * 100 if total_1_8 > 0 else 0

            if score is not None:
                display_score = score * 4 if score <= 25 else score
                label = f"{badge} {display_score}/100"
            else:
                label = "미평가"

            bar_width = 10
            filled = int(bar_width * pct_1_8 / 100)
            bar = "█" * filled + "░" * (bar_width - filled)

            current_stage = self._current_stage_name(idea)
            print(
                f"  {idx}. {name} [{label}] {bar} {pct_1_8:.1f}% ({stages_1_8_done}/{total_1_8})"
            )

        print("\n" + "=" * 60 + "\n")

    def generate_portfolio_md(self, portfolio: Dict):
        """
        output/ideas/portfolio.md를 생성/업데이트합니다.
        기존 파일이 있으면 AUTO:START~AUTO:END 영역만 교체합니다.
        """
        portfolio_path = self.project_dir / "output" / "ideas" / "portfolio.md"
        ideas = portfolio["ideas"]

        # Build the auto-generated table
        lines = []
        lines.append("| # | 아이디어 | 상태 | 점수 | 진행 단계 | 생성일 |")
        lines.append("|---|----------|------|------|-----------|--------|")
        for idx, idea in enumerate(ideas, 1):
            meta = idea["meta"]
            name = meta.get("name", "")
            judgment = meta.get("judgment") or meta.get("status") or ""
            badge = self._judgment_badge(judgment) if judgment else "미평가"
            score = meta.get("score")
            if score is not None:
                display_score = score * 4 if score <= 25 else score
                score_str = f"{display_score}/100"
            else:
                score_str = "-"
            stages_1_8_done = sum(
                1 for s in idea["stages"] if s["id"] > 0 and s["completed"]
            )
            current_stage = self._current_stage_name(idea)
            created = meta.get("created", "")
            lines.append(
                f"| {idx} | {name} | {badge} | {score_str} | {stages_1_8_done}/8 ({current_stage}) | {created} |"
            )

        auto_content = "\n".join(lines)
        auto_block = f"<!-- AUTO:START - 이 영역은 자동 생성됩니다. 편집하지 마세요. -->\n{auto_content}\n<!-- AUTO:END -->"

        if portfolio_path.exists():
            existing = portfolio_path.read_text(encoding="utf-8")
            # Replace AUTO:START~AUTO:END block
            pattern = r"<!-- AUTO:START.*?-->.*?<!-- AUTO:END -->"
            if re.search(pattern, existing, re.DOTALL):
                new_content = re.sub(pattern, auto_block, existing, flags=re.DOTALL)
            else:
                # No auto block found, prepend after first heading or at top
                new_content = existing + "\n\n" + auto_block + "\n"
        else:
            # Create new file
            portfolio_path.parent.mkdir(parents=True, exist_ok=True)
            new_content = f"""# 사업 아이디어 포트폴리오

{auto_block}

## 나의 메모
(이 영역은 자유롭게 편집하세요)
"""

        portfolio_path.write_text(new_content, encoding="utf-8")
        return str(portfolio_path.relative_to(self.project_dir))


def main():
    """메인 함수"""
    parser = argparse.ArgumentParser(
        description="사업 기획 진행률을 확인합니다.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
사용 예시:
  %(prog)s                    # 현재 디렉토리 기준으로 진행률 확인
  %(prog)s --json             # JSON 형식으로 출력
  %(prog)s --dir /path/to/project  # 특정 디렉토리의 진행률 확인
  %(prog)s --idea idea-001    # 특정 아이디어의 진행률 확인
  %(prog)s --portfolio        # 전체 포트폴리오 대시보드
        """,
    )

    parser.add_argument(
        "--dir",
        "-d",
        default=None,
        help="프로젝트 디렉토리 경로 (기본값: 스크립트의 3단계 상위 디렉토리)",
    )

    parser.add_argument(
        "--json",
        "-j",
        action="store_true",
        help="JSON 형식으로 출력",
    )

    parser.add_argument(
        "--idea",
        default=None,
        help="특정 아이디어의 진행률만 표시 (아이디어 ID 또는 경로)",
    )

    parser.add_argument(
        "--portfolio",
        action="store_true",
        help="전체 아이디어 요약 대시보드 + portfolio.md 자동생성",
    )

    args = parser.parse_args()

    # 프로젝트 디렉토리 결정
    if args.dir:
        project_dir = args.dir
    else:
        # 스크립트의 4단계 상위 디렉토리 (../../../.. from scripts/)
        # scripts/ → progress-tracker/ → skills/ → .agent/ → project root
        script_path = Path(__file__).resolve()
        project_dir = script_path.parent.parent.parent.parent.parent

    tracker = ProgressTracker(project_dir)

    # --idea: 특정 아이디어 모드
    if args.idea:
        idea_dir = tracker._find_idea_dir(args.idea)
        if idea_dir is None:
            print(f"오류: 아이디어를 찾을 수 없습니다: {args.idea}", file=sys.stderr)
            sys.exit(2)
        idea_progress = tracker.check_idea_stages(idea_dir)
        if args.json:
            print(json.dumps(idea_progress, ensure_ascii=False, indent=2))
        else:
            tracker.print_idea_report(idea_progress)
        sys.exit(0 if idea_progress["percentage"] == 100.0 else 1)

    # --portfolio: 포트폴리오 모드
    if args.portfolio:
        portfolio = tracker.check_portfolio()
        if portfolio["total_ideas"] == 0:
            print("아이디어 폴더가 없습니다. output/ideas/ 하위에 idea.json을 포함한 폴더를 생성하세요.", file=sys.stderr)
            sys.exit(2)
        md_path = tracker.generate_portfolio_md(portfolio)
        if args.json:
            portfolio["portfolio_md"] = md_path
            print(json.dumps(portfolio, ensure_ascii=False, indent=2))
        else:
            tracker.print_portfolio_report(portfolio)
            print(f"  📄 portfolio.md 생성: {md_path}\n")
        sys.exit(0)

    # 인수 없이 실행: 자동 모드 전환
    if tracker.is_multi_mode():
        # 멀티 모드 -> 포트폴리오 표시
        portfolio = tracker.check_portfolio()
        md_path = tracker.generate_portfolio_md(portfolio)
        if args.json:
            portfolio["portfolio_md"] = md_path
            print(json.dumps(portfolio, ensure_ascii=False, indent=2))
        else:
            tracker.print_portfolio_report(portfolio)
            print(f"  📄 portfolio.md 생성: {md_path}\n")
        sys.exit(0)
    else:
        # 레거시 모드 -> 기존 동작
        progress = tracker.check_all_stages()
        if args.json:
            print(json.dumps(progress, ensure_ascii=False, indent=2))
        else:
            tracker.print_text_report(progress)
        sys.exit(0 if progress["percentage"] == 100.0 else 1)


if __name__ == "__main__":
    main()
