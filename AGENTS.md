# rime-config

Rime input method configuration for `bopomofo_tw` (注音·臺灣正體).

## What this is

Version-controlled Rime config files with Ansible to sync them to the
platform's user config directory. A freshness guard prevents overwriting
live changes that haven't been pulled into the repo.

## Project layout

```
rime-config/
├── Makefile              # CLI entry point
├── sync.yml              # Ansible playbook (localhost copy)
├── rime/                 # config files, mirrors ~/Library/Rime/
│   ├── default.custom.yaml
│   ├── bopomofo_tw.custom.yaml
│   ├── custom_bopomofo.dict.yaml
│   └── custom_phrase.txt
├── README.md
├── AGENTS.md
└── .gitignore
```

## Files

| File | Purpose |
|------|---------|
| `rime/default.custom.yaml` | Global overrides (schema selection, key behavior) |
| `rime/bopomofo_tw.custom.yaml` | Schema-specific overrides (supplementary dict) |
| `rime/custom_bopomofo.dict.yaml` | Supplementary dict — add/override character readings |
| `rime/custom_phrase.txt` | Abbreviations and typo corrections |

## Workflow

```sh
make install          # freshness guard + ansible-playbook sync.yml
make install FORCE=1  # skip guard, overwrite live config
make deploy           # install + redeploy Squirrel (macOS)
make diff             # ansible-playbook --check --diff (dry-run)
make pull             # copy live config -> rime/ (before committing in-place edits)
```

Override the target directory for other platforms:

```sh
make install RIME_DIR=~/.config/ibus/rime
```

### Freshness guard

`make install` checks whether any live file in `~/Library/Rime/` is both
newer (by mtime) and different (by content) than the repo copy. If so, it
aborts and suggests `make pull` first. Pass `FORCE=1` to override.

## User config directory

| Platform | Path |
|----------|------|
| macOS | `~/Library/Rime/` |
| Linux (ibus-rime) | `~/.config/ibus/rime/` |
| Linux (fcitx5-rime) | `~/.local/share/fcitx5/rime/` |
| Windows | `%APPDATA%\Rime\` |

## custom_phrase.txt

`bopomofo_tw` ships with `table_translator@custom_phrase`. Drop the file into the
user config directory and redeploy. Entries rank above the main translator.

### Format

One entry per line, three **TAB**-separated fields:

```
phrase	keyboard_code	weight
```

- Weight is optional; higher = ranked first
- Lines starting with `#` are comments

### Example

```
設定	g2u	1
```

Typing ㄕㄉㄧ surfaces 設定 first.

### Bopomofo keyboard map (大千式)

Look up this table to convert 注音 to keyboard codes (derived from `bopomofo_tw` `xlit` rules).

```
聲母: ㄅ=1  ㄆ=q  ㄇ=a  ㄈ=z
      ㄉ=2  ㄊ=w  ㄋ=s  ㄌ=x
      ㄍ=e  ㄎ=d  ㄏ=c
      ㄐ=r  ㄑ=f  ㄒ=v
      ㄓ=5  ㄔ=t  ㄕ=g  ㄖ=b
      ㄗ=y  ㄘ=h  ㄙ=n

介母: ㄧ=u  ㄨ=j  ㄩ=m

韻母: ㄚ=8  ㄛ=i  ㄜ=k  ㄝ=,
      ㄞ=9  ㄟ=o  ㄠ=l  ㄡ=.
      ㄢ=0  ㄣ=p  ㄤ=;  ㄥ=/  ㄦ=-

聲調: ˉ(一聲)=space  ˊ(二聲)=6  ˇ(三聲)=3  ˋ(四聲)=4  ˙(輕聲)=7
```

## Supplementary dict: custom_bopomofo.dict.yaml

Use this to add or override character readings (e.g. make 嗎 appear under ㄇㄚˉ).

### Format

```
---
name: custom_bopomofo
version: "2025.04.04"
sort: by_weight
use_preset_vocabulary: true
max_phrase_length: 7
min_phrase_weight: 100
import_tables:
  - terra_pinyin
...

嗎	ma1
```

One entry per line: `char<TAB>pinyin_with_tone<TAB>weight (optional)`.
Tone digits: 1 = 一聲, 2 = 二聲, 3 = 三聲, 4 = 四聲, 5 = 輕聲.

### Required settings

- **Keep `use_preset_vocabulary: true`**. `import_tables` imports only the code table, not the original dict header. Without this, all multi-character vocabulary is lost.
- **Set `translator/user_dict: terra_pinyin`** in `bopomofo_tw.custom.yaml`. Otherwise Rime creates a new `custom_bopomofo.userdb` and all learned word frequencies reset to zero.

`bopomofo_tw.custom.yaml`:

```yaml
patch:
  translator/dictionary: custom_bopomofo
  translator/user_dict: terra_pinyin
```

### Supplementary dict vs custom_phrase.txt

Add readings via the supplementary dict; use `custom_phrase.txt` for abbreviations and typo corrections.

Single-syllable first-tone entries in `custom_phrase.txt` require space as the final
keyboard code character, but `fluency_editor`'s `space: toggle_selection` intercepts
the space first, selecting the candidate before it updates. Multi-syllable entries
are unaffected (space falls in the middle). The supplementary dict has no such limitation.

## Logs

Squirrel logs: `$TMPDIR/rime.squirrel.*`

## Redeploy

Redeploy after any config change.

- Right-click the Squirrel icon in the menu bar → 重新部署
- Or run:

```sh
/Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --reload
```

## References

- [Rime official site](https://rime.im/)
- [rime-bopomofo schema source](https://github.com/rime/rime-bopomofo)
- [custom_phrase.txt format example (lotem)](https://gist.github.com/lotem/5440677)
