# 挂载 VeraCrypt 加密保险库
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\vault-config.ps1"

$vc = Get-VeraCryptExe

if (-not (Test-Path -LiteralPath $VaultPath)) {
    Write-Host "未找到保险库，请先创建："
    Write-Host "  .\scripts\windows\create-vault.ps1"
    exit 1
}

if (Test-Path -LiteralPath $MountPoint) {
    $vol = Get-Volume -DriveLetter $DriveLetter -ErrorAction SilentlyContinue
    if ($vol -and $vol.FileSystemLabel -eq $VaultVolLabel) {
        Write-Host "保险库已挂载：$MountPoint"
        explorer.exe $MountPoint
        exit 0
    }
}

Write-Host "正在挂载「$VaultVolLabel」到 ${DriveLetter}: …"
Write-Host "请在弹出的 VeraCrypt 窗口中输入密码。"

# 不加 /silent，由 VeraCrypt 弹出密码框（比命令行传密码更安全）
& $vc /volume $VaultPath /letter $DriveLetter /quit

Start-Sleep -Seconds 1

if (Test-Path -LiteralPath $MountPoint) {
    Write-Host ""
    Write-Host "已打开 $MountPoint ，文件会永久保存在加密卷内。"
    Write-Host "可选：用完后执行 .\scripts\windows\unmount-vault.ps1 上锁（上锁不会删除文件）"
    explorer.exe $MountPoint
} else {
    Write-Host "挂载未完成。请检查密码或 VeraCrypt 提示。"
    exit 1
}
