# Installation

## Requirements

- Garry's Mod. The **x64 mode** is recommended for broader HTML/Chromium compatibility; x86 mode is also available. Both modes can be selected in the main branch, so no separate x86-64 branch is required.
- [GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix) is recommended for broader H.264 and media codec compatibility.
- SoundCloud may require an updated embedded Chromium/CEF browser; consult the project's current [GModPatchTool](https://github.com/solsticegamestudios/GModPatchTool) guidance.

Media Player Redux is a regular addon, not a gamemode. It works with Sandbox and other gamemodes that allow its entities, tools, and UI interactions.

## Steam Workshop (recommended)

1. Subscribe to [Workshop item 3001397905](https://steamcommunity.com/sharedfiles/filedetails/?id=3001397905).
2. On a dedicated server, add Workshop ID `3001397905` to the server's Workshop collection.
3. Restart the server or change map so the addon and its client files are mounted.

## Manual / Git installation

1. Clone or download this repository:

   ```bash
   git clone https://github.com/PurrCoding/gm-mediaplayer.git
   ```

2. Place the resulting folder under:

   ```text
   garrysmod/addons/gm-mediaplayer/
   ```

   The folder name can vary, but it must contain the addon's `lua/`, `materials/`, and other resource directories directly.

3. Restart Garry's Mod or change map.

Workshop releases may lag behind the repository. Use a source checkout when testing the latest development changes.

## Verify the installation

1. Open **Q → Entities → Media Player**.
2. Spawn one of the available screens.
3. Press **E** to activate it.
4. Hold **C** while looking at the screen to open the request UI.
5. Request a publicly playable URL from a supported service.
6. Confirm that another player can see/hear synchronized playback.

## Troubleshooting

### General checks

- **No Media Player category:** confirm the addon is mounted and check the server/client console for Lua errors.
- **Black screen or codec error:** if you are using x86 mode, try switching to x64 mode and check whether the provider requires a codec unsupported by your CEF build. The GMod CEF Codec Fix may improve codec compatibility.
- **SoundCloud does not load:** check the embedded browser version and the GModPatchTool requirement.
- **URL rejected:** check [Video services](video-services.md); unsupported URLs require `mediaplayer_allow_webpages 1`, which should be enabled cautiously.
- **Spatial audio is silent:** check the server hear radius, client 3D-audio setting, proximity distances, and whether the listener is within range.

### Verify Garry's Mod game files

If Garry's Mod or the addon behaves unexpectedly, files may be missing or corrupted. Verify the game's installation through Steam:

1. Open **Steam** and go to your **Library**.
2. Right-click **Garry's Mod** and select **Properties**.
3. Open **Installed Files**.
4. Select **Verify integrity of game files**.
5. Wait for Steam to finish. Steam will check the installation and reacquire files that are missing or damaged.
6. Once the process is complete, launch Garry's Mod again and test the issue.

See [Steam Support: Verify Integrity of Game Files](https://help.steampowered.com/faqs/view/0C48-FCBD-DA71-93EB) for the official instructions.

> [!NOTE]
> Verifying the game files can restore files modified by third-party patching tools. If you use GModPatchTool, you may need to run it again afterward.

### Garry's Mod crashes or the main menu does not load after an update

A Garry's Mod update can occasionally change files that GModPatchTool patches. The existing patch may then need to be regenerated. If the game starts crashing, fails to launch, or gets stuck before the main menu after a GMod update:

1. Download or open the **latest release** of [GModPatchTool](https://github.com/solsticegamestudios/GModPatchTool).
2. Run the tool again, even if it reports that it is already up to date.
3. Check the tool's output and make sure it reports **“applied successfully”**.
4. Start Garry's Mod and check whether the problem is resolved.
5. If the game still does not load, open **Steam → Library → Garry's Mod → Properties → General → Launch Options** and remove `-nochromium` if it is present. Then try launching the game again.

For further platform-specific troubleshooting, see the [GModPatchTool FAQ](https://solsticegamestudios.com/fixmedia/faq/).

> [!WARNING]
> GModPatchTool and GMod CEF Codec Fix are related but distinct tool names/releases. Follow the instructions for the tool you actually installed; do not assume that running one automatically installs or updates the other.

---

## Related

- [Usage](usage.md)
- [Configuration](configuration.md)
- [Video services](video-services.md)
