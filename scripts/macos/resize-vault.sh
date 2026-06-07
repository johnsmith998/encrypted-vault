#!/usr/bin/env bash
# 扩大已创建的加密保险库容量（需先上锁）
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=vault-config.sh
source "${SCRIPT_DIR}/vault-config.sh"

NEW_SIZE="${1:-}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "此脚本仅适用于 macOS。"
  exit 1
fi

if [[ -z "$NEW_SIZE" ]]; then
  echo "用法：bash scripts/macos/resize-vault.sh <容量>"
  echo "示例：bash scripts/macos/resize-vault.sh 150g"
  exit 1
fi

if [[ ! -e "$VAULT_PATH" ]]; then
  echo "未找到保险库：$VAULT_PATH"
  exit 1
fi

if mount | grep -q " on ${MOUNT_POINT} "; then
  echo "请先上锁：bash scripts/macos/unmount-vault.sh"
  echo "（若提示资源忙，请关闭 Preview/访达中打开的 ${VAULT_VOLNAME} 文件后重试）"
  exit 1
fi

echo "正在将保险库扩大到 ${NEW_SIZE}…"
echo "  $VAULT_PATH"
hdiutil resize -size "$NEW_SIZE" "$VAULT_PATH"
echo ""
echo "扩大完成。请重新打开：bash scripts/macos/mount-vault.sh"
