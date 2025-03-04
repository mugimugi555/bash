#!/bin/bash

# 必要なパッケージをインストール
echo "Installing required packages..."
sudo apt update && sudo apt install -y webp

# 変換対象のディレクトリ
TARGET_DIR=${1:-$(pwd)}

# WebP から PNG への変換
echo "Converting WebP images to PNG in $TARGET_DIR..."

find "$TARGET_DIR" -type f -name "*.webp" -exec sh -c '
  for file; do
    png_file="${file%.webp}.png"
    dwebp "$file" -o "$png_file"
    echo "Converted: $file -> $png_file"
  done
' sh {} +

echo "Conversion complete!"
