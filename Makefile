SH_FILES := lingogradient test/fixtures/bin/curl test/lingogradient.bats
SHFMT := shfmt
SHFMT_FLAGS := -i 2 -ci

.PHONY: check test lint fmt-check fmt

check: lint fmt-check test

test:
	bats test/lingogradient.bats

lint:
	shellcheck -s bash $(SH_FILES)

fmt-check:
	$(SHFMT) -d $(SHFMT_FLAGS) $(SH_FILES)

fmt:
	$(SHFMT) -w $(SHFMT_FLAGS) $(SH_FILES)
