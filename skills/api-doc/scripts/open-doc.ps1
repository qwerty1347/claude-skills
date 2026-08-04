# harness 저장소의 docs/skills/api-doc/output/ 에서 가장 최근 .html 을 브라우저로 연다.
# 인자를 받지 않는다 - 명령이 고정되어야 allowed-tools 로 미리 승인된다.

. (Join-Path $PSScriptRoot '_paths.ps1')

$dir = Get-ApiDocsDir

if (-not (Test-Path $dir)) {
    Write-Output "No such folder: $dir"
    exit 1
}

$latest = Get-ChildItem -Path $dir -Filter *.html -File |
          Sort-Object LastWriteTime -Descending |
          Select-Object -First 1

if ($null -eq $latest) {
    Write-Output "No document to open in: $dir"
    exit 1
}

# cmd 의 start 로 완전히 분리해서 띄운다.
# Start-Process 로 띄우면 브라우저가 출력 파이프를 물고 있어
# 창을 닫을 때까지 호출한 쪽이 끝나지 않는다.
cmd.exe /c start "" $latest.FullName | Out-Null

Write-Output $latest.FullName
