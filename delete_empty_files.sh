#!/bin/bash

# 引数が指定されていない場合のエラーメッセージ
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

TARGET_DIR="$1"

# 指定されたディレクトリが存在するかチェック
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

# ファイルサイズが0のファイルを検索
EMPTY_FILES=$(find "$TARGET_DIR" -type f -size 0)

# ファイルがない場合の処理
if [ -z "$EMPTY_FILES" ]; then
    echo "No empty files found in '$TARGET_DIR'."
    exit 0
fi

# 見つかったファイルを表示
echo "The following empty files will be deleted:"
echo "$EMPTY_FILES"
echo

# 確認プロンプト
read -p "Do you want to delete these files? (y/N): " CONFIRM
if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "$EMPTY_FILES" | xargs rm -f
    echo "Empty files deleted."
else
    echo "Operation canceled."
fi
