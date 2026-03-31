# Parfait Overview

Parfait is a Rust desktop image converter built with GTK4 and Libadwaita. It converts common raster image formats, supports batch jobs, and is being prepared for distribution as a Flatpak under the app ID `dev.pinkpixel.Parfait`.

## Architecture

- `src/main.rs`: GTK application bootstrap, actions, shortcuts, and About dialog
- `src/window.rs`: primary `ParfaitWindow` implementation and UI orchestration
- `src/converter.rs`: format conversion engine
- `src/batch.rs`: threaded batch runner and progress messaging
- `src/preferences.rs`: preferences window scaffold
- `src/preview.rs`: preview widget scaffold

## Packaging

- Cargo package name: `parfait`
- Meson project name: `parfait`
- Flatpak manifest: `dev.pinkpixel.Parfait.yml`
- GSettings schema: `dev.pinkpixel.Parfait`
- Desktop file: `dev.pinkpixel.Parfait.desktop`
- Icon assets: generated from `logo.png` into the hicolor sizes required for Flathub

## Repository Notes

- The working directory and GitHub repository path may still use `pixelconvert`
- Support and issue links currently still point at `pinkpixel-dev/pixelconvert`
- The user-facing product name, installed binary, and packaging metadata are now `Parfait`
