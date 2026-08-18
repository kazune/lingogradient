Mac mini上で動く、自分専用の英語学習CLIを作りたい。

目的

日本語文章をローカルLLMで英訳し、文単位で日本語と英語を一定割合で混ぜて出力する。MazelingoのCLI版のようなもの。

前提

* macOS / Mac mini
* ローカルLLMは Ollama
* 実装は Bash のみ
* Node.js / Python は使わない
* 依存はできるだけ少なくする
* curl と jq は利用可
* Web UI / TUI は不要
* 個人利用なので過度な汎用化や複雑な設計は不要

CLI仕様

基本:

lingogradient < input.txt

英語化する割合を指定可能にする:

lingogradient 30   # 30%
lingogradient 70   # 70%

未指定時は40%程度をデフォルトにする。

処理

1. stdinから日本語文章を読む
2. OllamaのHTTP APIへ送る
3. LLMに文章を自然な文単位に分割させる
4. 各文について日本語原文と自然な英訳をJSONで返させる
5. 指定された割合に応じて各文をランダムに日本語または英語で出力する
6. stdoutへ通常テキストとして出力する

イメージ:

今日は朝早く起きた。
I had breakfast at around seven.
その後、駅まで歩いた。
The train was unusually crowded today.

実装方針

* #!/usr/bin/env bash
* set -euo pipefail
* Ollama APIは curl
* JSON生成・解析はすべて jq に任せる
* BashでJSON文字列を手動組み立てしない
* 日本語の文分割もBashでは行わずLLMに任せる
* Ollama停止時やHTTPエラー時はstderrへ簡潔なエラーを出して終了
* フォールバックを作らない
* 不正な割合（0〜100外）はエラー
* コードはシンプルに保つ
* まずは単一ファイル lingogradient として実装する
* キャッシュ、履歴、設定ファイル、並列処理などは今回は不要

Ollamaのモデル名は`LINGOGRADIENT_MODEL`環境変数で変更できるようにする。未指定時は`qwen3.5:9b`を使う。

まず動く最小実装を作り、その後必要なら改善点も簡潔に提示してほしい。
