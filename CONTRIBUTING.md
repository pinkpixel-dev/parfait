# Contributing to Parfait

Thanks for helping improve Parfait. This guide covers the current development workflow, coding expectations, and Flatpak packaging details for the rebranded app.

## Project Basics

- Product name: `Parfait`
- Cargo package: `parfait`
- Flatpak app ID: `dev.pinkpixel.Parfait`
- Current repository URL: `https://github.com/pinkpixel-dev/parfait`

## Local Setup

```bash
git clone https://github.com/YOUR_USERNAME/parfait.git
cd parfait
```

Install the platform dependencies your distro needs, then use the standard Rust + Meson flow:

```bash
cargo build
cargo run
cargo test
cargo fmt
cargo clippy
```

### Meson / Flatpak

```bash
meson setup builddir
meson compile -C builddir

flatpak-builder --user --install --force-clean build-dir dev.pinkpixel.Parfait.yml
flatpak run dev.pinkpixel.Parfait
```

The current manifest is pinned to the remote `v1.0.0` git tag so local Flatpak
tests match the tagged release snapshot on GitHub. You do not need a published
GitHub Release page for `flatpak-builder`; the pushed git tag is the important
part.

## Coding Guidelines

- Follow the existing Rust style and keep `cargo fmt` clean.
- Run `cargo clippy` and address warnings when your change touches code.
- Preserve GTK4/Libadwaita conventions already used in `src/window.rs`.
- Prefer focused changes and update documentation with every user-facing change.

## Documentation Checklist

When you change functionality or packaging, update:

- `README.md`
- `CHANGELOG.md`
- `OVERVIEW.md`
- `ROADMAP.md`
- `dev/OVERVIEW.md`
- `dev/ROADMAP.md`
- `dev/FLATHUB-SUBMISSION-GUIDE.md`
- relevant files in `dev/`

## Project Structure

```text
parfait/
├── src/
│   ├── main.rs
│   ├── window.rs
│   ├── converter.rs
│   ├── batch.rs
│   ├── preferences.rs
│   └── preview.rs
├── data/
│   ├── icons/
│   ├── dev.pinkpixel.Parfait.desktop.in
│   ├── dev.pinkpixel.Parfait.metainfo.xml.in
│   └── dev.pinkpixel.Parfait.gschema.xml
├── dev.pinkpixel.Parfait.yml
├── parfait-cargo-sources.json
├── rav1e-cargo-sources.json
└── meson.build
```

## Pull Requests

1. Create a branch from `main`.
2. Make the smallest change set that solves the problem.
3. Run the relevant validation commands.
4. Update docs and packaging metadata when needed.
5. Submit a PR with a clear description and screenshots for UI changes.

## Manual QA

Before opening a PR, verify:

- The app launches as `Parfait`
- Drag-and-drop still works
- All format options convert successfully
- The output directory chooser behaves correctly
- About dialog and desktop metadata show the new brand
- The launcher and software-center icon use the transparent circular artwork without the old square background
- Flatpak metadata still validates after any packaging edit

Thanks for contributing to Parfait and helping Pink Pixel get it ready for Flathub.
