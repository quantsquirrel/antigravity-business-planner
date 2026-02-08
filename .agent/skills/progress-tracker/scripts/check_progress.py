#!/usr/bin/env python3
"""
사업 기획 진행률 추적 스크립트

8단계 기획 프로세스의 진행 상황을 output/ 디렉토리를 기반으로 추적합니다.
"""

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Dict, List, Tuple


class ProgressTracker:
    """사업 기획 진행률 추적기"""

    # 8단계 기획 프로세스 정의
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

    def check_all_stages(self) -> Dict:
        """
        모든 단계의 진행 상황을 확인합니다.

        Returns:
            진행률 정보를 담은 딕셔너리
        """
        results = []
        completed_count = 0

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

        total_stages = len(self.STAGES)
        percentage = (completed_count / total_stages * 100) if total_stages > 0 else 0

        return {
            "total_stages": total_stages,
            "completed_stages": completed_count,
            "percentage": round(percentage, 1),
            "stages": results,
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
            print(f"💡 다음 단계: {next_stage['id']}. {next_stage['name']}")
            print(f"   해당 단계의 산출물을 {self.STAGES[next_stage['id']-1]['directory']}에 생성하세요.")
        else:
            print("🎉 축하합니다! 모든 단계가 완료되었습니다!")

        print("=" * 60 + "\n")


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

    args = parser.parse_args()

    # 프로젝트 디렉토리 결정
    if args.dir:
        project_dir = args.dir
    else:
        # 스크립트의 3단계 상위 디렉토리 (../../.. from scripts/)
        script_path = Path(__file__).resolve()
        project_dir = script_path.parent.parent.parent.parent

    # 진행률 추적기 생성 및 실행
    tracker = ProgressTracker(project_dir)
    progress = tracker.check_all_stages()

    # 출력
    if args.json:
        print(json.dumps(progress, ensure_ascii=False, indent=2))
    else:
        tracker.print_text_report(progress)

    # 종료 코드: 모든 단계 완료 시 0, 아니면 1
    sys.exit(0 if progress["percentage"] == 100.0 else 1)


if __name__ == "__main__":
    main()
