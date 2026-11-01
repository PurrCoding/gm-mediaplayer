# Implementing a custom media service

Media services live under `lua/mediaplayer/services/`. The service loader in `lua/mediaplayer/sh_services.lua` uses an explicit ordered list: creating a folder does **not** register it automatically.

## Service file layout

A typical provider has three files:

```text
services/<name>/
  shared.lua   -- identity, URL matching, parsing, shared behavior
  init.lua     -- server-side metadata / HTTP handling
  cl_init.lua  -- client-side playback
```

Single-file services are also possible (for example `directmedia.lua` and `webpage.lua`). Follow the structure of the closest existing provider.

## Registration and load order

The loader initializes `base` first, then browser/resource/audio abstractions, then concrete providers. A custom provider must be added to the appropriate position in the `services` list in `sh_services.lua`.

The shared service table must define at least:
- `SERVICE.Name`: human-readable provider name.
- `SERVICE.Id`: short, unique identifier used in media IDs and networking.
- `SERVICE.Base`: optional registered base service ID; browser providers usually use `"browser"`.
- `SERVICE:Match(url)`: return true only for URL formats the service actually handles.
- `SERVICE:New(url)`: usually inherit the base constructor and set a stable `_data` identifier.

Example:

```lua
DEFINE_BASECLASS("mp_service_base")

SERVICE.Name = "Example"
SERVICE.Id = "example"
SERVICE.Base = "browser"

function SERVICE:New(url)
    local obj = BaseClass.New(self, url)
    obj._data = obj:GetExampleId()
    return obj
end

function SERVICE:Match(url)
    return string.find(url, "example%.com/watch/")
end
```

The base constructor parses the URL into `urlinfo`. Use a stable provider-specific ID for `_data` so metadata cache keys and history entries identify the same media consistently.

## Server-side metadata

Implement `GetMetadata(callback)` in `init.lua` when the provider exposes metadata through an HTTP API. Use asynchronous HTTP requests; do not block the server.

Typical flow:

1. Check `self:GetCachedMetadata()`.
2. Fetch provider metadata asynchronously.
3. Validate the response and parse JSON safely.
4. Normalize title, duration, thumbnail, and any provider-specific metadata.
5. Call `self:SetMetadata(metadata, true)`.
6. Persist with `MediaPlayer.Metadata:Save(self)`.
7. Invoke the callback with metadata, or `callback(false, reason)` on failure.

Use the base service's `Fetch` helper where appropriate so request/error handling stays consistent. Do not trust provider responses or assume every item has a duration.

Some providers use client-side metadata prefetch. For those, set `SERVICE.PrefetchMetadata = true` and implement the matching client `PreRequest` / `NetWriteRequest` and server `NetReadRequest` flow. Study YouTube or SoundCloud before adding a new variant.

## Client playback

Browser-backed services normally inherit from `mp_service_browser` and implement:
- `GetURL()` or `OnBrowserReady(browser)` to load the embed/player page.
- `SetVolume(volume)` to update the embedded player.
- Pause, seek, and synchronization behavior when the provider supports them.
- `IsTimed()` accurately for live streams and other non-seekable media.

The base browser implementation manages the shared DHTML browser pool. Release resources through the existing service lifecycle; do not create unmanaged panels or timers.

Where possible, expose a consistent JavaScript adapter as `window.MediaPlayer` with `play()`, `pause()`, `currentTime`, and `volume`. Validate any values interpolated into JavaScript and avoid inserting user-controlled strings as executable code.

## Spatial compatibility

Spatial players have a service whitelist in `lua/mediaplayer/players/spatial/shared.lua`. Adding a provider to the global service loader does not automatically make it available for spatial playback. Only add it to that whitelist after checking that the provider works as an audio-focused source.

The current whitelist contains stale IDs that do not all map to registered services; verify the service ID against `sh_services.lua` before relying on it. See [Spatial Media](spatial-media.md).

## Reference implementations

| Service | Useful pattern |
|---|---|
| `youtube/` | Client metadata prefetch, live/timed distinction, playlist integration |
| `dailymotion/` | Browser embed and metadata handling |
| `soundcloud/` | Audio-focused browser playback |
| `audiofile/` | Non-browser audio service |
| `directmedia.lua` | HTML5 video, image, HLS, and DASH resources |
| `webpage.lua` | Optional generic webpage fallback |

## Testing checklist

1. Confirm the URL matcher accepts valid URLs and rejects unrelated pages.
2. Confirm metadata success, malformed responses, unavailable/private content, and timeouts.
3. Confirm the service has a stable unique ID and correct cache behavior.
4. Test playback, pause, volume, synchronization, and seeking where supported.
5. Test more than one screen and a late-joining listener.
6. Verify the provider's spatial compatibility separately, if applicable.
7. Confirm that browser panels, timers, and callbacks are cleaned up after stop/removal.

## Common pitfalls

- Adding a folder but forgetting the explicit loader entry in `sh_services.lua`.
- Reusing an existing service ID or leaving `_data` unstable.
- Treating live media as timed or seekable.
- Calling synchronous/blocking HTTP code from metadata resolution.
- Assuming every browser exposes the same JavaScript player API.
- Adding a service to the spatial whitelist without verifying its actual ID and audio behavior.
- Enabling generic webpage playback as a substitute for a first-class provider.

## Related

- [Video services](video-services.md)
- [Architecture](architecture.md)
- [Development](development.md)
