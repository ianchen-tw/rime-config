# rime-config

Rime input method configuration for `bopomofo_tw` (注音·臺灣正體).
Ansible syncs `rime/` to the platform's user config directory; `backup: yes`
preserves overwritten files in both directions. Invoke Ansible with `uv run`
(Makefile does this). Do not assume `ansible-playbook` is on PATH.

## Files

`default.custom.yaml`, the deployed `bopomofo_tw.custom.yaml`, and `custom_phrase.txt` keep those names because Rime loads them by name: global settings, the bopomofo schema patch, and the abbreviation table.

| File | Purpose |
|------|---------|
| `rime/default.custom.yaml` | Global overrides (schema selection, key behavior) |
| `templates/bopomofo_tw.custom.default.yaml` | Schema patch when `personal.dict.yaml` is absent. Deployed as `bopomofo_tw.custom.yaml` |
| `templates/bopomofo_tw.custom.personal.yaml` | Schema patch when `personal.dict.yaml` is present. Deployed as `bopomofo_tw.custom.yaml` |
| `rime/pronunciation.dict.yaml` | Public reading table — import `terra_pinyin` and add reading overrides |
| `rime/custom_phrase.txt` | Abbreviations and typo corrections |

`make pull` does not pull `bopomofo_tw.custom.yaml`. The templates in this repo are the source. Personal phrases live in [`github.com/ianchen-tw/rime-vocab`](https://github.com/ianchen-tw/rime-vocab). That dict imports `pronunciation` and `terra_pinyin` (`import_tables` is not recursive). After that repo installs or removes `personal.dict.yaml`, run `make deploy` here.

## Workflow

First-time Mac: README `## New Mac`.

See `Makefile` header for all targets.

## Rime reference

Format specs, keyboard map, dict settings, and troubleshooting: `notes/rime.md`.
