# Changelog

이 프로젝트의 주요 변경 사항을 기록합니다. 형식은 [Keep a Changelog](https://keepachangelog.com/ko/1.1.0/)를 따르고, 버전은 [Semantic Versioning](https://semver.org/lang/ko/)을 따릅니다.

## [0.3.0] - 2026-05-30

### Added
- 기본 CLAUDE.md 자동 배포: SessionStart 훅(`hooks/hooks.json` + `scripts/ensure-claude-md.sh`)이 프로젝트에 CLAUDE.md가 없으면 번들된 행동 가이드라인을 자동 설치(비파괴 — 기존 파일은 건드리지 않음).
- 번들 콘텐츠 `templates/CLAUDE.md`를 Andrej Karpathy 계열 행동 가이드라인(출처: `forrestchang/andrej-karpathy-skills`, MIT)으로 교체하고, 상단에 MIT 고지 헤더를 동봉(모든 사본에 라이선스 동반).
- `THIRD_PARTY_LICENSES.md` — Apache-2.0 프로젝트에 번들된 MIT 제3자 콘텐츠를 명시(출처·저작권·번들 시점 스냅샷).

### Changed
- 위저드(`setup-harness`)가 기존 CLAUDE.md를 감지하면 통합 방식을 4지선다 대화형으로 제공(유지 / 교체+백업 / 기존을 `.claude/HARNESS.md`로 이전+참조 / 덮어쓰기). 없으면 무조건 설치.
- 프로젝트 컨텍스트(Commands/Stack/Rules)는 가이드라인 아래 append 블록으로 분리.

## [0.2.0] - 2026-05-30

### Added
- 복사-사용 템플릿 세트 `templates/` — 프로젝트 스코프 14개 항목 전체(루트 + `.claude/`)를 타깃 레이아웃 그대로 미러. 핵심(CLAUDE.md·settings.json)부터 고급(.mcp.json·agents·skills·commands·output-styles·worktreeinclude·개인용 파일)까지.
- 범용 가이드 `docs/project-setup-guide.md` — 각 항목의 역할·로드 시점·커밋 여부·설정 시점·템플릿 경로 정리.

### Changed
- `setup-harness` 위저드를 고급 항목까지 다루도록 확장: Step 4를 전문화/설정 파일 다중 선택으로, 생성은 `templates/` 원본 파일을 읽어 치환하도록 변경.
- `references/templates.md`를 인덱스+채움 규칙으로 재구성(중복 스니펫 제거), `question-flow.md`·`concepts.md`를 고급 항목까지 확장.

## [0.1.0] - 2026-05-30

### Added
- 초보자용 대화형 프로젝트 세팅 위저드 `setup-harness` 스킬 (`/setup-harness`).
- 적응형 깊이 선택(기본/표준/확장)에 따른 프로젝트 스코프 `.claude/` 설정 생성.
- 참조 문서: 질문 흐름(`question-flow.md`), 생성 템플릿(`templates.md`), 초보자 용어집(`concepts.md`).
- 플러그인 매니페스트(`plugin.json`)와 마켓플레이스(`marketplace.json`).
