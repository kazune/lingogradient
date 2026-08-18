# LingoGradient

Ollamaを使って日本語の文章を英訳し、文単位で日本語と英語を混ぜて出力する個人用CLIです。

[Mazelingo](https://mazelingo-web.pages.dev/)の文章中に日本語と英語を混ぜる体験に着想を得て、ローカルLLMで使えるシンプルなCLIとして作りました。

## 必要なもの

- macOS
- Bash 3.2以降
- Ollama
- `qwen3.5:9b`
- curl
- jq

Ollamaを起動し、モデルが未導入なら取得してください。

```console
ollama serve
ollama pull qwen3.5:9b
```

## 使い方

```console
./lingogradient < input.txt
./lingogradient 30 < input.txt
./lingogradient 70 < input.txt
./lingogradient --remix 70
```

引数は英語で出力する割合で、`0`から`100`までの整数です。未指定時は`40`です。

全文がN文の場合、`N × 割合 ÷ 100`を四捨五入した数の文をランダムに選び、英語で出力します。残りは日本語原文を出力します。出力順は入力と同じです。

stdinは空入力も含めてそのままOllamaへ渡します。モデルが空の文配列を返した場合は、何も出力せず正常終了します。

正常なOllamaレスポンスは実行ファイル横の`.lingogradient/last-response.json`へそのまま保存されます。`--remix`を指定するとOllamaへ再度問い合わせず、保存済みの翻訳から文を選び直します。割合を省略した場合は`40`です。

不正なレスポンスや通信エラーが発生しても、以前の正常なレスポンスは保持されます。保存内容には原文と翻訳が含まれるため、`.lingogradient/`はGitの対象外です。

モデルを変更する場合は、`LINGOGRADIENT_MODEL`環境変数を指定してください。

```console
LINGOGRADIENT_MODEL=gemma3:4b ./lingogradient < input.txt
```

## 制約

- 通常の日本語散文を対象とします。
- 出力は一文一行です。段落や箇条書きなどの書式は保持しません。
- 原文を省略・追加・言い換え・並べ替えしないようモデルへ指示しますが、スクリプト側で一致検証はしません。
- Ollamaの停止、HTTPエラー、不正な応答が発生した場合、部分的な結果は出力せず終了します。

## 開発

テストにはBats、静的検査にはShellCheck、整形にはshfmtを使用します。

```console
make check
make fmt
```
