# rime-config

Personal [Rime](https://rime.im/) config for `bopomofo_tw` 注音·臺灣正體.
Synced to `~/Library/Rime/` via Ansible (`uv run ansible-playbook`).

## New Mac

1. Install Homebrew if missing: https://brew.sh
2. `brew install uv`
3. `brew install --cask squirrel-app`
4. Open Squirrel once (creates `~/Library/Rime`, unpacks `bopomofo_tw` and `terra_pinyin`)
5. System Settings → Keyboard → Input Sources → add 鼠鬚管
6. Clone this repo; `cd` into it
7. `make deploy`
8. Type ㄕㄉㄧ, ㄓㄜㄧㄒㄝ, ㄇㄚˉ → expect 設定, 這些, 嗎

## Day-to-day

```
make install   # push config -> ~/Library/Rime/ (with backup)
make pull      # pull live config -> repo (with backup)
make diff      # dry-run diff
make deploy    # install + redeploy Squirrel
```

Linux: `make install RIME_DIR=~/.config/ibus/rime`
