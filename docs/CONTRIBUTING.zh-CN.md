# 维护与贡献指南

> 面向：克隆本仓库后的**二次开发、Issue 处理、发布更新**  
> 普通用户请阅读 [README.zh-CN.md](README.zh-CN.md)  
> 更新：2026-06-07

---

## 一、文档分工（公开仓库里各文件干什么）

| 文件 | 读者 | 是否含个人路径 |
|------|------|----------------|
| [README.md](../README.md) | 全球用户（英文首页） | 否 |
| [docs/README.zh-CN.md](README.zh-CN.md) | 中文用户 | 否 |
| [docs/mobile.md](mobile.md) | 手机端说明 | 否 |
| [COMMERCIAL.md](../COMMERCIAL.md) | 商业授权咨询 | 仅公开联系方式 |
| **本文件** `CONTRIBUTING.zh-CN.md` | 维护者 / 贡献者 | 否（示例路径均为占位） |
| `开发者指南.md`（项目根目录） | **仅仓库维护者本机** | 可含个人路径；**不提交 GitHub** |

> **说明：** 早期曾把同一份「开发指南」放在根目录 `开发指南.md` 与 `docs/开发指南.md` 两处手动同步，容易重复且会把维护者私人路径带上 GitHub。现已改为：**公开仓用 `docs/CONTRIBUTING*.md`；私人维护笔记用根目录 `开发者指南.md`（已在 `.gitignore`）。**

---

## 二、仓库与远程

| 项 | 值 |
|---|---|
| **GitHub** | [johnsmith998/encrypted-vault](https://github.com/johnsmith998/encrypted-vault) |
| **HTTPS 远程** | `https://github.com/johnsmith998/encrypted-vault.git` |
| **SSH 远程** | `git@github.com:johnsmith998/encrypted-vault.git` |

创建 GitHub 仓库时建议：**Public**，**不要**勾选 Add README / .gitignore / License（本地已有）。

---

## 三、推送更新

`origin` 默认指向 HTTPS 地址。

### 方式 1：PAT 脚本（推荐，token 不写进 git config）

```bash
cp .env.example .env.local
# 编辑 .env.local，只填 GITHUB_TOKEN（GITHUB_REPO 已在 .env.example）
npm run git:push
```

建议使用 **Fine-grained PAT**，仅授权 `encrypted-vault` 仓库。

### 方式 2：HTTPS

```bash
git push origin main
```

### 方式 3：SSH

```bash
git push git@github.com:johnsmith998/encrypted-vault.git main
```

---

## 四、提交前检查

```bash
git status
```

**不应出现：**

- `vault.location`、`.env.local`
- `*.sparsebundle` / `*.hc`
- `开发者指南.md`（本机维护笔记）
- 个人绝对路径写死在即将提交的文档里

语法检查（macOS 脚本）：

```bash
npm run check:macos
# 或：bash -n scripts/macos/*.sh
```

---

## 五、双许可与商务联系

| 许可 | 文件 |
|------|------|
| MIT（社区） | [LICENSE](../LICENSE) |
| 商业许可 | [COMMERCIAL.md](../COMMERCIAL.md) · [LICENSE-COMMERCIAL](../LICENSE-COMMERCIAL) |

商务联系（公开）：[hztrade@gmail.com](mailto:hztrade@gmail.com) · GitHub Issue 标签 `commercial`

---

## 六、初始化保险库（维护者自测）

### 测试库（推荐首次验证）

```bash
git clone https://github.com/johnsmith998/encrypted-vault.git
cd encrypted-vault

bash scripts/macos/create-vault.sh 5g
# 按回车 → 终端输入密码（两次）→ 等待创建

bash scripts/macos/mount-vault.sh
bash scripts/macos/unmount-vault.sh
```

默认路径：

```text
~/Library/Application Support/LocalPrefs/local.prefs.backup.sparsebundle
```

自定义路径：

```bash
bash scripts/macos/set-vault-location.sh "/your/path/vault.sparsebundle"
```

### macOS 15+ 注意

若出现 `hdiutil: create failed - 不适当的设备ioctl`，说明脚本在等 **终端密码输入** 或需使用已修复的 `-stdinpass` 版本；勿在管道里运行脚本。

---

## 七、故障排查（公开版）

| 现象 | 处理 |
|------|------|
| 未找到保险库 | `set-vault-location.sh` 指路径，或 `create-vault.sh` 新建 |
| 脚本卡住 | 是否在等回车 / 密码（输入时光标不动是正常的） |
| ioctl 错误 | 使用最新脚本；在交互式终端运行 |
| 资源忙无法 detach | 关闭占用文件的 App；再 `unmount-vault.sh` |
| Windows 脚本被拦截 | `powershell -ExecutionPolicy Bypass -File ...` |

---

## 八、后续开发优先级（摘要）

| 优先级 | 内容 |
|--------|------|
| P1 | Topics、Issue 标签 `commercial`、可选截图 |
| P2 | Windows 真机实测、Cryptomator 文档、CI shellcheck |
| P3 | 手机端调研（见 [mobile.md](mobile.md)） |

详细维护笔记与私人路径配置见本机 **`开发者指南.md`**（不公开）。

---

## 九、与 AI / Cursor 协作

1. 公开文档勿写入个人硬盘路径；示例用 `/your/path/`。
2. 不要让 AI 读取已挂载的 `/Volumes/LocalPrefs` 内容。
3. 改脚本后执行 `bash -n scripts/macos/*.sh`。

变更记录见 [CHANGELOG.md](CHANGELOG.md)。
