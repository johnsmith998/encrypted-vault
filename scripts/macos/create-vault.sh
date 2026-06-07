#!/usr/bin/env bash
# 创建 AES-256 加密保险库（macOS · 仅你知道密码才能打开）
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=vault-config.sh
source "${SCRIPT_DIR}/vault-config.sh"

DEFAULT_SIZE="20g"
SIZE="${1:-$DEFAULT_SIZE}"
: "${SIZE:=20g}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "此脚本仅适用于 macOS。"
  echo "Windows 请使用：scripts\\windows\\create-vault.ps1"
  exit 1
fi

if [[ -e "$VAULT_PATH" ]]; then
  echo "已存在保险库，不会覆盖："
  echo "  $VAULT_PATH"
  echo ""
  echo "若要挂载，请运行："
  echo "  bash scripts/macos/mount-vault.sh"
  exit 1
fi

echo "========================================"
echo "  创建加密保险库（macOS）"
echo "========================================"
echo ""
echo "文件名：${VAULT_BUNDLE_NAME}.sparsebundle"
echo "位置：$VAULT_PATH"
echo "（改位置：bash scripts/macos/set-vault-location.sh \"/新路径/xxx.sparsebundle\"）"
echo ""
mkdir -p "$VAULT_DIR"
printf '容量上限：%s（稀疏包，实际只占已存文件大小）\n' "${SIZE}"
echo "加密：AES-256 · 文件系统：APFS"
echo ""
echo "接下来会在本终端输入密码（不显示字符，属正常现象）。"
echo "请设置强密码，并只记在本人脑中，不要写入任何文件或发给 AI。"
echo ""
read -r -p "按回车开始创建…"

PASS1="$(read_vault_password "请设置保险库密码: ")"
PASS2="$(read_vault_password "请再次输入密码确认: ")"

if [[ -z "$PASS1" ]]; then
  echo "密码不能为空。"
  exit 1
fi

if [[ "$PASS1" != "$PASS2" ]]; then
  echo "两次密码不一致，已取消创建。"
  exit 1
fi

echo ""
echo "正在创建加密包（约需数秒）…"

printf '%s\n' "$PASS1" | hdiutil create \
  -size "$SIZE" \
  -type SPARSEBUNDLE \
  -fs APFS \
  -volname "$VAULT_VOLNAME" \
  -encryption AES-256 \
  -stdinpass \
  "$VAULT_PATH"

unset PASS1 PASS2

echo ""
echo "创建成功。"
echo ""
echo "下一步："
echo "  1. 挂载：bash scripts/macos/mount-vault.sh"
echo "  2. 在访达中打开「${VAULT_VOLNAME}」卷，放入文件"
echo "  3. 可选上锁：bash scripts/macos/unmount-vault.sh"
