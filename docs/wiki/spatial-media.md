# Spatial Media

Spatial media attaches a **MediaPlayer** instance to a prop (or a world position via an anchor entity). Nearby players become **listeners**; audio is attenuated by distance.

---

## Tool: Spatial Media Player

Category: **Media Player** in the tool menu.

| Action | Effect |
|--------|--------|
| **Left click** | Place a spatial source on the traced entity (or create a world-positioned anchor) |
| **Right click** | Remove an existing spatial source you control |
| **Reload** | Reopen the request UI for an existing source |

Valid targets: props and similar entities. Players, NPCs, ragdolls, and existing media player screen entities are rejected.

When a prop is targeted, an `mediaplayer_spatial_anchor` is parented to it and removed with the prop. World placements use a free-standing anchor within a match radius.

Controls and undo/cleanup are registered for the creating player.

---

## Hear radius

ConVar: `mediaplayer_spatial_hear_radius` (default **1800**).

Each think, the spatial media player gathers human players within that distance of the anchor and sets them as listeners. Outside the radius, players stop receiving that stream.

Client proximity volume still applies via `mediaplayer_proximity_min` / `mediaplayer_proximity_max` when 3D audio is enabled.

---

## Service whitelist

Spatial players use a reduced service whitelist (see `players/spatial/shared.lua`), including YouTube, Bilibili, SoundCloud, Twitch, Dailymotion, Internet Archive, Odysee, Google Drive, HTML5 video, and audio files. This keeps spatial sources focused on media that works well without a large screen.

---

## Permissions

Requesting and controlling spatial media requires privilege on that player instance (`IsPlayerPrivileged`). Typically the creator/owner (and admins via CAMI) can control the anchor.

---

## Related

- [Usage](usage.md)
- [Permissions](permissions.md)
- [Configuration](configuration.md)
