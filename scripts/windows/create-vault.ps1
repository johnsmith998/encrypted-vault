# 创建 VeraCrypt 加密保险库（Windows）
param(
    [string]$Size = "20G"
)

$ErrorActionPreference = "Stop"
. "$PSScriptRoot\vault-config.ps1"

$vc = Get-VeraCryptExe

if (Test-Path -LiteralPath $VaultPath) {
    Write-Host "已存在保险库，不会覆盖："
    Write-Host "  $VaultPath"
    Write-Host ""
    Write-Host "若要挂载，请运行："
    Write-Host "  .\scripts\windows\mount-vault.ps1"
    exit 1
}

Write-Host "========================================"
Write-Host "  创建加密保险库（Windows · VeraCrypt）"
Write-Host "========================================"
Write-Host ""
Write-Host "文件名：$VaultBundleName.hc"
Write-Host "位置：$VaultPath"
Write-Host "挂载盘符：${DriveLetter}:"
Write-Host "（改位置：.\scripts\windows\set-vault-location.ps1 `"路径\xxx.hc`"）"
Write-Host ""
Write-Host "容量上限：$Size"
Write-Host "加密：AES · 哈希：SHA-512 · 文件系统：NTFS"
Write-Host ""
Write-Host "接下来会弹出 VeraCrypt 创建向导，请设置强密码（12 位以上）。"
Write-Host "密码只记在本人脑中，不要写入文件或发给 AI。"
Write-Host ""
Read-Host "按回车开始创建"

New-Item -ItemType Directory -Force -Path $VaultDir | Out-Null

# 打开 VeraCrypt 创建向导（交互式设密码，比命令行传密码更安全）
& $vc /create /file $VaultPath /size $Size /encryption AES /hash SHA512 /filesystem NTFS /quit

Write-Host ""
Write-Host "若向导显示创建成功，下一步："
Write-Host "  1. 挂载：.\scripts\windows\mount-vault.ps1"
Write-Host "  2. 在资源管理器中打开 ${DriveLetter}: ，放入文件"
Write-Host "  3. 可选上锁：.\scripts\windows\unmount-vault.ps1"
