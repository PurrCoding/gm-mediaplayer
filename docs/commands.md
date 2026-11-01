# Console commands and diagnostics

This page lists the console command currently registered by the addon. It is not a list of built-in Garry's Mod commands.

## Server command

| Command | Where | Permission | Description |
|---|---|---|---|
| `mediaplayer_clearcache` | Server console or player console | Server console and single-player host are allowed; multiplayer players need superadmin access / `MediaPlayer_ClearCache` | Clears the SQLite `mediaplayer_metadata` cache table |

Run from the server console:

```text
mediaplayer_clearcache
```

The command clears cached titles, durations, thumbnails, and metadata. It does **not** clear `mediaplayer_history`, queues, or current playback. Metadata is fetched again when media is requested.

## Debug logging

Set `mediaplayer_debug 1` in the server console to enable server-side diagnostics, or in the client console for client-side diagnostics. Set it back to `0` to disable logging in that realm. The setting is not archived by the addon.

Debug output is written to the server console and may include request, listener, queue, state, and SQLite activity. Avoid leaving verbose logging enabled unnecessarily on busy servers.

## Related

- [Configuration](configuration.md)
- [Permissions](permissions.md)
- [Architecture](architecture.md)
