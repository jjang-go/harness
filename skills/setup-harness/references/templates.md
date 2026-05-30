# 생성 파일 템플릿 (templates)

Step 6에서 파일을 만들기 직전에 읽는다. 아래 템플릿의 `{{...}}` 자리표시자를 Step 1~4에서 모은 값으로 치환해 생성한다.

## 자리표시자
- `{{PROJECT_NAME}}` — 디렉터리명 또는 사용자가 준 이름
- `{{LANG}}` / `{{FRAMEWORK}}` — 감지/확인된 스택
- `{{BUILD}}` `{{TEST}}` `{{LINT}}` `{{FORMAT}}` — 확인된 명령 (없으면 해당 줄 생략)
- `{{FORMATTER}}` — 감지된 포매터 명령 (예: `npx prettier --write`)
- `{{CONVENTIONS}}` — Step 3에서 고른 컨벤션 항목들

## 작성 원칙
- 마크다운 파일(`CLAUDE.md`, `rules/*.md`, `agents/*.md`)에는 **초보자용 주석**을 자연스럽게 녹인다. 나중에 열어봤을 때 스스로 이해하도록.
- 해당 없는 줄/절은 통째로 **생략**한다. 빈 자리표시자를 남기지 않는다.
- 기존 파일을 보완할 때는 **빠진 절만** 이어쓴다. 이미 있는 절은 손대지 않는다.
- `settings.json`은 JSON이라 주석을 넣을 수 없다. 설명은 Step 7 말로 전달하고 파일은 깔끔히 둔다. 기존 파일이 있으면 **키 병합**(배열은 합치고 중복 제거)한다.

---

## 1. `CLAUDE.md` (모든 깊이)

> 매 세션 시작 시 항상 로드되는 프로젝트 지침서다. 200줄 이내를 권장한다.

````markdown
# {{PROJECT_NAME}}

<!-- 이 파일은 Claude가 매 세션마다 읽는 프로젝트 안내서입니다.
     자주 쓰는 명령, 기술 스택, 지켜야 할 규칙을 적어두면
     Claude가 매번 설명하지 않아도 같은 전제로 작업합니다.
     `/memory` 명령으로 언제든 열어 수정할 수 있어요. -->

## Commands
- Build: `{{BUILD}}`
- Test: `{{TEST}}`
- Lint: `{{LINT}}`
- Format: `{{FORMAT}}`

## Stack
- {{LANG}}

## Rules
{{CONVENTIONS를 불릿으로. 예시:}}
- {{LANG}} strict 모드 사용
- named export 사용, default export 지양
- 테스트는 소스 옆에 둔다: `foo.ts` → `foo.test.ts`
````

채움 규칙:
- **Stack 줄:** FRAMEWORK가 감지됐으면 `- {{LANG}}, {{FRAMEWORK}}`로 쓰고, 없으면 `- {{LANG}}`만.
- **Commands 줄:** 값이 없는 명령(예: Format 미감지)은 해당 줄을 통째로 생략한다.

표준/확장 깊이에서 규칙을 별도 `rules/` 파일로 분리한 경우, CLAUDE.md의 `## Rules` 절은 짧게 두고 "세부 규칙은 `.claude/rules/`에 있음" 한 줄을 남긴다.

---

## 2. `.claude/rules/testing.md` (표준·확장, 테스트 도구가 있을 때)

> `paths:` 프런트매터가 있는 규칙은 매칭되는 파일을 열 때만 로드된다. 테스트 파일을 만질 때만 이 규칙이 컨텍스트에 들어온다.

```markdown
---
paths:
  - "**/*.test.{{EXT}}"
  - "**/*.spec.{{EXT}}"
---

# 테스트 규칙

<!-- 이 규칙은 테스트 파일을 열 때만 자동으로 로드됩니다. -->

- 테스트 이름은 "should [기대결과] when [조건]" 형태로 명확히 쓴다
- 외부 의존성은 모킹하고, 내부 모듈은 실제로 사용한다
- 부수효과는 afterEach에서 정리한다
- 새 기능에는 happy path + edge case 테스트를 모두 포함한다
```

