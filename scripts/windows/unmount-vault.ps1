# 卸载 VeraCrypt 加密保险库（上锁）
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\vault-config.ps1"

$vc = Get-VeraCryptExe

if (-not (Test-Path -LiteralPath $MountPoint)) {
    Write-Host "保险库当前未挂载，无需卸载。"
    exit 0
}

& $vc /dismount $DriveLetter /quit /silent

Write-Host "已上锁：${DriveLetter}: ($VaultVolLabel)"
Write-Host "（文件仍永久保存在加密卷内，下次挂载输入密码即可继续访问）"
