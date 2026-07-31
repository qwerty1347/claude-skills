# Changelog

이 저장소의 주요 변경 사항을 기록한다.
형식은 [Keep a Changelog](https://keepachangelog.com/ko/1.1.0/) 를 따르고,
버전은 [Semantic Versioning](https://semver.org/lang/ko/) 을 따른다.

스킬을 추가·수정할 때마다 여기에 한 줄 남긴다. 무엇을 왜 바꿨는지가 남아야
나중에 "이 규칙은 왜 있지" 를 다시 안 묻는다.

## [Unreleased]

## [0.1.0] - 2026-07-31

### Added

- `/new-skill` — 새 스킬 뼈대를 만들고 트리거까지 검증하는 스킬 (Phase 0~7)
- `skills/new-skill/references/skill-writing-guide.md` — frontmatter 전체 필드,
  description 작성법, 점진적 공개, 트리거 검증 절차
- `docs/quickstart.md` — 5분 안에 첫 스킬 만들기
- `.claude-plugin/` — 플러그인 / 마켓플레이스 메타
- 저장소 구조를 [revfactory/harness](https://github.com/revfactory/harness) 기준으로 정리

### Notes

- 에이전트 · 팀 · 오케스트레이터는 아직 도입하지 않음. 스킬 하나가 손에 붙은 뒤에 판단한다.
- 설치는 `~/.claude/skills` 정션 링크 방식(개발용)만 사용 중. 플러그인 설치는 배포 시점에.

[Unreleased]: https://github.com/YOUR_HANDLE/harness/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/YOUR_HANDLE/harness/releases/tag/v0.1.0
