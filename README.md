# rime-config

Personal [Rime](https://rime.im/) configuration for `bopomofo_tw` (注音·臺灣正體).

## Prerequisites

- [Ansible](https://docs.ansible.com/) (`pipx install ansible-core` or `brew install ansible`)

## Usage

```sh
make install          # sync rime/ -> ~/Library/Rime/ (with freshness guard)
make install FORCE=1  # skip freshness guard
make deploy           # install + redeploy Squirrel
make diff             # dry-run diff (ansible --check --diff)
make pull             # import live config into repo
```

Other platforms: `make install RIME_DIR=~/.config/ibus/rime`

## Layout

```
rime/                 # config files, mirrors ~/Library/Rime/
sync.yml              # Ansible playbook
Makefile              # CLI entry point
```

See `AGENTS.md` for format references and the bopomofo keyboard map.
