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

## Personal phrase table

Optional. Phrases live in [`github.com/ianchen-tw/rime-vocab`](https://github.com/ianchen-tw/rime-vocab).

1. `make install` in that repo, so `~/Library/Rime/personal.dict.yaml` exists.
2. `make deploy` here. Ansible copies `templates/bopomofo_tw.custom.personal.yaml` when that file exists, and `templates/bopomofo_tw.custom.default.yaml` otherwise.
3. After removing the phrase table, run `make deploy` here again. A reload alone leaves the schema pointing at `personal`.

Both templates set `translator/user_dict: terra_pinyin`. The phrase table must import `pronunciation` and `terra_pinyin`. `import_tables` is not recursive, so `pronunciation` alone does not include the terra character table.
