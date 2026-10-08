# Media Player Redux

[![Garry's Mod](https://img.shields.io/badge/Garry's%20Mod-Addon-blue?style=flat-square)](https://gmod.facepunch.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE.md)
[![Steam Workshop](https://img.shields.io/badge/Steam-Workshop-171a21?style=flat-square&logo=steam)](https://steamcommunity.com/sharedfiles/filedetails/?id=3001397905)
[![Documentation](https://img.shields.io/badge/Docs-Wiki-informational?style=flat-square)](https://github.com/PurrCoding/gm-mediaplayer/wiki)

**Play media together in Garry's Mod.** Media Player Redux is an addon for synchronized video and audio playback on in-game screens, with queues, media services, and spatial audio.

It is a community-maintained continuation of the original Media Player by [Samuel Maddock](https://github.com/samuelmaddock), focused on modern Garry's Mod compatibility, additional services, and quality-of-life improvements.

## At a glance

- **Type:** Garry's Mod addon for Sandbox and most other gamemodes
- **Workshop:** [Media Player Redux](https://steamcommunity.com/sharedfiles/filedetails/?id=3001397905)
- **Documentation:** [GitHub Wiki](https://github.com/PurrCoding/gm-mediaplayer/wiki)
- **Issues and feature requests:** [GitHub Issues](https://github.com/PurrCoding/gm-mediaplayer/issues)
- **License:** [MIT](LICENSE.md)

## Features

### Playback and screens

- Synchronized playback for everyone viewing the same screen
- Queue controls for skip, seek, pause, repeat, shuffle, and lock
- Vote-skip support and a request menu with history
- Client fullscreen playback and idle screens
- Spawnable TVs and billboards, with entity duplication support
- CAMI privileges for granular admin control
- Localization in 20+ languages and SQLite request history

### Media services

YouTube, Bilibili, SoundCloud, Twitch, Dailymotion, Internet Archive, Google Drive, Odysee, direct audio URLs (such as `.mp3` and `.ogg`), HTML5 video, images, and optional unrestricted webpage playback.

Support varies by provider and URL type. Playback can also depend on the Chromium/CEF codecs available in the player's Garry's Mod installation.

### Spatial Media Player

Attach an audio source to many props with the Spatial Media Player tool. Players within range can hear the media, with volume fading by distance. Use the tool gun to place, remove, and configure spatial media anchors.

## Requirements

- Garry's Mod (the **x86-64 branch is recommended** for HTML/Chromium playback).
- [GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix) is strongly recommended for H.264 and similar codecs.

Unlike Cinema, this project is a regular addon and can be used in Sandbox and most other gamemodes.

## Installation

### Steam Workshop

1. Subscribe to [Media Player Redux](https://steamcommunity.com/sharedfiles/filedetails/?id=3001397905).
2. For a dedicated server, add Workshop ID `3001397905` to your collection.
3. Restart the server or change map.

### From source

Clone the repository into your Garry's Mod addons directory:

```bash
git clone https://github.com/PurrCoding/gm-mediaplayer.git
```

Place the resulting `gm-mediaplayer/` folder in `garrysmod/addons/`, then restart Garry's Mod or change map.

See the [installation guide](https://github.com/PurrCoding/gm-mediaplayer/wiki/installation) for details.

## Quick start

1. Open **Q menu → Entities → Media Player** and spawn a TV or billboard.
2. Press **E** on the entity to turn it on, or use its context menu.
3. Hold **C** while looking at the screen, or open the request UI, and enter a supported URL.
4. Adjust volume and resolution through the player options or ConVars.

For audio attached to props, select the **Spatial Media Player** tool in the tool menu.

## Configuration

### Server

| ConVar | Default | Description |
|---|---:|---|
| `mediaplayer_debug` | `0` | Verbose console logging |
| `mediaplayer_allow_webpages` | `0` | Allow arbitrary webpage URLs; enable only when needed |
| `mediaplayer_queue_limit` | `64` | Maximum items per media-player queue |
| `mediaplayer_spatial_hear_radius` | `1800` | Maximum distance for spatial media listeners |

### Client

| ConVar | Default | Description |
|---|---:|---|
| `mediaplayer_volume` | `0.15` | Playback volume (0–1) |
| `mediaplayer_resolution` | `480` | Render resolution height |
| `mediaplayer_3daudio` | `1` | Enable 3D spatial audio |
| `mediaplayer_mute_unfocused` | `1` | Mute when the game window is unfocused |
| `mediaplayer_fullscreen` | `0` | Fullscreen playback |
| `mediaplayer_draw_thumbnails` | `0` | Draw thumbnails on screens |
| `mediaplayer_proximity_min` | `100` | Minimum distance for proximity volume |
| `mediaplayer_proximity_max` | `1000` | Maximum distance for proximity volume |

See [Configuration](https://github.com/PurrCoding/gm-mediaplayer/wiki/configuration) for more options and details.

## Spawnable entities

| Entity | Model |
|---|---|
| Big Screen TV | `models/gmod_tower/suitetv_large.mdl` |
| Huge Billboard | `models/hunter/plates/plate5x8.mdl` |
| Small TV | `models/props_phx/rt_screen.mdl` |

Entities are available in the **Media Player** spawn-menu category. Screen size and orientation are configured through `MediaPlayerModelConfigs`.

## Documentation

| Guide | What it covers |
|---|---|
| [Wiki home](https://github.com/PurrCoding/gm-mediaplayer/wiki) | Documentation index |
| [Installation](https://github.com/PurrCoding/gm-mediaplayer/wiki/installation) | Setup and verification |
| [Configuration](https://github.com/PurrCoding/gm-mediaplayer/wiki/configuration) | ConVars and options |
| [Usage](https://github.com/PurrCoding/gm-mediaplayer/wiki/usage) | Entities, queue, and request UI |
| [Spatial Media](https://github.com/PurrCoding/gm-mediaplayer/wiki/spatial-media) | Tool and anchors |
| [Permissions](https://github.com/PurrCoding/gm-mediaplayer/wiki/permissions) | CAMI privileges |
| [Video services](https://github.com/PurrCoding/gm-mediaplayer/wiki/video-services) | Built-in providers |
| [Custom video service](https://github.com/PurrCoding/gm-mediaplayer/wiki/custom-video-service) | Adding a provider |
| [Architecture](https://github.com/PurrCoding/gm-mediaplayer/wiki/architecture) | Players, services, and networking |
| [Development](https://github.com/PurrCoding/gm-mediaplayer/wiki/development) | Layout and contribution notes |
| [Translations](https://github.com/PurrCoding/gm-mediaplayer/wiki/translations) | Localization |

## Repository layout

```text
lua/
  autorun/                    Loader, spawnables, properties, duplication
  entities/
    mediaplayer_base/          Shared base entity
    mediaplayer_tv/            Big Screen TV
    mediaplayer_spatial_anchor/
  mediaplayer/
    players/                   Base, entity, spatial, and mimic players
    services/                  YouTube, Bilibili, SoundCloud, etc.
    controls/                  DHTML and request UI
    i18n/                      Translations
    config/                    Client configuration
  weapons/gmod_tool/stools/
    mediaplayer_spatial.lua
materials/                     Icons and UI assets
public/                        HTML helpers and metadata
mediaplayer.fgd                Hammer definitions
```

Contributor guidance: [AGENTS.md](AGENTS.md).

## Credits

Originally created by [Samuel Maddock](https://github.com/samuelmaddock).

- [Shadowsun™](https://github.com/CattoGamer) — Maintainer; YouTube overhaul, new services, localization, proximity audio, and ongoing maintenance
- [SheepyLord](https://github.com/SheepyLord) — Spatial Media Player and Bilibili integration
- [Astralcircle](https://github.com/Astralcircle) — Spawn-menu icons and repository structure
- [Veitikka](https://github.com/veitikka) — YouTube metadata improvements
- [All other contributors](https://github.com/PurrCoding/gm-mediaplayer/graphs/contributors)

## License

Licensed under the **MIT License**. See [LICENSE.md](LICENSE.md) for the full license text.
