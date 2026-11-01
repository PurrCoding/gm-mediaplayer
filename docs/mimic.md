# Mimic tool

The Mimic tool lets one screen mirror the media-player state of another screen. It is useful when multiple physical screens should show the same playback without independently managing queues.

## Tool: Media Player → Mimic

The tool is available in the tool menu under **Media Player**.

| Action | Effect |
|---|---|
| Left click | Copy/select the source media-player screen |
| Right click | Turn the targeted compatible screen into a mimic of the selected source |
| Reload (R) | Remove the mimic link and restore the target's previous media-player type/state |

After selecting a source, you can paste it onto multiple target screens without selecting the source again. The client highlights the selected source and nearby mimic screens while the tool is active.

## Restrictions

- The source must be a valid screen media player.
- Spatial anchors cannot be used as sources or targets.
- A mimic cannot be used as a source for another mimic.
- The source and target must be different entities.
- A target that is already playing media or has queued items cannot be converted.
- The tool does not copy media from the target; it snapshots the target's previous player type/state so it can be restored later.

The mimic target does not accept independent media requests. Submit requests on the source screen instead.

## Undo and restoration

Pasting a mimic registers an undo action. Reloading the target also restores its previous player type and saved snapshot. If the source player is removed, the mimic's source reference is cleared by the server.

## Related

- [Usage](usage.md)
- [Architecture](architecture.md)
- [Permissions](permissions.md)
