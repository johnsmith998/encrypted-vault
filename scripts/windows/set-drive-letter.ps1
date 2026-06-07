# 设置 VeraCrypt 挂载盘符（可选，默认 V:）
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidatePattern('^[A-Za-z]$')]
    [string]$Letter
)

$ErrorActionPreference = "Stop"
. "$PSScriptRoot\vault-config.ps1"

$letterFile = Join-Path $ProjectRoot "vault.drive-letter"
$upper = $Letter.ToUpper()
Set-Content -LiteralPath $letterFile -Value $upper -NoNewline
Write-Host "已设置挂载盘符：${upper}:"
