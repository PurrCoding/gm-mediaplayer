# Frequently asked questions

Quick answers to common questions about playback, browser compatibility, YouTube, networking, Mimic screens, and server administration.

> [!TIP]
> **Start here if playback is broken:** check the [installation requirements](installation.md), try a second supported media URL, and then use the troubleshooting steps below. A provider can fail even when the addon itself is working correctly.

## Playback and browser issues

### Nothing plays, or the screen is black or white

Work through these checks in order:

1. **Check for addon conflicts.** Disable other Garry's Mod media-player addons temporarily. Two addons that modify similar browser or screen behavior may conflict.
2. **Check the browser setup.** Garry's Mod offers both **x86 and x64 modes** in the main branch; no separate x86-64 branch is needed. The x64 mode may offer broader compatibility with some providers. Some providers also require **GModPatchTool**; see [Installation](installation.md).
3. **Test more than one provider.** If one YouTube URL fails but a direct media URL works, the issue may be specific to YouTube rather than the player.
4. **Check network filtering.** VPNs, DNS filters, antivirus web protection, firewalls, school/work networks, or ISP restrictions can prevent the embedded browser from reaching a provider.
5. **Check the game console.** Look for browser, codec, or Lua errors. If you are reporting a bug, include the exact URL type/provider, your Garry's Mod branch, whether GModPatchTool is installed, and any relevant error text. Do not post passwords, cookies, or private access tokens.

> [!WARNING]
> Do not permanently disable your firewall or antivirus to make playback work. If you briefly disable a protection feature to isolate a problem, do so only as a controlled test and turn it back on immediately.

Changing DNS or trying another network can help identify a routing/filtering issue, but neither is a guaranteed fix. Cloudflare DNS uses `1.1.1.1` and `1.0.0.1`; Cloudflare WARP is a separate network-routing application. These are external tools, not Media Player features.

### Can I play files stored on my computer?

No. Media Player accepts web URLs using HTTP or HTTPS. Local paths such as `C:\video.mp4` and `file://` URLs are blocked intentionally.

A file on your computer is not hosted for the other players on the server. Even if your own client could open it, other players would not automatically have access to the same file.

**What to do instead:** upload the media to a host that provides a link accessible to the people watching, then submit that URL. Check [Built-in media services](video-services.md) for supported providers and direct-media URL types. For cloud-drive links, make sure the file permissions allow the embedded player to access the media.

### What does “Browser Limit Reached” mean?

Media Player has a limited number of embedded browser slots. If all available slots are occupied, a new player may have to wait until a slot becomes available.

This message does not necessarily mean the URL is broken. Close unused media-player screens where possible and try again after a slot is freed.

### A service says “GModPatchTool Required”

Some providers depend on browser features or codecs that are not available in the stock Garry's Mod browser. The Workshop FAQ specifically mentions YouTube Live, Bilibili, Twitch, direct video files, and Google Drive as cases that may require x64 mode and GModPatchTool.

Follow the current [installation guide](installation.md) and the tool's own setup instructions. Do not assume that installing a codec package and installing GModPatchTool are interchangeable steps: they address related but distinct browser compatibility issues.

### Does Media Player work in x86 mode?

Yes. Garry's Mod provides both x86 and x64 modes from the main branch, and Media Player can be used in either mode. However, browser features, codecs, and individual provider requirements can differ. If a provider fails in x86 mode, try x64 mode and check whether additional browser compatibility fixes are required.

> [!TIP]
> For broader HTML/Chromium and provider compatibility, x64 mode is recommended. You can select it without switching to a separate beta branch; see [Installation](installation.md).

### Why does a video have low quality, or why can't I choose its quality?

Video quality is generally selected by the provider's embedded player, not by a universal Media Player quality selector. Available quality can depend on the provider, the media itself, account status, network conditions, and browser capabilities.

For example, the Workshop FAQ notes that Bilibili may limit playback quality when no Bilibili account is logged in. The addon cannot guarantee that every provider exposes the same quality controls.

### Are subtitles supported?

The current addon includes a client setting for YouTube captions: `mediaplayer_cc_lang`. Set it to a language code such as `en` or `ko`; use `off` to disable captions. Availability still depends on whether YouTube provides captions for that video.

