# Configuration

ConVars are defined primarily in `lua/mediaplayer/sh_cvars.lua`. The spatial hear-radius ConVar is created by the server-side spatial player implementation.

## Server ConVars

| ConVar | Default | Flags / scope | Description |
|---|---:|---|---|
| `mediaplayer_debug` | `0` | Server | Enables verbose diagnostic logging |
| `mediaplayer_allow_webpages` | `0` | Archived, replicated | Allows otherwise-unmatched URLs to use the generic webpage service |
| `mediaplayer_queue_limit` | `64` | Replicated | Maximum number of queued items per media player |
| `mediaplayer_spatial_hear_radius` | `1800` | Archived, notified, replicated | Maximum distance at which players are listeners of a spatial anchor (Source units) |

Keep `mediaplayer_allow_webpages` disabled on public servers unless unrestricted webpage playback is an intentional feature. Arbitrary webpages are less predictable and expand the external-content attack surface. Restrict request permissions if you enable it.

## Client ConVars

| ConVar | Default | Archived | Description |
|---|---:|---|---|
| `mediaplayer_volume` | `0.15` | Yes | Master playback volume (0–1) |
| `mediaplayer_resolution` | `480` | Yes | Browser render resolution height |
| `mediaplayer_3daudio` | `1` | Yes | Enables distance-based volume |
| `mediaplayer_mute_unfocused` | `1` | Yes | Mutes playback while the game window is unfocused |
| `mediaplayer_fullscreen` | `0` | No | Enables fullscreen playback |
| `mediaplayer_draw_thumbnails` | `0` | Yes | Draws thumbnails on screens |
| `mediaplayer_proximity_min` | `100` | Yes | Distance where proximity volume is full |
| `mediaplayer_proximity_max` | `1000` | Yes | Distance where proximity volume reaches zero |
| `mediaplayer_cc_lang` | `off` | Yes | YouTube caption language code; `off` disables captions |

Most client settings are also exposed through the in-game **Media Player** menubar options.

## Spatial audio behavior

The server-side hear radius determines who becomes a listener of a spatial player. Client-side proximity settings control volume attenuation when `mediaplayer_3daudio` is enabled. These are separate controls: changing the client fade distances does not change the server listener radius.

If `mediaplayer_proximity_min` is greater than or equal to `mediaplayer_proximity_max`, the client ensures a non-zero range to avoid division by zero.

## Lua configuration table

The addon initializes `MediaPlayer.config` and merges values with:

```lua
MediaPlayer.SetConfig({
    example = {
        option = true
    }
})
```

Read nested values with:

```lua
local value = MediaPlayer.GetConfigValue("example.option")
```

Client defaults and hosted HTML endpoints are configured in `lua/mediaplayer/config/client.lua`. The current configuration points to the project's hosted request and YouTube helper pages.

## Related

- [Permissions](permissions.md)
- [Spatial Media](spatial-media.md)
- [Console commands](commands.md)
