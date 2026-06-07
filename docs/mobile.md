# 手机端说明（Android / 鸿蒙 / iOS）

本仓库的**脚本仅面向电脑端**（macOS / Windows）。手机无法直接运行 `hdiutil` 或 PowerShell + VeraCrypt CLI。

## 若要在手机上使用加密文件

推荐与电脑**分开**的方案（或未来统一改用 Cryptomator 等跨平台格式）：

| 方案 | Android | 鸿蒙 | 与电脑同一文件 |
|------|---------|------|----------------|
| [Cryptomator](https://cryptomator.org/) | ✅ 官方 App | ⚠️ 视能否安装 Android 应用 | ✅ 若电脑也用 Cryptomator |
| VeraCrypt + EDS 等 | ⚠️ 第三方客户端 | ⚠️ 有限 | ⚠️ 与 Windows `.hc` 理论上可互通，体验一般 |
| 系统自带（Secure Folder 等） | 各厂商不同 | 应用锁 / 隐私空间 | ❌ 与电脑脚本无关 |

## 与当前电脑保险库的关系

- **macOS `.sparsebundle`**：手机端**无法**原生打开。
- **Windows `.hc`（VeraCrypt）**：部分 Android 工具可挂载，鸿蒙支持不确定，**不建议**作为日常手机方案。

## 建议工作流

1. 电脑上用本仓库脚本管理主保险库。
2. 需要带出门的文件：复制到手机上的 Cryptomator vault，或加密压缩包（单独强密码）。
3. 换机备份：在电脑上打开保险库后，用数据线 / 云盘同步**已加密容器文件**（无密码仍打不开）。

如需后续在本仓库增加「Cryptomator 统一跨平台」文档或脚本，可单独开 issue / 任务。