> [!NOTE]
> The older Workshop FAQ says subtitles are disabled. That statement does not match the current repository documentation, which includes the caption-language setting. The current addon behavior and this repository's [console/ConVar reference](commands.md) take precedence.

## YouTube

### YouTube asks me to sign in or “prove I'm not a robot”

This is a verification challenge generated by YouTube. It can be triggered by VPN exit addresses, shared IP addresses, or network activity that YouTube considers unusual.

> [!WARNING]
> **Do not sign in to your Google account or enter your password in Garry's Mod's embedded browser.** Media Player cannot remove a verification challenge that YouTube itself is serving.

If you are not using a VPN, YouTube may still flag your public IP address. Shared ISP addresses (CGNAT), school/work networks, and heavily used IP addresses can contribute. This is controlled by YouTube and your network provider, not by Media Player.

### YouTube does not load while my VPN is enabled

YouTube may challenge or block traffic from VPN exit addresses. As a diagnostic test, you can try:

- Disconnecting the VPN while using Media Player, if that is safe and appropriate for your network.
- Trying a different VPN server.
- Using split tunneling so Garry's Mod uses your normal connection.

These are network workarounds, not addon settings. Follow your VPN provider's guidance and local rules.

### YouTube shows a cookie screen or an unexpected page instead of the video

These pages are generated by YouTube and may vary by region, account state, and time. Media Player uses YouTube's privacy-enhanced embed mode, but that does not guarantee YouTube will always serve the video directly.

If the same video is blocked in the embedded player, the addon may not be able to work around the restriction.

### Why not use Invidious, Piped, or another alternative YouTube frontend?

Third-party frontend instances can go offline, disable embedding, impose rate limits, return incomplete metadata, or offer inconsistent playback quality. Those problems are especially disruptive when many players on a server rely on the same source.

Media Player uses the official YouTube player rather than depending on a rotating list of community-hosted frontend instances.

### Why won't an age-restricted video play?

Age-restricted YouTube videos can require an authenticated account. Media Player uses an anonymous embedded player, so it cannot provide the account verification YouTube requires.

There is no Media Player setting that bypasses YouTube's age restrictions.

### Why won't a copyrighted, region-blocked, or non-embeddable video play?

A video may be unavailable because of its country restrictions, copyright settings, privacy state, or the uploader's choice to disable embedding. These restrictions are enforced by YouTube and cannot be overridden by the addon.

## Other streaming services

### Can Netflix, Spotify, Disney+, or similar subscription services be added?

Many subscription services rely on DRM systems such as Widevine and Verified Media Path (VMP). Garry's Mod's embedded browser is not an approved playback environment for some of these protections, so the service may refuse to play.

This is a browser/platform compatibility limitation, not simply a missing Media Player provider. The addon cannot legitimately grant the embedded browser DRM capabilities or bypass a provider's protection.

For services that are currently supported, see [Built-in media services](video-services.md).

## Network and regional issues

### A website works in my normal browser but not in Media Player

Your regular browser and Garry's Mod may differ in browser engine, codecs, DNS configuration, VPN routing, certificates, extensions, or account state. A school/work firewall, ISP filter, or country-level restriction may also affect one connection but not the other.

Try to determine whether the failure is provider-specific or network-wide:

1. Test another supported provider.
2. Test the same URL in your normal browser.
3. Check whether Garry's Mod is routed through a VPN or proxy.
4. Review the game console for the exact browser error.

Media Player cannot change your operating system's network configuration.

### What does `ERR_CONNECTION_RESET` mean?

It means the connection was interrupted before the page could finish loading. Possible causes include a firewall, antivirus web filter, ISP restriction, network firewall, or deep packet inspection (DPI).

Check your local security/network settings and, if possible, test from another trusted network. Do not leave security protections disabled as a workaround.

### What is DPI? Can external tools help?

**Deep Packet Inspection (DPI)** is a technique used by some networks to inspect and classify network traffic. Depending on the network, this can interfere with connections to particular services.

Tools such as Zapret, GoodbyeDPI, or PowerTunnel are third-party network tools that may change how some connections are handled. They are not part of Media Player, are not officially supported by the addon, and should only be used where lawful and safe.

