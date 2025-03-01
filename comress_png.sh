#!/bin/bash

# ==========================
# Ubuntu 用 PNG 圧縮スクリプト
# ==========================

# pngquant がインストールされているか確認
if ! command -v pngquant &> /dev/null; then
    echo "pngquant がインストールされていません。インストールします..."
    sudo apt update && sudo apt install -y pngquant
fi

echo "✅ pngquant はインストール済みです。"

# ==========================
# 圧縮対象のディレクトリ
# ==========================
TARGET_DIR=${1:-.}
INFO_FILE="${TARGET_DIR}/file_info.txt"

# 圧縮されたファイル情報を保持するテキストファイルがなければ作成
if [ ! -f "$INFO_FILE" ]; then
    touch "$INFO_FILE"
fi

# 一時ファイル（新しい情報を保存）
TMP_INFO_FILE=$(mktemp)

# ==========================
# PNG ファイルの圧縮処理
# ==========================
find "$TARGET_DIR" -type f -name "*.png" | while read -r file; do
    # 圧縮前のファイル情報（更新日時とサイズ）
    read OLD_MOD_TIME OLD_FILE_SIZE < <(stat --format='%Y %s' "$file")

    # 既存の `file_info.txt` からこのファイルの情報を取得
    OLD_INFO=$(grep "^$file " "$INFO_FILE" 2>/dev/null)

    # もし `file_info.txt` に存在する場合、過去の情報を取得
    if [ -n "$OLD_INFO" ]; then
        read OLD_RECORDED_MOD_TIME OLD_RECORDED_FILE_SIZE < <(echo "$OLD_INFO" | awk '{print $2, $3}')

        # もしファイルが変更されていない場合はスキップ
        if [ "$OLD_MOD_TIME" == "$OLD_RECORDED_MOD_TIME" ] && [ "$OLD_FILE_SIZE" == "$OLD_RECORDED_FILE_SIZE" ]; then
            echo "✅ すでに圧縮済み: $file"
            echo "$OLD_INFO" >> "$TMP_INFO_FILE"
            continue
        fi
    fi

    # ファイルを圧縮
    echo "🔄 圧縮中: $file"
    pngquant --quality=65-80 --speed 1 --ext .png --force "$file"

    # 圧縮後のファイル情報（更新日時とサイズ）
    read NEW_MOD_TIME NEW_FILE_SIZE < <(stat --format='%Y %s' "$file")

    # `file_info.txt` に圧縮後の情報を記録
    echo "$file $NEW_MOD_TIME $NEW_FILE_SIZE" >> "$TMP_INFO_FILE"
done

# 圧縮後の最新情報を `file_info.txt` に上書き
cat "$TMP_INFO_FILE" > "$INFO_FILE"
rm -f "$TMP_INFO_FILE"

echo "🎉 圧縮処理が完了しました！"
