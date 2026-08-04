# 공용 경로 해석. open-doc.ps1 / docs-dir.ps1 이 점 소스로 불러 쓴다.
#
# 명세서는 실행한 프로젝트가 아니라 harness 저장소의 docs/api-docs/ 에 모은다.
# harness 위치는 PC 마다 다르므로 하드코딩하지 않는다.
# 이 스크립트 자신의 경로에서 거꾸로 찾아간다.

# ~/.claude/skills 는 harness/skills 를 가리키는 junction 이다.
# $PSScriptRoot 는 junction 쪽 경로로 잡히므로 실제 경로로 되돌린다.
function Resolve-LinkPath {
    param([string]$Path)

    $tail = @()
    $cur  = $Path

    while ($cur) {
        $item = Get-Item -LiteralPath $cur -Force -ErrorAction SilentlyContinue
        if ($item -and $item.Target) {
            $real = @($item.Target)[0]
            if ($tail.Count -gt 0) { $real = Join-Path $real ($tail -join '\') }
            return $real
        }

        $parent = Split-Path $cur -Parent
        if (-not $parent -or $parent -eq $cur) { break }

        $tail = ,(Split-Path $cur -Leaf) + $tail
        $cur  = $parent
    }

    return $Path
}

# harness 루트 = .claude-plugin 이 있는 상위 폴더
function Get-HarnessRoot {
    $here = Resolve-LinkPath $PSScriptRoot
    $cur  = $here

    while ($cur) {
        if (Test-Path (Join-Path $cur '.claude-plugin')) { return $cur }

        $parent = Split-Path $cur -Parent
        if (-not $parent -or $parent -eq $cur) { break }
        $cur = $parent
    }

    # 마커를 못 찾으면 구조로 되짚는다: scripts -> api-doc -> skills -> harness
    return (Split-Path (Split-Path (Split-Path $here -Parent) -Parent) -Parent)
}

function Get-ApiDocsDir {
    return (Join-Path (Get-HarnessRoot) 'docs\api-docs')
}
