# Video services

Services live under `lua/mediaplayer/services/` and are registered through `MediaPlayer.RegisterService` in `sh_services.lua`.

Each concrete service has an **Id** (e.g. `yt`, `sc`) and optional **Base** (often `browser` or `base`).

---

## Built-in providers

| Id (typical) | Name | Notes |
|--------------|------|--------|
| `yt` | YouTube | Browser-based; client metadata prefetch |
| `bili` | Bilibili | VOD / related variants |
| `sc` | SoundCloud | Audio |
| `twl` / twitch | Twitch | Streams / VODs subject to embed rules |
| `dm` | Dailymotion | |
| `ia` | Internet Archive | archive.org |
| `gd` | Google Drive | Where embedding works |
| `odysee` | Odysee | |
| `af` | Audio file | Direct `.mp3`, `.ogg`, etc. |
| `h5v` / resource | HTML5 / resource media | Direct video/image-style playback |
| `www` | Webpage | Only when `mediaplayer_allow_webpages` is enabled |
| shoutcast | Shoutcast | Streaming radio-style |

Exact Ids are defined on each service’s `SERVICE.Id`. Abstract bases (`base`, `browser`) are not selectable by users.

Availability depends on embed policy, CEF codecs, and network access from clients.

---

## Resolution flow

```
URL
 → MediaPlayer.GetServiceByUrl / GetMediaForUrl
 → SERVICE:Match(url)
 → service:New(url)  -- instance with urlinfo, Data(), etc.
 → metadata (server HTTP and/or client prefetch)
 → queued on a MediaPlayer instance
 → CLIENT plays via browser panel or HTML5 element
```

`MediaPlayer.ValidUrl(url)` returns whether any non-abstract service matches.

---

## Spatial whitelist

Spatial media players only accept a subset of service Ids (see [Spatial Media](spatial-media.md)).

---

## Related

- [Custom video service](custom-video-service.md)
- [Architecture](architecture.md)
