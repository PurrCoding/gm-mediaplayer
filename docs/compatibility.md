# Third-party add-on compatibility

Media Player Redux is designed to work with Garry's Mod and its supported runtime dependencies. Other Workshop add-ons and gamemode modifications can change entities, rendering, input, permissions, or browser behavior and may introduce conflicts.

> [!WARNING]
> Third-party add-ons are not officially supported or guaranteed to remain compatible. The notes below are historical community-reported observations, not a current compatibility certification. Versions, load order, gamemode, and server configuration can change the result.

## Community-reported observations

The following observations were listed in the former Steam Workshop compatibility reference:

| Add-on | Historical observation | Current status |
|---|---|---|
| Lambda Players | Reported to seem to work, but had not been thoroughly tested. | Unverified |
| Extended Props | Reported to work. | Unverified |
| Emissive Lighting | Reported to work with ordinary media-player screens, but not with Mimic players. | Unverified; Mimic-specific limitation reported |

These notes are retained for context only. They should not be interpreted as endorsements or promises that a particular version works.

## Troubleshooting a suspected conflict

1. Reproduce the issue with Media Player Redux and the minimum required dependencies enabled.
2. Test the same screen and action in a clean Sandbox session, if possible.
3. Re-enable third-party add-ons in small groups to identify a conflict.
4. Record the Garry's Mod architecture mode (x86 or x64), gamemode, affected add-on versions, and relevant client/server console errors.
5. Report the smallest reproducible case. Remove private URLs, session tokens, and personal information from logs.

For general playback and browser issues, see the [FAQ](faq.md). For integration hooks and extension guidance, see [Development](development.md).
