# Installation

## Requirements

- Garry's Mod. The **x86-64 branch is recommended** for HTML/Chromium playback.
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

- **No Media Player category:** confirm the addon is mounted and check the server/client console for Lua errors.
- **Black screen or codec error:** try the x86-64 branch and GMod CEF Codec Fix; the provider may use a codec unsupported by the installed CEF build.
- **SoundCloud does not load:** check the embedded browser version and the GModPatchTool requirement.
- **URL rejected:** check [Video services](video-services.md); unsupported URLs require `mediaplayer_allow_webpages 1`, which should be enabled cautiously.
- **Spatial audio is silent:** check the server hear radius, client 3D-audio setting, proximity distances, and whether the listener is within range.

## Related

- [Usage](usage.md)
- [Configuration](configuration.md)
- [Video services](video-services.md)
