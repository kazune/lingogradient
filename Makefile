.PHONY: check test lint fmt

check: lint test

test:
	bats test/mz.bats

lint:
	shellcheck -s bash mz test/fixtures/bin/curl
	shfmt -d -i 2 -ci mz test/fixtures/bin/curl test/mz.bats

fmt:
	shfmt -w -i 2 -ci mz test/fixtures/bin/curl test/mz.bats
