# rime-config — Rime configuration sync
#
# Usage:
#   make install   push config -> ~/Library/Rime/ (with backup)
#   make pull      pull live config -> repo (with backup)
#   make diff      dry-run diff
#   make deploy    install + redeploy Squirrel
#
# Other platforms:
#   make install RIME_DIR=~/.config/ibus/rime

RIME_DIR := ~/Library/Rime
UV ?= uv
SQUIRREL := /Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel

.PHONY: install deploy diff pull

install:
	@$(UV) --version >/dev/null || { echo "install uv: https://docs.astral.sh/uv/"; exit 1; }
	$(UV) run ansible-playbook sync.yml -e "rime_dir=$(RIME_DIR)"

diff:
	@$(UV) --version >/dev/null || { echo "install uv: https://docs.astral.sh/uv/"; exit 1; }
	$(UV) run ansible-playbook sync.yml --check --diff -e "rime_dir=$(RIME_DIR)"

pull:
	@$(UV) --version >/dev/null || { echo "install uv: https://docs.astral.sh/uv/"; exit 1; }
	$(UV) run ansible-playbook sync.yml -e "mode=pull rime_dir=$(RIME_DIR)"

deploy: install
	@test -x "$(SQUIRREL)" || { echo "Squirrel not found at $(SQUIRREL)"; echo "install: brew install --cask squirrel-app"; exit 1; }
	"$(SQUIRREL)" --reload
	@echo "Rime redeployed."
