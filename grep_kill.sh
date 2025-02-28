#!/bin/bash

# 引数チェック
if [ $# -lt 1 ]; then
    echo "⚠️ 使い方: $0 キーワード1 [キーワード2 ... キーワードN]"
    exit 1
fi

# `ps aux` の出力をフィルタリング
PROCESS_LIST=$(ps aux)

for keyword in "$@"; do
    PROCESS_LIST=$(echo "$PROCESS_LIST" | grep "$keyword")
done

# `grep` 自体のプロセスを除外
PROCESS_LIST=$(echo "$PROCESS_LIST" | grep -v "grep")

# プロセスID（PID）を取得
PIDS=$(echo "$PROCESS_LIST" | awk '{print $2}')

if [ -z "$PIDS" ]; then
    echo "🔍 指定した条件のプロセスが見つかりません: $*"
    exit 0
fi

echo "💀 以下のプロセスを終了します:"
echo "$PROCESS_LIST"

# 確認プロンプト
read -p "本当に終了しますか？ (y/N): " CONFIRM
if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "$PIDS" | xargs kill
    echo "✅ プロセスを終了しました！"
else
    echo "🚀 操作をキャンセルしました！"
fi
