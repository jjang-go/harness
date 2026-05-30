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

## 구조

```
harness/
├── .claude-plugin/
│   ├── marketplace.json
│   └── plugin.json
└── skills/
    └── setup-harness/
        ├── SKILL.md
        └── references/
            ├── question-flow.md   # 질문 트리·분기
            ├── templates.md       # 생성 파일 템플릿
            └── concepts.md        # 초보자 용어집
```

## 라이선스

Apache-2.0
