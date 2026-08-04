# 명세서를 만들 폴더를 준비하고 그 절대경로를 출력한다.
# 7일 지난 산출물 정리도 여기서 한다. 삭제를 모델에 맡기지 않기 위한 것이다.
# 인자를 받지 않는다 - 명령이 고정되어야 allowed-tools 로 미리 승인된다.

. (Join-Path $PSScriptRoot '_paths.ps1')

$dir = Get-ApiDocsDir

if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

# YYYY-MM-DD_*.html 만 지운다. 패턴이 다른 파일은 남이 넣은 것일 수 있다.
$cutoff  = (Get-Date).Date.AddDays(-7)
$removed = 0

Get-ChildItem -Path $dir -Filter '*.html' -File | ForEach-Object {
    if ($_.Name -notmatch '^(\d{4})-(\d{2})-(\d{2})_') { return }

    # 날짜로 못 읽으면 건드리지 않는다.
    # 파싱 실패를 삭제로 이어지게 두면 폴더를 통째로 비운다.
    try {
        $stamp = [datetime]::ParseExact(
            "$($Matches[1])-$($Matches[2])-$($Matches[3])", 'yyyy-MM-dd',
            [Globalization.CultureInfo]::InvariantCulture)
    }
    catch { return }

    if ($stamp -is [datetime] -and $stamp -lt $cutoff) {
        Remove-Item -LiteralPath $_.FullName -Force
        $removed++
    }
}

if ($removed -gt 0) {
    Write-Output "removed $removed old file(s)"
}

Write-Output $dir
