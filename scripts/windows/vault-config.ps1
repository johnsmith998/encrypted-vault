# 保险库配置（Windows · VeraCrypt）
$ErrorActionPreference = "Stop"

$VaultBundleName = "local.prefs.backup"
$VaultVolLabel = "LocalPrefs"
$DefaultDriveLetter = "V"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)
$LocationFile = Join-Path $ProjectRoot "vault.location"

function Get-DefaultVaultPath {
    Join-Path $env:USERPROFILE "Documents\LocalVault\$VaultBundleName.hc"
}

function Get-VeraCryptExe {
    $candidates = @(
        "${env:ProgramFiles}\VeraCrypt\VeraCrypt.exe"
        "${env:ProgramFiles(x86)}\VeraCrypt\VeraCrypt.exe"
    )
    foreach ($path in $candidates) {
        if (Test-Path -LiteralPath $path) {
            return $path
        }
    }
    throw "未找到 VeraCrypt。请从 https://www.veracrypt.fr 安装后再试。"
}

function Get-VaultPath {
    if ($env:VAULT_PATH_OVERRIDE) {
        return $env:VAULT_PATH_OVERRIDE
    }
    if (Test-Path -LiteralPath $LocationFile) {
        $line = (Get-Content -LiteralPath $LocationFile -Raw).Trim()
        if ($line -match '^%USERPROFILE%\\(.+)$') {
            return Join-Path $env:USERPROFILE $Matches[1]
        }
        if ($line -match '^~\\(.+)$') {
            return Join-Path $env:USERPROFILE $Matches[1]
        }
        return $line
    }
    return Get-DefaultVaultPath
}

function Get-MountDriveLetter {
    $letterFile = Join-Path $ProjectRoot "vault.drive-letter"
    if (Test-Path -LiteralPath $letterFile) {
        $letter = (Get-Content -LiteralPath $letterFile -Raw).Trim().ToUpper()
        if ($letter -match '^[A-Z]$') {
            return $letter
        }
    }
    return $DefaultDriveLetter
}

$VaultPath = Get-VaultPath
$VaultDir = Split-Path -Parent $VaultPath
$DriveLetter = Get-MountDriveLetter
$MountPoint = "${DriveLetter}:"
