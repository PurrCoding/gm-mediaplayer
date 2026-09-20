# Media Player Redux

[![Garry's Mod](https://img.shields.io/badge/Garry's%20Mod-Addon-blue?style=flat-square)](https://gmod.facepunch.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE.md)
[![Steam Workshop](https://img.shields.io/badge/Steam-Workshop-171a21?style=flat-square&logo=steam)](https://steamcommunity.com/sharedfiles/filedetails/?id=3001397905)
[![Docs](https://img.shields.io/badge/Docs-docs%2Fwiki-informational?style=flat-square)]([Wiki](https://github.com/PurrCoding/gm-mediaplayer/wiki))

**Synchronized media streaming** for Garry's Mod — play videos, music, and other media on in-game screens, with real-time sync across all players.

Community-maintained continuation of the original Media Player by [Samuel Maddock](https://github.com/samuelmaddock). Focused on modern GMod compatibility, additional services, spatial audio, and quality-of-life features.

---

## Links

| | |
|---|---|
| **Workshop** | [Media Player Redux](https://steamcommunity.com/sharedfiles/filedetails/?id=3001397905) |
| **Documentation** | [docs/wiki](https://github.com/PurrCoding/gm-mediaplayer/wiki) |
| **Issues** | [Bug reports & feature requests](https://github.com/PurrCoding/gm-mediaplayer/issues) |
| **CEF Codec Fix** | [Recommended for many formats](https://github.com/solsticegamestudios/GModCEFCodecFix) |

---

## Features

### Playback

- Synchronized playback for everyone viewing the same screen
- Queue with skip, seek, pause, repeat, shuffle, and lock
- Vote-skip support
- Fullscreen mode on the client
- Idle screen when nothing is playing
- Request menu (URL + history-friendly UX)
- 3D spatial audio with proximity volume

### Media services

YouTube · Bilibili · SoundCloud · Twitch · Dailymotion · Internet Archive · Google Drive · Odysee · direct audio (`.mp3`, `.ogg`, …) · HTML5 video · images · optional unrestricted webpages (server ConVar)

### Spatial Media tool

Attach an audio source to almost any prop. Listeners within range hear the media; volume fades with distance. Place, remove, and reopen controls from the tool gun.

### Other

- Spawnable TVs and billboards (Sandbox spawn menu)
- Duplication support for media player entities
- CAMI privileges for granular admin control
- Localization (20+ languages)
- SQLite request history

---

## Requirements

- **Garry's Mod** (x86-64 branch recommended for HTML / Chromium playback)
- **[GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix)** — strongly recommended for H.264 and similar codecs

Works as a normal **addon** in Sandbox and most other gamemodes (unlike Cinema, which is a full gamemode).

---

## Installation

### Steam Workshop (recommended)

1. Subscribe on the [Workshop page](https://steamcommunity.com/sharedfiles/filedetails/?id=3001397905).
2. On dedicated servers, add Workshop ID `3001397905` to your collection.
3. Restart the server or change map.

### From source

```bash
git clone https://github.com/PurrCoding/gm-mediaplayer.git
# Place the folder into garrysmod/addons/
```

Restart Garry's Mod or change the map after installing.

Full details: **[Installation](https://github.com/PurrCoding/gm-mediaplayer/wiki/installation)**.

---

## Quick start

1. Open the **Q** menu → **Entities** → **Media Player** → spawn a TV or billboard.
2. Press **E** on the entity to turn it on (or use the context menu).
3. Hold **C** while looking at it (or use the request UI) and paste a supported URL.
4. Adjust volume / resolution in the Media Player options (menubar or ConVars).

For prop-attached audio only, use the **Spatial Media Player** tool under **Media Player** in the tool menu.

---

## Configuration

### Server

| ConVar | Default | Description |
|--------|---------|-------------|
| `mediaplayer_debug` | `0` | Verbose console logging |
| `mediaplayer_allow_webpages` | `0` | Allow arbitrary webpage URLs (use with care) |
| `mediaplayer_queue_limit` | `64` | Max items per media player queue |
| `mediaplayer_spatial_hear_radius` | `1800` | Max distance for spatial media listeners |

### Client

| ConVar | Default | Description |
|--------|---------|-------------|
| `mediaplayer_volume` | `0.15` | Playback volume (0–1) |
| `mediaplayer_resolution` | `480` | Render resolution height |
| `mediaplayer_3daudio` | `1` | 3D spatial audio |
| `mediaplayer_mute_unfocused` | `1` | Mute when the game window is unfocused |
| `mediaplayer_fullscreen` | `0` | Fullscreen playback |
| `mediaplayer_draw_thumbnails` | `0` | Draw thumbnails on screens |
| `mediaplayer_proximity_min` | `100` | Min distance for proximity volume |
| `mediaplayer_proximity_max` | `1000` | Max distance for proximity volume |

More detail: **[Configuration](https://github.com/PurrCoding/gm-mediaplayer/wiki/configuration)**.

---

## Spawnable entities

| Entity | Model |
|--------|--------|
| Big Screen TV | `models/gmod_tower/suitetv_large.mdl` |
| Huge Billboard | `models/hunter/plates/plate5x8.mdl` |
| Small TV | `models/props_phx/rt_screen.mdl` |

All under the **Media Player** category in the spawn menu. Screen size and orientation come from `MediaPlayerModelConfigs`.

---

## Documentation

| Guide | Description |
|-------|-------------|
| [Home](https://github.com/PurrCoding/gm-mediaplayer/wiki) | Documentation index |
| [Installation](https://github.com/PurrCoding/gm-mediaplayer/wiki/installation) | Setup and verification |
| [Configuration](https://github.com/PurrCoding/gm-mediaplayer/wiki/configuration) | ConVars and options |
| [Usage](https://github.com/PurrCoding/gm-mediaplayer/wiki/usage) | Entities, queue, request UI |
| [Spatial Media](https://github.com/PurrCoding/gm-mediaplayer/wiki/spatial-media) | Tool and anchors |
| [Permissions](https://github.com/PurrCoding/gm-mediaplayer/wiki/permissions) | CAMI privileges |
| [Video services](https://github.com/PurrCoding/gm-mediaplayer/wiki/video-services) | Built-in providers |
| [Custom video service](https://github.com/PurrCoding/gm-mediaplayer/wiki/custom-video-service) | Add a new provider |
| [Architecture](https://github.com/PurrCoding/gm-mediaplayer/wiki/architecture) | Players, services, networking |
| [Development](https://github.com/PurrCoding/gm-mediaplayer/wiki/development) | Layout and contribution notes |
| [Translations](https://github.com/PurrCoding/gm-mediaplayer/wiki/translations) | i18n |

---

## Repository layout

```
lua/
  autorun/                 Loader, spawnables, properties, dupe support
  entities/
    mediaplayer_base/      Shared base entity
    mediaplayer_tv/        Big Screen TV
    mediaplayer_spatial_anchor/
  mediaplayer/
    players/               base · entity · spatial · mimic
    services/              youtube · bilibili · soundcloud · …
    controls/              DHTML / request UI
    i18n/                  Translations
    config/                Client config
  weapons/gmod_tool/stools/
    mediaplayer_spatial.lua
materials/                 Icons and UI assets
models/                    (if any bundled)
mediaplayer.fgd            Hammer definitions
public/                    HTML helpers for browsers / metadata
```

Contributor standards: **[AGENTS.md](AGENTS.md)**.

---

## Credits

Originally created by [Samuel Maddock](https://github.com/samuelmaddock).

### Contributors

- [Shadowsun™](https://github.com/CattoGamer) — Maintainer; YouTube overhaul, new services, i18n, proximity audio, ongoing maintenance
- [SheepyLord](https://github.com/SheepyLord) — Spatial media player, Bilibili integration
- [Astralcircle](https://github.com/Astralcircle) — Spawn menu icons, category icon, repository structure
- [veitikka](https://github.com/veitikka) — YouTube metadata improvements

…and [all other contributors](https://github.com/PurrCoding/gm-mediaplayer/graphs/contributors).

---

## License

This project is licensed under the **MIT License**. See [LICENSE.md](LICENSE.md).
