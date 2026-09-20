# Configuration

ConVars are defined in `lua/mediaplayer/sh_cvars.lua` (plus `mediaplayer_spatial_hear_radius` on the spatial player).

---

## Server

| ConVar | Default | Description |
|--------|---------|-------------|
| `mediaplayer_debug` | `0` | Verbose logging of media player actions |
| `mediaplayer_allow_webpages` | `0` | Allow the generic webpage service for arbitrary URLs. **Security risk** if enabled on public servers |
| `mediaplayer_queue_limit` | `64` | Maximum queue length per media player |
| `mediaplayer_spatial_hear_radius` | `1800` | Distance (units) within which players become listeners of a spatial anchor |

`mediaplayer_allow_webpages` is replicated and archived. Only enable it if you trust players or restrict who can request media via [Permissions](permissions.md).

---

## Client

| ConVar | Default | Description |
|--------|---------|-------------|
| `mediaplayer_volume` | `0.15` | Master volume (0–1) |
| `mediaplayer_resolution` | `480` | Vertical resolution used for browser sizing |
| `mediaplayer_3daudio` | `1` | Enable 3D / proximity audio |
| `mediaplayer_mute_unfocused` | `1` | Mute when the GMod window is not focused |
| `mediaplayer_fullscreen` | `0` | Fullscreen media view |
| `mediaplayer_draw_thumbnails` | `0` | Draw media thumbnails on screens |
| `mediaplayer_proximity_min` | `100` | Distance where proximity volume is full |
| `mediaplayer_proximity_max` | `1000` | Distance where proximity volume reaches zero |

Many options are also exposed under the in-game **Media Player** menubar entry (`lua/autorun/menubar/mp_options.lua`).

---

## Config table

Server and client can merge values into `MediaPlayer.config` via `MediaPlayer.SetConfig(tbl)`.  
Read nested keys with `MediaPlayer.GetConfigValue("some.key.path")`.

Client defaults live in `lua/mediaplayer/config/client.lua`.

---

## Related

- [Permissions](permissions.md) — who may skip, seek, lock, etc.
- [Spatial Media](spatial-media.md) — hear radius behaviour