### Does Media Player include a VPN or proxy?

No. Network routing must be handled by your operating system, network, VPN provider, or other external software. Media Player does not provide a built-in VPN or proxy.

## Mimic screens

### How do I create a Mimic screen?

Use the **Mimic Media** tool under **Tools → Media Player**:

1. Equip the Mimic Media tool.
2. **Left-click** the screen whose playback should be mirrored (the source).
3. **Right-click** each compatible screen that should mirror that source (the targets).
4. Look at a mimic screen and press **R** (Reload) to remove its mimic link.

You can use one selected source for multiple targets. See the [Mimic tool guide](mimic.md) for restrictions and restoration behavior.

### Why does a mimic screen say “Waiting for source”?

The source screen is not currently playing media or has been turned off. The mimic should begin displaying the source again when playback resumes.

### Can I turn a screen that is already playing into a mimic?

No. The target screen must not already be playing media or have queued items. Stop playback and clear the target's queue before converting it. A mimic also cannot be used as the source for another mimic, and spatial anchors are not valid sources or targets.

> [!NOTE]
> A mimic mirrors another screen; it is not an independent player. Submit media requests on the source screen.

## Controls and settings

### How do I open the player controls or change the volume?

Hold **C** while looking at a media-player screen to open the sidebar. Volume and other local playback options are available there.

For client ConVars and their defaults, see [Console commands and ConVars](commands.md) and [Configuration](configuration.md).

### How do I toggle fullscreen?

Look at a screen and press **F11**, or use **Media Player → Fullscreen**. Fullscreen is a local display mode: it changes how the screen is presented on your client, not the shared playback state for other viewers.

### How do I control who can skip, seek, or remove media?

Media Player integrates with **CAMI** and supports common admin systems such as ULX, SAM, and ServerGuard. Permissions are checked server-side.

See [Permissions](permissions.md) for the available privileges and [Console commands and ConVars](commands.md) for administrative commands and settings.

## Server administration

### Which ConVars are useful for server owners?

| ConVar | Default | Purpose |
|---|---:|---|
| `mediaplayer_debug` | `0` | Enables diagnostic logging |
| `mediaplayer_allow_webpages` | `0` | Allows otherwise-unmatched URLs to use the generic webpage service |
| `mediaplayer_queue_limit` | `64` | Sets the maximum queue length |
| `mediaplayer_spatial_hear_radius` | `1800` | Sets the spatial listener radius in Source units |

See [Console commands and ConVars](commands.md) for the full list, including client settings.

> [!WARNING]
> Keep `mediaplayer_allow_webpages` disabled on public servers unless you deliberately want users to load arbitrary webpages and have considered the additional risk. Prefer the built-in provider list when possible.

### Can I restrict which services players can use?

Yes. Media Player entities support a service whitelist. Only services on the whitelist are allowed, except for users with the `MediaPlayer_BypassWhitelist` privilege.

The spatial player has its own service whitelist. See [Permissions](permissions.md) and [Built-in media services](video-services.md) for details.

### What information should I include when reporting a problem?

A useful report helps distinguish addon bugs from provider or network failures. Include:

- The provider and type of URL (do not include private or access-token URLs).
- What happens: black screen, loading forever, browser error, missing audio, or another symptom.
- Your Garry's Mod architecture mode (x86 or x64).
- Whether GModPatchTool and the recommended codec/browser fixes are installed.
- Relevant game-console errors and the steps needed to reproduce the issue.

> [!WARNING]
> Remove passwords, session cookies, private URLs, IP addresses, and other personal information before sharing logs or screenshots.

---

## Source and related guides

This FAQ is based on the [pinned Media Player Redux Steam Workshop FAQ](https://steamcommunity.com/workshop/filedetails/discussion/3001397905/801220136404147904/) and reconciled with the current documentation in this repository.

- [Installation](installation.md)
- [Usage](usage.md)
- [Built-in media services](video-services.md)
- [Configuration](configuration.md)
- [Console commands and ConVars](commands.md)
- [Mimic tool](mimic.md)
- [Permissions](permissions.md)