`{{EXT}}`는 언어 확장자(ts/tsx, py, go 등). Go 등 `_test.go` 관례가 있으면 그에 맞춰 glob을 조정한다.

---

## 3. `.claude/rules/code-style.md` (표준·확장)

```markdown
---
paths:
  - "src/**/*.{{EXT}}"
---

# 코드 스타일

<!-- src 아래 소스 파일을 열 때만 로드되는 규칙입니다. -->

{{Step 3 컨벤션 답변을 규칙으로 옮긴다. 예시:}}
- 함수는 한 가지 일만 하고 짧게 유지한다
- 가독성을 영리함보다 우선한다
- 주석은 "왜"를 설명한다 ("무엇"은 코드로)
```

> 프로젝트에 `src/`가 없으면 `paths:`를 실제 소스 경로에 맞추거나, 경로 제한 없는 일반 규칙으로 만든다.

---

## 4. `.claude/settings.json` (모든 깊이)

권한 선택과 포맷 훅 선택에 따라 조립한다. 아래는 "둘 다 + 자동 포맷" 최대 예시다. 선택 안 한 부분은 뺀다.

```json
{
  "permissions": {
    "allow": [
      "Bash({{TEST}}*)",
      "Bash({{LINT}}*)",
      "Bash({{BUILD}}*)",
      "Bash({{FORMAT}}*)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(git push --force*)",
      "Bash(git push -f*)"
    ]
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path' | xargs {{FORMATTER}}"
          }
        ]
      }
    ]
  }
}
```

조립 규칙:
- `allow`에는 Step 3에서 확인된 명령만 넣는다. 와일드카드 `*`로 인자 변형을 허용한다 (예: `Bash(npm test *)`).
- `deny`는 위험 명령 차단을 선택했을 때만. 사용자 환경 규칙(force push 금지 등)과 맞춘다.
- `hooks`는 포매터 감지 + 사용자가 "예"를 골랐을 때만. 아니면 `hooks` 키 자체를 뺀다.
- 훅 `command`는 이벤트 JSON을 **stdin**으로 받는다. `jq`는 인자 없이 stdin을 읽으므로 위 명령이 편집된 파일 경로를 그대로 추출한다(공식 문서 예시와 동일 형식).
- 기존 `settings.json`이 있으면 `allow`/`deny` 배열을 **합치고 중복 제거**, 다른 키는 보존한다.

---

## 5. `.claude/agents/code-reviewer.md` (확장, 선택 시)

> 자체 컨텍스트에서 도는 읽기 전용 검토 보조 에이전트. `tools`를 읽기 전용으로 제한해 코드를 수정하지 못하게 한다.

```markdown
---
name: code-reviewer
description: 정확성·보안·유지보수성 관점에서 코드를 검토한다. 변경분 리뷰가 필요할 때 사용한다.
tools: Read, Grep, Glob
---

당신은 시니어 코드 리뷰어입니다. 다음을 검토하세요:

1. 정확성: 로직 오류, 엣지 케이스, null 처리
2. 보안: 인젝션, 인증 우회, 데이터 노출
3. 유지보수성: 네이밍, 복잡도, 중복

모든 지적에는 구체적인 수정안을 함께 제시하세요.
```

---

## 6. `.claude/skills/run-checks/SKILL.md` (확장, 선택 시)

> test·lint를 한 번에 돌리는 단축 스킬. `/run-checks`로 호출.

```markdown
---
name: run-checks
description: 프로젝트의 테스트와 린트를 한 번에 실행하고 결과를 요약한다. '체크 돌려줘', '테스트랑 린트 확인' 같은 요청에 사용한다.
---

# Run Checks

다음을 순서대로 실행하고 결과를 간결히 요약한다. 실패가 있으면 어떤 명령이 왜 실패했는지 먼저 보고한다.

1. 린트: `{{LINT}}`
2. 테스트: `{{TEST}}`

각 명령의 성공/실패와 핵심 출력만 보고하고, 실패 시 수정 방향을 제안한다.
```

명령이 하나라도 없으면 해당 줄을 빼고, 둘 다 없으면 이 스킬을 만들지 않는다.
