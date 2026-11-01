# Spatial Media

Spatial Media attaches a media player to a prop or a world-positioned anchor. Nearby human players become listeners and hear the audio source. The client can attenuate volume based on distance.

## Tool: Spatial Media Player

Find **Media Player → Spatial Media Player** in the tool menu.

| Action | Effect |
|---|---|
| Left click | Create a spatial source on a supported traced entity or at a world position |
| Right click | Remove a spatial source you are allowed to control |
| Reload | Reopen the request UI for an existing spatial source |

The tool validates targets and uses an anchor entity to represent the source. A prop-attached anchor follows its parent; a world placement remains at its placed position. Tool-created entities participate in undo and cleanup.

Players and unsupported entity types are rejected. Existing media-player screens are not valid spatial targets.

## Listener radius

Server ConVar: `mediaplayer_spatial_hear_radius` (default `1800` Source units).

The server periodically checks connected human players and adds those within the radius to the spatial player's listener set. Players outside the radius stop receiving that source's stream.

This is separate from the client-side proximity-volume settings:
- `mediaplayer_3daudio` enables distance-based volume.
- `mediaplayer_proximity_min` sets the distance where volume is at full strength.
- `mediaplayer_proximity_max` sets the distance where volume reaches zero.

A player can be within the server listener radius but hear reduced volume due to client-side attenuation.

## Supported services

Spatial players use a service whitelist. The current built-in whitelist is:

| Service ID | Provider |
|---|---|
| `yt` | YouTube |
| `bili` | Bilibili |
| `sc` | SoundCloud |
| `twl` | Twitch live streams |
| `dm` | Dailymotion |
| `ia` | Internet Archive |
| `odysee` | Odysee |
| `tt` | HTML5 video/resource service |
| `gd` | Google Drive |
| `h5v` | Direct media/resource service |
| `af` | Audio files |

The whitelist is defined in `lua/mediaplayer/players/spatial/shared.lua`. Administrators with `MediaPlayer_BypassWhitelist` can bypass it.

## Permissions

The spatial player checks ownership/privileges before accepting requests. The creator/owner can control their source; administrators can be granted the relevant CAMI privileges. See [Permissions](permissions.md).

## Related

- [Configuration](configuration.md)
- [Usage](usage.md)
- [Permissions](permissions.md)
