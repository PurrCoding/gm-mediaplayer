# Permissions (CAMI)

Media Player Redux registers **CAMI** privileges so admin mods (ULX, SAM, ServerGuard, etc.) can grant fine-grained access.

Implementation: `lua/mediaplayer/sh_cami.lua`.

If CAMI is not present, checks fall back to `ply:IsAdmin()` where appropriate.

---

## Privileges

| Privilege | Default MinAccess | Description |
|-----------|-------------------|-------------|
| `MediaPlayer_ClearCache` | superadmin | Truncate `mediaplayer_metadata` (clear cached metadata) |
| `MediaPlayer_Admin` | admin | Full control on any media player (skip, seek, pause, remove, repeat, shuffle, lock, bypass whitelist) |
| `MediaPlayer_Skip` | admin | Skip current media on any player |
| `MediaPlayer_Seek` | admin | Seek current media on any player |
| `MediaPlayer_Remove` | admin | Remove any queued item (not only own) |
| `MediaPlayer_QueueControl` | admin | Toggle repeat, shuffle, and lock on any player |
| `MediaPlayer_BypassWhitelist` | admin | Bypass service whitelist restrictions |

Owners of a media player retain normal control over their own screen/anchor; these privileges extend control to **other** players’ media players.

---

## Helper

```lua
MediaPlayer.PlayerHasPrivilege( ply, "MediaPlayer_Skip" )
```

Use this in custom integrations instead of hard-coding admin checks.

---

## Related

- [Usage](usage.md)
- [Architecture](architecture.md)
