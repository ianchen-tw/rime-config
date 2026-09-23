# rime-config

Rime input method configuration for `bopomofo_tw` (注音·臺灣正體).
Ansible syncs `rime/` to the platform's user config directory; `backup: yes`
preserves overwritten files in both directions. Invoke Ansible with `uv run`
(Makefile does this). Do not assume `ansible-playbook` is on PATH.

## Files

| File | Purpose |
|------|---------|
| `rime/default.custom.yaml` | Global overrides (schema selection, key behavior) |
| `rime/bopomofo_tw.custom.yaml` | Schema-specific overrides (supplementary dict) |
| `rime/custom_bopomofo.dict.yaml` | Supplementary dict — add/override character readings |
| `rime/custom_phrase.txt` | Abbreviations and typo corrections |

## Workflow

First-time Mac: README `## New Mac`.

See `Makefile` header for all targets.

## Rime reference

Format specs, keyboard map, dict settings, and troubleshooting: `notes/rime.md`.
