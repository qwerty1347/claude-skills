# harness

반복되는 업무를 구조화한 스킬로 만들어 자동화하기 위한 환경
여기에 만든 스킬은 어느 프로젝트에서든 슬래시 명령으로 쓸 수 있다.

---

## 스킬 목록

| # | 스킬 | 하는 일 | 호출 |
|---|---|---|---|
| 1 | `/api-doc` | 변경된 API 의 명세서를 지정한 양식 HTML 로 만들어 브라우저로 연다. Jira 댓글에 붙여넣는 용도 | 자동 · `/명령` |
| 2 | `/refactor` | 지정한 파일 하나를 진단 → 전략 → 실행 → 검토 네 단계로 리팩토링한다. 원본은 두고 결과물을 `_workspace/output/` 에 만든다 | 자동 · `/명령` |
| 3 | `/commit` | 변경사항을 검토하고 Conventional Commits 형식으로 커밋한다. push 는 하지 않는다 | `/명령` 전용 |

호출 열의 `/명령` 전용은 `disable-model-invocation: true` 라 말로 시켜서는 안 불려온다는 뜻이다.

---

## 설치 (최초 1회)

`~/.claude/skills` 를 이 저장소의 `skills/` 로 연결한다. 이후 파일을 저장하면 즉시 반영된다.

```powershell
cd <이-저장소-경로>
New-Item -ItemType Junction `
  -Path   "$env:USERPROFILE\.claude\skills" `
  -Target "$PWD\skills"
```

Claude Code 를 재시작하고 슬래시 명령이 자동완성에 뜨면 성공.

> macOS · Linux:
> `cd ~/projects/harness`
> `ln -s "$PWD/skills" ~/.claude/skills`

### 실 데이터 예

```powershell
New-Item -ItemType Junction `
  -Path   "C:\Users\lee\.claude\skills" `
  -Target "C:\xampp\htdocs\www\projects\harness\skills"
```

### 다시 명렁어 입력어 하는 경우

저장소를 다른 폴더로 옮겼거나, 링크를 지웠거나, 다른 PC 에서 쓸 때. 그 외에는 최초 1회로 끝이다.

이미 걸려 있는 상태에서 위 명령을 실행하면 경로가 존재한다는 에러가 난다. 먼저 끊는다. (`-Recurse` 를 붙이지 않는다. 링크를 타고 들어가 원본 파일까지 지운다.)

```powershell
Remove-Item "C:\Users\gng\.claude\skills" -Force
```

### 확인 방법 명령어

```powershell
Get-Item "C:\Users\gng\.claude\skills" | Select-Object LinkType, Target
```

### 확인 결과

```
LinkType Target
-------- ------
Junction {C:\xampp\htdocs\www\projects\harness\skills}
```

## 스킬 추가하기

### 1. 만들 대상을 고른다

- 같은 지시를 **세 번 이상** 타이핑했다
- 절차가 말로 설명된다
- 결과물을 보고 잘 됐는지 **바로 판단**할 수 있다

셋을 다 만족하지 않으면 만들지 않는다. 한 번 하고 말 작업에 스킬을 만들면 관리 대상만 늘어난다.

### 2. 파일을 만든다

```
skills/{이름}/
└── SKILL.md          # 폴더 이름이 곧 /명령 이 된다
```

`references/`, `scripts/`, `assets/` 는 필요할 때만 만든다. 대개 `SKILL.md` 하나면 된다.

새 폴더라 인식이 안 되면 Claude Code 를 재시작한다.

### 3. frontmatter 를 채운다

```markdown
---
name: {폴더와 같은 이름}
description: 무엇을 하는지 한 문장. 이어서 실제로 쳤던 지시 문장 2~3개.
---
```

`description` 이 곧 트리거다. **"지금은 매번 어떻게 지시하나"** 를 요약하지 말고
실제로 쳤던 문장을 그대로 넣는다. 요약하면 그 말투로 시켰을 때 안 불려온다.

### 4. 실제로 돌려본다

만들고 끝내지 않는다. 여기까지가 한 세트다.

| 확인 | 안 되면 |
|---|---|
| 평소 말투로 시켰을 때 불려오는가 (3문장) | `description` 에 그 표현을 추가 |
| 비슷하지만 상관없는 요청에는 안 불려오는가 (2문장) | `description` 범위를 좁힘 |
| 불려온 뒤 결과가 기대와 같은가 | `SKILL.md` **본문**의 절차를 고침 |

`disable-model-invocation: true` 인 스킬은 위 두 줄을 건너뛰고 동작만 확인한다.

### 5. 설명 문서를 남긴다

`docs/skills/{스킬과-같은-이름}/DECISIONS.md` 를 만든다. **번호를 붙이지 않는다.**

```
skills/commit/                     →  /commit        ← 명령
docs/skills/commit/DECISIONS.md    →  설명 문서
```

### 6. 등록한다

- `README.md` 의 [스킬 목록](#스킬-목록) 표에 한 줄
- `docs/skills/README.md` 목록에 한 줄

---

## 설명 문서에 적을 것

`docs/skills/{이름}/DECISIONS.md` 는 **석 달 뒤의 내가 읽을 문서**다.
결과물이 아니라 **판단**을 남긴다. 스킬 파일을 보면 알 수 있는 것은 적지 않는다.

| 항목 | 내용 |
|---|---|
| 무엇을 하는가 | 한 문장. 어떤 반복을 대신하는가 |
| 왜 만들었는가 | 어떤 상황에서 몇 번 반복했는가 |
| 어떻게 쓰는가 | 호출 예시 몇 개. 자동 호출인지 `/명령` 전용인지 |
| 왜 이렇게 만들었는가 | 전역/프로젝트 선택 이유, frontmatter 옵션을 켠 이유 |
| 함정 | 이 도메인에서 틀리기 쉬운 것 |
| 검증 | 어떤 시나리오로 확인했는가 |
| 제작 기록 | 만들면서 판단이 바뀐 부분 |

만들기 **전에** 초안을 써두면 `description` 과 본문 절차를 그대로 옮겨 적을 수 있다.

---

## 규칙

- `skills/` 아래 **폴더 이름이 곧 명령**이다. 번호를 붙이거나 하위 폴더로 묶지 않는다
- `SKILL.md` 에 절대경로를 적지 않는다. `${CLAUDE_SKILL_DIR}` · `${CLAUDE_PROJECT_DIR}` 를 쓴다
- 되돌리기 어려운 동작(커밋·삭제·전송)은 `disable-model-invocation: true` 로 자동 호출을 끈다
- `allowed-tools` 는 쓸 명령만 나열한다. `Bash(git *)` 처럼 넓게 열지 않는다
- 본문 500줄을 넘기면 `references/` 로 뺀다
- 프로젝트별 컨벤션은 스킬이 아니라 그 프로젝트 `CLAUDE.md` 에

---

## 어느 문서를 보나

| 상황 | 볼 곳 |
|---|---|
| 스킬을 만든다 | 이 문서의 [스킬 추가하기](#스킬-추가하기) |
| 특정 스킬이 왜 이런지 알고 싶다 | `docs/skills/{이름}/DECISIONS.md` |

---

## 참고

- [Claude Code Skills 문서](https://code.claude.com/docs/en/skills)
- [revfactory/harness](https://github.com/revfactory/harness) — 구조를 참고한 원본