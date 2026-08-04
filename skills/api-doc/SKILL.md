---
name: api-doc
description: Laravel API 명세서를 사내 양식대로 HTML 로 만들고 브라우저로 연다. 사용자가 화면을 드래그 복사해 지라 댓글에 붙여넣는다. "이 API 명세서 만들어줘", "지라에 올릴 API 문서 뽑아줘", "api 스펙 정리해줘" 같은 요청에 사용한다.
allowed-tools: Bash(git status *) PowerShell(*docs-dir.ps1*) PowerShell(*open-doc.ps1*)
---

# API 명세서 만들기

Laravel 프로젝트의 API 명세서를 HTML 로 만든다. 사용자가 그 화면을 드래그 복사해
지라 댓글에 붙여넣으므로, **표와 색이 붙여넣기 후에도 살아남아야 한다.**

마크다운으로 만들지 않는다. 지라가 변환하지 않는다.

## 0. 문서 폴더를 받는다

**명세서는 지금 작업 중인 프로젝트가 아니라 harness 저장소에 모은다.**
작업 repo 에 임시 HTML 이 쌓여 `git status` 가 지저분해지는 것을 막기 위한 것이다.

폴더 경로는 직접 조립하지 말고 이 한 줄로 받는다. 폴더가 없으면 만들어서 준다.

```powershell
& '${CLAUDE_SKILL_DIR}/scripts/docs-dir.ps1'
```

출력된 절대경로(`...\harness\docs\api-docs`)를 이후 단계에서 그대로 쓴다.
아래에서 `docs/api-docs/` 라고 쓰면 전부 이 폴더를 뜻한다.

- **경로를 하드코딩하지 않는다.** PC 마다 harness 위치가 다르다
- **현재 폴더 기준 상대 경로를 쓰지 않는다.** 작업 중인 프로젝트에 문서가 생긴다

## 1. 오래된 파일을 정리한다

문서를 만들기 전에 먼저 한다.

- `docs/api-docs/` 안을 본다
- 파일명이 `YYYY-MM-DD_*.html` 형식이고, 그 날짜가 **오늘로부터 7일보다 이전**이면 지운다
  (오늘이 2026-08-04 면 2026-07-28 이전 파일이 대상)
- 패턴이 다른 파일은 지우지 않는다. 남이 만든 것일 수 있다
- 지운 개수를 한 줄로 알린다. 지운 게 없으면 말하지 않는다

## 2. 대상을 정한다

```
git status
```

- 변경된 파일 중 라우트·컨트롤러·FormRequest 가 있으면 그것이 다루는 API 를 대상으로 삼는다
- 사용자가 특정 파일이나 API 를 지정하면 그것을 우선한다
- 대상이 없으면 멈추고 알린다

## 3. 필요한 파일을 전부 읽는다

**Laravel 은 한 API 의 정보가 여러 파일에 흩어져 있다.** 아래를 모두 확인해야 명세서가 완성된다.

| 파일 | 여기서 얻는 것 |
|---|---|
| `routes/api.php` · `routes/web.php` | 라우트 정의, HTTP 메서드, `{param}`, 미들웨어, 그룹 |
| 컨트롤러 메서드 | 처리 흐름, `$request->query()` / `header()` / `input()` |
| FormRequest 클래스 | `rules()` — 파라미터·타입·필수 여부 |
| (FormRequest 가 없으면) 컨트롤러의 `$request->validate([...])` | 위와 같음 |
| API Resource(`JsonResource`) 또는 `response()->json(...)` | 성공 응답 구조 |
| `app/Exceptions/Handler.php`, 공통 응답 헬퍼 | 실패 응답 구조 |

**컨트롤러만 보고 넘어가지 않는다.** 파라미터는 대부분 FormRequest 에 있고,
컨트롤러 시그니처만 보면 "파라미터 없음" 이라고 쓰게 된다.

## 4. 내용을 채운다

- 문서 내용은 diff 가 아니라 **그 API 의 현재 코드 전체**를 읽어서 채운다.
  파라미터 하나만 바뀌었어도 명세서에는 파라미터 전부가 들어간다
- 추측해서 채우지 않는다. 명세서는 틀리면 남이 그대로 구현한다

### 모르는 것은 묻지 말고 표시한다

코드에서 못 찾는 것(값의 의미, 설명, 응답 예시)이 있어도 **멈추거나 되묻지 않는다.**
문서는 끝까지 만들고, 모르는 자리에만 표시를 남긴다. 사용자가 직접 채운다.

```html
<span class="b todo">확인 필요</span>
```

`in:e,d` 처럼 **값은 알지만 의미를 모를 때**가 대표적이다.
아는 것(허용값)은 적고, 모르는 것(의미)만 표시한다.

```
허용값: e, d <span class="b todo">확인 필요</span>
```

