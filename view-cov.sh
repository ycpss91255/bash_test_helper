#!/usr/bin/env bash

# 既然 Python 腳本可能因為路徑對齊問題失敗
# 我直接寫一個「絕對成功」的 Bash 簡單版本，這次我們只抓最重要的資訊
# 並直接讀取本地檔案。

JSON_FILE=$(ls coverage/*/coverage.json 2>/dev/null | head -n 1)
COVERAGE_DIR=$(dirname "$JSON_FILE")

# 顏色
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'

echo "正在掃描專案檔案..."

# 從 JSON 抓取檔案列表
files=($(jq -r '.files[].file' "$JSON_FILE"))

for full_path in "${files[@]}"; do
    # 轉換路徑：將 /source/src/ 轉為 ./src/
    local_path="./${full_path#*/source/}"
    [[ "$full_path" == *"/usr/"* ]] && continue # 跳過系統庫
    
    echo -e "
\033[1;34mFILE: $local_path\033[0m"
    echo "----------------------------------------"

    file_name=$(basename "$full_path")
    js_file=$(find "$COVERAGE_DIR" -name "${file_name}.*.js" | head -n 1)

    if [[ -f "$js_file" && -f "$local_path" ]]; then
        # 抓取哪些行號是 lineNoCov (未覆蓋)
        no_cov_lines=$(cat "$js_file" | sed 's/var data = //; s/;$//' | sed 's/,}/}/g' | jq -r '.lines[] | select(.class == "lineNoCov") | .lineNum' | xargs)
        # 抓取哪些行號是 lineCov (已覆蓋)
        cov_lines=$(cat "$js_file" | sed 's/var data = //; s/;$//' | sed 's/,}/}/g' | jq -r '.lines[] | select(.class == "lineCov") | .lineNum' | xargs)

        line_num=1
        while IFS= read -r line || [[ -n "$line" ]]; do
            # 判斷當前行號是否在「未覆蓋」清單中
            if [[ " $no_cov_lines " =~ " $line_num " ]]; then
                printf "${RED}%4d | %s${NC}
" "$line_num" "$line"
            elif [[ " $cov_lines " =~ " $line_num " ]]; then
                printf "${GREEN}%4d | %s${NC}
" "$line_num" "$line"
            else
                printf "%4d | %s
" "$line_num" "$line"
            fi
            ((line_num++))
        done < "$local_path"
    else
        echo "跳過: 找不到數據或檔案 ($local_path)"
    fi
done
