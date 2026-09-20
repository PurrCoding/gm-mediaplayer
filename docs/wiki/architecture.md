# Architecture

## Layers

| Layer | Role |
|-------|------|
| **Entities** | `mediaplayer_base`, `mediaplayer_tv`, `mediaplayer_spatial_anchor` — world objects that host a MediaPlayer |
| **MediaPlayer types** | `base`, `entity`, `spatial`, `mimic` — queue, state, listeners, net |
| **Services** | URL match → metadata → playback backend |
| **Controls / UI** | DHTML request panel, screen drawing, fullscreen |
| **Support** | History (SQLite), metadata cache, CAMI, i18n, browser pool |

---

## MediaPlayer types

Registered via `MediaPlayer.Register` (`sh_mediaplayer.lua`).

- **base** — queue, state (`MP_STATE_*`), owner, repeat/shuffle/lock, voteskip hooks, snapshot helpers
- **entity** — tied to a screen entity; 3D2D drawing and local listeners
- **spatial** — tied to an anchor; distance-based listener updates; service whitelist
- **mimic** — specialized follow/copy behaviour (see module files)

Server tracks **listeners**; only listeners receive media net updates for that instance.

---

## Services

- `MediaPlayer.RegisterService(serviceTable)` inherits from `Base` or `base`
- Instances created with `service:New(url)`
- Important API (base): `Match`, `Data`, `Title`, `Duration`, `IsTimed`, `Owner*`, `SetMetadata`, play/pause/volume on client

Browser services extend `browser` and use the shared **browser pool** for DHTML panels.

---

## Networking

Each media player type implements net write/read for state and media snapshots. Prefer existing helpers over ad-hoc net messages. Admin actions are gated by owner checks and [CAMI privileges](permissions.md).

---

## History & metadata

- **History** (`sh_history.lua`): logs requests into `mediaplayer_history` (media id, url, player, steamid, time).
- **Metadata** (`sh_metadata.lua`): caches resolved titles/durations (related SQL table; clearable via `MediaPlayer_ClearCache` privilege).

---

## Extension points

| Goal | Where |
|------|--------|
| New platform | New folder under `services/` — [Custom video service](custom-video-service.md) |
| New screen model | `AddMediaPlayerModel` in `mediaplayer_spawnables.lua` + model config |
| New player behaviour | New type under `players/` registered after `base` |
| Admin rules | CAMI privileges / `IsPlayerPrivileged` |

---

## Related

- [Development](development.md)
- [Custom video service](custom-video-service.md)
