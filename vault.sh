#!/usr/bin/env bash
# Cross-platform vault CLI — delegates to macOS bash or Windows PowerShell scripts.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
CMD="${1:-}"

usage() {
  cat <<'EOF'
用法: bash vault.sh <command> [args…]

命令:
  create [size]   首次创建保险库（macOS 默认 20g）
  mount           打开 / 挂载
  unmount         上锁 / 卸载
  location [path] 查看或设置保险库路径
  resize [size]   扩容（macOS，需先上锁）

示例:
  bash vault.sh mount
  bash vault.sh location "/path/to/vault.sparsebundle"
EOF
}

case "$(uname -s)" in
  Darwin)
    MACOS="${ROOT}/scripts/macos"
    case "$CMD" in
      create)  shift; exec bash "${MACOS}/create-vault.sh" "$@" ;;
      mount)   exec bash "${MACOS}/mount-vault.sh" ;;
      unmount) exec bash "${MACOS}/unmount-vault.sh" ;;
      location) shift; exec bash "${MACOS}/set-vault-location.sh" "$@" ;;
      resize)  shift; exec bash "${MACOS}/resize-vault.sh" "$@" ;;
      ""|-h|--help|help) usage ;;
      *)
        echo "未知命令: $CMD"
        usage
        exit 1
        ;;
    esac
    ;;
  MINGW*|MSYS*|CYGWIN*)
    WIN="${ROOT}/scripts/windows"
    case "$CMD" in
      create)  powershell -ExecutionPolicy Bypass -File "${WIN}/create-vault.ps1" ;;
      mount)   powershell -ExecutionPolicy Bypass -File "${WIN}/mount-vault.ps1" ;;
      unmount) powershell -ExecutionPolicy Bypass -File "${WIN}/unmount-vault.ps1" ;;
      location)
        shift
        powershell -ExecutionPolicy Bypass -File "${WIN}/set-vault-location.ps1" "$@"
        ;;
      resize)
        echo "Windows 请用 VeraCrypt 图形界面扩容。"
        exit 1
        ;;
      ""|-h|--help|help) usage ;;
      *)
        echo "未知命令: $CMD"
        usage
        exit 1
        ;;
    esac
    ;;
  *)
    echo "此 CLI 仅支持 macOS 与 Windows（Git Bash / MSYS）。"
    echo "Linux 请直接使用各平台脚本或参阅 docs/mobile.md。"
    exit 1
    ;;
esac
