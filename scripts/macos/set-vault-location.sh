#!/usr/bin/env bash
# 设置保险库保存位置（创建前或迁移后均可配置）
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=vault-config.sh
source "${SCRIPT_DIR}/vault-config.sh"

LOCATION_FILE="${PROJECT_ROOT}/vault.location"

show_current() {
  echo "当前保险库路径："
  echo "  $VAULT_PATH"
  if [[ -e "$VAULT_PATH" ]]; then
    echo "  （文件已存在）"
  else
    echo "  （尚未创建）"
  fi
}

if [[ "${1:-}" == "" ]]; then
  echo "用法："
  echo "  bash scripts/macos/set-vault-location.sh                    # 查看当前路径"
  echo "  bash scripts/macos/set-vault-location.sh default            # 恢复默认（Library 下）"
  echo "  bash scripts/macos/set-vault-location.sh \"/你的/路径/xxx.sparsebundle\""
  echo ""
  show_current
  echo ""
  echo "默认路径："
  default_vault_path
  exit 0
fi

if [[ "$1" == "default" ]]; then
  rm -f "$LOCATION_FILE"
  # shellcheck source=vault-config.sh
  source "${SCRIPT_DIR}/vault-config.sh"
  echo "已恢复默认路径："
  echo "  $(default_vault_path)"
  exit 0
fi

NEW_PATH="$1"
NEW_PATH="${NEW_PATH/#\~/$HOME}"

if [[ "$NEW_PATH" != *.sparsebundle ]]; then
  echo "请提供完整文件名，且以 .sparsebundle 结尾，例如："
  echo "  ~/Library/Application Support/LocalPrefs/local.prefs.backup.sparsebundle"
  exit 1
fi

if [[ -e "$VAULT_PATH" && "$NEW_PATH" != "$VAULT_PATH" ]]; then
  echo "保险库已存在于："
  echo "  $VAULT_PATH"
  echo ""
  echo "若要搬迁，请先手动移动该文件到新位置，再运行本命令指向新路径。"
  echo "或保持原路径不变。"
  exit 1
fi

mkdir -p "$(dirname "$NEW_PATH")"
echo "$NEW_PATH" > "$LOCATION_FILE"
echo "已设置保险库路径："
echo "  $NEW_PATH"
