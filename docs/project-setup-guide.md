# 프로젝트 단위 Claude Code 세팅 가이드

어느 프로젝트에나 적용할 수 있는 **프로젝트 스코프** `.claude` 설정 항목 전체(핵심~고급)를 정리한 범용 가이드다. 각 항목이 무엇이고, 언제 로드되며, 커밋 대상인지, 언제 설정하면 좋은지를 한곳에 모았다. 바로 복사해 쓸 수 있는 스타터는 이 저장소의 [`templates/`](../templates/)에 있다.

> 모든 설정은 **프로젝트 스코프**(이 저장소의 `CLAUDE.md`와 `.claude/`) 기준이다. 내 모든 프로젝트에 적용되는 개인 설정(`~/.claude/`, 글로벌 스코프)은 다루지 않는다.

## 목차
1. [빠른 시작](#빠른-시작)
2. [우선순위: 무엇부터](#우선순위-무엇부터)
3. [항목 레퍼런스 — 저장소 루트](#항목-레퍼런스--저장소-루트)
4. [항목 레퍼런스 — `.claude/`](#항목-레퍼런스--claude)
5. [자동 생성 항목](#자동-생성-항목)
6. [커밋 vs gitignore 요약](#커밋-vs-gitignore-요약)

---

## 빠른 시작

1. 이 저장소의 `templates/` 내용을 내 프로젝트 루트로 복사한다.
   ```bash
   cp -R templates/. /path/to/your-project/
   ```
   (`templates/.claude/`까지 함께 복사된다.)
2. **필요 없는 파일/폴더는 지운다.** 대부분 `CLAUDE.md` + `.claude/settings.json`만으로 시작해도 충분하다.
3. 각 파일의 `{{...}}` 자리표시자를 실제 값으로 채운다 (예: `{{BUILD}}` → `npm run build`). 값이 없는 명령 줄은 지운다.
4. 개인용 파일(`CLAUDE.local.md`, `.claude/settings.local.json`)은 `.gitignore`에 추가한다.

> ⚠️ `.claude/settings.json`의 `hooks` 블록은 **자동 포매터가 있을 때만** 쓴다. 포매터(prettier 등)가 없으면 `hooks` 블록 전체를 삭제하라 — `{{FORMATTER}}`를 그대로 두면 매 편집마다 훅이 실패한다.

> 대화형으로 채우고 싶다면, 이 저장소의 `harness-starter` 플러그인에서 `/setup-harness`를 호출하면 위 과정을 질문으로 안내·생성해 준다.

## 우선순위: 무엇부터

| 분류 | 항목 | 권장도 |
|------|------|--------|
| **핵심** | `CLAUDE.md`, `.claude/settings.json` | 거의 모든 프로젝트 |
| **선택** | `.claude/rules/`, `.claude/settings.local.json`, `CLAUDE.local.md`, `.mcp.json` | 필요해질 때 |
| **고급** | `.claude/agents/`, `.claude/skills/`, `.claude/commands/`, `.claude/output-styles/`, `.claude/workflows/`, `.worktreeinclude` | 자동화·전문화 단계 |
| **자동** | `.claude/agent-memory/`, `.claude/agent-memory-local/` | 서브에이전트가 생성 |

> 문서 권고: "대부분의 사용자는 `CLAUDE.md`와 `settings.json`만 편집한다." 작게 시작해 필요할 때 늘리는 것이 안전하다.

---

## 항목 레퍼런스 — 저장소 루트

`.claude/` 밖, 프로젝트 루트에 두는 파일들이다.

### `CLAUDE.md` · 핵심 · committed
- **역할:** 프로젝트 지침서(자주 쓰는 명령, 스택, 규칙).
- **로드:** 매 세션 시작 시 항상.
- **언제:** 거의 모든 프로젝트의 출발점. 200줄 넘으면 `rules/`로 분리.
- **템플릿:** [`templates/CLAUDE.md`](../templates/CLAUDE.md) · 편집: `/memory`

### `CLAUDE.local.md` · 선택 · gitignore(수동)
- **역할:** 나만 쓰는 개인용 프로젝트 지침(`CLAUDE.md`와 함께 로드).
- **언제:** 개인 메모/경로/디버깅 노트가 필요할 때. 반드시 `.gitignore`에 추가.
- **템플릿:** [`templates/CLAUDE.local.md`](../templates/CLAUDE.local.md)

### `.mcp.json` · 선택 · committed
- **역할:** 팀이 공유하는 MCP 서버(외부 도구: DB·API·브라우저 등) 정의.
- **로드:** 세션 시작 시 서버 연결(도구 스키마는 필요 시 로드).
- **언제:** 외부 도구 연동이 필요할 때. 시크릿은 `${ENV_VAR}` 참조로 두고 파일에 직접 쓰지 않는다.
- **템플릿:** [`templates/.mcp.json`](../templates/.mcp.json)

### `.worktreeinclude` · 고급 · committed
- **역할:** git worktree 생성 시 새 worktree로 복사할 gitignored 파일 목록(`.env` 등).
- **로드:** worktree 생성 시(`--worktree`, `isolation: worktree`).
- **언제:** worktree를 자주 쓰고 untracked 설정 파일이 필요할 때.
- **템플릿:** [`templates/.worktreeinclude`](../templates/.worktreeinclude)

---

## 항목 레퍼런스 — `.claude/`

### `.claude/settings.json` · 핵심 · committed
- **역할:** 권한(permissions)·훅(hooks)·env·model 기본값. CLAUDE.md가 "권유"라면 이건 **강제**된다.
- **로드:** 항상 적용. 로컬/CLI/관리설정이 이 위에 우선.
- **언제:** 자주 쓰는 안전 명령 자동 허용, 위험 명령 차단, 편집 후 자동 포맷 등.
- **템플릿:** [`templates/.claude/settings.json`](../templates/.claude/settings.json) · 편집: `/config` 또는 직접

### `.claude/settings.local.json` · 선택 · gitignore(자동)
- **역할:** `settings.json`을 덮어쓰는 개인 설정(동일 스키마).
- **언제:** 팀 설정과 다른 개인 권한/기본값이 필요할 때. 배열(`permissions.allow`)은 스코프 간 합쳐진다.
- **템플릿:** [`templates/.claude/settings.local.json`](../templates/.claude/settings.local.json)

### `.claude/rules/*.md` · 선택 · committed
- **역할:** 주제별 규칙 파일. `paths:` 프런트매터로 **조건부 로드** 가능.
- **로드:** `paths:` 없으면 세션 시작 시, 있으면 매칭 파일을 열 때만.
- **언제:** CLAUDE.md가 길어질 때, 또는 특정 파일군에만 적용할 규칙이 있을 때.
- **템플릿:** [`templates/.claude/rules/`](../templates/.claude/rules/) (`testing.md`, `code-style.md`)

### `.claude/skills/<name>/SKILL.md` · 고급 · committed
- **역할:** `/이름`으로 부르거나 Claude가 자동 호출하는 재사용 작업. 지원 파일 번들 가능.
- **로드:** 호출 또는 작업 매칭 시(메타데이터는 항상 컨텍스트에 존재).
- **언제:** 반복 작업을 단축 명령으로 만들 때.
- **템플릿:** [`templates/.claude/skills/run-checks/`](../templates/.claude/skills/run-checks/)

### `.claude/commands/*.md` · 고급 · committed
- **역할:** 단일 파일 커맨드(`/이름`). skills와 같은 메커니즘.
- **언제:** 새 작업이면 **skills 권장**. 커맨드는 레거시 호환용.
- **템플릿:** [`templates/.claude/commands/example.md`](../templates/.claude/commands/example.md)

### `.claude/agents/*.md` · 고급 · committed
- **역할:** 자체 컨텍스트에서 도는 서브에이전트(고유 시스템 프롬프트·도구 제한).
- **로드:** 위임/호출 시 새 컨텍스트에서 실행.
- **언제:** 코드 리뷰·조사 등 메인 대화와 분리할 전문 작업이 있을 때. `tools:`로 권한 제한.
- **템플릿:** [`templates/.claude/agents/code-reviewer.md`](../templates/.claude/agents/code-reviewer.md)

### `.claude/output-styles/*.md` · 고급 · committed(팀 공유 시)
- **역할:** 시스템 프롬프트에 덧붙는 출력 스타일(교육 모드, 리뷰 모드 등).
- **로드:** `outputStyle` 선택 시 세션 시작에 적용.
- **언제:** 팀이 공유하는 응답 스타일이 있을 때(보통은 개인용이라 `~/.claude/`).
- **템플릿:** [`templates/.claude/output-styles/teaching.md`](../templates/.claude/output-styles/teaching.md)

### `.claude/workflows/*.js` · 고급 · committed
- **역할:** 여러 서브에이전트를 조율하는 동적 워크플로우. 각 파일이 `/<이름>` 커맨드가 된다.
- **만드는 법:** 손으로 작성하지 않는다. `/workflows` 실행 결과를 `s`로 저장.
- **안내:** [`templates/.claude/workflows/README.md`](../templates/.claude/workflows/README.md)

---

## 자동 생성 항목

서브에이전트가 스스로 만들고 갱신한다. 사람이 작성하지 않는다.

### `.claude/agent-memory/<name>/MEMORY.md` · committed
- 에이전트 정의에 `memory: project`를 설정하면 생성. 에이전트가 세션 간 지식을 누적.

### `.claude/agent-memory-local/` · gitignore
- `memory: local` 일 때의 저장 위치(개인용). `.gitignore`에 추가.

> `memory:` 설정법과 저장 위치 표는 [`templates/.claude/agent-memory/README.md`](../templates/.claude/agent-memory/README.md) 참조.

---

## 커밋 vs gitignore 요약

| 커밋(팀 공유) | gitignore(개인) | 자동 생성 |
|---------------|-----------------|-----------|
| `CLAUDE.md` | `CLAUDE.local.md` | `.claude/agent-memory/`(커밋) |
| `.claude/settings.json` | `.claude/settings.local.json` | `.claude/agent-memory-local/`(gitignore) |
| `.claude/rules/`, `skills/`, `agents/`, `commands/`, `output-styles/`, `workflows/` | | |
| `.mcp.json`, `.worktreeinclude` | | |

> 개인용 파일을 처음 만들 땐 `.gitignore`에 `/CLAUDE.local.md`, `/.claude/settings.local.json`, `/.claude/agent-memory-local/`를 추가한다. (`.claude/settings.local.json`은 Claude Code가 자동으로 gitignore에 넣어주기도 한다.)
