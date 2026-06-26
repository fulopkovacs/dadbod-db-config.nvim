.PHONY: test lint format format-check

PLENARY ?= $(HOME)/.local/share/nvim/lazy/plenary.nvim

test:
	nvim --headless --clean -u NONE \
		-c "set rtp+=$(PLENARY)" \
		-c "set rtp+=." \
		-c "lua require('plenary.test_harness').test_directory('spec', { minimal_init = 'NONE' })"

lint:
	selene .

format:
	stylua .

format-check:
	stylua --check .
