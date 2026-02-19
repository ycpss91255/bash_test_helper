#!/usr/bin/env python3
import xml.etree.ElementTree as ET
import os
import glob
import subprocess

def get_local_path(filename):
    """嘗試在本地端找到對應的原始碼檔案"""
    # 修正：如果路徑是 /source/src/...，將其轉為 ./src/...
    filename_mapped = filename.replace('/source/', './')
    
    potential_paths = [
        filename_mapped,
        filename,
        os.path.join("src", filename),
        os.path.join("src/lib", filename),
        os.path.join(".", filename)
    ]
    for p in potential_paths:
        if os.path.exists(p) and os.path.isfile(p):
            return p
    return None

def view_file(cls):
    """顯示特定檔案的彩色覆蓋率報表"""
    filename = cls.get('filename')
    local_path = get_local_path(filename)
    
    if not local_path:
        print("錯誤: 找不到原始檔案 {}".format(filename))
        input("按任意鍵繼續...")
        return

    GREEN = '\033[92m'
    RED = '\033[91m'
    NC = '\033[0m'
    BG_RED = '\033[41;37m'
    BG_GREEN = '\033[42;30m'

    hits_map = {}
    for line in cls.findall(".//line"):
        hits_map[int(line.get('number'))] = int(line.get('hits'))

    output = []
    output.append("\033[1mFILE: {}\033[0m".format(local_path))
    output.append("{} 已執行 {} | {} 未執行 {} | 白色 = 無需執行".format(BG_GREEN, NC, BG_RED, NC))
    output.append("-" * 60)

    try:
        with open(local_path, 'r', encoding='utf-8', errors='ignore') as f:
            for idx, line_text in enumerate(f, 1):
                hits = hits_map.get(idx)
                line_content = line_text.rstrip()
                
                if hits == 0:
                    output.append("{}{:4} | {}{}".format(BG_RED, idx, line_content, NC))
                elif hits is not None and hits > 0:
                    output.append("{}{:4} | {}{}".format(GREEN, idx, line_content, NC))
                else:
                    output.append("{:4} | {}".format(idx, line_content))
    except Exception as e:
        output.append("讀取檔案出錯: {}".format(e))

    # 使用 less -R 顯示內容
    content = "\n".join(output)
    process = subprocess.Popen(['less', '-R'], stdin=subprocess.PIPE, text=True)
    process.communicate(input=content)

def main():
    xml_files = glob.glob('coverage/*/cov.xml') + glob.glob('coverage/*/cobertura.xml')
    if not xml_files:
        print("錯誤: 找不到覆蓋率 XML 檔案。")
        return
    
    try:
        tree = ET.parse(xml_files[0])
        root = tree.getroot()
    except Exception as e:
        print("解析 XML 出錯: {}".format(e))
        return

    while True:
        os.system('clear')
        print("\033[1m=== Shell Coverage TUI (Python Edition) ===\033[0m")
        print("{:<3} {:<10} {}".format('#', '覆蓋率', '檔案路徑'))
        print("-" * 60)

        classes = root.findall(".//class")
        valid_classes = []
        
        for cls in classes:
            filename = cls.get('filename')
            if get_local_path(filename):
                rate = float(cls.get('line-rate', 0)) * 100
                valid_classes.append(cls)
                print("{:<3} {:>6.2f}%    {}".format(len(valid_classes)-1, rate, filename))

        print("-" * 60)
        try:
            choice = input("輸入編號查看詳情 (或輸入 'q' 離開): ")
        except EOFError:
            break

        if choice.lower() == 'q':
            break
        
        try:
            choice_idx = int(choice)
            if 0 <= choice_idx < len(valid_classes):
                view_file(valid_classes[choice_idx])
            else:
                print("無效的編號。")
                input("按任意鍵繼續...")
        except ValueError:
            print("請輸入數字。")
            input("按任意鍵繼續...")

if __name__ == "__main__":
    main()
