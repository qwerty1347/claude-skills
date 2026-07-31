<div align="center">

# Harness — 내 반복 작업을 스킬로 굳히는 곳

**매번 설명하던 절차를 파일로 고정한다. 다음 세션부터는 Claude 가 알아서 꺼내 쓴다.**

![version](https://img.shields.io/badge/version-0.1.0-blue)
![license](https://img.shields.io/badge/license-MIT-green)
![claude--code](https://img.shields.io/badge/Claude%20Code-plugin-orange)

</div>

---

## 개요

같은 지시를 세 번째 타이핑하고 있다면, 그건 스킬이 될 자격이 있다.

Harness 는 그 순간을 처리하는 개인 저장소다. `/new-skill` 을 실행하면 스킬 뼈대를 만들고,
가장 자주 틀리는 부분(`description` 작성과 트리거 검증)까지 끌고 간다.

> 프롬프트를 잘 쓰는 게 아니라, **프롬프트를 잘 쓸 필요가 없게 만드는 것**이다.

## 핵심 기능

| 기능 | 설명 |
|---|---|
| 스킬 스캐폴딩 | `skills/{이름}/SKILL.md` 생성, frontmatter 자동 구성 |
| description 설계 | 트리거 실패의 90%를 차지하는 부분을 실제 발화 기준으로 작성 |
| 트리거 검증 | 불려와야 할 문장 3개 / 불려오면 안 될 문장 2개로 즉시 확인 |
| 즉시 반영 | `~/.claude/skills` 정션 링크로 저장하는 즉시 전역 적용 |

## 워크플로

`/new-skill` 은 8단계로 진행한다.

```
0. 기존 스킬 점검           ← 있으면 새로 만들지 않고 고친다
1. 무엇을 반복하는지 확인   ← 실제 지시 문장을 그대로 수집
2. 이름 정하기              ← 동사형, 소문자-하이픈
3. 범위 정하고 파일 생성    ← 전역이냐 이 프로젝트냐
4. description 작성         ← 여기가 트리거다
5. 본문 작성                ← 명령형, 이유 포함, 500줄 이내
6. 트리거 테스트            ← 만들고 끝내지 않는다
7. 등록                     ← README, CHANGELOG
```

자세한 작성 규칙은 [`skills/new-skill/references/skill-writing-guide.md`](skills/new-skill/references/skill-writing-guide.md) 참고.

## 설치

### 방법 A — 정션 링크 (개발용, 권장)

이 저장소를 직접 수정하면서 쓴다. 저장 즉시 반영된다.

```powershell
cd <이-저장소-경로>
New-Item -ItemType Junction `
  -Path   "$env:USERPROFILE\.claude\skills" `
  -Target "$PWD\skills"
```

Claude Code 재시작 후 `/new-skill` 이 자동완성에 뜨면 성공.

해제:

```powershell
Remove-Item "$env:USERPROFILE\.claude\skills" -Force
```

> 복사본이 아니라 **링크**다. 실체는 이 저장소의 `skills/` 하나뿐이고,
> 위 명령은 링크만 끊는다. 단, 링크를 타고 들어가 파일을 지우면 원본이 지워진다.
>
> 저장소를 다른 폴더로 옮기면 링크는 옛 경로를 계속 가리킨다. 옮긴 뒤에는 다시 걸 것.

### 방법 B — 플러그인 설치 (배포용)

GitHub 에 올린 뒤 다른 PC 에서 쓸 때.

```
/plugin marketplace add YOUR_HANDLE/harness
/plugin install harness@harness-marketplace
```

> A 와 B 를 동시에 쓰지 말 것. 같은 스킬이 두 번 로드된다.

## 구조

```
harness/
├── .claude-plugin/
│   ├── plugin.json          # 플러그인 메타
│   └── marketplace.json     # 마켓플레이스 등록 정보
├── docs/
│   └── quickstart.md        # 5분 안에 첫 스킬 만들기
├── skills/
│   └── new-skill/
│       ├── SKILL.md         # 본체 (500줄 이내로 유지)
│       └── references/      # 필요할 때만 읽히는 상세 문서
│           └── skill-writing-guide.md
├── _workspace/              # 실행 중 산출물 (감사용 보존)
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

`skills/` 아래 폴더 하나가 스킬 하나이고, 폴더 이름이 그대로 슬래시 명령이 된다.
(`skills/new-skill/` → `/new-skill`)

## 사용법

### 트리거 문장

명시적으로 부르거나:

```
/new-skill
```

또는 자연스럽게 말해도 걸린다:

- "이 작업 스킬로 만들자"
- "매번 똑같이 시키는 게 귀찮다"
- "이거 자동화하고 싶어"

### 스킬 목록

| 스킬 | 하는 일 |
|---|---|
| `/new-skill` | 새 스킬 뼈대를 만들고 트리거까지 검증한다 |

## 산출물

`/new-skill` 실행 후 생기는 것:

```
{이름}/
├── SKILL.md          # 필수 — name + description frontmatter
├── references/       # 선택 — 조건부 로딩 문서
├── scripts/          # 선택 — 매번 다시 짜기 아까운 코드
└── assets/           # 선택 — 템플릿, 이미지 등
```

위치는 Phase 3 에서 정한 범위에 따라 갈린다.

| 범위 | 생기는 곳 | 커밋되는 저장소 |
|---|---|---|
| 전역 | 이 저장소의 `skills/{이름}/` | harness |
| 프로젝트 전용 | `{그 프로젝트}/.claude/skills/{이름}/` | 그 프로젝트 |

전역이면 README 의 스킬 목록 표와 `CHANGELOG.md` 에도 한 줄씩 추가된다.

## 요구사항

- Claude Code
- 설치 명령은 Windows PowerShell 기준. macOS · Linux 는 `New-Item -ItemType Junction` 대신
  `ln -s "$PWD/skills" ~/.claude/skills` 를 쓴다.

> 저장소 경로는 어디든 상관없다. `SKILL.md` 는 `${CLAUDE_SKILL_DIR}` · `${CLAUDE_PROJECT_DIR}` 만
> 쓰고 절대경로를 적지 않는다. 그래서 폴더를 옮기거나 남이 클론해도 그대로 동작한다.

> 에이전트 팀(`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`)은 **아직 필요 없다.**
> 스킬만 쓰는 단계에서는 플래그 없이 동작한다.

## 로드맵

| 단계 | 시점 |
|---|---|
| 스킬 2~3개 만들어 실제로 써보기 | 지금 |
| 프로젝트별 `CLAUDE.md` 작성 | 스킬에 프로젝트 컨벤션을 넣고 싶어질 때 |
| 에이전트 / 팀 도입 | 한 작업을 "생성자 + 검증자"로 나눠야 할 만큼 커졌을 때 |
| 플러그인 공개 배포 | 남에게 쓰게 하고 싶을 때 |

## 원칙

1. **작게 시작한다.** 에이전트 6개짜리 팀보다 잘 만든 스킬 1개가 낫다.
2. **description 이 전부다.** 스킬이 안 불려오는 사고의 대부분은 여기서 난다.
3. **측정하지 않으면 개선이 아니라 취향이다.**
4. **한 번 하고 말 작업엔 하네스를 쓰지 않는다.**

## 참고

- [revfactory/harness](https://github.com/revfactory/harness) — 구조를 참고한 원본.
- [Claude Code Skills 문서](https://code.claude.com/docs/en/skills)

## 라이선스

MIT — [LICENSE](LICENSE)
