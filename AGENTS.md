# AGENTS.md

Engineering guidelines for Media Player Redux. Follow existing code and architecture first. Use these notes when the existing code leaves a decision open.

AI tools are welcome. Generated code must still fit the project, be understood by the contributor, and be checked for side effects before merge.

## Copyright and license

Licensed under the **MIT License** (`LICENSE.md`).

- Originally created by Samuel Maddock (https://github.com/samuelmaddock/gm-mediaplayer).
- Continued by PurrCoding and contributors.

**Rules:**

- Do not remove or alter copyright header comments at the top of source files.
- Do not remove or rewrite `LICENSE.md`.
- New `.lua`, `.js`, `.css`, and `.html` files must include the standard project copyright header.
- The MIT notice must be retained in all copies or substantial portions of the Software.

## Project context

Garry's Mod addon. Primarily Lua, with browser/CEF code for playback UI and media rendering.

**Boundaries:**

- **SERVER** owns media-player state, permissions, queues, persistence, and authoritative decisions.
- **CLIENT** owns playback presentation, input, and CEF/browser interaction.
- **SHARED** only for code that genuinely belongs on both realms.
- Network messages are an API; keep them small and validate on the server.
- Reuse existing media player, service, entity, tool, and UI abstractions. Do not build parallel implementations.

Media services vary: some are structured, others (direct URLs, optional webpage playback) involve less trusted content. Do not assume every URL behaves like a normal video file.

## Lua / Garry's Mod

Prefer straightforward Lua that matches surrounding code.

- Keep CLIENT, SERVER, and SHARED responsibilities clear.
- Use existing hooks, timers, entities, media-player state, and service interfaces.
- Clean up timers, hooks, entities, listeners, and temporary state when their owner goes away.
- Avoid global state unless the project already uses it intentionally.
- Keep functions focused; avoid clever abstractions that obscure GMod behavior.
- Use tabs for indentation; match nearby formatting.
- Comments explain intent, engine quirks, or non-obvious decisions — not the obvious.

### Performance

Many media players, viewers, and spatial-audio listeners can exist at once. Avoid work that scales badly.

- Be suspicious of expensive work in `Think`, frequent hooks, entity scans, and network handlers.
- Avoid repeated table/string work and unnecessary allocations in hot paths.
- Cache globals as locals only when a function is actually hot.
- Prefer event-driven state changes over polling.
- Limit network traffic to state clients actually need.
- Treat CEF rendering as real work: avoid unnecessary DOM rebuilds, timers, layout thrashing, and high-frequency Lua ↔ browser messages.
- Be conscious of media resolution and rendering cost.

Optimize measured or obviously hot code. Readability usually beats micro-optimisations.

## HTML / CSS / JavaScript / CEF

The browser side is an untrusted boundary.

- Keep HTML, CSS, and JavaScript valid, readable, and modular.
- Prefer normal DOM APIs and event handlers over large inline scripts or fragile HTML injection.
- Keep Lua ↔ CEF communication explicit: define messages, accepted data, and allowed actions.
- Treat everything from the browser as untrusted, even when it normally comes from our own UI.
- Never turn browser input into Lua code, console commands, filesystem operations, or arbitrary calls.
- Validate and constrain values crossing the CEF boundary.
- Escape or safely insert user-controlled text; avoid `innerHTML` when text/DOM APIs suffice.
- Keep browser assets and runtime work reasonably small.

Unrestricted webpage playback is intentionally more dangerous. Keep it behind the existing server-side configuration; do not make it the default.

New Lua bridges should be narrow, named actions with validated arguments — not a generic "execute this" interface.

## Security

Security decisions belong on the server.

- Never trust client-provided permissions, SteamIDs, entity ownership, queue state, or other authoritative values.
- Validate every network message: types, ranges, ownership, permissions, state.
- Privileged actions must be enforced server-side; client-side checks are only UX.
- Treat media URLs, redirects, webpage content, and service responses as untrusted input.
- Do not broaden URL/webpage allowlists without considering security impact. Keep unrestricted webpage playback opt-in and server-controlled.
- Avoid arbitrary code execution (`RunString`, `CompileString`, etc.), especially with client or CEF input.
- Do not expose server-only details or privileged functionality to the client.
- Be deliberate with filesystem and database operations; user input must never become an uncontrolled path or SQL statement.
- Rate-limit or constrain networked actions that can be spammed.
- Keep browser integrations narrow; external webpages increase attack surface.

If a change weakens a validation or permission boundary, stop and reconsider.

## Changes and verification

Understand the path through the existing media-player/service architecture before changing code. Prefer a small change in the correct layer over a workaround elsewhere.

After meaningful changes, check relevant realms and failure paths:

- multiple players watching the same screen
- invalid or unexpected client input and malformed network messages
- connect/disconnect and map cleanup
- timers, hooks, entities, listeners, and net receivers created and removed correctly
- media service failures, missing metadata, redirects, unsupported media
- CEF loading and Lua ↔ browser communication
- spatial audio when entities or listeners move or disappear

Do not add tests or abstractions only to satisfy this file. Add verification where it catches a realistic regression.

## When unsure

Prefer the existing project pattern over inventing a new one. If code relies on a Garry's Mod or Chromium/CEF quirk, verify against current documentation or known engine issues.

Priority order when goals conflict:

1. Correctness and player/server safety
2. Security and authority boundaries
3. Stability and compatibility
4. Maintainability and readability
5. Performance
6. Convenience
