#!/usr/bin/env bash
# 保险库配置（macOS · hdiutil + sparsebundle）
VAULT_BUNDLE_NAME="local.prefs.backup"
VAULT_VOLNAME="LocalPrefs"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
LOCATION_FILE="${PROJECT_ROOT}/vault.location"

default_vault_path() {
  echo "${HOME}/Library/Application Support/LocalPrefs/${VAULT_BUNDLE_NAME}.sparsebundle"
}

if [[ -n "${VAULT_PATH_OVERRIDE:-}" ]]; then
  VAULT_PATH="$VAULT_PATH_OVERRIDE"
elif [[ -f "$LOCATION_FILE" ]]; then
  VAULT_PATH="$(tr -d '\r\n' < "$LOCATION_FILE" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  VAULT_PATH="${VAULT_PATH/#\~/$HOME}"
else
  VAULT_PATH="$(default_vault_path)"
fi

VAULT_DIR="$(dirname "$VAULT_PATH")"
MOUNT_POINT="/Volumes/${VAULT_VOLNAME}"

require_tty() {
  if [[ ! -t 0 ]]; then
    echo "错误：需要在交互式终端中运行。"
    echo "请打开「终端.app」或 Cursor 终端，cd 到项目目录后再执行本脚本。"
    exit 1
  fi
}

read_vault_password() {
  local prompt="$1"
  local pass=""
  require_tty
  read -r -s -p "$prompt" pass
  echo ""
  printf '%s' "$pass"
}
