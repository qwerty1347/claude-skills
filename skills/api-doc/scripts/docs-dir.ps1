# 명세서를 만들 폴더를 만들고 그 절대경로를 출력한다.
# 인자를 받지 않는다 - 명령이 고정되어야 allowed-tools 로 미리 승인된다.

. (Join-Path $PSScriptRoot '_paths.ps1')

$dir = Get-ApiDocsDir

if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

Write-Output $dir
