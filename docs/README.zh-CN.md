# 加密保险库 · 电脑端使用说明

> 通用开源版 · 适配 **macOS** 与 **Windows**  
> 更新：2026-06-07

**开发者 / 上传 GitHub：** 请看项目根目录 [开发指南.md](../开发指南.md)（含「未找到保险库」原因与修复步骤）。

## 是什么

把任意文件（文档、照片、视频、备份等）放进**加密保险库**。  
**上锁**后无密码打不开；上锁**不是删除**，文件仍在硬盘里。

| 系统 | 打开后像 | 底层 |
|------|----------|------|
| macOS | 访达里的 **LocalPrefs** 卷 | `.sparsebundle` |
| Windows | 资源管理器 **V:** 盘（可改盘符） | VeraCrypt `.hc` |

⚠️ **Mac 与 Windows 的保险库文件格式不同，不能互相直接打开。** 各平台用自己的脚本即可。

---

## 一、macOS 快速上手

### 首次创建（只需一次）

```bash
cd "/path/to/important file git"
bash scripts/macos/create-vault.sh
```

默认容量 20GB，可指定例如 `bash scripts/macos/create-vault.sh 50g`。

### 打开

```bash
bash scripts/macos/mount-vault.sh
```

输入密码 → 访达出现 **LocalPrefs** → 像普通文件夹使用。

### 上锁

```bash
bash scripts/macos/unmount-vault.sh
```

或访达侧边栏对 **LocalPrefs** 点 **推出**。

> 关访达窗口 ❌ **不等于**上锁。

### 默认路径

```
~/Library/Application Support/LocalPrefs/local.prefs.backup.sparsebundle
```

改路径：

```bash
bash scripts/macos/set-vault-location.sh "/新路径/xxx.sparsebundle"
```

---

## 二、Windows 快速上手

### 前提

安装 [VeraCrypt](https://www.veracrypt.fr/en/Downloads.html)（免费）。

### 首次创建

在 PowerShell 中：

```powershell
cd "C:\path\to\important file git"
.\scripts\windows\create-vault.ps1
```

按 VeraCrypt 向导设置密码。

若提示无法运行脚本：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\create-vault.ps1
```

### 打开

```powershell
.\scripts\windows\mount-vault.ps1
```

在 VeraCrypt 密码框输入密码 → 资源管理器打开 **V:** 盘。

### 上锁

```powershell
.\scripts\windows\unmount-vault.ps1
```

### 默认路径

```
%USERPROFILE%\Documents\LocalVault\local.prefs.backup.hc
```

改路径：

```powershell
.\scripts\windows\set-vault-location.ps1 "D:\Backups\local.prefs.backup.hc"
```

改盘符（默认 V:）：

```powershell
.\scripts\windows\set-drive-letter.ps1 W
```

---

## 三、自定义保险库位置

1. 复制 `config/vault.location.example` 为项目根目录的 `vault.location`
2. 写一行完整路径（不要引号）
3. 或用上面各平台的 `set-vault-location` 脚本

`vault.location` 已在 `.gitignore` 中，不会上传到 GitHub。

---

## 四、常见问题

**Q：密码忘了？**  
A：无法找回，只能新建空库（旧数据永久打不开）。

**Q：删了 Git 项目，文件还在吗？**  
A：在。保险库在 `vault.location` 或默认路径，不在项目文件夹里。  
Mac 仍可用：`hdiutil attach "路径/xxx.sparsebundle"`  
Windows 仍可用 VeraCrypt 图形界面挂载 `.hc` 文件。

**Q：关机后会丢吗？**  
A：不会；会自动上锁，下次重新打开即可。

**Q：拔外置硬盘前？**  
A：先上锁，再安全弹出硬盘。

---

## 五、安全提醒

- 密码 ≥ 12 位，含字母、数字、符号
- 不要告诉 AI、不要写在云端备忘录
- 不要把已解锁的保险库文件夹拖给 Cursor / AI 读取
- 共用电脑建议用完就上锁

---

## 六、与私人版 `important file` 的区别

| 项目 | 私人版 | 本仓库（Git 版） |
|------|--------|------------------|
| 路径 | 含个人硬盘、iPhone 路径 | 通用默认路径 |
| iPhone 导入脚本 | 有 | 无（可另加 optional 文档） |
| Windows | 无 | VeraCrypt 脚本 |
| 可上传 GitHub | 不宜 | 可以 |

---

## 七、许可（双许可）

| 许可 | 文件 | 适用 |
|------|------|------|
| **MIT** | [LICENSE](../LICENSE) | 个人、学习、开源（须保留版权声明） |
| **商业许可** | [COMMERCIAL.md](../COMMERCIAL.md) | OEM、SaaS、企业部署、SLA、书面协议 |

个人自用一般 **MIT 免费** 即可。  
若将本项目嵌入 **收费产品**、**托管服务** 或需要 **企业合同**，请阅读 [COMMERCIAL.md](../COMMERCIAL.md)（[hztrade@gmail.com](mailto:hztrade@gmail.com) · GitHub Issue 标签 `commercial`）。
