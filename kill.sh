#!/bin/bash

# 引数が指定されていない場合はエラーメッセージを表示して終了
if [ -z "$1" ]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

PROCESS_NAME="$1"

# 指定したプロセスを検索し、PIDを取得してkill
PIDS=$(ps aux | grep "$PROCESS_NAME" | grep -v grep | awk '{print $2}')

if [ -z "$PIDS" ]; then
    echo "No matching processes found for: $PROCESS_NAME"
    exit 1
fi

echo "Killing the following processes: $PIDS"
echo "$PIDS" | xargs kill -9

echo "Processes killed."
