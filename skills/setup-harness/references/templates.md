# 생성 파일 템플릿 (templates) — 인덱스 + 채움 규칙

Step 6에서 파일을 만들기 직전에 읽는다. 템플릿의 **실제 원본 파일**은 플러그인 번들의 `${CLAUDE_PLUGIN_ROOT}/templates/` 에 있다. 해당 파일을 읽어 `{{...}}` 자리표시자를 Step 1~4에서 모은 값으로 치환한 뒤 사용자 프로젝트의 같은 경로에 쓴다.

> 템플릿은 타깃 레이아웃 그대로 미러되어 있다(예: `templates/.claude/settings.json` → 사용자 프로젝트의 `.claude/settings.json`). 사람이 직접 쓸 때는 `templates/` 전체를 복사하면 된다 — `docs/project-setup-guide.md` 참조.

## 템플릿 파일 맵

| 항목 | 원본 템플릿 | 깊이 |
|------|------------|------|
| CLAUDE.md (Karpathy 가이드라인 + MIT 헤더, 기본 제공) | `templates/CLAUDE.md` | 항상 |
| 권한·훅 | `templates/.claude/settings.json` | 기본+ |
| 개인 지침 | `templates/CLAUDE.local.md` | 고급(선택) |
| 개인 설정 | `templates/.claude/settings.local.json` | 고급(선택) |
| 규칙 | `templates/.claude/rules/{testing,code-style}.md` | 표준+ |
| MCP 서버 | `templates/.mcp.json` | 고급(선택) |
| worktree 복사 | `templates/.worktreeinclude` | 고급(선택) |
| 코드 리뷰어 | `templates/.claude/agents/code-reviewer.md` | 확장(선택) |
| 스타터 스킬 | `templates/.claude/skills/run-checks/SKILL.md` | 확장(선택) |
| 커맨드(레거시) | `templates/.claude/commands/example.md` | 고급(선택) |
| 출력 스타일 | `templates/.claude/output-styles/teaching.md` | 고급(선택) |
| 워크플로우 | `templates/.claude/workflows/README.md`(안내) | 고급(안내만) |
| 에이전트 메모리 | `templates/.claude/agent-memory/README.md`(안내) | 자동(안내만) |

> `workflows`와 `agent-memory`는 복사용 설정이 아니다(각각 `/workflows`로 생성, 서브에이전트가 자동 생성). 위저드는 생성하지 말고 안내만 한다.

## 자리표시자

| 자리표시자 | 의미 |
|-----------|------|
| `{{PROJECT_NAME}}` | 디렉터리명 또는 사용자가 준 이름 |
| `{{LANG}}` / `{{FRAMEWORK}}` | 감지/확인된 스택 |
| `{{BUILD}}` `{{TEST}}` `{{LINT}}` `{{FORMAT}}` | 확인된 명령 (없으면 해당 줄 생략) |
| `{{FORMATTER}}` | 감지된 포매터 명령 (예: `npx prettier --write`) |
| `{{EXT}}` | 언어 확장자 (ts/tsx, py, go 등) |

## 채움·조립 규칙

마크다운 파일(`CLAUDE.md`, `rules/*.md`, `agents/*.md` 등)의 초보자용 주석(`<!-- -->`)은 그대로 두면 학습에 도움이 된다. 다만 자리표시자는 반드시 치환한다.

- **CLAUDE.md (특수 — Karpathy 기본 + 프로젝트 컨텍스트 append)**
  - 기본 파일 `templates/CLAUDE.md`(Karpathy 가이드라인)는 **그대로** 설치한다. 본문엔 `{{}}` 자리표시자가 없다. **상단 MIT 헤더 주석은 절대 제거/변형하지 않는다(라이선스 의무).**
  - 설치/통합 분기(없으면 무조건 설치, 있으면 4지선다)는 `question-flow.md` 2-1을 따른다.
  - 프로젝트별 컨텍스트(Commands/Stack/Rules)가 필요하면 가이드라인 **아래에 "프로젝트 컨텍스트 append 블록"(바로 아래)** 을 덧붙인다.
- **settings.json**
  - `allow`에는 Step 3에서 확인된 명령만, 와일드카드 `*`로 인자 변형 허용.
  - `deny`는 위험 명령 차단을 선택했을 때만.
  - `hooks`는 포매터 감지 + 사용자가 "예"일 때만. 아니면 `hooks` 키 자체를 뺀다.
  - 훅 `command`는 이벤트 JSON을 **stdin**으로 받고 `jq`는 인자 없이 stdin을 읽는다(공식 문서 형식). `{{FORMATTER}}`만 치환.
- **rules/*.md**: `{{EXT}}`를 언어 확장자로. `src/`가 없으면 `paths:`를 실제 경로로 바꾸거나 제거.
- **.mcp.json**: 예시 서버는 실제 필요한 것으로 교체. 토큰은 `${ENV_VAR}` 참조 유지(파일에 직접 쓰지 않는다).
- **run-checks 스킬**: `{{LINT}}`/`{{TEST}}` 중 없는 줄 제거. 둘 다 없으면 이 스킬 생성 안 함.

## 프로젝트 컨텍스트 append 블록 (CLAUDE.md 가이드라인 아래에 덧붙임)

자리표시자를 치환해 가이드라인 본문 끝(MIT 헤더·가이드라인은 그대로 둠)에 덧붙인다. 값이 없는 줄은 생략한다.

```markdown

---

## Commands
- Build: `{{BUILD}}`
- Test: `{{TEST}}`
- Lint: `{{LINT}}`
- Format: `{{FORMAT}}`

## Stack
- {{LANG}}

## Project Rules
- (Step 3 컨벤션 답변을 불릿으로)
```

채움 규칙: Stack 줄은 FRAMEWORK가 있으면 `- {{LANG}}, {{FRAMEWORK}}`. Commands는 값 없는 명령 줄 생략. 규칙을 `.claude/rules/`로 분리했으면 `## Project Rules`는 "세부 규칙은 `.claude/rules/` 참조" 한 줄만.

## 기존 파일 병합 규칙 (무단 덮어쓰기 금지)

- `CLAUDE.md`는 전용 4지선다 처리(`question-flow.md` 2-1)를 따른다. 어떤 경로든 MIT 헤더 보존.
- 그 외 마크다운(`rules/*.md` 등): 빠진 절만 이어쓰고, 이미 있는 절은 손대지 않는다.
- JSON(`settings.json`, `settings.local.json`, `.mcp.json`): 기존 키를 보존하며 병합. 배열(`permissions.allow`/`deny`)은 합치고 중복 제거.
- 개인용 파일(`CLAUDE.local.md`, `settings.local.json`, `agent-memory-local/`)을 생성하면 `.gitignore` 등록을 안내/추가한다.
