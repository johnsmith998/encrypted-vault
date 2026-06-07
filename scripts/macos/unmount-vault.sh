#!/usr/bin/env bash
# 卸载加密保险库（上锁）
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=vault-config.sh
source "${SCRIPT_DIR}/vault-config.sh"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "此脚本仅适用于 macOS。"
  echo "Windows 请使用：scripts\\windows\\unmount-vault.ps1"
  exit 1
fi

if ! mount | grep -q " on ${MOUNT_POINT} "; then
  echo "保险库当前未挂载，无需卸载。"
  exit 0
fi

hdiutil detach "$MOUNT_POINT"
echo "已上锁：${VAULT_VOLNAME}"
echo "（文件仍永久保存在加密包内，下次挂载输入密码即可继续访问）"
