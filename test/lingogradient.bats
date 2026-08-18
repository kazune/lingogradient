#!/usr/bin/env bats

setup() {
  export PATH="$BATS_TEST_DIRNAME/fixtures/bin:$PATH"
  LINGOGRADIENT="$BATS_TEST_DIRNAME/../lingogradient"
}

@test "defaults to 40 percent of all sentences, rounded" {
  run "$LINGOGRADIENT" <<<"テスト。"

  [ "$status" -eq 0 ]
  [ "$(printf '%s\n' "$output" | grep -Ec '^(One|Two|Three|Four)\.$')" -eq 2 ]
  [ "$(printf '%s\n' "$output" | wc -l | tr -d ' ')" -eq 4 ]
}

@test "zero percent emits only Japanese" {
  run "$LINGOGRADIENT" 0 <<<"テスト。"

  [ "$status" -eq 0 ]
  [ "$output" = $'一。\n二。\n三。\n四。' ]
}

@test "one hundred percent emits only English" {
  run "$LINGOGRADIENT" 100 <<<"テスト。"

  [ "$status" -eq 0 ]
  [ "$output" = $'One.\nTwo.\nThree.\nFour.' ]
}

@test "rejects an invalid percentage" {
  run "$LINGOGRADIENT" 101 <<<"テスト。"

  [ "$status" -eq 1 ]
  [ "$output" = "lingogradient: percentage must be an integer from 0 to 100" ]
}

@test "rejects extra arguments" {
  run "$LINGOGRADIENT" 20 30 <<<"テスト。"

  [ "$status" -eq 2 ]
  [ "$output" = "Usage: lingogradient [0-100]" ]
}

@test "rejects empty input" {
  run "$LINGOGRADIENT" <<<"   "

  [ "$status" -eq 1 ]
  [ "$output" = "lingogradient: input is empty" ]
}

@test "fails without partial output when Ollama returns invalid JSON" {
  CURL_MODE=invalid run "$LINGOGRADIENT" <<<"テスト。"

  [ "$status" -eq 1 ]
  [ "$output" = "lingogradient: Ollama returned an invalid response" ]
}

@test "reports an Ollama request failure" {
  CURL_MODE=failure run "$LINGOGRADIENT" <<<"テスト。"

  [ "$status" -eq 1 ]
  [ "$output" = $'curl: (22) The requested URL returned error: 500\nlingogradient: Ollama request failed' ]
}
