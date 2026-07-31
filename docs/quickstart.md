# Quickstart — 5분 안에 첫 스킬 만들기

시간 예산은 **5분**이다. 끝나면 `skills/` 아래에 실제로 동작하는 스킬 하나가 생긴다.

## 사전 조건

- Claude Code 설치 완료
- 이 저장소를 클론(또는 다운로드)해 둔 상태
- PowerShell

에이전트 팀 실험 플래그는 **필요 없다.** 스킬만 쓰는 단계이기 때문이다.

---

## 1단계 — 링크 연결 (30초)

`~/.claude/skills` 를 이 저장소의 `skills/` 로 연결한다.
**저장소 루트에서** 실행하면 경로를 직접 적을 필요가 없다.

```powershell
cd <이-저장소-경로>
New-Item -ItemType Junction `
  -Path   "$env:USERPROFILE\.claude\skills" `
  -Target "$PWD\skills"
```

이미 `~/.claude/skills` 폴더가 있으면 명령이 실패한다. 그 경우 안의 내용을
이 저장소의 `skills\` 로 옮긴 뒤 원래 폴더를 지우고 다시 실행한다.

저장소를 다른 곳으로 옮겼다면 링크를 다시 건다. 링크는 옛 경로를 계속 가리킨다.

```powershell
Remove-Item "$env:USERPROFILE\.claude\skills" -Force
```

## 2단계 — 재시작 후 확인 (30초)

Claude Code 를 재시작한다. 세션 시작 시점에 없던 디렉터리는 자동 감지되지 않는다.

프롬프트에 `/new` 까지 치면 `/new-skill` 이 자동완성에 떠야 한다.

> **안 뜬다면**
> `Get-Item "$env:USERPROFILE\.claude\skills"` 로 `LinkType` 이 `Junction` 인지 확인한다.
> 링크는 맞는데 안 뜨면 `skills\new-skill\SKILL.md` 의
> frontmatter 에서 `name:` 이 폴더 이름과 같은지 본다.

## 3단계 — 반복하는 일 하나 고르기 (60초)

여기가 실제로 어려운 부분이다. 좋은 후보의 조건:

- 이미 **세 번 이상** 같은 지시를 타이핑했다
- 절차가 말로 설명된다 (1단계, 2단계, ...)
- 결과물을 보고 잘 됐는지 **바로 판단**할 수 있다

나쁜 후보: "코드 품질 개선" 처럼 성공 기준이 주관적인 것, "리팩토링" 처럼 범위가 열린 것.

> 첫 스킬은 **정답을 이미 알고 있는 작업**으로 잡아라.
> 잘 돌았는지 판단할 기준이 없으면 개선할 수가 없다.

## 4단계 — 스킬 생성 (2분)

```
/new-skill
```

물어보는 것에 답하면 된다. 핵심은 세 번째 질문이다 —
**"지금은 매번 어떻게 지시하나"** 에는 요약하지 말고 실제로 쳤던 문장을 그대로 준다.
그 문장이 `description` 에 들어가고, 그게 트리거가 된다.

## 5단계 — 검증 (60초)

만든 스킬이 파일로 생겼는지:

```powershell
Get-ChildItem "$env:USERPROFILE\.claude\skills" -Recurse -File | Select-Object FullName
```

그리고 **실제로 불려오는지**. 새 대화를 열고 3단계에서 고른 작업을 평소 말투로 시켜본다.
슬래시 명령을 쓰지 말고, 그냥 말로.

| 결과 | 조치 |
|---|---|
| 스킬이 불려왔다 | 끝. |
| 안 불려왔다 | `description` 에 방금 친 문장의 표현을 추가 |
| 엉뚱할 때도 불려온다 | `description` 의 범위를 좁히거나 `disable-model-invocation: true` |
| 불려왔는데 결과가 별로다 | `SKILL.md` **본문**의 절차를 고친다 (description 문제가 아니다) |

---

## 끝

- [x] `~/.claude/skills` 링크 연결
- [x] 스킬 1개 생성
- [x] 트리거 동작 확인

## 다음

- 스킬 작성 규칙 상세: [`../skills/new-skill/references/skill-writing-guide.md`](../skills/new-skill/references/skill-writing-guide.md)
- 두세 개 더 만들어 쓴 다음에, 에이전트와 팀을 볼 것. 순서를 뒤집으면 안 쓰는 구조부터 생긴다.
