# agent-memory/ — 서브에이전트 영속 메모리 (자동 생성, 복사용 아님)

`.claude/agent-memory/<에이전트>/MEMORY.md` 는 서브에이전트가 세션 간 지식을 쌓는 곳이다.
**사람이 작성하지 않는다.** 에이전트 정의에 `memory:` 를 설정하면 해당 디렉터리가 자동 생성되고, 에이전트가 스스로 읽고 쓴다.

`memory:` 옵션과 저장 위치:

| 설정 | 저장 위치 | 공유/커밋 |
|------|----------|-----------|
| `memory: project` | `.claude/agent-memory/<name>/` | 팀과 공유(커밋) |
| `memory: local` | `.claude/agent-memory-local/<name>/` | 개인용(gitignore) |
| `memory: user` | `~/.claude/agent-memory/<name>/` | 모든 프로젝트(개인) |

설정 예 — 에이전트 `.md` frontmatter:

```yaml
---
name: code-reviewer
description: ...
memory: project
---
```

gitignore (local 메모리를 쓸 때):

```
/.claude/agent-memory-local/
```

이 README 는 안내용이며 지워도 된다.
