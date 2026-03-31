# Parfait — Development Guidelines

## General Rules

- Always sound friendly and engaged with this project.
- Always update all documentation files - README.md, CHANGELOG.md, OVERVIEW.md, ROADMAP.md, and any other documentation and/or planning documents after completing a task.
- Use all available agents, skills, and tools autonomously as needed.
- Always refer to all instruction files at the start of new tasks.
- Use Context7 tools for up-to-date framework/API documentation.
- Check the system date/time before updating CHANGELOG.md.
- Thoroughly understand the full codebase context before making any changes. When uncertain, ask for clarification.
- Keep `OVERVIEW.md` (technical overview document), `README.md`, and `CHANGELOG.md` current. Create them if they don't exist.
- Create an Apache 2.0 `LICENSE` file if none exists.
- Always produce modern, elegant, and stylized solutions — avoid outdated or basic implementations.

**Important:** Do NOT change files unless you fully understand the project structure and intent.

**Important:** Always update all documentation files - README.md, CHANGELOG.md, OVERVIEW.md, ROADMAP.md, and any other documentation and/or planning documents after completing a task.

## Brand

- Primary: Pink `#ec4899` · Secondary: Purple `#8b5cf6`

---

## Owner / Org Branding

- **Name:** Pink Pixel
- **Website:** [pinkpixel.dev](https://pinkpixel.dev)
- **GitHub:** [github.com/pinkpixel-dev](https://github.com/pinkpixel-dev)
- **Email:** admin@pinkpixel.dev
- **Support Email:** support@pinkpixel.dev
- **Discord:** @sizzlebopz
- **Funding:** [buymeacoffee.com/pinkpixel](https://www.buymeacoffee.com/pinkpixel) · [ko-fi.com/sizzlebop](https://ko-fi.com/sizzlebop)
- **Tagline:** "Dream it, Pixel it ✨”
- **Signature:** “Made with 💖 by Pink Pixel”

---

## Code Style

- Language: Rust with GTK4/Libadwaita
- UI: programmatic construction via the `ObjectSubclass` pattern
- Module structure: flat `src/` layout
- Naming: types in `PascalCase`, functions/files in `snake_case`, app ID `dev.pinkpixel.Parfait`
- Formatting: `cargo fmt` and `cargo clippy`

## Architecture

```text
main.rs         -> App bootstrap, actions, shortcuts, About dialog
window.rs       -> ParfaitWindow and the main UI state
converter.rs    -> Single-file conversion engine
batch.rs        -> Background threaded batch processor
preferences.rs  -> Preferences window scaffold
preview.rs      -> Preview widget scaffold
```

## Build and Test

```bash
cargo build
cargo build --release
cargo test
cargo clippy
cargo fmt

meson setup builddir
meson compile -C builddir
flatpak-builder --user --install --force-clean build-dir dev.pinkpixel.Parfait.yml
flatpak run dev.pinkpixel.Parfait
```

## Packaging Notes

- Vendored sources: `parfait-cargo-sources.json` and `rav1e-cargo-sources.json`
- Desktop file: `data/dev.pinkpixel.Parfait.desktop.in`
- Metainfo file: `data/dev.pinkpixel.Parfait.metainfo.xml.in`
- GSettings schema: `data/dev.pinkpixel.Parfait.gschema.xml`
- Base icon: `data/icons/dev.pinkpixel.Parfait.png`

## Current Constraints

- GTK apps use the GLib main loop, so background conversion stays on `std::thread`, not Tokio
- Preferences and preview remain planned stubs
