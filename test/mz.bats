#!/usr/bin/env bats

setup() {
  export PATH="$BATS_TEST_DIRNAME/fixtures/bin:$PATH"
  MZ="$BATS_TEST_DIRNAME/../mz"
}

@test "defaults to 40 percent of all sentences, rounded" {
  run "$MZ" <<<"テスト。"

  [ "$status" -eq 0 ]
  [ "$(printf '%s\n' "$output" | grep -Ec '^(One|Two|Three|Four)\.$')" -eq 2 ]
  [ "$(printf '%s\n' "$output" | wc -l | tr -d ' ')" -eq 4 ]
}

@test "zero percent emits only Japanese" {
  run "$MZ" 0 <<<"テスト。"

  [ "$status" -eq 0 ]
  [ "$output" = $'一。\n二。\n三。\n四。' ]
}

@test "one hundred percent emits only English" {
  run "$MZ" 100 <<<"テスト。"

  [ "$status" -eq 0 ]
  [ "$output" = $'One.\nTwo.\nThree.\nFour.' ]
}

@test "rejects an invalid percentage" {
  run "$MZ" 101 <<<"テスト。"

  [ "$status" -eq 1 ]
  [ "$output" = "mz: percentage must be an integer from 0 to 100" ]
}

@test "rejects extra arguments" {
  run "$MZ" 20 30 <<<"テスト。"

  [ "$status" -eq 2 ]
  [ "$output" = "Usage: mz [0-100]" ]
}

@test "rejects empty input" {
  run "$MZ" <<<"   "

  [ "$status" -eq 1 ]
  [ "$output" = "mz: input is empty" ]
}

@test "fails without partial output when Ollama returns invalid JSON" {
  CURL_MODE=invalid run "$MZ" <<<"テスト。"

  [ "$status" -eq 1 ]
  [ "$output" = "mz: Ollama returned an invalid response" ]
}

@test "reports an Ollama request failure" {
  CURL_MODE=failure run "$MZ" <<<"テスト。"

  [ "$status" -eq 1 ]
  [ "$output" = "mz: Ollama request failed" ]
}