`e` 를 `enabled`, `d` 를 `deleted` 로 **넘겨짚지 않는다.** 그게 이 표시를 쓰는 이유다.

문서를 다 만든 뒤 `확인 필요` 가 몇 개 남았는지 한 줄로 알린다. 없으면 말하지 않는다.

## 5. 이전 문서에서 설명만 이어받는다

**명세서는 항상 현재 코드 그대로다. 무엇이 바뀌었는지는 기록하지 않는다.**

- 코드에서 사라진 파라미터는 문서에서도 사라진다. 취소선이나 REMOVED 표시로 남기지 않는다
- 새로 생긴 파라미터도 그냥 다른 항목과 똑같이 적는다. NEW 같은 표시를 붙이지 않는다
- 타입이나 필수 여부가 바뀌어도 바뀐 값만 적는다. 이전 값은 적지 않는다

이전 문서를 여는 이유는 딱 하나다. `docs/api-docs/` 에 같은 주제의 명세서가 있으면
**손으로 적어둔 설명을 그대로 옮겨온다.** 코드에서 나오지 않는 문장이라 다시 못 만든다.
지금도 코드에 있는 파라미터의 설명만 옮긴다.

## 6. HTML 을 만든다

0단계에서 받은 폴더에 `YYYY-MM-DD_주제.html` 로 만든다.

- 날짜는 만드는 날 기준. 같은 날 같은 주제면 덮어쓴다
- **작업 중인 프로젝트에는 아무 파일도 만들지 않는다.** `.gitignore` 등 설정 파일도 건드리지 않는다

스타일은 [`assets/doc.css`](assets/doc.css) 를 읽어 `<style>` 안에 **그대로** 넣는다.
색이나 여백을 즉석에서 바꾸지 않는다. 문서마다 모양이 달라지면 붙여넣은 지라 댓글이 제각각이 된다.

### 문서 구조

```html
<meta charset="utf-8">
<style> /* assets/doc.css 내용 */ </style>

<p class="guide">아래 구분선 사이를 드래그해서 복사한 뒤 지라 댓글에 붙여넣으세요.</p>
<hr>

<!-- API 가 2개 이상이면 목차 -->

<!-- API 블록 -->

<hr>
```

API 하나당 이 순서 고정:

1. `<h2>` API 이름
2. `<p>` METHOD + `<code>경로</code>` — 경로는 도메인 없이 `/` 로 시작
3. 인증 한 줄 — 필요 없으면 **아무것도 적지 않는다**
4. 파라미터 표 — 파라미터 / 위치 / 필수 / 타입 / 설명
   파라미터가 없으면 **아무것도 적지 않는다**
5. (조건부) `<b>요청 예시</b>` + `<pre>` JSON — BODY 필드가 3개 초과이거나 중첩일 때만
6. `<b>성공</b>` + `<pre>` JSON
7. `<b>실패</b>` + `<pre>` JSON — **대표 1개만.** 기본은 `500` 이다

API 사이에는 `<hr>` 로 경계를 둔다. **각 API 가 독립적으로 읽혀야 부분 복사가 된다.**

### 배지 마크업

`assets/doc.css` 의 클래스를 쓴다.

```html
<span class="b req">REQUIRED</span>
<span class="b opt">OPTIONAL</span>
<span class="b m loc">PATH</span>
<span class="b m t-string">STRING</span>
<span class="b todo">확인 필요</span>
```

`b` 는 공통, `m` 은 monospace. 타입과 위치에는 `m` 을 함께 붙인다.

## 7. 브라우저를 연다

```powershell
& '${CLAUDE_SKILL_DIR}/scripts/open-doc.ps1'
```

이 한 줄만 실행한다. **다른 PowerShell 명령을 만들지 않는다** —
변수 할당·큰따옴표 보간·괄호 부분식이 전부 승인 창을 띄운다.

---

## 파라미터 위치 판별

정렬 순서: PATH → QUERY → HEADER → BODY

| 위치 | 판별 |
|---|---|
| `PATH` | 라우트 정의의 `{param}`. `{param?}` 는 OPTIONAL |
| `QUERY` | `Route::get` · `Route::delete` 의 검증 필드, 또는 `$request->query('...')` |
| `HEADER` | `$request->header('...')`. 공통 인증 헤더는 제외 |
| `BODY` | `Route::post` · `put` · `patch` 의 검증 필드, `$request->input()`, FormRequest 규칙 |

표에 넣지 않는 것:

- `Request $request` 자체
- 라우트 모델 바인딩으로 주입되는 모델 객체
  (다만 그 바인딩의 원본 `{param}` 은 PATH 로 넣는다)

배열 요소 규칙(`items.*`)은 부모 파라미터 설명에 적는다. 별도 행으로 만들지 않는다.
중첩 객체(`user.name`)는 점 표기 그대로 파라미터 이름에 쓴다.

