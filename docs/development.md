# Development

## Stack and project guidance

- **Lua** for Garry's Mod entities, players, services, networking, and tools.
- **HTML/CSS/JavaScript** for browser-based playback and the request UI.
- **CEF/DHTML** is part of the runtime; provider compatibility depends on the embedded browser.

Read [AGENTS.md](../AGENTS.md) before making code changes. It documents the project's realm boundaries, security requirements, performance expectations, and verification approach.

## Source layout

```text
lua/
  autorun/                  Loader, spawnables, properties, duplication
  entities/                 Screen and spatial-anchor entities
  mediaplayer/
    players/                Base, entity, spatial, mimic player types
    services/               Provider implementations and playback backends
    controls/                DHTML and request controls
    i18n/                    Lua translations
    config/                  Client configuration
    sh_*.lua                  Shared systems (ConVars, history, CAMI, events)
  mp_menu/                   Sidebar and playback UI
  weapons/gmod_tool/stools/  Spatial and mimic tools
public/                      Hosted request/player helper pages and scripts
materials/, models/          Addon assets
docs/                        Versioned documentation
```

## Loading and extension patterns

- MediaPlayer types are registered through `MediaPlayer.Register`; register the base type before derived types.
- Services are registered through `MediaPlayer.RegisterService`. The loader in `sh_services.lua` uses an explicit ordered list; adding a service folder alone does not automatically register it. Update the loader and provide the correct shared/server/client files.
- Keep `CLIENT`, `SERVER`, and shared behavior in the same split used by neighboring modules.
- Prefer existing service/player abstractions and hooks over monkey-patching.
- Keep server-owned state and permission checks server-side.

## Public hooks and events

Useful integration hooks include:

| Hook | Purpose |
|---|---|
| `CanPlayerListenToMediaPlayer(mp, ply)` | Return `false` to reject a listener request |
| `MediaPlayerIsPlayerPrivileged(mp, ply)` | Extend player-specific privilege checks |
| `PreMediaPlayerMediaRequest(mp, media, ply)` | Return `false` to reject a media request before metadata lookup |
| `PostMediaPlayerMediaRequest(mp, media, ply)` | Observe a successfully queued request |
| `MediaPlayerNotifyPlayer(mp, ply, message)` | Handle/suppress the default player notification |
| `MediaPlayerAddListener(mp, ply)` | Observe a player becoming a listener |
| `MediaPlayerRemoveListener(mp, ply)` | Observe a player leaving the listener set |
| `MediaPlayerShouldMute(mp, media)` | Client hook; return true to force mute |

MediaPlayer events are emitted through the event emitter. Shared event names include `mediaChanged`, `mp.events.queueChanged`, and `mp.events.playerStateChanged`; client events also include volume and fullscreen state changes.

## Diagnostics

- Set `mediaplayer_debug 1` for verbose server-side logging.
- Use `mediaplayer_clearcache` to clear cached metadata when troubleshooting stale provider metadata (server console/single-player host/superadmin).
- Check both server and client console output; browser/CEF failures may only be visible client-side.

See [Console commands](commands.md) and [Configuration](configuration.md).

## Testing checklist

1. Spawn each screen configuration and verify screen rendering and interaction.
2. Request YouTube and at least one non-YouTube service.
3. Test a second client joining during playback.
4. Test owner controls, vote-skip, CAMI privileges, and queue lock.
5. Test a YouTube playlist, including private/unavailable and oversized playlists where practical.
6. Test spatial listener entry/exit and client proximity attenuation.
7. Test duplication and restoration in Sandbox.
8. Check failure paths: malformed URL, missing metadata, provider error, browser exhaustion, disconnect, and entity removal.

## Related

- [Architecture](architecture.md)
- [Custom video service](custom-video-service.md)
- [Translations](translations.md)
