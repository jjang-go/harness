# Harness Starter

초보자를 위한 **대화형 프로젝트 세팅 위저드** Claude Code 플러그인.

`/setup-harness`를 호출하면 다지선다 질문이 단계별로 떠서, 타이핑이나 전문용어 없이 클릭만으로 프로젝트에 맞는 `.claude/` 설정을 만들어 줍니다. 모든 결과물은 **프로젝트 스코프**(이 저장소의 `CLAUDE.md`와 `.claude/`)로 생성됩니다.

## 무엇을 만들어 주나요

깊이를 선택하면 그만큼만 적응형으로 생성합니다.

| 깊이 | 생성물 |
|------|--------|
| 기본 | `CLAUDE.md` + `.claude/settings.json` (권한) |
| 표준 | 기본 + `.claude/rules/*.md` (주제별 규칙) |
| 확장 | 표준 + 스타터 `agents/`·`skills/` |

특징
- **기본 CLAUDE.md 자동 세팅** — 플러그인이 켜진 프로젝트에 `CLAUDE.md`가 없으면, 세션 시작 시 번들된 행동 가이드라인을 자동 설치(비파괴). 이미 있으면 건드리지 않고, `/setup-harness`에서 통합 옵션을 제공.
- **적응형** — 목표/깊이를 물어 필요한 만큼만 생성
- **자동 감지** — 빌드/테스트/린트 명령을 추론해 확인만 받음
- **무단 변경 금지** — 기존 설정은 보존하고 빠진 부분만 보완
- **쓰기 전 미리보기** + **진행하며 설명** (초보자 학습용)

## 사용법

플러그인이 설치된 상태에서:

```
/setup-harness
```

깊이를 바로 지정할 수도 있습니다: `/setup-harness 표준`

## 로컬 설치 / 테스트

이 저장소를 클론한 뒤, 플러그인 디렉터리로 지정해 Claude Code를 실행합니다:

```bash
claude --plugin-dir /path/to/harness
```

또는 마켓플레이스로 추가해 설치합니다(프로젝트 스코프 예시):

```bash
claude plugin install harness-starter@harness-starter-marketplace --scope project
```

매니페스트 검증:

```bash
claude plugin validate /path/to/harness --strict
```

## 직접 세팅하고 싶다면 (대화 없이)

위저드 대신 손으로 설정하고 싶다면, 복사-사용 템플릿과 범용 가이드를 제공합니다.

- **범용 가이드**: [docs/project-setup-guide.md](docs/project-setup-guide.md) — 프로젝트 스코프 `.claude` 항목 전체(핵심~고급)의 역할·로드 시점·커밋 여부·설정 시점 정리.
- **복사-사용 템플릿**: [templates/](templates/) — 타깃 레이아웃 그대로 미러. 프로젝트로 복사 후 `{{...}}`만 채우면 됩니다.

```bash
cp -R templates/. /path/to/your-project/   # 필요 없는 파일은 지우고 {{...}} 채우기
```

## 구조

```
harness/
├── .claude-plugin/
│   ├── marketplace.json
│   └── plugin.json
├── hooks/
│   └── hooks.json              # SessionStart: 기본 CLAUDE.md 자동 세팅
├── scripts/
│   └── ensure-claude-md.sh     # 없으면 설치, 있으면 무변경 (비파괴)
├── templates/                  # 복사-사용 스타터 (프로젝트 루트 + .claude/ 미러)
│   ├── CLAUDE.md               # Karpathy 행동 가이드라인 + MIT 고지 헤더 (기본 배포)
│   ├── CLAUDE.local.md, .mcp.json, .worktreeinclude
│   └── .claude/                # settings(.local).json, rules, agents, skills,
│                               #   commands, output-styles, workflows·agent-memory 안내
├── docs/
│   └── project-setup-guide.md  # 범용 프로젝트 세팅 가이드
├── skills/
│   └── setup-harness/
│       ├── SKILL.md
│       └── references/         # question-flow / templates / concepts
├── THIRD_PARTY_LICENSES.md     # 번들된 MIT 제3자 콘텐츠 고지
└── LICENSE                     # Apache-2.0
```

## 라이선스

이 플러그인은 **Apache-2.0**입니다.

번들된 기본 `templates/CLAUDE.md`는 제3자 콘텐츠로 **MIT 라이선스**입니다 — 출처: [`multica-ai/andrej-karpathy-skills`](https://github.com/multica-ai/andrej-karpathy-skills) (원저자 forrestchang). MIT 고지는 해당 파일 상단 헤더와 [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md)에 동봉되어, 플러그인이 사용자 프로젝트에 써넣는 모든 사본에 라이선스가 동반됩니다.
