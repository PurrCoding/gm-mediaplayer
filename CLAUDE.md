# CLAUDE.md

Project instructions for Claude Code and other AI coding agents.

@AGENTS.md

## Copyright and license (must keep)

This project is licensed under the **MIT License** (`LICENSE.md`).

- Originally created by Samuel Maddock (https://github.com/samuelmaddock/gm-mediaplayer).
- Continued by PurrCoding and contributors.

**Rules for every change:**

- Never remove or rewrite the copyright header comments at the top of source files.
- Never delete or empty `LICENSE.md`.
- When creating new `.lua`, `.js`, `.css`, or `.html` files, add the standard project copyright header (see existing files).
- The MIT copyright notice and permission notice must remain in all copies or substantial portions of the Software.

## Quick project map

- `lua/mediaplayer/` — core logic (players, services, networking, config)
- `lua/entities/` — screen and spatial-anchor entities
- `lua/mp_menu/` — client UI sidebar
- `lua/weapons/gmod_tool/stools/` — tools
- `public/` — HTML/JS/CSS used by CEF browser panels
- `docs/` — human documentation

## Key constraints

- **SERVER** is authoritative (queues, permissions, state).
- **CLIENT** handles presentation and CEF.
- Validate all network input on the server.
- Treat browser/CEF data as untrusted.
- Prefer small changes that fit the existing architecture.
