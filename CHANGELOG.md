# Changelog

All notable changes to Parfait are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Rebranded the application as `Parfait`
- Renamed the public app ID to `dev.pinkpixel.Parfait`
- Renamed the executable and Cargo package to `parfait`
- Updated desktop, metainfo, GSettings, Meson, and Flatpak metadata for the new brand
- Rebuilt the Flatpak icon set from the new `logo.png` source at 16, 32, 48, 64, 128, 256, and 512 pixels
- Added root-level `OVERVIEW.md` and `ROADMAP.md` documents to keep project docs aligned

## [1.0.0] - 2026-02-18

### Added

- Modern GTK4 + Libadwaita interface for Linux
- Support for PNG, JPEG, WebP, AVIF, GIF, BMP, TIFF, and ICO
- Batch conversion with background threading and progress feedback
- Drag-and-drop file import
- Quality controls and output directory selection

### Fixed

- File chooser filtering for supported image formats
- Batch conversion threading issues in the GTK main-loop environment
- WebP and AVIF input support via explicit codec features

[Unreleased]: https://github.com/pinkpixel-dev/pixelconvert/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/pinkpixel-dev/pixelconvert/releases/tag/v1.0.0
