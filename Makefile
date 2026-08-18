.PHONY: check test lint fmt

check: lint test

test:
	bats test/lingogradient.bats

lint:
	shellcheck -s bash lingogradient test/fixtures/bin/curl
	shfmt -d -i 2 -ci lingogradient test/fixtures/bin/curl test/lingogradient.bats

fmt:
	shfmt -w -i 2 -ci lingogradient test/fixtures/bin/curl test/lingogradient.bats
