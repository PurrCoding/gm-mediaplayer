# AGENTS.md

## What this file is for

This is a small set of engineering guidelines for the project, not a rigid style policy. Follow the existing code and architecture first, and use these notes when making changes or when the existing code leaves a decision open.

AI tools are welcome. Generated code still needs to fit the project, be understood by the contributor, and be checked for side effects before it is merged.

## Project context

Media Player Redux is a Garry's Mod addon. It is primarily Lua, with browser/CEF code for the playback UI and media rendering.

The important boundaries are:

- **SERVER** owns media-player state, permissions, queues, persistence, and other authoritative decisions.
- **CLIENT** owns playback presentation, input, and CEF/browser interaction.
- **SHARED** is only for code that genuinely belongs on both realms.
- Network messages are an API between client and server; keep them small and validate them on the server.
- Reuse the existing media player, service, entity, tool, and UI abstractions instead of building parallel implementations.

Media services are intentionally varied: some provide structured playback, while direct URLs and optional webpage playback involve less trusted external content. Do not assume every URL behaves like a normal video file.

## Lua / Garry's Mod

Prefer straightforward Lua that matches the surrounding code.

- Keep CLIENT, SERVER, and SHARED responsibilities clear.
- Use the existing hooks, timers, entities, media-player state, and service interfaces where possible.
- Clean up timers, hooks, entities, listeners, and other temporary state when their owner goes away.
- Avoid global state unless the project already uses it intentionally.
- Keep functions focused and avoid clever abstractions that make GMod behavior harder to follow.
- Use tabs for indentation and keep formatting consistent with nearby files.
- Comments should explain intent, engine quirks, or non-obvious decisions rather than restating the code.

### Performance

This addon can have many media players, viewers, and spatial-audio listeners at the same time. Avoid work that scales badly with players, entities, or playback frequency.

- Be suspicious of expensive work in `Think`, frequent hooks, entity scans, and network handlers.
- Avoid repeated table/string work and unnecessary allocations in hot paths.
- Cache globals as locals when a function is actually hot; do not add blanket micro-optimisations.
- Prefer event-driven state changes over polling when practical.
- Keep network traffic limited to state that clients actually need.
- Treat CEF rendering as real runtime work: avoid unnecessary DOM rebuilds, timers, layout work, and high-frequency Lua ↔ browser messages.
- Be conscious of media resolution and rendering cost when changing playback/UI behavior.

Optimize measured or obviously hot code. Readability is normally more valuable than tiny micro-optimisations.

## HTML / CSS / JavaScript / CEF

The browser side is part of the addon and must be treated as an untrusted boundary.

- Keep HTML, CSS, and JavaScript valid, readable, and modular.
- Prefer normal DOM APIs and event handlers over large inline scripts or fragile HTML injection.
- Keep Lua ↔ CEF communication explicit: define what messages exist, what data they accept, and what they are allowed to do.
- Treat anything coming from the browser as untrusted, even if it normally comes from our own UI.
- Never turn browser input directly into Lua code, console commands, filesystem operations, or arbitrary event/function calls.
- Validate and constrain values crossing the CEF boundary.
- Escape or safely insert user-controlled text; do not use `innerHTML` or equivalent injection paths when text/DOM APIs are sufficient.
- Keep browser assets and runtime work reasonably small.

The addon supports an optional mode for unrestricted webpages. That feature is intentionally more dangerous than normal media playback; keep it behind its existing server-side configuration and do not silently make arbitrary webpages the default.

When a browser feature needs a new Lua bridge, prefer a narrow, named action with validated arguments over a generic "execute this" interface.

## Security

Security decisions belong primarily on the server.

- Never trust client-provided permissions, SteamIDs, entity ownership, queue state, or other authoritative values.
- Validate every network message before using its contents. Check types, ranges, ownership, permissions, and state where relevant.
- Privileged actions must be enforced server-side; client-side checks are only UX.
- Treat media URLs, redirects, webpage content, and service responses as untrusted input.
- Do not broaden an existing URL/webpage allowlist without considering the security impact. In particular, keep unrestricted webpage playback opt-in and server-controlled.
- Avoid arbitrary code execution such as `RunString`, `CompileString`, or equivalent dynamic execution, especially when input can originate from clients or CEF.
- Do not expose server-only implementation details or privileged functionality to the client.
- Be deliberate with filesystem and database operations; user input should never become an uncontrolled path or SQL statement.
- Rate-limit or otherwise constrain networked actions that can be spammed.
- Keep browser integrations narrow, because external webpages increase the attack surface significantly.

If a change weakens a validation or permission boundary, stop and reconsider the design instead of treating the check as boilerplate.

## Changes and verification

Before changing code, understand the path through the existing media-player/service architecture. Prefer a small change in the correct layer over a workaround elsewhere.

After a meaningful change, check the relevant realms and failure paths:

- multiple players watching the same screen;
- invalid or unexpected client input and malformed network messages;
- connect/disconnect and map cleanup;
- timers, hooks, entities, listeners, and net receivers being created and removed correctly;
- media service failures, missing metadata, redirects, and unsupported media;
- CEF loading and Lua ↔ browser communication where applicable;
- spatial audio behavior when entities or listeners move or disappear.

Do not add tests or abstractions only to satisfy this file. Add verification where it catches a realistic regression.

## When unsure

Prefer the existing project pattern over inventing a new one. If the code relies on a Garry's Mod or Chromium/CEF quirk, verify the behavior against current documentation or known engine issues before building a new dependency on it.

For conflicting goals, use this order as a practical guide:

1. Correctness and player/server safety
2. Security and authority boundaries
3. Stability and compatibility
4. Maintainability and readability
5. Performance
6. Convenience
