# Rime configuration sync (Ansible)
#
# Override RIME_DIR for non-macOS platforms:
#   make install RIME_DIR=~/.config/ibus/rime

RIME_DIR := ~/Library/Rime

.PHONY: install deploy diff pull

install:
	ansible-playbook sync.yml -e "rime_dir=$(RIME_DIR)"

diff:
	ansible-playbook sync.yml --check --diff -e "rime_dir=$(RIME_DIR)"

pull:
	ansible-playbook sync.yml -e "mode=pull rime_dir=$(RIME_DIR)"

deploy: install
	/Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --reload
	@echo "Rime redeployed."
