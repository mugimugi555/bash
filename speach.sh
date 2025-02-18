#!/bin/bash

# ==========================
# 必要なライブラリのチェック & インストール
# ==========================
REQUIRED_PKGS=("ffmpeg" "mpg123" "curl")

for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! command -v "$pkg" &> /dev/null; then
        echo "⚠️ $pkg が見つかりません。インストールします..."
        sudo apt install -y "$pkg" || sudo yum install -y "$pkg" || brew install "$pkg"
    fi
done

# ==========================
# テキスト入力チェック（引数なしならデフォルトメッセージを使用）
# ==========================
TEXT="${1:-再生したいテキストを入力してね！}"

# ==========================
# Google Translate TTS で音声取得
# ==========================
LANG="ja"
TMP_FILE="/tmp/google_tts.mp3"
OUT_DIR="/tmp/tts_variants"
mkdir -p "$OUT_DIR"

echo "🌍 Google Translate から音声を取得..."
curl -s -G --output "$TMP_FILE" "https://translate.google.com/translate_tts" \
     --data-urlencode "ie=UTF-8" \
     --data-urlencode "q=$TEXT" \
     --data-urlencode "tl=$LANG" \
     --data-urlencode "client=tw-ob"

# ==========================
# 「ちょっと遅い（落ち着いた感じ）」の音声を作成
# ==========================
FILE_NAME="slow"
PITCH="1.0"
SPEED="0.8"
DESCRIPTION="ちょっと遅い（落ち着いた感じ）"

OUTPUT_FILE="$OUT_DIR/${FILE_NAME}.mp3"

echo "🎵 生成中: ${DESCRIPTION}（ピッチ=${PITCH}, スピード=${SPEED}）"

ffmpeg -i "$TMP_FILE" -af "asetrate=44100*${PITCH},atempo=${SPEED}" -y "$OUTPUT_FILE"

echo "🎧 再生中: ${DESCRIPTION}"
mpg123 "$OUTPUT_FILE"

# ==========================
# 一時ファイル削除
# ==========================
rm -f "$TMP_FILE" "$OUTPUT_FILE"
