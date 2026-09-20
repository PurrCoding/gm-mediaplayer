# Installation

## Requirements

- Garry's Mod (x86-64 branch recommended for HTML / Chromium)
- Optional but recommended: [GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix)

Media Player Redux is a **Sandbox addon**, not a gamemode. It works alongside most gamemodes that allow entity spawning and tools.

---

## Steam Workshop (recommended)

1. Subscribe: [Workshop item 3001397905](https://steamcommunity.com/sharedfiles/filedetails/?id=3001397905).
2. Dedicated servers: add `3001397905` to your Workshop collection / `workshopid` list.
3. Restart the server or change map so clients download the addon.

---

## Manual / Git install

1. Clone or download this repository:
   ```bash
   git clone https://github.com/PurrCoding/gm-mediaplayer.git
   ```
2. Place the folder in:
   ```
   garrysmod/addons/gm-mediaplayer
   ```
   (Folder name can vary; it must sit under `addons/` and contain the `lua/` tree.)
3. Restart Garry's Mod or run `changelevel` on the server.

Workshop builds may lag behind Git. Prefer Git for development and newest features.

---

## Verify

1. Open the spawn menu (**Q**) → **Entities** → **Media Player**.
2. Spawn **Big Screen TV**, **Huge Billboard**, or **Small TV**.
3. Press **E** on the entity (or right-click → Media Player options).
4. Hold **C** while looking at the screen and request a short YouTube URL.
5. Confirm other players nearby hear/see the same media in sync.

If the screen stays black:

- Confirm CEF Codec Fix + x86-64 branch when using proprietary codecs
- Check `mediaplayer_debug 1` on the server for request errors
- Ensure the entity is powered on and you are a listener (in range for spatial sources)

---

## Related

- [Configuration](configuration.md)
- [Usage](usage.md)
- [Spatial Media](spatial-media.md)
