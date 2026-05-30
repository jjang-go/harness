---
paths:
  - "**/*.test.{{EXT}}"
  - "**/*.spec.{{EXT}}"
---

# 테스트 규칙

<!-- paths: 가 있으므로 이 규칙은 위 glob에 맞는 테스트 파일을 열 때만 로드됩니다.
     Go 처럼 _test.go 관례면 glob을 "**/*_test.go" 로 바꾸세요. -->

- 테스트 이름은 "should [기대결과] when [조건]" 형태로 명확히 쓴다
- 외부 의존성은 모킹하고, 내부 모듈은 실제로 사용한다
- 부수효과는 afterEach/teardown에서 정리한다
- 새 기능에는 happy path + edge case 테스트를 모두 포함한다
