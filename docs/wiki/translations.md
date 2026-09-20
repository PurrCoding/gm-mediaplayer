# Translations

Locales live under:

```
lua/mediaplayer/i18n/
  sh_i18n.lua
  lang/
    en.lua
    de.lua
    …
```

Missing keys fall back toward English.

---

## Adding a language

1. Copy `lang/en.lua` to e.g. `lang/pt-br.lua` (follow existing naming).
2. Translate string values; keep keys identical.
3. Ensure the loader in `sh_i18n.lua` picks up the file (follow the same pattern as other languages).
4. Restart the client and select the language if a UI selector is present.

Tool strings for the spatial stool are bridged into GMod’s `language.Add` system from i18n keys (`mp.tool.spatial.*`).

---

## Usage in code

```lua
MediaPlayer.L("some.key")
MediaPlayer.L("some.key", formatArg)
```

Prefer translation keys for any new player-facing text (errors, tooltips, tool help).

---

## Related

- [Development](development.md)
