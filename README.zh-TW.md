# Bats Helper [![測試狀態](https://github.com/ycpss91255/bash_test_helper/workflows/Main%20CI/CD%20Pipeline/badge.svg)](https://github.com/ycpss91255/bash_test_helper/actions) [![覆蓋率](https://codecov.io/gh/ycpss91255/bash_test_helper/branch/main/graph/badge.svg)](https://codecov.io/gh/ycpss91255/bash_test_helper)

![語言](https://img.shields.io/badge/語言-Bash-blue?style=flat-square)
![測試框架](https://img.shields.io/badge/測試框架-Bats-orange?style=flat-square)
![語法檢查](https://img.shields.io/badge/語法檢查-符合規範-brightgreen?style=flat-square)
[![授權](https://img.shields.io/badge/授權-GPL--3.0-yellow?style=flat-square)](./LICENSE)

[English](./README.md) | [繁體中文]

這是一個專為 [Bats (Bash Automated Testing System)](https://github.com/bats-core/bats-core) 設計的輔助工具組，旨在簡化 Bash 腳本測試流程，並整合 Lint 檢查與覆蓋率報告。

## 🌟 特色

- **輔助函式**：提供 `set_default` (變數預設值) 與 `get_script_dir` (路徑獲取) 等常用工具。
- **內建函式庫**：自動載入 `bats-support`, `bats-assert`, `bats-file` 與 `bats-mock`。
- **自定義斷言**：包含 `assert_math` (數學比較) 與 `assert_pkg` (套件狀態檢查)。
- **完整 CI 流程**：單一腳本完成 ShellCheck 靜態檢查、Bats 測試與 Kcov 覆蓋率計算。
- **Codecov 整合**：預設的高品質覆蓋率標準設定。

## 📁 專案結構

```text
.
├── src/
│   ├── test_helper.bash     # 核心輔助工具
│   └── lib/                 # 自定義斷言庫
├── test/                    # 測試案例
├── ci.sh                    # 在地 CI 啟動腳本
├── cov-tui.py               # 覆蓋率 TUI 工具
├── docker-compose.yaml      # Docker 環境設定與 CI 邏輯
├── .codecov.yaml            # Codecov 設定檔
└── LICENSE                  # 授權檔案
```

## 📦 依賴項

執行在地 CI 流程需要具備：
- **Docker**: 用於執行測試環境。
- **Docker Compose**: 用於管理容器服務。
- **GitHub CLI (gh)**: (選配) 用於管理 PR 與 GitHub 協作。

CI 容器內部會自動處理以下工具：
- **Bats Core**: 測試框架。
- **ShellCheck**: 語法檢查工具。
- **Kcov**: 覆蓋率報告產生器。

## 🚀 快速上手

### 1. 在測試中引用 Helper
在您的 `.bats` 檔案中，透過 `setup` 載入 helper：

```bash
setup() {
    load 'src/test_helper.bash'
}

@test "測試變數預設值" {
    set_default "MY_VAR" "hello"
    assert_equal "${MY_VAR}" "hello"
}
```

### 2. 在地執行完整檢查 (CI)
如果您安裝了 **Docker** 與 **Docker Compose**，可以直接執行整合測試腳本：
```bash
chmod +x ci.sh
./ci.sh
```
此腳本會透過 `docker-compose.yaml` 自動執行：
1. **ShellCheck**: 檢查語法規範。
2. **Bats**: 執行所有單元測試。
3. **Kcov**: 產出覆蓋率報告於 `coverage/` 目錄。

## 🛠 開發指南

### ShellCheck 警告處理
本專案嚴格執行 ShellCheck 檢查。若有特殊的動態載入需求，請使用標籤抑制警告：
```bash
# shellcheck disable=SC1090
source "${DYNAMIC_PATH}"
```

### 測試覆蓋率
我們追求高品質的程式碼，設定如下：
- **新程式碼 (Patch)**: 必須 100% 覆蓋。
- **整體專案 (Project)**: 只進步，不退步 (`auto`)。

## 📄 授權
[GPL-3.0](./LICENSE)
