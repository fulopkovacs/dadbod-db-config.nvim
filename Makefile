.PHONY: test format format-check

PLENARY ?= $(HOME)/.local/share/nvim/lazy/plenary.nvim

test:
	nvim --headless --clean -u NONE \
		-c "set rtp+=$(PLENARY)" \
		-c "set rtp+=." \
		-c "lua require('plenary.test_harness').test_directory('spec', { minimal_init = 'NONE' })"

format:
	git ls-files '*.lua' | xargs lua-format -i -c .lua-format

format-check:
	$(MAKE) format
	git diff --exit-code
