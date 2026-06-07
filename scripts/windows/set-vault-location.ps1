# 设置保险库保存位置（创建前或迁移后均可配置）
param(
    [Parameter(Position = 0)]
    [string]$NewPath
)

$ErrorActionPreference = "Stop"
. "$PSScriptRoot\vault-config.ps1"

function Show-Current {
    Write-Host "当前保险库路径："
    Write-Host "  $VaultPath"
    if (Test-Path -LiteralPath $VaultPath) {
        Write-Host "  （文件已存在）"
    } else {
        Write-Host "  （尚未创建）"
    }
    Write-Host ""
    Write-Host "当前挂载盘符：${DriveLetter}:"
}

if (-not $NewPath) {
    Write-Host "用法："
    Write-Host "  .\scripts\windows\set-vault-location.ps1                          # 查看当前路径"
    Write-Host "  .\scripts\windows\set-vault-location.ps1 default                  # 恢复默认"
    Write-Host "  .\scripts\windows\set-vault-location.ps1 `"C:\path\vault.hc`""
    Write-Host ""
    Show-Current
    Write-Host ""
    Write-Host "默认路径："
    Write-Host "  $(Get-DefaultVaultPath)"
    exit 0
}

if ($NewPath -eq "default") {
    if (Test-Path -LiteralPath $LocationFile) {
        Remove-Item -LiteralPath $LocationFile -Force
    }
    Write-Host "已恢复默认路径："
    Write-Host "  $(Get-DefaultVaultPath)"
    exit 0
}

if ($NewPath -notmatch '\.hc$') {
    Write-Host "请提供完整文件名，且以 .hc 结尾，例如："
    Write-Host "  $env:USERPROFILE\Documents\LocalVault\local.prefs.backup.hc"
    exit 1
}

$expanded = [Environment]::ExpandEnvironmentVariables($NewPath)
if ($expanded -match '^~\\(.+)$') {
    $expanded = Join-Path $env:USERPROFILE $Matches[1]
}

if ((Test-Path -LiteralPath $VaultPath) -and ($expanded -ne $VaultPath)) {
    Write-Host "保险库已存在于："
    Write-Host "  $VaultPath"
    Write-Host ""
    Write-Host "若要搬迁，请先手动移动该文件到新位置，再运行本命令指向新路径。"
    exit 1
}

$dir = Split-Path -Parent $expanded
New-Item -ItemType Directory -Force -Path $dir | Out-Null
Set-Content -LiteralPath $LocationFile -Value $expanded -NoNewline
Write-Host "已设置保险库路径："
Write-Host "  $expanded"
