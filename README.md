# Encrypted Vault

[![License: MIT OR Commercial](https://img.shields.io/badge/License-MIT%20OR%20Commercial-blue.svg)](LICENSE)

Cross-platform **desktop** scripts to create, mount, and lock an encrypted file vault for documents, photos, videos, and backups.

| Platform | Technology | Vault file |
|----------|------------|------------|
| **macOS** | `hdiutil` + sparsebundle | `*.sparsebundle` |
| **Windows** | [VeraCrypt](https://www.veracrypt.fr) | `*.hc` |

> **Note:** macOS and Windows vault formats are **not interchangeable**. Use the same platform’s format on each machine. For mobile (Android / HarmonyOS), see [docs/mobile.md](docs/mobile.md).

## Quick start

From the repo root you can use either platform scripts or the unified CLI:

```bash
bash vault.sh create    # once
bash vault.sh mount     # open
bash vault.sh unmount   # lock
```

### macOS

```bash
cd /path/to/this/repo
bash scripts/macos/create-vault.sh      # once
bash scripts/macos/mount-vault.sh       # open
bash scripts/macos/unmount-vault.sh     # lock
```

Default vault path:

```
~/Library/Application Support/LocalPrefs/local.prefs.backup.sparsebundle
```

Mounted volume name: **LocalPrefs** → `/Volumes/LocalPrefs`

### Windows

1. Install [VeraCrypt](https://www.veracrypt.fr/en/Downloads.html)
2. Open PowerShell in this repo:

```powershell
cd C:\path\to\this-repo
.\scripts\windows\create-vault.ps1      # once
.\scripts\windows\mount-vault.ps1       # open
.\scripts\windows\unmount-vault.ps1     # lock
```

If execution policy blocks scripts:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\mount-vault.ps1
```

Default vault path:

```
%USERPROFILE%\Documents\LocalVault\local.prefs.backup.hc
```

Default drive letter: **V:**

## Custom location

Copy `config/vault.location.example` to `vault.location` in the repo root, or use:

```bash
# macOS
bash scripts/macos/set-vault-location.sh "/your/path/vault.sparsebundle"
```

```powershell
# Windows
.\scripts\windows\set-vault-location.ps1 "D:\Backups\local.prefs.backup.hc"
```

## Security

- **AES-256** (macOS sparsebundle) / **AES** (VeraCrypt)
- Password is **not recoverable** if forgotten
- Do **not** store passwords in notes, chat, or git
- Do **not** mount the vault into AI tools (Cursor, etc.) unless you intend to expose contents
- **Lock** (`unmount`) when done on shared machines

## Project layout

```
vault.sh           # unified CLI (macOS / Git Bash on Windows)
scripts/macos/     # bash + hdiutil
scripts/windows/   # PowerShell + VeraCrypt
config/            # example config
docs/              # detailed guides (Chinese)
vault.location     # local path (gitignored)
.env.local         # GITHUB_REPO + GITHUB_TOKEN for npm run git:push (gitignored)
```

## Push to GitHub

Remote: `https://github.com/johnsmith998/encrypted-vault.git`

1. Copy `.env.example` → `.env.local` and set `GITHUB_TOKEN` (classic PAT, `repo` scope; `GITHUB_REPO` is already filled).
2. Push updates:

```bash
npm run git:push
```

Or with SSH (if configured): `git push origin main`

## License

**Dual-licensed** — choose the terms that fit your use case:

| License | Document | Typical use |
|---------|----------|-------------|
| **MIT** | [LICENSE](LICENSE) | Personal, learning, open source (keep copyright notice) |
| **Commercial** | [COMMERCIAL.md](COMMERCIAL.md) | OEM, SaaS, enterprise rollout, SLA, indemnification |

Most users can use the project under **MIT** for free.  
For paid products, hosted services, or a written enterprise agreement, see **[COMMERCIAL.md](COMMERCIAL.md)** ([hztrade@gmail.com](mailto:hztrade@gmail.com) · GitHub Issue label `commercial`).

## 中文说明

详见 [docs/README.zh-CN.md](docs/README.zh-CN.md)。

**继续开发 / 上传 GitHub：** 见 [开发指南.md](开发指南.md)（含「未找到保险库」排查与两条初始化路线）。
