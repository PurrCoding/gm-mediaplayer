# Media Player Redux

A Garry's Mod addon for synchronized media streaming in multiplayer. Play videos, music, and other media on in-game screens — all synced across players in real time.

[![Steam Workshop](https://img.shields.io/badge/Steam%20Workshop-Subscribe-blue?logo=steam)](https://steamcommunity.com/sharedfiles/filedetails/?id=3001397905)

## Features

- **Synchronized Playback** — Media plays in sync for all players viewing the same screen.
- **Multiple Media Services** — Support for a wide range of platforms and media types:
  - YouTube
  - Bilibili
  - SoundCloud
  - Twitch
  - Dailymotion
  - Internet Archive
  - Google Drive
  - TikTok
  - Odysee
  - Direct audio files (`.mp3`, `.ogg`, etc.)
  - HTML5 video
  - Images
  - Webpages (when enabled by server)
- **Spatial Media Player** — Attach audio to any props using the Spatial Media tool. Audio fades based on distance from the source.
- **Queue System** — Queue up media with support for skip, seek, pause, repeat, shuffle, and lock controls.
- **Vote Skip** — Players can vote to skip the current media.
- **3D Spatial Audio** — Audio volume adjusts based on distance and proximity to the screen.
- **Request Menu** — Built-in UI for players to request media via URL.
- **Fullscreen Mode** — Watch media in fullscreen on your client.
- **Idle Screen** — Displays an idle screen when no media is playing.
- **Duplication Support** — Media player entities can be duplicated using Sandbox tools.
- **Localization** — Translated into 20 languages.

## Spawnable Entities

| Entity | Model |
|---|---|
| Big Screen TV | `models/gmod_tower/suitetv_large.mdl` |
| Huge Billboard | `models/hunter/plates/plate5x8.mdl` |
| Small TV | `models/props_phx/rt_screen.mdl` |

All entities are available under the **Media Player** category in the spawn menu.

## Spatial Media Tool

The **Spatial Media Player** tool lets you attach audio sources to props. Players within the hear radius will receive the audio, which fades with distance.

| Action | Description |
|---|---|
| Left click | Place a spatial source on a target. |
| Right click | Remove an existing spatial source. |
| Reload | Reopen the request UI for an existing source. |

To request media or control playback, look at the target object and hold **C** to open the sidebar.

The tool is available under **Media Player** in the tool menu.

## Installation

### Steam Workshop (Recommended)

Subscribe to the addon on the [Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=3001397905) — it will be automatically installed and kept up to date.

### Manual Installation

1. Download or clone this repository.
2. Place the folder into your `garrysmod/addons/` directory.
3. Restart Garry's Mod or change the map.

## Configuration

### Server Console Variables

| ConVar | Default | Description |
|---|---|---|
| `mediaplayer_debug` | `0` | Enable debug mode; logs actions to the console. |
| `mediaplayer_allow_webpages` | `0` | Allow any webpage URL to be requested. |
| `mediaplayer_queue_limit` | `64` | Maximum number of items in a media player queue. |
| `mediaplayer_spatial_hear_radius` | `1800` | How far spatial media sources can be heard. |

### Client Console Variables

| ConVar | Default | Description |
|---|---|---|
| `mediaplayer_volume` | `0.15` | Playback volume (0–1). |
| `mediaplayer_resolution` | `480` | Media rendering resolution. |
| `mediaplayer_3daudio` | `1` | Enable 3D spatial audio. |
| `mediaplayer_mute_unfocused` | `1` | Mute media when the game window is unfocused. |
| `mediaplayer_fullscreen` | `0` | Enable fullscreen media playback. |
| `mediaplayer_proximity_min` | `100` | Minimum distance for proximity-based volume. |
| `mediaplayer_proximity_max` | `1000` | Maximum distance for proximity-based volume. |

## Credits

Originally created by [Samuel Maddock](https://github.com/samuelmaddock).

### Contributors

- [Shadowsun™](https://github.com/CattoGamer) — Maintainer; YouTube overhaul, new services (SoundCloud, TikTok, Google Drive, Odysee), i18n, proximity audio, and ongoing maintenance.
- [SheepyLord](https://github.com/SheepyLord) — Spatial media player, Bilibili service integration.
- [Astralcircle](https://github.com/Astralcircle) — Spawn menu icons, category icon, and repository structure refactor.
- [veitikka](https://github.com/veitikka) — YouTube metadata improvements, removing YouTube API dependency.

...and all [other contributors](https://github.com/PurrCoding/gm-mediaplayer/graphs/contributors). Thank you!
