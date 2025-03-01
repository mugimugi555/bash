# シェルスクリプト集

![タイトル画像](readme/header.png)

このリポジトリには、システム管理やメンテナンスのためのシェルスクリプトが含まれています。

## 含まれるスクリプト

### 1. delete_empty_files.sh
**説明:**
空のファイルを削除するスクリプト。

**使用方法:**
```bash
tbash delete_empty_files.sh /path/to/directory
```

---

### 2. grep_kill.sh
**説明:**
特定のプロセス名を `grep` で検索し、該当するプロセスを強制終了するスクリプト。

**使用方法:**
```bash
bash grep_kill.sh process_name
```

---

### 3. kill.sh
**説明:**
指定したプロセスID（PID）を強制終了するスクリプト。

**使用方法:**
```bash
bash kill.sh <PID>
```

---

### 4. memory.sh
**説明:**
メモリ使用量を表示するスクリプト。

**使用方法:**
```bash
bash memory.sh
```

---

### 5. speach.sh
**説明:**
テキストを音声合成して読み上げるスクリプト。

**使用方法:**
```bash
bash speach.sh "こんにちは、世界！"
```

## 注意事項
- スクリプトを実行する際は、適切な権限があることを確認してください。
- `chmod +x script_name.sh` を実行して、スクリプトに実行権限を付与してください。

## ライセンス
MIT ライセンスのもとで公開されています。

![タイトル画像](readme/footer.png)
