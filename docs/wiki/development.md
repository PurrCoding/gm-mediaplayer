# Development

## Stack

- **Lua** (Garry's Mod addon)
- **JavaScript / HTML** for browser-based services (`public/` and in-panel scripts)
- Shared patterns with the original Media Player; Redux adds services, spatial audio, i18n, and maintenance fixes

Authoritative contribution rules: **[AGENTS.md](../../AGENTS.md)**.

---

## Layout

```
lua/mediaplayer/
  players/          MediaPlayer type implementations
  services/         Media providers (one folder per service)
  controls/         VGUI / DHTML
  i18n/             Translations
  config/           Client config
  sh_*.lua          Shared systems (cvars, history, cami, events)
lua/entities/       World entities
lua/weapons/.../stools/  Spatial tool
public/             Static HTML used by browser services
```

Load order matters: **base** player and **base** service must register before dependents (`sh_mediaplayer.lua` / `sh_services.lua`).

---

## Conventions

- Prefer extending `MediaPlayer.Register` / `MediaPlayer.RegisterService` over monkey-patching
- Keep CLIENT / SERVER files split (`cl_init.lua`, `init.lua`, `shared.lua`) as in existing services
- Validate URLs and privilege before mutating queue state
- Use `MediaPlayer.DEBUG` / `mediaplayer_debug` for diagnostic logs
- Do not enable webpage fallback by default in examples aimed at public servers

---

## Testing checklist

1. Spawn each TV model; request YouTube + one non-YouTube service
2. Second client joins mid-playback — confirm sync
3. Spatial tool on a prop — range enter/leave listener behaviour
4. Queue lock, skip, seek with and without admin privileges
5. `mediaplayer_allow_webpages 0/1` behaviour
6. Dupe a powered TV in Sandbox

---

## Related

- [Architecture](architecture.md)
- [Custom video service](custom-video-service.md)
- [Translations](translations.md)