## 인증

코드에서 판단한다.

- 라우트의 `->middleware('auth:sanctum')` / `'auth:api'` / `'jwt.auth'`
- `Route::group` · `Route::middleware([...])` 로 묶였으면 **상위 그룹까지** 본다
- 컨트롤러 생성자의 `$this->middleware('auth')`

Sanctum · Passport · JWT 면 Bearer 로 적는다.

```
인증: Bearer 토큰 필요 — Authorization: Bearer {access_token}
```

미들웨어가 없으면 아무것도 적지 않는다. 판단이 안 되면 `확인 필요` 를 단다.
**공통 인증 헤더를 파라미터 표에 중복해서 넣지 않는다.**

## 응답

- API Resource(`JsonResource`)가 있으면 `toArray()` 를 읽어 성공 응답 구조를 만든다
- 없으면 컨트롤러의 `response()->json(...)` 을 읽는다
- 값은 코드에서 읽히는 대표값으로 채운다
- 구조를 못 찾으면 지어내지 않는다. `<pre>` 자리에 `확인 필요` 만 남긴다

### 실패 응답

**상태코드별로 전부 나열하지 않는다. 대표 1개만 적는다.**

- 기본은 `500` 이다. 공통 에러 포맷(`Handler.php`, 공통 응답 헬퍼)을 찾아 그 구조로 쓴다
- 포맷을 못 찾으면 `확인 필요` 를 남긴다
- 그 API 에만 있는 특별한 실패(예: 결제 거절, 중복 예약)가 있으면 500 대신 그것을 쓴다.
  둘 다 적지 않는다

## 타입 매핑

검증 규칙(`rules()` 또는 `$request->validate()`)을 기준으로 판단한다.

| 규칙 | 타입 | 클래스 |
|---|---|---|
| `string` `email` `url` `uuid` `alpha_num` | STRING | `t-string` |
| `integer` | INT | `t-int` |
| `numeric` `decimal:...` | FLOAT | `t-float` |
| `boolean` | BOOL | `t-bool` |
| `array` | ARRAY | `t-array` |
| `json` | OBJECT | `t-object` |
| `date` | DATE | `t-date` |
| `date_format:...` | DATETIME | `t-datetime` |
| `file` `image` `mimes:...` | FILE | `t-file` |
| `in:a,b,c` · `Rule::enum(...)` | STRING | `t-string` |
| 그 외 | STRING | `t-etc` |

**형식 제약은 타입이 아니라 설명에 적는다.**

```
email            → STRING + "이메일 형식"
in:a,b,c         → STRING + "허용값: a, b, c"
max:255          → STRING + "최대 255자"
exists:users,id  → INT    + "존재하는 사용자 ID"
```

타입 이름은 항상 대문자로 쓴다.

### 필수 여부

| 규칙 | 표기 |
|---|---|
| `required` | REQUIRED |
| `required_if` · `required_with` 등 | REQUIRED + 설명에 조건 명시 |
| `nullable` · `sometimes` · 규칙 없음 | OPTIONAL |

## 하지 말 것

- 컨트롤러만 보고 넘어가지 않는다. FormRequest 와 라우트를 반드시 읽는다
- 파라미터나 응답을 추측해서 채우지 않는다. 모르면 `확인 필요` 를 남기고 계속 만든다
- 모르는 게 있다고 문서 만들기를 멈추거나 되묻지 않는다
- 실패 응답을 상태코드별로 나열하지 않는다. 대표 1개만 적는다
- 문서 경로를 직접 조립하거나 하드코딩하지 않는다. `docs-dir.ps1` 이 준 경로를 쓴다
- 작업 중인 프로젝트 안에 문서를 만들지 않는다. harness 로 모은다
- diff 만 보고 명세서를 만들지 않는다. 항상 현재 코드 전체를 읽는다
- 변경 이력을 문서에 남기지 않는다. NEW · CHANGED · REMOVED 배지도, 취소선도 쓰지 않는다
- 코드에서 사라진 파라미터를 문서에 남겨두지 않는다. 같이 지운다
- 이전 문서에 손으로 적어둔 설명을 덮어쓰지 않는다
- 형식 제약(`email`, `max:255`)을 타입 자리에 적지 않는다. 설명에 적는다
- 공통 인증 헤더를 파라미터 표에 중복해서 넣지 않는다
- HTML 소스를 대화창에 출력하지 않는다. 파일로만 만든다
- 마크다운으로 출력하지 않는다. 지라가 변환하지 않는다
- `.gitignore` 나 프로젝트 설정 파일을 수정하지 않는다
- `YYYY-MM-DD_*.html` 패턴이 아닌 파일을 지우지 않는다
- `assets/doc.css` 의 색·여백을 문서마다 바꾸지 않는다
