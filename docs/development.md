# Development

> [!TIP]
> Before changing code, read the repository's [contributor instructions](../AGENTS.md). They define the project's Lua realm, security, and performance conventions.

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

The following hooks are called by the current codebase. Hook names and argument order are case-sensitive.

| Hook | Realm | Arguments | Return behavior / purpose |
|---|---|---|---|
| `CanPlayerListenToMediaPlayer` | Server | `mp, ply` | Return exactly `false` to reject the player's request to become a listener. |
| `MediaPlayerIsPlayerPrivileged` | Shared permission path | `mp, ply` | Return a truthy value to grant player-specific privileged control. Ownership and CAMI admin privileges are checked separately. |
| `PreMediaPlayerMediaRequest` | Server | `mp, media, ply` | Return exactly `false` to reject a media request before metadata is fetched. |
| `PostMediaPlayerMediaRequest` | Server | `mp, media, ply` | Called after metadata succeeds and the media has been added to the queue. Return values are ignored. |
| `MediaPlayerAddListener` | Server | `mp, ply` | Called after a player is added to the listener list and the initial state is sent. Return values are ignored. |
| `MediaPlayerRemoveListener` | Server | `mp, ply` | Called when a player is removed from the listener list. Return values are ignored. |
| `MediaPlayerNotifyPlayer` | Server | `mp, ply, message` | Return a truthy value to suppress the default `ply:ChatPrint`; return nil/false to allow it. |
| `MediaPlayerShouldMute` | Client | `mp, media` | Return a truthy value to force-mute this media player for the local client. |
| `MediaPlayerSetupIdlescreen` | Client | `browser` | Set up the idle-screen browser yourself and return a truthy value to prevent the default HTML from being loaded. Return nil/false to use the default idle screen. |

Example: reject requests from a player who is not in a custom allow-list, while leaving the addon's normal checks in place:

```lua
hook.Add("CanPlayerListenToMediaPlayer", "MyAddon_MediaPlayerAccess", function(mp, ply)
    if not MyAddon.CanUseMediaPlayer(ply, mp) then
        return false
    end
end)
```

Example: block a particular media request before metadata lookup:

```lua
hook.Add("PreMediaPlayerMediaRequest", "MyAddon_BlockMedia", function(mp, media, ply)
    if string.find(media:Url(), "example.com", 1, true) then
        return false
    end
end)
```

Example: customize the idle screen. The hook receives the DHTML browser; call `SetHTML` (or otherwise configure the browser) and return `true` to prevent the default idle page from overwriting it:

```lua
hook.Add("MediaPlayerSetupIdlescreen", "MyAddon_IdleScreen", function(browser)
    browser:SetHTML("<html><body><h1>Welcome</h1></body></html>")
    return true
end)
```

These hooks are integration points, not a replacement for server-side validation. In particular, client hooks such as `MediaPlayerShouldMute` and `MediaPlayerSetupIdlescreen` only affect the local client.

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

---

## Related

- [Architecture](architecture.md)
- [Custom video service](custom-video-service.md)
- [Translations](translations.md)
