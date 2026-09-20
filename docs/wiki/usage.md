# Usage

## Spawnable screens

Open **Q** → **Entities** → **Media Player**:

| Name | Notes |
|------|--------|
| Big Screen TV | Default large suite TV model |
| Huge Billboard | Wide hunter plate; large 3D2D surface |
| Small TV | Compact Phoenix RT screen |

Each model has a `MediaPlayerModelConfigs` entry (angle, offset, width, height) used to place the 3D2D panel.

### Power and interaction

- **E** (use) on a TV typically toggles / activates the media player.
- **Right-click** the entity for Sandbox properties (see `lua/autorun/properties/mediaplayer.lua`).
- Hold **C** (context menu) while looking at an active player to open the sidebar / request UI.
- **Q** can also interact with queue shortcuts on the client when the player is focused on a media player.

---

## Requesting media

1. Look at an active media player entity (or spatial target).
2. Open the request UI (hold **C**, or the dedicated request panel).
3. Paste a supported URL and submit.

The server resolves the URL through registered **services**, fetches metadata, and enqueues a media object.  
Unsupported URLs fail unless `mediaplayer_allow_webpages` is enabled (webpage fallback).

---

## Queue controls

Depending on privileges (owner / admin / CAMI):

- Skip current item
- Seek within timed media
- Pause / resume
- Remove queued items
- Toggle **repeat**, **shuffle**, and **queue lock**
- Vote-skip (when enabled by the voteskip component)

Queue size is capped by `mediaplayer_queue_limit`.

---

## Fullscreen

Client ConVar `mediaplayer_fullscreen` (and UI toggles) can expand the current media to a fullscreen panel for the local player without affecting others.

---

## Duplication

Sandbox duplication of media player entities is supported via `lua/autorun/sandbox/mediaplayer_dupe.lua`. Owners and media state restore according to that module’s rules.

---

## Related

- [Spatial Media](spatial-media.md)
- [Video services](video-services.md)
- [Permissions](permissions.md)
