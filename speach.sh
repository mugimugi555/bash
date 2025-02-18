#!/bin/bash

# ==========================
# 必要なライブラリのチェック & インストール
# ==========================
REQUIRED_PKGS=("ffmpeg" "mpg123" "curl")

for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! command -v "$pkg" &> /dev/null; then
        echo "⚠️ $pkg が見つかりません。インストールします..."
        sudo apt install -y "$pkg" >/dev/null 2>&1 || sudo yum install -y "$pkg" >/dev/null 2>&1 || brew install "$pkg" >/dev/null 2>&1
    fi
done

# ==========================
# テキスト入力チェック（引数なしならデフォルトメッセージを使用）
# ==========================
TEXT="${1:-再生したいテキストを入力してね！}"

# ==========================
# Google Translate TTS で音声取得（ログ非表示）
# ==========================
LANG="ja"
TMP_FILE="/tmp/google_tts.mp3"
OUT_DIR="/tmp/tts_variants"
mkdir -p "$OUT_DIR"

curl -s -G --output "$TMP_FILE" "https://translate.google.com/translate_tts" \
     --data-urlencode "ie=UTF-8" \
     --data-urlencode "q=$TEXT" \
     --data-urlencode "tl=$LANG" \
     --data-urlencode "client=tw-ob" >/dev/null 2>&1

# ==========================
# 「ちょっと遅い（落ち着いた感じ）」の音声を作成（ログ非表示）
# ==========================
FILE_NAME="slow"
PITCH="0.9"
SPEED="0.80"
DESCRIPTION="ちょっと遅い（落ち着いた感じ）"

OUTPUT_FILE="$OUT_DIR/${FILE_NAME}.mp3"

ffmpeg -i "$TMP_FILE" -af "asetrate=44100*${PITCH},atempo=${SPEED}" -y "$OUTPUT_FILE" >/dev/null 2>&1

# ==========================
# 再生（ログ非表示）
# ==========================
mpg123 "$OUTPUT_FILE" >/dev/null 2>&1

# ==========================
# 一時ファイル削除
# ==========================
rm -f "$TMP_FILE" "$OUTPUT_FILE"
