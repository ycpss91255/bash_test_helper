# Bats Helper [![Test Status](https://github.com/ycpss91255/bash_test_helper/workflows/Main%20CI/CD%20Pipeline/badge.svg)](https://github.com/ycpss91255/bash_test_helper/actions) [![Code Coverage](https://codecov.io/gh/ycpss91255/bash_test_helper/branch/main/graph/badge.svg)](https://codecov.io/gh/ycpss91255/bash_test_helper)

![Language](https://img.shields.io/badge/Language-Bash-blue?style=flat-square)
![Testing](https://img.shields.io/badge/Testing-Bats-orange?style=flat-square)
![ShellCheck](https://img.shields.io/badge/ShellCheck-Compliant-brightgreen?style=flat-square)
[![License](https://img.shields.io/badge/License-GPL--3.0-yellow?style=flat-square)](./LICENSE)

[English] | [繁體中文](./README.zh-TW.md)

A specialized helper toolkit for [Bats (Bash Automated Testing System)](https://github.com/bats-core/bats-core), designed to simplify Bash script testing, integrate linting, and generate coverage reports.

## 🌟 Features

- **Utility Functions**: Includes `set_default` (variable defaults) and `get_script_dir` (path resolution).
- **Built-in Libraries**: Automatically loads `bats-support`, `bats-assert`, `bats-file`, and `bats-mock`.
- **Custom Assertions**: Includes `assert_math` (mathematical comparisons) and `assert_pkg` (package status checks).
- **Unified CI Flow**: A single script handles ShellCheck linting, Bats testing, and Kcov coverage.
- **Codecov Integration**: Pre-configured high-quality coverage standards.

## 📁 Project Structure

```text
.
├── src/
│   ├── test_helper.bash     # Core helper utilities
│   └── lib/                 # Custom assertion libraries
├── test/                    # Test cases
├── ci.sh                    # Local CI entry point
├── cov-tui.py               # Coverage TUI tool
├── docker-compose.yaml      # Docker environment & CI logic
├── .codecov.yaml            # Codecov configuration
└── LICENSE                  # License file
```

## 📦 Dependencies

To run the local CI workflow, you need:
- **Docker**: For running the testing environment.
- **Docker Compose**: For managing the container services.
- **GitHub CLI (gh)**: (Optional) For managing PRs and GitHub interactions.

The CI container automatically handles the following:
- **Bats Core**: Testing framework.
- **ShellCheck**: Static analysis tool.
- **Kcov**: Coverage report generator.

## 🚀 Quick Start

### 1. Using the Helper in Tests
Load the helper in your `.bats` file via `setup`:

```bash
setup() {
    load 'src/test_helper.bash'
}

@test "Test variable default value" {
    set_default "MY_VAR" "hello"
    assert_equal "${MY_VAR}" "hello"
}
```

### 2. Local Full Check (CI)
If you have **Docker** and **Docker Compose** installed, you can run the integrated CI script directly:
```bash
chmod +x ci.sh
./ci.sh
```
This script uses `docker-compose.yaml` to:
1. **ShellCheck**: Static analysis for shell scripts.
2. **Bats**: Unit testing.
3. **Kcov**: Coverage reporting in the `coverage/` directory.

## 🛠 Development Guide

### ShellCheck Warnings
This project strictly enforces ShellCheck. For dynamic sourcing, use directives to suppress warnings:
```bash
# shellcheck disable=SC1090
source "${DYNAMIC_PATH}"
```

### Test Coverage
We pursue high-quality code with the following targets:
- **Patch**: 100% coverage required for new changes.
- **Project**: Progressive improvement (`auto`), never decreasing.

## 📄 License
[GPL-3.0](./LICENSE)
