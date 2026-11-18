# Built-in media services

The service loader is defined in `lua/mediaplayer/sh_services.lua`. It registers the providers below and matches URLs against their service-specific rules. Matching is based on URL shape, not a guarantee that a provider will play every item.

> [!WARNING]
> A recognized URL format does not guarantee that the media will play. Provider availability, privacy settings, regional restrictions, network access, and the installed CEF codecs can all affect playback.

## Registered providers

| Provider | Service ID | Typical supported URL/content |
|---|---|---|
| YouTube | `yt` | Videos, Shorts, and supported playlist URLs |
| Bilibili | `bili` | Video pages and supported player URLs |
| SoundCloud | `sc` | Individual track URLs |
| Twitch | `twl` | Channel livestreams |
| Dailymotion | `dm` | Video pages |
| Internet Archive | `ia` | Item details and file-specific URLs |
| Google Drive | `gd` | Shared video files |
| Odysee | `odysee` | Video/claim pages |
| Rumble | `rumble` | Video pages and Shorts |
| Kick | `kick` | Channel livestreams and VODs |
| OK | `ok` | Video and live pages |
| VK Video | `vk` | Video and live URLs |
| MEGA | `mega` | Shared file and embed links |
| BitChute | `bitchute` | Video and embed URLs |
| Direct media | `dm5` | Direct video, image, HLS (`.m3u8`), and DASH (`.mpd`) URLs |
| Audio file | `af` | Direct `.mp3`, `.wav`, and `.ogg` URLs |
| SHOUTcast Radio | `scr` | SHOUTcast station URLs, `.pls`, and supported `.m3u` playlists |
| Generic webpage | `www` | Arbitrary webpages, only when explicitly enabled |

The `browser` and `res` services are abstract base classes used by concrete providers; they are not standalone providers users should select.

## Spatial compatibility

Spatial players initialize a `ServiceWhitelist` in `lua/mediaplayer/players/spatial/shared.lua`. The current default list in code is:

```lua
{
    "yt", "bili", "sc", "twl", "dm", "ia",
    "odysee", "tt", "gd", "h5v", "af"
}
```

The current registered providers that match this list are YouTube (`yt`), Bilibili (`bili`), SoundCloud (`sc`), Twitch (`twl`), Dailymotion (`dm`), Internet Archive (`ia`), Odysee (`odysee`), Google Drive (`gd`), and audio files (`af`). The IDs `tt` and `h5v` remain in the default list but are not registered by the current service loader.

Other registered providers—including Rumble, Kick, OK, VK Video, MEGA, BitChute, direct media (`dm5`), and SHOUTcast (`scr`)—are not included in the spatial default whitelist. Do not assume every built-in provider works on spatial anchors. The server-side whitelist can be bypassed by a player with `MediaPlayer_BypassWhitelist` (or the general `MediaPlayer_Admin` privilege). See [Permissions](permissions.md#service-whitelist) for custom whitelist behavior.

## Provider limitations

- **YouTube:** playlists are expanded server-side, with a per-request limit of 50 items and a cooldown. Auto-generated Mix playlists are not expanded.
- **Bilibili:** without a logged-in Bilibili account, the platform may limit video quality to 360p.
- **SoundCloud:** the stock Garry's Mod CEF 86 browser may be too old; an updated embedded browser may be required.
- **Live streams:** providers report different timing capabilities. Seeking and automatic end detection are unavailable for services marked as untimed.
- **Direct media:** the file extension selects a playback path; unsupported codecs or access restrictions can still prevent playback.
- **Generic webpages:** arbitrary webpage playback is disabled by default and should be treated as a security-sensitive server option.

Provider behavior can change independently of the addon. A matching URL only means the addon recognizes the URL format; it does not guarantee that the provider is reachable, the content is public, or the installed CEF build supports its codecs.

## Enabling generic webpages

Set the server ConVar:

```text
mediaplayer_allow_webpages 1
```

This allows otherwise-unmatched URLs to fall back to the generic webpage service. Keep it disabled on public servers unless you deliberately accept the additional risk and restrict who can submit requests.

## Adding a provider

See [Custom video service](custom-video-service.md).

---

## Related

- [Configuration](configuration.md)
- [Spatial Media](spatial-media.md)
- [Custom video service](custom-video-service.md)
