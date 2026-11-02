# Console commands and ConVars

This page covers the addon's registered console command and its ConVars. It does not list built-in Garry's Mod commands or Lua API methods.

## Registered console command

The addon currently registers one command with `concommand.Add`:

| Command | Realm / where | Permission | Description |
|---|---|---|---|
| `mediaplayer_clearcache` | Server console; also player console | Server console and single-player host are allowed. On multiplayer servers, the caller needs the `MediaPlayer_ClearCache` CAMI privilege (superadmin by default); without CAMI, the fallback is `IsSuperAdmin()`. | Clears the `mediaplayer_metadata` SQL cache table. |

Usage:

```text
mediaplayer_clearcache
```

This removes cached titles, durations, thumbnails, and other media metadata. It does **not** clear `mediaplayer_history`, player queues, or current playback. Metadata is fetched again when media is requested.

## Server ConVars

Run these in the server console. Replicated ConVars are also made available to clients as appropriate by Garry's Mod.

| ConVar | Default | Description |
|---|---:|---|
| `mediaplayer_debug` | `0` | Enables verbose MediaPlayer diagnostics. Set to `1` to enable and `0` to disable. Not archived. |
| `mediaplayer_allow_webpages` | `0` | Allows arbitrary webpage URLs through the generic webpage service. Enabling this broadens what users can load; only enable it when needed and on servers where that risk is acceptable. |
| `mediaplayer_queue_limit` | `64` | Maximum number of items in a media-player queue. |
| `mediaplayer_spatial_hear_radius` | `1800` | Maximum distance, in Source units, at which players are kept as listeners for spatial media anchors. |

Examples:

```text
mediaplayer_debug 1
mediaplayer_queue_limit 32
mediaplayer_allow_webpages 0
mediaplayer_spatial_hear_radius 1800
```

## Client ConVars

These settings are local to each player and can be changed in that player's client console.

| ConVar | Default | Description |
|---|---:|---|
| `mediaplayer_resolution` | `480` | Browser/player render resolution. The Lua setter clamps values to the range 16–4096. |
| `mediaplayer_3daudio` | `1` | Enables positional/3D audio handling. |
| `mediaplayer_volume` | `0.15` | Local playback volume. The MediaPlayer volume API accepts normalized values; values above 1 are interpreted as percentages. |
| `mediaplayer_mute_unfocused` | `1` | Mutes playback while the game window is not focused. |
| `mediaplayer_fullscreen` | `0` | Legacy setting; fullscreen behavior is now controlled by the current player UI, and this ConVar is no longer used. |
| `mediaplayer_draw_thumbnails` | `0` | Controls drawing of media thumbnails in the client UI. |
| `mediaplayer_proximity_min` | `100` | Lower bound for the client's proximity-based audio behavior. |
| `mediaplayer_proximity_max` | `1000` | Upper bound for the client's proximity-based audio behavior. |
| `mediaplayer_cc_lang` | `off` | Preferred YouTube caption language code (for example, `en` or `ko`). Use `off` to disable captions. |

Examples:

```text
mediaplayer_volume 0.25
mediaplayer_3daudio 1
mediaplayer_mute_unfocused 0
mediaplayer_cc_lang en
```

## Browser console filtering (client)

The HTML/DHTML control also creates the client ConVar `js_console_filter` (default `0`). It controls JavaScript console output forwarded from the embedded browser:

| Value | Behavior |
|---:|---|
| `0` | Suppresses ordinary JavaScript console messages; JavaScript errors are still printed. |
| `1` | Prints JavaScript console messages and URL-change diagnostics. |

This is an internal browser-diagnostics setting, not a playback option. It is defined in `lua/mediaplayer/controls/dmediaplayerhtml.lua`.

## Debug logging

`mediaplayer_debug` is a ConVar, not a separate command. Set it in the server console to log server-side activity, or in the client console to log client-side activity. The two realms have their own ConVar instances. Debug output can include request, listener, queue, state, and SQLite activity; avoid leaving verbose logging enabled unnecessarily on busy servers.

## What is not a console command

The addon also exposes playback controls through its UI, toolgun tools, entity inputs, and Lua API (for example pause, skip, seek, repeat, shuffle, and lock). These are not registered console commands and therefore cannot be invoked as `mediaplayer_pause`, `mediaplayer_skip`, etc. Use the media-player UI/tool or the documented Lua interfaces instead.

## Source of truth

The registered command is defined in `lua/mediaplayer/sv_requests.lua`. The shared and client ConVars are defined in `lua/mediaplayer/sh_cvars.lua`; the spatial hear-radius ConVar is defined in `lua/mediaplayer/players/spatial/init.lua`.

## Related

- [Configuration](configuration.md)
- [Usage](usage.md)
- [Spatial media](spatial-media.md)
- [Permissions](permissions.md)
- [Architecture](architecture.md)
