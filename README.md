# Media Player Redux

[![Garry's Mod](https://img.shields.io/badge/Garry's%20Mod-Addon-blue?style=flat-square)](https://gmod.facepunch.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE.md)
[![Steam Workshop](https://img.shields.io/badge/Steam-Workshop-171a21?style=flat-square&logo=steam)](https://steamcommunity.com/sharedfiles/filedetails/?id=3001397905)
[![Documentation](https://img.shields.io/badge/Docs-in%20repository-informational?style=flat-square)](docs/README.md)

**Play media together in Garry's Mod.** Media Player Redux is an addon for synchronized video and audio playback on in-game screens and spatial audio sources, with queues, media services, and per-player controls.

It is a community-maintained continuation of the original Media Player by [Samuel Maddock](https://github.com/samuelmaddock), focused on modern Garry's Mod compatibility, additional services, and quality-of-life improvements.

## At a glance

- **Type:** Garry's Mod addon for Sandbox and most gamemodes that permit the required entities and tools
- **Workshop:** [Media Player Redux](https://steamcommunity.com/sharedfiles/filedetails/?id=3001397905)
- **Documentation:** [Repository documentation](docs/README.md)
- **Issues and feature requests:** [GitHub Issues](https://github.com/PurrCoding/gm-mediaplayer/issues)
- **License:** [MIT](LICENSE.md)

## Features

### Playback and screens

- Synchronized playback for listeners of the same media player
- Queue controls for skip, seek, pause, repeat, shuffle, and lock
- Vote-skip support and a request menu with request history
- Client fullscreen playback and idle screens
- Spawnable TVs and billboards, with Sandbox duplication support
- CAMI privileges for granular admin control
- Localization and SQLite request/metadata history

### Media services

Built-in services include YouTube, Bilibili, SoundCloud, Twitch, Dailymotion, Internet Archive, Google Drive, Odysee, Rumble, Kick, OK, VK Video, MEGA, BitChute, direct media URLs, audio files, SHOUTcast streams, and HTML5 resources. Optional unrestricted webpage playback is also available.

YouTube playlists can be queued from a playlist URL. YouTube subtitles can be selected when captions are available.

Support varies by provider, URL type, region, account access, and the Chromium/CEF codecs available in the player's Garry's Mod installation. SoundCloud requires an updated embedded browser; install [GModPatchTool](https://github.com/solsticegamestudios/GModPatchTool) only from its official project page if needed. The [GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix) can improve codec compatibility.

### Spatial Media Player

Attach an audio source to supported props or place a world-positioned anchor with the Spatial Media Player tool. Players within the configured radius become listeners, and client-side proximity audio can attenuate volume with distance.

## Requirements

- Garry's Mod; the **x86-64 branch is recommended** for HTML/Chromium playback.
- [GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix) is recommended for broader codec support.
- SoundCloud may require [GModPatchTool](https://github.com/BeepIsla/GModPatchTool) to update the embedded browser.
- Some providers require access to their service, compatible codecs, or media that is publicly playable.

This is a regular addon, not a gamemode. Compatibility with other gamemodes depends on whether they allow the relevant entities, tools, and UI interactions.

## Installation

### Steam Workshop

1. Subscribe to [Media Player Redux](https://steamcommunity.com/sharedfiles/filedetails/?id=3001397905).
2. For a dedicated server, add Workshop ID `3001397905` to its Workshop collection.
3. Restart the server or change map so the addon and its client files are mounted.

### From source

Clone the repository into your Garry's Mod addons directory:

```bash
git clone https://github.com/PurrCoding/gm-mediaplayer.git
```

Place the resulting `gm-mediaplayer/` folder in `garrysmod/addons/`, then restart Garry's Mod or change map.

See the [installation guide](docs/installation.md) for details and verification steps.

## Quick start

1. Open **Q menu → Entities → Media Player** and spawn a screen.
2. Press **E** on the entity to activate it, or use its context-menu properties.
3. Hold **C** while looking at the screen to open the request UI.
4. Enter a supported media URL and submit it.
5. Use the player sidebar to control the queue and playback.

For audio attached to props, select **Media Player → Spatial Media Player** in the tool menu.

## Configuration

### Server

| ConVar | Default | Description |
|---|---:|---|
| `mediaplayer_debug` | `0` | Enable verbose diagnostic logging |
| `mediaplayer_allow_webpages` | `0` | Allow otherwise-unmatched webpage URLs; keep disabled on public servers unless required |
| `mediaplayer_queue_limit` | `64` | Maximum number of queued items per media player |
| `mediaplayer_spatial_hear_radius` | `1800` | Maximum listener distance for spatial anchors, in Source units |

### Client

| ConVar | Default | Description |
|---|---:|---|
| `mediaplayer_volume` | `0.15` | Master playback volume (0–1) |
| `mediaplayer_resolution` | `480` | Browser render resolution height |
| `mediaplayer_3daudio` | `1` | Enable distance-based volume |
| `mediaplayer_mute_unfocused` | `1` | Mute when the game window is unfocused |
| `mediaplayer_fullscreen` | `0` | Enable fullscreen playback |
| `mediaplayer_draw_thumbnails` | `0` | Draw thumbnails on screens |
| `mediaplayer_proximity_min` | `100` | Distance at which proximity volume is full |
| `mediaplayer_proximity_max` | `1000` | Distance at which proximity volume reaches zero |
| `mediaplayer_cc_lang` | `off` | YouTube caption language; `off` disables captions |

See [Configuration](docs/configuration.md) for flags, persistence, and usage details.

## Documentation

Start at the [documentation index](docs/README.md). It links installation, usage, configuration, permissions, media services, spatial audio, architecture, and contributor guides.

## Repository layout

```text
lua/
  autorun/                    Loader, spawnables, properties, duplication
  entities/                   Screen and spatial-anchor entities
  mediaplayer/
    players/                  Base, entity, spatial, and mimic players
    services/                 Media provider implementations
    controls/                 DHTML and request UI
    i18n/                     Translations
    config/                   Client-side configuration
  mp_menu/                    Player sidebar and playback UI
  weapons/gmod_tool/stools/   Spatial and mimic tools
materials/                    Icons and UI assets
models/                       Screen models
public/                       HTML helpers and metadata pages
mediaplayer.fgd               Hammer definitions
docs/                         Project documentation
```

Contributor guidance: [AGENTS.md](AGENTS.md).

## Credits

Originally created by [Samuel Maddock](https://github.com/samuelmaddock).

- [Shadowsun™](https://github.com/CattoGamer) — Maintainer; YouTube overhaul, new services, localization, proximity audio, and ongoing maintenance
- [SheepyLord](https://github.com/SheepyLord) — Spatial Media Player and Bilibili integration
- [Astralcircle](https://github.com/Astralcircle) — Spawn-menu icons and repository structure
- [Veitikka](https://github.com/veitikka) — YouTube metadata improvements
- [parkmawani](https://github.com/parkmawani) — YouTube subtitle support
- [All other contributors](https://github.com/PurrCoding/gm-mediaplayer/graphs/contributors)

## License

Licensed under the **MIT License**. See [LICENSE.md](LICENSE.md) for the full license text.
