# Media Player Redux — Documentation

Synchronized multiplayer media streaming for Garry's Mod screens and spatial audio sources.

**Workshop:** [Media Player Redux](https://steamcommunity.com/sharedfiles/filedetails/?id=3001397905)  
**Source:** [github.com/PurrCoding/gm-mediaplayer](https://github.com/PurrCoding/gm-mediaplayer)

---

## Guides

### Getting started

| Page | Description |
|------|-------------|
| [Installation](installation.md) | Workshop and manual setup |
| [Configuration](configuration.md) | Server and client ConVars |
| [Usage](usage.md) | Spawning screens, request UI, queue controls |
| [Spatial Media](spatial-media.md) | Spatial tool and anchors |
| [Permissions](permissions.md) | CAMI privileges |

### Services & development

| Page | Description |
|------|-------------|
| [Video services](video-services.md) | Built-in providers |
| [Custom video service](custom-video-service.md) | Implement a new media provider |
| [Architecture](architecture.md) | MediaPlayer types, services, entities |
| [Development](development.md) | Layout, conventions, contribution |
| [Translations](translations.md) | Adding languages |

---

## Quick start

1. Install the addon (Workshop or `garrysmod/addons/`).
2. Spawn a **Media Player** entity from the Q menu.
3. Press **E** on it to power on, then request a URL (hold **C** while looking at it).
4. For audio-only on props, use the **Spatial Media Player** tool.

Prefer the **x86-64** branch of Garry's Mod and install [GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix) for broader codec support.
