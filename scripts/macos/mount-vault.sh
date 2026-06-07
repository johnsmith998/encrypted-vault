#!/usr/bin/env bash
# 挂载加密保险库（需要密码）
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=vault-config.sh
source "${SCRIPT_DIR}/vault-config.sh"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "此脚本仅适用于 macOS。"
  echo "Windows 请使用：scripts\\windows\\mount-vault.ps1"
  exit 1
fi

if [[ ! -e "$VAULT_PATH" ]]; then
  echo "未找到保险库，请先创建："
  echo "  bash scripts/macos/create-vault.sh"
  exit 1
fi

if mount | grep -q " on ${MOUNT_POINT} "; then
  echo "保险库已挂载：${MOUNT_POINT}"
  open "$MOUNT_POINT"
  exit 0
fi

echo "正在挂载「${VAULT_VOLNAME}」…"
PASS="$(read_vault_password "请输入保险库密码: ")"

if [[ -z "$PASS" ]]; then
  echo "密码不能为空。"
  exit 1
fi

printf '%s\n' "$PASS" | hdiutil attach -stdinpass "$VAULT_PATH"
unset PASS
open "$MOUNT_POINT"
echo ""
echo "已打开，文件会永久保存在加密包内。"
echo "可选：用完后执行 bash scripts/macos/unmount-vault.sh 上锁（上锁不会删除文件）"
