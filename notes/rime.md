# Rime Reference

Schema: `bopomofo_tw` (注音·臺灣正體). Platform frontends:

- **macOS** — 鼠鬚管 (Squirrel)
- **Linux** — 中州韻 (ibus-rime / fcitx-rime)
- **Windows** — 小狼毫 (Weasel)

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

## Reading table: pronunciation.dict.yaml

Use this to add or override character readings (e.g. make 嗎 appear under ㄇㄚˉ).

### Format

```
---
name: pronunciation
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
- **Set `translator/user_dict: terra_pinyin`** in both schema templates. Otherwise Rime creates a new `pronunciation.userdb` or `personal.userdb` and all learned word frequencies reset to zero.

### Schema templates

Rime loads `bopomofo_tw.custom.yaml` by that filename. This repo keeps two sources under `templates/` and Ansible copies one of them to that filename.

`templates/bopomofo_tw.custom.default.yaml`, used when `~/Library/Rime/personal.dict.yaml` is absent:

```yaml
patch:
  translator/dictionary: pronunciation
  translator/user_dict: terra_pinyin
```

`templates/bopomofo_tw.custom.personal.yaml`, used when that phrase table is present:

```yaml
patch:
  translator/dictionary: personal
  translator/user_dict: terra_pinyin
```

`make pull` does not copy the deployed patch back over these templates.

The personal phrase table is [`github.com/ianchen-tw/rime-vocab`](https://github.com/ianchen-tw/rime-vocab). Its `import_tables` lists `pronunciation` and `terra_pinyin`. `import_tables` is not recursive and does not copy `use_preset_vocabulary`; the personal dict sets that flag itself and must import `terra_pinyin` directly. `pronunciation` contributes reading overrides such as `嗎`.

### Reading table vs custom_phrase.txt

Add readings via `pronunciation.dict.yaml`; use `custom_phrase.txt` for abbreviations and typo corrections. The abbreviation filename is fixed by the schema (`user_dict: custom_phrase`).

Single-syllable first-tone entries in `custom_phrase.txt` require space as the final
keyboard code character, but `fluency_editor`'s `space: toggle_selection` intercepts
the space first, selecting the candidate before it updates. Multi-syllable entries
are unaffected (space falls in the middle). `pronunciation.dict.yaml` has no such limitation.

## Logs

Squirrel logs: `$TMPDIR/rime.squirrel.*`

## Redeploy

Redeploy after any config change.

- Right-click the Squirrel icon in the menu bar → 重新部署
- Or `make deploy`
- Or run directly:

```sh
/Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --reload
```

## References

- [Rime official site](https://rime.im/)
- [rime-bopomofo schema source](https://github.com/rime/rime-bopomofo)
- [custom_phrase.txt format example (lotem)](https://gist.github.com/lotem/5440677)
