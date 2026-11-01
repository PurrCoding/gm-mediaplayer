# Translations

Lua-side translations live in:

```text
lua/mediaplayer/i18n/
  sh_i18n.lua
  lang/
    en.lua
    de.lua
    ...
```

The request website has its own browser-side translation files under `public/scripts/translations/`. Keep both translation systems in mind when changing user-facing text.

## Adding or updating a Lua language

1. Copy the English source file `lua/mediaplayer/i18n/lang/en.lua` to the appropriate locale filename.
2. Translate values while preserving every key and format placeholder.
3. Follow the locale registration/loading pattern in `sh_i18n.lua`.
4. Check the spatial tool strings and all UI/error messages affected by the change.
5. Test the language in-game and verify that missing keys fall back as expected.

## Browser request UI translations

Browser-side translations are maintained separately in `public/scripts/translations/` and loaded by `public/scripts/i18n.js`. Update the relevant locale file when adding text to the hosted request UI, and preserve the keys expected by `public/scripts/request.js`.

The Lua and browser dictionaries are not automatically synchronized.

## Usage in Lua

```lua
MediaPlayer.L("some.key")
MediaPlayer.L("some.key", formatArg)
```

Prefer translation keys for player-facing errors, labels, tooltips, and tool help. Do not change keys casually: they are referenced by Lua and browser UI code.

## Related

- [Development](development.md)
